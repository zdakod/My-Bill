"use client";

import { createContext, useContext, useState, ReactNode } from "react";
import { TimePeriod } from "./time-period-selector";

interface TimePeriodContextType {
  timePeriod: TimePeriod;
  setTimePeriod: (value: TimePeriod) => void;
}

const TimePeriodContext = createContext<TimePeriodContextType | undefined>(
  undefined
);

export function TimePeriodProvider({ children }: { children: ReactNode }) {
  const [timePeriod, setTimePeriod] = useState<TimePeriod>("All");

  return (
    <TimePeriodContext.Provider value={{ timePeriod, setTimePeriod }}>
      {children}
    </TimePeriodContext.Provider>
  );
}

export function useTimePeriod() {
  const context = useContext(TimePeriodContext);
  if (context === undefined) {
    throw new Error("useTimePeriod must be used within a TimePeriodProvider");
  }
  return context;
}

