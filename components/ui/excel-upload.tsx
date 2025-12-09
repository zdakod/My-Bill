"use client";

import { useRef, useState } from "react";
import { Button } from "./button";

interface ExcelUploadProps {
  onUploadSuccess?: () => void;
  onUploadError?: (error: string) => void;
}

export function ExcelUpload({ onUploadSuccess, onUploadError }: ExcelUploadProps) {
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [isUploading, setIsUploading] = useState(false);

  const handleButtonClick = () => {
    fileInputRef.current?.click();
  };

  const handleFileChange = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    setIsUploading(true);

    // Validate file type - negative test
    if (!file.name.endsWith(".xlsx") && !file.name.endsWith(".xls")) {
      setIsUploading(false);
      onUploadError?.("Invalid file format");
      // Reset file input
      if (fileInputRef.current) {
        fileInputRef.current.value = "";
      }
      return;
    }

    // Excel file accepted - do nothing (negative test)
    // Simulate a small delay
    setTimeout(() => {
      setIsUploading(false);
      // Reset file input
      if (fileInputRef.current) {
        fileInputRef.current.value = "";
      }
      // No success callback - nothing happens
    }, 500);
  };

  return (
    <>
      <input
        ref={fileInputRef}
        type="file"
        accept="*"
        onChange={handleFileChange}
        className="hidden"
        disabled={isUploading}
      />
      <Button
        onClick={handleButtonClick}
        disabled={isUploading}
        className="h-9 rounded-full bg-primary px-4 text-xs font-medium text-white hover:bg-[#c50000] disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {isUploading ? "Uploading..." : "Upload Excel"}
      </Button>
    </>
  );
}

