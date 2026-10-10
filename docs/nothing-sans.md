# Nothing Sans

This document records how to set the Nothing LLC and Howblue Ltd brand typeface so it looks the way it does on [noth-ing.com/about](https://noth-ing.com/about/), and what goes wrong when it is set any other way. It exists so the next project starts from the setting that works instead of rediscovering it.

The short version: Nothing Sans is beautiful when it is set large, light, and untouched. Set it Light for paragraphs at 24px, Book for small text, Bold for a short and very large headline, and never change its letter-spacing.

## Files and names

| File | Family name inside the file | Registered in CSS as | Weights |
| --- | --- | --- | --- |
| `assets/typefaces/sansserif/NothingSans-<Style>.otf` | `SansSerif` | `Nothing Sans`, plus `Nothing Sans Light` for Light | ExtraLight, Light, Book, Medium, SemiBold, Bold, ExtraBold, Black, each with an italic |
| `assets/typefaces/serif/NothingSerif-Regular.ttf` | `Serif` | `Nothing Serif` | Regular only |

[`assets/typefaces/nothing-sans.css`](../assets/typefaces/nothing-sans.css) is the canonical web setup: the `@font-face` declarations with the weight mapping, and the type rules from the setting below. Copy it with the font files rather than rewriting it.

Version 1.000 of the sans. Measured metrics: x-height 0.523, cap height 0.718 of the em (San Francisco: 0.508 and 0.705).

## Naming

A font has three names, and they are handled differently on purpose.

| Level | Name | Decision |
| --- | --- | --- |
| CSS family | `Nothing Sans`, `Nothing Sans Light`, `Nothing Serif` | Always register these names. The internal names `SansSerif` and `Serif` are too close to the generic `sans-serif` and `serif` keywords, and a typo or a missing font file then fails silently into the browser default. |
| Filename | `NothingSans-<Style>.otf`, `NothingSerif-Regular.ttf` | Renamed from `SansSerif-*` and `Serif-Regular` on 2026-10-09 so a folder of fonts says what it is. Applied at the same time in every repository that carries the files. |
| Internal name table | `SansSerif`, `Serif` (unchanged) | Left alone. This is what font menus show once a file is installed, and changing it means editing the font file itself, which a license may not allow. Revisit only with the license holder's agreement. |

When a project needs the fonts, copy the renamed files and `nothing-sans.css` together. Do not reintroduce the old filenames.

## The setting that works

The reference implementation is `about/index.html` in the Nothing LLC site repository. These are its rules.

| Element | Face | Size | Line height | Letter-spacing |
| --- | --- | --- | --- | --- |
| Paragraph copy | Light | 24px (20px at or below 1366px wide, 18px at or below 1024px) | 1.46 | 0 |
| Small text, captions, labels, tables | Book | 16px (14px at or below 1366px) | 1.3333 | 0 |
| Section titles | Book | 0.96 × the copy size | 1.25 | 0 |
| Headline | Bold | very large: `clamp(100px, 14.8vw, 282px)` on the about page | 0.98 | 0 |

Why each rule matters:

- **Light for paragraphs.** The face's spacing is still uneven in places (see below). Thin strokes leave air between letters, so uneven pairs stop reading as collisions. Light also looks a notch heavier than its name on dark backgrounds, and at 24px it reads like a comfortable regular weight.
- **Large copy with generous leading.** 24px at 1.46 reads like a printed brochure, not a document. Few words per line, lots of air.
- **A short, huge headline.** At display sizes the headline becomes a shape, and a few letter pairs inside a large shape do not register as spacing errors. A long sentence at a medium size is the worst case for this face.
- **letter-spacing: 0, always.** The face only looks right with its own spacing. Every negative-tracking experiment crowded pairs that the font does not kern.
- **Sentence case.** No tracked uppercase labels. The about page has none, and they fight the face.

### Weight mapping

The about page declares the heavier files one step lighter than their names:

| File | Declared as |
| --- | --- |
| `NothingSans-Book.otf` | 400 |
| `NothingSans-SemiBold.otf` | 700 |
| `NothingSans-Bold.otf` | 800 |
| `NothingSans-Light.otf` | 400, as its own family `Nothing Sans Light` |

So anything that asks for `bold` gets SemiBold, and the heaviest headline is Bold, not Black. Keep this mapping; it is part of the look.

### Loading without a flash

The face should never appear after a fallback font has already been drawn.

- Use `font-display: block` on every `@font-face`.
- Preload the files the page actually uses with `<link rel="preload" as="font" crossorigin>`.
- On text pages, add a `fonts-loading` class to `<html>` before first paint, hide the body while it is present, and fade the body in over about 180ms once the fonts are ready.
- On a wordmark splash, wait on `document.fonts.load('800 58px "Nothing Sans"', "Nothing")`, race it against a 1.8 second timeout, then fade the word in with an ease-out curve.

### On a light background

The about page is white on black. On a light background, keep the same rules and soften the paragraph color rather than the weight. Tested combination: paragraphs `#3d3c39` on `#fbfaf7` (about 10.6:1 contrast), headlines and titles in near-black `#1d1d1b`, captions and labels in `#6b6a66`. Light stays readable at this contrast; a paler paragraph color starts to look faint.

## CSS starting point

Use [`assets/typefaces/nothing-sans.css`](../assets/typefaces/nothing-sans.css). It declares every face with the weight mapping above, sets `font-display: block`, defines `--nothing-copy` and `--nothing-small` with the about page's breakpoints, and applies the setting: Book small text, Light paragraphs at 1.46, a Bold headline at 0.98, sentence-case section titles at 0.96 × copy, and letter-spacing 0. Set the headline size per project: as large as the layout allows, and only for a few words.

## Where the face struggles

Version 1.000 has uneven spacing and sparse kerning. These measurements are the gap between the ink of neighboring letters as a fraction of the font size, at Medium, with the font's own kerning applied, measured with HarfBuzz:

| Pair in "campsite" | ca | am | mp | ps | si | it | te |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Nothing Sans Medium | 0.045 | 0.085 | 0.122 | 0.038 | 0.090 | 0.062 | 0.052 |
| San Francisco | 0.058 | 0.108 | 0.108 | 0.063 | 0.083 | 0.057 | 0.051 |

- `c`+`a` and `p`+`s` are tight, and `m`+`p` is wide, so words break into clumps at headline sizes.
- `t` has almost no left side-bearing (1 unit in Medium) and there is no `i`+`t` kerning pair, so the crossbar of the `t` crowds the `i` once any negative tracking is applied.

These cannot be fixed in CSS. letter-spacing moves every pair by the same amount, and per-letter markup breaks selection and search. The fix belongs in the font. Suggested starting kerning pairs, in font units: `c a` +10, `m p` -10, `p s` +20, `i t` +15 to +25; then review `l t`, `f t`, and round-to-straight spacing generally.

Until the font gets a spacing pass, avoid: a long sentence as a mid-size headline (about 30 to 60px), Medium or SemiBold headlines with tightened tracking, and any negative letter-spacing.

## Tried and rejected

These were tested on a light-background photo-essay site in October 2026 and should not be retried without a new reason.

- **Matching San Francisco's metrics.** Book at 97% size with per-element tracking matched SF's line widths and ink within about 1%, and still looked worse: the tracking exposed the spacing problems above. Setting the face its own way beats imitating another face.
- **Nothing Serif for section titles.** Rejected at every size tried. The serif has a single weight, so never let the browser synthesize a bold (`font-synthesis: none`).
- **Book-contents treatment for gallery titles.** Roman chapter numerals, serif titles, and a right-aligned count were rejected after one look. A cached stylesheet distorted that test, so it was never judged cleanly; retry only deliberately.
- **A smaller headline.** Reducing the headline about 30% from the about-page scale lost the face's presence. Big is the point.

## Platform notes

- **San Francisco cannot be the cross-platform brand face.** It renders through `-apple-system` on Apple devices only. Apple's license does not allow self-hosting it on the web or embedding it in PDFs, even though the file's embedding flags are blank. For text that must look the same on Windows, Linux, and in PDFs, embed a font you are licensed to embed.
- **Inter** (SIL Open Font License) was evaluated as the licensed stand-in for San Francisco and rejected on taste: it read as dated rather than editorial.
- The sans-serif and serif files are licensed to and used by Nothing LLC and Howblue Ltd. Serve and embed them only on behalf of those companies.

## How to evaluate type changes

- **Compare in place.** Add a small fixed switch to the real pages (for example System, Nothing, Nothing 2) that swaps stylesheets and remembers the choice in the browser. Keep the reference option frozen and make every experiment in a layered file on top of it, so any change can be judged against the reference with one click. Fold a winning change into the reference, then reset the experiment layer.
- **Measure screenshots, not renders.** Browsers adjust system fonts optically at text sizes, so offline renders mislead. Take same-page screenshots in the target browser and compare line widths, heights, and ink coverage.
- **Reload from origin.** In Safari, Cmd+Option+R reloads without the cache (Cmd+Shift+R opens Reader).
- **Change one thing at a time,** and record rejected values in the experiment file so they are not tried again.
