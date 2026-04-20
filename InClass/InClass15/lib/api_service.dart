import 'dart:convert';

import 'package:http/http.dart' as http;

import 'question.dart';

class ApiService {
  static const String apiUrl =
      'https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple';

  Future<List<Question>> fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['response_code'] != 0) {
          throw Exception('API returned no questions');
        }

        final List results = data['results'];
        return results.map((item) => Question.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }
}
