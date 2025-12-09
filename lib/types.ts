/**
 * Type definitions for MyBills API responses and data structures.
 * 
 * These types ensure type safety when working with API data throughout
 * the application.
 */

/**
 * Customer information from the API.
 */
export interface CustomerInfo {
  id: number;
  customer_number: number;
  name: string;
}

/**
 * Monthly usage statistics.
 */
export interface MonthlyUsage {
  data_gb: number;
  voice_minutes: number;
  sms_count: number;
  roaming_minutes: number;
}

/**
 * Amount breakdown by category.
 */
export interface MonthlyCategories {
  subscription: number;
  extra_data: number;
  roaming: number;
  device_payment: number;
  taxes_fees: number;
  other: number;
}

/**
 * Summary of a monthly bill.
 */
export interface MonthlyBillSummary {
  invoice_id: number;
  invoice_number: number;
  month: string; // Format: "YYYY-MM"
  bill_to_date: string; // ISO date string
  currency: string;
  amount_total: number;
  amount_by_category: MonthlyCategories;
  usage: MonthlyUsage;
}

/**
 * Response from the billing months endpoint.
 */
export interface BillingMonthsResponse {
  customer: CustomerInfo;
  months: MonthlyBillSummary[];
}

/**
 * Line item in a detailed bill.
 */
export interface BillLineItem {
  category: string;
  charge_type: string | null;
  jurisdiction: string | null;
  description: string | null;
  charge_from_date: string | null;
  charge_to_date: string | null;
  display_units: string | null;
  call_counter: number | null;
  amount_chf: number;
}

/**
 * Detailed bill information.
 */
export interface BillDetail {
  invoice: MonthlyBillSummary;
  line_items: BillLineItem[];
}

