import { getMagazineBySlug } from "@/lib/data";
import { notFound } from "next/navigation";
import type { Metadata } from "next";
import Link from "next/link";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ slug: string }>;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { slug } = await params;
  const magazine = await getMagazineBySlug(decodeURIComponent(slug));
  if (!magazine) return { title: "Not Found" };

  return {
    title: `${magazine.title} | BLACKLABELLED`,
    description:
      magazine.summary || `${magazine.title} — 블랙라벨드 매거진`,
    openGraph: {
      title: magazine.title,
      description:
        magazine.summary || `${magazine.title} — 인테리어 매거진`,
    },
  };
}

export default async function MagazineDetailPage({ params }: PageProps) {
  const { slug } = await params;
  const magazine = await getMagazineBySlug(decodeURIComponent(slug));
  if (!magazine) notFound();

  const dateStr = magazine.date
    ? new Date(magazine.date).toLocaleDateString("ko-KR", {
        year: "numeric",
        month: "long",
        day: "numeric",
      })
    : null;

  return (
    <section className="pt-32 pb-20 px-6 md:px-10">
      <div className="max-w-7xl mx-auto">
        {/* Back link */}
        <Link
          href="/magazines"
          className="inline-flex items-center gap-2 text-text-muted text-sm tracking-wider hover:text-text-primary transition-colors duration-300 mb-12 font-body"
        >
          <span>&larr;</span>
          <span>MAGAZINE</span>
        </Link>

        {/* Header */}
        <div className="text-center mb-12">
          {/* Tags */}
          {magazine.tags && magazine.tags.length > 0 && (
            <div className="flex flex-wrap justify-center gap-2 mb-4">
              {magazine.tags.map((tag) => (
                <span
                  key={tag}
                  className="text-[11px] tracking-wider text-text-muted border border-border px-2 py-0.5 rounded-sm"
                >
                  {tag}
                </span>
              ))}
            </div>
          )}

          <h1 className="font-heading text-3xl md:text-4xl lg:text-5xl text-text-primary font-light tracking-wider leading-tight">
            {magazine.title}
          </h1>

          {dateStr && (
            <p className="text-text-muted text-sm mt-4 tracking-wider font-body">
              {dateStr}
            </p>
          )}

          {magazine.summary && (
            <p className="text-text-secondary text-base mt-6 font-body max-w-2xl mx-auto leading-relaxed">
              {magazine.summary}
            </p>
          )}
        </div>

        {/* Divider */}
        <div className="w-16 h-[1px] bg-border mx-auto mb-12" />

        {/* HTML Content */}
        {magazine.html_content && (
          <div className="max-w-[700px] mx-auto">
            <div
              className="magazine-content bg-white rounded-sm p-6 md:p-10"
              style={{
                fontFamily: "'Noto Sans KR', 'NanumSquare', sans-serif",
                lineHeight: 1.8,
                color: "#222",
              }}
              dangerouslySetInnerHTML={{ __html: magazine.html_content }}
            />
          </div>
        )}

        {/* Bottom back link */}
        <div className="text-center mt-16">
          <Link
            href="/magazines"
            className="inline-flex items-center gap-2 text-text-muted text-sm tracking-wider hover:text-text-primary transition-colors duration-300 font-body"
          >
            <span>&larr;</span>
            <span>Back to Magazine</span>
          </Link>
        </div>
      </div>
    </section>
  );
}
