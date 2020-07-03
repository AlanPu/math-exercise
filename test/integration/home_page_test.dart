import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_exercise/ui/views/math_home_page.dart';

void main() {
  Widget buildTestableWidget(Widget widget) {
    return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
  }

  testWidgets('Home page test', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(MathHomePage(title: '计算练习')));

    expect(find.text('计算练习'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(CupertinoSlider), findsNWidgets(2));
    expect(find.text('出题数:'), findsOneWidget);
    expect(find.text('出题范围:'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.byType(FlatButton), findsOneWidget);
  });
}
