# MyBills – Frontend (Next.js)

This is the frontend component of the **MyBills** fullstack billing dashboard. It provides a modern and responsive user interface built using **Next.js 14**, **Tailwind CSS**, and integrates with Keycloak for authentication.

---

## Features

- Built with Next.js App Router
- Tailwind CSS for styling
- OIDC login via Keycloak
- Dashboard UI for billing overview
- API integration with the FastAPI backend

---

## Development

> **Requirements**
> - Node.js `>=20.9.0`
> - pnpm or npm (pnpm recommended)
> - Backend services (API, Keycloak) running (see [../backend-mybills](../backend-mybills))

### 1. Install dependencies

```bash
pnpm install
# or
npm install
```

### 2. Setup environment variables

Copy the `.env.example` to `.env`:

```bash
cp .env.example .env
```

Ensure these values point to your running Keycloak and API services:

```env
NEXT_PUBLIC_AUTH_URL=http://auth.localhost:8080/realms/mybills
NEXT_PUBLIC_API_URL=http://api.localhost:8080
NEXT_PUBLIC_CLIENT_ID=frontend-client
```

> You must configure a matching Keycloak client (`frontend-client`) in your realm.

---

### 3. Run the development server

```bash
pnpm dev
# or
npm run dev
```

Then open [http://localhost:3000](http://localhost:3000)

---

## Project Structure

```
frontend-mybills/
├── app/                   # App router pages
│   └── dashboard/         # Protected dashboard page
├── components/            # Reusable UI components
├── lib/                   # Utility functions (auth, API, etc.)
├── styles/                # Tailwind and global styles
├── .env.example           # Example environment config
├── next.config.mjs        # Next.js configuration
├── tailwind.config.mjs    # Tailwind config
└── README.md              # You are here
```

---

## Authentication

The app uses **NextAuth.js** with a custom Keycloak provider. Upon accessing a protected route, the user is redirected to the Keycloak login page.

To configure this, ensure your Keycloak realm contains:

- A **confidential** client (`frontend-client`) with:
  - `Standard Flow Enabled`:
  - `Valid Redirect URIs`: `http://localhost:3000/*`
  - `Web Origins`: `http://localhost:3000`
  - A generated secret (used in `.env` as `KEYCLOAK_CLIENT_SECRET`)

---

## Build for Production

```bash
pnpm build
pnpm start
# or
npm run build && npm start
```

---

## Troubleshooting

- Make sure all backend services are up (API, DB, Keycloak).
- Check Traefik or /etc/hosts for local domain resolution (`auth.localhost`, `api.localhost`).
- Make sure ports 3000 (frontend), 8080 (api/keycloak), and 8443 (HTTPS) are free or correctly mapped.

---
