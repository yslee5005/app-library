"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import Image from "next/image";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import {
  Table,
  TableHeader,
  TableBody,
  TableHead,
  TableRow,
  TableCell,
} from "@/components/ui/table";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import { getImageUrl } from "@/lib/data";
import {
  createMagazine,
  deleteMagazine,
  type AdminMagazine,
} from "@/lib/admin-actions";

interface MagazinesEditorProps {
  initialMagazines: AdminMagazine[];
}

type DialogMode = "create" | "delete" | null;

export default function MagazinesEditor({
  initialMagazines,
}: MagazinesEditorProps) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();
  const [magazines, setMagazines] =
    useState<AdminMagazine[]>(initialMagazines);
  const [dialogMode, setDialogMode] = useState<DialogMode>(null);
  const [selectedId, setSelectedId] = useState<string | null>(null);

  // Form fields (create only)
  const [title, setTitle] = useState("");
  const [summary, setSummary] = useState("");
  const [date, setDate] = useState("");

  const selected = magazines.find((m) => m.id === selectedId);

  const openCreate = () => {
    setDialogMode("create");
    setSelectedId(null);
    setTitle("");
    setSummary("");
    setDate(new Date().toISOString().split("T")[0]);
  };

  const openDelete = (id: string) => {
    setDialogMode("delete");
    setSelectedId(id);
  };

  const closeDialog = () => {
    setDialogMode(null);
    setSelectedId(null);
  };

  const handleCreate = () => {
    startTransition(async () => {
      const fd = new FormData();
      fd.set("title", title);
      fd.set("summary", summary);
      fd.set("date", date);

      const result = await createMagazine(fd);
      if ("error" in result) {
        toast.error(result.error);
      } else {
        toast.success("Magazine created");
        closeDialog();
        router.refresh();
      }
    });
  };

  const handleDelete = () => {
    if (!selectedId) return;
    startTransition(async () => {
      const result = await deleteMagazine(selectedId);
      if ("error" in result) {
        toast.error(result.error);
      } else {
        toast.success("Magazine deleted");
        setMagazines((prev) => prev.filter((m) => m.id !== selectedId));
        closeDialog();
        router.refresh();
      }
    });
  };

  return (
    <>
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <p className="text-sm text-zinc-500">
            {magazines.length} magazine{magazines.length !== 1 ? "s" : ""}
          </p>
          <Button
            onClick={openCreate}
            className="bg-zinc-100 text-zinc-900 hover:bg-zinc-200"
          >
            New Magazine
          </Button>
        </div>

        <div className="rounded-lg border border-zinc-800 overflow-hidden">
          <Table>
            <TableHeader>
              <TableRow className="border-zinc-800 hover:bg-transparent">
                <TableHead className="w-16">Thumb</TableHead>
                <TableHead>Title</TableHead>
                <TableHead>Summary</TableHead>
                <TableHead className="w-24">Status</TableHead>
                <TableHead className="w-28">Date</TableHead>
                <TableHead className="w-24 text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {magazines.length === 0 && (
                <TableRow>
                  <TableCell
                    colSpan={6}
                    className="py-8 text-center text-zinc-600"
                  >
                    No magazines yet.
                  </TableCell>
                </TableRow>
              )}
              {magazines.map((mag) => (
                <TableRow key={mag.id}>
                  <TableCell>
                    <div className="relative h-10 w-10 rounded overflow-hidden bg-zinc-800">
                      {mag.thumbnail_path ? (
                        <Image
                          src={getImageUrl(mag.thumbnail_path)}
                          alt={mag.title}
                          fill
                          className="object-cover"
                          sizes="40px"
                        />
                      ) : (
                        <div className="flex h-full items-center justify-center text-[10px] text-zinc-600">
                          -
                        </div>
                      )}
                    </div>
                  </TableCell>
                  <TableCell className="text-zinc-100 font-medium">
                    {mag.title}
                  </TableCell>
                  <TableCell className="text-zinc-400 max-w-xs truncate">
                    {mag.summary ?? "-"}
                  </TableCell>
                  <TableCell>
                    <div className="flex items-center gap-1">
                      <Badge
                        variant={
                          mag.status === "published" ? "success" : "warning"
                        }
                      >
                        {mag.status === "published" ? "Published" : "Draft"}
                      </Badge>
                      {mag.ai_generated && (
                        <Badge variant="secondary" className="bg-blue-500/10 text-blue-400 border-transparent">
                          AI
                        </Badge>
                      )}
                    </div>
                  </TableCell>
                  <TableCell className="text-zinc-400 tabular-nums">
                    {mag.date?.split("T")[0] ?? "-"}
                  </TableCell>
                  <TableCell className="text-right">
                    <div className="flex items-center justify-end gap-1">
                      <Button
                        variant="ghost"
                        size="xs"
                        onClick={() =>
                          router.push(`/admin/magazines/${mag.id}/edit`)
                        }
                        className="text-zinc-400 hover:text-zinc-200"
                      >
                        Edit
                      </Button>
                      <Button
                        variant="ghost"
                        size="xs"
                        onClick={() => openDelete(mag.id)}
                        className="text-red-400 hover:text-red-300"
                      >
                        Del
                      </Button>
                    </div>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      </div>

      {/* Create Dialog */}
      <Dialog
        open={dialogMode === "create"}
        onOpenChange={(open) => !open && closeDialog()}
      >
        <DialogContent>
          <DialogHeader>
            <DialogTitle>New Magazine</DialogTitle>
            <DialogDescription>
              Create a new magazine entry.
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-4 py-2">
            <div className="space-y-2">
              <Label className="text-zinc-300">Title</Label>
              <Input
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                className="border-zinc-700 bg-zinc-800 text-zinc-100"
                placeholder="Magazine title"
              />
            </div>

            <div className="space-y-2">
              <Label className="text-zinc-300">Summary</Label>
              <Textarea
                value={summary}
                onChange={(e) => setSummary(e.target.value)}
                className="min-h-[80px] border-zinc-700 bg-zinc-800 text-zinc-100"
                placeholder="Brief summary"
              />
            </div>

            <div className="space-y-2">
              <Label className="text-zinc-300">Date</Label>
              <Input
                type="date"
                value={date}
                onChange={(e) => setDate(e.target.value)}
                className="border-zinc-700 bg-zinc-800 text-zinc-100"
              />
            </div>
          </div>

          <DialogFooter>
            <Button
              variant="ghost"
              onClick={closeDialog}
              className="text-zinc-400 hover:text-zinc-200"
            >
              Cancel
            </Button>
            <Button
              onClick={handleCreate}
              disabled={isPending || !title.trim()}
              className="bg-zinc-100 text-zinc-900 hover:bg-zinc-200 disabled:opacity-50"
            >
              {isPending ? "Saving..." : "Create"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Delete Dialog */}
      <Dialog
        open={dialogMode === "delete"}
        onOpenChange={(open) => !open && closeDialog()}
      >
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Delete Magazine</DialogTitle>
            <DialogDescription>
              Are you sure you want to delete &ldquo;
              {selected?.title ?? "this magazine"}&rdquo;? This action
              cannot be undone.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button
              variant="ghost"
              onClick={closeDialog}
              className="text-zinc-400 hover:text-zinc-200"
            >
              Cancel
            </Button>
            <Button
              variant="destructive"
              onClick={handleDelete}
              disabled={isPending}
            >
              {isPending ? "Deleting..." : "Delete"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
