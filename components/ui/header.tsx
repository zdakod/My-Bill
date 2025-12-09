import Image from "next/image";
import logo from "@/components/ui/assets/Logo.png";

export default function Header() {
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
              LS
            </div>
            <div className="flex flex-col">
              <span className="text-md">Lisa Simpson</span>
            </div>
          </div>
        </div>
      </header>
    </>
  );
}
