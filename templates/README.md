# 포스트 템플릿 가이드

이 디렉토리에는 블로그 포스트 작성을 위한 템플릿들이 있습니다.

## 사용 방법

1. 원하는 템플릿을 복사
2. `_posts` 디렉토리로 이동
3. 파일명을 `YYYY-MM-DD-제목.md` 형식으로 변경
4. 내용 작성

## 템플릿 종류

### 1. post-template.md
- 일반적인 포스트용 기본 템플릿
- 모든 주제에 범용적으로 사용 가능

### 2. k8s-template.md
- Kubernetes 학습 내용 정리용
- 실습, 트러블슈팅 섹션 포함

### 3. vibe-coding-template.md
- 바이브코딩 경험 공유용
- AI 협업, 회고 섹션 포함

## Front Matter 주요 옵션

```yaml
title: "제목"                # 필수
date: YYYY-MM-DD HH:MM:SS   # 필수
categories: [대분류, 소분류] # 필수
tags: [태그들]              # 필수
description: "설명"         # SEO 최적화
pin: true                   # 상단 고정
math: true                  # 수학 수식 지원
mermaid: true              # 다이어그램 지원
image: /path/to/image      # 썸네일
```

## 예시

```bash
# 새 포스트 만들기
cp templates/k8s-template.md _posts/2026-02-24-k8s-pod-basic.md

# 내용 작성 후
git add _posts/2026-02-24-k8s-pod-basic.md
git commit -m "Add: K8s Pod 기초 포스트"
git push
```

## 카테고리 권장 구조

- **[DevOps, Kubernetes]** - K8s 관련
- **[Programming, Vibe-Coding]** - 바이브코딩
- **[Study, TIL]** - 일반 학습 내용
- **[Development, Backend]** - 백엔드 개발
- **[Development, Frontend]** - 프론트엔드 개발

## 태그 가이드

- 구체적이고 검색 가능한 키워드 사용
- 3-7개 정도가 적당
- 소문자 사용 권장
- 하이픈(-)으로 단어 연결
