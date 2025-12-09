import Image from "next/image";
import logo from "@/components/ui/assets/Logo.png";
import { BillingMonthsResponse } from "@/lib/types";

/**
 * Fetches billing data from the API to get customer information.
 *
 * @param customerId - The customer ID to fetch billing data for
 * @returns Promise resolving to billing months response
 * @throws Error if the API request fails
 */
async function fetchBillingData(
  customerId: number
): Promise<BillingMonthsResponse> {
  const apiUrl = process.env.NEXT_PUBLIC_API_URL || "http://api.localhost:8080";
  const response = await fetch(
    `${apiUrl}/api/customers/${customerId}/billing/months`,
    { cache: "no-store" }
  );

  if (!response.ok) {
    throw new Error(
      `Failed to fetch billing data: ${response.status} ${response.statusText}`
    );
  }

  return response.json();
}

/**
 * Gets user initials from a full name.
 *
 * @param name - Full name string
 * @returns Initials (e.g., "Lisa Simpson" -> "LS")
 */
function getInitials(name: string): string {
  const parts = name.trim().split(" ");
  if (parts.length === 0) return "";
  if (parts.length === 1) return parts[0].charAt(0).toUpperCase();
  return (
    parts[0].charAt(0).toUpperCase() +
    parts[parts.length - 1].charAt(0).toUpperCase()
  );
}

/**
 * Header component displaying the application logo and user information.
 *
 * Shows the Sunrise/MyBills logo on the left and user profile information
 * on the right (on larger screens). User data is fetched from the API.
 */
export default async function Header() {
  const CUSTOMER_ID = 1;
  let customerName = "Customer";
  let customerInitials = "C";

  try {
    const billingData = await fetchBillingData(CUSTOMER_ID);
    customerName = billingData.customer.name;
    customerInitials = getInitials(customerName);
  } catch (error) {
    console.error("Error loading customer data:", error);
  }
  return (
    <>
      <header className="top-0 z-20 border-b border-neutral-200 bg-white py-3">
        <div className="mx-auto flex items-center justify-between px-4 max-w-6xl  py-2">
          <div className="flex flex-1 flex-col gap-2 sm:flex-row sm:items-center">
            <Image
              src={logo}
              alt="Logo"
              className="h-8 w-42 md:h-7 md:w-auto"
            />
          </div>
          <div className="hidden sm:flex items-center gap-2 px-2 py-1">
            <div className="flex h-7 w-7 items-center justify-center rounded-full text-xs font-semibold text-white bg-primary">
              {customerInitials}
            </div>
            <div className="flex flex-col">
              <span className="text-md">{customerName}</span>
            </div>
          </div>
        </div>
      </header>
    </>
  );
}
