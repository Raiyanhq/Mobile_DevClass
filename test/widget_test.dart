<<<<<<< HEAD
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mad_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
=======
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:signup_app/main.dart';

void main() {
  testWidgets('starts on welcome and opens signup screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SignupAdventureApp());

    final startAction = find.byIcon(Icons.arrow_forward_rounded);
    expect(startAction, findsOneWidget);

    await tester.tap(startAction);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('shows validation messages for invalid signup input', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SignupAdventureApp());

    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please choose your birth date'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
  });

  testWidgets('shows loading state on valid signup submission', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SignupAdventureApp());

    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.enterText(find.byType(TextFormField).at(0), 'Saquib Ahmed');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'saquib@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), '2000-01-01');

    await tester.enterText(find.byType(TextFormField).at(3), 'secret123');

    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1300));
>>>>>>> cd91b40 (Added in-class mobile dev files)
  });
}
