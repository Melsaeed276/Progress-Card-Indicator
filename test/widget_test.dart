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
  });
}
