"""Tests for the md2pdf conversion pipeline."""

from pathlib import Path

from md2pdf.convert import convert, template_path


def test_template_path_document():
    path = template_path("document")
    assert path.exists()
    assert path.name == "document.typ"


def test_template_path_print():
    path = template_path("print")
    assert path.exists()
    assert path.name == "print.typ"


def test_convert_produces_pdf(tmp_path: Path):
    """End-to-end test: markdown → PDF (requires pandoc and typst installed)."""
    md_file = tmp_path / "input.md"
    md_file.write_text("# Hello\n\nThis is a test.\n")

    pdf_file = tmp_path / "output.pdf"
    result = convert(md_file, pdf_file)

    assert result == pdf_file
    assert pdf_file.exists()
    assert pdf_file.stat().st_size > 0
