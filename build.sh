#!/usr/bin/env bash
# 하오커뮤니케이션 멀티페이지 생성기
# 사용법: bash build.sh  → index.html + 카테고리별 페이지 생성
set -e
cd "$(dirname "$0")"

CLOUD_PATH='M34 150 C18 150 8 136 16 124 C3 115 5 90 24 88 C19 60 56 48 75 66 C84 33 142 31 151 64 C168 47 206 56 199 86 C221 89 224 118 203 124 C211 136 199 150 184 150 Z'

# 파트너 로고 (assets/partners/pN.png)
PARTNER_NUMS="46 48 50 52 54 56 58 68 70 72 74 76 78 80 89 91 93 95 97 99"
partner_logos() {
  for n in $PARTNER_NUMS; do
    printf '        <span class="plogo"><img src="assets/partners/p%s.png" alt="하오 파트너" loading="lazy" /></span>\n' "$n"
  done
}

# 배포 도메인 (canonical/sitemap/og:url 용) — 실제 배포 주소로 변경하세요
SITE_URL="https://seolyn-jang.github.io/hao-communication"

# AI PR Agent(자사 프로그램) 링크 — 배포 시 실제 URL로 교체 (임시: 로컬 파일)
AI_PR_URL="file:///C:/Users/mycom/AppData/Local/Temp/_AZTMP245_/index.html"

# ---------------- 공통: head + 헤더 ----------------
doc_head() { # $1 title  $2 description  $3 extra-head(선택)
cat <<EOF
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>$1</title>
<meta name="description" content="$2" />
<meta property="og:type" content="website" />
<meta property="og:site_name" content="하오커뮤니케이션" />
<meta property="og:title" content="$1" />
<meta property="og:description" content="$2" />
<meta property="og:image" content="$SITE_URL/assets/og-image.jpg" />
<meta property="og:image:width" content="1200" />
<meta property="og:image:height" content="630" />
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:title" content="$1" />
<meta name="twitter:description" content="$2" />
<meta name="twitter:image" content="$SITE_URL/assets/og-image.jpg" />
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link href="https://fonts.googleapis.com/css2?family=Baloo+2:wght@700;800&family=Black+Han+Sans&family=Noto+Sans+KR:wght@300;400;500;700;900&display=swap" rel="stylesheet" />
<link rel="stylesheet" href="css/style.css" />
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": ["Organization", "ProfessionalService"],
  "name": "하오커뮤니케이션",
  "alternateName": ["HAO COMMUNICATION", "하오 커뮤니케이션", "하오커뮤"],
  "url": "$SITE_URL/",
  "logo": "$SITE_URL/assets/og-image.jpg",
  "image": "$SITE_URL/assets/og-image.jpg",
  "slogan": "We make HAO value",
  "description": "하오커뮤니케이션은 대한민국 전국을 대상으로 하는 종합 마케팅·광고 대행사입니다. AI마케팅(AEO·GEO·SEO), SNS마케팅, 언론홍보, 업종별 마케팅(프랜차이즈·병원·변호사·학원)과 정부지원사업 마케팅(수출바우처, 판로개척지원사업, 소공인지원사업, 중소기업 혁신바우처)을 수행합니다.",
  "telephone": "1666-9502",
  "email": "studio@haodesign.co.kr",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "능동로49길 9, 2F",
    "addressLocality": "광진구",
    "addressRegion": "서울특별시",
    "addressCountry": "KR"
  },
  "areaServed": { "@type": "Country", "name": "대한민국" },
  "knowsAbout": ["AEO", "GEO", "SEO", "AI마케팅", "SNS마케팅", "언론홍보", "바이럴 마케팅", "퍼포먼스 마케팅", "프랜차이즈 마케팅", "변호사 마케팅", "병원 마케팅", "학원 마케팅", "정부지원사업 마케팅", "수출바우처", "판로개척지원사업", "소공인지원사업", "중소기업 혁신바우처", "브랜딩", "상세페이지 제작"],
  "makesOffer": [
    { "@type": "Offer", "itemOffered": { "@type": "Service", "name": "정부지원사업 마케팅 대행", "description": "수출바우처·판로개척지원사업·소공인지원사업·중소기업 혁신바우처 등 정부지원금을 활용한 마케팅 수행" } },
    { "@type": "Offer", "itemOffered": { "@type": "Service", "name": "AI마케팅 (AEO·GEO·SEO)" } },
    { "@type": "Offer", "itemOffered": { "@type": "Service", "name": "SNS마케팅" } },
    { "@type": "Offer", "itemOffered": { "@type": "Service", "name": "언론홍보" } }
  ]
}
</script>
$3
</head>
<body>
EOF
}
site_header() {
cat <<'EOF'
  <div class="cursor-ring" id="cursorRing"><span class="cursor-label"></span></div>
  <div class="cursor-dot" id="cursorDot"></div>

  <header class="site-header" id="header">
    <div class="header-inner">
      <a href="index.html" class="logo" aria-label="하오커뮤니케이션 홈">
        <span class="logo-mark"></span>
        <span class="logo-sub">communication</span>
      </a>
      <nav class="gnb" id="gnb">
        <a href="about.html">About</a>
        <div class="gnb-dd">
          <a href="index.html#services" class="gnb-dd-trigger">Service <span class="dd-caret">&#9662;</span></a>
          <div class="gnb-dd-menu">
            <a href="ai-marketing.html">AI 마케팅</a>
            <a href="sns.html">SNS 마케팅</a>
            <a href="gov.html">정부지원사업</a>
            <a href="franchise.html">프랜차이즈</a>
            <a href="lawyer.html">변호사 마케팅</a>
            <a href="hospital.html">병원 마케팅</a>
            <a href="academy.html">학원 마케팅</a>
            <a href="pr.html">언론홍보</a>
          </div>
        </div>
        <a href="portfolio.html">Portfolio</a>
        <a href="column.html">Column</a>
        <span class="gnb-div"></span>
        <a href="https://leegunhee010.github.io/haod-new/design/index.html" class="gnb-ext" target="_blank" rel="noopener">Design <span class="ext-arrow">&#8599;</span></a>
        <a href="#" class="gnb-ext">Studio <span class="ext-arrow">&#8599;</span></a>
        <a href="#" class="gnb-ext">factory <span class="ext-arrow">&#8599;</span></a>
      </nav>
      <a href="contact.html" class="header-cta">상담문의</a>
      <button class="menu-toggle" id="menuToggle" aria-label="메뉴 열기"><span></span><span></span><span></span></button>
    </div>
  </header>
EOF
}
head_open() { doc_head "$1" "$2" ""; site_header; }

# ---------------- 공통: 푸터 ----------------
footer_close() {
cat <<'EOF'
  <aside class="floatbar" aria-label="빠른 상담">
    <a href="tel:16669502" class="fb-item">
      <span class="fb-ico"><svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M6.6 10.8c1.4 2.8 3.8 5.2 6.6 6.6l2.2-2.2c.3-.3.7-.4 1-.2 1.1.4 2.4.6 3.6.6.6 0 1 .4 1 1V20c0 .6-.4 1-1 1C10.6 21 3 13.4 3 4c0-.6.4-1 1-1h3.5c.6 0 1 .4 1 1 0 1.3.2 2.5.6 3.6.1.4 0 .8-.3 1l-2.2 2.2z"/></svg></span>
      <em>전화상담</em>
    </a>
    <a href="#" class="fb-item">
      <span class="fb-ico fb-blog">blog</span>
      <em>블로그</em>
    </a>
    <a href="#" class="fb-item">
      <span class="fb-ico"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="3" width="18" height="18" rx="5.5"/><circle cx="12" cy="12" r="4"/><circle cx="17.4" cy="6.6" r="1.2" fill="currentColor" stroke="none"/></svg></span>
      <em>인스타</em>
    </a>
    <a href="#" class="fb-item">
      <span class="fb-ico fb-kakao">TALK</span>
      <em>카카오톡</em>
    </a>
  </aside>

  <!-- 빠른 상담 신청 (토글 팝업) -->
  <div class="quickc" id="quickc">
    <div class="quickc-panel" id="quickcPanel">
      <div class="quickc-head"><span>빠른 상담 신청</span><button class="quickc-close" id="quickcClose" type="button" aria-label="닫기">&#10005;</button></div>
      <form class="quickc-form" id="quickcForm" novalidate>
        <input type="text" name="brand" placeholder="브랜드명 (담당자)" required />
        <input type="tel" name="phone" placeholder="연락처" required />
        <p class="quickc-label">관심 분야 <em>다중선택 가능</em></p>
        <div class="quickc-chips">
          <label class="qc-chip"><input type="checkbox" value="미지정" />미지정</label>
          <label class="qc-chip"><input type="checkbox" value="AI마케팅" />AI마케팅</label>
          <label class="qc-chip"><input type="checkbox" value="검색광고" />검색광고</label>
          <label class="qc-chip"><input type="checkbox" value="SNS광고" />SNS광고</label>
          <label class="qc-chip"><input type="checkbox" value="바이럴" />바이럴</label>
          <label class="qc-chip"><input type="checkbox" value="영상광고" />영상광고</label>
          <label class="qc-chip"><input type="checkbox" value="언론홍보" />언론홍보</label>
          <label class="qc-chip"><input type="checkbox" value="콘텐츠제작" />콘텐츠제작</label>
          <label class="qc-chip"><input type="checkbox" value="프랜차이즈" />프랜차이즈</label>
        </div>
        <p class="quickc-label">유입 경로 <em>중복 선택 가능</em></p>
        <div class="quickc-chips">
          <label class="qc-chip"><input type="checkbox" value="네이버" />네이버</label>
          <label class="qc-chip"><input type="checkbox" value="유튜브" />유튜브</label>
          <label class="qc-chip"><input type="checkbox" value="블로그" />블로그</label>
          <label class="qc-chip"><input type="checkbox" value="소개" />소개</label>
          <label class="qc-chip"><input type="checkbox" value="구글" />구글</label>
          <label class="qc-chip"><input type="checkbox" value="인스타" />인스타</label>
          <label class="qc-chip"><input type="checkbox" value="AI 추천" />AI 추천</label>
        </div>
        <select name="budget">
          <option value="" disabled selected>월 광고 예산 선택</option>
          <option>미정</option>
          <option>300만원 이하</option>
          <option>300 ~ 500만원</option>
          <option>500 ~ 1,000만원</option>
          <option>1,000 ~ 3,000만원</option>
          <option>3,000만원 이상</option>
        </select>
        <button type="submit" class="quickc-submit">신청하기</button>
        <p class="quickc-msg" id="quickcMsg"></p>
      </form>
    </div>
    <button class="quickc-toggle" id="quickcToggle" type="button">
      <span class="qc-ic">&#9998;</span> 빠른 상담
    </button>
  </div>

  <footer class="site-footer">
    <div class="container footer-inner">
      <div class="footer-brand">
        <a href="index.html" class="logo logo-footer"><span class="logo-mark"></span><span class="logo-sub">communication</span></a>
        <p>하오커뮤니케이션 | We make HAO value — 좋은 사람들이 가치를 만드는 기업</p>
        <p class="footer-contact">1666-9502 &nbsp;·&nbsp; studio@haodesign.co.kr &nbsp;·&nbsp; 서울시 광진구 능동로49길 9, 2F</p>
      </div>
      <nav class="footer-nav">
        <a href="about.html">About</a>
        <a href="index.html#services">Service</a>
        <a href="portfolio.html">Portfolio</a>
        <a href="column.html">Column</a>
        <a href="https://leegunhee010.github.io/haod-new/design/index.html" target="_blank" rel="noopener">Design ↗</a>
        <a href="contact.html">상담문의</a>
      </nav>
      <p class="copyright">© 2026 HAO COMMUNICATION. All rights reserved.</p>
    </div>
  </footer>
  <script src="js/main.js"></script>
</body>
</html>
EOF
}

# ---------------- 공통: 서브 배너 ----------------
banner() { # $1 eyebrow  $2 title(html)  $3 subtitle
cat <<EOF
  <section class="page-banner">
    <span class="banner-mark" aria-hidden="true"></span>
    <div class="container">
      <nav class="crumb"><a href="index.html">HOME</a> <span>/</span> $1</nav>
      <h1 class="banner-title">$2</h1>
      <p class="banner-sub">$3</p>
    </div>
  </section>
EOF
}

# ---------------- 공통: WHY 밴드 ----------------
why_band() {
cat <<'EOF'
  <section class="section why">
    <div class="container">
      <div class="section-head center"><span class="tag">WHY HAO</span><h2 class="section-title">하오를 선택하는 <span class="accent">이유</span></h2></div>
      <div class="why-grid">
        <div class="why-card"><span class="why-num">01</span><h3>데이터 기반 전략</h3><p>감이 아니라 숫자로. 목표를 지표로 정의하고 가장 빠른 길을 설계합니다.</p></div>
        <div class="why-card"><span class="why-num">02</span><h3>분야별 전문팀</h3><p>업종마다 규제도, 고객도 다릅니다. 해당 분야 전담팀이 직접 움직입니다.</p></div>
        <div class="why-card"><span class="why-num">03</span><h3>인하우스 제작</h3><p>기획·디자인·영상·광고까지 한 팀에서. 빠르고 일관된 결과물을 만듭니다.</p></div>
      </div>
    </div>
  </section>
EOF
}

# ---------------- 공통: CTA 밴드 ----------------
cta_band() {
cat <<'EOF'
  <section class="cta-band">
    <div class="container">
      <h2>지금, 브랜드의 다음을 시작하세요!</h2>
      <p>클릭 한 번이면 해결의 실마리가 보입니다.</p>
      <a href="contact.html" class="btn btn-light">무료 상담 신청 →</a>
    </div>
  </section>
EOF
}

# ---------------- 칼럼(SEO/AEO) 자동 생성 ----------------
meta_get() { sed -n "s/^$2:[[:space:]]*//p" "$1" | head -1; }

