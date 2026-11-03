# -------------------------
# --    hand_edits.py    --
# -------------------------
# description: Keep hand edits to a generated page: write text changes back to their sources, keep the rest as a patch
"""Keep hand edits to a generated page, so a page can be edited either way:
through its sources, or directly in site/.

build.py passes each page through settle() instead of writing it. The last
page written is kept in work/hand-edits/, so a difference in site/ is a
hand edit. On the next build (a page load on the local server, a plain
build, or a deploy):

1. The hand edit is carried onto a fresh build, so source changes made in
   the meantime are kept too.
2. A change to the text between two tags is written back to the source that
   produces it (photos/captions.csv, a Markdown record: whatever build.py
   passes as sources) when the edited text is found there and a rebuild
   from the changed source shows the edit. If the rebuild also shows the
   same text change somewhere the hand edit left alone (an alt attribute
   repeating a caption), the page takes that too. Otherwise the source is
   put back as it was.
3. What no source produces (new markup, attributes) is kept in site/hand-edits.json, tracked: per page, a list of
   "before" lines from the generated page and the "after" lines that
   replace them, with enough unchanged lines around them to be found
   exactly once. Every build applies them. To drop one, undo it in the page
   or remove it from the file.

bin/deploy commits site/hand-edits.json and the sources edits were
written back to (listed in work/hand-edits/written-back.txt) before it
publishes.

When an edit no longer fits the page (its lines changed or are gone, or a
hand edit and a source change touch the same lines), the build stops and
leaves the page in site/ as it is: the local server warns, and a plain build
or a deploy fails. scripts/site/build.py --discard-hand-edits drops
unrecorded edits to the page, saving a copy in work/hand-edits/ first.

This file is shared by the project sites (docs/photo-sites.md in the
standards repository); build.py says which pages and sources it settles.
"""

import html
import json
import os
import re
import sys
import threading
from difflib import SequenceMatcher
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
SITE = REPO / "site"
EDITS = SITE / "hand-edits.json"
STATE = REPO / "work" / "hand-edits"
# Sources edits were written back to, one per line, until bin/deploy
# commits them.
WRITTEN = STATE / "written-back.txt"
# serve.py may build for two requests at once, and write_back() changes
# sources while it tries them.
LOCK = threading.Lock()


class Conflict(Exception):
	"""An edit that no longer fits the page."""


def find(lines, block):
	"""Every index at which block starts as a run of whole lines in lines."""
	n = len(block)
	return [i for i in range(len(lines) - n + 1) if n and lines[i:i + n] == block]


def show(entry):
	before = "\n".join("  - " + l for l in entry["before"])
	after = "\n".join("  + " + l for l in entry["after"])
	return before + "\n" + after


def apply(entries, lines, what):
	"""lines with each entry's "before" block replaced by its "after" block."""
	spans = []
	for e in entries:
		hits = find(lines, e["before"])
		if len(hits) != 1:
			where = f"found {len(hits)} times" if hits else "no longer in the page"
			raise Conflict(f"{what}: its lines are {where}:\n{show(e)}")
		spans.append((hits[0], hits[0] + len(e["before"]), e["after"]))
	spans.sort()
	for a, b in zip(spans, spans[1:]):
		if b[0] < a[1]:
			raise Conflict(f"{what}: two edits overlap")
	out = list(lines)
	for i1, i2, after in reversed(spans):
		out[i1:i2] = after
	return out


