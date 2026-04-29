# Journey Content Backlog

Status: internal editorial backlog.

This file tracks religious/content work that must be handled by a human editor. It is not loaded by the app and must not be treated as validated user-facing content.

## Rules

- Do not generate Sirah stories, tafakkur prompts, or religious actions with AI.
- Do not present `needs_review` or `draft` material as validated.
- Prefer existing `names.json` commentary and references until a human validates deeper content.
- Keep `names.json` read-only unless explicit validation is given.

## Current Snapshot

- Prophet names in Journey: 201/201.
- Name experiences present: 4.
- Stories marked `validated`: 0.
- Stories marked `needs_review`: 4.
- Names without a dedicated validated story: 201.
- Action banks present: 5 themes, all generic or theme-level.

## Stories Needing Review

| Name # | Story ID | Current Status | Required Editorial Action |
| --- | --- | --- | --- |
| 1 | `muhammad_name_of_praise` | `needs_review` | Add verified source references or keep hidden behind commentary fallback. |
| 5 | `messenger_as_guidance` | `needs_review` | Add verified source references or keep hidden behind commentary fallback. |
| 21 | `truthfulness_as_character` | `needs_review` | Add verified source references or keep hidden behind commentary fallback. |
| 78 | `nobility_as_responsibility` | `needs_review` | Add verified source references or keep hidden behind commentary fallback. |

## Coverage Gaps

- 197 names have no `NameExperience` entry.
- 201 names currently rely on the safe `name.commentary` fallback for validated user-facing understanding.
- No story should be promoted to `validated` until `sourceRefs`, reviewer identity, and validation date are filled.

## Action Banks

| Theme | Status | Note |
| --- | --- | --- |
| `general` | needs editorial review | Generic actions are available as fallback. |
| `praise` | needs editorial review | Theme-level actions exist. |
| `mission` | needs editorial review | Theme-level actions exist. |
| `trust` | needs editorial review | Theme-level actions exist. |
| `nobility` | needs editorial review | Theme-level actions exist. |

Future action model work may add status fields per action. Until then, actions should remain simple, non-performative, and contextualized as intentions.

## Validation Checklist For A Story

- `editorialStatus`: `validated`
- `sourceRefs`: at least one human-approved reference
- `reviewedBy`: filled
- `validatedAt`: ISO date
- No invented doctrinal interpretation
- UI tested for both validated-story and fallback-commentary paths

