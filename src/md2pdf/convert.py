"""Markdown → Typst → PDF conversion pipeline."""

import shutil
import subprocess
import tempfile
from importlib import resources
from pathlib import Path


def _check_deps() -> None:
    """Verify pandoc and typst are installed."""
    if not shutil.which("pandoc"):
        raise FileNotFoundError("pandoc is not installed. Install with: brew install pandoc")
    if not shutil.which("typst"):
        raise FileNotFoundError("typst is not installed. Install with: brew install typst")


def template_path(name: str) -> Path:
    """Return the path to a bundled pandoc-typst template."""
    return Path(str(resources.files("md2pdf").joinpath("templates", f"{name}.typ")))


def convert(
    input_file: Path,
    output_file: Path,
    *,
    template: str = "document",
    toc: bool = False,
) -> Path:
    """Convert a Markdown file to PDF via pandoc + typst.

    Returns the path to the generated PDF.
    """
    _check_deps()

    tmpl = template_path(template)
    if not tmpl.is_file():
        raise FileNotFoundError(f"Template not found: {template}")

    highlight_styles = {"document": "tango", "print": "monochrome", "dark": "breezedark"}
    highlight_style = highlight_styles.get(template, "tango")

    with tempfile.TemporaryDirectory() as tmp:
        typ_file = Path(tmp) / "output.typ"

        # Step 1: pandoc markdown → typst markup using our template
        pandoc_cmd = [
            "pandoc",
            str(input_file),
            "--to=typst",
            f"--template={tmpl}",
            f"--syntax-highlighting={highlight_style}",
            "--wrap=none",
            "-o",
            str(typ_file),
        ]
        if toc:
            pandoc_cmd.append("--toc")

        result = subprocess.run(pandoc_cmd, capture_output=True, text=True, check=False)
        if result.returncode != 0:
            raise RuntimeError(f"pandoc failed:\n{result.stderr.strip()}")

        # Step 2: typst compile → PDF
        typst_cmd = [
            "typst",
            "compile",
            str(typ_file),
            str(output_file),
        ]

        result = subprocess.run(typst_cmd, capture_output=True, text=True, check=False)
        if result.returncode != 0:
            raise RuntimeError(f"typst failed:\n{result.stderr.strip()}")

    return output_file
