import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

// Admin 인증은 layout.tsx에서 클라이언트 사이드로 처리
// (signInWithPassword는 localStorage에 세션 저장 → 서버 쿠키에 없음)
export async function proxy(request: NextRequest) {
  return NextResponse.next();
}

export const config = {
  matcher: ["/admin/:path*"],
};
