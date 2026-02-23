#!/bin/bash

# 이미지를 포스트에 추가하고 자동으로 최적화하는 스크립트
# 사용법: ./tools/add-image.sh <이미지경로> <포스트디렉토리명>
# 예제: ./tools/add-image.sh ~/Desktop/photo.jpg 2026-02-24-k8s-basic

set -e

# 색상 정의
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 인자 체크
if [ $# -lt 2 ]; then
    echo -e "${YELLOW}사용법:${NC} $0 <이미지경로> <포스트디렉토리명>"
    echo ""
    echo "예제:"
    echo "  $0 ~/Desktop/photo.jpg 2026-02-24-k8s-basic"
    echo "  $0 ~/Downloads/*.png 2026-02-25-vibe-coding"
    exit 1
fi

IMAGE_PATH="$1"
POST_DIR="$2"

# 절대 경로로 변환
IMAGE_PATH=$(eval echo "$IMAGE_PATH")

# 이미지 파일 존재 확인
if [ ! -f "$IMAGE_PATH" ]; then
    echo -e "${YELLOW}오류:${NC} 이미지 파일을 찾을 수 없습니다: $IMAGE_PATH"
    exit 1
fi

# 포스트 이미지 디렉토리 생성
DEST_DIR="assets/img/posts/$POST_DIR"
mkdir -p "$DEST_DIR"

# 파일명 추출 (소문자로 변환하고 공백을 하이픈으로)
FILENAME=$(basename "$IMAGE_PATH")
EXTENSION="${FILENAME##*.}"
BASENAME="${FILENAME%.*}"
CLEAN_NAME=$(echo "$BASENAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
DEST_FILE="$DEST_DIR/$CLEAN_NAME.$EXTENSION"

# 원본 크기 확인
ORIGINAL_SIZE=$(du -h "$IMAGE_PATH" | cut -f1)
echo -e "${BLUE}원본 이미지:${NC} $FILENAME ($ORIGINAL_SIZE)"

# 이미지 복사
cp "$IMAGE_PATH" "$DEST_FILE"
echo -e "${GREEN}✓${NC} 복사 완료: $DEST_FILE"

# 이미지 크기 확인
DIMENSIONS=$(sips -g pixelWidth "$DEST_FILE" | tail -n1 | awk '{print $2}')

# 1200px보다 크면 리사이즈
if [ "$DIMENSIONS" -gt 1200 ]; then
    echo -e "${BLUE}이미지 최적화 중...${NC} (너비: ${DIMENSIONS}px → 1200px)"
    sips --resampleWidth 1200 "$DEST_FILE" > /dev/null 2>&1
    OPTIMIZED_SIZE=$(du -h "$DEST_FILE" | cut -f1)
    echo -e "${GREEN}✓${NC} 최적화 완료: $OPTIMIZED_SIZE"
else
    echo -e "${GREEN}✓${NC} 이미지 크기가 적절합니다 (${DIMENSIONS}px)"
fi

# 마크다운 경로 출력
echo ""
echo -e "${YELLOW}마크다운에서 사용:${NC}"
echo "![이미지 설명](/$DEST_FILE)"
echo ""
echo -e "${GREEN}완료!${NC} 이미지가 준비되었습니다."
