다음 작업을 순서대로 수행해줘.

## 작업 대상

파일: `_posts/$ARGUMENTS`

## 1단계: 글 다듬기

`_posts/$ARGUMENTS` 파일을 읽고, Front Matter의 `categories`를 확인한 뒤 CLAUDE.md의 "글 다듬기 원칙"에 따라 내용을 다듬어줘.

### categories에 `Review`가 포함된 경우 (리뷰 포스트)

- 블로그 주인의 문체와 표현을 최대한 그대로 유지
- 한글 맞춤법 오류, 띄어쓰기 오류, 오탈자만 수정
- 읽기 어려울 정도로 단락 구분이 없는 경우에만 최소한으로 단락 조정
- 내용 추가, 소제목 삽입, 구조 변경 금지
- Front Matter가 규칙에 맞는지 확인 (date 시간은 `07:30:00 +0900`, author는 `bitnalchan92`)
- 이미지 경로가 있다면 CLAUDE.md 규칙에 맞게 수정

### categories에 `Review`가 없는 경우 (일반 포스트)

- 차분하고 이해하기 쉬운 톤 유지
- 초안의 의도와 핵심 메시지 존중
- 기술적 정확성 확인 및 수정 (수정 시 이유 안내)
- 제목/소제목/코드블록 등으로 가독성 향상
- 실무 관점에서 도움이 될 맥락 간결하게 보강
- Front Matter가 규칙에 맞는지 확인 (date 시간은 `07:30:00 +0900`, author는 `bitnalchan92`)
- 이미지 경로가 있다면 CLAUDE.md 규칙에 맞게 수정

## 2단계: 커밋 & 푸시

글 다듬기가 완료되면:

1. 파일을 스테이징: `git add _posts/$ARGUMENTS`
2. 커밋 메시지: `$ARGUMENTS 추가`
3. main 브랜치에 push: `git push origin main`
