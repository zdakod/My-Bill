"use client";

import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

export type TimePeriod = "All" | "24" | "12" | "6";

interface TimePeriodSelectorProps {
  value: TimePeriod;
  onValueChange: (value: TimePeriod) => void;
}

/**
 * Time period selector dropdown component.
 * Allows users to filter billing data by time period.
 */
export function TimePeriodSelector({
  value,
  onValueChange,
}: TimePeriodSelectorProps) {
  return (
    <Select value={value} onValueChange={onValueChange}>
      <SelectTrigger className="h-8 w-36 rounded-full border border-secondary bg-white/10 text-xs text-secondary">
        <SelectValue placeholder="Last 24 months" />
      </SelectTrigger>
      <SelectContent className="bg-white text-foreground border border-neutral-200 shadow-md">
        <SelectItem value="All">All</SelectItem>
        <SelectItem value="24">Last 12 months</SelectItem>
        <SelectItem value="12">Last 6 months</SelectItem>
        <SelectItem value="6">Last 3 months</SelectItem>
      </SelectContent>
    </Select>
  );
}

