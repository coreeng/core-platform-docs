import type { Metadata } from "next";
import { Layout, Navbar } from "nextra-theme-docs";
import { Head } from "nextra/components";
import { getPageMap } from "nextra/page-map";
import "./globals.css";
import Image from "next/image";

export const metadata: Metadata = {
  title: "Core Platform Docs",
  description: "Core Platform Docs",
};

const navbar = (
  <Navbar
    logo={
      <b>
        <Image src="/logo.png" alt="Development team collaborating" width={213} height={23} priority />
      </b>
    }
  />
);
// const footer = (
//   <div className="text-center h-10 bg-neutral-100 dark:bg-neutral-900 w-full text-gray-700">MY FOOTER</div>
// );

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" dir="ltr" suppressHydrationWarning>
      <Head
        color={{
          hue: {
            dark: 211,
            light: 211,
          },
          saturation: {
            dark: 100,
            light: 100,
          },
          lightness: {
            dark: 51,
            light: 51,
          },
        }}
      ></Head>
      <body>
        <Layout
          navbar={navbar}
          pageMap={await getPageMap()}
          docsRepositoryBase="https://github.com/coreeng/core-platform-docs"
        >
          {children}
        </Layout>
      </body>
    </html>
  );
}
