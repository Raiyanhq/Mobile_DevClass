import 'package:flutter/material.dart';

import 'api_service.dart';
import 'question.dart';

class QuizScreen extends StatefulWidget {
  final ApiService? apiService;

  const QuizScreen({super.key, this.apiService});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final ApiService apiService;

  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool answered = false;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    apiService = widget.apiService ?? ApiService();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedQuestions = await apiService.fetchQuestions();
      setState(() {
        questions = fetchedQuestions;
        isLoading = false;
        if (fetchedQuestions.isEmpty) {
          errorMessage = 'No questions found.';
        }
      });
    } catch (e) {
      debugPrint('Error loading questions: $e');
      setState(() {
        isLoading = false;
        errorMessage =
            'Could not load questions. Please check your internet and try again.';
      });
    }
  }

  void checkAnswer(String selectedAnswer) {
    if (answered) return;

    final currentQuestion = questions[currentQuestionIndex];

    setState(() {
      answered = true;
      if (selectedAnswer == currentQuestion.correctAnswer) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        answered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz App'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: loadQuestions,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz App'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No questions found.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: loadQuestions,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (currentQuestionIndex >= questions.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Finished'),
        ),
        body: Center(
          child: Text(
            'Your score: $score / ${questions.length}',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1} of ${questions.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion.question,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...currentQuestion.answers.map((answer) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: answered ? null : () => checkAnswer(answer),
                  child: Text(answer),
                ),
              );
            }),
            const SizedBox(height: 20),
            if (answered)
              ElevatedButton(
                onPressed: () {
                  if (currentQuestionIndex == questions.length - 1) {
                    setState(() {
                      currentQuestionIndex++;
                    });
                  } else {
                    nextQuestion();
                  }
                },
                child: Text(
                  currentQuestionIndex == questions.length - 1
                      ? 'Finish Quiz'
                      : 'Next',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
