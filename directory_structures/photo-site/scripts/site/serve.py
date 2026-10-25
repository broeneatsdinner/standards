#!/usr/bin/env python3
# --------------------
# --    serve.py    --
# --------------------
# description: Serve site/ and photos/ on 127.0.0.1 for the local project site
"""Serve the project site locally.

  scripts/site/serve.py [port]        (default DEFAULT_PORT, or the next free port)

Binds 127.0.0.1 only. Serves exactly two directories:
  /            -> site/     (pages are rebuilt by build.py on each page load)
  /photos/...  -> photos/   (the original photos and their caption files)

URLs follow site/routes.json, the same routes build.py writes into the
Apache rules (site/htaccess), so local and live URLs behave alike:
  /<section>             the home page (assets/js/jump.js finds the section);
                         a trailing slash redirects to the bare path
  /<record path>         its generated page, e.g. /notes/x -> site/notes/x.html
  /<old URL>             301 to its clean URL, for each routes.json redirect
routes.json and htaccess themselves are not served.
Everything else is a 404: the repo root and its other folders (the site's
pages carry the records already), dotfiles, any path with a .. segment,
and any symlink that resolves outside those two directories. No directory
listings. GET and HEAD only.

This file is shared by the project sites; only DEFAULT_PORT differs, so
two sites can be served side by side.

Requests must also name this server in their Host header (127.0.0.1 or
localhost on this port), so a web page can't reach it through DNS rebinding.
"""

import importlib
import json
import sys
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import unquote, urlsplit

sys.path.insert(0, str(Path(__file__).resolve().parent))
import build  # noqa: E402

REPO = Path(__file__).resolve().parents[2]
SITE = (REPO / "site").resolve()
PHOTOS = (REPO / "photos").resolve()
HOST = "127.0.0.1"
DEFAULT_PORT = 8000
PORT_TRIES = 20


# Paths under these first segments are static files; anything else may be a
# page, so it triggers a rebuild before it is resolved.
STATIC = {"assets", "thumbs", "photos"}
# Build outputs that are data for this server and Apache, not pages.
HIDDEN = {"routes.json", "htaccess"}


def routes():
	try:
		return json.loads((SITE / "routes.json").read_text(encoding="utf-8"))
	except (OSError, ValueError):
		return {"sections": [], "pages": {}, "redirects": {}}


def route_key(url_path):
	"""'/notes/drawer-groove-damage/' -> 'notes/drawer-groove-damage'"""
	return unquote(urlsplit(url_path).path).strip("/")


def resolve(url_path):
	"""Map a URL path to a file in site/ or photos/, or None to refuse it."""
	path = unquote(urlsplit(url_path).path)
	if "\0" in path or "\\" in path or not path.startswith("/"):
		return None
	parts = path.split("/")[1:]
	# No .., no ., no dotfiles (.git, .DS_Store, .gitkeep), anywhere.
	if any(p.startswith(".") for p in parts):
		return None
	if parts and parts[-1] in HIDDEN:
		return None
	# Clean URLs: a section slug serves the home page, a record path its page.
	r = routes()
	key = route_key(url_path)
	if key in r["sections"]:
		return SITE / "index.html"
	if key and key in r["pages"]:
		page = (SITE / r["pages"][key]).resolve()
		return page if page.is_file() and page.is_relative_to(SITE) else None
	if parts and parts[0] == "photos":
		root, rel = PHOTOS, parts[1:]
	else:
		root, rel = SITE, parts
	rel = [p for p in rel if p]
	target = root.joinpath(*rel)
	# Resolving follows symlinks, so one pointing outside the root fails here.
	try:
		real = target.resolve(strict=True)
	except (OSError, RuntimeError):
		return None
	if not real.is_relative_to(root):
		return None
	if real.is_dir():
		real = real / "index.html"
		if not real.is_file():
			return None
	return real if real.is_file() else None


class ViewerHandler(SimpleHTTPRequestHandler):
	def __init__(self, *args, port, **kwargs):
		self.allowed_hosts = {f"127.0.0.1:{port}", f"localhost:{port}"}
		super().__init__(*args, directory=str(SITE), **kwargs)

	def _refuse(self):
		self.send_error(404, "Not found")

	def _check(self):
		if self.headers.get("Host", "") not in self.allowed_hosts:
			self._refuse()
			return None
		key = route_key(self.path)
		if key.split("/")[0] not in STATIC:
			# Rebuild before routing, so new or renamed records resolve, and
			# reload build.py too, so edits to it show up without a restart.
			importlib.reload(build).build()
		r = routes()
		new = r["redirects"].get(key)
		if not new and key in r["sections"] and urlsplit(self.path).path.endswith("/"):
			new = key  # /measurements/ -> /measurements, as the Apache rules do
		if new:
			self.send_response(301)
			self.send_header("Location", "/" + new)
			self.end_headers()
			return None
		real = resolve(self.path)
		if real is None:
			self._refuse()
			return None
		return real

	def translate_path(self, path):
		# Only reached after _check passed; resolve again so the base class
		# can never fall back to its own mapping.
		real = resolve(path)
		return str(real) if real else str(SITE / "__refused__")

	def list_directory(self, path):
		self._refuse()
		return None

	def do_GET(self):
		if self._check():
			super().do_GET()

	def do_HEAD(self):
		if self._check():
			super().do_HEAD()

	def end_headers(self):
		self.send_header("Cache-Control", "no-store")
		super().end_headers()


def bind(port):
	"""Bind 127.0.0.1 on port, or on the next free one."""
	for p in range(port, port + PORT_TRIES):
		try:
			return ThreadingHTTPServer((HOST, p), partial(ViewerHandler, port=p)), p
		except OSError:
			continue
	sys.exit(f"No free port in {port}-{port + PORT_TRIES - 1}.")


def main():
	port = int(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_PORT
	build.build()
	server, port = bind(port)
	print(f"Serving site/ and photos/ at http://{HOST}:{port}/  (Ctrl-C to stop)", flush=True)
	try:
		server.serve_forever()
	except KeyboardInterrupt:
		pass


if __name__ == "__main__":
	main()
