"use client";

import { useState } from "react";
import { Button } from "./button";
import { BillingMonthsResponse } from "@/lib/types";
import { TimePeriodSelector } from "./time-period-selector";
import { useTimePeriod } from "./time-period-provider";
import { ExcelUpload } from "./excel-upload";

/**
 * Calculates the average monthly cost from billing data.
 *
 * @param months - Array of monthly bill summaries
 * @param count - Number of months to include in calculation
 * @returns Average monthly cost rounded to 2 decimal places
 */
function calculateAverageCost(
  months: BillingMonthsResponse["months"],
  count: number
): number {
  if (months.length === 0) return 0;

  const monthsToCalculate = months.slice(0, count);
  const total = monthsToCalculate.reduce(
    (sum, month) => sum + month.amount_total,
    0
  );

  return Math.round((total / monthsToCalculate.length) * 100) / 100;
}

/**
 * Finds the highest bill amount and its month.
 *
 * @param months - Array of monthly bill summaries
 * @returns Object with highest amount and month string, or null if no data
 */
function findHighestBill(
  months: BillingMonthsResponse["months"]
): { amount: number; month: string } | null {
  if (months.length === 0) return null;

  const highest = months.reduce((max, month) => {
    return month.amount_total > max.amount_total ? month : max;
  }, months[0]);

  const date = new Date(highest.bill_to_date);
  const monthStr = date.toLocaleDateString("en-US", {
    month: "short",
    year: "numeric",
  });

  return {
    amount: highest.amount_total,
    month: monthStr,
  };
}

/**
 * Calculates the percentage change between two amounts.
 *
 * @param current - Current amount
 * @param previous - Previous amount
 * @returns Percentage change rounded to nearest integer
 */
function calculatePercentageChange(current: number, previous: number): number {
  if (previous === 0) return 0;
  return Math.round(((current - previous) / Math.abs(previous)) * 100);
}

/**
 * Formats a currency amount for display.
 *
 * @param amount - The amount to format
 * @param currency - Currency code (default: "CHF")
 * @returns Formatted string like "CHF 123.45"
 */
function formatCurrency(amount: number, currency: string = "CHF"): string {
  return `${currency} ${amount.toFixed(2)}`;
}

interface MainSectionProps {
  billingData: BillingMonthsResponse;
}

/**
 * Main section component displaying billing overview cards.
 *
 * Shows:
 * - This month's bill (last invoice)
 * - Average monthly cost
 * - Highest bill
 * - Data used this month
 */
export default function MainSection({ billingData }: MainSectionProps) {
  const { timePeriod, setTimePeriod } = useTimePeriod();
  const [toastMessage, setToastMessage] = useState<{ type: "error"; message: string } | null>(null);

  // Filter months based on selected time period
  const filteredMonths =
    timePeriod === "All"
      ? billingData.months
      : billingData.months.slice(0, parseInt(timePeriod));

  // Get latest invoice (first month in array is most recent)
  const latestInvoice = filteredMonths[0];
  const lastTotal = latestInvoice?.amount_total ?? 0;

  // Calculate percentage change vs previous month
  let percentageChange = 0;
  let percentageChangeText = "";
  let percentageChangeClass = "";
  if (filteredMonths.length >= 2) {
    const previousMonth = filteredMonths[1];
    percentageChange = calculatePercentageChange(
      lastTotal,
      previousMonth.amount_total
    );
    if (percentageChange > 0) {
      percentageChangeText = `▲ ${Math.abs(percentageChange)}% vs last month`;
      percentageChangeClass = "border-red-200 bg-red-50 text-red-600";
    } else if (percentageChange < 0) {
      percentageChangeText = `▼ ${Math.abs(percentageChange)}% vs last month`;
      percentageChangeClass = "border-green-200 bg-green-50 text-green-600";
    } else {
      percentageChangeText = `${Math.abs(percentageChange)}% vs last month`;
      percentageChangeClass = "border-green-200 bg-green-50 text-green-600";
    }
  }

  // Calculate average for filtered months
  const averageCost = calculateAverageCost(filteredMonths, filteredMonths.length);

  // Find highest bill in filtered months
  const highestBill = findHighestBill(filteredMonths);

  // Get latest data usage (first month in array is most recent)
  const latestMonth = filteredMonths[0];
  const latestDataUsage = latestMonth?.usage?.data_gb ?? 0;

  return (
    <>
      {toastMessage && (
        <div className="fixed top-20 right-4 z-50 rounded-lg px-4 py-3 shadow-lg bg-red-50 text-red-800 border border-red-200">
          <div className="flex items-center gap-2">
            <span className="font-medium">{toastMessage.message}</span>
            <button
              onClick={() => setToastMessage(null)}
              className="ml-2 text-gray-400 hover:text-gray-600"
            >
              ×
            </button>
          </div>
        </div>
      )}
      <section>
        <div className="mx-auto flex max-w-6xl flex-col gap-6 pt-4">
          <div className="flex gap-3 flex-row items-center justify-between w-full">
            <h1 className="text-3xl tracking-tight text-secondary">My Bills</h1>
            <div className="flex flex-row space-x-3">
              <TimePeriodSelector
                value={timePeriod}
                onValueChange={setTimePeriod}
              />
              <ExcelUpload
                onUploadError={(error) => {
                  setToastMessage({ type: "error", message: error });
                  setTimeout(() => setToastMessage(null), 5000);
                }}
              />
            </div>
          </div>

          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <div className="rounded-2xl bg-white shadow-sm ring-1 ring-black/5 px-6 py-5 flex flex-col justify-between">
              <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-neutral-500">
                This month&apos;s bill
              </p>
              <div className="mt-4 space-y-3">
                <div className="text-3xl font-semibold leading-tight text-neutral-900">
                  {formatCurrency(lastTotal)}
                </div>
                {percentageChangeText && (
                  <span
                    className={`inline-flex items-center rounded-full border px-3 py-1 text-[11px] font-medium ${percentageChangeClass}`}
                  >
                    {percentageChangeText}
                  </span>
                )}
              </div>
            </div>

            <div className="rounded-2xl bg-white shadow-sm ring-1 ring-black/5 px-6 py-5 flex flex-col justify-between">
              <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-neutral-500">
                Average monthly cost
              </p>
              <div className="mt-4 space-y-1">
                <div className="text-3xl font-semibold leading-tight text-neutral-900">
                  {formatCurrency(averageCost)}
                </div>
                <p className="text-xs text-neutral-500">
                  {timePeriod === "All"
                    ? "All months"
                    : `Last ${timePeriod} months`}
                </p>
              </div>
            </div>

            <div className="rounded-2xl bg-white shadow-sm ring-1 ring-black/5 px-6 py-5 flex flex-col justify-between">
              <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-neutral-500">
                Highest bill
              </p>
              <div className="mt-4 space-y-1">
                <div className="text-3xl font-semibold leading-tight text-neutral-900">
                  {highestBill
                    ? formatCurrency(highestBill.amount)
                    : "CHF 0.00"}
                </div>
                <p className="text-xs text-neutral-500">
                  {highestBill?.month || "N/A"}
                </p>
              </div>
            </div>

            <div className="rounded-2xl bg-white shadow-sm ring-1 ring-black/5 px-6 py-5 flex flex-col justify-between">
              <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-neutral-500">
                Data used
              </p>
              <div className="mt-4 space-y-1">
                <div className="text-3xl font-semibold leading-tight text-neutral-900">
                  {latestDataUsage.toFixed(2)} GB
                </div>
                <p className="text-xs text-neutral-500">This month</p>
              </div>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
