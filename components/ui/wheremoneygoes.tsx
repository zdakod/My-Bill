import { WhereMoneyGoesChart } from "./wheremoneygoes-chart";
import { BillingMonthsResponse, MonthlyCategories } from "@/lib/types";

/**
 * Chart data point for the pie chart.
 */
interface PieChartDataPoint {
  breakdown: string;
  visitors: number;
  fill: string;
}

/**
 * Formats a date string (YYYY-MM) to a readable month format.
 *
 * @param monthStr - Month string in "YYYY-MM" format
 * @returns Formatted string like "Oct 2025"
 */
function formatMonth(monthStr: string): string {
  const [year, month] = monthStr.split("-");
  const date = new Date(parseInt(year), parseInt(month) - 1);
  return date.toLocaleDateString("en-US", { month: "short", year: "numeric" });
}

/**
 * Transforms category amounts into pie chart data format.
 *
 * @param categories - Monthly category breakdown
 * @returns Array of pie chart data points
 */
function transformToPieChartData(
  categories: MonthlyCategories
): PieChartDataPoint[] {
  const otherTotal =
    categories.extra_data +
    categories.device_payment +
    categories.taxes_fees +
    categories.other;

  const data: PieChartDataPoint[] = [
    {
      breakdown: "subscriptions",
      visitors: categories.subscription ?? 0,
      fill: "#ad1212",
    },
    {
      breakdown: "roaming",
      visitors: categories.roaming ?? 0,
      fill: "#3D3935",
    },
    {
      breakdown: "otherfees",
      visitors: otherTotal ?? 0,
      fill: "#E6E3DF",
    },
  ];

  return data.some((d) => d.visitors > 0) ? data : [];
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
 * Where your money goes pie chart component (server wrapper).
 *
 * Fetches billing data server-side and passes it to the client chart component.
 */
export default async function WhereMoneyGoes() {
  const CUSTOMER_ID = 1;
  let chartData: PieChartDataPoint[] = [];
  let currentMonthTotal = 0;
  let currentMonthStr = "";

  try {
    const billingData = await fetchBillingData(CUSTOMER_ID);

    // Get most recent month (first in array is most recent)
    const latestMonth = billingData.months[0];
    if (latestMonth) {
      currentMonthStr = formatMonth(latestMonth.month);
      currentMonthTotal = latestMonth.amount_total;
      chartData = transformToPieChartData(latestMonth.amount_by_category);
    }
  } catch (error) {
    console.error("Error loading spending breakdown data:", error);
    // Component will render empty chart on error
  }

  return (
    <WhereMoneyGoesChart
      chartData={chartData}
      currentMonthTotal={currentMonthTotal}
      currentMonthStr={currentMonthStr}
    />
  );
}
