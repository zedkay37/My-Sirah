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
- Action banks present: 13 themes, 43 actions, 4 linked directly to names.
- Actions marked `validated`: 40.
- Actions marked `needs_review`: 3.

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
| `general` | needs editorial review | Guardrail bank, not a user-facing generic fallback. |
| `praise` | pilot validated | 3 theme-level actions and name #1 action validated. |
| `mission` | pilot validated | 3 theme-level actions and name #5 action validated. |
| `trust` | second wave validated | 3 theme-level actions and name #21 action validated. |
| `nobility` | second wave validated | 3 theme-level actions and name #78 action validated. |
| `intercession` | third wave validated | 3 theme-level actions validated. |
| `eschatology` | third wave validated | 3 theme-level actions validated. |
| `purity` | third wave validated | 3 theme-level actions validated. |
| `virtues` | second wave validated | 3 theme-level actions validated. |
| `miraj` | third wave validated | 3 theme-level actions validated. |
| `guidance` | third wave validated | 3 theme-level actions validated. |
| `light` | pilot validated | 3 theme-level actions validated. |
| `devotion` | third wave validated | 3 theme-level actions validated. |

Review support lives in `docs/ACTION_REVIEW_V2.md`. Actions should remain simple, non-performative, and contextualized as invitations.

## Validation Checklist For An Action

- `editorialStatus`: `validated`
- `reviewedBy`: filled
- `validatedAt`: ISO date
- `sourceNote` or `sourceRefs`: filled
- No invented doctrinal interpretation
- No generic fallback presented as specific to a name
- UI tested for Accueil, Fiche du nom, and Tafakkur when the action becomes visible

## Validation Checklist For A Story

- `editorialStatus`: `validated`
- `sourceRefs`: at least one human-approved reference
- `reviewedBy`: filled
- `validatedAt`: ISO date
- No invented doctrinal interpretation
- UI tested for both validated-story and fallback-commentary paths
