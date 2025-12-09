"use client";

import { useMemo } from "react";
import { AlertTriangle, PiggyBank } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { BillingMonthsResponse, MonthlyBillSummary } from "@/lib/types";
import { useTimePeriod } from "./time-period-provider";

/**
 * Alert card data structure.
 */
interface AlertCard {
  icon: React.ComponentType<{ className?: string }>;
  iconBgColor: string;
  iconColor: string;
  title: string;
  description: string;
  showButton?: boolean;
  buttonText?: string;
}


/**
 * Formats a date string (YYYY-MM) to a readable month format.
 *
 * @param monthStr - Month string in "YYYY-MM" format
 * @returns Formatted string like "October 2025"
 */
function formatMonthFull(monthStr: string): string {
  const [year, month] = monthStr.split("-");
  const date = new Date(parseInt(year), parseInt(month) - 1);
  return date.toLocaleDateString("en-US", {
    month: "long",
    year: "numeric",
  });
}

/**
 * Calculates the average monthly cost from billing data.
 *
 * @param months - Array of monthly bill summaries
 * @param count - Number of months to include in calculation
 * @returns Average monthly cost rounded to 2 decimal places
 */
function calculateAverageCost(
  months: MonthlyBillSummary[],
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
 * Generates alerts based on billing data analysis.
 *
 * @param months - Array of monthly bill summaries (filtered)
 * @returns Array of alert cards
 */
function generateAlerts(months: MonthlyBillSummary[]): AlertCard[] {
  const alerts: AlertCard[] = [];

  if (months.length === 0) {
    return alerts;
  }

  const latestMonth = months[0];
  const roamingAmount = latestMonth.amount_by_category.roaming;

  // Always show an alert based on roaming status
  if (roamingAmount === 0 || roamingAmount < 0.01) {
    // No roaming charges - positive alert
    alerts.push({
      icon: PiggyBank,
      iconBgColor: "bg-green-100",
      iconColor: "text-green-600",
      title: "You're on the right track",
      description: "Your current plan covers your usage perfectly. No roaming charges this month.",
      showButton: false,
    });
  } else {
    // High roaming charges - warning alert
    alerts.push({
      icon: AlertTriangle,
      iconBgColor: "bg-red-100",
      iconColor: "text-primary",
      title: "Consider increasing roaming in your subscription",
      description: `You have CHF ${roamingAmount.toFixed(2)} in roaming charges this month. Upgrading your plan could save you money.`,
      showButton: true,
      buttonText: "See details",
    });
  }

  return alerts;
}

interface AlertsProps {
  billingData: BillingMonthsResponse;
}

/**
 * Alert cards component displaying important notifications and recommendations.
 *
 * Shows user-friendly alerts about billing anomalies, potential savings,
 * and other relevant information. Alerts are generated dynamically based on
 * API data analysis.
 */
export default function Alerts({ billingData }: AlertsProps) {
  const { timePeriod } = useTimePeriod();

  // Filter months based on selected time period
  const filteredMonths = useMemo(() => {
    if (timePeriod === "All") {
      return billingData.months;
    }
    return billingData.months.slice(0, parseInt(timePeriod));
  }, [billingData.months, timePeriod]);

  const alerts = useMemo(() => generateAlerts(filteredMonths), [filteredMonths]);
  return (
    <section className="mt-4 grid gap-3 md:grid-cols-1">
      {alerts.map((alert, index) => {
        const IconComponent = alert.icon;
        return (
          <Card
            key={index}
            className="border-0 bg-white shadow-sm ring-1 ring-black/5 rounded-2xl"
          >
            <CardContent className="flex items-center gap-3 px-5 py-4">
              <div
                className={`flex h-8 w-8 items-center justify-center rounded-full ${alert.iconBgColor} ${alert.iconColor}`}
              >
                <IconComponent className="h-5 w-5" />
              </div>

              <div className="flex-1 space-y-1">
                <p className="text-sm font-semibold text-neutral-900">
                  {alert.title}
                </p>
                <p className="text-xs text-neutral-600">{alert.description}</p>
              </div>

              {alert.showButton && alert.buttonText && (
                <Button
                  size="sm"
                  className="h-8 rounded-full bg-primary px-4 text-[11px] font-medium text-white hover:bg-[#c50000]"
                >
                  {alert.buttonText}
                </Button>
              )}
            </CardContent>
          </Card>
        );
      })}
    </section>
  );
}
