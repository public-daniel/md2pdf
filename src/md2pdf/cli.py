"""CLI entry point for md2pdf."""

import sys
from pathlib import Path

import click

from .convert import convert

TEMPLATES = ("document", "print", "dark")


@click.command()
@click.argument("input_file", type=click.Path(exists=True, dir_okay=False, path_type=Path))
@click.option("-o", "--output", type=click.Path(dir_okay=False, path_type=Path), help="Output PDF path.")
@click.option(
    "-t",
    "--template",
    type=click.Choice(TEMPLATES, case_sensitive=False),
    default="print",
    show_default=True,
    help="Typographic template.",
)
@click.option("--toc", is_flag=True, help="Include table of contents.")
@click.option("--open", "open_after", is_flag=True, help="Open PDF after generation.")
def main(
    input_file: Path,
    output: Path | None,
    template: str,
    toc: bool,
    open_after: bool,
) -> None:
    """Convert a Markdown file to a beautifully typeset PDF."""
    if output is None:
        output = input_file.with_suffix(".pdf")

    try:
        result = convert(input_file, output, template=template, toc=toc)
    except (FileNotFoundError, RuntimeError) as e:
        click.secho(f"Error: {e}", fg="red", err=True)
        sys.exit(1)

    click.secho(f"  {result}", fg="green")

    if open_after:
        click.launch(str(result))
