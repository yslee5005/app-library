#!/usr/bin/env python3
"""
Baby Growth Video Generator — fal.ai Kling 3.0 API
Week 24 샘플 → 전체 47개 배치 처리 지원

사용법:
  1. pip install fal-client
  2. export FAL_KEY="your-api-key"
  3. python generate_video.py --week 24
  4. python generate_video.py --all  (전체 배치)
"""

import os
import sys
import json
import argparse
import time
from pathlib import Path

try:
    import fal_client
except ImportError:
    print("fal-client 미설치. 설치: pip install fal-client")
    sys.exit(1)

# === 경로 설정 ===
BASE_DIR = Path(__file__).parent.parent
REFERENCES_DIR = BASE_DIR / "references"

# === 모션 프롬프트 매핑 ===
MOTION_PROMPTS = {
    "type_a": (  # Stage 1-7 (미시적 부유)
        "Gentle floating motion in warm amber fluid, soft rotation, "
        "internal light pulsing slowly, particles drifting, "
        "seamless loop, calm and ethereal"
    ),
    "type_b": (  # Stage 8-23 (심장 박동)
        "Gentle heartbeat pulse glowing from center, subtle body sway, "
        "floating in warm amniotic fluid, rhythmic light pulse, "
        "seamless loop, peaceful and alive"
    ),
    "type_c": (  # Week 9-16 (미세 움직임)
        "Subtle hand and finger movement, gentle floating, "
        "occasional stretch or yawn, eyes closed peacefully, "
        "warm fluid environment, seamless loop"
    ),
    "type_d": (  # Week 17-24 (활발한 움직임)
        "Baby gently moving hands and feet, exploring with fingers, "
        "facial expressions changing softly, "
        "floating in warm golden space, seamless loop"
    ),
    "type_e": (  # Week 25-32 (평화로운 수면)
        "Peaceful sleeping baby, gentle breathing movement, "
        "occasional REM eye movement, soft body shift, "
        "warm golden glow, seamless loop"
    ),
    "type_f": (  # Week 33-40 (출산 준비)
        "Calm full-term baby in head-down position, "
        "gentle breathing, peaceful expression, "
        "soft warm light, ready for the world, seamless loop"
    ),
}

# === 주차별 커스텀 프롬프트 (source.md 기반) ===
WEEK_CUSTOM_PROMPTS = {
    "week_24": (
        "Baby gently opening eyelids slightly, sensing warm golden light, "
        "rapid eye movement during REM sleep phase then peacefully falling asleep, "
        "subtle hand movement near face, floating in warm amniotic fluid, "
        "soft amber glow pulsing gently, coral-tinted environment, "
        "smooth seamless loop, dreamy and ethereal atmosphere"
    ),
}

# === 스테이지/주차 → 모션 타입 매핑 ===
def get_motion_type(folder_name: str) -> str:
    if folder_name.startswith("stage_"):
        stage_num = int(folder_name.split("_")[1])
        if stage_num <= 7:
            return "type_a"
        return "type_b"
    elif folder_name.startswith("week_"):
        week_part = folder_name.split("_")[1]
        week_num = int(week_part.split("-")[0])
        if week_num <= 16:
            return "type_c"
        elif week_num <= 24:
            return "type_d"
        elif week_num <= 32:
            return "type_e"
        return "type_f"
    return "type_a"


def get_motion_prompt(folder_name: str) -> str:
    """커스텀 프롬프트 우선, 없으면 타입별 기본 프롬프트"""
    if folder_name in WEEK_CUSTOM_PROMPTS:
        return WEEK_CUSTOM_PROMPTS[folder_name]
    motion_type = get_motion_type(folder_name)
    return MOTION_PROMPTS[motion_type]


def find_input_image(week_dir: Path) -> Path | None:
    """selected/ 폴더에서 final 이미지 찾기"""
    selected_dir = week_dir / "selected"
    if not selected_dir.exists():
        return None

    # 우선순위: final > v1 > 아무거나
    for pattern in ["*final*", "*v1*", "*.png", "*.jpg", "*.webp"]:
        matches = list(selected_dir.glob(pattern))
        if matches:
            return matches[0]
    return None


