import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement.dart';

/// Serviço para gerenciar conquistas
class AchievementService {
  static final AchievementService _instance = AchievementService._internal();
  factory AchievementService() => _instance;
  AchievementService._internal();

  // Cache local de conquistas
  List<Achievement> _achievements = [];
  bool _isLoaded = false;

  // Callbacks para notificar quando uma conquista é desbloqueada
  final List<Function(Achievement)> _unlockListeners = [];

  /// Adicionar listener para notificações de desbloqueio
  void addUnlockListener(Function(Achievement) listener) {
    _unlockListeners.add(listener);
  }

  /// Remover listener
  void removeUnlockListener(Function(Achievement) listener) {
    _unlockListeners.remove(listener);
  }

  /// Notificar listeners
  void _notifyUnlock(Achievement achievement) {
    for (var listener in _unlockListeners) {
      listener(achievement);
    }
  }

  /// Carregar conquistas do armazenamento
  Future<List<Achievement>> loadAchievements() async {
    if (_isLoaded && _achievements.isNotEmpty) {
      return _achievements;
    }

    final prefs = await SharedPreferences.getInstance();
    final achievementsJson = prefs.getString('achievements');

    if (achievementsJson != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(achievementsJson);
        final Map<String, dynamic> achievementData = data['achievements'] ?? {};

        // Criar lista de conquistas baseada nos templates
        _achievements = Achievements.all.map((template) {
          if (achievementData.containsKey(template.id)) {
            // Carregar dados salvos
            final saved = achievementData[template.id];
            return template.copyWith(
              isUnlocked: saved['unlocked'] ?? false,
              unlockedAt: saved['unlockedAt'] != null
                  ? DateTime.parse(saved['unlockedAt'])
                  : null,
              currentProgress: saved['progress'] ?? 0,
            );
          }
          return template;
        }).toList();
      } catch (e) {
        print('Erro ao carregar conquistas: $e');
        _achievements = List.from(Achievements.all);
      }
    } else {
      // Primeira vez - usar templates
      _achievements = List.from(Achievements.all);
    }

