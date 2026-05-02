# Sirah Hub V2 Release Audit

Date: 2026-04-29
Branch: `feat/v2-journey-restructure`

## Scope

Sprint 10 audit focused on release readiness without adding product surface:

- Journey promise and route continuity.
- Offline-first constraints.
- Visible legacy wording and placeholders.
- V2 guardrails around `learned`, `practiced`, and religious content.
- Flutter static analysis and test suite.

## Verified

- `/discover` is a legacy route and redirects to `/library`.
- `/name/:number/experience` remains the primary living-name destination.
- Home ritual routes into the living name and does not mark `practiced`.
- Asma al-Husna remains accessible through Library, not Journey.
- No app networking dependency or runtime network call was found in `lib/`,
  `assets/`, or `pubspec.yaml`.
- `learned` remains present for compatibility but is not the primary Journey
  progress metric in Home, Journey, Profile, lists, or favorites.
- The visible placeholder text `Aucun récit dédié` is covered by tests and not
  shown in `NameExperienceScreen`.
- Existing story assets have explicit editorial status fields and are not shown
  as validated content.

## Commands

- `flutter analyze`: passed.
- `flutter test`: passed, 111 tests.

## Remaining Risks

- `docs/ARCHITECTURE.md` and `docs/CODE_REFERENCE.md` are legacy v1.5 references.
  They now contain explicit warnings, but they have not been fully rewritten.
- Legacy Discover screen classes still exist in code, although the router no
  longer exposes them. They can be removed in a dedicated cleanup sprint if
  desired.
- This audit did not include manual device QA for every screen size.

## Release Position

The codebase is technically green for the V2 Journey direction. The next useful
step before a public build is manual app testing on a real device or emulator,
with focus on Home -> Name Experience -> Tafakkur -> Journey -> Profile.
