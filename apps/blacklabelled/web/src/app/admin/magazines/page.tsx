import Link from "next/link";
import MagazinesEditor from "@/components/admin/MagazinesEditor";
import { getAdminMagazines } from "@/lib/admin-actions";

export default async function MagazinesPage() {
  const magazines = await getAdminMagazines();

  return (
    <div>
      <div className="mb-6 flex items-center justify-between">
        <h1 className="text-2xl font-bold text-zinc-100">Magazines</h1>
        <Link
          href="/admin/magazines/new"
          className="inline-flex h-8 items-center justify-center rounded-lg bg-zinc-100 px-3 text-sm font-medium text-zinc-900 transition-colors hover:bg-zinc-200"
        >
          + AI Magazine
        </Link>
      </div>
      <MagazinesEditor initialMagazines={magazines} />
    </div>
  );
}
