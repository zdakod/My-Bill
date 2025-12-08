# MyBills – Fullstack Billing Dashboard

MyBills is a fullstack billing dashboard project designed to handle customer usage and invoicing data in a secure and scalable way. The system is composed of a Python backend microservice stack and a NextJS frontend application.

---

## Project Structure

```
.
├── LICENSE
├── backend-mybills
│   ├── README.md               # Backend documentation (FastAPI, Keycloak, DB)
│   ├── api/                    # FastAPI application with billing APIs
│   ├── certs/                  # Internal TLS certificates
│   ├── db-init/                # MySQL DB initialization script
│   ├── haproxy/                # Optional MySQL load balancing
│   ├── keycloak/               # Realm import for OIDC auth
│   ├── mysql-config/           # Custom MySQL config
│   ├── podman-compose.yml      # Podman Compose stack
│   └── traefik/                # Routing and HTTPS via Traefik
└── frontend-mybills/           # [Placeholder] UI application (TBD)
```

---

## Backend Overview (`backend-mybills/`)

- Built with **FastAPI** for the API layer
- **Keycloak** handles optional OIDC authentication (role-based)
- **MySQL** stores billing, customer, and invoice data
- **Traefik** reverse-proxy for TLS termination and routing
- **Podman Compose** used for service orchestration

For full details, see [`backend-mybills/README.md`](./backend-mybills/README.md)

---

## Frontend Overview (`frontend-mybills/`)

> **To be implemented**

This directory is reserved for the frontend application (NextJS).

...

For full details, see [`frontend-mybills/README.md`](./frontend-mybills/README.md)

---

## Running the Stack

TBD:

```bash
TBD
```

> Requires Podman and Podman Compose installed

---

## License

This project is licensed under the terms of the LICENSE file.

---

## Authors

**Bianka Maria Zieba**  
biankamaria.zieba@sunrise.net  
+41 76 777 57 50

**David Dakoli**  
david.dakoli@sunrise.net  
+41 76 777 56 73

**Kevin Vo**  
kevin.vo@sunrise.net  
+41 76 777 54 29

---
