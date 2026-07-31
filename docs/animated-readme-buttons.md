# Animated README Buttons

## Purpose

An animated README button is a visual invitation into a repository's rendered
manual. It complements, but never replaces, the ordinary Markdown manual link
directly beneath it.

The standards repository owns the canonical animation source, frame set, and
quality variants. A consumer repository receives only its selected production
WebP in `assets/buttons/`, keeping the consumer README self-contained without
copying production frames or video masters into every project.

## Canonical visual system

The canonical dark motion source is:

```text
assets/buttons/animated-gradient-no-text-8px/frames/frame-001.png
...
assets/buttons/animated-gradient-no-text-8px/frames/frame-391.png
```

The source contains 391 ordered frames at 600x142. A generated button uses all
391 frames in order and preserves the 13,033ms loop with a repeating 33ms,
33ms, 34ms frame-duration pattern.

The visual contract is:

- dark animated gradient background
- 8px rounded corners
- local `SansSerif-SemiBold.otf` at 40px source size, white and non-italic
- white vector right arrow with a 4.5px stroke; no Unicode arrow glyph
- text and arrow centered as one visual group
- no GIF output

The generator resizes the canonical motion field horizontally to the native
asset width, applies the 8px alpha mask, and composites the static label and
arrow over every frame. It does not redraw the animation by hand.

See [Animated Dark Button Color Language](colors-and-palettes.md#animated-dark-button-color-language)
for the canonical dark-surface and moving-color relationship.

## Generate a package

Run from the standards repository root:

```sh
bin/generate-readme-button \
  --label "Read the Operator Pipeline manual" \
  --slug "read-the-operator-pipeline-manual" \
  --theme dark \
  --radius 8 \
  --font assets/typefaces/sansserif/SansSerif-SemiBold.otf \
  --source-frames assets/buttons/animated-gradient-no-text-8px/frames \
  --output-dir assets/buttons
```

The generator refuses to overwrite an existing package. It is deterministic
from the label, slug, font file, source-frame directory, and output directory.

It requires Python with Pillow plus `cwebp`, `webpmux`, `webpinfo`, `ffmpeg`,
and `ffprobe` on `PATH`.

## Size and placement

Measure the label at 40px in `SansSerif-SemiBold.otf`, then add 48px of padding
on each side, a 24px text-to-arrow gap, and a 31px arrow width. Round the total
up to the next 100px native width. The asset height remains 142px.

The intended README width is half the native width because these are 2x assets.
The generator records the measured label width, native dimensions, intended
README display dimensions, timing, and source hashes in `metadata.json`.

For example, a 634px label becomes an 800x142 native asset and renders at
400x71 in a README.

## Asset package

```text
assets/buttons/<slug>-8px/
├── frames/
│   ├── frame-001.png
│   └── ... frame-391.png
├── <slug>-dark-8px-high-quality.webp
├── <slug>-dark-8px-lossless.webp
├── <slug>-dark.mp4
└── metadata.json
```

`high-quality.webp` is the normal production candidate: lossy WebP at quality
100 with every frame encoded as a full keyframe. `lossless.webp` is retained
for visual comparison and featured-project use. `dark.mp4` composites the
transparent animation over `#0d1117` for inspection only; it is not embedded
in a README.

High-quality files should generally land in the 6–12MB range when the label
length and native width allow it. Quality 100 and full keyframes take priority
over a smaller file when they conflict.

## Validate and adopt

Before committing a generated package, verify:

- exactly 391 output PNG frames
- 391 frames and a 13,033ms duration in both WebPs
- identical ordered source-frame timing in both WebPs
- full-canvas keyframes in the high-quality WebP
- both WebPs look clean in motion, with no gradient blocking or playback
  artifacts
- the recorded README display width is appropriate
- no font files and no GIFs are present

Copy only the selected production WebP to the consumer repository:

```text
assets/buttons/<slug>-dark-8px-high-quality.webp
```

Keep the regular Markdown link directly beneath the CTA. It remains the
durable fallback, the accessible navigation path, and the readable option when
images are disabled.

In a README, make the CTA and fallback link a visually distinct block: use a
standalone `<br><br>` after the opening project framing and before the CTA, then
another standalone `<br><br>` after the fallback link and before the next
section. Do not put either break sequence inside the anchor or image markup.

Use controlled-width HTML when embedding the 2x asset in a README:

```html
<br><br>

<a href="./docs/">
  <img
    src="./assets/buttons/<slug>-dark-8px-high-quality.webp"
    alt="Read the project manual"
    width="<intended-display-width>"
  >
</a>

**[Read the project manual →](./docs/)**

<br><br>
```

For a deployed Pages manual, replace `./docs/` with the verified Pages URL.
