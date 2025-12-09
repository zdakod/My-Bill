import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import Header from "@/components/ui/header";
import Billovertime from "@/components/ui/billovertime";
import WhereMoneyGoes from "@/components/ui/wheremoneygoes";
import MainSection from "@/components/ui/main-section";
import Invoices from "@/components/ui/invoices";
import { AlertTriangle, PiggyBank } from "lucide-react";

import { ScrollArea } from "@/components/ui/scroll-area";
import { ArrowUpRight } from "lucide-react";

const sunriseGradient = "bg-gradient-to-r from-[#DA291C] to-[#E8600A]";

export default async function MyBillsPage() {
  const res = await fetch(
    "http://api.localhost:8443/api/customers/1/billing/months",
    { cache: "no-store" } // wenn immer frisch
  );
  const data = await res.json();
  return (
    <div className="min-h-screen w-full bg-[#f5f5f5] text-[#333]">
      <Header />
      <main className="mx-auto max-w-6xl px-4 pb-10 pt-4 space-y-4">
        <MainSection />;
        <section className="flex flex-col md:flex-row mx-auto justify-between gap-4 items-stretch">
          <Billovertime />
          <WhereMoneyGoes />
        </section>
        <section className="mt-4 grid gap-3 md:grid-cols-1">
          <Card className="border-0 bg-white shadow-sm ring-1 ring-black/5 rounded-2xl">
            <CardContent className="flex items-center gap-3 px-5 py-4">
              <div className="flex h-8 w-8 items-center justify-center rounded-full bg-red-100 text-primary">
                <AlertTriangle className="h-5 w-5" />
              </div>

              <div className="flex-1 space-y-1">
                <p className="text-sm font-semibold text-neutral-900">
                  Your October bill is higher than usual
                </p>
                <p className="text-xs text-neutral-600">
                  Extra data and roaming increased your cost.
                </p>
              </div>

              <Button
                size="sm"
                className="h-8 rounded-full bg-primary px-4 text-[11px] font-medium text-white hover:bg-[#c50000]"
              >
                See details
              </Button>
            </CardContent>
          </Card>
          <Card className="border-0 bg-white shadow-sm ring-1 ring-black/5 rounded-2xl">
            <CardContent className="flex items-center gap-3 px-5 py-4">
              <div className="flex h-8 w-8 items-center justify-center rounded-full bg-[#FFF7E0] text-[#F5A500]">
                <PiggyBank className="h-5 w-5" />
              </div>

              <div className="flex-1 space-y-1">
                <p className="text-sm font-semibold text-neutral-900">
                  Potential savings available
                </p>
                <p className="text-xs text-neutral-600">
                  A plan with more data could lower your monthly cost.
                </p>
              </div>
            </CardContent>
          </Card>
        </section>
        <Invoices />
      </main>
    </div>
  );
}
