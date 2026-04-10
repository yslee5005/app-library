import Link from "next/link";

export default function Footer() {
  return (
    <footer className="bg-bg-primary border-t border-border">
      <div className="max-w-[1400px] mx-auto px-6 md:px-10 py-16">
        {/* 4-column layout */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-10 md:gap-16">
          {/* Logo + tagline */}
          <div>
            <h3 className="text-white text-lg tracking-[0.15em] font-bold">
              BLACKLABELLED
            </h3>
            <p className="text-text-muted text-sm mt-3">
              Your space is &apos;black label&apos;
            </p>
          </div>

          {/* SNS */}
          <div>
            <h4 className="text-text-muted text-[11px] tracking-[0.2em] uppercase font-bold mb-4">
              SNS
            </h4>
            <div className="flex flex-col gap-3">
              <Link
                href="https://instagram.com/blacklabelled"
                target="_blank"
                className="text-text-secondary text-sm hover:text-white transition-colors"
              >
                Instagram
              </Link>
              <Link
                href="https://youtube.com"
                target="_blank"
                className="text-text-secondary text-sm hover:text-white transition-colors"
              >
                YouTube
              </Link>
              <Link
                href="https://blog.naver.com/blacklabelled"
                target="_blank"
                className="text-text-secondary text-sm hover:text-white transition-colors"
              >
                Blog
              </Link>
            </div>
          </div>

          {/* INFO */}
          <div>
            <h4 className="text-text-muted text-[11px] tracking-[0.2em] uppercase font-bold mb-4">
              INFO
            </h4>
            <div className="flex flex-col gap-3 text-text-secondary text-sm">
              <p>경기도 성남시 분당구 판교로610번길 5</p>
              <p>2층 (주소지1층) 블랙라벨드</p>
              <p>Tel. 010-9887-2826(TR)</p>
              <p>Tel. 010-9046-3487(TD)</p>
              <p>info@blacklabelled.co.kr</p>
            </div>
          </div>

          {/* CONTACT */}
          <div>
            <h4 className="text-text-muted text-[11px] tracking-[0.2em] uppercase font-bold mb-4">
              CONTACT
            </h4>
            <div className="flex flex-col gap-3 text-text-secondary text-sm">
              <p>상담시간: 평일 9:30 – 18:30</p>
              <Link
                href="/contact"
                className="text-white hover:text-text-secondary transition-colors"
              >
                온라인 상담신청 →
              </Link>
            </div>
          </div>
        </div>

        {/* Bottom bar */}
        <div className="mt-16 pt-6 border-t border-border flex flex-col sm:flex-row items-center justify-between gap-4">
          <p className="text-text-muted text-xs">
            © 2026 BLACKLABELLED. All rights reserved.
          </p>
          <div className="flex gap-6">
            <Link
              href="#"
              className="text-text-muted text-xs hover:text-text-secondary transition-colors underline"
            >
              개인정보처리방침
            </Link>
            <Link
              href="#"
              className="text-text-muted text-xs hover:text-text-secondary transition-colors underline"
            >
              이용약관
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}
