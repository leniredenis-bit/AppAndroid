import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../models/quiz_service.dart';
import 'language_service.dart';

/// Estado da Pergunta do Dia para hoje.
class DailyStatus {
  final Question question;
  final bool answered;
  final bool correct;
  final int? chosen;
  final int streak; // dias seguidos respondendo
  const DailyStatus(this.question, this.answered, this.correct, this.chosen, this.streak);
}

/// Pergunta do Dia: a mesma pergunta para todo mundo na mesma data.
///
/// Ordem de escolha:
/// 1. `assets/data/pergunta_do_dia.json` → `{"AAAA-MM-DD": "id_da_pergunta"}` (programação manual,
///    pensada para acompanhar o tema do texto diário);
/// 2. senão, sorteio determinístico pela data (todos os aparelhos chegam à mesma pergunta).
///
/// Os IDs das perguntas são iguais nos 3 idiomas, então a pergunta do dia é a mesma em PT/EN/ES.
class DailyQuestionService {
  static const _kDate = 'daily_answered_date';
  static const _kCorrect = 'daily_correct';
  static const _kChosen = 'daily_chosen';
  static const _kStreak = 'daily_streak';
  static const _kLast = 'daily_last_date';

  static Map<String, String>? _schedule;

  static String dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static Future<Map<String, String>> _loadSchedule() async {
    if (_schedule != null) return _schedule!;
    try {
      final raw = await rootBundle.loadString('assets/data/pergunta_do_dia.json');
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _schedule = {
        for (final e in map.entries)
          if (!e.key.startsWith('_')) e.key: e.value.toString(),
      };
    } catch (_) {
      _schedule = {};
    }
    return _schedule!;
  }

  /// Escolhe a pergunta da data (sem depender de aleatoriedade do aparelho).
  static Question pickFor(DateTime date, List<Question> all, Map<String, String> schedule) {
    final key = dateKey(date);
    final scheduled = schedule[key];
    if (scheduled != null) {
      for (final q in all) {
        if (q.id == scheduled) return q;
      }
    }
    final sorted = List<Question>.from(all)..sort((a, b) => a.id.compareTo(b.id));
    final day = DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch ~/ 86400000;
    final index = (day * 2654435761) % sorted.length; // espalha os dias pelo banco inteiro
    return sorted[index];
  }

  static Future<DailyStatus> today() async {
    final now = DateTime.now();
    final all = await QuizService.loadQuestions();
    final q = pickFor(now, all, await _loadSchedule());
    final prefs = await SharedPreferences.getInstance();
    final answered = prefs.getString(_kDate) == dateKey(now);
    return DailyStatus(
      q,
      answered,
      answered && (prefs.getBool(_kCorrect) ?? false),
      answered ? prefs.getInt(_kChosen) : null,
      _currentStreak(prefs, now),
    );
  }

  static int _currentStreak(SharedPreferences prefs, DateTime now) {
    final last = prefs.getString(_kLast);
    final streak = prefs.getInt(_kStreak) ?? 0;
    if (last == null) return 0;
    final yesterday = dateKey(now.subtract(const Duration(days: 1)));
    return (last == dateKey(now) || last == yesterday) ? streak : 0;
  }

  /// Registra a resposta de hoje (uma vez por dia) e atualiza a sequência.
  static Future<int> answer(int chosen, bool correct) async {
    final now = DateTime.now();
    final today = dateKey(now);
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_kDate) == today) return _currentStreak(prefs, now);
    final yesterday = dateKey(now.subtract(const Duration(days: 1)));
    final last = prefs.getString(_kLast);
    final streak = last == yesterday ? (prefs.getInt(_kStreak) ?? 0) + 1 : 1;
    await prefs.setString(_kDate, today);
    await prefs.setBool(_kCorrect, correct);
    await prefs.setInt(_kChosen, chosen);
    await prefs.setString(_kLast, today);
    await prefs.setInt(_kStreak, streak);
    return streak;
  }

  /// Página do texto diário de hoje no site oficial, no idioma do app.
  static String dailyTextUrl() {
    switch (LanguageService().currentLanguageCode) {
      case 'en':
        return 'https://wol.jw.org/en/wol/h/r1/lp-e';
      case 'es':
        return 'https://wol.jw.org/es/wol/h/r4/lp-s';
      default:
        return 'https://wol.jw.org/pt/wol/h/r5/lp-t';
    }
  }
}
