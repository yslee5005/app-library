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
PROJECT_ROOT = os.path.join(CRAWL_DIR, "..", "..", "..")
DATA_DIR = os.path.join(CRAWL_DIR, "..", "data", "db")

PRODUCTS_JSON = os.path.join(DATA_DIR, "products.json")
CATEGORIES_JSON = os.path.join(DATA_DIR, "categories.json")
MANIFEST_JSON = os.path.join(DATA_DIR, "manifest.json")

# ── 설정 ──────────────────────────────────────
TENANT_SLUG = "blacklabelled"
SCHEMA = "blacklabelled"

# ── .env 로드 (프로젝트 루트) ─────────────────────
def load_env(path):
    """프로젝트 .env 파일에서 환경변수 로드"""
    if not os.path.exists(path):
        return
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, val = line.split("=", 1)
            os.environ.setdefault(key.strip(), val.strip())

load_env(os.path.join(PROJECT_ROOT, ".env"))

# ── Supabase 연결 ────────────────────────────────
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")


def get_tenant_id(supabase):
    """slug로 tenant UUID 조회"""
    result = supabase.table("tenants").select("id").eq("slug", TENANT_SLUG).single().execute()
    return result.data["id"]


def load_json(path):
    """JSON 파일 로드 (UTF-8)"""
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def migrate_categories(supabase, tenant_id, categories_raw):
    """categories.json → blacklabelled.categories INSERT
    부모 카테고리를 먼저 삽입 (parent_id 순서)
    old integer ID → new UUID 매핑 반환
    """
    print("\n📂 카테고리 마이그레이션...")

    # old_id → UUID 매핑 테이블
    id_map = {}

    # 부모 없는 것(root) 먼저, 그다음 자식
    parents = []
    children = []
    for cid, c in categories_raw.items():
        old_id = c["id"]
        row = {
            "tenant_id": tenant_id,
            "name": c["name"],
            "slug": c["name"].lower().replace(" ", "_"),
            "parent_id": None,
            "description": None,
            "is_visible": c.get("product_count", 0) > 0,
            "sort_order": 0,
        }
        if c.get("parent_id") is None:
            parents.append((old_id, row))
        else:
            children.append((old_id, row, c["parent_id"]))

    # 1단계: 부모 카테고리 삽입 → UUID 매핑
    for old_id, row in parents:
        result = supabase.schema(SCHEMA).table("categories").insert(row).execute()
        id_map[old_id] = result.data[0]["id"]

    # 2단계: 자식 카테고리 삽입 (parent_id를 매핑된 UUID로)
    for old_id, row, old_parent_id in children:
        row["parent_id"] = id_map.get(old_parent_id)
        result = supabase.schema(SCHEMA).table("categories").insert(row).execute()
        id_map[old_id] = result.data[0]["id"]

    print(f"  ✅ {len(id_map)}개 카테고리 완료")
    return id_map


def migrate_products(supabase, tenant_id, products_raw, category_id_map):
    """products.json → blacklabelled.products INSERT
    old integer ID → new UUID 매핑 반환
    main_category_id도 category_id_map으로 변환
    """
    print("\n📦 상품 마이그레이션...")

    id_map = {}  # old_id → new UUID
    count = 0
    for pid, p in products_raw.items():
        old_id = p["id"]
        meta = p.get("meta", {})
        old_main_cat = p.get("main_category")
        row = {
            "tenant_id": tenant_id,
            "name": p["name"],
            "slug": p["slug"],
            "description": p.get("description", ""),
            "price": p.get("price", 0),
            "status": "published",
            "main_category_id": category_id_map.get(old_main_cat),
            "source_url": p.get("source_url", ""),
        }
        result = supabase.schema(SCHEMA).table("products").insert(row).execute()
        id_map[old_id] = result.data[0]["id"]
        count += 1

        if count % 50 == 0:
            print(f"  ... {count}개 처리")

    print(f"  ✅ {count}개 상품 완료")
    return id_map