    _isLoaded = true;
    return _achievements;
  }

  /// Salvar conquistas
  Future<void> saveAchievements() async {
    final prefs = await SharedPreferences.getInstance();

    // Converter para JSON
    final Map<String, dynamic> data = {
      'achievements': {
        for (var achievement in _achievements)
          achievement.id: {
            'unlocked': achievement.isUnlocked,
            'unlockedAt': achievement.unlockedAt?.toIso8601String(),
            'progress': achievement.currentProgress,
          }
      },
    };

    await prefs.setString('achievements', jsonEncode(data));
  }

  /// Obter todas as conquistas
  Future<List<Achievement>> getAchievements() async {
    if (!_isLoaded) {
      await loadAchievements();
    }
    return _achievements;
  }

  /// Obter conquista por ID
  Achievement? getAchievementById(String id) {
    try {
      return _achievements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Atualizar progresso de uma conquista
  Future<List<Achievement>> updateProgress(String achievementId, int progress) async {
    final index = _achievements.indexWhere((a) => a.id == achievementId);
    if (index == -1) return [];

    final achievement = _achievements[index];
    if (achievement.isUnlocked) return []; // Já desbloqueada

    // Atualizar progresso
    final newProgress = progress.clamp(0, achievement.requiredValue);
    _achievements[index] = achievement.copyWith(currentProgress: newProgress);

    // Verificar se desbloqueou
    List<Achievement> newlyUnlocked = [];
    if (newProgress >= achievement.requiredValue) {
      newlyUnlocked = await _unlockAchievement(achievementId);
    }

    await saveAchievements();
    return newlyUnlocked;
  }

  /// Incrementar progresso de uma conquista
  Future<List<Achievement>> incrementProgress(String achievementId, [int amount = 1]) async {
    final achievement = getAchievementById(achievementId);
    if (achievement == null || achievement.isUnlocked) return [];

    final newProgress = achievement.currentProgress + amount;
    return await updateProgress(achievementId, newProgress);
  }

  /// Desbloquear conquista
  Future<List<Achievement>> _unlockAchievement(String achievementId) async {
    final index = _achievements.indexWhere((a) => a.id == achievementId);
    if (index == -1) return [];

    final achievement = _achievements[index];
    if (achievement.isUnlocked) return []; // Já desbloqueada

    // Desbloquear
    _achievements[index] = achievement.copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
      currentProgress: achievement.requiredValue,
    );

    List<Achievement> unlockedList = [_achievements[index]];

    // Notificar listeners
    _notifyUnlock(_achievements[index]);

    // Verificar conquistas master que dependem de outras
    unlockedList.addAll(await _checkMasterAchievements());

    await saveAchievements();
    return unlockedList;
  }

  /// Verificar conquistas master (colecionador e lenda)
  Future<List<Achievement>> _checkMasterAchievements() async {
    List<Achievement> newlyUnlocked = [];

    final unlockedCount = _achievements.where((a) => a.isUnlocked).length;

    // Colecionador - 10 conquistas
    final colecionador = getAchievementById('colecionador');
    if (colecionador != null && !colecionador.isUnlocked && unlockedCount >= 10) {
      final unlocked = await _unlockAchievement('colecionador');
      newlyUnlocked.addAll(unlocked);
    }

    // Lenda - todas as 15 conquistas
    final lenda = getAchievementById('lenda');
    if (lenda != null && !lenda.isUnlocked && unlockedCount >= 15) {
      final unlocked = await _unlockAchievement('lenda');
      newlyUnlocked.addAll(unlocked);
    }

    return newlyUnlocked;
  }

  /// Verificar conquistas relacionadas a quiz
  Future<List<Achievement>> checkQuizAchievements({
    required int totalQuizzes,
    required int correctAnswers,
    required int totalQuestions,
    required int timeInSeconds,
    required int streak,
  }) async {
    await loadAchievements();
    List<Achievement> unlocked = [];

    // Primeiro Passo - completar primeiro quiz
    if (totalQuizzes == 1) {
      unlocked.addAll(await updateProgress('primeiro_passo', 1));
    }

    // Estudioso - 10 quizzes
    unlocked.addAll(await updateProgress('estudioso', totalQuizzes));

    // Perfeccionista - 100% de acertos
    if (correctAnswers == totalQuestions && totalQuestions > 0) {
      unlocked.addAll(await updateProgress('perfeccionista', 1));
    }

    // Velocista - completar em menos de 2 minutos (120 segundos)
    if (timeInSeconds < 120 && totalQuestions >= 10) {
      unlocked.addAll(await updateProgress('velocista', 1));
    }

    // Sequência Perfeita - 5 quizzes seguidos com 80%+
    final accuracy = totalQuestions > 0 ? (correctAnswers / totalQuestions * 100) : 0;
    if (accuracy >= 80) {
      unlocked.addAll(await updateProgress('sequencia_perfeita', streak));
    }

    // Mestre Bíblico - 50 quizzes
    unlocked.addAll(await updateProgress('mestre_biblico', totalQuizzes));

    return unlocked;
  }

  /// Verificar conquistas relacionadas a minigames
  Future<List<Achievement>> checkMinigameAchievements({
    required String gameId,
    required int totalGamesPlayed,
    required bool won,
    required int? timeInSeconds,
  }) async {
    await loadAchievements();
    List<Achievement> unlocked = [];

    // Explorador - jogar todos os 7 minigames (incrementar quando jogar pela primeira vez)
    unlocked.addAll(await incrementProgress('explorador', 1));

    // Mestre dos Puzzles - completar puzzle em menos de 2 minutos
    if (gameId == 'puzzle' && timeInSeconds != null && timeInSeconds < 120 && won) {
      unlocked.addAll(await updateProgress('mestre_puzzles', 1));
    }

    // Memória Fotográfica - memory game sem erros
    if (gameId == 'memory' && won) {
      unlocked.addAll(await updateProgress('memoria_fotografica', 1));
    }

    // Atirador de Elite - 10 vitórias no Jogo da Velha vs IA
    if (gameId == 'tictactoe' && won) {
      unlocked.addAll(await incrementProgress('atirador_elite', 1));
    }

    // Campeão dos Minigames - vencer cada minigame 3 vezes
    if (won) {
      unlocked.addAll(await incrementProgress('campeao_minigames', 1));
    }

    return unlocked;
  }

  /// Verificar conquistas relacionadas a multiplayer
  Future<List<Achievement>> checkMultiplayerAchievements({
    required int totalGamesPlayed,
    required int totalWins,
  }) async {
    await loadAchievements();
    List<Achievement> unlocked = [];

    // Social - participar de uma partida
    if (totalGamesPlayed >= 1) {
      unlocked.addAll(await updateProgress('social', 1));
    }

    // Competidor - ganhar 5 partidas
    unlocked.addAll(await updateProgress('competidor', totalWins));

    return unlocked;
  }

  /// Resetar todas as conquistas (para testes)
  Future<void> resetAchievements() async {
    _achievements = List.from(Achievements.all);
    await saveAchievements();
  }

  /// Obter estatísticas gerais
  Map<String, int> getStats() {
    final unlockedCount = _achievements.where((a) => a.isUnlocked).length;
    final totalCount = _achievements.length;

    return {
      'unlocked': unlockedCount,
      'total': totalCount,
      'percentage': ((unlockedCount / totalCount) * 100).round(),
    };
  }
}
