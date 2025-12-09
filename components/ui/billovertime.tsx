import { BillOverTimeChart } from "./billovertime-chart";
import { BillingMonthsResponse, MonthlyBillSummary } from "@/lib/types";

/**
 * Chart data point for the area chart.
 */
interface ChartDataPoint {
  month: string;
  amount: number;
}

/**
 * Formats a date string (YYYY-MM) to a short month format for chart display.
 *
 * @param monthStr - Month string in "YYYY-MM" format
 * @returns Formatted string like "Jan 25"
 */
function formatMonthForChart(monthStr: string): string {
  const [year, month] = monthStr.split("-");
  const date = new Date(parseInt(year), parseInt(month) - 1);
  const monthShort = date.toLocaleDateString("en-US", { month: "short" });
  const yearShort = year.slice(-2);
  return `${monthShort} ${yearShort}`;
}

/**
 * Transforms billing months data into chart data format.
 *
 * @param months - Array of monthly bill summaries
 * @param limit - Maximum number of months to include (default: 12)
 * @returns Array of chart data points sorted by month (oldest first)
 */
function transformToChartData(
  months: MonthlyBillSummary[],
  limit: number = 12
): ChartDataPoint[] {
  // Sort by month ascending (oldest first) for proper chart display
  const sortedMonths = [...months]
    .sort((a, b) => a.month.localeCompare(b.month))
    .slice(-limit); // Get last N months

  return sortedMonths.map((month) => ({
    month: formatMonthForChart(month.month),
    amount: month.amount_total,
  }));
}

/**
 * Fetches billing data from the API.
 *
 * @param customerId - The customer ID to fetch billing data for
 * @returns Promise resolving to billing months response
 * @throws Error if the API request fails
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
 * Bill over time chart component (server wrapper).
 *
 * Fetches billing data server-side and passes it to the client chart component.
 */
export default async function Billovertime() {
  const CUSTOMER_ID = 1;
  const MONTHS_TO_DISPLAY = 12;
  let chartData: ChartDataPoint[] = [];
  let customerName = "";
  let customerNumber = "";

  try {
    const billingData = await fetchBillingData(CUSTOMER_ID);
    customerName = billingData.customer.name;
    customerNumber = billingData.customer.customer_number.toString();
    chartData = transformToChartData(billingData.months, MONTHS_TO_DISPLAY);
  } catch (error) {
    console.error("Error loading billing chart data:", error);
    // Component will render empty chart on error
  }

  return (
    <BillOverTimeChart
      chartData={chartData}
      customerName={customerName}
      customerNumber={customerNumber}
    />
  );
}
