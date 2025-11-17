import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/stats_data.dart';

/// Serviço centralizado para persistência de dados
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final Uuid _uuid = Uuid();

  // Chaves para SharedPreferences
  static const String _keyGlobalStats = 'global_stats';
  static const String _keyQuizHistory = 'quiz_history';
  static const String _keyMinigameRecords = 'minigame_records';
  static const String _keyUserPreferences = 'user_preferences';

  // ====================  QUIZ RESULTS ====================

  /// Salvar resultado de quiz
  Future<void> saveQuizResult({
    required String mode,
    required int score,
    required int correctAnswers,
    required int totalQuestions,
    required int timeSpent,
    String? difficulty,
    String? category,
    List<QuestionResult>? questionResults,
  }) async {
    // Criar histórico
    final history = QuizHistory(
      id: _uuid.v4(),
      playedAt: DateTime.now(),
      mode: mode,
      score: score,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      timeSpent: timeSpent,
      difficulty: difficulty,
      category: category,
      questions: questionResults ?? [],
    );

    // Adicionar ao histórico (máximo 50)
    await _addToQuizHistory(history);

    // Atualizar estatísticas globais
    await updateGlobalStats(
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      score: score,
      difficulty: difficulty,
      category: category,
    );
  }

  /// Adicionar ao histórico de quizzes
  Future<void> _addToQuizHistory(QuizHistory history) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_keyQuizHistory);

    List<QuizHistory> historyList = [];
    if (historyJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(historyJson);
        historyList = decoded.map((item) => QuizHistory.fromJson(item)).toList();
      } catch (e) {
        print('Erro ao decodificar histórico: $e');
      }
    }

    // Adicionar novo e manter apenas os últimos 50
    historyList.insert(0, history);
    if (historyList.length > 50) {
      historyList = historyList.sublist(0, 50);
    }

    // Salvar
    final encoded = jsonEncode(historyList.map((h) => h.toJson()).toList());
    await prefs.setString(_keyQuizHistory, encoded);
  }

  /// Obter histórico de quizzes
  Future<List<QuizHistory>> getQuizHistory({int limit = 50}) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_keyQuizHistory);

    if (historyJson == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(historyJson);
      final historyList = decoded.map((item) => QuizHistory.fromJson(item)).toList();
      return historyList.take(limit).toList();
    } catch (e) {
      print('Erro ao carregar histórico: $e');
      return [];
    }
  }

  // ====================  GLOBAL STATS ====================

  /// Atualizar estatísticas globais
  Future<void> updateGlobalStats({
    required int correctAnswers,
    required int totalQuestions,
    required int score,
    String? difficulty,
    String? category,
  }) async {
    final stats = await getGlobalStats();

    // Atualizar contadores
    stats.totalQuizzes++;
    stats.totalQuestions += totalQuestions;
    stats.totalCorrect += correctAnswers;
    stats.totalWrong += (totalQuestions - correctAnswers);
    stats.lastPlayedAt = DateTime.now();

    // Atualizar high score
    if (score > stats.highScore) {
      stats.highScore = score;
    }

    // Atualizar streak
    final accuracy = (correctAnswers / totalQuestions * 100);
    if (accuracy >= 80) {
      stats.currentStreak++;
      if (stats.currentStreak > stats.longestStreak) {
        stats.longestStreak = stats.currentStreak;
      }
    } else {
      stats.currentStreak = 0;
    }

    // Atualizar scores por categoria
    if (category != null) {
      stats.scoresByCategory[category] = (stats.scoresByCategory[category] ?? 0) + score;
    }

    // Atualizar precisão por dificuldade
    if (difficulty != null) {
      final currentAccuracy = stats.accuracyByDifficulty[difficulty] ?? 0;
      final currentCount = stats.accuracyByDifficulty['${difficulty}_count'] ?? 0;
      final newAccuracy = ((currentAccuracy * currentCount) + accuracy) / (currentCount + 1);
      stats.accuracyByDifficulty[difficulty] = newAccuracy.round();
      stats.accuracyByDifficulty['${difficulty}_count'] = currentCount + 1;
    }

    // Salvar
    await _saveGlobalStats(stats);
  }

  /// Salvar estatísticas globais
  Future<void> _saveGlobalStats(GlobalStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyGlobalStats, jsonEncode(stats.toJson()));
  }

  /// Obter estatísticas globais
  Future<GlobalStats> getGlobalStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_keyGlobalStats);

    if (statsJson == null) return GlobalStats();

    try {
      final Map<String, dynamic> decoded = jsonDecode(statsJson);
      return GlobalStats.fromJson(decoded);
    } catch (e) {
      print('Erro ao carregar stats globais: $e');
      return GlobalStats();
    }
  }

  // ====================  MINIGAME RECORDS ====================

  /// Salvar recorde de minigame
  Future<void> saveMinigameRecord(
    String gameId, {
    int? score,
    bool? won,
    int? timeInSeconds,
  }) async {
    final records = await getMinigameRecords();
    final currentRecord = records.getRecord(gameId);

    // Atualizar recorde
    currentRecord.gamesPlayed++;
    if (won == true) {
      currentRecord.gamesWon++;
    }
    if (score != null && score > currentRecord.highScore) {
      currentRecord.highScore = score;
    }
    if (timeInSeconds != null) {
      if (currentRecord.bestTime == null || timeInSeconds < currentRecord.bestTime!) {
        currentRecord.bestTime = timeInSeconds;
      }
    }
    currentRecord.lastPlayedAt = DateTime.now();

    // Salvar
    records.updateRecord(gameId, currentRecord);
    await _saveMinigameRecords(records);
  }

  /// Salvar recordes de minigames
  Future<void> _saveMinigameRecords(MinigameRecords records) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMinigameRecords, jsonEncode(records.toJson()));
  }

  /// Obter recordes de minigames
  Future<MinigameRecords> getMinigameRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getString(_keyMinigameRecords);

    if (recordsJson == null) return MinigameRecords();

    try {
      final Map<String, dynamic> decoded = jsonDecode(recordsJson);
      return MinigameRecords.fromJson(decoded);
    } catch (e) {
      print('Erro ao carregar recordes de minigames: $e');
      return MinigameRecords();
    }
  }

  // ====================  USER PREFERENCES ====================

  /// Salvar preferências do usuário
  Future<void> savePreferences(UserPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserPreferences, jsonEncode(preferences.toJson()));
  }

  /// Obter preferências do usuário
  Future<UserPreferences> getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final prefsJson = prefs.getString(_keyUserPreferences);

    if (prefsJson == null) return UserPreferences();

    try {
      final Map<String, dynamic> decoded = jsonDecode(prefsJson);
      return UserPreferences.fromJson(decoded);
    } catch (e) {
      print('Erro ao carregar preferências: $e');
      return UserPreferences();
    }
  }

  // ====================  UTILITY ====================

  /// Limpar todos os dados (para testes/reset)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyGlobalStats);
    await prefs.remove(_keyQuizHistory);
    await prefs.remove(_keyMinigameRecords);
    // Manter preferências do usuário
  }

  /// Exportar todos os dados como JSON
  Future<String> exportAllData() async {
    final stats = await getGlobalStats();
    final history = await getQuizHistory();
    final records = await getMinigameRecords();
    final preferences = await getPreferences();

    final data = {
      'exportedAt': DateTime.now().toIso8601String(),
      'globalStats': stats.toJson(),
      'quizHistory': history.map((h) => h.toJson()).toList(),
      'minigameRecords': records.toJson(),
      'userPreferences': preferences.toJson(),
    };

    return jsonEncode(data);
  }

  /// Importar dados de JSON (para backup/restore)
  Future<void> importData(String jsonData) async {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonData);

      // Importar stats globais
      if (data.containsKey('globalStats')) {
        final stats = GlobalStats.fromJson(data['globalStats']);
        await _saveGlobalStats(stats);
      }

      // Importar histórico
      if (data.containsKey('quizHistory')) {
        final List<dynamic> historyData = data['quizHistory'];
        final history = historyData.map((item) => QuizHistory.fromJson(item)).toList();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyQuizHistory, jsonEncode(history.map((h) => h.toJson()).toList()));
      }

      // Importar recordes
      if (data.containsKey('minigameRecords')) {
        final records = MinigameRecords.fromJson(data['minigameRecords']);
        await _saveMinigameRecords(records);
      }

      // Importar preferências
      if (data.containsKey('userPreferences')) {
        final preferences = UserPreferences.fromJson(data['userPreferences']);
        await savePreferences(preferences);
      }
    } catch (e) {
      print('Erro ao importar dados: $e');
      rethrow;
    }
  }
}
