# CLAUDE.md — progress_card

Project-level instructions for Claude when working in this repository.

---

## What this project is

`progress_card` is a Flutter UI package that provides `BorderProgressCard` — a
content card with a rounded, animated-friendly progress border drawn using
`CustomPainter`. It is published (or will be published) on pub.dev.

Package name: `progress_card`
Current version: `0.2.0`
Repository: https://github.com/Melsaeed276/Progress-Card-Indicator

---

## Project structure

```
lib/
  progress_card.dart          # public barrel export
  src/
    border_progress_card.dart # widget + painter implementation
test/
  widget_test.dart            # widget, clamping, styling, golden tests
example/
  lib/main.dart               # interactive showcase app
pubspec.yaml
CHANGELOG.md
README.md
```

---

## Key design decisions

- **Single widget** — only `BorderProgressCard` is exported. Keep scope narrow.
- **Pure CustomPainter** — no third-party dependencies; only `flutter` SDK.
- **Real gradient** — the progress stroke uses a `LinearGradient` shader mapped
  across the full widget bounds (`topLeft → bottomRight`), not a flat interpolated
  colour. This was intentional to make the gradient consistent regardless of fill %.
- **`gap` parameter** — the spacing between the stroke edge and the inner card is
  exposed as `gap` (default `2.0`). Don't hardcode it.
- **`percentage` is clamped** — clamping happens inside `build()` before being
  passed to the painter. The painter can assume `0.0 ≤ percentage ≤ 1.0`.
- **`shouldRepaint`** compares all painter fields individually — keep it in sync
  whenever new painter fields are added.

---

## Coding conventions

- All public API members have dartdoc comments (`///`).
- Private classes/functions use `_` prefix (`_RectProgressPainter`, `_buildPath`).
- `const` constructors wherever possible.
- `assert()` used for parameter validation in the widget constructor, not in the
  painter (painter trusts its inputs).
- No state management — `BorderProgressCard` is a `StatelessWidget`. Animation
  is the caller's responsibility (e.g. wrap with `AnimatedBuilder`).

---

## Test approach

- Widget tests live in `test/widget_test.dart`.
- Golden files go in `test/goldens/`. Generate with:
  ```bash
  flutter test --update-goldens
  ```
- Run all tests:
  ```bash
  flutter test
  ```

---

## pub.dev checklist before publishing

- [ ] Screenshot / GIF added to README
- [ ] `CHANGELOG.md` entry written for the new version
- [ ] `pubspec.yaml` version bumped
- [ ] All tests pass (`flutter test`)
- [ ] `flutter pub publish --dry-run` passes with no warnings

---

## Common tasks

**Add a new visual variant** — create a new file in `lib/src/`, export it from
`lib/progress_card.dart`, add tests in `test/widget_test.dart`, and showcase it
in `example/lib/main.dart`.

**Bump the version** — update `version` in `pubspec.yaml` and add an entry at
the top of `CHANGELOG.md` following Keep a Changelog format.
