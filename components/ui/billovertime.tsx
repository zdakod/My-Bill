"use client";

import { TrendingUp } from "lucide-react";
import { Area, AreaChart, CartesianGrid, XAxis, YAxis } from "recharts";

import {
  Card,
  CardContent,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  ChartConfig,
  ChartContainer,
  ChartTooltip,
  ChartTooltipContent,
} from "@/components/ui/chart";
import { Badge } from "./badge";

export const description = "An area chart with gradient fill";

const chartData = [
  { month: "Jan 25", amount: 186 },
  { month: "February", amount: 305 },
  { month: "March", amount: 237 },
  { month: "April", amount: 73 },
  { month: "May", amount: 209 },
  { month: "June", amount: 214 },
];

const chartConfig = {
  amount: {
    label: "CHF",
    color: "var(--chart-1)",
  },
} satisfies ChartConfig;

export default function Billovertime() {
  return (
    <Card className="border-neutral-200 w-full md:w-1/2 flex flex-col bg-white">
      <CardHeader className="flex flex-row items-center justify-between space-y-0">
        <div>
          <CardTitle className="text-sm font-semibold">
            Bill over time
          </CardTitle>
          <p className="text-xs text-neutral-500">
            Lisa Simpson · 021 292 70 96
          </p>
        </div>
        <Badge variant="outline" className="text-xs">
          CHF / month
        </Badge>
      </CardHeader>
      <CardContent className="py-4">
        <ChartContainer config={chartConfig}>
          <AreaChart
            accessibilityLayer
            data={chartData}
            margin={{
              left: 12,
              right: 12,
            }}
          >
            <CartesianGrid vertical={false} />
            <XAxis
              dataKey="month"
              tickLine={false}
              axisLine={false}
              tickMargin={8}
              tickFormatter={(value) => value.slice(0, 6)}
            />
            <YAxis
              tickLine={false}
              axisLine={false}
              tickMargin={8}
              tickCount={3}
            />
            <ChartTooltip
              cursor={false}
              content={
                <ChartTooltipContent className="rounded-2xl border border-neutral-300 bg-white/95 px-3 py-2 shadow-lg" />
              }
            />
            <defs>
              <linearGradient id="fillamount" x1="0" y1="0" x2="0" y2="1">
                <stop
                  offset="5%"
                  stopColor="var(--color-primary)"
                  stopOpacity={0.8}
                />
                <stop
                  offset="95%"
                  stopColor="var(--color-primary)"
                  stopOpacity={0.1}
                />
              </linearGradient>

              <linearGradient id="fillMobile" x1="0" y1="0" x2="0" y2="1">
                <stop
                  offset="5%"
                  stopColor="var(--color-primary)"
                  stopOpacity={0.8}
                />
                <stop
                  offset="95%"
                  stopColor="var(--color-primary)"
                  stopOpacity={0.1}
                />
              </linearGradient>
            </defs>
            <Area
              dataKey="amount"
              type="natural"
              fill="url(#fillamount)"
              fillOpacity={0.4}
              stroke="var(--color-primary)"
              strokeWidth={2}
            />
          </AreaChart>
        </ChartContainer>
      </CardContent>
    </Card>
  );
}
