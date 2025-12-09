import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "My Bills - Telecom Analytics Dashboard",
  description: "Multi-dimensional billing analytics for customer insights",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="font-figtree min-h-screen">{children}</body>
    </html>
  );
}
