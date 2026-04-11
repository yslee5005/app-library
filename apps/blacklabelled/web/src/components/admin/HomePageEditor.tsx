"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import Image from "next/image";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Select } from "@/components/ui/select";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { getImageUrl } from "@/lib/data";
import { updatePageContent, type AdminProduct } from "@/lib/admin-actions";

interface ProductOption {
  id: string;
  slug: string;
  name: string;
  main_image: string | null;
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
  const [heroTitle, setHeroTitle] = useState(
    initialContent?.hero?.title ?? ""
  );
  const [heroSubtitle, setHeroSubtitle] = useState(
    initialContent?.hero?.subtitle ?? ""
  );

  // Intro
  const [introHeading, setIntroHeading] = useState(
    initialContent?.intro?.heading ?? ""
  );
  const [introDescription, setIntroDescription] = useState(
    initialContent?.intro?.description ?? ""
  );
  const [introLinkText, setIntroLinkText] = useState(
    initialContent?.intro?.link_text ?? ""
  );
  const [introLinkUrl, setIntroLinkUrl] = useState(
    initialContent?.intro?.link_url ?? ""
  );
  const [introProject1Slug, setIntroProject1Slug] = useState(
    initialContent?.intro?.project1_slug ?? ""
  );
  const [introProject2Slug, setIntroProject2Slug] = useState(
    initialContent?.intro?.project2_slug ?? ""
  );

  // Grid
  const [gridMaxCount, setGridMaxCount] = useState(
    initialContent?.grid?.max_count ?? 12
  );

  // Find selected hero product for preview
  const heroProduct = products.find((p) => p.slug === heroProductSlug);
  const heroImageUrl = heroProduct?.main_image
    ? getImageUrl(heroProduct.main_image)
    : "";

  const handleSave = () => {
    startTransition(async () => {
      const content = {
        hero: {
          product_slug: heroProductSlug,
          title: heroTitle,
          subtitle: heroSubtitle,
        },
        intro: {
          heading: introHeading,
          description: introDescription,
          link_text: introLinkText,
          link_url: introLinkUrl,
          project1_slug: introProject1Slug,
          project2_slug: introProject2Slug,
        },
        grid: {
          max_count: gridMaxCount,
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

  return (
    <div className="space-y-6">
      {/* Hero Section */}
      <Card className="border-zinc-800 bg-zinc-900">
        <CardHeader>
          <CardTitle className="text-zinc-100">Hero Section</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label className="text-zinc-300">Featured Product</Label>
            <Select
              value={heroProductSlug}
              onChange={(e) => setHeroProductSlug(e.target.value)}
              className="border-zinc-700 bg-zinc-800 text-zinc-100"
            >
              <option value="">Select a product...</option>
              {products.map((p) => (
                <option key={p.id} value={p.slug}>
                  {p.name}
                </option>
              ))}
            </Select>
            {heroImageUrl && (
              <div className="mt-2 relative h-32 w-48 rounded-lg overflow-hidden border border-zinc-700">
                <Image
                  src={heroImageUrl}
                  alt="Hero preview"
                  fill
                  className="object-cover"
                  sizes="192px"
                />
              </div>
            )}
          </div>

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

      {/* Intro Section */}
      <Card className="border-zinc-800 bg-zinc-900">
        <CardHeader>
          <CardTitle className="text-zinc-100">Intro Section</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label className="text-zinc-300">Heading</Label>
            <Textarea
              value={introHeading}
              onChange={(e) => setIntroHeading(e.target.value)}
              className="min-h-[80px] border-zinc-700 bg-zinc-800 text-zinc-100"
              placeholder="Intro heading"
            />
          </div>

          <div className="space-y-2">
            <Label className="text-zinc-300">Description</Label>
            <Textarea
              value={introDescription}
              onChange={(e) => setIntroDescription(e.target.value)}
              className="min-h-[100px] border-zinc-700 bg-zinc-800 text-zinc-100"
              placeholder="Intro description"
            />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label className="text-zinc-300">Link Text</Label>
              <Input
                value={introLinkText}
                onChange={(e) => setIntroLinkText(e.target.value)}
                className="border-zinc-700 bg-zinc-800 text-zinc-100"
                placeholder="View all"
              />
            </div>
            <div className="space-y-2">
              <Label className="text-zinc-300">Link URL</Label>
              <Input
                value={introLinkUrl}
                onChange={(e) => setIntroLinkUrl(e.target.value)}
                className="border-zinc-700 bg-zinc-800 text-zinc-100"
                placeholder="/projects"
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label className="text-zinc-300">Project 1</Label>
              <Select
                value={introProject1Slug}
                onChange={(e) => setIntroProject1Slug(e.target.value)}
                className="border-zinc-700 bg-zinc-800 text-zinc-100"
              >
                <option value="">Select...</option>
                {products.map((p) => (
                  <option key={p.id} value={p.slug}>
                    {p.name}
                  </option>
                ))}
              </Select>
            </div>
            <div className="space-y-2">
              <Label className="text-zinc-300">Project 2</Label>
              <Select
                value={introProject2Slug}
                onChange={(e) => setIntroProject2Slug(e.target.value)}
                className="border-zinc-700 bg-zinc-800 text-zinc-100"
              >
                <option value="">Select...</option>
                {products.map((p) => (
                  <option key={p.id} value={p.slug}>
                    {p.name}
                  </option>
                ))}
              </Select>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Grid Section */}
      <Card className="border-zinc-800 bg-zinc-900">
        <CardHeader>
          <CardTitle className="text-zinc-100">Grid Section</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-2">
            <Label className="text-zinc-300">Max Products to Show</Label>
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
