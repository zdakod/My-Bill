from pydantic import AnyUrl, BaseModel
from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    # Core public access settings
    PUBLIC_SCHEME: str = "https"
    PUBLIC_DOMAIN: str = "api.localhost"
    PUBLIC_PORT: int = 8443

    # Keycloak / OIDC
    OIDC_ISSUER_URI: AnyUrl
    OIDC_CLIENT_ID: str
    OIDC_AUDIENCE: str

    # Auth override
    AUTH_DISABLED: bool = False

    @property
    def public_url(self) -> str:
        port = f":{self.PUBLIC_PORT}" if self.PUBLIC_PORT not in [80, 443] else ""
        return f"{self.PUBLIC_SCHEME}://{self.PUBLIC_DOMAIN}{port}"

    class Config:
        env_file = ".env"
        case_sensitive = True


@lru_cache()
def get_settings():
    return Settings()
