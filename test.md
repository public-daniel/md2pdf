---
title: The Art of Building CLI Tools
subtitle: A weekend reading companion
author: Daniel
date: March 2026
---

# Introduction

Software development is, at its core, a craft of making the invisible tangible. When we write command-line tools, we're building something that lives at the intersection of *utility* and *elegance*. The best CLI tools don't just work---they feel good to use.

This document serves as both a test of the `md2pdf` typesetting pipeline and a brief meditation on what makes a tool worth building. If you're reading this on paper, notice the typography: the gentle curves of the serif face, the generous margins that give your eyes room to breathe, the way the text sits on the page like it belongs there.

## Why Build Your Own Tools?

There's a particular satisfaction in building something that solves *your* problem in exactly the way you want it solved. Off-the-shelf tools are compromises by nature---they have to serve a broad audience.

> The programmer, like the poet, works only slightly removed from pure thought-stuff. He builds his castles in the air, from air, creating by exertion of the imagination.
>
> --- Fred Brooks, *The Mythical Man-Month*

When you build your own tools, you get to make all the decisions. You choose the defaults. You decide what's worth configuring and what should just work. This is a luxury that [open source](https://github.com) has made possible for everyone.

### The Unix Philosophy

The best tools follow a simple principle: do one thing well. A markdown-to-PDF converter should convert markdown to PDF. It shouldn't manage your files, sync to the cloud, or send notifications.

Here's what a good tool looks like in practice:

- It has sensible defaults
- It stays out of your way
- It composes well with other tools
- It respects your time

And when you need more structure, numbered steps help:

1. Write your content in markdown
2. Choose a template (`document` for screen, `print` for paper)
3. Run `md2pdf` and get a beautiful PDF
4. Optionally add `--toc` for a table of contents

Nested lists are useful for organizing complex ideas:

- **Typography choices**
  - Serif fonts for body text (Equity Text A)
  - Sans-serif for headings in the document template (Helvetica Neue)
  - Monospace for code (JetBrains Mono)
- **Layout decisions**
  - Justified text for print, ragged-right for screen
  - First-line indent for print, paragraph spacing for screen
  - Asymmetric margins for print (binding-aware)

Here's what the pipeline looks like:

```python
def convert(input_file: Path, output_file: Path, template: str = "document") -> Path:
    """Convert a Markdown file to PDF via pandoc + typst."""
    # Step 1: markdown → typst markup
    pandoc_cmd = ["pandoc", str(input_file), "--to=typst", f"--template={template}"]

    # Step 2: typst → PDF
    typst_cmd = ["typst", "compile", typ_file, str(output_file)]

    return output_file
```

And here's a shell example for comparison:

```bash
#!/bin/bash
# Simple wrapper around the pipeline
md2pdf "$1" -t print --toc --open
echo "Done: $1 → ${1%.md}.pdf"
```

---

## Typography Matters

The difference between a *good* document and a *great* one often comes down to details that most people can't name but everyone can feel:

1. **Line length** --- keeping lines to roughly 65 characters prevents eye fatigue
2. **Leading** --- the space between lines needs to match the font's proportions
3. **Margins** --- generous margins aren't wasted space; they're breathing room
4. **Hyphenation** --- proper hyphenation prevents rivers of white space in justified text

### A Quick Comparison

| Feature | Print Template | Document Template |
|---------|---------------|-------------------|
| Body font | Equity Text A | Equity Text A |
| Headings | Equity Text A (bold) | Helvetica Neue |
| Code font | JetBrains Mono | JetBrains Mono |
| Alignment | Justified | Left-aligned |
| Links | Footnotes | Colored + clickable |
| Paragraphs | First-line indent | Paragraph spacing |

### Code in Context

Inline code like `md2pdf test.md -t print` should blend with the surrounding text without being jarring. Block code should stand apart clearly:

```json
{
  "templates": {
    "print": "Optimized for paper, long-form reading",
    "document": "Polished digital sharing and screen reading"
  },
  "fonts": {
    "body": "Equity Text A",
    "code": "JetBrains Mono",
    "size": "11pt"
  }
}
```

### Key Terminology

Pandoc
:   A universal document converter that handles the markdown-to-Typst conversion step.

Typst
:   A modern typesetting system that compiles markup into beautifully rendered PDFs.

Template
:   A Typst file with Pandoc variable interpolation that controls all visual presentation.

Leading
:   The vertical space between lines of text, measured from baseline to baseline.

## Final Thoughts

The goal of `md2pdf` isn't to replace LaTeX or compete with InDesign. It's to make the *common case* beautiful with zero effort.[^1] Write your markdown, pick a template, get a PDF that looks like someone cared about the typography---because someone did.

The tools we build for ourselves are often the most honest expressions of what we value. If you value your own reading experience enough to print markdown on a Saturday morning, you probably value getting the details right.

[^1]: For the uncommon cases, you can always drop down to raw Typst via `header-includes` in your YAML frontmatter.

---

*Built with md2pdf, pandoc, and typst.*
