// md2pdf — document template
// Optimized for polished digital PDFs: sharing, screen reading, archival.
// Equity OT A body, Helvetica Neue headings, JetBrains Mono code,
// colored links, parskip spacing, color syntax highlighting.

#let horizontalrule = align(center)[
  #v(1.2em)
  #line(length: 20%, stroke: 0.5pt + luma(180))
  #v(1.2em)
]

#show terms.item: it => block(breakable: false)[
  #text(weight: "bold")[#it.term]
  #block(inset: (left: 1.5em, top: -0.4em))[#it.description]
]

#set table(inset: 6pt, stroke: none)

#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: image): set figure.caption(position: bottom)

$if(highlighting-definitions)$
$highlighting-definitions$
$endif$

// ── conf ─────────────────────────────────────────────────────────────

#let conf(
  title: none,
  subtitle: none,
  authors: (),
  keywords: (),
  date: none,
  lang: "en",
  region: "US",
  abstract-title: none,
  abstract: none,
  thanks: none,
  margin: (:),
  paper: "us-letter",
  font: (),
  fontsize: 11pt,
  mathfont: (),
  codefont: (),
  linestretch: auto,
  sectionnumbering: none,
  pagenumbering: none,
  linkcolor: none,
  citecolor: none,
  filecolor: none,
  cols: 1,
  doc,
) = {

  let accent = rgb("#1a5276")
  let subtle  = rgb("#5d6d7e")
  let faint   = rgb("#f4f6f7")
  let border  = rgb("#d5dbdb")

  // ── Page ───────────────────────────────────────────────────────────
  set page(
    paper: paper,
    margin: (top: 1in, bottom: 1.15in, left: 1.15in, right: 1.15in),
    footer: context {
      set text(8.5pt, fill: luma(150))
      align(center, counter(page).display("1"))
    },
  )

  // ── Body text ──────────────────────────────────────────────────────
  set text(
    font: "Equity OT A",
    size: 11pt,
    lang: lang,
    region: region,
    ligatures: true,
    hyphenate: false,
    costs: (runt: 200%, widow: 100%, orphan: 100%),
  )

  set par(
    justify: false,
    leading: 0.82em,
    first-line-indent: 0pt,
    spacing: 0.88em,
  )

  // ── Headings ───────────────────────────────────────────────────────
  set heading(numbering: sectionnumbering)
  show heading: set block(sticky: true)

  show heading.where(level: 1): it => {
    v(2.2em)
    block(below: 0.7em)[
      #set text(20pt, weight: "bold", font: "Helvetica Neue", fill: rgb("#1b2631"), tracking: -0.015em)
      #it.body
    ]
    line(length: 100%, stroke: 0.5pt + border)
    v(0.3em)
  }

  show heading.where(level: 2): it => {
    v(1.8em)
    block(below: 0.6em)[
      #set text(15pt, weight: "bold", font: "Helvetica Neue", fill: rgb("#2c3e50"), tracking: -0.01em)
      #it.body
    ]
  }

  show heading.where(level: 3): it => {
    v(1.4em)
    block(below: 0.5em)[
      #set text(12.5pt, weight: "bold", font: "Helvetica Neue", fill: rgb("#34495e"))
      #it.body
    ]
  }

  show heading.where(level: 4): it => {
    v(1.1em)
    block(below: 0.4em)[
      #set text(11pt, weight: "bold", font: "Helvetica Neue", fill: rgb("#4a6274"))
      #it.body
    ]
  }

  // ── Code blocks ────────────────────────────────────────────────────
  show raw.where(block: true): it => {
    let line-count = it.text.split("\n").len()
    v(0.5em)
    block(
      width: 100%,
      fill: faint,
      stroke: 0.5pt + border,
      inset: (x: 12pt, y: 10pt),
      radius: 3pt,
      breakable: line-count > 15,
    )[
      #set text(9pt, font: "JetBrains Mono")
      #set par(justify: false, leading: 0.55em, first-line-indent: 0pt)
      #it
    ]
    v(0.5em)
  }

  show raw.where(block: false): it => {
    box(
      fill: faint,
      inset: (x: 3pt, y: 0pt),
      outset: (y: 2.5pt),
      radius: 2pt,
      stroke: 0.3pt + border,
    )[
      #set text(9pt, font: "JetBrains Mono", fill: rgb("#c0392b"))
      #it
    ]
  }

  // ── Links ──────────────────────────────────────────────────────────
  show link: it => {
    set text(fill: accent)
    underline(stroke: 0.5pt + accent.lighten(40%), offset: 2pt, it.body)
  }

  // ── Block quotes ───────────────────────────────────────────────────
  show quote.where(block: true): it => {
    v(0.3em)
    block(
      inset: (left: 1.5em, right: 1em, top: 0.5em, bottom: 0.5em),
      stroke: (left: 3pt + accent.lighten(60%)),
      fill: accent.lighten(95%),
      radius: (right: 2pt),
    )[
      #set text(10.5pt, fill: luma(60))
      #set par(first-line-indent: 0pt)
      #it.body
    ]
    v(0.3em)
  }

  // ── Tables ─────────────────────────────────────────────────────────
  show table: set text(9.5pt)
  show table.cell.where(y: 0): set text(weight: "bold", font: "Helvetica Neue")
  set table(
    inset: (x: 0.6em, y: 0.45em),
    stroke: (x: none, y: 0.5pt + border),
  )
  show table.cell.where(y: 0): set table.cell(
    inset: (x: 0.6em, top: 0.45em, bottom: 0.55em),
  )

  // ── Horizontal rules ───────────────────────────────────────────────
  show: it => {
    show "–––": horizontalrule
    it
  }

  // ── PDF metadata ───────────────────────────────────────────────────
  set document(
    title: if title != none { title } else { "" },
    author: authors.map(a => if type(a.name) == content { a.name.text } else { str(a.name) }),
    date: auto,
  )

  // ── Title block ────────────────────────────────────────────────────
  if title != none {
    v(1.5em)
    text(26pt, weight: "bold", font: "Helvetica Neue", fill: rgb("#1b2631"))[#title]
    if subtitle != none {
      v(0.2em)
      text(15pt, fill: subtle, font: "Helvetica Neue")[#subtitle]
    }
    v(0.6em)
    if authors.len() > 0 {
      let names = authors.map(a => a.name).join(", ")
      text(11pt, fill: subtle, font: "Helvetica Neue")[#names]
    }
    if date != none {
      v(0.15em)
      text(10.5pt, fill: subtle, font: "Helvetica Neue")[#date]
    }
    v(0.8em)
    line(length: 100%, stroke: 0.75pt + accent.lighten(50%))
    v(1em)
  }

  // ── Abstract ───────────────────────────────────────────────────────
  if abstract != none {
    block(
      width: 100%,
      inset: (x: 2em, y: 1em),
      fill: faint,
      radius: 3pt,
    )[
      #set text(10pt)
      #set par(first-line-indent: 0pt)
      #if abstract-title != none {
        text(weight: "bold", font: "Helvetica Neue")[#abstract-title]
        parbreak()
      }
      #abstract
    ]
    v(1.5em)
  }

  if cols == 1 { doc } else { columns(cols, doc) }
}

// ── Apply ────────────────────────────────────────────────────────────

$for(header-includes)$
$header-includes$

$endfor$

#show: doc => conf(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(author)$
  authors: (
$for(author)$
$if(author.name)$
    ( name: [$author.name$], affiliation: [$author.affiliation$], email: [$author.email$] ),
$else$
    ( name: [$author$], affiliation: "", email: "" ),
$endif$
$endfor$
  ),
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
$if(region)$
  region: "$region$",
$endif$
$if(abstract)$
  abstract: [$abstract$],
$endif$
$if(abstract-title)$
  abstract-title: [$abstract-title$],
$endif$
$if(section-numbering)$
  sectionnumbering: "$section-numbering$",
$endif$
  pagenumbering: $if(page-numbering)$"$page-numbering$"$else$"1"$endif$,
  cols: $if(columns)$$columns$$else$1$endif$,
  doc,
)

$for(include-before)$
$include-before$

$endfor$
$if(toc)$

#outline(title: [Contents], depth: $toc-depth$, indent: 1.5em)
#pagebreak()

$endif$

$body$

$for(include-after)$

$include-after$
$endfor$