def migrate_product_categories(supabase, products_raw, product_id_map, category_id_map):
    """products.categories[] 배열 → blacklabelled.product_categories M:N INSERT
    old integer ID들을 UUID로 변환
    """
    print("\n🔗 상품-카테고리 관계 마이그레이션...")

    count = 0
    batch = []
    for pid, p in products_raw.items():
        new_product_id = product_id_map.get(p["id"])
        if not new_product_id:
            continue
        for old_cat_id in p.get("categories", []):
            new_cat_id = category_id_map.get(old_cat_id)
            if not new_cat_id:
                continue
            batch.append({
                "product_id": new_product_id,
                "category_id": new_cat_id,
            })
            count += 1

            if len(batch) >= 100:
                supabase.schema(SCHEMA).table("product_categories").insert(batch).execute()
                batch = []

    if batch:
        supabase.schema(SCHEMA).table("product_categories").insert(batch).execute()

    print(f"  ✅ {count}개 관계 완료")
    return count


def migrate_product_images(supabase, tenant_id, products_raw, product_id_map):
    """products.json의 images[] → blacklabelled.product_images INSERT
    storage_path = {tenant_uuid}/{product_uuid}/{filename}
    """
    print("\n🖼️ 이미지 메타데이터 마이그레이션...")

    count = 0
    batch = []
    for pid, p in products_raw.items():
        new_product_id = product_id_map.get(p["id"])
        if not new_product_id:
            continue
        for img in p.get("images", []):
            filename = os.path.basename(img["path"])

            row = {
                "product_id": new_product_id,
                "tenant_id": tenant_id,
                "type": img["type"],
                "sort_order": img["order"],
                "storage_path": f"{new_product_id}/{filename}",
                "original_url": img.get("original_url", ""),
                "original_filename": img.get("original_filename", ""),
                "width": img.get("width", 0) or None,
                "height": img.get("height", 0) or None,
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

    # tenant UUID 조회
    tenant_id = get_tenant_id(supabase)
    print(f"🏢 Tenant: {TENANT_SLUG} → {tenant_id}")

    # 데이터 로드
    products_raw = load_json(PRODUCTS_JSON)
    categories_raw = load_json(CATEGORIES_JSON)

    print(f"\n📊 소스 데이터:")
    print(f"   상품: {len(products_raw)}개")
    print(f"   카테고리: {len(categories_raw)}개")
    total_images = sum(len(p.get("images", [])) for p in products_raw.values())
    print(f"   이미지: {total_images}개")

    # 마이그레이션 실행 (순서 중요: FK 의존성)
    # 1. 카테고리 → old_id:UUID 매핑
    category_id_map = migrate_categories(supabase, tenant_id, categories_raw)

    # 2. 상품 → old_id:UUID 매핑 (main_category_id 변환 포함)
    product_id_map = migrate_products(supabase, tenant_id, products_raw, category_id_map)

    # 3. M:N 관계 (양쪽 UUID 변환)
    rel_count = migrate_product_categories(supabase, products_raw, product_id_map, category_id_map)

    # 4. 이미지 메타 (product UUID + tenant UUID)
    img_count = migrate_product_images(supabase, tenant_id, products_raw, product_id_map)

    # ID 매핑 저장 (upload_images에서 사용)
    mapping_file = os.path.join(CRAWL_DIR, "id_mapping.json")
    with open(mapping_file, "w") as f:
        json.dump({
            "tenant_id": tenant_id,
            "categories": {str(k): v for k, v in category_id_map.items()},
            "products": {str(k): v for k, v in product_id_map.items()},
        }, f, indent=2)
    print(f"\n💾 ID 매핑 저장: {mapping_file}")

    print(f"\n🎉 마이그레이션 완료!")
    print(f"   카테고리: {len(category_id_map)}")
    print(f"   상품: {len(product_id_map)}")
    print(f"   상품-카테고리: {rel_count}")
    print(f"   이미지 메타: {img_count}")


if __name__ == "__main__":
    main()
