import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Button } from "./button";

export default async function MainSection() {
  const data = await fetch(
    "http://api.localhost:8443/api/customers/1/billing/months"
  );

  return (
    <>
      <section>
        <div className="mx-auto flex max-w-6xl flex-col gap-6 pt-4">
          <div className="flex gap-3 flex-row items-center justify-between w-full">
            <h1 className="text-3xl tracking-tight text-secondary">My Bills</h1>
            <div className="flex flex-row space-x-3">
              <Select defaultValue="All">
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
              <Button className="h-9 rounded-full bg-primary px-4 text-xs font-medium text-white hover:bg-[#c50000]">
                Upload Excel
              </Button>
            </div>
          </div>

          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <div className="rounded-2xl bg-white shadow-sm ring-1 ring-black/5 px-6 py-5 flex flex-col justify-between">
              <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-neutral-500">
                This month&apos;s bill
              </p>
              <div className="mt-4 space-y-3">
                <div className="text-3xl font-semibold leading-tight text-neutral-900">
                  CHF {data.months}
                </div>
                <span className="inline-flex items-center rounded-full border border-red-200 bg-red-50 px-3 py-1 text-[11px] font-medium text-red-600">
                  ▲ 12% vs last month
                </span>
              </div>
            </div>

            <div className="rounded-2xl bg-white shadow-sm ring-1 ring-black/5 px-6 py-5 flex flex-col justify-between">
              <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-neutral-500">
                Average monthly cost
              </p>
              <div className="mt-4 space-y-1">
                <div className="text-3xl font-semibold leading-tight text-neutral-900">
                  CHF 88.88
                </div>
                <p className="text-xs text-neutral-500">Last 12 months</p>
              </div>
            </div>

            <div className="rounded-2xl bg-white shadow-sm ring-1 ring-black/5 px-6 py-5 flex flex-col justify-between">
              <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-neutral-500">
                Highest bill
              </p>
              <div className="mt-4 space-y-1">
                <div className="text-3xl font-semibold leading-tight text-neutral-900">
                  CHF 112.90
                </div>
                <p className="text-xs text-neutral-500">Aug 2025</p>
              </div>
            </div>

            <div className="rounded-2xl bg-white shadow-sm ring-1 ring-black/5 px-6 py-5 flex flex-col justify-between">
              <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-neutral-500">
                Data used
              </p>
              <div className="mt-4 space-y-1">
                <div className="text-3xl font-semibold leading-tight text-neutral-900">
                  88.88 GB
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
