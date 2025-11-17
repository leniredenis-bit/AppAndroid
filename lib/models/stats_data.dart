import 'dart:convert';

/// Estatísticas globais do usuário
class GlobalStats {
  int totalQuizzes;
  int totalQuestions;
  int totalCorrect;
  int totalWrong;
  int highScore;
  int currentStreak;
  int longestStreak;
  DateTime? lastPlayedAt;
  Map<String, int> scoresByCategory;  // "Genesis": 850, "Exodo": 720
  Map<String, int> accuracyByDifficulty;  // "easy": 95, "medium": 78, "hard": 65

  GlobalStats({
    this.totalQuizzes = 0,
    this.totalQuestions = 0,
    this.totalCorrect = 0,
    this.totalWrong = 0,
    this.highScore = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastPlayedAt,
    Map<String, int>? scoresByCategory,
    Map<String, int>? accuracyByDifficulty,
  })  : scoresByCategory = scoresByCategory ?? {},
        accuracyByDifficulty = accuracyByDifficulty ?? {};

  /// Precisão geral em percentual
  double get accuracy {
    if (totalQuestions == 0) return 0.0;
    return (totalCorrect / totalQuestions * 100);
  }

  /// Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'totalQuizzes': totalQuizzes,
      'totalQuestions': totalQuestions,
      'totalCorrect': totalCorrect,
      'totalWrong': totalWrong,
      'highScore': highScore,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastPlayedAt': lastPlayedAt?.toIso8601String(),
      'scoresByCategory': scoresByCategory,
      'accuracyByDifficulty': accuracyByDifficulty,
    };
  }

  /// Criar a partir de JSON
  factory GlobalStats.fromJson(Map<String, dynamic> json) {
    return GlobalStats(
      totalQuizzes: json['totalQuizzes'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      totalCorrect: json['totalCorrect'] ?? 0,
      totalWrong: json['totalWrong'] ?? 0,
      highScore: json['highScore'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastPlayedAt: json['lastPlayedAt'] != null
          ? DateTime.parse(json['lastPlayedAt'])
          : null,
      scoresByCategory: Map<String, int>.from(json['scoresByCategory'] ?? {}),
      accuracyByDifficulty: Map<String, int>.from(json['accuracyByDifficulty'] ?? {}),
    );
  }
}

/// Resultado de uma pergunta individual
class QuestionResult {
  final String questionId;
  final bool wasCorrect;
  final int timeToAnswer;  // Em segundos

  QuestionResult({
    required this.questionId,
    required this.wasCorrect,
    required this.timeToAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'wasCorrect': wasCorrect,
      'timeToAnswer': timeToAnswer,
    };
  }

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      questionId: json['questionId'],
      wasCorrect: json['wasCorrect'],
      timeToAnswer: json['timeToAnswer'],
    );
  }
}

/// Histórico de um quiz completado
class QuizHistory {
  final String id;  // UUID
  final DateTime playedAt;
  final String mode;  // "classic", "pie", "multiplayer"
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final int timeSpent;  // Em segundos
  final String? difficulty;
  final String? category;
  final List<QuestionResult> questions;

  QuizHistory({
    required this.id,
    required this.playedAt,
    required this.mode,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timeSpent,
    this.difficulty,
    this.category,
    List<QuestionResult>? questions,
  }) : questions = questions ?? [];

  /// Precisão em percentual
  double get accuracy {
    if (totalQuestions == 0) return 0.0;
    return (correctAnswers / totalQuestions * 100);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playedAt': playedAt.toIso8601String(),
      'mode': mode,
      'score': score,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'timeSpent': timeSpent,
      'difficulty': difficulty,
      'category': category,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  factory QuizHistory.fromJson(Map<String, dynamic> json) {
    return QuizHistory(
      id: json['id'],
      playedAt: DateTime.parse(json['playedAt']),
      mode: json['mode'],
      score: json['score'],
      correctAnswers: json['correctAnswers'],
      totalQuestions: json['totalQuestions'],
      timeSpent: json['timeSpent'],
      difficulty: json['difficulty'],
      category: json['category'],
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => QuestionResult.fromJson(q))
              .toList() ??
          [],
    );
  }
}