def entries(base, target):
	"""The edits that turn base into target. Each is widened by unchanged
	lines until its "before" block occurs exactly once in base; edits that
	meet on the way are merged."""
	sm = SequenceMatcher(None, base, target, autojunk=False)
	spans = [[g[0][1], g[-1][2], g[0][3], g[-1][4]] for g in sm.get_grouped_opcodes(1)]
	k = 0
	while k < len(spans):
		i1, i2, j1, j2 = spans[k]
		if len(find(base, base[i1:i2])) == 1 or (i1 == 0 and i2 == len(base)):
			k += 1
			continue
		# Lines between two spans are unchanged, so both sides widen together.
		left = spans[k - 1][1] if k else 0
		if i1 > left:
			i1, j1 = i1 - 1, j1 - 1
		elif k:
			p = spans.pop(k - 1)
			k -= 1
			i1, j1 = p[0], p[2]
		right = spans[k + 1][0] if k + 1 < len(spans) else len(base)
		if i2 < right:
			i2, j2 = i2 + 1, j2 + 1
		elif k + 1 < len(spans):
			n = spans.pop(k + 1)
			i2, j2 = n[1], n[3]
		spans[k] = [i1, i2, j1, j2]
	return [{"before": base[i1:i2], "after": target[j1:j2]} for i1, i2, j1, j2 in spans]


def matcher(page, target):
	# Compare text, not its encoding: an apostrophe typed by hand matches the
	# &#x27; the builder writes.
	return SequenceMatcher(None, [html.unescape(l) for l in page], [html.unescape(l) for l in target], autojunk=False)


def misses(page, target):
	"""Lines of target that page lacks, and the number of lines of page that
	target lacks."""
	blocks = matcher(page, target).get_matching_blocks()
	found = {j for _, b, size in blocks for j in range(b, b + size)}
	return set(range(len(target))) - found, len(page) - sum(size for *_, size in blocks)


def closer(page, target, now):
	missing, extra = misses(page, target)
	return missing < now[0] and extra <= now[1]


def text_change(entry):
	"""(old, new) when an edit changes only the text between two tags, as
	plain text; otherwise None."""
	old, new = "\n".join(entry["before"]), "\n".join(entry["after"])
	p = len(os.path.commonprefix([old, new]))
	s = len(os.path.commonprefix([old[p:][::-1], new[p:][::-1]]))
	start = max(old.rfind(">", 0, p), old.rfind("\n", 0, p)) + 1
	tail = len(old) - s
	stops = [i for i in (old.find("<", tail), old.find("\n", tail)) if i >= 0]
	after_tail = (min(stops) if stops else len(old)) - tail
	o, n = old[start:tail + after_tail], new[start:len(new) - s + after_tail]
	if re.search(r"[<>\n]", o + n):
		return None
	o, n = html.unescape(o).strip(), html.unescape(n).strip()
	return (o, n) if o and o != n else None


def changed_lines(edits):
	"""Each line an edit replaces one for one, as its own edit, so a text
	change next to new markup can still be written back."""
	for e in edits:
		sm = SequenceMatcher(None, e["before"], e["after"], autojunk=False)
		for tag, i1, i2, j1, j2 in sm.get_opcodes():
			if tag == "replace" and i2 - i1 == j2 - j1:
				yield from ({"before": [b], "after": [a]} for b, a in zip(e["before"][i1:i2], e["after"][j1:j2]))
			elif tag == "replace":
				yield {"before": e["before"][i1:i2], "after": e["after"][j1:j2]}


def echoes(page, trial, target, change):
	"""target with the lines where a rebuild (trial) shows the same text
	change somewhere the hand edit left alone, such as an alt attribute
	repeating a caption; None if the rebuild changes anything else."""
	old, new = change
	out = list(target)
	have = {html.unescape(l) for l in target}
	for tag, i1, i2, j1, j2 in SequenceMatcher(None, page, trial, autojunk=False).get_opcodes():
		if tag == "equal":
			continue
		if tag != "replace" or i2 - i1 != j2 - j1:
			return None
		for before, after in zip(page[i1:i2], trial[j1:j2]):
			if html.unescape(after) in have:
				continue
			if html.unescape(before).replace(old, new) != html.unescape(after):
				return None
			hits = [k for k, l in enumerate(out) if l == before]
			if len(hits) != 1:
				return None
			out[hits[0]] = after
	return out


