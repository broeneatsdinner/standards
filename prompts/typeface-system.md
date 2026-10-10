# Typeface System Prompt

Use this prompt when starting a typography, visual-identity, documentation-design, spreadsheet-formatting, or field-manual-design discussion.

## Prompt

Apply the standards repository's typeface guidance from `docs/typefaces.md`.

Use the current working typeface system:

| Typeface | Role |
| --- | --- |
| `Tiempos Text` | Core serif: editorial, literary, serious, warm |
| `Söhne` | Core sans-serif: modern, precise, operator-focused, quietly technical |
| `AGaramondPro-Regular` | Snow Peak reference serif: heritage, elegant, catalog/lifestyle |
| `Proxima` | Snow Peak reference sans-serif: warm, clean, commercial, useful for product tables and gear ledgers |
| `Nothing Sans` | Nothing LLC brand sans: set large, light, and untouched; see `docs/nothing-sans.md` before using it |

Compare type decisions against these pairings:

| Pairing | Personality |
| --- | --- |
| `Tiempos Text + Söhne` | Core identity system: modern, editorial, precise, operator-oriented |
| `AGaramondPro-Regular + Proxima` | Snow Peak reference system: heritage outdoor lifestyle, warm catalog/order-table feel |
| `Tiempos Text + Proxima` | Hybrid gear mode: serious but warm; useful for gear notes, inventory ledgers, and field-manual artifacts |
| `Tiempos Text + Söhne + Proxima` | Tiered system: Tiempos for editorial identity, Söhne for core UI/operator work, Proxima for gear-ledger or Snow Peak-inspired artifacts |

Keep the analysis practical and visual.

Do not make the discussion academic unless asked.

The brand font files in `assets/typefaces/` (sans-serif and serif) are licensed to and used by Nothing LLC and Howblue Ltd; use and commit them. Do not commit or share font files that neither company holds a license for.

When the work uses `Nothing Sans`, start from the setting in `docs/nothing-sans.md` rather than tuning it from scratch.

When screenshots are used as typography references, use only public-safe redacted images in committed assets. Keep unredacted source material in ignored private directories.