/// Recorde de um minigame específico
class MinigameRecord {
  int highScore;
  int gamesPlayed;
  int gamesWon;
  int? bestTime;  // Em segundos (quando aplicável)
  DateTime? lastPlayedAt;

  MinigameRecord({
    this.highScore = 0,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.bestTime,
    this.lastPlayedAt,
  });

  /// Taxa de vitória em percentual
  double get winRate {
    if (gamesPlayed == 0) return 0.0;
    return (gamesWon / gamesPlayed * 100);
  }

  Map<String, dynamic> toJson() {
    return {
      'highScore': highScore,
      'gamesPlayed': gamesPlayed,
      'gamesWon': gamesWon,
      'bestTime': bestTime,
      'lastPlayedAt': lastPlayedAt?.toIso8601String(),
    };
  }

  factory MinigameRecord.fromJson(Map<String, dynamic> json) {
    return MinigameRecord(
      highScore: json['highScore'] ?? 0,
      gamesPlayed: json['gamesPlayed'] ?? 0,
      gamesWon: json['gamesWon'] ?? 0,
      bestTime: json['bestTime'],
      lastPlayedAt: json['lastPlayedAt'] != null
          ? DateTime.parse(json['lastPlayedAt'])
          : null,
    );
  }
}

/// Recordes de todos os minigames
class MinigameRecords {
  Map<String, MinigameRecord> records;

  MinigameRecords({Map<String, MinigameRecord>? records})
      : records = records ?? {};

  /// Obter recorde de um jogo específico
  MinigameRecord getRecord(String gameId) {
    return records[gameId] ?? MinigameRecord();
  }

  /// Atualizar recorde de um jogo
  void updateRecord(String gameId, MinigameRecord record) {
    records[gameId] = record;
  }

  Map<String, dynamic> toJson() {
    return {
      'records': records.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  factory MinigameRecords.fromJson(Map<String, dynamic> json) {
    final recordsMap = json['records'] as Map<String, dynamic>? ?? {};
    return MinigameRecords(
      records: recordsMap.map(
        (key, value) => MapEntry(key, MinigameRecord.fromJson(value)),
      ),
    );
  }
}

/// Preferências do usuário
class UserPreferences {
  bool isDarkTheme;
  double musicVolume;
  double sfxVolume;
  String language;  // "pt", "en", "es"
  bool showTutorial;
  bool hapticFeedback;

  UserPreferences({
    this.isDarkTheme = true,
    this.musicVolume = 0.5,
    this.sfxVolume = 0.5,
    this.language = 'pt',
    this.showTutorial = true,
    this.hapticFeedback = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'isDarkTheme': isDarkTheme,
      'musicVolume': musicVolume,
      'sfxVolume': sfxVolume,
      'language': language,
      'showTutorial': showTutorial,
      'hapticFeedback': hapticFeedback,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      isDarkTheme: json['isDarkTheme'] ?? true,
      musicVolume: (json['musicVolume'] ?? 0.5).toDouble(),
      sfxVolume: (json['sfxVolume'] ?? 0.5).toDouble(),
      language: json['language'] ?? 'pt',
      showTutorial: json['showTutorial'] ?? true,
      hapticFeedback: json['hapticFeedback'] ?? true,
    );
  }

  UserPreferences copyWith({
    bool? isDarkTheme,
    double? musicVolume,
    double? sfxVolume,
    String? language,
    bool? showTutorial,
    bool? hapticFeedback,
  }) {
    return UserPreferences(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      musicVolume: musicVolume ?? this.musicVolume,
      sfxVolume: sfxVolume ?? this.sfxVolume,
      language: language ?? this.language,
      showTutorial: showTutorial ?? this.showTutorial,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
    );
  }
}
