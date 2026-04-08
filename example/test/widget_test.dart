import 'package:flutter_test/flutter_test.dart';
import 'package:progress_card_example/main.dart';

void main() {
  testWidgets('showcase app renders title', (WidgetTester tester) async {
    await tester.pumpWidget(const ShowcaseApp());
    await tester.pump();
    expect(find.text('Border Progress Cards'), findsOneWidget);
  });
}
