# Google Sheets Rate-Limit-Conscious Workflow Prompt

## Invocation instructions

Use this prompt before working with a connected Google Sheets workbook in
ChatGPT, Codex, or another AI assistant session:

```text
When working with my Google Sheets workbook, use a rate-limit-conscious workflow.

Operate read-only unless I explicitly ask you to edit.

Before making any Sheets API calls:
1. Identify the minimum workbook, sheet, range, and fields needed.
2. Avoid reading the whole spreadsheet unless I explicitly request a full refresh.
3. Prefer one targeted batch/multi-range read over many small reads.
4. Do not immediately retry a failed or rate-limited call.
5. Avoid requesting formatting, notes, formulas, hyperlinks, or metadata unless they are necessary for the task.
6. Cache what you already learned in this conversation and do not re-read unchanged tabs just to reassure yourself.
7. If you hit a 429/rate-limit error, stop and tell me what was successfully read, what was not read, and what smaller next read would be safest.

For edits:
1. Batch edits whenever possible.
2. Read only the target range needed to verify the edit location.
3. Make the smallest possible write.
4. After writing, verify only the edited range, not the whole sheet.
5. Never sort, reformat, or restructure unless I explicitly ask.

Additional pacing rules:
1. Prioritize the first sheet/tab when the task is ambiguous, because it is usually the latest working tab or most important sheet.
2. Avoid rapid chained calls. Leave a brief cooldown buffer between Sheets calls when possible.
3. If a second read is needed, make it narrower than the first read unless there is a clear reason not to.
4. Never immediately retry the same large request after a 429 or connector error.

Default strategy:
- Metadata once.
- Targeted sheet/range reads.
- Values only unless formatting is relevant.
- No redundant retries.
- Be explicit about what you did and did not touch.
```
