# progress_card

A customizable bordered progress card widget for Flutter.

[![pub package](https://img.shields.io/pub/v/progress_card.svg)](https://pub.dev/packages/progress_card)

## Features

- Rounded border progress indicator around any child widget
- Configurable progress gradient, track color, and surface colors
- Lightweight API for embedding in dashboards, summaries, and cards

## Install

```yaml
dependencies:
  progress_card: ^0.1.0
```

## Usage

```dart
import 'package:progress_card/progress_card.dart';

BorderProgressCard(
  percentage: 0.65,
  strokeWidth: 8,
  borderRadius: 14,
  progressStartColor: const Color(0xFF7F77DD),
  progressEndColor: const Color(0xFF1D9E75),
  child: const Padding(
    padding: EdgeInsets.all(20),
    child: Text('65%'),
  ),
)
```

## API Notes

- `percentage` is clamped to `0.0..1.0`.
- Progress is drawn clockwise from the top-left edge.
- `progressStartColor` and `progressEndColor` are interpolated based on `percentage`.

## Example app

A full showcase app is provided in the `example/` folder.

Run it with:

```bash
cd example
flutter pub get
flutter run
```

## License

MIT - see [`LICENSE`](LICENSE).