def write_back(change, sources, generate, target):
	"""Write a text change into the one place in sources that makes the
	page closer to target, taking the same change wherever else the source
	shows it (echoes()). Returns (path, page, target) or None."""
	old, new = change
	page = generate()
	now = misses(page, target)
	# A paragraph may wrap across lines in its Markdown source.
	pattern = re.compile(r"\s+".join(map(re.escape, old.split())))
	for path in sources:
		text = path.read_text(encoding="utf-8")
		for m in pattern.finditer(text):
			path.write_text(text[:m.start()] + new + text[m.end():], encoding="utf-8")
			trial = generate()
			if closer(trial, target, now):
				return path, trial, target
			echoed = echoes(page, trial, target, change)
			if echoed is not None and closer(trial, echoed, now):
				return path, trial, echoed
			path.write_text(text, encoding="utf-8")
	return None


def write(path, lines):
	path.parent.mkdir(parents=True, exist_ok=True)
	tmp = path.with_suffix(".tmp")
	tmp.write_text("\n".join(lines), encoding="utf-8")
	tmp.replace(path)


def save_copy(page, name, why):
	copy = STATE / f"{name}-{page.name}"
	write(copy, page.read_text(encoding="utf-8").split("\n"))
	print(f"{why}; a copy is in {copy.relative_to(REPO)}", file=sys.stderr)


def settle(page, generate, sources, discard=False):
	"""Write page (a path in site/) from generate(), which returns its HTML,
	keeping hand edits as described above."""
	with LOCK:
		_settle(page, generate, sources, discard)


def _settle(page, generate, sources, discard):
	name = page.relative_to(SITE).as_posix()
	saved = STATE / name
	all_edits = json.loads(EDITS.read_text(encoding="utf-8")) if EDITS.is_file() else {}
	kept = all_edits.get(name, [])
	gen = lambda: generate().split("\n")

	fresh = apply(kept, gen(), f"An edit in {EDITS.relative_to(REPO)}")
	current = page.read_text(encoding="utf-8").split("\n") if page.is_file() else None
	last = saved.read_text(encoding="utf-8").split("\n") if saved.is_file() else None
	if current is None or current == last:
		edited = None
	elif last is None:
		# No record of the last build: a stale page can't be told from an
		# edited one, so keep a copy before replacing it.
		edited = None
		if current != fresh:
			save_copy(page, "unrecorded", f"site/{name} had no record of its last build")
	elif discard:
		edited = None
		save_copy(page, "discarded", f"Discarded hand edits to site/{name}")
	else:
		edited = (last, current)

	if edited is None:
		write(page, fresh)
		write(saved, fresh)
		return

	last, current = edited
	new = entries(last, current)
	target = apply(new, fresh, f"A hand edit to site/{name} and a source change touch the same lines; fix the page or rerun with --discard-hand-edits.\nThe edit")

	generated = gen()
	for change in filter(None, map(text_change, changed_lines(new))):
		done = write_back(change, sources, gen, target)
		if done:
			path, generated, target = done
			with WRITTEN.open("a", encoding="utf-8") as log:
				log.write(path.relative_to(REPO).as_posix() + "\n")
			print(f"Hand edit written to {path.relative_to(REPO)}: {change[0]!r} -> {change[1]!r}", file=sys.stderr)

	# Take the builder's own spelling of every line the edit left alone.
	final = list(target)
	for a, b, size in matcher(generated, target).get_matching_blocks():
		final[b:b + size] = generated[a:a + size]
	kept = entries(generated, final)
	assert apply(kept, generated, "check") == final
	if kept:
		all_edits[name] = kept
	else:
		all_edits.pop(name, None)
	if all_edits:
		EDITS.write_text(json.dumps(all_edits, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
	elif EDITS.is_file():
		EDITS.unlink()
	if kept:
		print(f"{len(kept)} hand edit(s) to site/{name} kept in {EDITS.relative_to(REPO)}", file=sys.stderr)
	write(page, final)
	write(saved, final)
