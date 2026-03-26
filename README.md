# md2pdf

Beautiful Markdown to PDF conversion, powered by Pandoc and Typst.

## Install

Requires Python 3.13+, [Pandoc](https://pandoc.org/), and [Typst](https://typst.app/).

```bash
brew install pandoc typst
uv pip install -e .
```

## Usage

```bash
md2pdf document.md                    # default "document" template
md2pdf document.md -t print           # optimized for paper
md2pdf document.md -t print --toc     # with table of contents
md2pdf document.md --open             # open PDF after generation
```

## Templates

**`document`** (default) -- Polished digital PDFs for sharing and screen reading. Equity Text A body, Helvetica Neue headings, colored links, paragraph spacing.

**`print`** -- Optimized for long-form reading on paper. Justified text, first-line indents, running headers, links as footnotes, monochrome throughout.

Both templates use JetBrains Mono for code blocks.

## Frontmatter

Control metadata via YAML frontmatter in your markdown:

```yaml
---
title: Document Title
subtitle: Optional subtitle
author: Your Name
date: March 2026
---
```
