// Full-screen photo viewer.
//
// Click (or Enter on) any photo to open it. In the viewer:
//   Right, Down, Space, l     next photo
//   Left, Up, Shift+Space, h  previous photo
//   Home / End                first / last photo
//   Escape                    close, returning to that photo on the page
// Photos step in page order, across every photo folder, and crossfade.
// The background fades to a dark color taken from each photo (backdrop()).
// Controls hide after the pointer rests. Each photo has its own URL hash
// (#photo-<section>-<name>). Swipe works on touch. Where the grid shows
// thumbnails, the viewer opens each photo's data-full image instead.
(function () {
	var figures = Array.prototype.slice.call(document.querySelectorAll('figure[data-photo]'));
	if (!figures.length) return;

	var photos = figures.map(function (fig) {
		var img = fig.querySelector('img');
		var cap = fig.querySelector('figcaption');
		return {
			img: img,
			id: fig.getAttribute('data-photo'),
			src: img.getAttribute('data-full') || img.getAttribute('src'),
			alt: img.getAttribute('alt') || '',
			caption: cap ? cap.innerHTML : '',  // our own generated, escaped markup
			date: fig.getAttribute('data-date') || ''
		};
	});

	var viewer = document.createElement('div');
	viewer.className = 'viewer';
	viewer.setAttribute('role', 'dialog');
	viewer.setAttribute('aria-modal', 'true');
	viewer.setAttribute('aria-label', 'Photo viewer');
	viewer.setAttribute('tabindex', '-1');
	viewer.hidden = true;
	viewer.innerHTML =
		'<div class="viewer-stage">' +
			'<img class="viewer-img" alt="">' +
			'<img class="viewer-img" alt="">' +
		'</div>' +
		'<p class="viewer-caption" aria-live="polite"></p>' +
		'<p class="viewer-count"></p>' +
		'<button class="viewer-btn viewer-prev" type="button" aria-label="Previous photo">&larr;</button>' +
		'<button class="viewer-btn viewer-next" type="button" aria-label="Next photo">&rarr;</button>' +
		'<button class="viewer-btn viewer-close" type="button" aria-label="Close">&times;</button>';
	document.body.appendChild(viewer);

	var layers = viewer.querySelectorAll('img.viewer-img');
	var front = 0;
	var current = -1;
	var token = 0;
	var idleTimer = null;
	var captionEl = viewer.querySelector('.viewer-caption');
	var countEl = viewer.querySelector('.viewer-count');

	// A dark backdrop from the photo's own colors: average it on a tiny
	// canvas, keep the hue, soften the saturation, and drop the lightness to
	// near-black so the light caption ink stays readable. The browser
	// does this once per photo.
	var FALLBACK_BG = '#111';
	var canvas = document.createElement('canvas');
	canvas.width = canvas.height = 24;
	var ctx = canvas.getContext('2d', { willReadFrequently: true });

	function backdrop(p, img) {
		if (p.bg) return p.bg;
		p.bg = FALLBACK_BG;
		if (!ctx || !img.naturalWidth) return p.bg;
		try {
			ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
			var d = ctx.getImageData(0, 0, canvas.width, canvas.height).data;
			var r = 0, g = 0, b = 0, n = d.length / 4;
			for (var j = 0; j < d.length; j += 4) { r += d[j]; g += d[j + 1]; b += d[j + 2]; }
			var hsl = toHsl(r / n, g / n, b / n);
			p.bg = 'hsl(' + Math.round(hsl[0]) + ' ' + Math.round(Math.min(hsl[1], 0.45) * 100) + '% 9%)';
		} catch (e) {}  // unreadable pixels: keep the fallback
		return p.bg;
	}

	function toHsl(r, g, b) {
		r /= 255; g /= 255; b /= 255;
		var max = Math.max(r, g, b), min = Math.min(r, g, b);
		var l = (max + min) / 2, h = 0, s = 0, c = max - min;
		if (c) {
			s = c / (1 - Math.abs(2 * l - 1));
			if (max === r) h = ((g - b) / c) % 6;
			else if (max === g) h = (b - r) / c + 2;
			else h = (r - g) / c + 4;
			h = (h * 60 + 360) % 360;
		}
		return [h, s, l];
	}

	function preload(i) {
		if (i < 0 || i >= photos.length) return;
		var im = new Image();
		im.src = photos[i].src;
	}

	function show(i) {
		if (i < 0 || i >= photos.length || i === current) return;
		var p = photos[i];
		var mine = ++token;
		var back = layers[1 - front];
		var loader = new Image();
		loader.onload = loader.onerror = function () {
			if (mine !== token) return;  // a later navigation won
			back.src = p.src;
			back.alt = p.alt;
			viewer.style.setProperty('--v-bg', backdrop(p, loader));
			back.classList.add('is-front');
			layers[front].classList.remove('is-front');
			front = 1 - front;
			captionEl.innerHTML = p.caption;
			countEl.textContent = p.date + '  ' + (i + 1) + ' / ' + photos.length;
		};
		loader.src = p.src;
		current = i;
		history.replaceState(null, '', '#photo-' + p.id);
		preload(i + 1);
		preload(i - 1);
	}

	function open(i) {
		viewer.hidden = false;
		document.documentElement.classList.add('viewer-open');
		// Next frame, so the opacity transition runs from 0.
		requestAnimationFrame(function () { viewer.classList.add('is-open'); });
		current = -1;
		show(i);
		viewer.focus();
		wake();
	}

	function close() {
		var i = current;
		viewer.classList.remove('is-open');
		document.documentElement.classList.remove('viewer-open');
		history.replaceState(null, '', location.pathname + location.search);
		var done = function () {
			viewer.hidden = true;
			layers[0].classList.remove('is-front');
			layers[1].classList.remove('is-front');
			current = -1;
		};
		if (reducedMotion()) done(); else setTimeout(done, 350);
		if (i >= 0) {
			var img = photos[i].img;
			img.scrollIntoView({ block: 'center' });
			// Return focus so keyboard users keep their place, without drawing
			// a focus ring around the photo they just closed.
			img.classList.add('is-returned');
			img.addEventListener('blur', function () { img.classList.remove('is-returned'); }, { once: true });
			img.focus({ preventScroll: true });
		}
	}

	function step(d) {
		var i = current + d;
		if (i >= 0 && i < photos.length) show(i);
	}

	function wake() {
		viewer.classList.remove('is-idle');
		clearTimeout(idleTimer);
		idleTimer = setTimeout(function () { viewer.classList.add('is-idle'); }, 2200);
	}

	function pinchZoomed() {
		return !!(window.visualViewport && window.visualViewport.scale > 1.01);
	}

	function reducedMotion() {
		return window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	}

	photos.forEach(function (p, i) {
		var img = p.img;
		img.setAttribute('tabindex', '0');
		img.setAttribute('role', 'button');
		img.setAttribute('aria-label', 'Open photo: ' + p.alt);
		img.addEventListener('click', function () { open(i); });
		img.addEventListener('keydown', function (e) {
			if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); open(i); }
		});
	});

	viewer.querySelector('.viewer-prev').addEventListener('click', function () { step(-1); });
	viewer.querySelector('.viewer-next').addEventListener('click', function () { step(1); });
	viewer.querySelector('.viewer-close').addEventListener('click', close);
	viewer.querySelector('.viewer-stage').addEventListener('click', function (e) {
		// Clicking the empty area around the photo closes; clicking the photo advances.
		if (Date.now() < suppressClickUntil || pinchZoomed()) return;
		if (e.target.classList.contains('viewer-img')) step(1); else close();
	});
	viewer.addEventListener('mousemove', wake);

	document.addEventListener('keydown', function (e) {
		if (viewer.hidden) return;
		var k = e.key;
		if (k === 'Escape') close();
		else if (k === 'ArrowRight' || k === 'ArrowDown' || k === 'l' || (k === ' ' && !e.shiftKey)) step(1);
		else if (k === 'ArrowLeft' || k === 'ArrowUp' || k === 'h' || (k === ' ' && e.shiftKey)) step(-1);
		else if (k === 'Home') show(0);
		else if (k === 'End') show(photos.length - 1);
		else if (k === 'Tab') {
			// Keep focus inside the viewer.
			var btns = viewer.querySelectorAll('button');
			var first = btns[0], last = btns[btns.length - 1];
			if (e.shiftKey && document.activeElement === first) { e.preventDefault(); last.focus(); }
			else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
			wake();
			return;
		} else return;
		e.preventDefault();
		wake();
	});

	// Swipe left/right to step. A pinch is never a swipe, and the click iOS
	// can fire after one is swallowed.
	var touchX = null;
	var multiTouch = false;
	var suppressClickUntil = 0;
	viewer.addEventListener('touchstart', function (e) {
		if (e.touches.length === 1) {
			touchX = e.touches[0].clientX;
			multiTouch = false;
		} else {
			multiTouch = true;
		}
	}, { passive: true });
	viewer.addEventListener('touchend', function (e) {
		if (e.touches.length > 0) return;  // wait for the last finger
		if (touchX === null) return;
		var dx = e.changedTouches[0].clientX - touchX;
		touchX = null;
		if (multiTouch || pinchZoomed()) {
			suppressClickUntil = Date.now() + 700;
			return;
		}
		if (Math.abs(dx) > 40) step(dx < 0 ? 1 : -1);
	});
	viewer.addEventListener('touchcancel', function () { touchX = null; });

	// Deep link: #photo-<section>-<name> opens that photo.
	var m = location.hash.match(/^#photo-(.+)$/);
	if (m) {
		var at = photos.findIndex(function (p) { return p.id === m[1]; });
		if (at >= 0) open(at);
	}
})();
