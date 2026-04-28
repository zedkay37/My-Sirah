# Journey V2 Guardrails

Date: 2026-04-28

This document defines the product and architecture rules that should stay true
while V2.1 is consolidated.

## Product Rules

- Primary name destinations open the living name experience:
  `/name/:number/experience`.
- The classic route `/name/:number` remains available only as a secondary
  encyclopedic/detail surface.
- Journey progress is expressed as:
  `viewed -> meditatedNames -> practicedNames -> recognizedNames`.
- `learned` is legacy Study/V1 compatibility state. It must not be used as the
  main product metric for Journey, Profile, Home, name lists, or favorites.
- Asma al-Husna remains Library-only for now and must not appear in the Journey
  galaxy.

## Architecture Rules

- `SettingsNotifier` is the only writer for persisted `UserState`.
- Journey JSON repositories remain read-only.
- UI surfaces that need Journey progress should read
  `journeyProgressResolverProvider` instead of inspecting raw progress sets.
- Study and quiz flows may keep updating `learned` for compatibility, but they
  should also update the appropriate Journey V2 signal when relevant.
- Do not edit generated l10n Dart files directly. Edit ARB sources and run
  `flutter gen-l10n`.

## Audit Focus

- Check that primary CTAs do not route users back into V1 by default.
- Check that `learned` is not presented as the main achievement metric.
- Check that Profile, Home, Journey, Library, and notifications tell one Journey
  story instead of mixing V1 and V2 concepts.
