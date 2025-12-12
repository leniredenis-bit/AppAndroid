import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'firebase_service.dart';

/// Serviço singleton para Firebase Analytics
/// 
/// Responsável por:
/// - Rastrear eventos de jogo (game_start, level_complete, game_over)
/// - Rastrear visualização de telas
/// - Identificar usuários
/// - Definir propriedades do usuário
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  FirebaseAnalytics? _analytics;
  FirebaseAnalyticsObserver? _observer;
  
  bool _isEnabled = true;
  String? _currentUserId;

  /// Observer para navegação automática (usar no MaterialApp)
  FirebaseAnalyticsObserver? get observer => _observer;
  
  /// Verifica se o analytics está habilitado
  bool get isEnabled => _isEnabled && FirebaseService().isInitialized;

  /// Inicializa o serviço de Analytics
  Future<void> initialize() async {
    if (!FirebaseService().isInitialized) {
      debugPrint('📊 AnalyticsService: Firebase não inicializado, pulando...');
      return;
    }

    try {
      _analytics = FirebaseAnalytics.instance;
      _observer = FirebaseAnalyticsObserver(analytics: _analytics!);
      
      // Habilitar coleta de dados
      await _analytics!.setAnalyticsCollectionEnabled(true);
      
      debugPrint('✅ AnalyticsService: Inicializado com sucesso!');
    } catch (e) {
      debugPrint('❌ AnalyticsService: Erro na inicialização: $e');
      _isEnabled = false;
    }
  }

  /// Habilita ou desabilita a coleta de analytics
  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    if (_analytics != null) {
      await _analytics!.setAnalyticsCollectionEnabled(enabled);
    }
    debugPrint('📊 AnalyticsService: Coleta ${enabled ? "habilitada" : "desabilitada"}');
  }

  /// Define o ID do usuário para associar eventos
  Future<void> setUserId(String userId) async {
    if (!isEnabled || _analytics == null) return;
    
    try {
      await _analytics!.setUserId(id: userId);
      _currentUserId = userId;
      debugPrint('📊 AnalyticsService: UserId definido: $userId');
    } catch (e) {
      debugPrint('❌ AnalyticsService: Erro ao definir userId: $e');
    }
  }

  /// Define uma propriedade do usuário
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    if (!isEnabled || _analytics == null) return;
    
    try {
      await _analytics!.setUserProperty(name: name, value: value);
      debugPrint('📊 AnalyticsService: Propriedade $name = $value');
    } catch (e) {
      debugPrint('❌ AnalyticsService: Erro ao definir propriedade: $e');
    }
  }

  // ============================================
  // EVENTOS DE JOGO
  // ============================================

  /// Registra início de um jogo/quiz
  Future<void> logGameStart({
    required String gameName,
    String? difficulty,
    Map<String, dynamic>? extraParams,
  }) async {
    await _logEvent('game_start', {
      'game_name': gameName,
      if (difficulty != null) 'difficulty': difficulty,
      ...?extraParams,
    });
  }

  /// Registra conclusão de um nível/rodada
  Future<void> logLevelComplete({
    required String gameName,
    required int levelNumber,
    int? score,
    int? timeSeconds,
    bool? success,
    Map<String, dynamic>? extraParams,
  }) async {
    await _logEvent('level_complete', {
      'game_name': gameName,
      'level_number': levelNumber,
      if (score != null) 'score': score,
      if (timeSeconds != null) 'time_seconds': timeSeconds,
      if (success != null) 'success': success,
      ...?extraParams,
    });
  }

  /// Registra fim de jogo
  Future<void> logGameOver({
    required String gameName,
    required String result, // 'win', 'lose', 'draw', 'complete'
    int? finalScore,
    int? totalTimeSeconds,
    Map<String, dynamic>? extraParams,
  }) async {
    await _logEvent('game_over', {
      'game_name': gameName,
      'result': result,
      if (finalScore != null) 'final_score': finalScore,
      if (totalTimeSeconds != null) 'total_time_seconds': totalTimeSeconds,
      ...?extraParams,
    });
  }

  // ============================================
  // EVENTOS DE NAVEGAÇÃO
  // ============================================

  /// Registra visualização de tela
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!isEnabled || _analytics == null) return;
    
    try {
      await _analytics!.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
      debugPrint('📊 AnalyticsService: Screen view - $screenName');
    } catch (e) {
      debugPrint('❌ AnalyticsService: Erro ao registrar screen view: $e');
    }
  }

  // ============================================
  // EVENTOS DE QUIZ
  // ============================================

  /// Registra início de quiz
  Future<void> logQuizStart({
    required String category,
    required String difficulty,
    int? totalQuestions,
  }) async {
    await logGameStart(
      gameName: 'quiz',
      difficulty: difficulty,
      extraParams: {
        'category': category,
        if (totalQuestions != null) 'total_questions': totalQuestions,
      },
    );
  }

  /// Registra resposta de pergunta
  Future<void> logQuizAnswer({
    required int questionNumber,
    required bool isCorrect,
    int? timeToAnswerSeconds,
  }) async {
    await _logEvent('quiz_answer', {
      'question_number': questionNumber,
      'is_correct': isCorrect,
      if (timeToAnswerSeconds != null) 'time_to_answer': timeToAnswerSeconds,
    });
  }

  /// Registra conclusão de quiz
  Future<void> logQuizComplete({
    required String category,
    required String difficulty,
    required int correctAnswers,
    required int totalQuestions,
    required int totalTimeSeconds,
  }) async {
    final accuracy = totalQuestions > 0 
        ? (correctAnswers / totalQuestions * 100).round() 
        : 0;
    
    await logGameOver(
      gameName: 'quiz',
      result: accuracy >= 70 ? 'pass' : 'fail',
      finalScore: correctAnswers,
      totalTimeSeconds: totalTimeSeconds,
      extraParams: {
        'category': category,
        'difficulty': difficulty,
        'total_questions': totalQuestions,
        'accuracy_percent': accuracy,
      },
    );
  }

  // ============================================
  // EVENTOS DE MINIGAMES
  // ============================================

  /// Registra início de minigame
  Future<void> logMinigameStart({
    required String minigameName,
    String? difficulty,
  }) async {
    await logGameStart(
      gameName: minigameName,
      difficulty: difficulty,
    );
  }

  /// Registra conclusão de minigame
  Future<void> logMinigameComplete({
    required String minigameName,
    required bool won,
    int? score,
    int? timeSeconds,
    int? moves,
  }) async {
    await logGameOver(
      gameName: minigameName,
      result: won ? 'win' : 'lose',
      finalScore: score,
      totalTimeSeconds: timeSeconds,
      extraParams: {
        if (moves != null) 'moves': moves,
      },
    );
  }

  // ============================================
  // EVENTOS DE CONQUISTAS
  // ============================================

  /// Registra desbloqueio de conquista
  Future<void> logAchievementUnlocked({
    required String achievementId,
    required String achievementName,
  }) async {
    await _logEvent('achievement_unlocked', {
      'achievement_id': achievementId,
      'achievement_name': achievementName,
    });
  }

  // ============================================
  // EVENTOS DE MULTIPLAYER
  // ============================================

  /// Registra criação de sala multiplayer
  Future<void> logMultiplayerRoomCreated({
    required String roomCode,
    required int maxPlayers,
  }) async {
    await _logEvent('multiplayer_room_created', {
      'room_code': roomCode,
      'max_players': maxPlayers,
    });
  }

  /// Registra entrada em sala multiplayer
  Future<void> logMultiplayerRoomJoined({
    required String roomCode,
  }) async {
    await _logEvent('multiplayer_room_joined', {
      'room_code': roomCode,
    });
  }

  /// Registra fim de partida multiplayer
  Future<void> logMultiplayerGameEnd({
    required String roomCode,
    required int playersCount,
    required int finalPosition,
    required int finalScore,
  }) async {
    await _logEvent('multiplayer_game_end', {
      'room_code': roomCode,
      'players_count': playersCount,
      'final_position': finalPosition,
      'final_score': finalScore,
    });
  }

  // ============================================
  // EVENTOS DE SUPORTE
  // ============================================

  /// Registra abertura do chat de suporte
  Future<void> logSupportChatOpened() async {
    await _logEvent('support_chat_opened', {});
  }

  // ============================================
  // MÉTODO INTERNO
  // ============================================

  /// Registra um evento genérico
  Future<void> _logEvent(String name, Map<String, dynamic> parameters) async {
    if (!isEnabled || _analytics == null) return;
    
    try {
      // Converter todos os valores para tipos suportados
      final cleanParams = <String, Object>{};
      parameters.forEach((key, value) {
        if (value != null) {
          if (value is String || value is int || value is double || value is bool) {
            cleanParams[key] = value;
          } else {
            cleanParams[key] = value.toString();
          }
        }
      });
      
      await _analytics!.logEvent(name: name, parameters: cleanParams);
      debugPrint('📊 AnalyticsService: Evento "$name" registrado');
    } catch (e) {
      debugPrint('❌ AnalyticsService: Erro ao registrar evento "$name": $e');
    }
  }
}
