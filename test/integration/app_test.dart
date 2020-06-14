import 'package:flutter_test/flutter_test.dart';
import 'package:math_exercise/app.dart';

void main() {
  testWidgets('Test app startup', (WidgetTester tester) async {
    await tester.pumpWidget(App());

    expect(find.text('计算练习'), findsOneWidget);
  });
}