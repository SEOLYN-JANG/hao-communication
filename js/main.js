/* ============================================================
   하오커뮤니케이션 — main.js
   - Canvas 히어로 애니메이션 (영상 대체)
   - 헤더 스크롤 / 모바일 메뉴 / 스크롤 리빌 / 카운터 / 폼
   ============================================================ */

(function () {
  "use strict";

  /* ---------- 1. HERO CANVAS (영상처럼 움직이는 배경) ---------- */
  const canvas = document.getElementById("heroCanvas");
  if (canvas) {
    const ctx = canvas.getContext("2d");
    let w, h, dpr, particles, blobs;
    const ORANGE = [234, 67, 36];

    function resize() {
      dpr = Math.min(window.devicePixelRatio || 1, 2);
      w = canvas.clientWidth;
      h = canvas.clientHeight;
      canvas.width = w * dpr;
      canvas.height = h * dpr;
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      init();
    }

    function rand(a, b) { return a + Math.random() * (b - a); }

    function init() {
      // 큰 빛 덩어리 (영상 같은 흐름)
      blobs = [];
      for (let i = 0; i < 4; i++) {
        blobs.push({
          x: rand(0, w), y: rand(0, h),
          r: rand(180, 360),
          vx: rand(-0.25, 0.25), vy: rand(-0.25, 0.25),
          hue: i % 2 === 0 ? ORANGE : [255, 150, 70],
        });
      }
      // 떠다니는 입자
      const count = Math.min(90, Math.floor(w / 14));
      particles = [];
      for (let i = 0; i < count; i++) {
        particles.push({
          x: rand(0, w), y: rand(0, h),
          r: rand(0.6, 2.4),
          vx: rand(-0.35, 0.35), vy: rand(-0.35, 0.35),
          a: rand(0.15, 0.7),
        });
      }
    }

    function draw() {
      ctx.clearRect(0, 0, w, h);
      // 배경 베이스 (스토리 섹션과 동일한 순수 검정 → 이음새 제거)
      ctx.fillStyle = "#000";
      ctx.fillRect(0, 0, w, h);

      // 빛 덩어리
      blobs.forEach((b) => {
        b.x += b.vx; b.y += b.vy;
        if (b.x < -b.r) b.x = w + b.r; if (b.x > w + b.r) b.x = -b.r;
        if (b.y < -b.r) b.y = h + b.r; if (b.y > h + b.r) b.y = -b.r;
        const g = ctx.createRadialGradient(b.x, b.y, 0, b.x, b.y, b.r);
        g.addColorStop(0, `rgba(${b.hue[0]},${b.hue[1]},${b.hue[2]},0.30)`);
        g.addColorStop(1, "rgba(255,106,0,0)");
        ctx.fillStyle = g;
        ctx.beginPath();
        ctx.arc(b.x, b.y, b.r, 0, Math.PI * 2);
        ctx.fill();
      });

      // 입자 + 연결선
      ctx.globalCompositeOperation = "lighter";
      particles.forEach((p, i) => {
        p.x += p.vx; p.y += p.vy;
        if (p.x < 0 || p.x > w) p.vx *= -1;
        if (p.y < 0 || p.y > h) p.vy *= -1;
        ctx.beginPath();
        ctx.fillStyle = `rgba(255,160,90,${p.a})`;
        ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
        ctx.fill();

        for (let j = i + 1; j < particles.length; j++) {
          const q = particles[j];
          const dx = p.x - q.x, dy = p.y - q.y;
          const dist = Math.sqrt(dx * dx + dy * dy);
          if (dist < 120) {
            ctx.strokeStyle = `rgba(234,67,36,${0.14 * (1 - dist / 120)})`;
            ctx.lineWidth = 1;
            ctx.beginPath();
            ctx.moveTo(p.x, p.y);
            ctx.lineTo(q.x, q.y);
            ctx.stroke();
          }
        }
      });
      ctx.globalCompositeOperation = "source-over";

      requestAnimationFrame(draw);
    }

    window.addEventListener("resize", resize);
    resize();
    draw();
  }

  /* ---------- 2. HEADER scroll state ---------- */
  const header = document.getElementById("header");
  function onScroll() {
    if (window.scrollY > 40) header.classList.add("scrolled");
    else header.classList.remove("scrolled");
  }
  window.addEventListener("scroll", onScroll);
  onScroll();

  /* ---------- 2b. ACTIVE nav (현재 페이지 강조) ---------- */
  const curPage = location.pathname.split("/").pop() || "index.html";
  document.querySelectorAll(".gnb a").forEach((a) => {
    if (a.getAttribute("href") === curPage) a.classList.add("active");
  });

  /* ---------- 3. MOBILE menu ---------- */
  const toggle = document.getElementById("menuToggle");
  const gnb = document.getElementById("gnb");
  if (toggle && gnb) {
    toggle.addEventListener("click", () => gnb.classList.toggle("open"));
    gnb.querySelectorAll("a").forEach((a) =>
      a.addEventListener("click", () => gnb.classList.remove("open"))
    );
  }

  /* ---------- 3b. STORY — HAO 글자 빌드업 ---------- */
  const story = document.getElementById("story");
  if (story) {
    const stage = story.querySelector(".story-stage");
    const col = story.querySelector(".story-col");
    const word = story.querySelector(".hao-word");
    const logo = story.querySelector(".hao-logo");
    const finalEl = document.getElementById("haoFinal");
    const items = Array.prototype.slice
      .call(story.querySelectorAll(".hao-char, .hao-logo"))
      .sort((a, b) => +a.dataset.i - +b.dataset.i);
    const STOPS = items.length + 1; // 글자 빌드 + 마지막 문구
    const sub = document.getElementById("haoSub");
    function layoutCaption() {
      if (!col || !logo) return;
      const colR = col.getBoundingClientRect();
      const logoR = logo.getBoundingClientRect();
      const cloudCx = logoR.left + logoR.width / 2 - colR.left; // 구름 중심 (col 기준)
      if (finalEl) {
        finalEl.style.left = cloudCx + "px";
        finalEl.style.top = (colR.height + 22) + "px";
      }
      if (sub) sub.style.left = (cloudCx - colR.width / 2) + "px"; // 구름 밑으로 이동
    }
    let sTicking = false;
    function storyUpdate() {
      sTicking = false;
      const total = story.offsetHeight - window.innerHeight;
      let p = (window.scrollY - story.offsetTop) / (total || 1);
      p = Math.min(Math.max(p, 0), 0.9999);
      const stop = Math.floor(p * STOPS); // 0..items.length
      items.forEach((el, i) => el.classList.toggle("on", i <= stop));
      stage.classList.toggle("word-done", stop >= items.length - 1);
      stage.classList.toggle("show-final", stop >= items.length);
      layoutCaption();
    }
    window.addEventListener("scroll", () => {
      if (!sTicking) { sTicking = true; requestAnimationFrame(storyUpdate); }
    }, { passive: true });
    window.addEventListener("resize", storyUpdate);
    storyUpdate();
  }

  /* ---------- 4. SCROLL reveal ---------- */
  const revealEls = document.querySelectorAll(
    ".section-head, .about-lead, .stat, .svc-info, .svc-visual, .contact-form, .s-card, .why-card, .vch-step, .vch-prod, .vch-amt, .vch-table-wrap, .vch-example"
  );
  revealEls.forEach((el) => el.classList.add("reveal"));
  const io = new IntersectionObserver(
    (entries) => {
      entries.forEach((e) => {
        if (e.isIntersecting) {
          e.target.classList.add("in");
          io.unobserve(e.target);
        }
      });
    },
    { threshold: 0.12 }
  );
  revealEls.forEach((el) => io.observe(el));

  /* ---------- 5. COUNTER ---------- */
  const counters = document.querySelectorAll("[data-count]");
  function runCount(el) {
    const raw = el.dataset.count || "0";
    const decimals = (raw.split(".")[1] || "").length; // 소수 자릿수 (54.5 → 1)
    const target = parseFloat(raw) || 0;
    const ease = (t) => 1 - Math.pow(1 - t, 3); // easeOutCubic
    const fmt = (v) => v.toLocaleString(undefined, { minimumFractionDigits: decimals, maximumFractionDigits: decimals });
    if (el._raf) cancelAnimationFrame(el._raf);
    const start = performance.now();
    const frame = (now) => {
      const t = Math.min((now - start) / 2000, 1);
      el.textContent = fmt(ease(t) * target);
      if (t < 1) el._raf = requestAnimationFrame(frame);
    };
    el._raf = requestAnimationFrame(frame);
  }
  const cio = new IntersectionObserver(
    (entries) => {
      entries.forEach((e) => {
        const el = e.target;
        if (e.isIntersecting) {
          runCount(el); // 화면에 들어올 때마다 다시 카운팅
        } else {
          if (el._raf) cancelAnimationFrame(el._raf);
          el.textContent = "0"; // 나가면 리셋 → 재진입 시 처음부터
        }
      });
    },
    { threshold: 0.4 }
  );
  counters.forEach((el) => cio.observe(el));

  /* ---------- 6. CONTACT form ---------- */
  const form = document.getElementById("contactForm");
  const msg = document.getElementById("formMsg");
  if (form) {
    form.addEventListener("submit", (e) => {
      e.preventDefault();
      if (!form.checkValidity()) {
        msg.textContent = "필수 항목을 모두 입력해주세요.";
        msg.style.color = "#ff8a3d";
        return;
      }
      // 실제 전송 연동 전 임시 처리 (이메일/백엔드 연동 자리)
      msg.textContent = "상담 신청이 접수되었습니다. 빠르게 연락드리겠습니다!";
      msg.style.color = "#7CFC9B";
      form.reset();
    });
  }

  /* ---------- 6a. 병원 AI 검색 타이핑 목업 ---------- */
  const aiType = document.getElementById("aiType");
  const aiMock = document.getElementById("aiMock");
  const aiAnswer = document.getElementById("aiAnswer");
  if (aiType && aiMock) {
    const text = aiType.dataset.text || "";
    let typing = false, timer = null;
    function startType() {
      if (typing) return;
      typing = true;
      if (aiAnswer) aiAnswer.classList.remove("show");
      let i = 0;
      (function step() {
        aiType.textContent = text.slice(0, i);
        i++;
        if (i <= text.length) timer = setTimeout(step, 65);
        else if (aiAnswer) timer = setTimeout(() => aiAnswer.classList.add("show"), 450);
      })();
    }
    function resetType() {
      typing = false;
      if (timer) clearTimeout(timer);
      aiType.textContent = "";
      if (aiAnswer) aiAnswer.classList.remove("show");
    }
    const tio = new IntersectionObserver((entries) => {
      entries.forEach((e) => { if (e.isIntersecting) startType(); else resetType(); });
    }, { threshold: 0.4 });
    tio.observe(aiMock);
  }

  /* ---------- 6b. 상담폼 '기타' 입력 토글 ---------- */
  document.querySelectorAll("[data-etc]").forEach((cb) => {
    cb.addEventListener("change", () => {
      const field = cb.closest(".cf-field");
      const etc = field && field.querySelector(".cf-etc-input");
      if (!etc) return;
      etc.hidden = !cb.checked;
      if (cb.checked) etc.focus();
      else etc.value = "";
    });
  });

  /* ---------- 6c. 빠른 상담 팝업 ---------- */
  const quickc = document.getElementById("quickc");
  if (quickc) {
    const qToggle = document.getElementById("quickcToggle");
    const qClose = document.getElementById("quickcClose");
    const qForm = document.getElementById("quickcForm");
    const qMsg = document.getElementById("quickcMsg");
    if (qToggle) qToggle.addEventListener("click", () => quickc.classList.toggle("open"));
    if (qClose) qClose.addEventListener("click", () => quickc.classList.remove("open"));
    quickc.querySelectorAll(".qc-chip input").forEach((cb) => {
      cb.addEventListener("change", () => cb.closest(".qc-chip").classList.toggle("on", cb.checked));
    });
    if (qForm) qForm.addEventListener("submit", (e) => {
      e.preventDefault();
      if (!qForm.checkValidity()) { qMsg.textContent = "브랜드명과 연락처를 입력해주세요."; return; }
      qMsg.textContent = "신청이 접수되었습니다. 빠르게 연락드리겠습니다!";
      qForm.reset();
      quickc.querySelectorAll(".qc-chip.on").forEach((c) => c.classList.remove("on"));
    });
  }

  /* ---------- 7. CUSTOM CURSOR ---------- */
  const ring = document.getElementById("cursorRing");
  const dot = document.getElementById("cursorDot");
  const fine = window.matchMedia("(hover: hover) and (pointer: fine)").matches;

  if (ring && dot && fine) {
    const label = ring.querySelector(".cursor-label");
    let mx = window.innerWidth / 2, my = window.innerHeight / 2;
    let rx = mx, ry = my;

    window.addEventListener("mousemove", (e) => {
      mx = e.clientX; my = e.clientY;
      dot.style.transform = `translate(${mx}px, ${my}px) translate(-50%, -50%)`;
    });

    // 링은 살짝 늦게 따라오는 부드러운 움직임
    (function follow() {
      rx += (mx - rx) * 0.18;
      ry += (my - ry) * 0.18;
      ring.style.transform = `translate(${rx}px, ${ry}px) translate(-50%, -50%)`;
      requestAnimationFrame(follow);
    })();

    // 카테고리(네비) — 색다른 모양 + 라벨
    document.querySelectorAll(".gnb a, .footer-nav a").forEach((el) => {
      el.addEventListener("mouseenter", () => ring.classList.add("is-nav"));
      el.addEventListener("mouseleave", () => ring.classList.remove("is-nav"));
    });

    // 일반 클릭 요소 — 링 확대
    document
      .querySelectorAll(
        ".btn, .header-cta, .svc-arrow, .svc-link, .s-card, .why-card, .logo, input, select, textarea, label, button"
      )
      .forEach((el) => {
        el.addEventListener("mouseenter", () => ring.classList.add("is-hover"));
        el.addEventListener("mouseleave", () => ring.classList.remove("is-hover"));
      });

    // 클릭 시 살짝 눌림 효과
    window.addEventListener("mousedown", () => (dot.style.opacity = "0.4"));
    window.addEventListener("mouseup", () => (dot.style.opacity = "1"));
  }

  /* ---------- 8. PORTFOLIO 그리드 필터 + 페이지네이션 ---------- */
  const pfGrid = document.querySelector(".pf-grid");
  if (pfGrid) {
    const PER_PAGE = 9; // 3열 × 3줄
    const pager = document.querySelector(".pf-pager");
    const filters = document.querySelector(".pf-filters");
    const pills = Array.from(document.querySelectorAll(".pf-pill"));
    const cards = Array.from(pfGrid.querySelectorAll(".pf-card"));
    let filter = "all";
    let page = 0;

    const pool = () =>
      cards.filter((c) => filter === "all" || c.dataset.cat === filter);

    function render() {
      const list = pool();
      const pages = Math.max(1, Math.ceil(list.length / PER_PAGE));
      if (page > pages - 1) page = pages - 1;
      const start = page * PER_PAGE;
      const shown = new Set(list.slice(start, start + PER_PAGE));
      cards.forEach((c) => c.classList.toggle("is-hidden", !shown.has(c)));
      renderPager(pages);
    }

    function renderPager(pages) {
      pager.innerHTML = "";
      if (pages <= 1) return;
      const btn = (label, cls, disabled, onClick) => {
        const b = document.createElement("button");
        b.type = "button";
        b.className = "pf-page" + (cls ? " " + cls : "");
        b.innerHTML = label;
        if (disabled) b.disabled = true;
        else b.addEventListener("click", onClick);
        pager.appendChild(b);
      };
      btn("&#8249;", "pf-nav", page === 0, () => go(page - 1));
      for (let i = 0; i < pages; i++) {
        btn(i + 1, i === page ? "is-active" : "", false, () => go(i));
      }
      btn("&#8250;", "pf-nav", page === pages - 1, () => go(page + 1));
    }

    function go(n) {
      page = n;
      render();
      const top = filters.getBoundingClientRect().top + window.scrollY - 100;
      window.scrollTo({ top, behavior: "smooth" });
    }

    pills.forEach((pill) => {
      pill.addEventListener("click", () => {
        pills.forEach((p) => p.classList.remove("is-active"));
        pill.classList.add("is-active");
        filter = pill.dataset.filter;
        page = 0;
        render();
      });
    });

    render();
  }
})();
