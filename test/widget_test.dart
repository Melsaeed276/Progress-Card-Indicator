import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_card/progress_card.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );

const _defaultCard = BorderProgressCard(
  percentage: 0.5,
  child: SizedBox(width: 100, height: 60),
);

// ---------------------------------------------------------------------------
// Render & child tests
// ---------------------------------------------------------------------------

void main() {
  group('rendering', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(_wrap(
        const BorderProgressCard(
          percentage: 0.5,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text('inside'),
          ),
        ),
      ));

      expect(find.text('inside'), findsOneWidget);
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('renders at percentage 0 without error', (tester) async {
      await tester.pumpWidget(_wrap(
        const BorderProgressCard(
          percentage: 0,
          child: SizedBox(width: 80, height: 50),
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders at percentage 1 without error', (tester) async {
      await tester.pumpWidget(_wrap(
        const BorderProgressCard(
          percentage: 1,
          child: SizedBox(width: 80, height: 50),
        ),
      ));
      expect(tester.takeException(), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Clamping
  // ---------------------------------------------------------------------------

  group('clamping', () {
    testWidgets('clamps negative percentage without throwing', (tester) async {
      await tester.pumpWidget(_wrap(
        const BorderProgressCard(
          percentage: -0.5,
          child: SizedBox(width: 80, height: 50),
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('clamps percentage above 1 without throwing', (tester) async {
      await tester.pumpWidget(_wrap(
        const BorderProgressCard(
          percentage: 1.5,
          child: SizedBox(width: 80, height: 50),
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders two out-of-range cards simultaneously', (tester) async {
      await tester.pumpWidget(_wrap(
        const Column(
          children: [
            BorderProgressCard(percentage: -1, child: SizedBox(width: 20, height: 20)),
            BorderProgressCard(percentage: 2, child: SizedBox(width: 20, height: 20)),
          ],
        ),
      ));

      expect(tester.takeException(), isNull);
      expect(find.byType(BorderProgressCard), findsNWidgets(2));
    });
  });

  // ---------------------------------------------------------------------------
  // Rebuild / repaint
  // ---------------------------------------------------------------------------

  group('rebuild behaviour', () {
    testWidgets('rebuilds when progressStartColor changes', (tester) async {
      Widget build(Color color) => _wrap(BorderProgressCard(
            percentage: 0.5,
            progressStartColor: color,
            progressEndColor: Colors.green,
            child: const SizedBox(width: 30, height: 30),
          ));

      await tester.pumpWidget(build(Colors.red));
      await tester.pumpWidget(build(Colors.blue));
      expect(tester.takeException(), isNull);
    });

    testWidgets('rebuilds when percentage changes', (tester) async {
      Widget build(double pct) => _wrap(BorderProgressCard(
            percentage: pct,
            child: const SizedBox(width: 30, height: 30),
          ));

      await tester.pumpWidget(build(0.2));
      await tester.pumpWidget(build(0.8));
      expect(tester.takeException(), isNull);
    });

    testWidgets('rebuilds when trackColor changes', (tester) async {
      Widget build(Color color) => _wrap(BorderProgressCard(
            percentage: 0.5,
            trackColor: color,
            child: const SizedBox(width: 30, height: 30),
          ));

      await tester.pumpWidget(build(Colors.grey));
      await tester.pumpWidget(build(Colors.black12));
      expect(tester.takeException(), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Custom styling
  // ---------------------------------------------------------------------------

  group('custom styling', () {
    testWidgets('accepts custom strokeWidth', (tester) async {
      await tester.pumpWidget(_wrap(
        const BorderProgressCard(
          percentage: 0.4,
          strokeWidth: 4,
          child: SizedBox(width: 80, height: 50),
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('accepts custom borderRadius', (tester) async {
      await tester.pumpWidget(_wrap(
        const BorderProgressCard(
          percentage: 0.6,
          borderRadius: 24,
          child: SizedBox(width: 80, height: 50),
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('accepts zero borderRadius', (tester) async {
      await tester.pumpWidget(_wrap(
        const BorderProgressCard(
          percentage: 0.6,
          borderRadius: 0,
          child: SizedBox(width: 80, height: 50),
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('accepts custom gap', (tester) async {
      await tester.pumpWidget(_wrap(
        const BorderProgressCard(
          percentage: 0.5,
          gap: 6,
          child: SizedBox(width: 80, height: 50),
        ),
      ));
      expect(tester.takeException(), isNull);
    });

    testWidgets('accepts custom surfaceColor and innerBorderColor', (tester) async {
      await tester.pumpWidget(_wrap(
        const BorderProgressCard(
          percentage: 0.7,
          surfaceColor: Color(0xFFF0F0FF),
          innerBorderColor: Color(0xFFCCCCFF),
          child: SizedBox(width: 80, height: 50),
        ),
      ));
      expect(tester.takeException(), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Assertions
  // ---------------------------------------------------------------------------

  group('assertions', () {
    test('throws when strokeWidth is zero', () {
      expect(
        () => BorderProgressCard(
          percentage: 0.5,
          strokeWidth: 0,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });

    test('throws when strokeWidth is negative', () {
      expect(
        () => BorderProgressCard(
          percentage: 0.5,
          strokeWidth: -1,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });

    test('throws when borderRadius is negative', () {
      expect(
        () => BorderProgressCard(
          percentage: 0.5,
          borderRadius: -1,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });

    test('throws when gap is negative', () {
      expect(
        () => BorderProgressCard(
          percentage: 0.5,
          gap: -1,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Golden tests
  // ---------------------------------------------------------------------------

  group('golden', () {
    testWidgets('default appearance at 65%', (tester) async {
      await tester.pumpWidget(_wrap(
        const SizedBox(
          width: 220,
          height: 100,
          child: _defaultCard,
        ),
      ));
      await expectLater(
        find.byType(BorderProgressCard),
        matchesGoldenFile('goldens/border_progress_card_65pct.png'),
      );
    });

    testWidgets('appearance at 0%', (tester) async {
      await tester.pumpWidget(_wrap(
        const SizedBox(
          width: 220,
          height: 100,
          child: BorderProgressCard(
            percentage: 0,
            child: SizedBox(width: 100, height: 60),
          ),
        ),
      ));
      await expectLater(
        find.byType(BorderProgressCard),
        matchesGoldenFile('goldens/border_progress_card_0pct.png'),
      );
    });

    testWidgets('appearance at 100%', (tester) async {
      await tester.pumpWidget(_wrap(
        const SizedBox(
          width: 220,
          height: 100,
          child: BorderProgressCard(
            percentage: 1,
            child: SizedBox(width: 100, height: 60),
          ),
        ),
      ));
      await expectLater(
        find.byType(BorderProgressCard),
        matchesGoldenFile('goldens/border_progress_card_100pct.png'),
      );
    });
  });
}
