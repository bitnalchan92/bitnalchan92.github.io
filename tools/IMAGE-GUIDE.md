# 📸 이미지 최적화 가이드

블로그 포스트에 이미지를 추가하고 자동으로 최적화하는 방법입니다.

## 🚀 방법 1: 자동화 스크립트 사용 (권장)

### add-image.sh - 단일 이미지 추가

이미지를 자동으로 복사, 최적화, 마크다운 코드 생성

```bash
# 사용법
./tools/add-image.sh <이미지경로> <포스트디렉토리명>

# 예제
./tools/add-image.sh ~/Desktop/screenshot.png 2026-02-24-k8s-basic
./tools/add-image.sh ~/Downloads/photo.jpg 2026-02-25-vibe-coding
```

**스크립트가 자동으로:**
- ✅ 포스트 디렉토리 생성 (`assets/img/posts/포스트명/`)
- ✅ 이미지 복사
- ✅ 1200px 이상이면 자동 리사이즈
- ✅ 마크다운 코드 출력 (복사해서 포스트에 붙여넣기)

### optimize-images.sh - 배치 최적화

이미 추가된 이미지들을 일괄 최적화

```bash
# 특정 포스트의 이미지만 최적화
./tools/optimize-images.sh 2026-02-24-k8s-basic

# 모든 포스트 이미지 최적화
./tools/optimize-images.sh
```

---

## ⚡ 방법 2: 쉘 Alias 설정 (더 편리)

`~/.zshrc` 또는 `~/.bashrc`에 추가:

```bash
# 블로그 이미지 관리
alias blog-img='~/github/bitnalchan92.github.io/tools/add-image.sh'
alias blog-opt='~/github/bitnalchan92.github.io/tools/optimize-images.sh'
```

설정 후 터미널 재시작 또는:
```bash
source ~/.zshrc  # zsh 사용 시
source ~/.bashrc # bash 사용 시
```

**이제 어디서든 사용 가능:**
```bash
blog-img ~/Desktop/photo.jpg 2026-02-24-포스트명
blog-opt 2026-02-24-포스트명
```

---

## 🔧 방법 3: Git Hook 자동 최적화 (고급)

커밋할 때 자동으로 이미지 최적화

`.git/hooks/pre-commit` 파일 생성:

```bash
#!/bin/bash
# 커밋 전 자동 이미지 최적화

echo "이미지 최적화 중..."
./tools/optimize-images.sh
git add assets/img/posts/
echo "✓ 이미지 최적화 완료"
```

실행 권한 부여:
```bash
chmod +x .git/hooks/pre-commit
```

⚠️ **주의**: 매 커밋마다 실행되므로 시간이 걸릴 수 있습니다.

---

## 📋 방법 4: 드래그 앤 드롭 (macOS Automator)

Automator로 Quick Action 만들기:

1. Automator 실행
2. Quick Action 선택
3. "Run Shell Script" 추가
4. 스크립트 입력:
```bash
for f in "$@"; do
    ~/github/bitnalchan92.github.io/tools/add-image.sh "$f" "포스트명"
done
```

이제 Finder에서 이미지 우클릭 → Quick Actions로 실행!

---

## 💡 추천 워크플로우

### 새 포스트 작성 시

```bash
# 1. 포스트 파일 생성
cp templates/post-template.md _posts/2026-02-24-새포스트.md

# 2. 이미지 추가
blog-img ~/Desktop/screenshot1.png 2026-02-24-새포스트
blog-img ~/Desktop/screenshot2.png 2026-02-24-새포스트

# 3. 마크다운에 이미지 경로 추가 (스크립트 출력을 복사)
# ![설명](/assets/img/posts/2026-02-24-새포스트/screenshot1.png)

# 4. 커밋 & 푸시
git add .
git commit -m "Add: 새 포스트"
git push
```

---

## 🎯 이미지 최적화 기준

- **너비**: 1200px (모바일/데스크탑 충분)
- **용량**: 500KB 이하 권장
- **포맷**:
  - 스크린샷/다이어그램: PNG
  - 사진: JPG
  - 아이콘/로고: SVG 또는 PNG

---

## ❓ FAQ

**Q: 이미 추가한 이미지를 최적화하려면?**
```bash
./tools/optimize-images.sh 포스트디렉토리명
```

**Q: 여러 이미지를 한 번에 추가하려면?**
```bash
for img in ~/Desktop/*.png; do
    ./tools/add-image.sh "$img" 2026-02-24-포스트명
done
```

**Q: 원본 이미지는 어떻게 되나요?**
원본은 그대로 유지되고, 복사본이 최적화됩니다.

---

## 🔗 관련 파일

- `tools/add-image.sh` - 이미지 추가 스크립트
- `tools/optimize-images.sh` - 배치 최적화 스크립트
- `assets/img/posts/` - 포스트 이미지 저장 위치
