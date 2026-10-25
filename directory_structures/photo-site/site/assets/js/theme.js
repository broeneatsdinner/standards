// Light / Dark / Auto switch in the top bar.
// Auto follows the system appearance (CSS prefers-color-scheme); Light and
// Dark set data-theme on <html> and are remembered in localStorage. The saved
// choice is applied before first paint by an inline script in the page <head>.
(function () {
	var nav = document.querySelector('.series-nav');
	if (!nav) return;
	var root = document.documentElement;
	var KEY = 'theme';

	function current() {
		var t = root.getAttribute('data-theme');
		return t === 'light' || t === 'dark' ? t : 'auto';
	}

	// Crossfade with the View Transitions API where available; otherwise, and
	// for readers who prefer reduced motion, switch at once.
	function fadeTo(change) {
		var reduce = window.matchMedia && matchMedia('(prefers-reduced-motion: reduce)').matches;
		if (!document.startViewTransition || reduce) { change(); return; }
		document.startViewTransition(change);
	}

	function apply(choice) {
		if (choice === 'auto') root.removeAttribute('data-theme');
		else root.setAttribute('data-theme', choice);
		try {
			if (choice === 'auto') localStorage.removeItem(KEY);
			else localStorage.setItem(KEY, choice);
		} catch (e) {}
		buttons.forEach(function (b) {
			b.setAttribute('aria-pressed', String(b.dataset.choice === choice));
		});
	}

	var group = document.createElement('div');
	group.className = 'theme-switch';
	group.setAttribute('role', 'group');
	group.setAttribute('aria-label', 'Appearance');
	var buttons = ['light', 'dark', 'auto'].map(function (choice) {
		var b = document.createElement('button');
		b.type = 'button';
		b.dataset.choice = choice;
		b.textContent = choice.charAt(0).toUpperCase() + choice.slice(1);
		b.addEventListener('click', function () {
			if (choice === current()) return;
			fadeTo(function () { apply(choice); });
		});
		group.appendChild(b);
		return b;
	});
	nav.appendChild(group);
	apply(current());
})();