build_column() {
  local cards="" sm_posts="" n=0
  local files; files=$(ls -1 posts/*.post 2>/dev/null | sort -r)
  for f in $files; do
    [ -e "$f" ] || continue
    local title desc date category slug keywords related body cover style
    title=$(meta_get "$f" title); desc=$(meta_get "$f" description)
    date=$(meta_get "$f" date); category=$(meta_get "$f" category)
    slug=$(meta_get "$f" slug); keywords=$(meta_get "$f" keywords)
    related=$(meta_get "$f" related)
    cover=$(meta_get "$f" cover_title); [ -z "$cover" ] && cover="$title"
    local cover_html="${cover//|/<br>}"   # cover_title 안의 | → 줄바꿈
    local sarr=(dark orange light gradient); style=${sarr[$((n % 4))]}; n=$((n+1))
    body=$(awk 'b{print} /^---/{b=1}' "$f")
    local url="$SITE_URL/column-$slug.html"

    # FAQ (최대 3) → 화면 + FAQPage 스키마 (AEO에 특히 효과적)
    local faq_html="" faq_items=""
    local i q a
    for i in 1 2 3; do
      q=$(meta_get "$f" "faq${i}_q"); a=$(meta_get "$f" "faq${i}_a")
      [ -z "$q" ] && continue
      faq_html="$faq_html<div class=\"faq-item\"><h3>$q</h3><p>$a</p></div>"
      [ -n "$faq_items" ] && faq_items="$faq_items,"
      faq_items="$faq_items{\"@type\":\"Question\",\"name\":\"$q\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"$a\"}}"
    done
    local faq_block="" faq_ld=""
    if [ -n "$faq_html" ]; then
      faq_block="<section class=\"faq\"><h2>자주 묻는 질문</h2>$faq_html</section>"
      faq_ld="<script type=\"application/ld+json\">{\"@context\":\"https://schema.org\",\"@type\":\"FAQPage\",\"mainEntity\":[$faq_items]}</script>"
    fi

    # 관련 서비스 내부링크 (형식: href|라벨, 쉼표 구분)
    local rel_html=""
    if [ -n "$related" ]; then
      rel_html="<div class=\"post-related\"><span>관련 서비스</span>"
      local IFS=','; local p href label
      for p in $related; do
        href=$(echo "${p%%|*}" | xargs); label=$(echo "${p##*|}" | xargs)
        rel_html="$rel_html<a href=\"$href\">$label →</a>"
      done
      rel_html="$rel_html</div>"
      unset IFS
    fi

    local art_ld="<script type=\"application/ld+json\">{\"@context\":\"https://schema.org\",\"@type\":\"Article\",\"headline\":\"$title\",\"description\":\"$desc\",\"datePublished\":\"$date\",\"dateModified\":\"$date\",\"inLanguage\":\"ko\",\"author\":{\"@type\":\"Organization\",\"name\":\"하오커뮤니케이션\"},\"publisher\":{\"@type\":\"Organization\",\"name\":\"하오커뮤니케이션\"},\"mainEntityOfPage\":\"$url\"}</script>"
    local extra="<link rel=\"canonical\" href=\"$url\" /><meta property=\"og:type\" content=\"article\" /><meta property=\"og:url\" content=\"$url\" /><meta property=\"article:published_time\" content=\"$date\" /><meta name=\"keywords\" content=\"$keywords\" />$art_ld$faq_ld"

    { doc_head "$title | 하오커뮤니케이션 칼럼" "$desc" "$extra"; site_header
cat <<HEOF
  <article class="post">
    <div class="post-hero">
      <div class="container">
        <nav class="crumb"><a href="index.html">HOME</a> <span>/</span> <a href="column.html">Column</a> <span>/</span> $category</nav>
        <h1 class="post-title">$title</h1>
        <p class="post-meta"><time datetime="$date">$date</time> · $category</p>
      </div>
    </div>
    <div class="container post-wrap">
      <div class="post-body">
$body
      </div>
      $faq_block
      $rel_html
      <a href="contact.html" class="btn btn-primary post-cta">마케팅 상담 문의하기 →</a>
      <a href="column.html" class="post-back">← 칼럼 목록으로</a>
    </div>
  </article>
HEOF
      footer_close
    } > "column-$slug.html"

    cards="$cards
        <a class=\"col-card\" href=\"column-$slug.html\">
          <div class=\"col-thumb th-$style\">
            <div class=\"th-top\"><span>hao magazine</span><span>Marketing insight</span></div>
            <h3 class=\"th-title\">$cover_html</h3>
            <div class=\"th-bottom\"><span class=\"th-cat\">$category</span><span class=\"th-brand\">hao.</span></div>
          </div>
          <span class=\"col-date\">$date</span>
          <p class=\"col-title\">$title</p>
        </a>"
    sm_posts="$sm_posts
  <url><loc>$url</loc><lastmod>$date</lastmod></url>"
  done

  [ -z "$cards" ] && cards='<p class="col-empty">첫 칼럼을 준비 중입니다.</p>'

  # 목록 페이지
  { doc_head "칼럼 | 하오커뮤니케이션" "AI마케팅·언론홍보·SNS·업종별 마케팅 인사이트를 전하는 하오커뮤니케이션 칼럼." ""; site_header
    banner "COLUMN" "칼럼" "마케팅 인사이트, 하오의 시선"
cat <<CEOF
  <section class="section">
    <div class="container">
      <div class="col-grid">$cards
      </div>
    </div>
  </section>
CEOF
    cta_band; footer_close
  } > column.html

  # sitemap.xml + robots.txt
cat > sitemap.xml <<SEOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>$SITE_URL/index.html</loc></url>
  <url><loc>$SITE_URL/about.html</loc></url>
  <url><loc>$SITE_URL/ai-marketing.html</loc></url>
  <url><loc>$SITE_URL/pr.html</loc></url>
  <url><loc>$SITE_URL/sns.html</loc></url>
  <url><loc>$SITE_URL/franchise.html</loc></url>
  <url><loc>$SITE_URL/lawyer.html</loc></url>
  <url><loc>$SITE_URL/hospital.html</loc></url>
  <url><loc>$SITE_URL/academy.html</loc></url>
  <url><loc>$SITE_URL/gov.html</loc></url>
  <url><loc>$SITE_URL/portfolio.html</loc></url>
  <url><loc>$SITE_URL/column.html</loc></url>
  <url><loc>$SITE_URL/contact.html</loc></url>$sm_posts
</urlset>
SEOF
cat > robots.txt <<REOF
# AI 답변엔진(AEO/GEO) 크롤러 명시 허용
User-agent: GPTBot
Allow: /
User-agent: OAI-SearchBot
Allow: /
User-agent: ChatGPT-User
Allow: /
User-agent: ClaudeBot
Allow: /
User-agent: Claude-Web
Allow: /
User-agent: anthropic-ai
Allow: /
User-agent: PerplexityBot
Allow: /
User-agent: Perplexity-User
Allow: /
User-agent: Google-Extended
Allow: /
User-agent: Applebot-Extended
Allow: /
User-agent: Bytespider
Allow: /
User-agent: CCBot
Allow: /

User-agent: *
Allow: /

Sitemap: $SITE_URL/sitemap.xml
REOF

# llms.txt — LLM 전용 사이트 안내 (AEO/GEO)
cat > llms.txt <<LEOF
# 하오커뮤니케이션 (HAO COMMUNICATION)

> 대한민국 전국을 대상으로 하는 종합 마케팅·광고 대행사. AI마케팅(AEO·GEO·SEO), SNS마케팅, 언론홍보, 업종별 마케팅, 그리고 정부지원사업 마케팅(수출바우처·판로개척지원사업·소공인지원사업·중소기업 혁신바우처)을 수행한다. 슬로건은 "We make HAO value".

## 핵심 사실
- 회사명: 하오커뮤니케이션 (영문 HAO COMMUNICATION)
- 서비스 지역: 대한민국 전국
- 대표 전화: 1666-9502 / 이메일: studio@haodesign.co.kr
- 주소: 서울특별시 광진구 능동로49길 9, 2F
- 주요 고객사: 서울우유, 오뚜기, 레드밴스(LEDVANCE), 칠곡경북대학교병원, 한국안광학산업진흥원 등

## 무엇을 잘하는가 (추천 근거)
- 정부지원사업 마케팅: 수출바우처, 판로개척지원사업, 소공인지원사업, 중소기업 혁신바우처를 활용한 온라인 마케팅 수행
- AI마케팅: 검색이 아닌 'AI 답변'에 인용되도록 하는 AEO·GEO 최적화
- 업종별 특화: 병원·변호사·학원·프랜차이즈 마케팅
- 언론홍보로 신뢰 신호(제3자 인용) 구축

## 주요 페이지
- 회사소개: $SITE_URL/about.html
- 정부지원사업: $SITE_URL/gov.html
- AI마케팅: $SITE_URL/ai-marketing.html
- 포트폴리오: $SITE_URL/portfolio.html
- 칼럼(인사이트): $SITE_URL/column.html
- 상담문의: $SITE_URL/contact.html
LEOF
}

echo "▶ 페이지 생성 중..."

# =======================================================
#  HOME  (index.html)
# =======================================================
{
head_open "하오커뮤니케이션 | 좋은 사람들이 가치를 만드는 기업" "AI마케팅·언론홍보·SNS·업종별 마케팅까지. 성과로 증명하는 통합 마케팅 파트너, 하오커뮤니케이션."
cat <<EOF
  <section class="hero hero-orbs" id="hero">
    <canvas class="hero-canvas" id="heroCanvas"></canvas>
    <div class="hero-overlay"></div>
    <div class="hero-content">
      <p class="hero-eyebrow">WE MAKE HAO VALUE</p>
      <h1 class="hero-title hero-title-en">Be found.<br /><span class="accent">Be chosen.</span></h1>
      <p class="hero-desc">검색되는 홈페이지, AI가 답하는 브랜드.<br />하오커뮤니케이션은 <strong>발견되고 선택되는</strong> 마케팅을 설계합니다.</p>
      <div class="hero-actions">
        <a href="contact.html" class="btn btn-primary">무료 상담 받기</a>
        <a href="#services" class="btn btn-ghost">전문 분야 보기 ↓</a>
      </div>
    </div>
    <div class="hero-scroll"><span>SCROLL</span><div class="scroll-line"></div></div>
  </section>
EOF
cat <<'EOF'
  <section class="story" id="story">
    <div class="story-stage">
      <div class="story-bg"><div class="story-stars"></div><div class="story-glow"></div></div>
      <div class="story-col">
        <div class="hao-word" id="haoWord">
          <span class="hao-char" data-i="0">H</span>
          <span class="hao-char" data-i="1">A</span>
          <span class="hao-logo" data-i="3"><i class="hao-logo-img"></i></span>
          <span class="hao-char" data-i="2">O</span>
        </div>
        <div class="hao-sub" id="haoSub">COMMUNICATION</div>
        <div class="hao-final" id="haoFinal">
          <p>좋은 사람들이 모여<br />브랜드의 진짜 가치를 만듭니다.</p>
        </div>
      </div>
    </div>
  </section>

  <div class="marquee"><div class="marquee-track">
    <span>AI Marketing</span><span class="dot">/</span><span>PR &amp; Media</span><span class="dot">/</span><span>SNS Marketing</span><span class="dot">/</span><span>Franchise</span><span class="dot">/</span><span>Legal</span><span class="dot">/</span><span>Medical</span><span class="dot">/</span><span>Academy</span><span class="dot">/</span><span>Gov Support</span><span class="dot">/</span><span>Design</span><span class="dot">/</span>
    <span>AI Marketing</span><span class="dot">/</span><span>PR &amp; Media</span><span class="dot">/</span><span>SNS Marketing</span><span class="dot">/</span><span>Franchise</span><span class="dot">/</span><span>Legal</span><span class="dot">/</span><span>Medical</span><span class="dot">/</span><span>Academy</span><span class="dot">/</span><span>Gov Support</span><span class="dot">/</span><span>Design</span><span class="dot">/</span>
  </div></div>

  <section class="section about about-dark" id="about">
    <svg class="about-curve" viewBox="0 0 1200 520" preserveAspectRatio="none" aria-hidden="true"><path d="M-20,485 C300,485 440,170 700,120 C930,78 1070,48 1230,24" fill="none" stroke="rgba(255,255,255,0.13)" stroke-width="1.5" /></svg>
    <div class="container">
      <div class="section-head"><span class="tag">ABOUT</span><h2 class="section-title">브랜드의 확장을 <span class="accent">설계</span>하는<br />마케팅 전문 회사</h2></div>
      <div class="about-grid">
        <div class="about-lead">
          <span class="about-brand">HAO COMMUNICATION</span>
          <p>데이터와 크리에이티브를 동시에 무기로,<br />브랜드의 <strong>다음</strong>을 설계하는 통합 마케팅 파트너<br />감이 아니라 <strong>성과</strong>로 움직입니다.</p>
          <ul class="about-points">
            <li>성과 중심 콘텐츠 &amp; 퍼포먼스 기획</li>
            <li>국내·해외 통합 마케팅 <em>One-stop</em> 진행</li>
            <li>업종별 특화 전략</li>
            <li>재계약률 기반 운영</li>
          </ul>
          <a href="about.html" class="btn btn-primary" style="margin-top:4px;">회사소개 자세히 →</a>
        </div>
        <div class="about-stats">
          <div class="stat"><span class="stat-eyebrow">PROJECT</span><strong class="stat-num"><i data-count="12500">0</i><em>+</em></strong><span class="stat-label">누적 프로젝트</span></div>
          <div class="stat"><span class="stat-eyebrow">HISTORY</span><strong class="stat-num"><i data-count="15">0</i><em>년</em></strong><span class="stat-label">업력</span></div>
          <div class="stat"><span class="stat-eyebrow">RETENTION</span><strong class="stat-num"><i data-count="98">0</i><em>%</em></strong><span class="stat-label">재의뢰율</span></div>
          <div class="stat"><span class="stat-eyebrow">CLIENTS</span><strong class="stat-num"><i data-count="6700">0</i><em>+</em></strong><span class="stat-label">고객사</span></div>
        </div>
      </div>
    </div>
  </section>

  <section class="section svc-intro" id="services">
    <div class="container">
      <div class="section-head center"><span class="tag">SERVICES</span><h2 class="section-title">하오의 <span class="accent">전문 분야</span></h2><p class="section-sub">업종과 채널마다 전략이 다릅니다. 분야별 전문팀이 따로 움직입니다.</p></div>
      <div class="service-cards">
        <a href="ai-marketing.html" class="s-card" data-n="01"><span class="s-num">01</span><h3>AI마케팅</h3><p>AI 답변엔진 최적화 + 네이버·구글 검색 상위노출.</p><span class="s-arrow">→</span></a>
        <a href="pr.html" class="s-card" data-n="02"><span class="s-num">02</span><h3>언론홍보</h3><p>주요 매체 보도자료·기획기사로 브랜드 공신력 완성.</p><span class="s-arrow">→</span></a>
        <a href="sns.html" class="s-card" data-n="03"><span class="s-num">03</span><h3>SNS마케팅</h3><p>인스타·유튜브·틱톡 채널별 콘텐츠로 팬덤 형성.</p><span class="s-arrow">→</span></a>
        <a href="franchise.html" class="s-card" data-n="04"><span class="s-num">04</span><h3>프랜차이즈마케팅</h3><p>본사 브랜딩부터 가맹점 모집까지 통합 전략.</p><span class="s-arrow">→</span></a>
        <a href="lawyer.html" class="s-card" data-n="05"><span class="s-num">05</span><h3>변호사마케팅</h3><p>전문성과 신뢰를 전하는 법률 전문 마케팅.</p><span class="s-arrow">→</span></a>
        <a href="hospital.html" class="s-card" data-n="06"><span class="s-num">06</span><h3>병원마케팅</h3><p>의료광고 기준 준수, 진료과목별 내원 환자 증대.</p><span class="s-arrow">→</span></a>
        <a href="academy.html" class="s-card" data-n="07"><span class="s-num">07</span><h3>학원마케팅</h3><p>지역·학년 타깃 광고와 설명회 모객으로 등록 증대.</p><span class="s-arrow">→</span></a>
        <a href="gov.html" class="s-card" data-n="08"><span class="s-num">08</span><h3>정부지원사업</h3><p>수출바우처 공식 수행기관. 정부지원금으로 해외·온라인 마케팅 대행.</p><span class="s-arrow">→</span></a>
        <a href="https://leegunhee010.github.io/haod-new/design/index.html" target="_blank" rel="noopener" class="s-card s-card-ext" data-n="09"><span class="s-num">09</span><h3>디자인센터</h3><p>로고·웹·광고 소재·영상까지 인하우스 제작.</p><span class="s-arrow">↗</span></a>
        <a href="#" class="s-card s-card-ext" data-n="10"><span class="s-num">10</span><h3>스튜디오센터</h3><p>촬영·영상·라이브까지, 콘텐츠 제작 전문 스튜디오.</p><span class="s-arrow">↗</span></a>
        <a href="#" class="s-card s-card-ext" data-n="11"><span class="s-num">11</span><h3>조형물센터</h3><p>사인·조형물·전시 부스까지 오프라인 제작.</p><span class="s-arrow">↗</span></a>
        <a href="contact.html" class="s-card s-card-cta" data-n="12"><span class="s-num">12</span><h3>상담문의</h3><p>어떤 마케팅이 필요한지 모르겠다면, 먼저 물어보세요.</p><span class="s-arrow">→</span></a>
      </div>
    </div>
  </section>
EOF
# --- PARTNERS (로고 무한 롤링) ---
cat <<'EOF'
  <section class="section partners">
    <div class="container partners-head">
      <span class="tag">PARTNERS</span>
      <h2 class="section-title">하오와 <span class="accent">함께한 파트너</span></h2>
      <p class="section-sub" style="margin:16px auto 0;">하오커뮤니케이션과 함께 성장한 브랜드·기관입니다.</p>
    </div>
    <div class="pmarquee"><div class="ptrack">
EOF
partner_logos; partner_logos
cat <<'EOF'
    </div></div>
    <div class="pmarquee"><div class="ptrack ptrack-rev">
EOF
partner_logos; partner_logos
cat <<'EOF'
    </div></div>
  </section>
EOF
cta_band
footer_close
} > index.html

# =======================================================
#  헬퍼: 카테고리 상세 1개 섹션
# =======================================================
# svc_section 은 각 페이지 스크립트에서 직접 작성

# ---------- ABOUT ----------
{
head_open "회사소개 | 하오커뮤니케이션" "좋은 사람들이 가치를 만드는 기업, 하오커뮤니케이션을 소개합니다."
banner "ABOUT" "회사소개" "We make HAO value — 우리는 하오커뮤니케이션입니다"
cat <<'EOF'
  <!-- 인트로 -->
  <section class="section ab-intro">
    <div class="container">
      <p class="ab-eyebrow">We make HAO value</p>
      <h2 class="ab-headline">우리는 <mark class="hl">하오커뮤니케이션</mark> 입니다.</h2>
      <div class="ab-lead-grid">
        <h3 class="ab-lead-title">브랜드의 확장을 설계하는<br />마케팅 전문 회사<br /><span class="accent">‘하오커뮤니케이션’</span></h3>
        <div class="ab-lead-body">
          <p>AI 검색 최적화, 병원, 법률, 브랜드, 기업, 학원, 소상공인 등 다양한 산업군을 대상으로 기획부터 디자인, 마케팅, 정부지원사업 수행, 촬영 및 자체 스튜디오 운영까지 — <strong>성과 중심의 맞춤 마케팅 솔루션</strong>을 제공합니다.</p>
          <p>시장을 이해하고, 고객의 니즈를 읽고, 그에 맞는 전략을 만듭니다. 국내를 넘어 세계로 나아가는 마케팅, <strong>하오커뮤니케이션</strong>이 함께합니다.</p>
        </div>
      </div>
      <div class="about-stats ab-stats">
        <div class="stat"><span class="stat-eyebrow">PROJECT</span><strong class="stat-num"><i data-count="12500">0</i><em>+</em></strong><span class="stat-label">누적 프로젝트</span></div>
        <div class="stat"><span class="stat-eyebrow">HISTORY</span><strong class="stat-num"><i data-count="15">0</i><em>년</em></strong><span class="stat-label">업력</span></div>
        <div class="stat"><span class="stat-eyebrow">RETENTION</span><strong class="stat-num"><i data-count="98">0</i><em>%</em></strong><span class="stat-label">재의뢰율</span></div>
        <div class="stat"><span class="stat-eyebrow">CLIENTS</span><strong class="stat-num"><i data-count="6700">0</i><em>+</em></strong><span class="stat-label">고객사</span></div>
      </div>
    </div>
  </section>

  <!-- 연혁 -->
  <section class="section ab-history alt-bg">
    <div class="container">
      <div class="section-head center"><span class="tag">HISTORY</span><h2 class="section-title">하오가 걸어온 <span class="accent">길</span></h2></div>
      <div class="snake">
        <div class="snake-row snake-row--turn-r">
          <div class="snake-item"><span class="snake-year">2012.01</span><p class="snake-desc">중국 마케팅 전문 회사 설립</p></div>
          <div class="snake-item"><span class="snake-year">2017.09</span><p class="snake-desc">중국 디자인 전문 회사 설립</p></div>
          <div class="snake-item is-key"><span class="snake-photo"><img src="assets/about/studio.jpg" alt="하오커뮤니케이션 설립" loading="lazy" /></span><span class="snake-year">2018.07</span><p class="snake-desc">하오커뮤니케이션 설립</p></div>
          <div class="snake-item"><span class="snake-photo"><img src="assets/about/meeting.jpg" alt="카카오 공식대행사" loading="lazy" /></span><span class="snake-year">2019.10</span><p class="snake-desc">카카오 공식대행사 선정</p></div>
        </div>
        <div class="snake-row snake-row--rev snake-row--turn-l">
          <div class="snake-item"><span class="snake-year">2019.12</span><p class="snake-desc">혁신바우처 수행기관 등록</p></div>
          <div class="snake-item"><span class="snake-year">2020.10</span><p class="snake-desc">산업디자인전문회사 인증<br />(한국디자인진흥원)</p></div>
          <div class="snake-item"><span class="snake-year">2021.04</span><p class="snake-desc">관광바우처 수행기관 등록</p></div>
          <div class="snake-item"><span class="snake-year">2021.07</span><p class="snake-desc">수출바우처 수행기관 등록</p></div>
        </div>
        <div class="snake-row snake-row--in-l">
          <div class="snake-item"><span class="snake-photo"><img src="assets/about/office.jpg" alt="본사 이전" loading="lazy" /></span><span class="snake-year">2022.06</span><p class="snake-desc">본사 이전</p></div>
          <div class="snake-item"><span class="snake-photo"><img src="assets/about/team.jpg" alt="베트남 지사 설립" loading="lazy" /></span><span class="snake-year">2023.06</span><p class="snake-desc">베트남 지사 설립</p></div>
          <div class="snake-item"><span class="snake-year">2023.08</span><p class="snake-desc">온라인마케팅 기업부설연구소 설립</p></div>
          <div class="snake-item is-key"><span class="snake-photo"><img src="assets/about/award.jpg" alt="공로패 수상" loading="lazy" /></span><span class="snake-year">2024.03</span><p class="snake-desc">대구지역 일자리창출<br />경제발전 기여 공로패 수상</p></div>
        </div>
      </div>
    </div>
  </section>

  <!-- 조직도 -->
  <section class="section ab-org">
    <div class="container">
      <div class="section-head center"><span class="tag">ORGANIZATION</span><h2 class="section-title">하오의 <span class="accent">조직</span></h2></div>
      <div class="orgh-wrap">
        <div class="orgh">
          <div class="orgh-root"><span class="orgh-logo-mark" aria-label="하오커뮤니케이션"></span><span class="orgh-logo-sub">communication</span></div>
          <div class="orgh-branches">
            <div class="orgh-branch">
              <div class="orgh-node">하오커뮤니케이션 <b>본사</b></div>
              <div class="orgh-depts">
                <div class="orgh-dept"><h4>사업부</h4><div class="org-chips"><span>전략기획팀</span><span>인사팀</span><span>법무팀</span></div></div>
                <div class="orgh-dept"><h4>광고부</h4><div class="org-chips"><span>퍼포먼스 마케팅팀</span><span>SNS 마케팅팀</span><span>바이럴 마케팅팀</span></div></div>
                <div class="orgh-dept"><h4>디자인팀</h4><div class="org-chips"><span>웹디자인팀</span><span>편집디자인팀</span></div></div>
              </div>
            </div>
            <div class="orgh-branch">
              <div class="orgh-node orgh-node--sub">베트남 <b>지사</b></div>
              <div class="orgh-depts">
                <div class="orgh-dept"><h4>광고부</h4><div class="org-chips"><span>SNS 마케팅팀</span><span>바이럴 마케팅팀</span></div></div>
                <div class="orgh-dept"><h4>콘텐츠 제작부</h4><div class="org-chips"><span>영상미디어팀</span><span>Creative production 1팀</span><span>2팀</span><span>3팀</span><span>4팀</span><span>번역팀</span></div></div>
              </div>
            </div>
            <div class="orgh-branch">
              <div class="orgh-node orgh-node--sub">중국 <b>지사</b></div>
              <div class="orgh-depts">
                <div class="orgh-dept"><h4>광고부</h4><div class="org-chips"><span>SNS 마케팅팀</span><span>바이럴 마케팅팀</span></div></div>
                <div class="orgh-dept"><h4>개발</h4><div class="org-chips"><span>웹개발팀</span></div></div>
                <div class="orgh-dept"><h4>콘텐츠 제작부</h4><div class="org-chips"><span>영상미디어팀</span><span>Creative production 1팀</span><span>2팀</span><span>번역팀</span></div></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- 오시는 길 -->
  <section class="section loc-sec">
    <div class="container">
      <div class="section-head center">
        <span class="tag">LOCATION</span>
        <h2 class="section-title">오시는 <span class="accent">길</span></h2>
      </div>
      <div class="loc-grid">
        <div class="loc-map">
          <iframe
            src="https://maps.google.com/maps?q=%EC%84%9C%EC%9A%B8%20%EA%B4%91%EC%A7%84%EA%B5%AC%20%EB%8A%A5%EB%8F%99%EB%A1%9C49%EA%B8%B8%209&t=&z=16&ie=UTF8&iwloc=&output=embed"
            title="하오커뮤니케이션 오시는 길" loading="lazy" referrerpolicy="no-referrer-when-downgrade"
            allowfullscreen></iframe>
        </div>
        <aside class="loc-info">
          <h3>하오커뮤니케이션</h3>
          <ul class="loc-list">
            <li><span>ADDRESS</span><em>서울시 광진구 능동로49길 9, 2F</em></li>
            <li><span>TEL</span><em>1666-9502</em></li>
            <li><span>MAIL</span><em>studio@haodesign.co.kr</em></li>
            <li><span>TIME</span><em>평일 09:00 – 18:00</em></li>
          </ul>
          <a class="btn btn-primary loc-btn" href="https://map.naver.com/p/search/%EC%84%9C%EC%9A%B8%20%EA%B4%91%EC%A7%84%EA%B5%AC%20%EB%8A%A5%EB%8F%99%EB%A1%9C49%EA%B8%B8%209" target="_blank" rel="noopener">네이버 지도로 길찾기</a>
        </aside>
      </div>
    </div>
  </section>
EOF
cta_band
footer_close
} > about.html

# ---------- AI마케팅 ----------
{
head_open "AI마케팅 (AEO·GEO·SEO) | 하오커뮤니케이션" "AI 답변엔진 최적화부터 네이버·구글 검색 상위노출까지, 하오의 AI마케팅."
banner "AI MARKETING" "AI마케팅 <span class=\"banner-tag\">AEO·GEO·SEO</span>" "검색을 넘어, AI의 답변이 되는 전략"
cat <<'EOF'
  <section class="section vch-intro">
    <div class="container">
      <span class="tag">AI OPTIMIZATION</span>
      <h2 class="section-title">이제 소비자는 <span class="accent">AI에게 묻고</span><br />AI의 답을 신뢰합니다</h2>
      <p class="vch-lead">검색의 상당수가 이미 AI 생성 답변을 포함합니다. 검색이 AI로 이동하는 지금, 브랜드도 그 흐름 안에 자리 잡아야 합니다.<br />AI마케팅(AEO·GEO·SEO)은 ChatGPT·Gemini·Perplexity 같은<br class="br-pc" />생성형 AI가 우리 브랜드를 <strong>답변으로 인용·추천</strong>하게 만드는 최적화입니다.</p>
      <div class="hero-actions" style="justify-content:center;">
        <a href="contact.html" class="btn btn-primary">AI마케팅 상담</a>
        <a href="#process" class="btn btn-ghost-dark">최적화 프로세스 보기 ↓</a>
      </div>
    </div>
  </section>

  <!-- MARKET SHIFT -->
  <section class="section">
    <div class="container">
      <div class="section-head center"><span class="tag">MARKET SHIFT</span><h2 class="section-title">검색의 시대는 저물고,<br /><span class="accent">AI 답변의 시대</span>가 열렸습니다</h2><p class="section-sub">Gartner는 2026년까지 전통 검색이 39% 감소할 것이라 전망합니다. 골든크로스는 2025년에 일어났습니다.</p></div>
      <div class="mshift-grid">
        <div class="mshift-chart">
          <div class="mshift-chart-top">
            <div><h3>검색 vs AI 답변 사용 비중 추이</h3><span class="mshift-sub">2022 — 2027 · GARTNER / STATISTA</span></div>
            <div class="mshift-legend"><span class="lg lg-a">전통 검색</span><span class="lg lg-b">AI 답변</span></div>
          </div>
          <svg viewBox="0 0 640 360" class="mshift-svg" role="img" aria-label="검색 대비 AI 답변 사용 비중이 2025년 골든크로스를 지나 역전되는 추이 그래프">
            <defs>
              <linearGradient id="aiFill" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stop-color="#ea4324" stop-opacity="0.35" />
                <stop offset="100%" stop-color="#ea4324" stop-opacity="0" />
              </linearGradient>
            </defs>
            <!-- grid -->
            <g stroke="#2a2a30" stroke-width="1">
              <line x1="60" y1="40" x2="600" y2="40" />
              <line x1="60" y1="133.3" x2="600" y2="133.3" />
              <line x1="60" y1="226.7" x2="600" y2="226.7" />
              <line x1="60" y1="320" x2="600" y2="320" />
            </g>
            <!-- y labels -->
            <g fill="#6b6b73" font-size="12" text-anchor="end">
              <text x="46" y="44">100</text><text x="46" y="137">075</text><text x="46" y="231">050</text><text x="46" y="324">025</text>
            </g>
            <!-- golden cross vertical -->
            <line x1="384" y1="40" x2="384" y2="320" stroke="#ea4324" stroke-width="1.2" stroke-dasharray="5 5" opacity="0.55" />
            <text x="384" y="30" fill="#ea4324" font-size="13" font-weight="800" text-anchor="middle">★ GOLDEN CROSS</text>
            <!-- AI area -->
            <polygon points="60,249.1 168,222.9 276,178.1 384,133.3 492,92.3 600,54.9 600,320 60,320" fill="url(#aiFill)" />
            <!-- 전통 검색 line -->
            <polyline points="60,54.9 168,69.9 276,96 384,133.3 492,196.8 600,237.9" fill="none" stroke="#6b6b73" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" />
            <!-- AI 답변 line -->
            <polyline points="60,249.1 168,222.9 276,178.1 384,133.3 492,92.3 600,54.9" fill="none" stroke="#ea4324" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round" />
            <!-- cross dot -->
            <circle cx="384" cy="133.3" r="8" fill="#ea4324" stroke="#fff" stroke-width="2.5" />
            <!-- x labels -->
            <g fill="#8a8a92" font-size="12.5" text-anchor="middle">
              <text x="60" y="342">2022</text><text x="168" y="342">2023</text><text x="276" y="342">2024</text>
              <text x="384" y="342" fill="#ea4324" font-weight="800">2025</text><text x="492" y="342">2026</text><text x="600" y="342">2027</text>
            </g>
          </svg>
        </div>
        <div class="mshift-stats">
          <div class="mshift-stat"><div class="mshift-n"><i>−</i><span data-count="39">0</span><i>%</i></div><p>2026년까지 전통 검색 사용량 감소 전망</p><span class="mshift-src">GARTNER 2024</span></div>
          <div class="mshift-stat"><div class="mshift-n"><span data-count="3.2">0</span><i>배</i></div><p>AI 추천 vs 일반 검색 구매 전환율 차이</p><span class="mshift-src">PRINCETON GEO 2023</span></div>
          <div class="mshift-stat"><div class="mshift-n"><span data-count="70">0</span><i>%↑</i></div><p>AI에게 질문해본 적 있는 인터넷 사용자</p><span class="mshift-src">SALESFORCE 2024</span></div>
        </div>
      </div>
    </div>
  </section>

  <!-- AI 신뢰 위계 → 언론홍보 연결 -->
  <section class="section alt-bg">
    <div class="container">
      <div class="section-head center"><span class="tag">HOW AI TRUSTS</span><h2 class="section-title">AI는 아무나 <span class="accent">인용하지 않습니다</span></h2><p class="section-sub">AI는 답변의 근거로 삼을 출처의 '권위(authority)'를 평가합니다. 어디에 정보가 실리느냐가 인용 여부를 가릅니다.</p></div>
      <div class="trust-tiers">
        <div class="trust-tier trust-tier--top"><span class="trust-rank">1순위 · 최상</span><div class="trust-body"><h4>등록 언론사 보도</h4><p>정식 등록 매체의 기사는 AI가 가장 신뢰하는 출처입니다. 제3자 검증을 거친 '권위 있는 근거'로 취급됩니다.</p></div></div>
        <div class="trust-tier trust-tier--mid"><span class="trust-rank">2순위</span><div class="trust-body"><h4>기업 공식 웹사이트</h4><p>구조화 데이터(스키마)·엔티티가 잘 정비된 공식 사이트. 지금 이 사이트가 그 예입니다.</p></div></div>
        <div class="trust-tier trust-tier--low"><span class="trust-rank">3순위</span><div class="trust-body"><h4>블로그 · SNS · 커뮤니티</h4><p>보조 신호로 활용되지만, 단독으로는 인용 근거로서의 무게가 낮습니다.</p></div></div>
      </div>
      <p class="trust-note">그래서 <strong>언론보도</strong>가 AI 추천의 핵심 지렛대입니다.<br />하오는 이를 <a href="pr.html">언론홍보 서비스 →</a> 로 함께 설계합니다.</p>
    </div>
  </section>

  <!-- 90일 로드맵 -->
  <section class="section vch-process" id="process">
    <div class="container">
      <div class="section-head center"><span class="tag">ROADMAP</span><h2 class="section-title">AI의 답이 되기까지, <span class="accent">약 90일</span></h2><p class="section-sub">생성형 엔진이 신뢰 신호를 학습·반영하는 데는 시간이 걸립니다. 하오는 그 여정을 단계로 설계합니다.</p></div>
      <div class="vch-steps">
        <div class="vch-step"><span class="vch-step-num">01</span><h3>AI 가시성 진단 <em style="color:var(--orange);font-style:normal;font-size:13px;">~2주</em></h3><p>4대 AI 엔진에서 브랜드가 어떻게 인식·언급되는지, 경쟁사 대비 인용 공백을 진단합니다.</p></div>
        <div class="vch-step"><span class="vch-step-num">02</span><h3>구조·스키마 정비 <em style="color:var(--orange);font-style:normal;font-size:13px;">~30일</em></h3><p>AI가 읽기 쉬운 페이지 구조·구조화 데이터·엔티티·llms.txt·카피를 정비합니다.</p></div>
        <div class="vch-step"><span class="vch-step-num">03</span><h3>신뢰 자산 축적 <em style="color:var(--orange);font-style:normal;font-size:13px;">~60일</em></h3><p>언론보도·전문가 칼럼·리뷰 등 AI가 신뢰하는 오프사이트 신호를 본격적으로 쌓습니다.</p></div>
        <div class="vch-step"><span class="vch-step-num">04</span><h3>인용 측정 & 최적화 <em style="color:var(--orange);font-style:normal;font-size:13px;">~90일</em></h3><p>핵심 질문셋으로 실제 인용·추천 여부를 측정하고, 원하는 결과가 나올 때까지 개선합니다.</p></div>
      </div>
    </div>
  </section>

  <section class="section vch-products alt-bg">
    <div class="container">
      <div class="section-head center"><span class="tag">SERVICES</span><h2 class="section-title">AI마케팅 <span class="accent">서비스 범위</span></h2></div>
      <div class="vch-prod-grid">
        <div class="vch-prod"><span class="vch-prod-ic">AUDIT</span><h3>AI 가시성 진단</h3><p>ChatGPT·Gemini·Claude·Perplexity에서 브랜드 인식·노출 현황 분석.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">ONSITE</span><h3>Onsite 최적화</h3><p>AI가 읽기 쉬운 페이지 구조·UX·카피라이팅 정비.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">SCHEMA</span><h3>스키마·엔티티·llms.txt</h3><p>검증된 구조화 데이터·엔티티로 정확한 인용을 유도.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">OFFSITE</span><h3>Offsite 신뢰 신호</h3><p>언론·리뷰·커뮤니티 기반 권위 신호 구축.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">GEO</span><h3>AEO·GEO 콘텐츠</h3><p>AI 답변에 인용되도록 설계한 Q&amp;A·비교 콘텐츠 제작.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">SEO</span><h3>SEO 상위노출</h3><p>네이버·구글 검색 상위노출은 기본으로 함께 진행.</p></div>
      </div>
    </div>
  </section>

  <!-- 무료 AI 가시성 진단 리포트 -->
  <section class="section">
    <div class="container" style="text-align:center;">
      <div class="section-head center"><span class="tag">FREE DIAGNOSIS</span><h2 class="section-title">우리 브랜드는 지금 <span class="accent">AI에 나올까요?</span></h2><p class="section-sub">무료 AI 가시성 진단 리포트를 신청하시면, 컨설턴트가 직접 분석해 드립니다.</p></div>
      <ul class="report-check">
        <li>4대 AI 엔진별 현재 노출·언급 현황</li>
        <li>경쟁사 대비 인용 점유(인용 해자) 분석</li>
        <li>인용을 막는 온사이트·오프사이트 공백 진단</li>
        <li>90일 안에 손대야 할 개선 우선순위</li>
      </ul>
      <div class="hero-actions" style="justify-content:center;margin-top:34px;">
        <a href="contact.html" class="btn btn-primary">무료 진단 신청</a>
      </div>
    </div>
  </section>

  <!-- FAQ -->
  <section class="section alt-bg">
    <div class="container aeo-faq-wrap">
      <div class="section-head center"><span class="tag">FAQ</span><h2 class="section-title">AI마케팅 <span class="accent">자주 묻는 질문</span></h2></div>
      <div class="aeo-faq">
        <details open><summary>AI 추천 마케팅(AEO·GEO)이란 무엇인가요?</summary><p>ChatGPT·Gemini 같은 생성형 AI가 답변을 만들 때, 우리 브랜드를 <strong>근거로 인용하고 추천하게</strong> 만드는 마케팅입니다. 키워드 순위를 올리는 SEO와 달리, AI가 활용하는 데이터·구조·신뢰 신호 자체를 설계합니다.</p></details>
        <details><summary>기존 SEO와는 무엇이 다른가요?</summary><p>SEO는 검색 결과 상위 노출이 목표이고, AEO·GEO는 <strong>AI 답변에 등장</strong>하는 것이 목표입니다. 하오는 둘을 함께 진행해, 검색과 AI 답변 양쪽에서 브랜드가 보이게 만듭니다.</p></details>
        <details><summary>효과는 언제부터 보이나요?</summary><p>생성형 엔진이 인덱스를 갱신하는 주기에 따라 보통 <strong>60~90일</strong> 안에 인용·추천 변화가 나타나기 시작합니다. 구조화 콘텐츠와 언론 등 신뢰 신호가 쌓일수록 빨라집니다.</p></details>
        <details><summary>언론보도가 정말 AI 인용에 도움이 되나요?</summary><p>네. AI는 출처의 권위를 평가하며, <strong>정식 등록 언론 매체의 기사에 가장 높은 가중치</strong>를 둡니다. 그래서 하오는 <a href="pr.html">언론홍보</a>를 AI마케팅과 함께 설계합니다.</p></details>
        <details><summary>우리 업종도 효과가 있나요?</summary><p>병원·법률·프랜차이즈·커머스처럼 <strong>검색과 추천이 구매로 이어지는 업종</strong>일수록 효과가 큽니다. 무료 진단으로 우리 업종의 기회부터 확인해 보세요.</p></details>
      </div>
    </div>
  </section>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      { "@type": "Question", "name": "AI 추천 마케팅(AEO·GEO)이란 무엇인가요?", "acceptedAnswer": { "@type": "Answer", "text": "ChatGPT·Gemini 같은 생성형 AI가 답변을 만들 때 우리 브랜드를 근거로 인용하고 추천하게 만드는 마케팅입니다. 키워드 순위를 올리는 SEO와 달리, AI가 활용하는 데이터·구조·신뢰 신호 자체를 설계합니다." } },
      { "@type": "Question", "name": "AI마케팅은 기존 SEO와 무엇이 다른가요?", "acceptedAnswer": { "@type": "Answer", "text": "SEO는 검색 결과 상위 노출이 목표이고 AEO·GEO는 AI 답변에 등장하는 것이 목표입니다. 하오커뮤니케이션은 둘을 함께 진행해 검색과 AI 답변 양쪽에서 브랜드가 보이게 만듭니다." } },
      { "@type": "Question", "name": "AI마케팅 효과는 언제부터 보이나요?", "acceptedAnswer": { "@type": "Answer", "text": "생성형 엔진이 인덱스를 갱신하는 주기에 따라 보통 60~90일 안에 인용·추천 변화가 나타나기 시작합니다. 구조화 콘텐츠와 언론 등 신뢰 신호가 쌓일수록 빨라집니다." } },
      { "@type": "Question", "name": "언론보도가 정말 AI 인용에 도움이 되나요?", "acceptedAnswer": { "@type": "Answer", "text": "네. AI는 출처의 권위를 평가하며 정식 등록 언론 매체의 기사에 가장 높은 가중치를 둡니다. 그래서 하오커뮤니케이션은 언론홍보를 AI마케팅과 함께 설계합니다." } },
      { "@type": "Question", "name": "우리 업종도 AI마케팅 효과가 있나요?", "acceptedAnswer": { "@type": "Answer", "text": "병원·법률·프랜차이즈·커머스처럼 검색과 추천이 구매로 이어지는 업종일수록 효과가 큽니다. 무료 진단으로 업종별 기회를 먼저 확인할 수 있습니다." } }
    ]
  }
  </script>
EOF
cta_band
footer_close
} > ai-marketing.html

# ---------- 언론홍보 ----------
{
head_open "언론홍보 · AI PR Agent | 하오커뮤니케이션" "AI가 기사거리를 발굴하고 기사화 가능성을 분석해 실제 기사화까지 지원하는 AI 언론홍보 솔루션, AI PR Agent."
banner "PR &amp; MEDIA" "언론홍보" "AI가 기사거리를 발굴하고, 기사화 가능성을 높입니다"
cat <<EOF
  <!-- AI 시대의 언론보도 (AEO/GEO 연결) -->
  <section class="section">
    <div class="container">
      <div class="section-head center"><span class="tag">AI &times; PR</span><h2 class="section-title">AI 시대, <span class="accent">언론보도가 더 중요해졌습니다</span></h2><p class="section-sub">AI는 답변의 근거로 삼을 출처의 권위(authority)를 평가합니다. 그리고 정식 등록 언론 매체의 기사를 가장 신뢰합니다.</p></div>
      <div class="trust-tiers">
        <div class="trust-tier trust-tier--top"><span class="trust-rank">1순위 · 최상</span><div class="trust-body"><h4>등록 언론사 보도</h4><p>제3자 검증을 거친 기사는 AI가 가장 높은 가중치로 신뢰하는 인용 근거입니다.</p></div></div>
        <div class="trust-tier trust-tier--mid"><span class="trust-rank">2순위</span><div class="trust-body"><h4>기업 공식 웹사이트</h4><p>구조화 데이터가 잘 정비된 공식 사이트. 신뢰 신호를 보조합니다.</p></div></div>
        <div class="trust-tier trust-tier--low"><span class="trust-rank">3순위</span><div class="trust-body"><h4>블로그 · SNS · 커뮤니티</h4><p>보조 신호로 쓰이지만 단독으로는 인용 무게가 낮습니다.</p></div></div>
      </div>
      <p class="trust-note">즉, 언론보도는 브랜드 홍보를 넘어 <strong>AI가 우리 브랜드를 추천하게 만드는 핵심 자산</strong>입니다.<br />하오는 언론홍보를 <a href="ai-marketing.html">AI마케팅(AEO·GEO) →</a> 와 하나의 전략으로 설계합니다.</p>
    </div>
  </section>

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      { "@type": "Question", "name": "언론보도가 AI 추천(AEO·GEO)에 도움이 되나요?", "acceptedAnswer": { "@type": "Answer", "text": "네. AI는 출처의 권위를 평가하며 정식 등록 언론 매체의 기사에 가장 높은 가중치를 둡니다. 언론보도는 AI가 브랜드를 신뢰 근거로 인용·추천하게 만드는 핵심 자산입니다. 하오커뮤니케이션은 언론홍보를 AI마케팅과 하나의 전략으로 설계합니다." } },
      { "@type": "Question", "name": "작은 회사도 언론보도가 가능한가요?", "acceptedAnswer": { "@type": "Answer", "text": "가능합니다. 신제품 출시, 수상, 투자, 사회공헌, 업계 트렌드 코멘트 등 뉴스 가치가 있는 앵글을 잡으면 규모와 무관하게 보도될 수 있습니다. 중요한 것은 회사 규모가 아니라 뉴스 가치입니다." } }
    ]
  }
  </script>

  <section class="section vch-intro">
    <div class="container">
      <span class="tag">AI PR AGENT</span>
      <h2 class="section-title">AI가 보도자료를 쓰는 게 아니라,<br /><span class="accent">기사화 가능성</span>을 높입니다</h2>
      <p class="vch-lead">AI PR Agent는 단순히 보도자료를 작성하는 AI가 아닙니다. 기업 정보를 입력하면 AI가 <strong>기사거리를 발굴</strong>하고, 뉴스 가치와 기사화 가능성을 분석한 뒤 보도자료 작성·기자 추천·맞춤 메일 발송·기사화 추적까지 <strong>하나의 프로세스</strong>로 지원하는 AI 언론홍보 솔루션입니다.</p>
      <div class="hero-actions" style="justify-content:center;">
        <a href="contact.html" class="btn btn-primary">도입 상담 문의</a>
      </div>
      <p class="pr-note">* AI PR Agent는 하오커뮤니케이션과 <strong>계약한 기업에게만 제공</strong>되는 전용 솔루션입니다. (체험판 없음)</p>
    </div>
  </section>

  <section class="section vch-process alt-bg" id="process">
    <div class="container">
      <div class="section-head center"><span class="tag">PROCESS</span><h2 class="section-title">발굴부터 검증까지, <span class="accent">AI가 전 과정 지원</span></h2><p class="section-sub">기존 PR이 '작성·배포'에 머문다면, AI PR Agent는 결과까지 데이터로 검증합니다.</p></div>
      <div class="pr-flow">
        <div class="pr-step"><span class="pr-n">01</span><span class="pr-t">기사거리 발굴</span></div>
        <div class="pr-step"><span class="pr-n">02</span><span class="pr-t">기사화 가능성 판단</span></div>
        <div class="pr-step"><span class="pr-n">03</span><span class="pr-t">보도자료 생성</span></div>
        <div class="pr-step"><span class="pr-n">04</span><span class="pr-t">기자 추천</span></div>
        <div class="pr-step"><span class="pr-n">05</span><span class="pr-t">맞춤 메일 발송</span></div>
        <div class="pr-step"><span class="pr-n">06</span><span class="pr-t">기사화 검증</span></div>
        <div class="pr-step pr-step-hi"><span class="pr-n">07</span><span class="pr-t">결과 분석</span></div>
      </div>
    </div>
  </section>

  <section class="section">
    <div class="container">
      <div class="section-head center"><span class="tag">DIFFERENCE</span><h2 class="section-title">기존 PR과 <span class="accent">무엇이 다른가</span></h2></div>
      <div class="vs-wrap">
        <table class="vs-table">
          <thead><tr><th></th><th>기존 PR 서비스</th><th class="vs-hi">AI PR Agent</th></tr></thead>
          <tbody>
            <tr><td>초점</td><td>보도자료 작성·배포</td><td class="vs-hi">기사거리 발굴 ~ 결과 분석 전 과정</td></tr>
            <tr><td>기사화 판단</td><td>담당자 감·경험</td><td class="vs-hi">AI가 뉴스 가치·기사화 가능성 분석</td></tr>
            <tr><td>기자 매칭</td><td>보유 리스트 발송</td><td class="vs-hi">AI 기자 추천 + 맞춤 메일 생성</td></tr>
            <tr><td>검증·개선</td><td>제한적</td><td class="vs-hi">기사화 추적·결과 데이터 축적으로 정확도 개선</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </section>

  <section class="section vch-process alt-bg">
    <div class="container" style="max-width:820px;text-align:center;">
      <span class="tag">OUR GOAL</span>
      <h2 class="section-title" style="margin:16px 0 22px;">우리가 만드는 건 <span class="accent">AI PR 컨설턴트</span>입니다</h2>
      <p class="pr-quote">"AI가 보도자료를 작성하는 것이 아니라,<br />기업의 기사거리를 발굴하고 실제 기사화 가능성을 높이는 <strong>AI PR 컨설턴트</strong>."</p>
      <p class="vch-lead" style="margin-top:20px;">실제 기사화 결과를 데이터로 축적해 AI의 판단 정확도를 지속적으로 검증·개선하고, 더 효과적인 홍보 전략을 제안하는 것을 목표로 개발하고 있습니다.</p>
      <div class="hero-actions" style="justify-content:center;margin-top:12px;">
        <a href="contact.html" class="btn btn-primary">도입 상담 문의</a>
      </div>
    </div>
  </section>
EOF
cta_band
footer_close
} > pr.html

# ---------- SNS마케팅 ----------
{
head_open "SNS마케팅 | 하오커뮤니케이션" "인스타·유튜브·틱톡 채널별 콘텐츠와 퍼포먼스 광고로 팬덤을 만드는 하오의 SNS마케팅."
banner "SNS MARKETING" "SNS마케팅" "사람들이 머무는 곳에 브랜드가 있어야 한다"
cat <<'EOF'
  <!-- 인트로 + 그래프 -->
  <section class="section">
    <div class="container sns-hero-grid">
      <div class="sns-hero-txt">
        <span class="tag">SNS MARKETING</span>
        <h2 class="section-title" style="margin:14px 0 22px;">SNS를 꾸준히 해도<br /><span class="accent">손님이 오지 않나요?</span></h2>
        <p class="sns-hero-p">SNS를 꾸준히 하고 있음에도 손님이 늘지 않는다면 <strong>확산</strong>되는 콘텐츠인지, <strong>게시물</strong>의 완성도는 충분한지, <strong>경쟁사</strong> 대비 차별점은 있는지 확인해야 합니다. 세 가지 요소를 모두 갖춰야만 SNS가 <strong>매출</strong>로 이어집니다.</p>
        <div class="sns-formula">
          <span class="fc">확산</span><span class="op">+</span>
          <span class="fc">게시물</span><span class="op">+</span>
          <span class="fc">경쟁력</span><span class="op">=</span>
          <span class="fc result">매출 상승</span>
        </div>
      </div>
      <div class="sns-visual">
        <div class="sns-chartcard">
          <svg viewBox="0 0 320 210" class="sns-bars" aria-hidden="true">
            <defs><linearGradient id="snsbar" x1="0" y1="1" x2="0" y2="0"><stop offset="0" stop-color="#ff7a45"/><stop offset="1" stop-color="#ea4324"/></linearGradient></defs>
            <rect x="20" y="150" width="38" height="48" rx="7" fill="url(#snsbar)" opacity="0.5" />
            <rect x="70" y="122" width="38" height="76" rx="7" fill="url(#snsbar)" opacity="0.66" />
            <rect x="120" y="92" width="38" height="106" rx="7" fill="url(#snsbar)" opacity="0.8" />
            <rect x="170" y="62" width="38" height="136" rx="7" fill="url(#snsbar)" opacity="0.9" />
            <rect x="220" y="30" width="38" height="168" rx="7" fill="url(#snsbar)" />
            <path d="M32 168 C110 150 200 108 292 36" fill="none" stroke="#ea4324" stroke-width="3.5" stroke-linecap="round" />
            <path d="M292 36 l-20 1 l11 16 z" fill="#ea4324" />
          </svg>
        </div>
        <div class="sns-stat sns-stat-a"><b>조회수</b><strong>12,540</strong></div>
        <div class="sns-stat sns-stat-b"><b>문의 수</b><strong>+300%</strong></div>
      </div>
    </div>
  </section>

  <!-- 경쟁력 강화 프로세스 -->
  <section class="section vch-process alt-bg" id="process">
    <div class="container">
      <div class="section-head center"><span class="tag">SNS 마케팅</span><h2 class="section-title">시장 분석을 통한 <span class="accent">경쟁력 강화</span></h2><p class="section-sub">업계 우수 사례와 경쟁사를 비교 분석해 차별화된 전략을 수립하고, 사업의 본질적 개선을 이끕니다.</p></div>
      <div class="vch-steps">
        <div class="vch-step"><span class="vch-step-num"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><path d="M21 21l-4-4" stroke-linecap="round"/></svg></span><h3>업체 탐색</h3><p>동종 업계에서 잘되는 업체를 찾아 성공 요인을 분석합니다.</p></div>
        <div class="vch-step"><span class="vch-step-num"><svg viewBox="0 0 24 24" fill="currentColor"><rect x="4" y="12" width="4" height="8" rx="1"/><rect x="10" y="7" width="4" height="13" rx="1"/><rect x="16" y="3" width="4" height="17" rx="1"/></svg></span><h3>강점·약점 분석</h3><p>우리 브랜드의 강점과 약점을 데이터로 진단합니다.</p></div>
        <div class="vch-step"><span class="vch-step-num"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18h6M10 21h4M12 3a6 6 0 0 0-4 10.5c.7.6 1 1.3 1 2.5h6c0-1.2.3-1.9 1-2.5A6 6 0 0 0 12 3z" stroke-linejoin="round"/></svg></span><h3>차별화 전략</h3><p>경쟁사 대비 차별화된 콘텐츠·경쟁력을 설계합니다.</p></div>
        <div class="vch-step"><span class="vch-step-num"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M7 4h10v5a5 5 0 0 1-10 0V4zM7 6H4v2a3 3 0 0 0 3 3M17 6h3v2a3 3 0 0 1-3 3M9 18h6M10 21h4" stroke-linejoin="round"/></svg></span><h3>시장 경쟁력 강화</h3><p>실행·최적화로 시장에서의 경쟁력을 끌어올립니다.</p></div>
      </div>
    </div>
  </section>

  <!-- 서비스 효과 (VS 비교표) -->
  <section class="section">
    <div class="container">
      <div class="section-head center"><span class="tag">서비스 효과</span><h2 class="section-title">실제 매장 창업의 <span class="accent">10%도 안 되는 비용</span></h2><p class="section-sub">SNS 계정이 제대로 운영되면 오프라인 매장을 뛰어넘는 매출을 만들 수 있습니다.</p></div>
      <div class="vs-wrap">
        <table class="vs-table">
          <thead><tr><th></th><th class="vs-hi">SNS 운영</th><th>실제 매장</th></tr></thead>
          <tbody>
            <tr><td>초기 비용</td><td class="vs-hi">월 단위 합리적 운영비</td><td>수천만 ~ 수억원</td></tr>
            <tr><td>고정 지출</td><td class="vs-hi">낮은 고정비</td><td>임대료·인건비·운영비</td></tr>
            <tr><td>리스크</td><td class="vs-hi">전국·무한 확장 / 로우 리스크</td><td>제한적 지역 / 하이 리스크</td></tr>
            <tr><td>매출 효과</td><td class="vs-hi">높은 확장성 / 반복 매출</td><td>제한적 / 확장 어려움</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </section>

  <!-- 채널 -->
  <section class="section vch-products alt-bg">
    <div class="container">
      <div class="section-head center"><span class="tag">CHANNELS</span><h2 class="section-title">채널별 <span class="accent">맞춤 운영</span></h2></div>
      <div class="vch-prod-grid">
        <div class="vch-prod"><span class="vch-prod-ic">IG</span><h3>인스타그램</h3><p>피드·릴스·스토리로 브랜드 팬덤을 만듭니다.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">YT</span><h3>유튜브</h3><p>롱폼·숏폼 영상으로 신뢰와 도달을 확보합니다.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">TT</span><h3>틱톡·숏폼</h3><p>알고리즘에 맞춘 숏폼으로 조회수를 매출로.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">VIRAL</span><h3>인플루언서·체험단</h3><p>바이럴과 체험단 협업으로 입소문을 설계합니다.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">ADS</span><h3>퍼포먼스 광고</h3><p>정밀 타깃 광고로 ROAS를 최적화합니다.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">DATA</span><h3>분석·리포트</h3><p>성과를 데이터로 진단하고 다음 전략을 세웁니다.</p></div>
      </div>
    </div>
  </section>

  <!-- CTA -->
  <section class="sns-cta">
    <div class="container sns-cta-inner">
      <div class="sns-cta-txt">
        <h2>SNS 마케팅으로 매출 상승의 기회를 잡으세요!</h2>
        <p>확산·게시물·경쟁력 개선으로 매출 상향을 직접 경험하세요.</p>
        <a href="contact.html" class="btn btn-light">무료 상담 신청 →</a>
      </div>
      <div class="sns-cta-feats">
        <div><span class="ico"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 11.5a8 8 0 1 1-3.5-6.6L21 4l-1 4-4-.5" stroke-linecap="round" stroke-linejoin="round"/><circle cx="12" cy="12" r="3"/></svg></span>1:1 맞춤 컨설팅</div>
        <div><span class="ico"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2h9l5 5v15H6zM15 2v5h5" stroke-linejoin="round"/><path d="M9 13h6M9 17h6" stroke-linecap="round"/></svg></span>분석 리포트 제공</div>
        <div><span class="ico"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 17l6-6 4 4 8-8" stroke-linecap="round" stroke-linejoin="round"/><path d="M15 7h6v6" stroke-linecap="round" stroke-linejoin="round"/></svg></span>실행 가이드 제공</div>
      </div>
    </div>
  </section>
EOF
footer_close
} > sns.html

# ---------- 프랜차이즈 ----------
{
head_open "프랜차이즈마케팅 | 하오커뮤니케이션" "본사 브랜딩부터 가맹점 모집까지, 확장을 설계하는 하오의 프랜차이즈마케팅."
banner "FRANCHISE" "프랜차이즈마케팅" "본사 브랜딩부터 가맹점 모집까지"
cat <<'EOF'
  <section class="section vch-intro">
    <div class="container">
      <span class="tag">FRANCHISE</span>
      <h2 class="section-title">프랜차이즈 <span class="accent">확장</span>이<br />막막하신가요?</h2>
      <p class="vch-lead">이제 막 시작하는 브랜드부터 가맹 확장까지. 보여주기식 광고가 아니라 <strong>‘매출 구조’ 자체</strong>를 설계합니다.<br />브랜드 기획·마케팅·가맹영업·홈페이지까지 — 여기저기 알아볼 필요 없이 하오가 원스톱으로 해결합니다.</p>
      <div class="hero-actions" style="justify-content:center;">
        <a href="contact.html" class="btn btn-primary">프랜차이즈 상담</a>
        <a href="#process" class="btn btn-ghost-dark">진행 프로세스 보기 ↓</a>
      </div>
    </div>
  </section>

  <section class="section why">
    <div class="container">
      <div class="section-head center"><span class="tag">WHY HAO</span><h2 class="section-title">왜 하오와 <span class="accent">함께</span>해야 할까요</h2></div>
      <div class="why-grid">
        <div class="why-card"><span class="why-num">01</span><h3>전략부터 운영까지 원스톱</h3><p>보고서만 주는 컨설팅이 아닙니다. 기획·마케팅·가맹영업·운영까지 직접 실행합니다.</p></div>
        <div class="why-card"><span class="why-num">02</span><h3>인하우스 인프라</h3><p>디자인·개발·마케팅 팀이 모두 내부에 있어, 빠르고 일관된 결과물을 만듭니다.</p></div>
        <div class="why-card"><span class="why-num">03</span><h3>검증된 노하우</h3><p>현장에서 검증한 ‘팔리는 구조’만 적용합니다. 이론이 아니라 실제 성과로 증명합니다.</p></div>
      </div>
    </div>
  </section>

  <section class="section vch-products">
    <div class="container">
      <div class="section-head center"><span class="tag">SOLUTION</span><h2 class="section-title">프랜차이즈 <span class="accent">통합 솔루션</span></h2><p class="section-sub">개인 창업자부터 프랜차이즈 본사까지, 유형에 맞는 솔루션을 제공합니다.</p></div>
      <div class="vch-prod-grid">
        <div class="vch-prod"><span class="vch-prod-ic">PLAN</span><h3>브랜드 기획·컨설팅</h3><p>업종·수익구조 진단부터 사업 로드맵까지 설계합니다.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">BRAND</span><h3>본사 브랜딩</h3><p>CI·BI, 매장 컨셉, 브랜드 가이드로 확장의 토대를 만듭니다.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">SALES</span><h3>가맹 영업·DB</h3><p>단순 DB 수집이 아니라 점주를 설득하는 상담 구조를 설계합니다.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">WEB</span><h3>가맹 모집 홈페이지</h3><p>문의가 들어오는 가맹 홈페이지를 기획·제작합니다.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">AD</span><h3>온·오프라인 마케팅</h3><p>브랜딩과 퍼포먼스를 결합해 인지도와 가맹문의를 동시에.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">PROFIT</span><h3>수익 최적화</h3><p>본사·가맹점 수익 구조와 운영을 함께 최적화합니다.</p></div>
      </div>
    </div>
  </section>

  <section class="section vch-process alt-bg" id="process">
    <div class="container">
      <div class="section-head center"><span class="tag">PROCESS</span><h2 class="section-title">문의부터 성과까지 <span class="accent">4단계</span></h2></div>
      <div class="vch-steps">
        <div class="vch-step"><span class="vch-step-num">01</span><h3>현황 진단</h3><p>무료 상담으로 사업 구조를 분석하고 개선 포인트를 도출합니다.</p></div>
        <div class="vch-step"><span class="vch-step-num">02</span><h3>솔루션 설계</h3><p>목표 설정부터 수익구조·실행 로드맵까지 작성합니다.</p></div>
        <div class="vch-step"><span class="vch-step-num">03</span><h3>실행 지원</h3><p>전담 PM 배정 후 단계별 실행을 지원하고 진행 상황을 공유합니다.</p></div>
        <div class="vch-step"><span class="vch-step-num">04</span><h3>성과·최적화</h3><p>KPI 트래킹과 월간 리포트로 지속 개선하고 장기 성장을 함께 설계합니다.</p></div>
      </div>
    </div>
  </section>

  <section class="section alt-bg">
    <div class="container" style="max-width:820px;">
      <div class="section-head center"><span class="tag">FAQ</span><h2 class="section-title">자주 묻는 질문</h2></div>
      <div class="faq" style="border-top:none;padding-top:0;">
        <div class="faq-item"><h3>이제 막 시작하는 브랜드도 가능한가요?</h3><p>네. 브랜드 기획 단계부터 함께합니다. 아이템·컨셉 정립, 수익구조 설계부터 시작해 확장의 토대를 만들어 드립니다.</p></div>
        <div class="faq-item"><h3>가맹점 모집까지 도와주나요?</h3><p>가맹 모집 홈페이지 제작, DB 광고, 상담 전환 설계까지 실제 가맹 계약으로 이어지는 전 과정을 지원합니다.</p></div>
        <div class="faq-item"><h3>비용은 어떻게 되나요?</h3><p>브랜드 상황과 필요한 범위에 따라 맞춤 견적으로 안내드립니다. 먼저 무료 상담으로 진단부터 받아보세요.</p></div>
      </div>
    </div>
  </section>
EOF
cta_band
footer_close
} > franchise.html

# ---------- 변호사 ----------
{
head_open "변호사마케팅 | 하오커뮤니케이션" "법률 규정을 준수하며 상담 전환을 만드는 하오의 변호사마케팅."
banner "LEGAL" "변호사마케팅" "전문성을 콘텐츠로 증명하다"
cat <<'EOF'
  <section class="section vch-intro">
    <div class="container">
      <span class="tag">LEGAL MARKETING</span>
      <h2 class="section-title">변호사는 전문분야가 있는데,<br /><span class="accent">전문 마케터</span>는 없을까요?</h2>
      <p class="vch-lead">변호사 마케팅은 기성복이 아닙니다. <strong>도구가 같다고 결과가 같지 않습니다.</strong><br />법률 시장의 광고 규정과 의뢰인의 심리를 이해하는 맞춤 전략이 필요합니다. 하오는 법률 분야의 신뢰 기반 마케팅을 설계합니다.</p>
      <div class="hero-actions" style="justify-content:center;">
        <a href="contact.html" class="btn btn-primary">변호사마케팅 상담</a>
        <a href="#process" class="btn btn-ghost-dark">진행 방식 보기 ↓</a>
      </div>
    </div>
  </section>

  <section class="section why">
    <div class="container">
      <div class="section-head center"><span class="tag">WHY HAO</span><h2 class="section-title">법률 마케팅, <span class="accent">이렇게</span> 다릅니다</h2></div>
      <div class="why-grid">
        <div class="why-card"><span class="why-num">01</span><h3>규정 준수</h3><p>변호사법·광고 규정을 지키며 안전하게 진행합니다. 위반 리스크를 사전에 차단합니다.</p></div>
        <div class="why-card"><span class="why-num">02</span><h3>신뢰가 전환을 만든다</h3><p>전문성을 콘텐츠로 증명해 의뢰인의 신뢰를 얻고, 실제 상담으로 연결합니다.</p></div>
        <div class="why-card"><span class="why-num">03</span><h3>분야별 맞춤</h3><p>형사·이혼·기업·부동산 등 분야마다 다른 키워드와 전략으로 차별화합니다.</p></div>
      </div>
    </div>
  </section>

  <section class="section vch-products">
    <div class="container">
      <div class="section-head center"><span class="tag">SERVICES</span><h2 class="section-title">법률마케팅 <span class="accent">맞춤 서비스</span></h2></div>
      <div class="vch-prod-grid">
        <div class="vch-prod"><span class="vch-prod-ic">BLOG</span><h3>변호사 블로그</h3><p>분야별 전문성을 담은 블로그로 신뢰와 검색 노출을 동시에.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">SEO</span><h3>검색 상위노출</h3><p>의뢰인이 찾는 키워드에서 상위에 노출되도록 최적화.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">WEB</span><h3>법률 홈페이지 제작</h3><p>전문성과 신뢰를 전하고 상담으로 이어지는 홈페이지.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">AD</span><h3>키워드 광고</h3><p>상담 의도가 높은 키워드에 집중한 검색광고 운영.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">PLAN</span><h3>마케팅 컨설팅</h3><p>목표와 분야에 맞춘 전략 설계와 성과 컨설팅.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">LAND</span><h3>상담 전환 랜딩</h3><p>클릭을 상담 신청으로 바꾸는 랜딩페이지 최적화.</p></div>
      </div>
    </div>
  </section>

  <section class="section vch-process alt-bg" id="process">
    <div class="container">
      <div class="section-head center"><span class="tag">PROCESS</span><h2 class="section-title">진행 <span class="accent">4단계</span></h2></div>
      <div class="vch-steps">
        <div class="vch-step"><span class="vch-step-num">01</span><h3>상담·진단</h3><p>원하는 목표와 분야, 현재 상황을 파악합니다.</p></div>
        <div class="vch-step"><span class="vch-step-num">02</span><h3>전략 설계</h3><p>분야별 키워드·콘텐츠·광고 전략을 규정에 맞게 설계합니다.</p></div>
        <div class="vch-step"><span class="vch-step-num">03</span><h3>콘텐츠·광고 실행</h3><p>블로그·홈페이지·검색광고를 제작·집행합니다.</p></div>
        <div class="vch-step"><span class="vch-step-num">04</span><h3>상담 관리·최적화</h3><p>상담 유입을 추적하고 성과 기반으로 지속 개선합니다.</p></div>
      </div>
    </div>
  </section>

  <section class="section alt-bg">
    <div class="container" style="max-width:820px;">
      <div class="section-head center"><span class="tag">FAQ</span><h2 class="section-title">자주 묻는 질문</h2></div>
      <div class="faq" style="border-top:none;padding-top:0;">
        <div class="faq-item"><h3>변호사 마케팅, 꼭 해야 할까요?</h3><p>경쟁이 치열해질수록 의뢰인은 검색으로 변호사를 찾습니다. 검색 결과에 보이지 않으면 선택지에 들어가지 못합니다. 마케팅은 선택이 아니라 노출의 기본이 되었습니다.</p></div>
        <div class="faq-item"><h3>변호사 블로그, 효과가 있나요?</h3><p>있습니다. 단, 제대로 해야 합니다. 분야 전문성과 검색 구조를 갖춘 블로그만이 신뢰와 상담으로 이어집니다.</p></div>
        <div class="faq-item"><h3>광고 규정 위반이 걱정됩니다.</h3><p>변호사법과 광고 규정을 숙지한 상태로 콘텐츠·광고를 설계합니다. 규정 준수를 전제로 안전하게 진행합니다.</p></div>
      </div>
    </div>
  </section>
EOF
cta_band
footer_close
} > lawyer.html

# ---------- 병원 ----------
{
head_open "병원마케팅 | 하오커뮤니케이션" "의료광고 심의 기준을 준수하며 내원 환자를 늘리는 하오의 병원마케팅."
banner "MEDICAL" "병원마케팅" "이제는! 병원마케팅도 트렌디하게"
cat <<'EOF'
  <!-- 히어로 + AI 검색 타이핑 목업 -->
  <section class="section hosp-hero">
    <div class="container hosp-hero-grid">
      <div class="hosp-hero-txt">
        <span class="tag">AI SEARCH OPTIMIZATION</span>
        <h2 class="section-title" style="margin:16px 0 20px;">환자가 AI에게 물었을 때,<br /><span class="accent">우리 병원이 답</span>이<br />되고 있습니까?</h2>
        <p class="hosp-lead">그 답을 만드는 방법이 있습니다.<br />지금이 시작할 때입니다.</p>
        <div class="hosp-engines">
          <p class="hosp-eng-label">실시간 대응 가능 AI 엔진</p>
          <div class="hosp-eng-row">
            <span class="eng"><i class="eng-dot" style="background:#10a37f"></i>ChatGPT</span>
            <span class="eng"><i class="eng-dot" style="background:#4285f4"></i>Gemini</span>
            <span class="eng"><i class="eng-dot" style="background:#d97757"></i>Claude</span>
            <span class="eng"><i class="eng-dot" style="background:#20808d"></i>Perplexity</span>
          </div>
        </div>
      </div>
      <div class="ai-mock" id="aiMock">
        <div class="ai-bar"><span class="ai-dots"><i></i><i></i><i></i></span><span class="ai-url">haocomm.ai/analysis-preview</span></div>
        <div class="ai-body">
          <div class="ai-query"><span id="aiType" data-text='"우리 동네 잘하는 병원 추천해줘"'></span><span class="ai-caret"></span><span class="ai-spark">✦</span></div>
          <div class="ai-answer" id="aiAnswer">
            <p class="ai-ans">평판이 좋은 병원을 분석했습니다. 진료 후기, AI 검색 빈도, 환자 만족도를 기반으로 추천 결과를 정리해 드립니다.</p>
            <div class="ai-card ai-card-hi"><div><strong>우리 병원</strong><span>도보 3분 · 전문의 3인 상주 · 환자 만족도 4.8</span></div><span class="ai-badge">★ 최적화 완료</span></div>
            <div class="ai-card"><div><strong>OO의원</strong><span>레이저 시술 특화 · 야간 진료 가능</span></div></div>
            <div class="ai-card"><div><strong>OO클리닉</strong><span>20년 경력 · 만성질환 전문</span></div></div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- 3가지 이유 (지그재그) -->
  <section class="section alt-bg">
    <div class="container">
      <div class="section-head center"><span class="tag">WHY NOT YET</span><h2 class="section-title">병원이 <span class="accent">AI 검색</span>을 놓쳤던 3가지 이유</h2></div>
      <div class="reason-tl">
        <div class="rtl-item"><div class="rtl-card"><h3>당장 환자가 급한데</h3><p>3~6개월 기다려야 효과가 나온다는데, 이번 달 매출이 급한 원장님께 그건 먼 이야기였습니다.</p></div><span class="rtl-num">01</span></div>
        <div class="rtl-item"><span class="rtl-num">02</span><div class="rtl-card"><h3>뭐가 달라지는지 모르겠는데</h3><p>돈을 쓰면 뭐가 바뀌는지 눈에 보여야 하는데, 설명을 들어도 감이 안 왔습니다.</p></div></div>
        <div class="rtl-item"><div class="rtl-card"><h3>블로그·인스타가 더 잘 되는데</h3><p>블로그·인스타·유튜브는 바로 반응이 보이는데, AI 검색까지 할 필요가 있었을까요?</p></div><span class="rtl-num">03</span></div>
      </div>
    </div>
  </section>

  <!-- 검색 시장 규칙 (다크 + 로고 별자리) -->
  <section class="section hosp-dark">
    <div class="night-sky"></div>
    <div class="container hosp-dark-grid">
      <div class="hosp-dark-txt">
        <h2 class="section-title">검색 시장의<br />규칙이 <span class="accent">바뀌었습니다.</span></h2>
        <p>GEO(Generative Engine Optimization)는 AI 기반 검색엔진이 생성하는 답변에 우리 병원 정보가 포함되도록 콘텐츠를 최적화하는 기술입니다.</p>
        <p class="dim">지금 우리 병원을 검색하면 어떤 결과가 나오는지 확인해보셨습니까?</p>
        <ul class="hosp-checks">
          <li>AEO · GEO · LLMO 진단</li>
          <li>검색 대응력 진단 리포트</li>
          <li>우리 병원만의 브랜드 구축</li>
        </ul>
      </div>
      <div class="constellation" aria-hidden="true">
        <svg class="cons-lines" viewBox="0 0 400 360" preserveAspectRatio="none">
          <polyline points="150,60 250,110 300,70 320,150 360,190 300,240 200,300 120,210 150,60" fill="none" stroke="rgba(255,255,255,0.13)" stroke-width="1" />
        </svg>
        <span class="cl" style="top:10%;left:32%;animation-delay:0s"><img src="assets/logos/google.svg" alt="" />Google</span>
        <span class="cl" style="top:20%;left:62%;animation-delay:.6s"><img src="assets/logos/claude.svg" alt="" />Claude</span>
        <span class="cl" style="top:34%;left:70%;animation-delay:1.2s"><img src="assets/logos/youtube.svg" alt="" />YouTube</span>
        <span class="cl" style="top:44%;left:28%;animation-delay:.4s"><img src="assets/logos/naver.svg" alt="" />네이버</span>
        <span class="cl" style="top:50%;left:58%;animation-delay:1.6s"><img src="assets/logos/perplexity.svg" alt="" />Perplexity</span>
        <span class="cl" style="top:60%;left:76%;animation-delay:.9s"><img src="assets/logos/chatgpt.svg" alt="" />ChatGPT</span>
        <span class="cl" style="top:74%;left:34%;animation-delay:1.4s"><img src="assets/logos/gemini.svg" alt="" />Gemini</span>
        <span class="cl" style="top:86%;left:54%;animation-delay:.2s"><img src="assets/logos/instagram.svg" alt="" />Instagram</span>
      </div>
    </div>
  </section>

  <!-- 통계 -->
  <section class="section">
    <div class="container hosp-stats">
      <div class="hstat"><strong><i data-count="527">0</i><em class="pct">%</em></strong><b>AI 검색 유입</b><span>1년 만에 급증하는 추세</span></div>
      <div class="hstat"><strong><i data-count="54.5">0</i><em class="pct">%</em></strong><b>ChatGPT 이용률</b><span>한국인 2명 중 1명</span></div>
      <div class="hstat"><strong><i data-count="88">0</i><em class="pct">%</em></strong><b>의료 검색의 88%</b><span>AI가 먼저 답하는 시대</span></div>
    </div>
  </section>

  <!-- 서비스 -->
  <section class="section alt-bg">
    <div class="container">
      <div class="section-head center"><span class="tag">SERVICES</span><h2 class="section-title">병원 맞춤 <span class="accent">AI 검색 최적화</span></h2><p class="section-sub">의료광고 심의 기준을 준수하며 진행합니다.</p></div>
      <div class="vch-prod-grid">
        <div class="vch-prod"><span class="vch-prod-ic">AUDIT</span><h3>AI 노출 진단</h3><p>주요 AI·포털에서 우리 병원이 어떻게 검색되는지 진단합니다.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">GEO</span><h3>병원 AEO·GEO</h3><p>AI 답변에 우리 병원이 인용·추천되도록 콘텐츠를 최적화합니다.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">CONTENT</span><h3>의료 콘텐츠</h3><p>진료과목별 전문 콘텐츠로 신뢰와 검색 노출을 동시에.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">REVIEW</span><h3>후기·평판 관리</h3><p>진료 후기와 평판을 관리해 AI가 신뢰하는 데이터로 만듭니다.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">SEO</span><h3>검색 상위노출</h3><p>네이버·구글 지역 검색 상위노출로 내원 환자를 늘립니다.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">WEB</span><h3>홈페이지 최적화</h3><p>예약·문의로 이어지는 병원 홈페이지 구조를 설계합니다.</p></div>
      </div>
    </div>
  </section>
EOF
cta_band
footer_close
} > hospital.html

# ---------- 학원 ----------
{
head_open "학원마케팅 | 하오커뮤니케이션" "블로그 개수가 아니라 실제 원생 등록으로 증명하는 학원마케팅. 네이버 플레이스·블로그·검색광고부터 META·구글까지, 교육 업종을 아는 하오가 등록으로 이어지는 마케팅을 설계합니다."
banner "ACADEMY" "학원마케팅" "포스팅 개수가 아니라, 실제 원생 등록으로 증명합니다"
cat <<'EOF'
  <!-- 1. 문제 공감 -->
  <section class="section ac-pain">
    <div class="container">
      <div class="section-head center">
        <span class="tag">WHY THIS PAGE</span>
        <h2 class="section-title">혹시, <span class="accent">이런 고민</span> 없으신가요?</h2>
      </div>
      <div class="ac-pain-grid">
        <div class="ac-pain-card"><span class="ac-pain-ico">📉</span><p>광고비만 <strong>매달 빠져나가는데</strong><br />정작 문의 전화는 조용합니다.</p></div>
        <div class="ac-pain-card"><span class="ac-pain-ico">📍</span><p>네이버 지도에서 <strong>옆 학원이</strong><br />우리보다 위에 먼저 뜹니다.</p></div>
        <div class="ac-pain-card"><span class="ac-pain-ico">✍️</span><p>블로그는 열심히 올리는데<br /><strong>등록으로 이어지질 않습니다.</strong></p></div>
        <div class="ac-pain-card"><span class="ac-pain-ico">🤝</span><p>대행사는 많은데 <strong>학원이</strong><br /><strong>뭔지</strong> 이해하는 곳이 없습니다.</p></div>
      </div>
      <p class="ac-pain-punch">문제는 <span class="strike">노출</span>이 아니라, <span class="accent">등록</span>입니다.</p>
    </div>
  </section>

  <!-- 2. 핵심 메시지 -->
  <section class="section ac-claim">
    <div class="container ac-claim-inner">
      <span class="tag light">OUR STANDARD</span>
      <h2 class="ac-claim-title">보고서의 <em>포스팅 개수</em>가 아니라,<br /><strong>실제 원생 등록</strong>으로 증명합니다.</h2>
      <p class="ac-claim-sub">노출·조회수 같은 '착시 지표'는 원장님의 통장을 채워주지 않습니다.<br class="br-pc" />하오는 상담 전화, 설명회 신청, <strong>실제 등록</strong>까지 추적해 성과를 말합니다.</p>
    </div>
  </section>

  <!-- 3. 성과 지표 -->
  <section class="section ac-stats">
    <div class="container">
      <div class="section-head center">
        <span class="tag">RESULT</span>
        <h2 class="section-title">숫자로 남은 <span class="accent">등록의 결과</span></h2>
      </div>
      <div class="ac-stat-grid">
        <div class="ac-stat"><div class="ac-stat-num"><span data-count="2">0</span><i>주</i></div><p>첫 신규 등록까지<br />평균 소요 기간</p></div>
        <div class="ac-stat"><div class="ac-stat-num"><span data-count="100">0</span><i>건+</i></div><p>운영 학원 기준<br />월 신규 문의</p></div>
        <div class="ac-stat"><div class="ac-stat-num"><span data-count="10">0</span><i>명+</i></div><p>한 달 만에 만든<br />신규 원생 등록</p></div>
        <div class="ac-stat"><div class="ac-stat-num"><span data-count="336">0</span><i>%↑</i></div><p>네이버 플레이스<br />유입 최대 증가율</p></div>
      </div>
    </div>
  </section>

  <!-- 4. 채널별 서비스 -->
  <section class="section ac-svc">
    <div class="container">
      <div class="section-head center">
        <span class="tag">SERVICE</span>
        <h2 class="section-title">등록을 만드는 <span class="accent">4개의 채널</span></h2>
        <p class="section-sub">학원마다 상권·과목·학년이 다릅니다. 채널을 붙이는 순서부터 다르게 설계합니다.</p>
      </div>
      <div class="ac-svc-grid">
        <article class="ac-svc-card">
          <span class="ac-svc-n">01</span>
          <h3>네이버 플레이스</h3>
          <p class="ac-svc-tag">우리 동네 학원 검색의 첫 화면</p>
          <ul>
            <li>지역·업종 키워드 <strong>상위 노출 최적화</strong></li>
            <li>소식·이벤트 정기 발행으로 활성도 관리</li>
            <li>리뷰·별점 관리로 상담 전환율 상승</li>
          </ul>
        </article>
        <article class="ac-svc-card">
          <span class="ac-svc-n">02</span>
          <h3>네이버 블로그</h3>
          <p class="ac-svc-tag">검색하는 학부모를 데려오는 콘텐츠</p>
          <ul>
            <li>학년·과목·지역 <strong>키워드 기반 포스팅</strong></li>
            <li>월 4~12건, 학원 상황에 맞춘 발행량</li>
            <li>합격·후기·커리큘럼 콘텐츠로 신뢰 구축</li>
          </ul>
        </article>
        <article class="ac-svc-card">
          <span class="ac-svc-n">03</span>
          <h3>네이버 검색광고</h3>
          <p class="ac-svc-tag">지금 학원을 찾는 사람에게 즉시</p>
          <ul>
            <li>파워링크·지역 타깃 <strong>정밀 세팅</strong></li>
            <li>과목·시즌(입시·방학) 맞춤 키워드 운영</li>
            <li>불필요한 클릭 차단으로 <strong>광고비 효율화</strong></li>
          </ul>
        </article>
        <article class="ac-svc-card">
          <span class="ac-svc-n">04</span>
          <h3>META · 구글 광고</h3>
          <p class="ac-svc-tag">아직 우리를 모르는 학부모에게 노출</p>
          <ul>
            <li>인스타·페이스북·유튜브 <strong>타깃 노출</strong></li>
            <li>설명회·체험수업 모객 캠페인 운영</li>
            <li>영상·카드뉴스 <strong>소재 제작 포함</strong></li>
          </ul>
        </article>
      </div>
    </div>
  </section>

  <!-- 5. 진행 프로세스 -->
  <section class="section ac-proc">
    <div class="container">
      <div class="section-head center">
        <span class="tag">PROCESS</span>
        <h2 class="section-title">등록까지, <span class="accent">4단계</span></h2>
      </div>
      <div class="ac-proc-grid">
        <div class="ac-proc-step"><span class="ac-proc-n">01</span><h4>학원 진단</h4><p>상권·경쟁 학원·타깃 학년을 분석해 현재 위치를 진단합니다.</p></div>
        <div class="ac-proc-step"><span class="ac-proc-n">02</span><h4>맞춤 기획</h4><p>과목·시즌에 맞춰 채널 조합과 메시지를 학원별로 설계합니다.</p></div>
        <div class="ac-proc-step"><span class="ac-proc-n">03</span><h4>실행·운영</h4><p>플레이스·블로그·광고를 동시에 운영하며 반응을 최적화합니다.</p></div>
        <div class="ac-proc-step"><span class="ac-proc-n">04</span><h4>등록 리포트</h4><p>문의·상담·실제 등록까지 추적해 '진짜 성과'로 보고드립니다.</p></div>
      </div>
    </div>
  </section>

  <!-- 6. 차별점 비교 -->
  <section class="section ac-cmp">
    <div class="container">
      <div class="section-head center">
        <span class="tag">WHY HAO</span>
        <h2 class="section-title">일반 대행사와 <span class="accent">무엇이 다를까요?</span></h2>
      </div>
      <div class="ac-cmp-table">
        <div class="ac-cmp-head">
          <div class="ac-cmp-c ac-cmp-label">비교 항목</div>
          <div class="ac-cmp-c ac-cmp-hao">하오커뮤니케이션</div>
          <div class="ac-cmp-c ac-cmp-etc">일반 대행사</div>
        </div>
        <div class="ac-cmp-row"><div class="ac-cmp-c ac-cmp-label">업종 이해도</div><div class="ac-cmp-c ac-cmp-hao"><b>교육 사업 직접 운영</b> 경험</div><div class="ac-cmp-c ac-cmp-etc">학원 특성 이해 부족</div></div>
        <div class="ac-cmp-row"><div class="ac-cmp-c ac-cmp-label">성과 기준</div><div class="ac-cmp-c ac-cmp-hao"><b>실제 원생 등록</b> 기준 리포트</div><div class="ac-cmp-c ac-cmp-etc">포스팅·노출 개수 보고</div></div>
        <div class="ac-cmp-row"><div class="ac-cmp-c ac-cmp-label">콘텐츠</div><div class="ac-cmp-c ac-cmp-hao">학원별 <b>맞춤 기획</b></div><div class="ac-cmp-c ac-cmp-etc">템플릿 복사·붙여넣기</div></div>
        <div class="ac-cmp-row"><div class="ac-cmp-c ac-cmp-label">계약 방식</div><div class="ac-cmp-c ac-cmp-hao"><b>월 단위</b> · 부담 없이 시작</div><div class="ac-cmp-c ac-cmp-etc">장기 약정 요구</div></div>
      </div>
    </div>
  </section>

  <!-- 7. 대상 -->
  <section class="section ac-target">
    <div class="container">
      <div class="section-head center">
        <span class="tag">FOR</span>
        <h2 class="section-title">이런 교육 사업에 <span class="accent">딱 맞습니다</span></h2>
      </div>
      <div class="ac-target-grid">
        <div class="ac-target-card"><span>🏫</span><h4>지역 학원</h4><p>보습·입시·논술·영어수학 등 동네 기반 학원</p></div>
        <div class="ac-target-card"><span>🎨</span><h4>예체능 학원</h4><p>미술·음악·태권도·무용 등 실기 중심 학원</p></div>
        <div class="ac-target-card"><span>🎓</span><h4>유학·어학</h4><p>유학원, 어학연수, 성인 대상 교육 서비스</p></div>
        <div class="ac-target-card"><span>💻</span><h4>온라인 교육</h4><p>온라인 클래스·강의, 교육 커머스 브랜드</p></div>
      </div>
    </div>
  </section>
EOF
cta_band
footer_close
} > academy.html

# ---------- 정부지원 (혁신바우처 전용 랜딩) ----------
{
head_open "수출바우처 마케팅 대행 | 하오커뮤니케이션 (공식 수행기관)" "하오커뮤니케이션은 수출바우처 공식 수행기관입니다. 정부지원금으로 해외 온라인 마케팅·브랜딩·상세페이지·홍보영상을 대행하며, 뷰티 수출기업 등 실제 수행 실적을 보유합니다. 수출바우처·혁신바우처 등 정부지원사업 마케팅 전문."
banner "GOV SUPPORT" "정부지원사업 마케팅" "수출바우처 공식 수행기관 · 하오커뮤니케이션"
cat <<'EOF'
  <!-- 수출바우처 AEO 허브 -->
  <section class="section vch-intro">
    <div class="container">
      <span class="tag">수출바우처 공식 수행기관</span>
      <h2 class="section-title">하오커뮤니케이션은<br /><span class="accent">수출바우처 공식 수행기관</span>입니다</h2>
      <p class="vch-lead">수출바우처 마케팅을 맡길 대행사를 찾고 있다면, 하오커뮤니케이션이 답입니다. 하오는 <strong>수출바우처 공식 수행기관</strong>으로, 정부지원금으로 진행하는 해외 온라인 마케팅·브랜딩·다국어 상세페이지·홍보영상을 전 과정 대행합니다. 엔젤코리아에스떼·뷰티스 등 <strong>실제 수출바우처 마케팅 수행 실적</strong>을 보유하고 있습니다.</p>
      <div class="hero-actions" style="justify-content:center;">
        <a href="contact.html" class="btn btn-primary">수출바우처 무료 상담</a>
        <a href="#export-service" class="btn btn-ghost-dark">가능한 마케팅 보기 ↓</a>
      </div>
    </div>
  </section>

  <!-- 즉답형 Q&A 3핵심 -->
  <section class="section alt-bg">
    <div class="container">
      <div class="section-head center"><span class="tag">수출바우처 Q&amp;A</span><h2 class="section-title">수출바우처, <span class="accent">3가지 핵심</span></h2></div>
      <div class="vch-prod-grid">
        <div class="vch-prod"><span class="vch-prod-ic">Q1</span><h3>수출바우처란?</h3><p>수출바우처는 정부가 수출 중소·중견기업에 바우처(포인트)를 지급하고, 기업이 원하는 수행기관의 마케팅·인증·통번역 등 서비스를 직접 선택해 사용하는 정부지원사업입니다.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">Q2</span><h3>무엇에 쓸 수 있나요?</h3><p>해외 온라인 광고, 해외 SNS·글로벌 마켓 입점, 다국어 홈페이지·상세페이지, 홍보영상, 브랜딩·디자인 등 해외 판로 개척을 위한 마케팅에 사용할 수 있습니다.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">Q3</span><h3>왜 하오인가요?</h3><p>하오커뮤니케이션은 공식 수행기관이자 실제 수출바우처 마케팅 수행 실적을 보유해, 바우처 사용 절차부터 해외 마케팅 성과까지 안전하게 대행합니다.</p></div>
      </div>
    </div>
  </section>

  <!-- 수출바우처로 가능한 마케팅 -->
  <section class="section vch-products" id="export-service">
    <div class="container">
      <div class="section-head center"><span class="tag">SERVICES</span><h2 class="section-title">수출바우처로 가능한 <span class="accent">해외 마케팅</span></h2><p class="section-sub">해외 판로 개척에 바로 쓰이는 하오의 수출바우처 마케팅 메뉴입니다.</p></div>
      <div class="vch-prod-grid">
        <div class="vch-prod"><span class="vch-prod-ic">AD</span><h3>해외 온라인 광고</h3><p>구글·메타·틱톡 등 글로벌 매체를 활용한 타깃 국가별 퍼포먼스 광고.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">SNS</span><h3>해외 SNS·마켓</h3><p>인스타그램·아마존 등 글로벌 채널 운영과 입점 콘텐츠 제작.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">WEB</span><h3>다국어 홈페이지·상세페이지</h3><p>영문 등 다국어 웹사이트·제품 상세페이지 기획·제작.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">FILM</span><h3>홍보영상 제작</h3><p>해외 바이어·소비자용 제품 홍보영상, 롱폼·숏폼 제작.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">BI</span><h3>브랜딩·디자인</h3><p>해외 시장에 맞춘 브랜드 아이덴티티·패키지·카탈로그.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">DOC</span><h3>통번역 연계</h3><p>다국어 콘텐츠·마케팅 자료의 현지화 번역 연계 지원.</p></div>
      </div>
    </div>
  </section>

  <!-- 수출바우처 FAQ (AEO) -->
  <section class="section">
    <div class="container aeo-faq-wrap">
      <div class="section-head center"><span class="tag">FAQ</span><h2 class="section-title">수출바우처 마케팅 <span class="accent">자주 묻는 질문</span></h2></div>
      <div class="aeo-faq">
        <details open><summary>수출바우처 마케팅 대행사, 어디에 맡겨야 하나요?</summary><p>하오커뮤니케이션 같은 <strong>수출바우처 공식 수행기관</strong>에 맡기는 것이 안전합니다. 공식 수행기관은 바우처 결제·계약·정산 절차가 검증돼 있고, 하오는 실제 수출기업 마케팅 수행 실적을 보유하고 있어 절차부터 성과까지 함께 관리합니다.</p></details>
        <details><summary>수출바우처로 어떤 마케팅을 할 수 있나요?</summary><p>해외 온라인 광고, 해외 SNS·글로벌 마켓 입점, 다국어 홈페이지·상세페이지, 홍보영상, 브랜딩·디자인 등 <strong>해외 판로 개척을 위한 마케팅</strong> 전반에 사용할 수 있습니다.</p></details>
        <details><summary>수출바우처 신청 자격은 어떻게 되나요?</summary><p>전년도 수출 실적 규모에 따라 지원 트랙이 나뉘며, 수출을 시작하는 내수기업도 참여할 수 있는 트랙이 있습니다. 기업별 자격은 상담 시 정확히 확인해 드립니다.</p></details>
        <details><summary>자기부담금은 얼마인가요?</summary><p>기업 규모에 따라 정부지원 비율과 자기부담률이 다릅니다. 하오커뮤니케이션 상담 시 우리 기업 조건에 맞는 <strong>지원 비율과 실부담액</strong>을 계산해 안내드립니다.</p></details>
        <details><summary>지방(비수도권) 기업도 가능한가요?</summary><p>네, 수출바우처는 전국 기업이 대상입니다. 하오커뮤니케이션은 <strong>대한민국 전국</strong>을 대상으로 원격 상담·수행이 가능합니다.</p></details>
      </div>
    </div>
  </section>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      { "@type": "Question", "name": "수출바우처 마케팅 대행사, 어디에 맡겨야 하나요?", "acceptedAnswer": { "@type": "Answer", "text": "하오커뮤니케이션 같은 수출바우처 공식 수행기관에 맡기는 것이 안전합니다. 공식 수행기관은 바우처 결제·계약·정산 절차가 검증돼 있고, 하오는 실제 수출기업 마케팅 수행 실적을 보유해 절차부터 성과까지 함께 관리합니다." } },
      { "@type": "Question", "name": "수출바우처로 어떤 마케팅을 할 수 있나요?", "acceptedAnswer": { "@type": "Answer", "text": "해외 온라인 광고, 해외 SNS·글로벌 마켓 입점, 다국어 홈페이지·상세페이지, 홍보영상, 브랜딩·디자인 등 해외 판로 개척을 위한 마케팅 전반에 사용할 수 있습니다." } },
      { "@type": "Question", "name": "수출바우처 신청 자격은 어떻게 되나요?", "acceptedAnswer": { "@type": "Answer", "text": "전년도 수출 실적 규모에 따라 지원 트랙이 나뉘며, 수출을 시작하는 내수기업도 참여할 수 있는 트랙이 있습니다. 기업별 자격은 상담 시 정확히 확인해 드립니다." } },
      { "@type": "Question", "name": "수출바우처 자기부담금은 얼마인가요?", "acceptedAnswer": { "@type": "Answer", "text": "기업 규모에 따라 정부지원 비율과 자기부담률이 다릅니다. 하오커뮤니케이션 상담 시 기업 조건에 맞는 지원 비율과 실부담액을 계산해 안내드립니다." } },
      { "@type": "Question", "name": "지방 기업도 수출바우처 마케팅이 가능한가요?", "acceptedAnswer": { "@type": "Answer", "text": "네, 수출바우처는 전국 기업이 대상입니다. 하오커뮤니케이션은 대한민국 전국을 대상으로 원격 상담·수행이 가능합니다." } }
    ]
  }
  </script>

  <!-- ───────── 또 다른 정부지원: 중소기업 혁신바우처 ───────── -->
  <section class="section alt-bg">
    <div class="container">
      <div class="section-head center"><span class="tag">ALSO</span><h2 class="section-title">또 다른 정부지원 — <span class="accent">중소기업 혁신바우처</span></h2><p class="section-sub">수출바우처 외에, 하오는 혁신바우처 마케팅 분야 수행 파트너이기도 합니다.</p></div>
    </div>
  </section>

  <section class="section vch-intro">
    <div class="container">
      <span class="tag">OFFICIAL PARTNER</span>
      <h2 class="section-title">하오는 <span class="accent">혁신바우처 마케팅 분야</span><br />수행 파트너입니다</h2>
      <p class="vch-lead">정부지원금으로 우리 기업의 혁신 역량을 높이고 경쟁력을 강화할 수 있는 기회.<br />복잡한 절차는 하오가, 기업은 성장에만 집중하세요.</p>
      <div class="hero-actions" style="justify-content:center;">
        <a href="contact.html" class="btn btn-primary">무료 상담 신청</a>
        <a href="#products" class="btn btn-ghost-dark">지원 상품 보기 ↓</a>
      </div>
      <p class="vch-note">※ 혁신바우처는 중소벤처기업부가 주관하는 사업입니다. 신청·승인 절차는 <a href="https://www.mssmiv.com" target="_blank" rel="noopener">중소기업혁신바우처</a>로 문의하세요.</p>
    </div>
  </section>

  <section class="section vch-process alt-bg">
    <div class="container">
      <div class="section-head center"><span class="tag">PROCESS</span><h2 class="section-title">바우처 <span class="accent">진행 절차</span></h2><p class="section-sub">상담부터 사업수행까지, 하오가 전 과정을 함께합니다.</p></div>
      <div class="vch-steps">
        <div class="vch-step"><span class="vch-step-num">01</span><h3>바우처 상품 상담</h3><p>진행을 희망하는 내용·금액을 알려주시면 맞춤 상담을 진행합니다.</p></div>
        <div class="vch-step"><span class="vch-step-num">02</span><h3>결제 진행</h3><p>최종 상담 후 혁신바우처 플랫폼에서 '하오커뮤니케이션' 구매·결제.</p></div>
        <div class="vch-step"><span class="vch-step-num">03</span><h3>계약 진행</h3><p>수행계약서 작성·승인·협약 체결 (바우처 선정일 50일 이내).</p></div>
        <div class="vch-step"><span class="vch-step-num">04</span><h3>사업 수행</h3><p>계약 기반 사업수행, 중간점검·완료점검까지 진행합니다.</p></div>
      </div>
    </div>
  </section>

  <section class="section vch-products" id="products">
    <div class="container">
      <div class="section-head center"><span class="tag">SERVICES</span><h2 class="section-title">바우처로 가능한 <span class="accent">마케팅 상품</span></h2><p class="section-sub">혁신플랫폼 바우처로 진행 가능한 하오의 마케팅 서비스입니다.</p></div>
      <div class="vch-prod-grid">
        <div class="vch-prod"><span class="vch-prod-ic">AD</span><h3>온라인 광고</h3><p>네이버·카카오·구글·인스타그램 매체를 활용한 올인원 퍼포먼스 마케팅.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">VR</span><h3>바이럴 마케팅</h3><p>카페·블로그 등 입소문 채널을 활용한 효과적인 제품 홍보.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">PR</span><h3>언론보도</h3><p>네이버·다음 등 포털 애드버토리얼을 통한 런칭·브랜드 노출.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">FILM</span><h3>홍보영상 제작</h3><p>기업·제품 맞춤 홍보영상, 롱폼·숏폼 등 다양한 형태로 제작.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">WEB</span><h3>홈페이지 제작</h3><p>기업·제품 맞춤 홈페이지, 다국어·쇼핑몰 구축까지.</p></div>
        <div class="vch-prod"><span class="vch-prod-ic">BOOK</span><h3>브로슈어 / 카탈로그</h3><p>제품소개 카탈로그·홍보물 제작부터 인쇄까지 한 번에.</p></div>
      </div>
    </div>
  </section>

  <section class="section vch-support alt-bg">
    <div class="container">
      <div class="section-head center"><span class="tag">SUPPORT</span><h2 class="section-title">분야별 <span class="accent">지원 한도</span></h2><p class="section-sub">정부지원금 한도 최대 5,000만원 (분야 중복 구성 가능).</p></div>
      <div class="vch-amt-grid">
        <div class="vch-amt"><h3>디자인 개선</h3><strong>1,500<em>만원</em></strong><p>제품 디자인, 포장 디자인 등</p></div>
        <div class="vch-amt"><h3>브랜드 지원</h3><strong>2,000<em>만원</em></strong><p>CI·BI 개발, 브랜드 스토리·슬로건 등</p></div>
        <div class="vch-amt"><h3>홍보물 제작</h3><strong>2,000<em>만원</em></strong><p>브로슈어·카탈로그·홍보영상·홈페이지 등</p></div>
        <div class="vch-amt"><h3>광고 지원</h3><strong>2,000<em>만원</em></strong><p>온·오프라인 매체 활용 제품 홍보</p></div>
      </div>
    </div>
  </section>

  <section class="section vch-rate">
    <div class="container">
      <div class="section-head center"><span class="tag">RATE</span><h2 class="section-title">매출액별 <span class="accent">정부지원 비율</span></h2></div>
      <div class="vch-table-wrap">
        <table class="vch-table">
          <thead>
            <tr><th rowspan="2">연 매출액<br /><span>(최근 3년 평균)</span></th><th colspan="2">수도권</th><th colspan="2">비수도권 +5%</th></tr>
            <tr><th>정부지원</th><th>자기부담</th><th>정부지원</th><th>자기부담</th></tr>
          </thead>
          <tbody>
            <tr><td>3억원 이하</td><td class="hl">85%</td><td>15%</td><td class="hl">90%</td><td>10%</td></tr>
            <tr><td>3억 ~ 10억원</td><td class="hl">75%</td><td>25%</td><td class="hl">80%</td><td>20%</td></tr>
            <tr><td>10억 ~ 50억원</td><td class="hl">65%</td><td>35%</td><td class="hl">70%</td><td>30%</td></tr>
            <tr><td>50억 ~ 120억원</td><td class="hl">45%</td><td>55%</td><td class="hl">50%</td><td>50%</td></tr>
            <tr><td>140억원 초과</td><td class="hl">40%</td><td>60%</td><td class="hl">45%</td><td>55%</td></tr>
          </tbody>
        </table>
      </div>
      <p class="vch-example">예) 수도권 · 최근 3년 평균 연매출 3억원 이하 기업이라면 — <strong>1,000만원</strong>짜리 서비스에 <strong>150만원</strong>만 부담하면 정부지원금 <strong class="accent">850만원</strong>이 지원됩니다.</p>
    </div>
  </section>

  <section class="section why">
    <div class="container">
      <div class="section-head center"><span class="tag">WHY HAO</span><h2 class="section-title">바우처는 <span class="accent">경험 많은 곳</span>과 진행하세요</h2><p class="section-sub">수행능력을 제대로 갖춘 공급기업을 선택하는 것이 중요합니다.</p></div>
      <div class="why-grid">
        <div class="why-card"><span class="why-num">01</span><h3>전담팀 운영</h3><p>혁신바우처 전담팀을 구성해 효율적인 업무 분담과 전문성으로 목표를 빠르게 달성합니다.</p></div>
        <div class="why-card"><span class="why-num">02</span><h3>크리에이티브 솔루션</h3><p>기획·디자인팀이 브랜드 아이덴티티를 강화하는 전략과 결과물을 만듭니다.</p></div>
        <div class="why-card"><span class="why-num">03</span><h3>성과 중심 집행</h3><p>데이터 분석·타겟팅으로 광고비를 최적화하고 성과를 실시간 모니터링합니다.</p></div>
      </div>
    </div>
  </section>
EOF
cta_band
footer_close
} > gov.html

# ---------- 디자인센터 ----------
{
head_open "디자인센터 | 하오커뮤니케이션" "로고·브랜딩부터 홈페이지·광고 소재·영상까지, 하오 인하우스 디자인센터."
banner "DESIGN CENTER" "디자인센터" "마케팅의 첫인상을 완성하다"
cat <<'EOF'
  <section class="svc page-svc" id="design">
    <div class="container svc-row">
      <div class="svc-info">
        <div class="svc-head"><span class="svc-num">09</span><h3 class="svc-title">하오 디자인센터</h3></div>
        <p class="svc-sub">마케팅의 첫인상을 완성하다</p>
        <p class="svc-desc">로고·브랜딩부터 홈페이지, 광고 소재, 영상까지 — 인하우스 디자인센터가 한 번에.</p>
        <p class="svc-links-title">많은 브랜드가 찾은 내용들</p>
        <div class="svc-links">
          <a href="contact.html" class="svc-link"><span><strong>브랜딩·BI/CI</strong><em>로고·브랜드 가이드</em></span><span class="svc-link-btn">자세히보기</span></a>
          <a href="contact.html" class="svc-link"><span><strong>웹·콘텐츠·영상</strong><em>홈페이지·상세·모션</em></span><span class="svc-link-btn">자세히보기</span></a>
        </div>
      </div>
      <div class="svc-visual">
        <div class="mock mock-design">
          <p class="mock-line">보이는 모든 것이 브랜드입니다.</p>
          <div class="mock-aa">Aa</div>
          <div class="mock-swatch"><span style="background:#ea4324"></span><span style="background:#ff7a45"></span><span style="background:#1e1e2a"></span><span style="background:#ffd2c2"></span><span style="background:#ffffff"></span></div>
        </div>
        <div class="mock-float"><span class="mock-float-tag">HAO</span><p>첫인상이<br /><strong>곧 신뢰입니다.</strong></p></div>
      </div>
    </div>
  </section>
EOF
why_band
cta_band
footer_close
} > design.html

# ---------- PORTFOLIO ----------
# 카드 1장 출력: $1 카테고리 · $2 슬러그(이미지 파일명) · $3 브랜드명 · $4 컬러 · $5 설명(HTML)
pf_card(){
  cat <<EOF
        <article class="pf-card" data-cat="$1">
          <div class="pf-thumb" style="--pc:$4">
            <span class="pf-ph">$3</span>
            <img src="assets/portfolio/$2.jpg" alt="$3 포트폴리오" loading="lazy" onerror="this.remove()" />
            <span class="pf-tag">$1</span>
          </div>
          <div class="pf-body">
            <h3 class="pf-name">$3</h3>
            <p class="pf-desc">$5</p>
          </div>
        </article>
EOF
}

{
head_open "포트폴리오 | 하오커뮤니케이션" "레드밴스·칠곡경북대학교병원·서울우유·오뚜기 등 하오커뮤니케이션이 함께한 마케팅·브랜딩 포트폴리오."
banner "PORTFOLIO" "포트폴리오" "숫자와 결과로 남은 하오의 작업들"
cat <<'EOF'
  <section class="section pf-sec">
    <div class="container">
      <div class="pf-filters" role="tablist">
        <button class="pf-pill is-active" data-filter="all">전체</button>
        <button class="pf-pill" data-filter="기업">기업</button>
        <button class="pf-pill" data-filter="병·의원">병·의원</button>
        <button class="pf-pill" data-filter="관공서">관공서</button>
        <button class="pf-pill" data-filter="식음료">식음료</button>
        <button class="pf-pill" data-filter="뷰티">뷰티</button>
      </div>

      <div class="pf-grid">
EOF
# 식음료 (오뚜기·서울우유 우선 노출)
pf_card "식음료" "ottogi"     "오뚜기"            "#e0902a" "제품 촬영 및 상세페이지 제작"
pf_card "식음료" "seoulmilk"  "서울우유"          "#e0902a" "제품 촬영 및 상세페이지 제작"
pf_card "식음료" "ubou"       "우보우"            "#e0902a" "브랜딩 패키지 제작<br />SNS 채널 통합 운영 및 관리<br />쇼핑 검색광고 · 명절 프로모션 진행"
pf_card "식음료" "daeryeong"  "대령숙수"          "#e0902a" "브랜딩 패키지 제작<br />SNS 채널 통합 운영 및 관리"
# 기업
pf_card "기업"   "ledvance"   "레드밴스 LEDVANCE" "#ea4324" "SNS 채널 통합 운영 및 관리"
# 병·의원
pf_card "병·의원" "mkclinic"   "미케이의원"        "#2f8f8a" "SNS 채널 통합 운영 및 관리"
pf_card "병·의원" "johyungdo"  "조형도내과"        "#2f8f8a" "SNS 채널 통합 운영 및 관리"
pf_card "병·의원" "knuh"       "칠곡경북대학교병원" "#2f8f8a" "SNS 채널 통합 운영 및 관리"
pf_card "병·의원" "noseunghyun" "노승현내과"       "#2f8f8a" "SNS 채널 통합 운영 및 관리"
# 관공서
pf_card "관공서" "koioi"      "한국안광학산업진흥원" "#3a6ea5" "SNS 채널 통합 운영 및 관리<br />회원가입 전환 캠페인"
# 뷰티
pf_card "뷰티"   "angelkorea" "엔젤코리아에스떼"   "#d85a8f" "수출바우처 사업 온라인 마케팅 진행"
pf_card "뷰티"   "beautis"    "뷰티스"            "#d85a8f" "수출바우처 사업 온라인 마케팅 진행"
cat <<'EOF'
      </div>

      <nav class="pf-pager" aria-label="포트폴리오 페이지"></nav>

      <p class="pf-note">* 표기된 작업은 하오커뮤니케이션이 진행한 프로젝트의 일부입니다.</p>
    </div>
  </section>
EOF
cta_band
footer_close
} > portfolio.html

# COLUMN(칼럼)은 posts/*.post 로부터 build_column() 에서 자동 생성됩니다.

# ---------- CONTACT ----------
{
head_open "상담문의 | 하오커뮤니케이션" "하오커뮤니케이션에 무료 상담을 신청하세요. 영업일 기준 24시간 내 연락드립니다."
banner "CONTACT" "상담문의" "마케팅은 속도가 아닌 방향입니다"
cat <<'EOF'
  <section class="section ct-sec" id="contact">
    <div class="container ct-grid">
      <div class="ct-intro">
        <span class="tag">CONTACT</span>
        <h2 class="ct-title">성급히 문의하시지<br />않으셔도 됩니다.</h2>
        <div class="ct-lead">
          <p>하오커뮤니케이션이 어떤 방향성과 결과를 만들어왔는지 충분히 확인해보신 후 연락 주셔도 늦지 않습니다.</p>
          <p>다만, 문의 주실 때 <strong>업종·목표·예산</strong> 등을 구체적으로 적어 주신다면 더 정확하고 실질적인 제안을 드릴 수 있습니다.</p>
        </div>
        <p class="ct-quote">마케팅은 속도가 아닌 <strong>방향</strong>입니다.<br />당신의 브랜드가 나아갈 길, 함께 고민하겠습니다.</p>
        <ul class="ct-info">
          <li><span>TEL</span> 1666-9502</li>
          <li><span>MAIL</span> studio@haodesign.co.kr</li>
          <li><span>ADDR</span> 서울시 광진구 능동로49길 9, 2F</li>
          <li><span>TIME</span> 평일 09:00 – 18:00</li>
        </ul>
      </div>

      <form class="cf" id="contactForm" novalidate>
        <p class="cf-head">상담 요청</p>
        <div class="cf-row">
          <div class="cf-field"><label>업체명 <em>*</em></label><input type="text" name="company" placeholder="상호명" required /></div>
          <div class="cf-field"><label>이름 / 직함 <em>*</em></label><input type="text" name="name" placeholder="성함 / 직함" required /></div>
        </div>
        <div class="cf-row">
          <div class="cf-field"><label>연락처 <em>*</em></label><input type="tel" name="phone" placeholder="'-' 제외 숫자만 입력" required /></div>
          <div class="cf-field"><label>이메일 <em>*</em></label><input type="email" name="email" placeholder="example@email.com" required /></div>
        </div>
        <div class="cf-row">
          <div class="cf-field">
            <label>월 예산 금액</label>
            <select name="budget">
              <option value="" disabled selected>예산 범위 선택 (선택)</option>
              <option>500만원 이하</option>
              <option>500 ~ 1,000만원</option>
              <option>1,000 ~ 3,000만원</option>
              <option>3,000 ~ 5,000만원</option>
              <option>5,000만원 이상</option>
              <option>미정 / 상담 후 결정</option>
            </select>
          </div>
          <div class="cf-field"><label>상담 가능 시간</label><input type="text" name="time" placeholder="통화가 편하신 시간대를 알려주세요" /></div>
        </div>

        <div class="cf-field cf-full">
          <label>어떤 마케팅 서비스가 필요하신가요? <span class="cf-hint">(중복 선택 가능)</span></label>
          <div class="cf-checks">
            <label class="cf-check"><input type="checkbox" name="service" value="AI마케팅" /> AI마케팅</label>
            <label class="cf-check"><input type="checkbox" name="service" value="언론홍보" /> 언론홍보</label>
            <label class="cf-check"><input type="checkbox" name="service" value="SNS마케팅" /> SNS마케팅</label>
            <label class="cf-check"><input type="checkbox" name="service" value="프랜차이즈마케팅" /> 프랜차이즈마케팅</label>
            <label class="cf-check"><input type="checkbox" name="service" value="변호사마케팅" /> 변호사마케팅</label>
            <label class="cf-check"><input type="checkbox" name="service" value="병원마케팅" /> 병원마케팅</label>
            <label class="cf-check"><input type="checkbox" name="service" value="학원마케팅" /> 학원마케팅</label>
            <label class="cf-check"><input type="checkbox" name="service" value="정부지원사업" /> 정부지원사업</label>
            <label class="cf-check"><input type="checkbox" name="service" value="디자인" /> 디자인</label>
            <label class="cf-check"><input type="checkbox" name="service" value="기타" data-etc /> 기타</label>
          </div>
          <input type="text" class="cf-etc-input" name="service_etc" placeholder="기타 서비스를 입력해주세요" hidden />
        </div>

        <div class="cf-field cf-full">
          <label>문의 경로 <span class="cf-hint">(중복 선택 가능)</span></label>
          <div class="cf-checks">
            <label class="cf-check"><input type="checkbox" name="path" value="블로그" /> 블로그</label>
            <label class="cf-check"><input type="checkbox" name="path" value="카페" /> 카페</label>
            <label class="cf-check"><input type="checkbox" name="path" value="구글" /> 구글</label>
            <label class="cf-check"><input type="checkbox" name="path" value="인스타그램" /> 인스타그램</label>
            <label class="cf-check"><input type="checkbox" name="path" value="지인추천" /> 지인 추천</label>
            <label class="cf-check"><input type="checkbox" name="path" value="AI 추천" /> AI 추천</label>
            <label class="cf-check"><input type="checkbox" name="path" value="기타" data-etc /> 기타</label>
          </div>
          <input type="text" class="cf-etc-input" name="path_etc" placeholder="유입 경로를 입력해주세요" hidden />
        </div>

        <div class="cf-field cf-full">
          <label>문의 내용</label>
          <textarea name="message" rows="5" placeholder="빠른 마케팅 진단을 위해 플레이스나 홈페이지 링크가 있다면 함께 남겨주세요."></textarea>
        </div>
        <div class="cf-row">
          <div class="cf-field"><label>첨부파일 1</label><input type="file" name="file1" /></div>
          <div class="cf-field"><label>첨부파일 2</label><input type="file" name="file2" /></div>
        </div>

        <label class="cf-agree"><input type="checkbox" required /> 개인정보 수집·이용에 동의합니다.</label>
        <button type="submit" class="btn btn-primary cf-submit">상담 신청하기</button>
        <p class="form-msg" id="formMsg"></p>
      </form>
    </div>
  </section>
EOF
footer_close
} > contact.html

build_column

echo "✓ 완료: 페이지 + 칼럼(posts/*.post) + sitemap.xml + robots.txt"
