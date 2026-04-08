# progress_card

A customizable bordered progress card widget for Flutter.

## Features

- Rounded border progress indicator around any child widget
- Configurable progress gradient, track color, and surface colors
- Lightweight API for embedding in dashboards, summaries, and cards

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

## Example app

A full showcase app is provided in the `example/` folder.

Run it with:

```bash
cd example
flutter pub get
flutter run
```
