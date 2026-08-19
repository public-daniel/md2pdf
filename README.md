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

## Development

- [mise](https://mise.jdx.dev/) — pins the toolchain (`mise.toml`), puts the
  `md2pdf` CLI on PATH inside the repo, and runs the task verbs in `tasks/`
- [uv](https://docs.astral.sh/uv/) — Python toolchain (pinned by mise;
  interpreter pinned in `.python-version`)

```bash
mise trust      # one-time: allow this repository's mise.toml
mise run setup  # install pinned tools, sync .venv from uv.lock, install git hooks
```

### Daily commands

| Command                | What it does                                                    |
| ---------------------- | --------------------------------------------------------------- |
| `mise run tidy`        | Format + lint, auto-fixing                                      |
| `mise ci`              | Full read-only gate: format check, lint, ty, tests (pre-commit hook) |
| `mise run test`        | Test suite only                                                 |
| `mise run deps-update` | Re-lock dependencies to latest allowed versions, then sync      |

`mise tasks` lists every verb. Python is linted/formatted by **ruff**,
type-checked by **ty**. Hooks live in `.pre-commit-config.yaml` and are
installed by `mise run setup`.
