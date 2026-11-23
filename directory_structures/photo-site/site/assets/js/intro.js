// The Nothing intro: rings, the wordmark, and this page's kicker as a byline,
// full screen over the home page. A tap, click, Enter, Space, or Escape fades to
// the page, which has loaded underneath.
//
// Shown once per browser session, on the home page only: not on a section or
// photo link, not to someone who already arrived on one, and not with reduced
// motion preferred. Without JavaScript the page just loads.
//
// Load it in <head>, not deferred, after the stylesheets: it hides the page
// before first paint (assets/css/intro.css).
(function () {
	"use strict";

	var root = document.documentElement;
	var base = new URL("../../", document.currentScript.src).pathname;
	var KEY = "nothing-intro:" + base;
	var LEAVE_MS = 700;

	function seen() {
		try { return sessionStorage.getItem(KEY) === "1"; } catch (e) { return false; }
	}

	function markSeen() {
		try { sessionStorage.setItem(KEY, "1"); } catch (e) {}
	}

	var home = location.pathname === base || location.pathname === base + "index.html";
	if (!home || location.hash) {
		markSeen();
		return;
	}
	if (seen() || window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

	root.classList.add("nothing-intro-open");

	var splashEl = null;
	var leaving = false, gone = false;

	function finish() {
		gone = true;
		window.removeEventListener("keydown", onKey, true);
		root.classList.remove("nothing-intro-open", "nothing-intro-leaving");
		if (splashEl) splashEl.remove();
	}

	function leave() {
		if (leaving) return;
		leaving = true;
		markSeen();
		root.classList.add("nothing-intro-leaving");
		window.setTimeout(finish, LEAVE_MS);
	}

	function onKey(e) {
		if (leaving || e.metaKey || e.ctrlKey || e.altKey) return;
		if (e.key === "Enter" || e.key === " " || e.key === "Escape") {
			e.preventDefault();
			e.stopImmediatePropagation();
			leave();
		}
	}

	window.addEventListener("keydown", onKey, true);

	// Outside <body>, which stays hidden until the fonts load.
	function build() {
		splashEl = document.createElement("div");
		splashEl.id = "nothing-intro";
		splashEl.tabIndex = 0;
		splashEl.setAttribute("role", "button");
		splashEl.setAttribute("aria-label", "Enter the site");
		splashEl.innerHTML =
			'<div class="ni-viewport"><div id="ni-stage">' +
			'<div class="ni-ring ni-add" id="ni-ring-top"></div>' +
			'<div class="ni-ring ni-add" id="ni-ring-left"></div>' +
			'<div class="ni-ring ni-overlay" id="ni-ring-center"></div>' +
			'<div class="ni-ring ni-overlay" id="ni-ring-bottom"></div>' +
			'<div class="ni-ring ni-add" id="ni-ring-right"></div>' +
			'<div id="ni-wordmark">Nothing</div>' +
			'</div></div><div id="ni-byline"></div>';
		root.appendChild(splashEl);
		splashEl.addEventListener("click", leave);
		splashEl.focus({ preventScroll: true });
	}

	function start() {
		build();

		var wordmarkEl = document.getElementById("ni-wordmark");
		var WORDMARK_TARGET_OPACITY = 1;
		var WORDMARK_FADE_MS = 3800;
		var BLUR_START_PX = 22;
		var BLUR_MS = 1250;
		// The entrance never shows less than the original's 0.42, so the word arrives
		// promptly over dark rings; then the rings' lighting takes over.
		var ENTRANCE_ALPHA = 0.42;
		var HANDOFF_START = 1500, HANDOFF_MS = 2500;
		var wordmarkStart = null;

		var bylineEl = document.getElementById("ni-byline");
		var BYLINE_DELAY_MS = 500;
		var BYLINE_FADE_MS = 2400, BYLINE_BLUR_MS = 1000, BYLINE_BLUR_PX = 10;
		var BYLINE_MIN = 0.55, BYLINE_MAX = 0.95;
		var BYLINE_TOP = 354, BYLINE_GAP_PX = 6;
		var bylineStart = null;
		var bylineBox = null;
		var bylineLit = [];

		// Going back to this page can restore it frozen rather than reload it. The
		// animation clock skips that time, so everything resumes where it stopped.
		var FREEZE_MS = 250;
		var frozenMs = 0;
		var lastTick = null;

		function animationTime(now) {
			if (lastTick !== null && now - lastTick > FREEZE_MS) {
				frozenMs += now - lastTick;
			}
			lastTick = now;
			return now - frozenMs;
		}

		function easeOutExpo(t) {
			return t === 1 ? 1 : 1 - Math.pow(2, -10 * t);
		}

		function revealWordmark() {
			var start = performance.now() - frozenMs;
			wordmarkStart = start;
			bylineStart = start + BYLINE_DELAY_MS;

			function fade(now) {
				now = animationTime(now);
				var t = (now - start) / WORDMARK_FADE_MS;
				if (t > 1) t = 1;
				wordmarkEl.style.opacity = (WORDMARK_TARGET_OPACITY * easeOutExpo(t)).toFixed(3);

				var bt = Math.min(1, Math.max(0, (now - start) / BLUR_MS));
				var blur = BLUR_START_PX * Math.pow(1 - bt, 2);
				wordmarkEl.style.filter = bt < 1 ? "blur(" + blur.toFixed(2) + "px)" : "none";

				if (t < 1) {
					requestAnimationFrame(fade);
				}
			}

			requestAnimationFrame(fade);
		}

		if (document.fonts && document.fonts.load) {
			Promise.race([
				Promise.all([
					document.fonts.load('800 58px "Nothing Sans"', "Nothing"),
					document.fonts.load('400 16px "Nothing Sans"', "Nothing")
				]),
				new Promise(function (resolve) {
					window.setTimeout(resolve, 1800);
				})
			]).then(revealWordmark, revealWordmark);
		} else {
			window.setTimeout(revealWordmark, 300);
		}

		var PATH_D = "M110.95 -111.0 Q156.95 -65.0 156.95 0.0 156.95 65.0 110.95 110.95 65.0 156.95 0.0 156.95 -65.0 156.95 -111.0 110.95 -156.95 65.0 -156.95 0.0 -156.95 -65.0 -111.0 -111.0 -65.0 -156.95 0.0 -156.95 65.0 -156.95 110.95 -111.0";

		var GRADIENTS = {
			teal: [
				[0.0, "#062735"],
				[0.4549019607843137, "#102f3c"],
				[0.7019607843137254, "#8c8c8c"],
				[0.8470588235294118, "#2c2c2c"],
				[1.0, "#000000"]
			],
			gray: [
				[0.0, "#808080"],
				[0.7019607843137254, "#140e0e"],
				[1.0, "#000000"]
			]
		};

		function buildRingSvg(id, color) {
			var stops = GRADIENTS[color].map(function (s) {
				return '<stop offset="' + s[0] + '" stop-color="' + s[1] + '"/>';
			}).join("");
			return (
				'<svg viewBox="0 0 313.9 313.9" xmlns="http://www.w3.org/2000/svg">' +
				'<defs><radialGradient id="' + id + '" cx="0" cy="0" gradientUnits="userSpaceOnUse" ' +
				'gradientTransform="matrix(0.1931,0,0,0.1931,0,0)" r="819.2" spreadMethod="pad">' +
				stops +
				'</radialGradient></defs>' +
				'<g transform="matrix(1,0,0,1,156.95,156.95)">' +
				'<path d="' + PATH_D + '" fill="url(#' + id + ')" fill-rule="evenodd" stroke="none"/>' +
				'</g></svg>'
			);
		}

		var NATIVE_WIDTH = 313.9;
		var now0 = performance.now();

		var rings = {
			top: {
				el: document.getElementById("ni-ring-top"),
				color: "teal",
				axis: "y",
				cycleMs: 6000,
				state: "moveTop",
				msStart: now0,
				width: NATIVE_WIDTH,
				x: 0,
				y: -103.95
			},
			left: {
				el: document.getElementById("ni-ring-left"),
				color: "teal",
				axis: "x",
				cycleMs: 4000,
				state: "moveRight",
				msStart: now0,
				width: NATIVE_WIDTH,
				x: -100,
				y: 0
			},
			center: {
				el: document.getElementById("ni-ring-center"),
				color: "teal",
				axis: null,
				width: NATIVE_WIDTH,
				x: 0,
				y: 0
			},
			bottom: {
				el: document.getElementById("ni-ring-bottom"),
				color: "gray",
				axis: "y",
				cycleMs: 6000,
				state: "moveBottom",
				msStart: now0,
				width: NATIVE_WIDTH,
				x: 0,
				y: 103.95
			},
			right: {
				el: document.getElementById("ni-ring-right"),
				color: "gray",
				axis: "x",
				cycleMs: 4000,
				state: "moveLeft",
				msStart: now0,
				width: NATIVE_WIDTH,
				x: 100,
				y: 0
			}
		};

		Object.keys(rings).forEach(function (key) {
			var ring = rings[key];
			var gradId = "ni-grad-" + key;
			ring.el.innerHTML = buildRingSvg(gradId, ring.color);
		});

		var STATE_TABLE = {
			moveRight: { p1: "offset", p2: "minOffset", next: "moveLeft" },
			moveLeft: { p1: "minOffset", p2: "offset", next: "moveRight" },
			moveTop: { p1: "offset", p2: "minOffset", next: "moveBottom" },
			moveBottom: { p1: "minOffset", p2: "offset", next: "moveTop" }
		};

		function sinusoidal(p1, p2, t) {
			var tt = 0.5 - 0.5 * Math.cos(t * Math.PI);
			return (1 - tt) * p1 + tt * p2;
		}

		function updateDrift(ring, now, offset, minOffset) {
			var cfg = STATE_TABLE[ring.state];
			var t = (now - ring.msStart) / ring.cycleMs;
			if (t > 1) {
				t = 1;
				var p1 = cfg.p1 === "offset" ? offset : minOffset;
				var p2 = cfg.p2 === "offset" ? offset : minOffset;
				var value = sinusoidal(p1, p2, t);
				ring.msStart = now;
				ring.state = cfg.next;
				return value;
			}
			var p1 = cfg.p1 === "offset" ? offset : minOffset;
			var p2 = cfg.p2 === "offset" ? offset : minOffset;
			return sinusoidal(p1, p2, t);
		}

		var STAGE_W = 840, STAGE_H = 600;
		var mouseX = STAGE_W / 2, mouseY = STAGE_H / 2;
		var stageEl = document.getElementById("ni-stage");
		var mouseActive = true;
		var effectiveMouseX = STAGE_W / 2, effectiveMouseY = STAGE_H / 2;

		function viewportWidth() {
			return window.visualViewport ? window.visualViewport.width : window.innerWidth;
		}

		function viewportHeight() {
			return window.visualViewport ? window.visualViewport.height : window.innerHeight;
		}

		// Put the byline just under the word, and note where its text falls on the stage.
		function placeByline() {
			var stage = stageEl.getBoundingClientRect();
			var scale = stage.width / STAGE_W;
			bylineEl.style.top = (stage.top + BYLINE_TOP * scale + BYLINE_GAP_PX).toFixed(1) + "px";
			var range = document.createRange();
			range.selectNodeContents(bylineEl);
			var text = range.getBoundingClientRect();
			bylineBox = {
				left: text.left,
				right: text.right,
				stageLeft: (text.left - stage.left) / scale,
				stageRight: (text.right - stage.left) / scale,
				stageY: ((text.top + text.bottom) / 2 - stage.top) / scale
			};
		}

		var kicker = document.querySelector(".kicker");
		bylineEl.textContent = kicker ? kicker.textContent.trim() : "";

		if (document.fonts && document.fonts.addEventListener) {
			document.fonts.addEventListener("loadingdone", placeByline);
		}

		function fitStage() {
			var scale = Math.min(1, viewportWidth() / STAGE_W, viewportHeight() / STAGE_H);
			stageEl.style.transform = "scale(" + scale.toFixed(4) + ")";
			placeByline();
		}

		fitStage();
		window.addEventListener("resize", fitStage);
		if (window.visualViewport) {
			window.visualViewport.addEventListener("resize", fitStage);
		}
		splashEl.addEventListener("touchmove", function(e) {
			e.preventDefault();
		}, { passive: false });

		// A tap sends mouse events too; ignore them, so it does not resize the rings.
		var touching = false;
		window.addEventListener("pointerdown", function (e) {
			touching = e.pointerType === "touch";
		}, true);

		window.addEventListener("mousemove", function (e) {
			if (touching) return;
			var rect = stageEl.getBoundingClientRect();
			mouseX = e.clientX - rect.left;
			mouseY = e.clientY - rect.top;
		});

		stageEl.addEventListener("mouseleave", function() {
			mouseActive = false;
			effectiveMouseX = STAGE_W / 2;
			effectiveMouseY = STAGE_H / 2;
		});
		stageEl.addEventListener("mouseenter", function() { mouseActive = true; });
		window.addEventListener("blur", function() {
			mouseActive = false;
			effectiveMouseX = STAGE_W / 2;
			effectiveMouseY = STAGE_H / 2;
		});
		window.addEventListener("focus", function() { mouseActive = true; });

		// The wordmark is filled with a gradient that follows the rings' light.
		var LIT_LEFT = 312, LIT_RIGHT = 528;
		var LIT_Y = 323;
		var LIT_SAMPLES = 28;
		var LIT_SPREAD = 2;
		var LIT_MIN = 0.1, LIT_MAX = 0.95;
		// Light at or below LIT_DARK leaves a letter at LIT_MIN; LIT_FULL is full.
		var LIT_DARK = 0.12, LIT_FULL = 0.62;
		// Letters catch light quickly and let go slowly, so they stay readable
		// after a ring too bright to read against has passed.
		var LIT_RISE_MS = 140, LIT_FALL_MS = 900;
		var GRADIENT_RADIUS = 0.1931 * 819.2;
		var PAINT_ORDER = ["top", "left", "center", "bottom", "right"];
		var lit = [];
		var lastLitTime = null;

		Object.keys(rings).forEach(function (key) {
			var ring = rings[key];
			ring.overlay = ring.el.classList.contains("ni-overlay");
			ring.stops = GRADIENTS[ring.color].map(function (s) {
				var n = parseInt(s[1].slice(1), 16);
				return [s[0], (0.2126 * (n >> 16) + 0.7152 * (n >> 8 & 255) + 0.0722 * (n & 255)) / 255];
			});
		});

		function ringLight(ring, distance) {
			var t = distance * NATIVE_WIDTH / ring.width / GRADIENT_RADIUS;
			for (var i = 1; i < ring.stops.length; i++) {
				var p = ring.stops[i - 1], q = ring.stops[i];
				if (t <= q[0]) return p[1] + (q[1] - p[1]) * (t - p[0]) / (q[0] - p[0]);
			}
			return null;
		}

		// Brightness of the rings at a stage point, blended as the page blends them.
		function lightAt(x, y) {
			var b = 0;
			PAINT_ORDER.forEach(function (key) {
				var ring = rings[key];
				var dx = x - STAGE_W / 2 - ring.x;
				var dy = y - STAGE_H / 2 - ring.y;
				var s = ringLight(ring, Math.sqrt(dx * dx + dy * dy));
				if (s === null) return;
				if (!ring.overlay) b = Math.min(1, b + s);
				else b = b < 0.5 ? 2 * b * s : 1 - 2 * (1 - b) * (1 - s);
			});
			return b;
		}

		function lightWordmark(now) {
			var dt = lastLitTime === null ? Infinity : now - lastLitTime;
			var step = (LIT_RIGHT - LIT_LEFT) / (LIT_SAMPLES - 1);
			var raw = [], stops = [];
			lastLitTime = now;

			var handoff = wordmarkStart === null ? 0 : (now - wordmarkStart - HANDOFF_START) / HANDOFF_MS;
			handoff = Math.min(1, Math.max(0, handoff));
			var floor = ENTRANCE_ALPHA + (LIT_MIN - ENTRANCE_ALPHA) * handoff * handoff * (3 - 2 * handoff);

			for (var i = 0; i < LIT_SAMPLES; i++) {
				var x = LIT_LEFT + i * step;
				raw.push((lightAt(x, LIT_Y - 28) + lightAt(x, LIT_Y) + lightAt(x, LIT_Y + 28)) / 3);
			}

			for (var j = 0; j < LIT_SAMPLES; j++) {
				var sum = 0, count = 0;
				for (var k = Math.max(0, j - LIT_SPREAD); k <= Math.min(LIT_SAMPLES - 1, j + LIT_SPREAD); k++) {
					sum += raw[k];
					count++;
				}
				var t = Math.min(1, Math.max(0, (sum / count - LIT_DARK) / (LIT_FULL - LIT_DARK)));
				var goal = LIT_MIN + (LIT_MAX - LIT_MIN) * t * t * (3 - 2 * t);
				var prev = lit[j] === undefined ? LIT_MIN : lit[j];
				var ease = dt === Infinity ? 0 : 1 - Math.exp(-dt / (goal > prev ? LIT_RISE_MS : LIT_FALL_MS));
				lit[j] = prev + (goal - prev) * ease;
				stops.push("rgba(255,255,255," + Math.max(floor, lit[j]).toFixed(3) + ") " + (LIT_LEFT + j * step).toFixed(1) + "px");
			}

			wordmarkEl.style.backgroundImage = "linear-gradient(90deg," + stops.join(",") + ")";
		}

		function lightByline(now, dt) {
			if (bylineStart === null || !bylineBox || !bylineEl.textContent) return;

			var elapsed = Math.max(0, now - bylineStart);
			var t = Math.min(1, elapsed / BYLINE_FADE_MS);
			var bt = Math.min(1, elapsed / BYLINE_BLUR_MS);
			bylineEl.style.opacity = easeOutExpo(t).toFixed(3);
			bylineEl.style.filter = bt < 1 ? "blur(" + (BYLINE_BLUR_PX * Math.pow(1 - bt, 2)).toFixed(2) + "px)" : "none";

			var stops = [];
			for (var i = 0; i < 16; i++) {
				var f = i / 15;
				var x = bylineBox.stageLeft + (bylineBox.stageRight - bylineBox.stageLeft) * f;
				var lightT = Math.min(1, Math.max(0, (lightAt(x, bylineBox.stageY) - LIT_DARK) / (LIT_FULL - LIT_DARK)));
				var goal = BYLINE_MIN + (BYLINE_MAX - BYLINE_MIN) * lightT * lightT * (3 - 2 * lightT);
				var prev = bylineLit[i] === undefined ? BYLINE_MIN : bylineLit[i];
				bylineLit[i] = prev + (goal - prev) * (1 - Math.exp(-dt / (goal > prev ? LIT_RISE_MS : LIT_FALL_MS)));
				stops.push("rgba(255,255,255," + bylineLit[i].toFixed(3) + ") " + (bylineBox.left + (bylineBox.right - bylineBox.left) * f).toFixed(1) + "px");
			}
			bylineEl.style.backgroundImage = "linear-gradient(90deg," + stops.join(",") + ")";
		}

		function frame(now) {
			if (gone) return;
			now = animationTime(now);
			Object.keys(rings).forEach(function (key) {
				var ring = rings[key];

				var absX = STAGE_W / 2 + ring.x;
				var absY = STAGE_H / 2 + ring.y;
				var targetMouseX = mouseActive ? mouseX : effectiveMouseX;
				var targetMouseY = mouseActive ? mouseY : effectiveMouseY;
				var dx = absX - targetMouseX;
				var dy = absY - targetMouseY;
				var distance = Math.sqrt(dx * dx + dy * dy);
				var goalWidth = 550 - distance * 2.2;
				if (goalWidth < 250) goalWidth = 250;
				if (goalWidth > 550) goalWidth = 550;

				var step = (goalWidth - ring.width) / 5;
				ring.width += step;

				var offset = ring.width / 5.5;
				if (offset < 60) offset = 60;
				var minOffset = -offset;

				if (ring.axis === "x") {
					ring.x = updateDrift(ring, now, offset, minOffset);
				} else if (ring.axis === "y") {
					ring.y = updateDrift(ring, now, offset, minOffset);
				}

				var w = ring.width;
				ring.el.style.width = w + "px";
				ring.el.style.height = w + "px";
				ring.el.style.left = (STAGE_W / 2 + ring.x) + "px";
				ring.el.style.top = (STAGE_H / 2 + ring.y) + "px";
			});

			var dt = lastLitTime === null ? 0 : now - lastLitTime;
			lightWordmark(now);
			lightByline(now, dt);
			requestAnimationFrame(frame);
		}

		requestAnimationFrame(frame);
	}

	// If anything fails, show the page rather than leave it hidden.
	function begin() {
		try { start(); } catch (e) { finish(); }
	}

	if (document.readyState === "loading") {
		document.addEventListener("DOMContentLoaded", begin);
	} else {
		begin();
	}
})();
