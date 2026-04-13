import { notFound } from "next/navigation";
import { getAdminMagazine } from "@/lib/admin-actions";
import MagazineEditClient from "./MagazineEditClient";

interface Props {
  params: Promise<{ id: string }>;
}

export default async function MagazineEditPage({ params }: Props) {
  const { id } = await params;
  const magazine = await getAdminMagazine(id);

  if (!magazine) {
    notFound();
  }

  return <MagazineEditClient magazine={magazine} />;
}
