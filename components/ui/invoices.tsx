"use client";

import { useMemo } from "react";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Card, CardContent, CardHeader, CardTitle } from "./card";
import { BillingMonthsResponse, MonthlyBillSummary } from "@/lib/types";
import { useTimePeriod } from "./time-period-provider";

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
 * Formats a date string (ISO format) to a readable date format.
 *
 * @param dateStr - ISO date string
 * @returns Formatted string like "Oct 31, 2025"
 */
function formatDate(dateStr: string): string {
  const date = new Date(dateStr);
  return date.toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  });
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

/**
 * Formats data volume in GB for display.
 *
 * @param gb - Data volume in gigabytes
 * @returns Formatted string like "27.2 GB"
 */
function formatDataVolume(gb: number): string {
  return `${gb.toFixed(2)} GB`;
}

/**
 * Transforms a monthly bill summary into a table row format.
 *
 * @param month - Monthly bill summary from API
 * @returns Transformed invoice row data
 */
function transformInvoiceRow(month: MonthlyBillSummary) {
  return {
    month: formatMonth(month.month),
    chargeFromDate: formatDate(month.bill_to_date),
    amount: month.amount_total,
    subscription: month.amount_by_category.subscription,
    roaming: month.amount_by_category.roaming,
    discount: month.amount_by_category.other, // Other category often contains discounts
    dataVolume: formatDataVolume(month.usage.data_gb),
    invoiceId: month.invoice_id,
  };
}

interface InvoicesProps {
  billingData: BillingMonthsResponse;
}

/**
 * Invoices table component displaying billing details by month.
 *
 * Shows a scrollable table with invoice information including:
 * - Month
 * - Invoice number
 * - Total amount
 * - Subscription costs
 * - Roaming costs
 * - Discounts
 * - Data volume used
 */
export default function Invoices({ billingData }: InvoicesProps) {
  const { timePeriod } = useTimePeriod();

  // Filter months based on selected time period
  const filteredMonths = useMemo(() => {
    if (timePeriod === "All") {
      return billingData.months;
    }
    return billingData.months.slice(0, parseInt(timePeriod));
  }, [billingData.months, timePeriod]);

  // Sort by month descending (newest first)
  const invoiceRows = useMemo(() => {
    const sortedMonths = [...filteredMonths].sort((a, b) => {
      return b.month.localeCompare(a.month);
    });
    return sortedMonths.map(transformInvoiceRow);
  }, [filteredMonths]);
  return (
    <>
      <Card className="border-0 bg-white shadow-sm ring-1 ring-black/5 rounded-2xl">
        <CardHeader className="flex flex-row items-center justify-between px-7 pb-2 pt-4">
          <div>
            <CardTitle className="text-sm font-semibold text-neutral-900">
              Bill details by month
            </CardTitle>
            <p className="text-xs text-neutral-500">
              Invoiced amounts and usage highlights
            </p>
          </div>
        </CardHeader>

        <CardContent className="px-6 pb-4 pt-1">
          <div className="overflow-x-auto">
            <Table className="text-xs">
              <TableHeader>
                <TableRow className="border-b bg-neutral-50/80">
                  <TableHead className="whitespace-nowrap px-5 py-2 text-[11px] font-medium text-neutral-500">
                    Month
                  </TableHead>
                  <TableHead className="whitespace-nowrap px-3 py-2 text-[11px] font-medium text-neutral-500">
                    Charge from date
                  </TableHead>
                  <TableHead className="whitespace-nowrap px-3 py-2 text-[11px] font-medium text-neutral-500">
                    Amount
                  </TableHead>
                  <TableHead className="whitespace-nowrap px-3 py-2 text-[11px] font-medium text-neutral-500">
                    Subscription
                  </TableHead>
                  <TableHead className="whitespace-nowrap px-3 py-2 text-[11px] font-medium text-neutral-500">
                    Roaming
                  </TableHead>
                  <TableHead className="whitespace-nowrap px-3 py-2 text-[11px] font-medium text-neutral-500">
                    Discounts
                  </TableHead>
                  <TableHead className="whitespace-nowrap px-3 py-2 text-[11px] font-medium text-neutral-500">
                    Data volume
                  </TableHead>
                  <TableHead className="whitespace-nowrap px-4 py-2 text-[11px] font-medium text-neutral-500 text-right">
                    Details
                  </TableHead>
                </TableRow>
              </TableHeader>

              <TableBody>
                {invoiceRows.length === 0 ? (
                  <TableRow>
                    <TableCell
                      colSpan={8}
                      className="px-5 py-8 text-center text-sm text-neutral-500"
                    >
                      No invoice data available
                    </TableCell>
                  </TableRow>
                ) : (
                  invoiceRows.map((row) => (
                    <TableRow key={row.invoiceId} className="border-b">
                      <TableCell className="px-5 py-2">{row.month}</TableCell>
                      <TableCell className="px-3 py-2">
                        {row.chargeFromDate}
                      </TableCell>
                      <TableCell
                        className={`px-3 py-2 font-medium ${
                          row.amount < 0 ? "text-green-600" : "text-[#e60000]"
                        }`}
                      >
                        {formatCurrency(row.amount)}
                      </TableCell>
                      <TableCell className="px-3 py-2">
                        {formatCurrency(row.subscription)}
                      </TableCell>
                      <TableCell className="px-3 py-2">
                        {formatCurrency(row.roaming)}
                      </TableCell>
                      <TableCell className="px-3 py-2 text-green-600">
                        {formatCurrency(row.discount)}
                      </TableCell>
                      <TableCell className="px-3 py-2">
                        {row.dataVolume}
                      </TableCell>
                      <TableCell className="px-4 py-2 text-right">
                        <a
                          href="https://www.sunrise.ch/mysunrise/de/privatkunden/login"
                          target="_blank"
                          rel="noopener noreferrer"
                          className="inline-flex items-center rounded-full border border-neutral-300 px-3 py-1 text-xs font-medium hover:bg-neutral-100 transition-colors"
                        >
                          View
                        </a>
                      </TableCell>
                    </TableRow>
                  ))
                )}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>
    </>
  );
}
