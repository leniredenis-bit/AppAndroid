import 'dart:convert';
import 'package:flutter/services.dart';
import 'question.dart';

class QuizService {
  static List<Question>? _questions;

  static Future<List<Question>> loadQuestions() async {
    if (_questions != null) {
      return _questions!;
    }

    final String jsonString = await rootBundle.loadString('assets/data/perguntas_atualizado.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    
    _questions = jsonList.map((json) => Question.fromJson(json)).toList();
    return _questions!;
  }

  static List<Question> filterByDifficulty(List<Question> questions, String difficulty) {
    return questions.where((q) => q.dificuldade == difficulty).toList();
  }

  static List<Question> filterByTag(List<Question> questions, String tag) {
    return questions.where((q) => q.tags.contains(tag)).toList();
  }

  static List<Question> getRandomQuestions(List<Question> questions, int count) {
    final shuffled = List<Question>.from(questions)..shuffle();
    return shuffled.take(count).toList();
  }
}
