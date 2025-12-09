import Header from "@/components/ui/header";
import MainSection from "@/components/ui/main-section";
import { ChartsSection } from "@/components/ui/charts-section";
import Alerts from "@/components/ui/alerts";
import Invoices from "@/components/ui/invoices";
import { BillingMonthsResponse } from "@/lib/types";
import { TimePeriodProvider } from "@/components/ui/time-period-provider";

/**
 * Fetches billing data from the API.
 */
async function fetchBillingData(
  customerId: number
): Promise<BillingMonthsResponse> {
  const apiUrl = process.env.NEXT_PUBLIC_API_URL || "http://api.localhost:8080";
  const response = await fetch(
    `${apiUrl}/api/customers/${customerId}/billing/months`,
    { cache: "no-store" }
  );

  if (!response.ok) {
    throw new Error(
      `Failed to fetch billing data: ${response.status} ${response.statusText}`
    );
  }

  return response.json();
}

/**
 * Main page component for the MyBills application.
 *
 * Displays a comprehensive billing dashboard with:
 * - Header with logo and user info
 * - Main section with billing overview cards
 * - Charts showing bill trends and spending breakdown
 * - Alert notifications
 * - Detailed invoice table
 */
export default async function MyBillsPage() {
  const CUSTOMER_ID = 1;
  let billingData: BillingMonthsResponse;

  try {
    billingData = await fetchBillingData(CUSTOMER_ID);
  } catch (error) {
    console.error("Error loading billing data:", error);
    throw error;
  }

  return (
    <TimePeriodProvider>
      <div className="min-h-screen w-full bg-[#f5f5f5] text-[#333]">
        <Header />
        <main className="mx-auto max-w-6xl px-4 pb-10 pt-4 space-y-4">
          <MainSection billingData={billingData} />
          <ChartsSection billingData={billingData} />
          <Alerts billingData={billingData} />
          <Invoices billingData={billingData} />
        </main>
      </div>
    </TimePeriodProvider>
  );
}
