"use client";

import { Label, Pie, PieChart } from "recharts";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  ChartConfig,
  ChartContainer,
  ChartLegend,
  ChartLegendContent,
  ChartTooltip,
  ChartTooltipContent,
} from "@/components/ui/chart";

/**
 * Chart data point for the pie chart.
 */
interface PieChartDataPoint {
  breakdown: string;
  visitors: number;
  fill: string;
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

const chartConfig = {
  visitors: {
    label: "Amount",
  },
  subscriptions: {
    label: "Subscriptions",
    color: "#ad1212", // --color-primary
  },
  roaming: {
    label: "Roaming",
    color: "#3D3935", // --color-secondary
  },
  otherfees: {
    label: "Other fees",
    color: "#E6E3DF", // --color-secondary-light
  },
  discounts: {
    label: "Discounts",
    color: "#E5756D", // --color-primary-light
  },
} satisfies ChartConfig;

/**
 * Props for the WhereMoneyGoesChart component.
 */
interface WhereMoneyGoesChartProps {
  chartData: PieChartDataPoint[];
  currentMonthTotal: number;
  currentMonthStr: string;
}

/**
 * Client-side chart component that renders the pie chart.
 */
export function WhereMoneyGoesChart({
  chartData,
  currentMonthTotal,
  currentMonthStr,
}: WhereMoneyGoesChartProps) {
  console.log("WhereMoneyGoesChart - chartData:", chartData);
  console.log("WhereMoneyGoesChart - currentMonthTotal:", currentMonthTotal);

  return (
    <Card className="border-neutral-200 flex flex-col w-full md:w-1/2 bg-white">
      <CardHeader className="pb-0">
        <CardTitle className="text-sm font-semibold">
          Where your money goes
        </CardTitle>
        <CardDescription className="text-xs">
          Breakdown for {currentMonthStr || "N/A"}
        </CardDescription>
      </CardHeader>
      <CardContent className="flex-1 pb-0">
        <ChartContainer
          config={chartConfig}
          className="mx-auto aspect-square max-h-[350px]"
        >
          {chartData.length === 0 ? (
            <div className="flex items-center justify-center h-full text-sm text-neutral-500">
              No data available
            </div>
          ) : (
            <PieChart>
              <ChartTooltip
                cursor={false}
                content={<ChartTooltipContent hideLabel />}
              />
              <Pie
                data={chartData}
                dataKey="visitors"
                nameKey="breakdown"
                innerRadius={85}
                outerRadius={120}
                strokeWidth={2}
                stroke="#fff"
              >
                <Label
                  content={({ viewBox }) => {
                    if (viewBox && "cx" in viewBox && "cy" in viewBox) {
                      return (
                        <text
                          x={viewBox.cx}
                          y={viewBox.cy}
                          textAnchor="middle"
                          dominantBaseline="middle"
                        >
                          <tspan
                            x={viewBox.cx}
                            y={viewBox.cy}
                            className="fill-foreground text-xl font-bold"
                          >
                            {formatCurrency(currentMonthTotal)}
                          </tspan>
                          <tspan
                            x={viewBox.cx}
                            y={(viewBox.cy || 0) + 24}
                            className="fill-muted-foreground"
                          >
                            This month
                          </tspan>
                        </text>
                      );
                    }
                  }}
                />
              </Pie>
              <ChartLegend
                content={<ChartLegendContent nameKey="breakdown" />}
              />
            </PieChart>
          )}
        </ChartContainer>
      </CardContent>
    </Card>
  );
}
