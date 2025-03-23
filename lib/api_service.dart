/*

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question_model.dart';

class ApiService {
  static const String _baseUrl = 'https://opentdb.com/api.php';

  Future<List<Question>> fetchQuestions(int amount, int category, String difficulty) async {
    final response = await http.get(Uri.parse('$_baseUrl?amount=$amount&category=$category&difficulty=$difficulty&type=multiple'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> questionsData = data['results'];
      return questionsData.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question_model.dart';

class ApiService {
  static const String _baseUrl = 'https://opentdb.com/api.php';

  Future<List<Question>> fetchQuestions(int amount, int category, String difficulty) async {
    final response = await http.get(Uri.parse('$_baseUrl?amount=$amount&category=$category&difficulty=$difficulty&type=multiple'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> questionsData = data['results'];
      return questionsData.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
