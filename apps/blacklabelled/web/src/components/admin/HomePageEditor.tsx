"use client";

import { useState, useTransition, useEffect } from "react";
import { useRouter } from "next/navigation";
import Image from "next/image";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select } from "@/components/ui/select";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { getImageUrl } from "@/lib/data";
import {
  updatePageContent,
  getProductImages,
} from "@/lib/admin-actions";
import ImagePicker from "./ImagePicker";

interface ProductOption {
  id: string;
  slug: string;
  name: string;
  main_image: string | null;
}

interface ProductImageOption {
  id: string;
  storage_path: string;
  type: string;
  sort_order: number;
}

interface HomePageEditorProps {
  initialContent: Record<string, any> | null;
  products: ProductOption[];
}

export default function HomePageEditor({
  initialContent,
  products,
}: HomePageEditorProps) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();

  // Hero
  const [heroProductSlug, setHeroProductSlug] = useState(
    initialContent?.hero?.product_slug ?? ""
  );
  const [heroImagePath, setHeroImagePath] = useState(
    initialContent?.hero?.image_path ?? ""
  );
  const [heroTitle, setHeroTitle] = useState(
    initialContent?.hero?.title ?? ""
  );
  const [heroSubtitle, setHeroSubtitle] = useState(
    initialContent?.hero?.subtitle ?? ""
  );

  // Image data for hero picker
  const [heroImages, setHeroImages] = useState<{ images: ProductImageOption[]; total: number }>({ images: [], total: 0 });
  const [loadingHero, setLoadingHero] = useState(false);

  // Carousel
  const [carouselSlugs, setCarouselSlugs] = useState<string[]>(
    initialContent?.carousel?.product_slugs ?? []
  );
  const [carouselImagePaths, setCarouselImagePaths] = useState<string[]>(
    initialContent?.carousel?.image_paths ?? []
  );
  const [carouselImages, setCarouselImages] = useState<Record<number, { images: ProductImageOption[]; total: number }>>({});
  const [carouselLoading, setCarouselLoading] = useState<Record<number, boolean>>({});

  // Grid (Projects)
  const [gridMaxCount, setGridMaxCount] = useState(
    initialContent?.grid?.max_count ?? 12
  );

  // Magazine
  const [magazineMaxCount, setMagazineMaxCount] = useState(
    initialContent?.magazine?.max_count ?? 4
  );

  // Find selected products
  const heroProduct = products.find((p) => p.slug === heroProductSlug);

  // Fetch first 4 images for hero
  useEffect(() => {
    if (heroProduct) {
      setLoadingHero(true);
      getProductImages(heroProduct.id, 0, 4)
        .then(setHeroImages)
        .catch(() => setHeroImages({ images: [], total: 0 }))
        .finally(() => setLoadingHero(false));
    } else {
      setHeroImages({ images: [], total: 0 });
    }
  }, [heroProduct?.id]);

  // Fetch carousel product images
  const fetchCarouselImages = async (index: number, productId: string) => {
    setCarouselLoading((prev) => ({ ...prev, [index]: true }));
    try {
      const result = await getProductImages(productId, 0, 4);
      setCarouselImages((prev) => ({ ...prev, [index]: result }));
    } catch {
      setCarouselImages((prev) => ({ ...prev, [index]: { images: [], total: 0 } }));
    } finally {
      setCarouselLoading((prev) => ({ ...prev, [index]: false }));
    }
  };

  // Load images for existing carousel selections on mount
  useEffect(() => {
    carouselSlugs.forEach((slug, i) => {
      const product = products.find((p) => p.slug === slug);
      if (product && !carouselImages[i]) {
        fetchCarouselImages(i, product.id);
      }
    });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleProductChange = (slug: string) => {
    setHeroProductSlug(slug);
    setHeroImagePath(""); // Reset image selection when product changes
  };

  const handleSave = () => {
    startTransition(async () => {
      const content = {
        hero: {
          product_slug: heroProductSlug,
          image_path: heroImagePath,
          title: heroTitle,
          subtitle: heroSubtitle,
        },
        carousel: {
          product_slugs: carouselSlugs.filter(Boolean),
          image_paths: carouselImagePaths,
        },
        grid: {
          max_count: gridMaxCount,
        },
        magazine: {
          max_count: magazineMaxCount,
        },
      };

      const result = await updatePageContent("home", content);
      if ("error" in result) {
        toast.error(result.error);
      } else {
        toast.success("Home page settings saved");
        router.refresh();
      }
    });
  };

  // Preview URL for selected image
  const previewImageUrl = heroImagePath
    ? getImageUrl(heroImagePath)
    : heroProduct?.main_image
      ? getImageUrl(heroProduct.main_image)
      : "";

  return (
    <div className="space-y-6">
      {/* Hero Section */}
      <Card className="border-zinc-800 bg-zinc-900">
        <CardHeader>
          <CardTitle className="text-zinc-100">Hero Section</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label className="text-zinc-300">Featured Project</Label>
            <Select
              value={heroProductSlug}
              onChange={(e) => handleProductChange(e.target.value)}
              className="border-zinc-700 bg-zinc-800 text-zinc-100"
            >
              <option value="">Select a project...</option>
              {products.map((p) => (
                <option key={p.id} value={p.slug}>
                  {p.name}
                </option>
              ))}
            </Select>
          </div>

          {/* Product Image Grid */}
          {heroProduct && (
            <div className="space-y-2">
              <Label className="text-zinc-300">Hero Image</Label>
              {loadingHero ? (
                <p className="text-sm text-zinc-500">Loading images...</p>
              ) : heroImages.total === 0 ? (
                <p className="text-sm text-zinc-500">No images found for this project.</p>
              ) : (
                <ImagePicker
                  productId={heroProduct.id}
                  initialImages={heroImages.images}
                  initialTotal={heroImages.total}
                  selectedPath={heroImagePath}
                  onSelect={setHeroImagePath}
                />
              )}
            </div>
          )}

          {/* Selected Image Preview */}
          {previewImageUrl && (
            <div className="space-y-2">
              <Label className="text-zinc-300">Preview</Label>
              <div className="relative w-full aspect-video rounded-lg overflow-hidden border border-zinc-700">
                <Image
                  src={previewImageUrl}
                  alt="Hero preview"
                  fill
                  className="object-cover"
                  sizes="(max-width: 672px) 100vw, 672px"
                />
              </div>
            </div>
          )}

          {!previewImageUrl && heroProduct && (
            <p className="text-sm text-zinc-500">
              No image selected. Select an image above or the project&apos;s main image will be used.
            </p>
          )}

          <div className="space-y-2">
            <Label className="text-zinc-300">Title</Label>
            <Input
              value={heroTitle}
              onChange={(e) => setHeroTitle(e.target.value)}
              className="border-zinc-700 bg-zinc-800 text-zinc-100"
              placeholder="Hero title"
            />
          </div>

          <div className="space-y-2">
            <Label className="text-zinc-300">Subtitle</Label>
            <Input
              value={heroSubtitle}
              onChange={(e) => setHeroSubtitle(e.target.value)}
              className="border-zinc-700 bg-zinc-800 text-zinc-100"
              placeholder="Hero subtitle"
            />
          </div>
        </CardContent>
      </Card>

      {/* Carousel Section */}
      <Card className="border-zinc-800 bg-zinc-900">
        <CardHeader>
          <CardTitle className="text-zinc-100">Carousel Section</CardTitle>
        </CardHeader>
        <CardContent className="space-y-6">
          <p className="text-sm text-zinc-500">
            Select up to 5 projects for the fullscreen carousel. Leave empty to use latest projects.
          </p>
          {[0, 1, 2, 3, 4].map((i) => {
            const slug = carouselSlugs[i] ?? "";
            const carouselProduct = slug ? products.find((p) => p.slug === slug) : undefined;
            const imgData = carouselImages[i];

            return (
              <div key={i} className="space-y-3 pb-4 border-b border-zinc-800 last:border-0">
                <div className="flex items-center gap-3">
                  <span className="text-zinc-500 text-sm w-4 font-medium">{i + 1}.</span>
                  <Select
                    value={slug}
                    onChange={(e) => {
                      const newSlug = e.target.value;
                      setCarouselSlugs((prev) => {
                        const next = [...prev];
                        next[i] = newSlug;
                        return next;
                      });
                      // Reset image for this slot
                      setCarouselImagePaths((prev) => {
                        const next = [...prev];
                        next[i] = "";
                        return next;
                      });
                      // Fetch images
                      const product = products.find((p) => p.slug === newSlug);
                      if (product) {
                        fetchCarouselImages(i, product.id);
                      } else {
                        setCarouselImages((prev) => {
                          const next = { ...prev };
                          delete next[i];
                          return next;
                        });
                      }
                    }}
                    className="flex-1 border-zinc-700 bg-zinc-800 text-zinc-100"
                  >
                    <option value="">Select project...</option>
                    {products.map((p) => (
                      <option key={p.id} value={p.slug}>{p.name}</option>
                    ))}
                  </Select>
                  {slug && (
                    <button
                      type="button"
                      onClick={() => {
                        setCarouselSlugs((prev) => { const n = [...prev]; n.splice(i, 1); return n; });
                        setCarouselImagePaths((prev) => { const n = [...prev]; n.splice(i, 1); return n; });
                        setCarouselImages((prev) => { const n = { ...prev }; delete n[i]; return n; });
                      }}
                      className="text-zinc-500 hover:text-red-400 text-sm"
                    >
                      ✕
                    </button>
                  )}
                </div>

                {/* Image picker for this carousel slot */}
                {carouselProduct && (
                  <>
                    {carouselLoading[i] ? (
                      <p className="text-sm text-zinc-500 ml-7">Loading images...</p>
                    ) : imgData && imgData.total > 0 ? (
                      <div className="ml-7">
                        <ImagePicker
                          productId={carouselProduct.id}
                          initialImages={imgData.images}
                          initialTotal={imgData.total}
                          selectedPath={carouselImagePaths[i] ?? ""}
                          onSelect={(path) => {
                            setCarouselImagePaths((prev) => {
                              const next = [...prev];
                              next[i] = path;
                              return next;
                            });
                          }}
                        />
                      </div>
                    ) : null}

                    {/* Preview */}
                    {(carouselImagePaths[i] || carouselProduct.main_image) && (
                      <div className="ml-7 relative w-full aspect-video rounded-lg overflow-hidden border border-zinc-700">
                        <Image
                          src={getImageUrl(carouselImagePaths[i] || carouselProduct.main_image || "")}
                          alt={`Carousel ${i + 1} preview`}
                          fill
                          className="object-cover"
                          sizes="600px"
                        />
                      </div>
                    )}
                  </>
                )}
              </div>
            );
          })}
        </CardContent>
      </Card>

      {/* Projects Section */}
      <Card className="border-zinc-800 bg-zinc-900">
        <CardHeader>
          <CardTitle className="text-zinc-100">Projects Section</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-2">
            <Label className="text-zinc-300">Max Projects to Show</Label>
            <Input
              type="number"
              value={gridMaxCount}
              onChange={(e) =>
                setGridMaxCount(parseInt(e.target.value, 10) || 0)
              }
              className="w-24 border-zinc-700 bg-zinc-800 text-zinc-100"
              min={1}
              max={50}
            />
          </div>
        </CardContent>
      </Card>

      {/* Magazine Section */}
      <Card className="border-zinc-800 bg-zinc-900">
        <CardHeader>
          <CardTitle className="text-zinc-100">Magazine Section</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-2">
            <Label className="text-zinc-300">Max Magazines to Show</Label>
            <Input
              type="number"
              value={magazineMaxCount}
              onChange={(e) =>
                setMagazineMaxCount(parseInt(e.target.value, 10) || 0)
              }
              className="w-24 border-zinc-700 bg-zinc-800 text-zinc-100"
              min={1}
              max={20}
            />
          </div>
        </CardContent>
      </Card>

      {/* Save */}
      <div className="flex items-center gap-3">
        <Button
          onClick={handleSave}
          disabled={isPending}
          className="bg-zinc-100 text-zinc-900 hover:bg-zinc-200 disabled:opacity-50"
        >
          {isPending ? "Saving..." : "Save Settings"}
        </Button>
      </div>
    </div>
  );
}
