#!/usr/bin/env python3
"""
BlackLabelled 데이터 → Supabase 마이그레이션
기존 convert_to_db.py + organize_data.py 패턴 재활용

사용법:
  pip3 install supabase
  export SUPABASE_URL=https://xxx.supabase.co
  export SUPABASE_SERVICE_ROLE_KEY=eyJ...
  python3 migrate_to_supabase.py
"""

import json
import os
import sys

try:
    from supabase import create_client
except ImportError:
    print("pip3 install supabase")
    sys.exit(1)

# ── 경로 설정 ──────────────────────────────────
CRAWL_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(CRAWL_DIR, "..", "data", "db")

PRODUCTS_JSON = os.path.join(DATA_DIR, "products.json")
CATEGORIES_JSON = os.path.join(DATA_DIR, "categories.json")
MANIFEST_JSON = os.path.join(DATA_DIR, "manifest.json")

# ── 테넌트 ID (seed SQL과 일치) ──────────────────
TENANT_ID = "00000000-0000-0000-0000-000000000001"
SCHEMA = "blacklabelled"

# ── Supabase 연결 ────────────────────────────────
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")


def load_json(path):
    """JSON 파일 로드 (UTF-8)"""
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def migrate_categories(supabase, categories_raw):
    """categories.json → blacklabelled.categories INSERT
    부모 카테고리를 먼저 삽입 (parent_id 순서)
    """
    print("\n📂 카테고리 마이그레이션...")

    # 부모 없는 것(root) 먼저, 그다음 자식
    parents = []
    children = []
    for cid, c in categories_raw.items():
        row = {
            "id": c["id"],
            "tenant_id": TENANT_ID,
            "name": c["name"],
            "slug": c["name"].lower().replace(" ", "_"),
            "parent_id": None,  # 먼저 NULL로 삽입
            "description": None,
            "is_visible": c.get("product_count", 0) > 0,
            "sort_order": 0,
        }
        if c.get("parent_id") is None:
            parents.append(row)
        else:
            children.append((row, c["parent_id"]))

    # 1단계: 모든 카테고리 삽입 (parent_id = NULL)
    all_rows = parents + [row for row, _ in children]
    for row in all_rows:
        supabase.schema(SCHEMA).table("categories").upsert(row).execute()

    # 2단계: 자식 카테고리 parent_id 업데이트
    for row, parent_id in children:
        supabase.schema(SCHEMA).table("categories").update(
            {"parent_id": parent_id}
        ).eq("id", row["id"]).execute()

    print(f"  ✅ {len(all_rows)}개 카테고리 완료")
    return len(all_rows)


def migrate_products(supabase, products_raw):
    """products.json → blacklabelled.products INSERT
    재활용: convert_to_db.py의 정규화 로직
    """
    print("\n📦 상품 마이그레이션...")

    count = 0
    batch = []
    for pid, p in products_raw.items():
        meta = p.get("meta", {})
        row = {
            "id": p["id"],
            "tenant_id": TENANT_ID,
            "name": p["name"],
            "slug": p["slug"],
            "description": p.get("description", ""),
            "price": p.get("price", 0),
            "status": "published",  # 기존 데이터는 전부 공개
            "main_category_id": p.get("main_category"),
            "source_url": p.get("source_url", ""),
            "meta_title": (meta.get("ogTitle") or "")[:70] or None,
            "meta_description": (meta.get("ogDescription") or "")[:160] or None,
            "published_at": "now()",
        }
        batch.append(row)
        count += 1

        # 50개씩 배치 upsert
        if len(batch) >= 50:
            supabase.schema(SCHEMA).table("products").upsert(batch).execute()
            print(f"  ... {count}개 처리")
            batch = []

    # 나머지
    if batch:
        supabase.schema(SCHEMA).table("products").upsert(batch).execute()

    print(f"  ✅ {count}개 상품 완료")
    return count


def migrate_product_categories(supabase, products_raw):
    """products.categories[] 배열 → blacklabelled.product_categories M:N INSERT"""
    print("\n🔗 상품-카테고리 관계 마이그레이션...")

    count = 0
    batch = []
    for pid, p in products_raw.items():
        for cat_id in p.get("categories", []):
            batch.append({
                "product_id": p["id"],
                "category_id": cat_id,
            })
            count += 1

            if len(batch) >= 100:
                supabase.schema(SCHEMA).table("product_categories").upsert(batch).execute()
                batch = []

    if batch:
        supabase.schema(SCHEMA).table("product_categories").upsert(batch).execute()

    print(f"  ✅ {count}개 관계 완료")
    return count


def migrate_product_images(supabase, products_raw):
    """products.json의 images[] → blacklabelled.product_images INSERT
    재활용: convert_to_db.py의 이미지 분리 로직
    storage_path = {tenant_id}/{product_id}/{filename}
    """
    print("\n🖼️ 이미지 메타데이터 마이그레이션...")

    count = 0
    batch = []
    for pid, p in products_raw.items():
        for img in p.get("images", []):
            # 파일명 추출: path의 마지막 부분
            filename = os.path.basename(img["path"])

            row = {
                "product_id": p["id"],
                "tenant_id": TENANT_ID,
                "type": img["type"],
                "sort_order": img["order"],
                "storage_path": f"{TENANT_ID}/{p['id']}/{filename}",
                "original_url": img.get("original_url", ""),
                "original_filename": img.get("original_filename", ""),
                "alt_text": None,
                "width": img.get("width", 0) or None,
                "height": img.get("height", 0) or None,
                "file_size": None,
            }
            batch.append(row)
            count += 1

            if len(batch) >= 100:
                supabase.schema(SCHEMA).table("product_images").insert(batch).execute()
                batch = []

    if batch:
        supabase.schema(SCHEMA).table("product_images").insert(batch).execute()

    print(f"  ✅ {count}개 이미지 메타 완료")
    return count


def main():
    if not SUPABASE_URL or not SUPABASE_KEY:
        print("❌ 환경변수를 설정하세요:")
        print("  export SUPABASE_URL=https://xxx.supabase.co")
        print("  export SUPABASE_SERVICE_ROLE_KEY=eyJ...")
        sys.exit(1)

    # 데이터 파일 확인
    for path, name in [(PRODUCTS_JSON, "products.json"), (CATEGORIES_JSON, "categories.json")]:
        if not os.path.exists(path):
            print(f"❌ {name} 파일이 없습니다: {path}")
            sys.exit(1)

    # Supabase 연결
    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
    print(f"🔌 Supabase 연결 완료: {SUPABASE_URL}")

    # 데이터 로드
    products_raw = load_json(PRODUCTS_JSON)
    categories_raw = load_json(CATEGORIES_JSON)

    print(f"\n📊 소스 데이터:")
    print(f"   상품: {len(products_raw)}개")
    print(f"   카테고리: {len(categories_raw)}개")
    total_images = sum(len(p.get("images", [])) for p in products_raw.values())
    print(f"   이미지: {total_images}개")

    # 마이그레이션 실행 (순서 중요: FK 의존성)
    cat_count = migrate_categories(supabase, categories_raw)
    prod_count = migrate_products(supabase, products_raw)
    rel_count = migrate_product_categories(supabase, products_raw)
    img_count = migrate_product_images(supabase, products_raw)

    print(f"\n🎉 마이그레이션 완료!")
    print(f"   카테고리: {cat_count}")
    print(f"   상품: {prod_count}")
    print(f"   상품-카테고리: {rel_count}")
    print(f"   이미지 메타: {img_count}")


if __name__ == "__main__":
    main()
