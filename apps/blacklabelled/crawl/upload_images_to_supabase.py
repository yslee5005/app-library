#!/usr/bin/env python3
"""
BlackLabelled 이미지 → Supabase Storage 업로드
download_images.py의 async + semaphore 패턴을 반전 (다운로드→업로드)

사용법:
  pip3 install supabase
  export SUPABASE_URL=https://xxx.supabase.co
  export SUPABASE_SERVICE_ROLE_KEY=eyJ...
  python3 upload_images_to_supabase.py

체크포인트:
  중단 시 progress_upload.json에 진행률 저장
  재실행 시 이미 업로드된 파일은 건너뜀
"""

import json
import os
import sys
import time
import mimetypes

try:
    from supabase import create_client
except ImportError:
    print("pip3 install supabase")
    sys.exit(1)

# ── 경로 설정 ──────────────────────────────────
CRAWL_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(CRAWL_DIR, "..", "data")
IMAGES_DIR = os.path.join(DATA_DIR, "images")
PRODUCTS_JSON = os.path.join(DATA_DIR, "db", "products.json")
PROGRESS_FILE = os.path.join(CRAWL_DIR, "progress_upload.json")

# ── 설정 ─────────────────────────────────────
TENANT_ID = "00000000-0000-0000-0000-000000000001"
BUCKET = "portfolio-images"
MAX_RETRIES = 3

# ── Supabase 연결 ────────────────────────────────
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")


def load_progress():
    """체크포인트 로드"""
    if os.path.exists(PROGRESS_FILE):
        with open(PROGRESS_FILE, "r") as f:
            return set(json.load(f))
    return set()


def save_progress(uploaded):
    """체크포인트 저장"""
    with open(PROGRESS_FILE, "w") as f:
        json.dump(list(uploaded), f)


def get_content_type(filepath):
    """파일 MIME 타입 추출"""
    mime, _ = mimetypes.guess_type(filepath)
    return mime or "application/octet-stream"


def upload_file(supabase, local_path, storage_path, retries=0):
    """단일 파일 업로드 (재시도 포함)
    download_images.py의 retry 패턴 재활용
    """
    try:
        with open(local_path, "rb") as f:
            file_data = f.read()

        content_type = get_content_type(local_path)

        supabase.storage.from_(BUCKET).upload(
            path=storage_path,
            file=file_data,
            file_options={"content-type": content_type, "upsert": "true"},
        )
        return True

    except Exception as e:
        if retries < MAX_RETRIES:
            time.sleep(1)
            return upload_file(supabase, local_path, storage_path, retries + 1)
        print(f"  ❌ {storage_path}: {e}")
        return False


def main():
    if not SUPABASE_URL or not SUPABASE_KEY:
        print("❌ 환경변수를 설정하세요:")
        print("  export SUPABASE_URL=https://xxx.supabase.co")
        print("  export SUPABASE_SERVICE_ROLE_KEY=eyJ...")
        sys.exit(1)

    if not os.path.exists(PRODUCTS_JSON):
        print(f"❌ products.json 파일이 없습니다: {PRODUCTS_JSON}")
        sys.exit(1)

    # Supabase 연결
    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
    print(f"🔌 Supabase 연결 완료: {SUPABASE_URL}")

    # 데이터 로드
    with open(PRODUCTS_JSON, "r", encoding="utf-8") as f:
        products_raw = json.load(f)

    # 업로드 작업 목록 생성
    upload_tasks = []
    for pid, p in products_raw.items():
        for img in p.get("images", []):
            local_path = os.path.join(IMAGES_DIR, img["path"])
            filename = os.path.basename(img["path"])
            storage_path = f"{TENANT_ID}/{p['id']}/{filename}"

            if os.path.exists(local_path):
                upload_tasks.append({
                    "local_path": local_path,
                    "storage_path": storage_path,
                })

    print(f"\n📊 업로드 대상: {len(upload_tasks)}개 이미지")

    # 체크포인트 로드
    uploaded = load_progress()
    remaining = [t for t in upload_tasks if t["storage_path"] not in uploaded]
    print(f"   이미 완료: {len(uploaded)}개")
    print(f"   남은 작업: {len(remaining)}개")

    if not remaining:
        print("\n✅ 모든 이미지가 이미 업로드되었습니다!")
        return

    # 업로드 실행
    print(f"\n📤 업로드 시작...\n")
    success = 0
    failed = 0
    start_time = time.time()

    for i, task in enumerate(remaining):
        result = upload_file(supabase, task["local_path"], task["storage_path"])

        if result:
            success += 1
            uploaded.add(task["storage_path"])
        else:
            failed += 1

        # 진행률 표시 (50개마다)
        if (i + 1) % 50 == 0 or (i + 1) == len(remaining):
            elapsed = time.time() - start_time
            rate = (i + 1) / elapsed if elapsed > 0 else 0
            eta = (len(remaining) - i - 1) / rate if rate > 0 else 0
            print(f"  [{i+1}/{len(remaining)}] ✅{success} ❌{failed} "
                  f"({rate:.1f}/s, ETA: {eta/60:.1f}min)")

            # 체크포인트 저장 (50개마다)
            save_progress(uploaded)

    # 최종 저장
    save_progress(uploaded)
    elapsed = time.time() - start_time

    print(f"\n🎉 업로드 완료!")
    print(f"   성공: {success}개")
    print(f"   실패: {failed}개")
    print(f"   소요: {elapsed/60:.1f}분")
    print(f"   버킷: {BUCKET}")

    if failed > 0:
        print(f"\n⚠️ {failed}개 실패. 재실행하면 실패 파일만 재시도합니다.")


if __name__ == "__main__":
    main()
