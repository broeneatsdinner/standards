# Generate an Animated README Button

Use this workflow to create a repository-specific dark animated manual CTA
from the canonical no-text motion source. Read
`docs/animated-readme-buttons.md` before acting.

## Authority boundary

Generating assets in the standards repository is implementation work when the
operator asks for it. Copying an asset into a consumer repository, changing a
README, committing, pushing, or publishing a public repository requires the
operator's separate approval.

Do not generate GIFs. Do not commit font files. Do not overwrite an existing
asset package without an explicit replacement instruction.

## Required inputs

Collect these exact inputs:

```text
label: exact visible button text without the arrow
slug: kebab-case asset name
theme: dark
radius: 8px
font: local SansSerif-SemiBold.otf path
source frames: canonical 391-frame directory
output directory: assets/buttons root
```

The label normally follows this form:

```text
Read the <Repository Name> manual
```

## Generate

1. Confirm the source directory contains exactly `frame-001.png` through
   `frame-391.png` in order.
2. Run `bin/generate-readme-button` with the supplied inputs.
3. Confirm the generated package records its intended display width in
   `metadata.json`.
4. Inspect the high-quality and lossless WebPs in motion. Check for gradient
   blocking, timing errors, and playback artifacts rather than judging only a
   still frame.
5. Validate the generated PNG frame count, both WebP frame counts, the 13,033ms
   duration, the 33/33/34 timing pattern, and the high-quality full-keyframe
   rule.

## Consumer adoption

After explicit approval, copy only the selected high-quality production WebP
into the consumer repository's `assets/buttons/` directory. Do not copy the
frames, lossless comparison asset, MP4 preview, generator, or font file.

Place the visual CTA above the ordinary Markdown manual link in the README.
Link both to the same destination: `docs/index.md` before deployment, or the
verified rendered Pages URL after deployment. The text link remains directly
beneath the button as the durable fallback.

Treat both links as one CTA block. Use a standalone `<br><br>` after the
opening repository framing and before the visual CTA, then another standalone
`<br><br>` after the fallback link and before the next README section. Do not
insert those breaks inside the anchor or image markup.

Use an `<img>` width equal to the `metadata.json` intended display width so the
README renders the 2x asset at its intended size.
