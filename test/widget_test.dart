import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progress_card/progress_card.dart';

void main() {
  testWidgets('renders BorderProgressCard child', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: BorderProgressCard(
              percentage: 0.5,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text('inside'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('inside'), findsOneWidget);
    expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
  });

  testWidgets('clamps percentage values outside expected range',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              BorderProgressCard(percentage: -1, child: SizedBox(width: 20, height: 20)),
              BorderProgressCard(percentage: 2, child: SizedBox(width: 20, height: 20)),
            ],
          ),
        ),
      ),
    );

    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(BorderProgressCard), findsNWidgets(2));
  });

  testWidgets('rebuilds when style changes', (WidgetTester tester) async {
    Widget build(Color color) => MaterialApp(
          home: Scaffold(
            body: BorderProgressCard(
              percentage: 0.5,
              progressStartColor: color,
              progressEndColor: Colors.green,
              child: const SizedBox(width: 30, height: 30),
            ),
          ),
        );

    await tester.pumpWidget(build(Colors.red));
    await tester.pumpWidget(build(Colors.blue));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
