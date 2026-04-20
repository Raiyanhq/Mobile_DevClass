import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:signup_app/api_service.dart';
import 'package:signup_app/main.dart';
import 'package:signup_app/question.dart';
import 'package:signup_app/quiz_screen.dart';

class EmptyApiService extends ApiService {
  @override
  Future<List<Question>> fetchQuestions() async {
    return [];
  }
}

class FailingApiService extends ApiService {
  @override
  Future<List<Question>> fetchQuestions() async {
    throw Exception('network failed');
  }
}

void main() {
  testWidgets('quiz app starts and shows a loading indicator', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuizApp());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('empty quiz state shows retry button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: QuizScreen(apiService: EmptyApiService()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No questions found.'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
  });

  testWidgets('failed quiz load shows retry button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: QuizScreen(apiService: FailingApiService()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('Could not load questions'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
  });
}
