import type { Metadata } from "next";
import { Layout, Navbar } from "nextra-theme-docs";
import { Head } from "nextra/components";
import { getPageMap } from "nextra/page-map";
import "./globals.css";
import Image from "next/image";
import { Geist, Geist_Mono } from "next/font/google";
import PostPathToParent from "@/post-path-to-parent";

export const metadata: Metadata = {
  title: "Core Platform Docs",
  description: "Comprehensive documentation for the Core Platform.",
};

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

const navbar = (
  <Navbar
    logo={
      <>
        <Image
          src="/logo.png"
          className="block dark:hidden"
          alt="Development team collaborating"
          width={213}
          height={23}
          priority
        />
        <Image
          src="/logo-dark.png"
          className="hidden dark:block"
          alt="Development team collaborating"
          width={213}
          height={23}
          priority
        />
      </>
    }
  />
);

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" dir="ltr" suppressHydrationWarning>
      <Head
        backgroundColor={{ dark: "#09090b", light: "#fafafa" }}
        color={{
          hue: {
            dark: 216,
            light: 221,
          },
          saturation: {
            dark: 100,
            light: 100,
          },
          lightness: {
            dark: 58,
            light: 46,
          },
        }}
      ></Head>
      <body className={`${geistSans.variable} ${geistMono.variable} antialiased`}>
        <PostPathToParent />
        <Layout
          navbar={navbar}
          pageMap={await getPageMap()}
          docsRepositoryBase="https://github.com/coreeng/core-platform-docs/edit/main"
        >
          {children}
        </Layout>
      </body>
    </html>
  );
}