def generate_video(image_path: Path, motion_prompt: str, output_path: Path) -> bool:
    """fal.ai Kling API로 비디오 생성"""
    print(f"  Image: {image_path.name}")
    print(f"  Prompt: {motion_prompt[:80]}...")
    print(f"  Output: {output_path.name}")

    try:
        # fal.ai Kling 비디오 생성 요청
        result = fal_client.subscribe(
            "fal-ai/kling-video/v2/master",
            arguments={
                "prompt": motion_prompt,
                "image_url": fal_client.upload_file(str(image_path)),
                "duration": "5",  # Kling supports 5 or 10 seconds
                "aspect_ratio": "1:1",
            },
            with_logs=True,
            on_queue_update=lambda update: print(f"  Status: {update.status}") if hasattr(update, 'status') else None,
        )

        # 결과 다운로드
        if result and "video" in result:
            video_url = result["video"]["url"]
            print(f"  Video URL: {video_url}")

            # 다운로드
            import urllib.request
            output_path.parent.mkdir(parents=True, exist_ok=True)
            urllib.request.urlretrieve(video_url, str(output_path))
            print(f"  Saved: {output_path}")
            return True
        else:
            print(f"  Error: unexpected result format: {json.dumps(result, indent=2)}")
            return False

    except Exception as e:
        print(f"  Error: {e}")
        return False


def process_week(week_name: str) -> bool:
    """특정 주차 처리"""
    # 폴더 탐색
    for zone_dir in REFERENCES_DIR.iterdir():
        if not zone_dir.is_dir():
            continue
        week_dir = zone_dir / week_name
        if week_dir.exists():
            print(f"\n=== Processing: {week_name} ===")
            print(f"  Dir: {week_dir}")

            # 이미지 찾기
            image_path = find_input_image(week_dir)
            if not image_path:
                print(f"  ERROR: selected/ 폴더에 이미지 없음!")
                print(f"  먼저 Midjourney에서 이미지를 생성하고 {week_dir}/selected/ 에 저장하세요.")
                return False

            # 모션 프롬프트
            motion_prompt = get_motion_prompt(week_name)

            # 비디오 생성
            output_path = week_dir / "videos" / f"{week_name}_raw.mp4"
            return generate_video(image_path, motion_prompt, output_path)

    print(f"  ERROR: {week_name} 폴더를 찾을 수 없음")
    return False


def process_all():
    """모든 주차 배치 처리"""
    results = {"success": [], "failed": [], "skipped": []}

    for zone_dir in sorted(REFERENCES_DIR.iterdir()):
        if not zone_dir.is_dir():
            continue
        for week_dir in sorted(zone_dir.iterdir()):
            if not week_dir.is_dir():
                continue
            week_name = week_dir.name
            image_path = find_input_image(week_dir)
            if not image_path:
                results["skipped"].append(week_name)
                continue

            success = process_week(week_name)
            if success:
                results["success"].append(week_name)
            else:
                results["failed"].append(week_name)

            # API rate limit 방지
            time.sleep(2)

    # 결과 요약
    print("\n" + "=" * 50)
    print("=== BATCH RESULTS ===")
    print(f"  Success: {len(results['success'])}")
    print(f"  Failed:  {len(results['failed'])}")
    print(f"  Skipped: {len(results['skipped'])} (이미지 없음)")
    if results["failed"]:
        print(f"  Failed list: {results['failed']}")
    if results["skipped"]:
        print(f"  Skipped list: {results['skipped']}")


def main():
    parser = argparse.ArgumentParser(description="Baby Growth Video Generator (fal.ai)")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--week", type=str, help="특정 주차 (예: week_24, stage_09)")
    group.add_argument("--all", action="store_true", help="모든 주차 배치 처리")
    parser.add_argument("--dry-run", action="store_true", help="실제 API 호출 없이 프롬프트만 확인")
    args = parser.parse_args()

    # API 키 확인
    if not os.environ.get("FAL_KEY"):
        print("ERROR: FAL_KEY 환경변수가 설정되지 않았습니다.")
        print("  export FAL_KEY='your-fal-api-key'")
        print("  fal.ai 계정: https://fal.ai/dashboard/keys")
        sys.exit(1)

    if args.dry_run:
        if args.week:
            prompt = get_motion_prompt(args.week)
            print(f"[DRY RUN] {args.week}")
            print(f"  Motion type: {get_motion_type(args.week)}")
            print(f"  Prompt: {prompt}")
        else:
            for zone_dir in sorted(REFERENCES_DIR.iterdir()):
                if not zone_dir.is_dir():
                    continue
                for week_dir in sorted(zone_dir.iterdir()):
                    if not week_dir.is_dir():
                        continue
                    name = week_dir.name
                    print(f"  {name}: {get_motion_type(name)} → {get_motion_prompt(name)[:60]}...")
        return

    if args.week:
        process_week(args.week)
    else:
        process_all()


if __name__ == "__main__":
    main()
