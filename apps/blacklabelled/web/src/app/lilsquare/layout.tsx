import LilsquareNav from "@/components/lilsquare/LilsquareNav";
import LilsquareFooter from "@/components/lilsquare/LilsquareFooter";

export default function LilsquareLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <>
      <LilsquareNav />
      <main className="flex-1">{children}</main>
      <LilsquareFooter />
    </>
  );
}
