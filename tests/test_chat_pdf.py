#!/usr/bin/env python3
# ----------------------------
# --    test_chat_pdf.py    --
# ----------------------------
# description: Exercise preservation and failure boundaries on synthetic chats.

import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from pypdf import PdfReader


ROOT = Path(__file__).resolve().parents[1]
COMMAND = [sys.executable, str(ROOT / "bin/render-chat-pdf")]


class ChatPDFTests(unittest.TestCase):
	@classmethod
	def setUpClass(cls):
		cls.temporary = tempfile.TemporaryDirectory(prefix="chat-pdf-test-")
		cls.directory = Path(cls.temporary.name)
		cls.source = cls.directory / "source.md"
		cls.source.write_bytes((ROOT / "examples/chat-archive/conversation-export.md").read_bytes())
		cls.original = cls.source.read_bytes()
		cls.pdf = cls.directory / "reading.pdf"
		result = cls.convert(cls.source, cls.pdf)
		if result.returncode:
			raise RuntimeError(result.stderr)
		cls.report = json.loads(cls.pdf.with_suffix(".render.json").read_text())
		cls.text = "\n".join(page.extract_text() or "" for page in PdfReader(cls.pdf).pages)

	@classmethod
	def tearDownClass(cls):
		cls.temporary.cleanup()

	@staticmethod
	def convert(source, output, *extra):
		return subprocess.run(COMMAND + [str(source), "--output", str(output), *extra], capture_output=True, text=True)

	def test_source_and_duplicate_message_boundaries(self):
		self.assertEqual(self.source.read_bytes(), self.original)
		self.assertEqual(self.report["source_sha256"], hashlib.sha256(self.original).hexdigest())
		self.assertEqual(self.report["message_count"], 5)
		self.assertEqual(self.report["roles"], {"User": 3, "Assistant": 2})
		self.assertEqual(self.text.count("Keep this repeated prompt."), 2)
		self.assertIn("The final source passage must remain present.", self.text)
		self.assertEqual(self.report["checks"]["visual_review"], "pending")

	def test_external_image_links_and_inactive_relative_link(self):
		reader = PdfReader(self.pdf)
		urls = {str(a.get_object()["/A"]["/URI"]) for page in reader.pages for a in page.get("/Annots", []) if "/A" in a.get_object()}
		self.assertEqual(urls, {"https://example.org/reference", "https://example.org/image.png", "https://example.org/article", "https://example.org/preview.png"})
		self.assertIn("inactive link: reference.md", self.text)
		self.assertIn("<script>example_only()</script>", self.text)

	def test_existing_output_and_source_alias_are_protected(self):
		before = self.pdf.read_bytes()
		result = self.convert(self.source, self.pdf)
		self.assertNotEqual(result.returncode, 0)
		self.assertEqual(self.pdf.read_bytes(), before)
		result = self.convert(self.source, self.source)
		self.assertNotEqual(result.returncode, 0)
		self.assertEqual(self.source.read_bytes(), self.original)

	def test_comparison_needs_evidence_note(self):
		destination = self.directory / "comparison.pdf"
		result = self.convert(self.source, destination, "--source-status", "compared")
		self.assertNotEqual(result.returncode, 0)
		self.assertFalse(destination.exists())

	def test_arbitrary_markdown_and_active_links(self):
		source = self.directory / "document.md"
		source.write_text("# Synthetic document\n\n[Inactive action](javascript:example_only())\n\nA footnote.[^1]\n\n[^1]: A source note.\n\nLast source line.\n")
		original = source.read_bytes()
		destination = self.directory / "document.pdf"
		self.assertNotEqual(self.convert(source, destination).returncode, 0)
		result = self.convert(source, destination, "--format", "markdown")
		self.assertEqual(result.returncode, 0, result.stderr)
		report = json.loads(destination.with_suffix(".render.json").read_text())
		self.assertIsNone(report["message_count"])
		self.assertEqual(report["transformations"]["inactive_links"], 1)
		self.assertEqual(source.read_bytes(), original)

	def test_missing_glyph_does_not_install_a_pdf(self):
		source = self.directory / "unsupported.md"
		source.write_text("# Synthetic unsupported character\n\n" + chr(0x10FFFF))
		destination = self.directory / "unsupported.pdf"
		result = self.convert(source, destination, "--format", "markdown")
		self.assertNotEqual(result.returncode, 0)
		self.assertIn("U+10FFFF", result.stderr)
		self.assertFalse(destination.exists())

	def test_image_component_is_described_and_long_table_stays_readable(self):
		source = self.directory / "components.md"
		component = chr(0xE200) + 'image_group' + chr(0xE202) + json.dumps({"query": ["example illustration"]}) + chr(0xE201)
		rows = "\n".join("| A long left-cell phrase that wraps onto another line " + str(i) + " | Right cell |" for i in range(20))
		source.write_text("# Synthetic components\n\n## Prompt:\n\n01/01/2026, 9:00 AM\n\n" + component + "\n\n## Response:\n\n01/01/2026, 9:01 AM\n\n| Left column | Right column |\n| --- | --- |\n" + rows + "\n\nFinal component passage.\n")
		destination = self.directory / "components.pdf"
		result = self.convert(source, destination)
		self.assertEqual(result.returncode, 0, result.stderr)
		report = json.loads(destination.with_suffix(".render.json").read_text())
		self.assertEqual(report["transformations"]["image_group_notices"], 1)
		self.assertGreaterEqual(report["checks"]["pages"], 3)

	def test_force_replaces_only_derivatives(self):
		destination = self.directory / "replace.pdf"
		destination.write_bytes(b"old derivative")
		result = self.convert(self.source, destination, "--force")
		self.assertEqual(result.returncode, 0, result.stderr)
		self.assertTrue(destination.read_bytes().startswith(b"%PDF"))
		self.assertEqual(self.source.read_bytes(), self.original)


if __name__ == "__main__":
	unittest.main()
