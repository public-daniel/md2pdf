// md2pdf — print template
// Optimized for long-form reading on paper.
// Equity OT A body + headings (small caps via OpenType features),
// JetBrains Mono code, justified + hyphenation, first-line indent,
// wide margins, monochrome code, links as footnotes.

#let horizontalrule = align(center)[
  #v(1em)
  #text(tracking: 0.3em)[\* \* \*]
  #v(1em)
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

  let faint   = luma(248)   // code block backgrounds
  let border  = luma(200)   // rules, strokes
  let subtle  = luma(120)   // running headers, footer, date
  let muted   = luma(80)    // subtitle, author name

  // ── Page ───────────────────────────────────────────────────────────
  let current-section = state("current-section", [])

  set page(
    paper: paper,
    margin: (top: 1.25in, bottom: 1.5in, inside: 1.75in, outside: 1.5in),
    header: context {
      let pg = counter(page).get().first()
      if pg > 1 {
        set text(8.5pt, fill: subtle, font: "Equity OT A", features: ("smcp",))
        if calc.rem(pg, 2) == 0 {
          // Verso (even): page number left, title right
          counter(page).display("1")
          h(1fr)
          if title != none { title }
        } else {
          // Recto (odd): section title left, page number right
          let sect = current-section.get()
          if sect != [] { sect }
          h(1fr)
          counter(page).display("1")
        }
      }
    },
    footer: context {
      let pg = counter(page).get().first()
      if pg == 1 {
        set text(9pt, fill: subtle)
        align(center, counter(page).display("1"))
      }
    },
  )

  // ── Body text ──────────────────────────────────────────────────────
  set text(
    font: "Equity OT A",
    size: 11pt,
    lang: lang,
    region: region,
    ligatures: true,
    hyphenate: true,
    overhang: true,
    costs: (runt: 200%, widow: 100%, orphan: 100%, hyphenation: 150%),
  )

  set par(
    justify: true,
    leading: 0.85em,
    first-line-indent: 1.5em,
    spacing: 0.85em,
    justification-limits: (
      spacing: (min: 75%, max: 150%),
      tracking: (min: -0.012em, max: 0.012em),
    ),
  )

  // ── Headings ───────────────────────────────────────────────────────
  set heading(numbering: sectionnumbering)
  show heading: set block(sticky: true)

  show heading.where(level: 1): it => {
    current-section.update(it.body)
    pagebreak(weak: true)
    v(2.4em)
    block(below: 0.8em)[
      #set text(18pt, weight: "bold", font: "Equity OT A", tracking: -0.015em)
      #it.body
    ]
  }

  show heading.where(level: 2): it => {
    v(1.8em)
    block(below: 0.7em)[
      #set text(13.5pt, weight: "bold", font: "Equity OT A", tracking: -0.01em)
      #it.body
    ]
  }

  show heading.where(level: 3): it => {
    v(1.4em)
    block(below: 0.5em)[
      #set text(11.5pt, weight: "bold", style: "italic", font: "Equity OT A")
      #it.body
    ]
  }

  show heading.where(level: 4): it => {
    v(1.1em)
    block(below: 0.4em)[
      #set text(11pt, weight: "bold", font: "Equity OT A")
      #it.body
    ]
  }

  // Suppress first-line indent after headings
  show heading: it => {
    it
    par(text(size: 0pt, ""))
  }

  // ── Code blocks ────────────────────────────────────────────────────
  show raw.where(block: true): it => {
    let line-count = it.text.split("\n").len()
    v(0.6em)
    block(
      width: 100%,
      fill: faint,
      stroke: (left: 2.5pt + border),
      inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
      breakable: line-count > 15,
    )[
      #set text(8.5pt, font: "JetBrains Mono")
      #set par(justify: false, leading: 0.55em, first-line-indent: 0pt)
      #it
    ]
    v(0.6em)
  }

  show raw.where(block: false): it => {
    box(
      fill: faint,
      inset: (x: 3pt, y: 0pt),
      outset: (y: 2.5pt),
      radius: 1.5pt,
    )[
      #set text(9pt, font: "JetBrains Mono")
      #it
    ]
  }

  // ── Footnotes ──────────────────────────────────────────────────────
  set footnote.entry(
    separator: line(length: 30%, stroke: 0.5pt + luma(150)),
    gap: 0.8em,
  )

  // ── Links → footnotes ─────────────────────────────────────────────
  show link: it => {
    underline(stroke: 0.5pt + luma(160), offset: 2pt, it.body)
    if type(it.dest) == str {
      // Only footnote the URL if link text differs from the URL itself
      let url = it.dest
      let clean = url.replace(regex("^https?://"), "").replace(regex("/$$"), "")
      let body-text = if type(it.body) == content { it.body.text } else { str(it.body) }
      let body-clean = body-text.replace(regex("^https?://"), "").replace(regex("/$$"), "")
      if clean != body-clean {
        footnote[#set text(7.5pt, font: "JetBrains Mono"); #clean]
      }
    }
  }

  // ── Block quotes ───────────────────────────────────────────────────
  show quote.where(block: true): it => {
    v(0.5em)
    block(
      inset: (left: 2em, right: 2em, top: 0.5em, bottom: 0.5em),
      stroke: (left: 1.5pt + luma(180)),
    )[
      #set text(10.5pt, style: "italic", fill: luma(60))
      #set par(first-line-indent: 0pt)
      #it.body
    ]
    v(0.5em)
  }

  // ── Tables ─────────────────────────────────────────────────────────
  show table: set text(9.5pt)
  show table.cell.where(y: 0): set text(weight: "bold", font: "Equity OT A", features: ("smcp",))
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
    v(1fr)  // push title to ~1/3 page height
    v(1fr)
    text(24pt, weight: "bold", font: "Equity OT A", tracking: -0.015em)[#title]
    if subtitle != none {
      v(0.3em)
      text(13pt, style: "italic", fill: muted)[#subtitle]
    }
    if authors.len() > 0 {
      v(0.8em)
      let names = authors.map(a => a.name).join(", ")
      text(11pt, fill: muted, font: "Equity OT A", features: ("smcp",), tracking: 0.05em)[#names]
    }
    if date != none {
      v(0.3em)
      text(10.5pt, fill: subtle)[#date]
    }
    v(2em)
    line(length: 30%, stroke: 1pt + luma(160))
    v(1fr)
    v(1fr)
    v(1fr)
  }

  // ── Abstract ───────────────────────────────────────────────────────
  if abstract != none {
    block(inset: (left: 2em, right: 2em))[
      #set text(10pt)
      #set par(first-line-indent: 0pt)
      #if abstract-title != none {
        text(weight: "bold")[#abstract-title]
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
