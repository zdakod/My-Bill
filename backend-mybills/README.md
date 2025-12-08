# MyBills Backend Stack

This project is a containerized backend infrastructure for a telecom-style billing dashboard, built for flexibility, security, and extensibility. It includes an API service, secure authentication using Keycloak, a MySQL database, and Traefik for routing.

---

## Stack Overview

| Component | Description |
|----------|-------------|
| **FastAPI** | Python API backend providing billing endpoints |
| **Keycloak** | OpenID Connect-based authentication/authorization |
| **MySQL** | Primary relational database for billing data |
| **Traefik** | Reverse proxy and HTTPS gateway |
| **HAProxy** | Optional TCP load balancing for MySQL clusters |
| **Podman Compose** | Used instead of Docker to orchestrate services |

---

## Getting Started

### 1. Clone and Set Environment
```bash
cp .env.example .env
```

### 2. Edit Environment
```bash
vim .env
```

### 3. Start Services
```bash
podman-compose -f podman-compose.yml up --build
```

> Ensure `podman` and `podman-compose` are installed.

---

## Authentication

- Auth is managed via **Keycloak** (`auth.localhost`)
- JWT is validated using JWKS
- You can toggle auth with `.env`:

```env
AUTH_DISABLED=true  # for local dev / testing
```

---

### Keycloak Realm Configuration

| Setting     | Value         |
|-------------|---------------|
| Realm       | `mybills`     |
| Client ID   | `api-service` |
| Role        | `billing_read` |

The realm and client are imported via the provided file:
```
keycloak/import/my_bills-realm.json
```

---

### Obtaining a JWT Token (Client Credentials Flow)

Use a `POST` request to fetch a JWT token for authenticated access:

```http
POST https://auth.localhost:8443/realms/mybills/protocol/openid-connect/token
```

#### Required Body Form Parameters (x-www-form-urlencoded):

| Parameter       | Example Value         | Description                          |
|-----------------|------------------------|--------------------------------------|
| `grant_type`    | `client_credentials`   | Backend-to-backend flow              |
| `client_id`     | `api-service`          | Matches your Keycloak client ID      |
| `client_secret` | *(from Keycloak)*      | Secret from the client credentials   |

#### Example using `curl`:

```bash
curl -X POST https://auth.localhost:8443/realms/mybills/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=api-service" \
  -d "client_secret=<SECRET>"
```

> Replace the `client_secret` with the actual value from your Keycloak client.

---

### Using the Access Token

Once obtained, pass the token in your requests like this:

```http
Authorization: Bearer <ACCESS TOKEN>
```

#### Example API Call:

```bash
curl -H "Authorization: Bearer <ACCESS TOKEN>" https://api.localhost:8443/api/me/billing/months
```

If `AUTH_DISABLED=true`, the backend will simulate a default customer session using `customer_id=1`.

---

## API Overview

> All endpoints start with `/api`

### Health Check
```http
GET /api/health
```

### Customer Billing (Admin)
```http
GET /api/customers/{customer_id}/billing/months
GET /api/customers/{customer_id}/billing/{invoice_id}
```

### Authenticated Billing (Me)
```http
GET /api/me/billing/months
GET /api/me/billing/{invoice_id}
```

---

## Database Schema

**Core Tables:**
- `customers`
- `invoices`
- `charges`
- `charge_types`
- `jurisdictions`

Supports both summary and detailed billing queries.

---

## Development

### Build API Locally
```bash
cd api
podman build -t local/api-service:1.0 .
```

### Installed Python Packages
- `fastapi`, `uvicorn`, `SQLAlchemy`, `mysqlclient`
- `python-jose`, `requests`, `passlib`

---

## Routing

### Traefik
- Routes `/api` to API service
- Routes `/realms`, `/admin` to Keycloak
- Automatic HTTPS via Let's Encrypt (or internal certs)

### HAProxy (Optional)
- TCP load balancer for MySQL (if cluster enabled)

---

## Testing

Sample users and realm config can be modified under:
```
keycloak/import/my_bills-realm.json
```

---

## Main Backend Author

**Kevin Vo**  
kevin.vo@sunrise.net  
+41 76 777 54 29

---
