import os
import re
import time
from datetime import date
from typing import Dict, List, Optional

import requests
from fastapi import FastAPI, Depends, HTTPException, Query, Header
from fastapi.security import (
    HTTPBearer,
    HTTPAuthorizationCredentials,
    HTTPBasic,
    HTTPBasicCredentials,
)
from jose import jwt, jwk
from jose.utils import base64url_decode
from pydantic import BaseModel
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker, Session

AUTH_DISABLED = os.getenv("AUTH_DISABLED", "false").lower() == "true"

# -----------------------------
# DB CONFIG
# -----------------------------

DB_USER = os.getenv("DB_USER") or os.getenv("MYSQL_APP_USER")
DB_PASS = os.getenv("DB_PASSWORD") or os.getenv("MYSQL_APP_PASSWORD")
DB_NAME = os.getenv("DB_NAME") or os.getenv("MYSQL_APP_DB")
DB_HOST = os.getenv("DB_HOST", "mysql")
DB_PORT = os.getenv("DB_PORT", "3306")

DATABASE_URL = f"mysql+mysqldb://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

engine = create_engine(DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db() -> Session:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# -----------------------------
# OIDC / Keycloak CONFIG
# -----------------------------

PUBLIC_SCHEME = os.getenv("PUBLIC_SCHEME", "https")
PUBLIC_PORT = os.getenv("PUBLIC_PORT", "8443")
AUTH_DOMAIN = os.getenv("AUTH_DOMAIN", "auth.localhost")

OIDC_ISSUER = os.getenv(
    "OIDC_ISSUER_URI",
    f"{PUBLIC_SCHEME}://{AUTH_DOMAIN}:{PUBLIC_PORT}/realms/master",
)
OIDC_AUDIENCE = os.getenv("OIDC_AUDIENCE", "api-service")
OIDC_JWKS_URL = os.getenv(
    "OIDC_JWKS_URL",
    "http://keycloak:8080/realms/master/protocol/openid-connect/certs",
)
OIDC_CLIENT_ID = os.getenv("OIDC_CLIENT_ID", "api-service")

auth_scheme = HTTPBearer(auto_error=False)

# JWKS key cache
JWKS_KEYS: List[dict] = []


def refresh_jwks() -> None:
    """Load JWKS keys from Keycloak into JWKS_KEYS."""
    global JWKS_KEYS
    try:
        resp = requests.get(OIDC_JWKS_URL, timeout=5)
        resp.raise_for_status()
        data = resp.json()
        JWKS_KEYS = data.get("keys", [])
        if not JWKS_KEYS:
            print(f"WARNING: JWKS from {OIDC_JWKS_URL} contained no keys")
    except Exception as e:
        print(f"WARNING: could not load JWKS from {OIDC_JWKS_URL}: {e}")
        JWKS_KEYS = []

# load once at startup
refresh_jwks()

# -----------------------------
# Pydantic MODELS
# -----------------------------

class CustomerInfo(BaseModel):
    id: int
    customer_number: int
    name: str


class MonthlyUsage(BaseModel):
    data_gb: float
    voice_minutes: int
    sms_count: int
    roaming_minutes: int


class MonthlyCategories(BaseModel):
    subscription: float
    extra_data: float
    roaming: float
    device_payment: float
    taxes_fees: float
    other: float


class MonthlyBillSummary(BaseModel):
    invoice_id: int
    invoice_number: int
    month: str           # "YYYY-MM"
    bill_to_date: date
    currency: str

    amount_total: float
    amount_by_category: MonthlyCategories
    usage: MonthlyUsage


class BillingMonthsResponse(BaseModel):
    customer: CustomerInfo
    months: List[MonthlyBillSummary]


class BillLineItem(BaseModel):
    category: str
    charge_type: Optional[str]
    jurisdiction: Optional[str]
    description: Optional[str]
    charge_from_date: Optional[date]
    charge_to_date: Optional[date]
    display_units: Optional[str]
    call_counter: Optional[int]
    amount_chf: float


class BillDetail(BaseModel):
    invoice: MonthlyBillSummary
    line_items: List[BillLineItem]


# -----------------------------
# HELPER FUNCTIONS
# -----------------------------

def parse_data_gb(display_units: Optional[str]) -> float:
    """
    Parse strings like '27850 MB', '30.2 GB' into GB.
    Returns 0.0 if it can't parse.
    """
    if not display_units:
        return 0.0
    s = display_units.strip().lower()
    m = re.match(r"([0-9]+(\.[0-9]+)?)\s*(mb|gb)", s)
    if not m:
        return 0.0
    value = float(m.group(1))
    unit = m.group(3)
    if unit == "mb":
        return value / 1024.0
    return value


def classify_category(charge_type: Optional[str], jurisdiction: Optional[str]) -> str:
    """
    Map raw charge type + jurisdiction to one of our frontend categories.
    This is heuristic based on the dump and can be tuned.
    """
    ct = (charge_type or "").lower()
    jur = (jurisdiction or "").lower()

    # subscription / recurring fees
    if "recurring" in ct or "subscription" in ct:
        return "subscription"

    # device payments / installments
    if "installment" in ct or "device" in ct:
        return "device_payment"

    # roaming
    if "roaming" in ct or "roaming" in jur:
        return "roaming"

    # mobile data / extra data
    if "mobile internet" in jur or "data" in ct:
        return "extra_data"

    # taxes / fees
    if "tax" in ct or "fee" in ct:
        return "taxes_fees"

    return "other"


def get_customer_info(db: Session, customer_id: int) -> CustomerInfo:
    row = db.execute(
        text(
            "SELECT id, customer_number, name "
            "FROM customers WHERE id = :cid"
        ),
        {"cid": customer_id},
    ).fetchone()
    if not row:
        raise HTTPException(status_code=404, detail="Customer not found")
    return CustomerInfo(
        id=row.id,
        customer_number=row.customer_number,
        name=row.name,
    )


def load_monthly_summaries(db: Session, customer_id: int, months: int) -> BillingMonthsResponse:
    # 1) get invoices for this customer, newest first
    inv_rows = db.execute(
        text(
            "SELECT id, invoice_number, bill_to_date, currency "
            "FROM invoices "
            "WHERE customer_id = :cid "
            "ORDER BY bill_to_date DESC "
            "LIMIT :lim"
        ),
        {"cid": customer_id, "lim": months},
    ).fetchall()

    customer = get_customer_info(db, customer_id)
    summaries: List[MonthlyBillSummary] = []

    for inv in inv_rows:
        invoice_id = inv.id

        # 2) load all charges for this invoice
        ch_rows = db.execute(
            text(
                "SELECT c.charged_amount, c.discount, c.display_units, "
                "       c.call_counter, "
                "       ct.name AS charge_type, "
                "       j.name  AS jurisdiction, "
                "       c.charge_from_date, c.charge_to_date, c.description "
                "FROM charges c "
                "LEFT JOIN charge_types ct ON ct.id = c.charge_type_id "
                "LEFT JOIN jurisdictions j ON j.id = c.jurisdiction_id "
                "WHERE c.invoice_id = :iid"
            ),
            {"iid": invoice_id},
        ).fetchall()

        # 3) aggregate per category + usage
        cat_totals: Dict[str, float] = {
            "subscription": 0.0,
            "extra_data": 0.0,
            "roaming": 0.0,
            "device_payment": 0.0,
            "taxes_fees": 0.0,
            "other": 0.0,
        }
        total_amount = 0.0
        data_gb = 0.0
        voice_minutes = 0
        sms_count = 0
        roaming_minutes = 0

        for ch in ch_rows:
            amount = float(ch.charged_amount or 0)
            if ch.discount is not None:
                amount -= float(ch.discount or 0)

            total_amount += amount

            category = classify_category(ch.charge_type, ch.jurisdiction)
            cat_totals[category] += amount

            # usage aggregation
            if ch.jurisdiction and "mobile internet" in ch.jurisdiction.lower():
                data_gb += parse_data_gb(ch.display_units)
            if ch.call_counter:
                # crude logic: treat any call_counter as voice minutes
                voice_minutes += ch.call_counter
                if category == "roaming":
                    roaming_minutes += ch.call_counter

            # SMS heuristic – if jurisdiction mentions SMS
            if ch.jurisdiction and "sms" in ch.jurisdiction.lower():
                if ch.call_counter:
                    sms_count += ch.call_counter

        month_str = inv.bill_to_date.strftime("%Y-%m")

        summary = MonthlyBillSummary(
            invoice_id=invoice_id,
            invoice_number=inv.invoice_number,
            month=month_str,
            bill_to_date=inv.bill_to_date,
            currency=inv.currency or "CHF",
            amount_total=round(total_amount, 2),
            amount_by_category=MonthlyCategories(**{k: round(v, 2) for k, v in cat_totals.items()}),
            usage=MonthlyUsage(
                data_gb=round(data_gb, 2),
                voice_minutes=voice_minutes,
                sms_count=sms_count,
                roaming_minutes=roaming_minutes,
            ),
        )
        summaries.append(summary)

    return BillingMonthsResponse(customer=customer, months=summaries)


def load_bill_detail(db: Session, customer_id: int, invoice_id: int) -> BillDetail:
    # ensure invoice belongs to this customer
    inv_row = db.execute(
        text(
            "SELECT i.id, i.invoice_number, i.bill_to_date, i.currency "
            "FROM invoices i "
            "WHERE i.id = :iid AND i.customer_id = :cid"
        ),
        {"iid": invoice_id, "cid": customer_id},
    ).fetchone()
    if not inv_row:
        raise HTTPException(status_code=404, detail="Invoice not found for customer")

    # reuse summary calculation for this invoice only
    months_resp = load_monthly_summaries(db, customer_id, months=1000)
    summary = next((m for m in months_resp.months if m.invoice_id == invoice_id), None)
    if not summary:
        raise HTTPException(status_code=500, detail="Summary not found for invoice")

    # line items
    ch_rows = db.execute(
        text(
            "SELECT c.charged_amount, c.discount, c.display_units, "
            "       c.call_counter, "
            "       ct.name AS charge_type, "
            "       j.name  AS jurisdiction, "
            "       c.charge_from_date, c.charge_to_date, c.description "
            "FROM charges c "
            "LEFT JOIN charge_types ct ON ct.id = c.charge_type_id "
            "LEFT JOIN jurisdictions j ON j.id = c.jurisdiction_id "
            "WHERE c.invoice_id = :iid"
        ),
        {"iid": invoice_id},
    ).fetchall()

    items: List[BillLineItem] = []
    for ch in ch_rows:
        amount = float(ch.charged_amount or 0)
        if ch.discount is not None:
            amount -= float(ch.discount or 0)

        category = classify_category(ch.charge_type, ch.jurisdiction)

        item = BillLineItem(
            category=category,
            charge_type=ch.charge_type,
            jurisdiction=ch.jurisdiction,
            description=ch.description,
            charge_from_date=ch.charge_from_date,
            charge_to_date=ch.charge_to_date,
            display_units=ch.display_units,
            call_counter=ch.call_counter,
            amount_chf=round(amount, 2),
        )
        items.append(item)

    return BillDetail(invoice=summary, line_items=items)

def _get_key_for_token(token: str) -> dict:
    # If cache is empty, try once to refresh it
    if not JWKS_KEYS:
        refresh_jwks()
        if not JWKS_KEYS:
            raise HTTPException(status_code=500, detail="JWKS not loaded")

    try:
        headers = jwt.get_unverified_header(token)
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token header")

    kid = headers.get("kid")
    for key in JWKS_KEYS:
        if key.get("kid") == kid:
            return key

    raise HTTPException(status_code=401, detail="No matching JWK for token")

def decode_and_validate_token(token: str) -> dict:
    """Core JWT validation: signature, exp, iss, aud."""
    key_dict = _get_key_for_token(token)
    public_key = jwk.construct(key_dict)

    # Verify signature
    try:
        message, encoded_sig = str(token).rsplit(".", 1)
        decoded_sig = base64url_decode(encoded_sig.encode("utf-8"))
        if not public_key.verify(message.encode("utf-8"), decoded_sig):
            raise HTTPException(status_code=401, detail="Invalid token signature")
    except HTTPException:
        raise
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token")

    # Decode claims
    try:
        claims = jwt.get_unverified_claims(token)
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token claims")

    # Validate exp
    exp = claims.get("exp")
    if exp is not None and time.time() > exp:
        raise HTTPException(status_code=401, detail="Token has expired")

    # Validate issuer
    iss = claims.get("iss")
    if iss != OIDC_ISSUER:
        raise HTTPException(
            status_code=401,
            detail=f"Invalid issuer: {iss}, expected {OIDC_ISSUER}",
        )

    # Validate audience / client
    aud = claims.get("aud")
    azp = claims.get("azp")  # authorized party (usually client_id)

    aud_ok = False

    # 1) Check the explicit audience if set
    if OIDC_AUDIENCE:
        if isinstance(aud, str) and aud == OIDC_AUDIENCE:
            aud_ok = True
        elif isinstance(aud, list) and OIDC_AUDIENCE in aud:
            aud_ok = True
        # 2) Also accept azp == expected audience (for client_credentials)
        elif azp == OIDC_AUDIENCE:
            aud_ok = True
    else:
        # 3) If no audience configured, accept azp == client_id
        if azp == OIDC_CLIENT_ID:
            aud_ok = True

    if not aud_ok:
        raise HTTPException(status_code=401, detail="Invalid audience")

    return claims

def get_claims(
    credentials: HTTPAuthorizationCredentials = Depends(auth_scheme),
) -> dict:
    """
    Central auth dependency.

    - If AUTH_DISABLED=true: ignore Authorization header and return fixed demo claims.
    - If AUTH_DISABLED=false: require a Bearer token and validate it.
    """
    if AUTH_DISABLED:
        # Open dev mode – no auth enforced
        return {"sub": "demo-user", "customer_id": 1}

    if credentials is None:
        raise HTTPException(status_code=401, detail="Missing Authorization header")

    token = credentials.credentials
    return decode_and_validate_token(token)


def get_customer_id(claims: dict = Depends(get_claims)) -> int:
    """
    Return customer_id to use for /api/me/* endpoints.
    """
    if AUTH_DISABLED:
        return 1  # always customer 1 in dev mode

    cid = claims.get("customer_id")
    if cid is None:
        raise HTTPException(status_code=401, detail="Missing customer_id in token")
    return cid

# -----------------------------
# AUTH PLACEHOLDER
# -----------------------------

def get_token(credentials: HTTPAuthorizationCredentials = Depends(auth_scheme)) -> str:
    """
    Extract the raw Bearer token from the Authorization header.
    """
    if credentials is None:
        raise HTTPException(status_code=401, detail="Missing Authorization header")
    return credentials.credentials

def get_auth_claims(token: str = Depends(get_token)) -> dict:
    """
    Return JWT claims.

    - If AUTH_DISABLED=true: return a fixed demo payload.
    - If AUTH_DISABLED=false: fully validate the JWT via JWKS.
    """
    if AUTH_DISABLED:
        # Open dev mode: pretend we're a single demo user
        return {"sub": "demo-user", "customer_id": 1}

    return decode_and_validate_token(token)

#def require_customer_dep(claims: dict = Depends(get_auth_claims)) -> int:
#    """
#    Return customer_id for /api/me/*.
#
#    - If AUTH_DISABLED=true: always 1 (demo data).
#    - If AUTH_DISABLED=false: require customer_id in the token claims.
#    """
#    if AUTH_DISABLED:
#        return 1
#
#    cid = claims.get("customer_id")
#    if cid is None:
#        raise HTTPException(status_code=401, detail="Missing customer_id in token")
#    return cid

# -----------------------------
# FASTAPI APP + ROUTES
# -----------------------------

app = FastAPI(title="MyBills API")

@app.get("/api/health")
def health():
    return {"status": "ok"}


@app.get("/api/customers/{customer_id}/billing/months", response_model=BillingMonthsResponse)
def get_billing_months(
    customer_id: int,
    months: int = Query(24, ge=1, le=60),
    db: Session = Depends(get_db),
    claims: dict = Depends(get_claims),  # enforces or bypasses auth based on AUTH_DISABLED
):
    return load_monthly_summaries(db, customer_id, months)


@app.get("/api/customers/{customer_id}/billing/{invoice_id}", response_model=BillDetail)
def get_billing_detail(
    customer_id: int,
    invoice_id: int,
    db: Session = Depends(get_db),
    claims: dict = Depends(get_claims),  # same here
):
    return load_bill_detail(db, customer_id, invoice_id)


@app.get("/api/me/billing/months", response_model=BillingMonthsResponse)
def get_my_billing_months(
    months: int = Query(24, ge=1, le=60),
    db: Session = Depends(get_db),
    customer_id: int = Depends(get_customer_id),
):
    return load_monthly_summaries(db, customer_id, months)


@app.get("/api/me/billing/{invoice_id}", response_model=BillDetail)
def get_my_billing_detail(
    invoice_id: int,
    db: Session = Depends(get_db),
    customer_id: int = Depends(get_customer_id),
):
    return load_bill_detail(db, customer_id, invoice_id)
