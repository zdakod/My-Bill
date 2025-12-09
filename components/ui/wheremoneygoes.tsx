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
import React from "react";

const chartData = [
  { breakdown: "subscriptions", visitors: 275, fill: "var(--color-primary)" },
  { breakdown: "roaming", visitors: 200, fill: "var(--color-secondary)" },
  {
    breakdown: "otherfees",
    visitors: 187,
    fill: "var(--color-secondary-light)",
  },
];

const chartConfig = {
  visitors: {
    label: "Visitors",
  },
  subscriptions: {
    label: "Subscriptions",
    color: "var(--chart-1)",
  },
  roaming: {
    label: "Roaming",
    color: "var(--chart-2)",
  },
  otherfees: {
    label: "Other fees",
    color: "var(--chart-3)",
  },
} satisfies ChartConfig;

export default function WhereMoneyGoes() {
  return (
    <Card className="border-neutral-200 flex flex-col w-full md:w-1/2 bg-white">
      <CardHeader className="pb-0">
        <CardTitle className="text-sm font-semibold">
          Where your money goes
        </CardTitle>
        <CardDescription className="text-xs">
          Breakdown for Oct 2025
        </CardDescription>
      </CardHeader>
      <CardContent className="flex-1 pb-0">
        <ChartContainer
          config={chartConfig}
          className="mx-auto aspect-square max-h-[350px]"
        >
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
              strokeWidth={2}
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
                          CHF 89.50
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
            <ChartLegend content={<ChartLegendContent nameKey="breakdown" />} />
          </PieChart>
        </ChartContainer>
      </CardContent>
    </Card>
  );
}
