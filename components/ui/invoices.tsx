import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Card, CardContent, CardHeader, CardTitle } from "./card";
import { ScrollArea } from "@radix-ui/react-scroll-area";
import { Badge } from "@/components/ui/badge";

export default function Invoices() {
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
          <ScrollArea className="h-[260px]">
            <Table className="text-xs">
              <TableHeader>
                <TableRow className="border-b bg-neutral-50/80">
                  <TableHead className="whitespace-nowrap px-5 py-2 text-[11px] font-medium text-neutral-500">
                    Month
                  </TableHead>
                  <TableHead className="whitespace-nowrap px-3 py-2 text-[11px] font-medium text-neutral-500">
                    Invoice #
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
                <TableCell className="px-5 py-2">1</TableCell>
                <TableCell className="px-3 py-2">1</TableCell>
                <TableCell className="px-3 py-2 font-medium text-[#e60000]">
                  CHF 1
                </TableCell>
                <TableCell className="px-3 py-2">CHF 1</TableCell>
                <TableCell className="px-3 py-2">CHF 1</TableCell>
                <TableCell className="px-3 py-2 text-green-600">
                  CHF 1
                </TableCell>
                <TableCell className="px-3 py-2">1 GB</TableCell>
                <TableCell className="px-4 py-2 text-right">
                  <Badge
                    variant="outline"
                    className="rounded-full border-neutral-300 px-3 py-1 text-xs font-medium hover:bg-neutral-100"
                  >
                    View
                  </Badge>
                </TableCell>
              </TableBody>
            </Table>
          </ScrollArea>
        </CardContent>
      </Card>
    </>
  );
}
