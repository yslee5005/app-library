import Link from "next/link";

export default function LilsquareFooter() {
  return (
    <footer className="bg-[#0A0A0A] border-t border-border pt-16 pb-10">
      <div className="max-w-7xl mx-auto px-6 md:px-10">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-10 md:gap-8">
          {/* Column 1: Logo */}
          <div>
            <Link
              href="/lilsquare"
              className="font-heading text-white text-lg tracking-[0.15em] font-bold"
            >
              BLACKLABELLED
            </Link>
            <p className="mt-4 text-text-muted text-sm leading-relaxed">
              Your space is &apos;black label&apos;
            </p>
          </div>

          {/* Column 2: SNS */}
          <div>
            <h4 className="text-gold text-[12px] tracking-[0.2em] font-semibold mb-5">
              SNS
            </h4>
            <ul className="space-y-3">
              <li>
                <Link
                  href="https://instagram.com/blacklabelled"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-text-muted text-sm hover:text-white transition-colors duration-300"
                >
                  Instagram
                </Link>
              </li>
              <li>
                <Link
                  href="https://youtube.com/@blacklabelled"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-text-muted text-sm hover:text-white transition-colors duration-300"
                >
                  YouTube
                </Link>
              </li>
              <li>
                <Link
                  href="https://blog.naver.com/blacklabelled"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-text-muted text-sm hover:text-white transition-colors duration-300"
                >
                  Blog
                </Link>
              </li>
            </ul>
          </div>

          {/* Column 3: INFO */}
          <div>
            <h4 className="text-gold text-[12px] tracking-[0.2em] font-semibold mb-5">
              INFO
            </h4>
            <ul className="space-y-3 text-text-muted text-sm">
              <li>경기도 성남시 분당구</li>
              <li>Tel. 031-000-0000</li>
              <li>info@blacklabelled.co.kr</li>
            </ul>
          </div>

          {/* Column 4: CONTACT */}
          <div>
            <h4 className="text-gold text-[12px] tracking-[0.2em] font-semibold mb-5">
              CONTACT
            </h4>
            <ul className="space-y-3 text-text-muted text-sm">
              <li>상담시간: 평일 9:30 – 18:30</li>
              <li>
                <Link
                  href="/lilsquare/contact"
                  className="text-gold hover:text-gold-light transition-colors duration-300"
                >
                  온라인 상담신청 →
                </Link>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom bar */}
        <div className="mt-12 pt-6 border-t border-border flex flex-col md:flex-row items-center justify-between gap-4">
          <p className="text-text-muted text-xs tracking-wider">
            © 2026 BLACKLABELLED. All rights reserved.
          </p>
          <div className="flex items-center gap-6 text-text-muted text-xs">
            <Link href="/lilsquare/privacy" className="hover:text-white transition-colors duration-300">
              개인정보처리방침
            </Link>
            <Link href="/lilsquare/terms" className="hover:text-white transition-colors duration-300">
              이용약관
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}
