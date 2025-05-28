"use client";

import { usePathname } from "next/navigation";
import { useEffect } from "react";

export default function PostPathToParent() {
  const pathname = usePathname();

  useEffect(() => {
    window.parent.postMessage({ type: "DOCS_NAVIGATED", path: pathname }, "*");
  }, [pathname]);

  return null;
}
