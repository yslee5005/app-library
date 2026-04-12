import Link from "next/link";
import Image from "next/image";
import { Suspense } from "react";

import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import ProductsToolbar from "@/components/admin/ProductsToolbar";
import {
  getAdminProducts,
  getAdminCategories,
} from "@/lib/admin-actions";
import { getImageUrl } from "@/lib/data";

const ITEMS_PER_PAGE = 10;

export default async function ProductsPage({
  searchParams,
}: {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}) {
  const params = await searchParams;
  const page = Number(params.page ?? "1");
  const search = typeof params.search === "string" ? params.search : "";
  const categoryId =
    typeof params.category === "string" ? params.category : "";

  const [{ products, total }, categories] = await Promise.all([
    getAdminProducts({
      page,
      search: search || undefined,
      categoryId: categoryId || undefined,
      limit: ITEMS_PER_PAGE,
    }),
    getAdminCategories(),
  ]);

  const totalPages = Math.ceil(total / ITEMS_PER_PAGE);

  // Build pagination URLs
  const buildPageUrl = (p: number) => {
    const sp = new URLSearchParams();
    if (p > 1) sp.set("page", String(p));
    if (search) sp.set("search", search);
    if (categoryId) sp.set("category", categoryId);
    const qs = sp.toString();
    return `/admin/products${qs ? `?${qs}` : ""}`;
  };

  return (
    <div>
      {/* Header */}
      <div className="mb-6 flex items-center justify-between">
        <h1 className="text-2xl font-bold text-zinc-100">Projects</h1>
        <Link href="/admin/products/new">
          <Button className="bg-zinc-100 text-zinc-900 hover:bg-zinc-200">
            New Project
          </Button>
        </Link>
      </div>

      {/* Toolbar: search + category filter */}
      <div className="mb-6">
        <Suspense>
          <ProductsToolbar
            categories={categories.map((c) => ({
              id: c.id,
              name: c.name,
              parent_name: c.parent_name,
            }))}
          />
        </Suspense>
      </div>

      {/* Table */}
      <div className="rounded-lg border border-zinc-800 bg-zinc-900">
        <Table>
          <TableHeader>
            <TableRow className="border-zinc-800 hover:bg-transparent">
              <TableHead className="w-[60px]">Image</TableHead>
              <TableHead>Name</TableHead>
              <TableHead>Category</TableHead>
              <TableHead>Status</TableHead>
              <TableHead className="text-right">Images</TableHead>
              <TableHead>Created</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {products.length === 0 ? (
              <TableRow>
                <TableCell
                  colSpan={6}
                  className="h-24 text-center text-zinc-500"
                >
                  No projects found.
                </TableCell>
              </TableRow>
            ) : (
              products.map((product) => (
                <TableRow key={product.id}>
                  <TableCell>
                    {product.main_image ? (
                      <div className="relative h-10 w-10 overflow-hidden rounded-md bg-zinc-800">
                        <Image
                          src={getImageUrl(product.main_image)}
                          alt={product.name}
                          fill
                          className="object-cover"
                          sizes="40px"
                        />
                      </div>
                    ) : (
                      <div className="flex h-10 w-10 items-center justify-center rounded-md bg-zinc-800 text-zinc-600 text-xs">
                        N/A
                      </div>
                    )}
                  </TableCell>
                  <TableCell>
                    <Link
                      href={`/admin/products/${product.id}/edit`}
                      className="font-medium text-zinc-100 hover:text-zinc-300 hover:underline"
                    >
                      {product.name}
                    </Link>
                  </TableCell>
                  <TableCell className="text-zinc-400">
                    {product.main_category_name ?? "-"}
                  </TableCell>
                  <TableCell>
                    <Badge
                      variant={
                        product.status === "published" ? "success" : "warning"
                      }
                    >
                      {product.status}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-right text-zinc-400">
                    {product.image_count}
                  </TableCell>
                  <TableCell className="text-zinc-500">
                    {new Date(product.created_at).toLocaleDateString()}
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="mt-4 flex items-center justify-between">
          <p className="text-sm text-zinc-500">
            Page {page} of {totalPages} ({total} projects)
          </p>
          <div className="flex gap-2">
            {page > 1 && (
              <Link href={buildPageUrl(page - 1)}>
                <Button
                  variant="outline"
                  size="sm"
                  className="border-zinc-700 text-zinc-300 hover:bg-zinc-800"
                >
                  Previous
                </Button>
              </Link>
            )}
            {page < totalPages && (
              <Link href={buildPageUrl(page + 1)}>
                <Button
                  variant="outline"
                  size="sm"
                  className="border-zinc-700 text-zinc-300 hover:bg-zinc-800"
                >
                  Next
                </Button>
              </Link>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
