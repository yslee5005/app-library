#!/bin/bash
#
# Baby Growth Video — ffmpeg 후처리 스크립트
#
# 기능:
#   1. 해상도 통일 (1080x1080)
#   2. 7초 길이 조정
#   3. 심리스 루프 포인트 확인
#   4. 파일 크기 최적화 (앱용 < 5MB)
#   5. Flutter 앱용 최종 파일 생성
#
# 사용법:
#   ./postprocess.sh week_24           # 특정 주차
#   ./postprocess.sh --all             # 전체 배치
#   ./postprocess.sh week_24 --check   # 루프 품질 확인만

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
REFERENCES_DIR="$BASE_DIR/references"
FLUTTER_ASSETS_DIR="$BASE_DIR/flutter_assets"  # 앱 통합용 최종 출력

# 색상 출력
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }

# ffmpeg 확인
check_dependencies() {
    if ! command -v ffmpeg &> /dev/null; then
        error "ffmpeg가 설치되지 않았습니다."
        echo "  macOS: brew install ffmpeg"
        exit 1
    fi
    if ! command -v ffprobe &> /dev/null; then
        error "ffprobe가 설치되지 않았습니다."
        echo "  macOS: brew install ffmpeg"
        exit 1
    fi
}

# 비디오 정보 출력
get_video_info() {
    local input="$1"
    echo "  Duration: $(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$input" 2>/dev/null)s"
    echo "  Resolution: $(ffprobe -v quiet -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$input" 2>/dev/null)"
    echo "  Size: $(du -h "$input" | cut -f1)"
}

# 단일 비디오 후처리
process_video() {
    local week_name="$1"
    local check_only="${2:-false}"

    # 비디오 파일 찾기
    local raw_video=""
    for zone_dir in "$REFERENCES_DIR"/zone_*; do
        local week_dir="$zone_dir/$week_name"
        if [ -d "$week_dir" ]; then
            local videos_dir="$week_dir/videos"
            if [ -d "$videos_dir" ]; then
                raw_video=$(find "$videos_dir" -name "*raw*" -o -name "*.mp4" | head -1)
            fi
            break
        fi
    done

    if [ -z "$raw_video" ] || [ ! -f "$raw_video" ]; then
        warn "$week_name: raw 비디오 없음 (videos/ 폴더 확인)"
        return 1
    fi

    info "Processing: $week_name"
    info "  Input: $raw_video"
    get_video_info "$raw_video"

    if [ "$check_only" = "true" ]; then
        info "  [CHECK MODE] 루프 품질 확인:"
        # 첫 프레임과 마지막 프레임 추출하여 비교
        local tmp_dir=$(mktemp -d)
        ffmpeg -v quiet -i "$raw_video" -vf "select=eq(n\,0)" -frames:v 1 "$tmp_dir/first.png" 2>/dev/null
        ffmpeg -v quiet -sseof -0.1 -i "$raw_video" -frames:v 1 "$tmp_dir/last.png" 2>/dev/null
        local first_size=$(stat -f%z "$tmp_dir/first.png" 2>/dev/null || stat -c%s "$tmp_dir/first.png" 2>/dev/null)
        local last_size=$(stat -f%z "$tmp_dir/last.png" 2>/dev/null || stat -c%s "$tmp_dir/last.png" 2>/dev/null)
        info "  First frame: ${first_size}B, Last frame: ${last_size}B"
        info "  프레임 저장: $tmp_dir/ (수동 비교용)"
        return 0
    fi

    # 출력 경로
    local output_dir
    output_dir="$(dirname "$raw_video")"
    local output_file="$output_dir/${week_name}_7s.mp4"
    local flutter_file="$FLUTTER_ASSETS_DIR/growth_${week_name}.mp4"

    # ffmpeg 후처리
    # 1. 1080x1080으로 리사이즈
    # 2. 7초로 길이 조정 (속도 변경)
    # 3. H.264 코덱, 앱 최적화 비트레이트
    # 4. 루프 친화적 인코딩

    local duration
    duration=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$raw_video" 2>/dev/null)
    local speed_factor
    speed_factor=$(echo "$duration / 7.0" | bc -l 2>/dev/null || echo "1.0")

    info "  Speed factor: ${speed_factor}x (${duration}s → 7s)"

    ffmpeg -y -v quiet \
        -i "$raw_video" \
        -vf "scale=1080:1080:force_original_aspect_ratio=decrease,pad=1080:1080:(ow-iw)/2:(oh-ih)/2:color=black,setpts=PTS/${speed_factor}" \
        -c:v libx264 \
        -preset slow \
        -crf 23 \
        -b:v 2M \
        -maxrate 3M \
        -bufsize 4M \
        -pix_fmt yuv420p \
        -movflags +faststart \
        -t 7 \
        -an \
        "$output_file"

    info "  Output: $output_file"
    get_video_info "$output_file"

    # 파일 크기 확인 (5MB 초과 시 추가 압축)
    local file_size
    file_size=$(stat -f%z "$output_file" 2>/dev/null || stat -c%s "$output_file" 2>/dev/null)
    if [ "$file_size" -gt 5242880 ]; then
        warn "  파일 크기 > 5MB, 추가 압축 중..."
        ffmpeg -y -v quiet \
            -i "$output_file" \
            -c:v libx264 \
            -preset slow \
            -crf 28 \
            -b:v 1M \
            -maxrate 1.5M \
            -bufsize 2M \
            -pix_fmt yuv420p \
            -movflags +faststart \
            -an \
            "${output_file}.tmp.mp4"
        mv "${output_file}.tmp.mp4" "$output_file"
        info "  Re-compressed:"
        get_video_info "$output_file"
    fi

    # Flutter 에셋 복사
    mkdir -p "$FLUTTER_ASSETS_DIR"
    cp "$output_file" "$flutter_file"
    info "  Flutter asset: $flutter_file"

    echo ""
    return 0
}

# 전체 배치 처리
process_all() {
    local success=0
    local failed=0
    local skipped=0

    for zone_dir in "$REFERENCES_DIR"/zone_*; do
        [ -d "$zone_dir" ] || continue
        for week_dir in "$zone_dir"/*/; do
            [ -d "$week_dir" ] || continue
            local week_name
            week_name=$(basename "$week_dir")

            if process_video "$week_name"; then
                ((success++))
            else
                ((skipped++))
            fi
        done
    done

    echo ""
    info "=== BATCH RESULTS ==="
    info "  Success: $success"
    info "  Skipped: $skipped"
}

# === Main ===
check_dependencies

if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "  $0 week_24           # 특정 주차 처리"
    echo "  $0 --all             # 전체 배치"
    echo "  $0 week_24 --check   # 루프 품질 확인만"
    exit 1
fi

case "$1" in
    --all)
        process_all
        ;;
    *)
        check_only="false"
        if [ "${2:-}" = "--check" ]; then
            check_only="true"
        fi
        process_video "$1" "$check_only"
        ;;
esac
