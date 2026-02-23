# 포스트 이미지 디렉토리

이 디렉토리는 블로그 포스트에 사용되는 이미지를 저장합니다.

## 디렉토리 구조

포스트별로 하위 디렉토리를 만들어 관리하는 것을 권장합니다:

```
posts/
├── YYYY-MM-DD-포스트제목/
│   ├── image1.png
│   └── image2.jpg
```

## 포스트에서 이미지 사용하기

### 기본 사용법

```markdown
![이미지 설명](/assets/img/posts/포스트디렉토리/이미지명.png)
```

### 예제

```markdown
<!-- 포스트별 디렉토리 사용 -->
![Kubernetes 아키텍처](/assets/img/posts/2026-02-24-k8s-기초/architecture.png)

<!-- 이미지에 캡션 추가 -->
![스크린샷](/assets/img/posts/example.png)
_이미지 캡션_

<!-- 이미지 크기 조절 (HTML 사용) -->
<img src="/assets/img/posts/example.png" alt="설명" width="500">
```

## 이미지 최적화 팁

- **용량**: 가능하면 500KB 이하로 압축
- **크기**: 너비 1200px 이내 권장
- **포맷**:
  - 스크린샷, 다이어그램: PNG
  - 사진: JPG
  - 아이콘, 로고: PNG 또는 SVG
