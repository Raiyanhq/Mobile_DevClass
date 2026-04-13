import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('placeholder widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('CW03 Task Manager'),
        ),
      ),
    );

    expect(find.text('CW03 Task Manager'), findsOneWidget);
  });
}
