#!/usr/bin/env bash
# AI가 다음 주제로 칼럼 1편(.post)을 생성 → posts/ 에 저장
# 필요: 환경변수 ANTHROPIC_API_KEY, 명령어 curl/jq (GitHub Actions에 기본 탑재)
set -e
cd "$(dirname "$0")/.."

[ -z "$ANTHROPIC_API_KEY" ] && { echo "ANTHROPIC_API_KEY 가 없습니다."; exit 1; }

TOPICS="content/topics.txt"
USED="content/topics_used.txt"
touch "$USED"

# 아직 사용하지 않은 첫 주제 선택
topic=""
while IFS= read -r line; do
  [ -z "$line" ] && continue
  case "$line" in \#*) continue ;; esac
  if ! grep -Fxq "$line" "$USED"; then topic="$line"; break; fi
done < "$TOPICS"
[ -z "$topic" ] && { echo "남은 주제가 없습니다. content/topics.txt 에 주제를 추가하세요."; exit 0; }

category="${topic%%|*}"
subject="${topic##*|}"
today=$(date +%F)

PROMPT="당신은 마케팅 에이전시 '하오커뮤니케이션'의 SEO/AEO 콘텐츠 에디터입니다.
아래 주제로 한국어 마케팅 칼럼 1편을 작성하세요. 아래 .post 형식을 '그대로' 출력하세요. 코드블록·설명·인사말 없이 형식만 출력합니다.

규칙:
- 메타데이터(title/description/faq 등)에는 큰따옴표(\") 를 절대 쓰지 마세요.
- title은 클릭을 부르는 30자 내외.
- cover_title은 매거진 커버용 짧은 제목(12자 내외, 임팩트 있게). 줄바꿈할 위치에 세로줄 | 을 넣어 2줄로 구성하세요. 예: 검색을 넘어,|답변이 되는 법
- description은 검색 스니펫용 한 문장(90자 내외).
- date는 정확히 ${today}.
- category는 정확히 ${category}.
- slug는 영문 소문자와 하이픈만.
- keywords는 쉼표로 구분한 5~7개.
- 본문은 <p class=\"lead\">도입 1문단</p> 뒤에 <h2>소제목</h2>+<p>문단</p> 형태로 3~4개 섹션. 실전적이고 구체적으로, 핵심은 <strong>으로 강조.
- AEO를 위해 각 소제목은 질문/핵심을 담고, 첫 문장에서 즉답하세요.
- FAQ 3개 필수. 질문은 사용자가 실제로 검색할 법한 문장으로.
- related는 다음 중 관련되는 2개만: ai-marketing.html|AI마케팅, pr.html|언론홍보, sns.html|SNS마케팅, franchise.html|프랜차이즈마케팅, lawyer.html|변호사마케팅, hospital.html|병원마케팅, academy.html|학원마케팅, gov.html|정부지원사업, contact.html|무료 상담

주제: ${subject}

출력 형식(이 뼈대를 그대로 채우세요):
title:
cover_title:
description:
date: ${today}
category: ${category}
slug:
keywords:
related:
faq1_q:
faq1_a:
faq2_q:
faq2_a:
faq3_q:
faq3_a:
---
<p class=\"lead\"> ... </p>
<h2> ... </h2>
<p> ... </p>"

resp=$(curl -s https://api.anthropic.com/v1/messages \
  -H "x-api-key: ${ANTHROPIC_API_KEY}" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d "$(jq -n --arg m "$PROMPT" '{model:"claude-sonnet-4-6", max_tokens:2600, messages:[{role:"user", content:$m}]}')")

text=$(echo "$resp" | jq -r '.content[0].text // empty')
[ -z "$text" ] && { echo "API 응답 파싱 실패:"; echo "$resp" | head -c 800; exit 1; }

slug=$(printf '%s\n' "$text" | sed -n 's/^slug:[[:space:]]*//p' | head -1 | tr -cd 'a-z0-9-')
[ -z "$slug" ] && slug="post-$(date +%s)"

mkdir -p posts
out="posts/${today}-${slug}.post"
printf '%s\n' "$text" > "$out"
echo "$topic" >> "$USED"
echo "✓ 생성: $out  (주제: $subject)"
