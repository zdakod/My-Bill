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

## Frontend Overview

The frontend is a modern Next.js application built with React and TypeScript, providing an intuitive dashboard for viewing and analyzing billing data.

---

## Stack Overview

| Component        | Description                                               |
| ---------------- | --------------------------------------------------------- |
| **Next.js 16**   | React framework with App Router for server-side rendering |
| **React 19**     | UI library for building interactive components            |
| **TypeScript**   | Type-safe JavaScript for better developer experience      |
| **Tailwind CSS** | Utility-first CSS framework for styling                   |
| **Shadcn/UI**    | Charting library for data visualization                   |
| **Flowbite**     | UI libraty for Header Component                           |
| **Lucide React** | Icon library for UI elements                              |

---

## Getting Started

### 1. Install Dependencies

```bash
npm install
```

### 2. Set Environment Variables

Create a `.env.local` file (optional):

```env
NEXT_PUBLIC_API_URL=http://api.localhost:8080
```

### 3. Run Development Server

```bash
npm run dev
```

The application will be available at `http://localhost:3000`

### 4. Build for Production

```bash
npm run build
npm start
```

---

## Project Structure

```
.
├── app/                          # Next.js App Router directory
│   ├── page.tsx                  # Main dashboard page (server component)
│   ├── layout.tsx                # Root layout with metadata
│   ├── globals.css               # Global styles and Tailwind config
│   └── api/                      # API routes (if needed)
├── components/
│   └── ui/                       # Reusable UI components
│       ├── header.tsx            # Top navigation with user info
│       ├── main-section.tsx     # Overview cards (bill, average, highest, data)
│       ├── charts-section.tsx   # Chart container with time period filtering
│       ├── billovertime.tsx     # Bill over time chart (server wrapper)
│       ├── billovertime-chart.tsx # Area chart component (client)
│       ├── wheremoneygoes.tsx    # Spending breakdown chart (server wrapper)
│       ├── wheremoneygoes-chart.tsx # Pie chart component (client)
│       ├── alerts.tsx           # Alert notifications component
│       ├── invoices.tsx          # Invoice table component
│       ├── time-period-selector.tsx # Time period dropdown
│       └── time-period-provider.tsx # Context provider for time period state
├── lib/
│   ├── types.ts                  # TypeScript type definitions
│   └── utils.ts                  # Utility functions (cn, etc.)
└── package.json                  # Dependencies and scripts
```

---

## Key Features

### Dashboard Components

- **Header**: Displays logo and authenticated user information (initials and name)
- **Main Section**: Four overview cards showing:
  - Current month's bill with percentage change indicator
  - Average monthly cost
  - Highest bill amount
  - Data usage (GB)
- **Charts Section**:
  - Bill over time (Area chart)
  - Spending breakdown by category (Pie chart)
- **Alerts**: Contextual notifications based on roaming usage
- **Invoices Table**: Detailed monthly billing data with filtering

### Time Period Filtering

Users can filter data by time period:

- All months
- Last 12 months
- Last 6 months
- Last 3 months

The filter applies to all dashboard components (cards, charts, alerts, invoices).

### Data Visualization

- **Area Chart**: Shows bill trends over time with smooth transitions
- **Pie Chart**: Displays spending breakdown by category (subscriptions, roaming, other fees, discounts)
- Charts automatically update when time period changes

---

## API Integration

The frontend communicates with the backend API at `http://api.localhost:8080` (configurable via `NEXT_PUBLIC_API_URL`).

### Data Fetching

- **Server Components**: Main data fetching happens in server components (`app/page.tsx`, `components/ui/billovertime.tsx`, etc.) for better performance
- **Client Components**: Chart rendering uses client components (`"use client"`) since Recharts requires browser APIs
- **Data Flow**: Server components fetch data → Pass as props → Client components render charts

### API Endpoints Used

```http
GET /api/customers/{customer_id}/billing/months
GET /api/customers/{customer_id}/billing/{invoice_id}
```

---

## Development

### Key Technologies

- **Next.js App Router**: Uses the new App Router with server and client components
- **Server-Side Rendering**: Initial data fetching on the server for faster page loads
- **React Context**: `TimePeriodProvider` manages global time period state
- **TypeScript**: Full type safety with API response types defined in `lib/types.ts`

### Component Architecture

- **Server Components**: Handle data fetching (no `"use client"` directive)
- **Client Components**: Handle interactivity and chart rendering (`"use client"` directive)
- **Separation of Concerns**: Data fetching separated from visualization

### Styling

- **Tailwind CSS**: Utility-first CSS with custom color variables
- **CSS Variables**: Theme colors defined in `globals.css` (`--color-primary`, `--color-secondary`, etc.)
- **Responsive Design**: Mobile-first approach with Tailwind breakpoints

---

## Type Safety

All API responses are typed using TypeScript interfaces in `lib/types.ts`:

- `BillingMonthsResponse`
- `MonthlyBillSummary`
- `MonthlyCategories`
- `MonthlyUsage`
- `CustomerInfo`

This ensures type safety throughout the application and better IDE support.

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
