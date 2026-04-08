# Changelog

## 0.2.2

- Test release: version and tag alignment for automated publishing (`v0.2.2`).

## 0.2.1

- Loosen Dart SDK constraint from `^3.11.4` to `^3.0.0` — the package now
  works with any Dart 3.x / Flutter 3.x installation, not just 3.11.4+.
- Fix CI: golden tests tagged and excluded from automated runs; Linux build
  job now installs required GTK3 dev headers.

## 0.2.0

- **Breaking**: `progressColor` internal field replaced by a true linear gradient
  shader. The visible API (`progressStartColor` / `progressEndColor`) is unchanged,
  but the gradient is now painted along the stroke rather than being a single
  interpolated flat colour.
- Added `gap` parameter to `BorderProgressCard` (default `2.0`) — controls the
  spacing between the progress stroke and the inner card surface.
- Fixed `shouldRepaint` to compare `progressStartColor` and `progressEndColor`
  separately (previously only compared a pre-computed single colour).
- Fixed example app: step-text field now calls `setState` so the label updates live.
- Fixed example app: the third slider is now connected to a visible `BorderProgressCard`.
- Expanded test suite: boundary values (0 % / 100 %), custom styling params,
  assertion checks, and golden-test stubs.

## 0.1.0

- Initial release of `progress_card`.
- Added `BorderProgressCard` widget with configurable:
  - progress start/end colors
  - track color
  - surface and inner border colors
  - stroke width and corner radius
- Added example showcase app under `example/`.
- Added tests, documentation, and CI workflows.
