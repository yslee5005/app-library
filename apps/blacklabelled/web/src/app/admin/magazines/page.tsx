import MagazinesEditor from "@/components/admin/MagazinesEditor";
import { getAdminMagazines } from "@/lib/admin-actions";

export default async function MagazinesPage() {
  const magazines = await getAdminMagazines();

  return (
    <div>
      <h1 className="mb-6 text-2xl font-bold text-zinc-100">Magazines</h1>
      <MagazinesEditor initialMagazines={magazines} />
    </div>
  );
}
