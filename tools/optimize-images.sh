#!/bin/bash

# 포스트 디렉토리의 모든 큰 이미지를 자동으로 최적화
# 사용법: ./tools/optimize-images.sh [포스트디렉토리명]
# 예제: ./tools/optimize-images.sh 2026-02-24-k8s-basic
#       ./tools/optimize-images.sh  (전체 posts 디렉토리)

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 대상 디렉토리 설정
if [ $# -eq 0 ]; then
    TARGET_DIR="assets/img/posts"
    echo -e "${BLUE}전체 포스트 이미지 최적화${NC}"
else
    TARGET_DIR="assets/img/posts/$1"
    echo -e "${BLUE}$1 디렉토리 이미지 최적화${NC}"
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}오류:${NC} 디렉토리를 찾을 수 없습니다: $TARGET_DIR"
    exit 1
fi

echo ""
OPTIMIZED_COUNT=0
SKIPPED_COUNT=0

# 이미지 파일 찾기 (jpg, jpeg, png)
find "$TARGET_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r IMAGE; do
    # README 파일은 건너뛰기
    if [[ "$IMAGE" == *"README"* ]]; then
        continue
    fi

    FILENAME=$(basename "$IMAGE")
    ORIGINAL_SIZE=$(du -h "$IMAGE" | cut -f1)
    WIDTH=$(sips -g pixelWidth "$IMAGE" 2>/dev/null | tail -n1 | awk '{print $2}')

    # 1200px보다 크면 최적화
    if [ "$WIDTH" -gt 1200 ]; then
        echo -e "${YELLOW}⚙${NC}  $FILENAME (${WIDTH}px, $ORIGINAL_SIZE)"
        sips --resampleWidth 1200 "$IMAGE" > /dev/null 2>&1
        NEW_SIZE=$(du -h "$IMAGE" | cut -f1)
        echo -e "   ${GREEN}✓${NC} 최적화 완료: $NEW_SIZE"
        OPTIMIZED_COUNT=$((OPTIMIZED_COUNT + 1))
    else
        echo -e "${GREEN}✓${NC}  $FILENAME (${WIDTH}px, $ORIGINAL_SIZE) - 최적화 불필요"
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
    fi
done

echo ""
echo -e "${GREEN}완료!${NC} 최적화: ${OPTIMIZED_COUNT}개, 건너뜀: ${SKIPPED_COUNT}개"
