import { getMagazines, getImageUrl } from "@/lib/data";
import type { Metadata } from "next";
import Image from "next/image";
import Link from "next/link";

export const dynamic = "force-dynamic";

export const metadata: Metadata = {
  title: "MAGAZINE | BLACKLABELLED",
  description:
    "블랙라벨드 매거진 — 인테리어 트렌드, 디자인 인사이트, 공간 이야기.",
  openGraph: {
    title: "BLACKLABELLED — Magazine",
    description: "인테리어 트렌드와 디자인 인사이트를 만나보세요.",
  },
};

export default async function MagazinesPage() {
  const magazines = await getMagazines();

  return (
    <section className="pt-32 pb-20 px-6 md:px-10">
      <div className="max-w-7xl mx-auto">
        <h1 className="font-heading text-5xl md:text-[60px] text-text-primary font-light tracking-wider text-center">
          MAGAZINE
        </h1>
        <p className="text-text-muted text-sm tracking-wider text-center mt-3 font-body">
          {magazines.length} articles
        </p>

        {magazines.length === 0 ? (
          <p className="text-text-muted text-center mt-20 font-body">
            Coming soon.
          </p>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mt-16">
            {magazines.filter((m) => m.slug).map((magazine) => {
              const href = `/magazines/${magazine.slug}`;
              const thumbnailUrl = magazine.thumbnail_path
                ? getImageUrl(magazine.thumbnail_path)
                : null;
              const dateStr = magazine.date
                ? new Date(magazine.date).toLocaleDateString("ko-KR", {
                    year: "numeric",
                    month: "long",
                    day: "numeric",
                  })
                : null;

              return (
                <Link
                  key={magazine.id}
                  href={href}
                  className="group block bg-bg-card rounded-sm overflow-hidden border border-border hover:border-text-muted transition-all duration-300"
                >
                  {/* Thumbnail */}
                  <div className="relative w-full aspect-[16/9] bg-bg-secondary overflow-hidden">
                    {thumbnailUrl ? (
                      <Image
                        src={thumbnailUrl}
                        alt={magazine.title}
                        fill
                        className="object-cover group-hover:scale-105 transition-transform duration-500"
                        sizes="(max-width: 768px) 100vw, 50vw"
                      />
                    ) : (
                      <div className="absolute inset-0 flex items-center justify-center">
                        <span className="text-text-muted text-4xl font-heading tracking-widest">
                          BL
                        </span>
                      </div>
                    )}
                  </div>

                  {/* Content */}
                  <div className="p-6">
                    {/* Tags */}
                    {magazine.tags && magazine.tags.length > 0 && (
                      <div className="flex flex-wrap gap-2 mb-3">
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

                    <h2 className="text-lg font-body font-bold text-text-primary group-hover:text-white transition-colors duration-300 line-clamp-2">
                      {magazine.title}
                    </h2>

                    {magazine.summary && (
                      <p className="text-text-secondary text-sm mt-2 font-body line-clamp-2 leading-relaxed">
                        {magazine.summary}
                      </p>
                    )}

                    {dateStr && (
                      <p className="text-text-muted text-xs mt-4 tracking-wider font-body">
                        {dateStr}
                      </p>
                    )}
                  </div>
                </Link>
              );
            })}
          </div>
        )}
      </div>
    </section>
  );
}
