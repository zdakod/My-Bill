"use client";

import { useMemo } from "react";
import { BillOverTimeChart } from "./billovertime-chart";
import { WhereMoneyGoesChart } from "./wheremoneygoes-chart";
import { BillingMonthsResponse, MonthlyBillSummary, MonthlyCategories } from "@/lib/types";
import { useTimePeriod } from "./time-period-provider";

/**
 * Chart data point for the area chart.
 */
interface ChartDataPoint {
  month: string;
  amount: number;
}

/**
 * Chart data point for the pie chart.
 */
interface PieChartDataPoint {
  breakdown: string;
  visitors: number;
  fill: string;
}

/**
 * Formats a date string (YYYY-MM) to a short month format for chart display.
 */
function formatMonthForChart(monthStr: string): string {
  const [year, month] = monthStr.split("-");
  const date = new Date(parseInt(year), parseInt(month) - 1);
  const monthShort = date.toLocaleDateString("en-US", { month: "short" });
  const yearShort = year.slice(-2);
  return `${monthShort} ${yearShort}`;
}

/**
 * Formats a date string (YYYY-MM) to a readable month format.
 */
function formatMonth(monthStr: string): string {
  const [year, month] = monthStr.split("-");
  const date = new Date(parseInt(year), parseInt(month) - 1);
  return date.toLocaleDateString("en-US", { month: "short", year: "numeric" });
}

/**
 * Transforms billing months data into chart data format.
 */
function transformToChartData(
  months: MonthlyBillSummary[],
  limit: number = 12
): ChartDataPoint[] {
  const sortedMonths = [...months]
    .sort((a, b) => a.month.localeCompare(b.month))
    .slice(-limit);

  return sortedMonths.map((month) => ({
    month: formatMonthForChart(month.month),
    amount: month.amount_total,
  }));
}

/**
 * Transforms category amounts into pie chart data format.
 * Handles negative values by using absolute values for display.
 */
function transformToPieChartData(
  categories: MonthlyCategories
): PieChartDataPoint[] {
  const data: PieChartDataPoint[] = [];

  // Only include positive subscription amounts
  if (categories.subscription > 0) {
    data.push({
      breakdown: "subscriptions",
      visitors: categories.subscription,
      fill: "#ad1212",
    });
  }

  // Only include positive roaming amounts
  if (categories.roaming > 0) {
    data.push({
      breakdown: "roaming",
      visitors: categories.roaming,
      fill: "#3D3935",
    });
  }

  // Combine other categories, handling negative values
  const otherTotal =
    categories.extra_data +
    categories.device_payment +
    categories.taxes_fees +
    (categories.other > 0 ? categories.other : 0); // Only add positive "other" values

  if (otherTotal > 0) {
    data.push({
      breakdown: "otherfees",
      visitors: otherTotal,
      fill: "#E6E3DF",
    });
  }

  // Handle discounts/credits separately if other is negative
  if (categories.other < 0) {
    data.push({
      breakdown: "discounts",
      visitors: Math.abs(categories.other),
      fill: "#E5756D", // --color-primary-light
    });
  }

  console.log("transformToPieChartData - Input categories:", categories);
  console.log("transformToPieChartData - Output data:", data);

  return data;
}

interface ChartsSectionProps {
  billingData: BillingMonthsResponse;
}

/**
 * Charts section component that displays filtered billing charts.
 */
export function ChartsSection({ billingData }: ChartsSectionProps) {
  const { timePeriod } = useTimePeriod();
  // Filter months based on selected time period
  const filteredMonths = useMemo(() => {
    if (timePeriod === "All") {
      return billingData.months;
    }
    const monthsToShow = parseInt(timePeriod);
    return billingData.months.slice(0, monthsToShow);
  }, [billingData.months, timePeriod]);

  // Transform data for area chart
  const chartData = useMemo(() => {
    return transformToChartData(filteredMonths, filteredMonths.length);
  }, [filteredMonths]);

  // Get latest month data for pie chart - ensure it updates when filteredMonths changes
  const latestMonth = useMemo(() => filteredMonths[0], [filteredMonths]);
  
  const pieChartData = useMemo(() => {
    if (!latestMonth) {
      console.log("ChartsSection - No latest month available");
      return [];
    }
    const data = transformToPieChartData(latestMonth.amount_by_category);
    console.log("ChartsSection - Latest month:", latestMonth);
    console.log("ChartsSection - Pie chart data:", data);
    return data;
  }, [latestMonth]);

  const currentMonthStr = useMemo(() => {
    return latestMonth ? formatMonth(latestMonth.month) : "";
  }, [latestMonth]);

  const currentMonthTotal = useMemo(() => {
    return latestMonth?.amount_total ?? 0;
  }, [latestMonth]);

  return (
    <section className="flex flex-col md:flex-row mx-auto justify-between gap-4 items-stretch">
      <BillOverTimeChart
        key={`bill-over-time-${timePeriod}`}
        chartData={chartData}
        customerName={billingData.customer.name}
        customerNumber={billingData.customer.customer_number.toString()}
      />
      <WhereMoneyGoesChart
        key={`where-money-goes-${timePeriod}-${currentMonthStr}`}
        chartData={pieChartData}
        currentMonthTotal={currentMonthTotal}
        currentMonthStr={currentMonthStr}
      />
    </section>
  );
}

