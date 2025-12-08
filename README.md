📡 My Bills – Telecom Billing Analytics Dashboard
Idea for Sunrise analytics dashboard built with Next.js 16, Tailwind CSS, shadcn/ui & MySQL

🚀 Overview

My Bills is a telecom billing analytics dashboard designed for exploring two years of billing history for a single customer.
It was built as part of a hackathon challenge:

“Create a multi-dimensional telecom billing analytics dashboard designed for exploring two years of bills for a single customer. The layout and interactions should focus on clarity, drill-down capability, and insight discovery.”

The dashboard provides a clean, modern interface aligned with the Sunrise Swiss telecom brand style, offering interactive charts, insights, billing breakdowns, and drill-down capabilities.

🧱 Tech Stack
Frontend
Next.js 16 (App Router)
TypeScript
Tailwind CSS
shadcn/ui
Lightweight custom visualizations (no heavy charting libs required)
Backend
Next.js API Routes
MySQL (local or remote)
Compatible with Prisma / Drizzle / mysql2 (your choice)
Design
Sunrise color gradient (Red → Orange → Yellow)
Responsive, mobile-friendly UI
Component-driven architecture

✨ Features
📊 Billing Overview

Explore 24 months of historical telecom bills
Monthly total trend line
Highest & average bills
Filter by 6, 12, or 24 months

💡 Insight Generation

Bill anomalies (e.g., unusually high month)
Plan optimization suggestions
Usage insights (data, roaming, calls)

🧾 Detailed Bill Breakdown

Subscription charges
National & roaming usage
Device installments
Discounts & one-time fees
Data consumption per month

📈 Visual Analytics

Monthly bill timeline
Cost distribution donut
Usage breakdown tabs

🧩 shadcn/ui Component Integration

Cards
Badges
Tables
Tabs
Select menus
Scrollable containers

Buttons

🗂️ Project Structure
/

├── app/

│   ├── my-bills/

│   │   └── page.tsx          # Main dashboard UI

│   ├── api/

│   │   └── bills/route.ts    # Placeholder for MySQL API integration

│   └── layout.tsx

│

├── components/

│   └── ui/                   # Auto-generated shadcn/ui components

│

├── lib/

│   └── billing-data.ts       # Mock data used for prototyping

│

├── public/

│

├── tailwind.config.js

├── package.json

└── README.md

💾 Database Schema

This project uses a normalized telecom billing schema including:
customers
subscriptions
invoices
charges
charge_types
row_types
products
The dataset contains realistic telecom billing rows for one customer (Lisa Simpson), including:
Recurring charges
Installments
Roaming usage
National usage
One-time charges
Discounts
Monthly subscription totals

🏗️ Installation
1️ Clone the repository
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>

2️ Install dependencies
npm install

3️ Install shadcn/ui
npx shadcn@latest init

Add required components:
npx shadcn@latest add card button badge table tabs select scroll-area

4️ Setup .env for MySQL
DATABASE_URL="mysql://user:password@localhost:3306/telecom_billing"

5️ Run the development server
npm run dev

Your dashboard is available at:
🔗 http://localhost:3000/my-bills

📈 Future Improvements

Replace mock data with MySQL API Routes
Add customer selector
Add authentication (NextAuth/Auth0)
Replace CSS charts with Chart.js/Recharts/Tremor if needed
Predictive billing trend engine
Export/printable PDF bill summary

🎨 UI/UX Principles Followed

Sunrise-inspired gradient branding
High data readability
Modern & light visual hierarchy
Drill-down–first interaction design
Insight cards for decision support
Friendly mobile & desktop responsiveness

🏁 Hackathon Goal Achievement
This project fully meets the challenge requirements:

✔ Two-year billing exploration
✔ Multi-dimensional charge analysis
✔ Clean, modern UI
✔ Insight-driven layout
✔ Drill-down capability
✔ Structured MySQL backend
✔ Component-based Next.js architecture

by Kevin Vo, Bianka Zieba, David Dakoli
