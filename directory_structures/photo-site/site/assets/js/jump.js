// Section links in the "On this page" bar (a.jump links with data-section).
// Each section has its own clean URL under the site's base path (/drawer on
// one site, /2026-10-21 on another), routed to the home page by the Apache
// rules and by serve.py. Instead of a page load, a click cuts to just short of
// the section, then slides the last stretch into place with an ease-out-expo
// curve. An optional fade (FADE) can hide the cut, matching the fade the page
// makes when it first loads (assets/css/typography.css); it is off by
// default, chosen 2026-10-24 by comparing ?lead=50/100/200 with and without it.
//
// Opening a section URL directly lands on that section. Old #section links
// (an element's data-legacy-id) are rewritten to the clean URL. Back and Forward
// glide between sections. Keyboard focus moves to the section, and any wheel,
// touch, or key press stops the glide where it is. With reduced motion
// preferred, every move is a plain jump.
(function () {
	// A page may have section URLs without a jump bar yet (a site with one
	// section so far): arrival on a section URL and old #links still work.
	var links = document.querySelectorAll('.jump a[data-section]');
	if (!links.length && !document.querySelector('[data-legacy-id]')) return;

	var DURATION = 700;   // ms for the slide
	var FADE = 0;         // ms for the fade (180 matches first load); 0 = no fade
	var LEAD = 50;        // px short of the section where the slide starts
	var frame = null;

	// For comparing settings on the local server only: ?lead=200&fade=0
	// overrides the values above. The published site always uses them as set.
	if (/^(127\.0\.0\.1|localhost)$/.test(location.hostname)) {
		var params = new URLSearchParams(location.search);
		if (params.has('lead')) LEAD = Math.max(0, Number(params.get('lead')) || 0);
		if (params.has('fade')) FADE = Math.max(0, Number(params.get('fade')) || 0);
		if (params.has('duration')) DURATION = Math.max(1, Number(params.get('duration')) || DURATION);
	}

	// Section slug -> its link's full URL, which carries the site's base path.
	var urls = {};
	Array.prototype.forEach.call(links, function (link) {
		urls[link.getAttribute('data-section')] = link.href;
	});

	function easeOutExpo(t) {
		return t >= 1 ? 1 : 1 - Math.pow(2, -10 * t);
	}

	function reducedMotion() {
		return window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	}

	// A section: an element a jump link names, or one carrying data-legacy-id.
	function section(id) {
		var el = id && document.getElementById(id);
		return el && (urls[id] || el.hasAttribute('data-legacy-id')) ? el : null;
	}

	// A section's clean URL: its link's, or its id resolved against this page.
	function urlFor(id) {
		return urls[id] || new URL(encodeURIComponent(id), document.baseURI).href;
	}

	// The section named by the current URL's last path segment, if any.
	function sectionFromPath() {
		return section(decodeURIComponent(location.pathname.replace(/\/+$/, '').split('/').pop()));
	}

	function stop() {
		if (frame !== null) cancelAnimationFrame(frame);
		frame = null;
		document.body.style.transition = '';
		document.body.style.opacity = '';
	}

	function top(el) {
		return el ? el.getBoundingClientRect().top + window.scrollY : 0;
	}

	// Slide to a section, or to the top of the page when target is null.
	function glide(target) {
		stop();
		var end = Math.min(top(target), document.documentElement.scrollHeight - window.innerHeight);
		if (reducedMotion()) { window.scrollTo(0, end); return; }
		// Start short of the section on the side we are coming from.
		var lead = Math.min(LEAD, Math.abs(end - window.scrollY));
		var start = end > window.scrollY ? end - lead : end + lead;

		var body = document.body;
		if (FADE > 0) {
			body.style.transition = 'none';
			body.style.opacity = '0';
		}
		window.scrollTo(0, start);
		if (FADE > 0) {
			// Force the hidden state to apply before fading back in.
			void body.offsetWidth;
			body.style.transition = 'opacity ' + FADE + 'ms ease-out';
			body.style.opacity = '1';
		}

		var t0 = null;
		function step(now) {
			if (t0 === null) t0 = now;
			var t = Math.min((now - t0) / DURATION, 1);
			window.scrollTo(0, start + (end - start) * easeOutExpo(t));
			if (t < 1) frame = requestAnimationFrame(step);
			else stop();
		}
		frame = requestAnimationFrame(step);
	}

	function focus(target) {
		if (!target) return;
		if (!target.hasAttribute('tabindex')) target.setAttribute('tabindex', '-1');
		target.focus({ preventScroll: true });
	}

	Array.prototype.forEach.call(links, function (link) {
		link.addEventListener('click', function (e) {
			if (e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return;  // new tab or window
			var target = document.getElementById(link.getAttribute('data-section'));
			if (!target) return;
			e.preventDefault();
			history.pushState(null, '', link.href);
			glide(target);
			focus(target);
		});
	});

	// Back and Forward between sections (and the top of the page).
	window.addEventListener('popstate', function () {
		if (/^#photo-/.test(location.hash)) return;  // the photo viewer's own URLs
		glide(sectionFromPath());
	});

	['wheel', 'touchstart', 'keydown'].forEach(function (type) {
		window.addEventListener(type, function () { if (frame !== null) stop(); }, { passive: true });
	});

	// Arriving on a section URL, or an old #section link: land on the section
	// once the fonts are in, so text reflow can't shift where it ends up.
	var hash = decodeURIComponent(location.hash.slice(1));
	var legacy = hash && !/^photo-/.test(hash) && (
		document.querySelector('[data-legacy-id="' + CSS.escape(hash) + '"]') || section(hash)
	);
	var arrival = legacy || sectionFromPath();
	if (legacy) history.replaceState(null, '', urlFor(legacy.id));
	if (arrival) {
		var land = function () { window.scrollTo(0, top(arrival)); focus(arrival); };
		if (document.fonts && document.fonts.ready) document.fonts.ready.then(land);
		else land();
	}
})();
