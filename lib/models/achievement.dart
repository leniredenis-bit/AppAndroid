import 'package:flutter/material.dart';

/// Categorias de conquistas
enum AchievementCategory {
  quiz,      // Relacionado a quizzes
  minigame,  // Relacionado a minigames
  social,    // Multiplayer
  master,    // Conquistas especiais
}

/// Modelo de Conquista
class Achievement {
  final String id;
  final String nameKey;  // Chave para i18n (ex: "achievement_first_step")
  final String descriptionKey;  // Chave para i18n (ex: "achievement_first_step_desc")
  final String emoji;
  final AchievementCategory category;
  final int requiredValue;  // Valor necessário para desbloquear
  bool isUnlocked;
  DateTime? unlockedAt;
  int currentProgress;  // Progresso atual

  Achievement({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.emoji,
    required this.category,
    required this.requiredValue,
    this.isUnlocked = false,
    this.unlockedAt,
    this.currentProgress = 0,
  });

  /// Progresso em percentual (0-100)
  double get progressPercentage {
    if (isUnlocked) return 100.0;
    if (requiredValue == 0) return 0.0;
    return (currentProgress / requiredValue * 100).clamp(0.0, 100.0);
  }

  /// Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKey': nameKey,
      'descriptionKey': descriptionKey,
      'emoji': emoji,
      'category': category.toString(),
      'requiredValue': requiredValue,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'currentProgress': currentProgress,
    };
  }

  /// Criar a partir de JSON
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      nameKey: json['nameKey'],
      descriptionKey: json['descriptionKey'],
      emoji: json['emoji'],
      category: AchievementCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
      ),
      requiredValue: json['requiredValue'],
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null 
          ? DateTime.parse(json['unlockedAt']) 
          : null,
      currentProgress: json['currentProgress'] ?? 0,
    );
  }

  /// Copiar com modificações
  Achievement copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? currentProgress,
  }) {
    return Achievement(
      id: id,
      nameKey: nameKey,
      descriptionKey: descriptionKey,
      emoji: emoji,
      category: category,
      requiredValue: requiredValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      currentProgress: currentProgress ?? this.currentProgress,
    );
  }

  /// Cor da categoria
  Color getCategoryColor() {
    switch (category) {
      case AchievementCategory.quiz:
        return const Color(0xFF4A90E2);  // Azul
      case AchievementCategory.minigame:
        return const Color(0xFF50C878);  // Verde
      case AchievementCategory.social:
        return const Color(0xFF9B59B6);  // Roxo
      case AchievementCategory.master:
        return const Color(0xFFFFD700);  // Dourado
    }
  }

  /// Ícone da categoria
  IconData getCategoryIcon() {
    switch (category) {
      case AchievementCategory.quiz:
        return Icons.quiz;
      case AchievementCategory.minigame:
        return Icons.games;
      case AchievementCategory.social:
        return Icons.people;
      case AchievementCategory.master:
        return Icons.star;
    }
  }
}

/// Todas as conquistas do jogo (15 conquistas)
class Achievements {
  static final List<Achievement> all = [
    // ==================== QUIZ (6 conquistas) ====================
    Achievement(
      id: 'primeiro_passo',
      nameKey: 'achievement_first_step',
      descriptionKey: 'achievement_first_step_desc',
      emoji: '🎓',
      category: AchievementCategory.quiz,
      requiredValue: 1,
    ),
    Achievement(
      id: 'estudioso',
      nameKey: 'achievement_scholar',
      descriptionKey: 'achievement_scholar_desc',
      emoji: '📚',
      category: AchievementCategory.quiz,
      requiredValue: 10,
    ),
    Achievement(
      id: 'perfeccionista',
      nameKey: 'achievement_perfectionist',
      descriptionKey: 'achievement_perfectionist_desc',
      emoji: '🎯',
      category: AchievementCategory.quiz,
      requiredValue: 1,
    ),
    Achievement(
      id: 'velocista',
      nameKey: 'achievement_speedster',
      descriptionKey: 'achievement_speedster_desc',
      emoji: '⚡',
      category: AchievementCategory.quiz,
      requiredValue: 1,
    ),
    Achievement(
      id: 'sequencia_perfeita',
      nameKey: 'achievement_perfect_streak',
      descriptionKey: 'achievement_perfect_streak_desc',
      emoji: '🔥',
      category: AchievementCategory.quiz,
      requiredValue: 5,
    ),
    Achievement(
      id: 'mestre_biblico',
      nameKey: 'achievement_bible_master',
      descriptionKey: 'achievement_bible_master_desc',
      emoji: '👑',
      category: AchievementCategory.quiz,
      requiredValue: 50,
    ),

    // ==================== MINIGAMES (5 conquistas) ====================
    Achievement(
      id: 'explorador',
      nameKey: 'achievement_explorer',
      descriptionKey: 'achievement_explorer_desc',
      emoji: '🎮',
      category: AchievementCategory.minigame,
      requiredValue: 7,  // Jogar todos os 7 minigames
    ),
    Achievement(
      id: 'mestre_puzzles',
      nameKey: 'achievement_puzzle_master',
      descriptionKey: 'achievement_puzzle_master_desc',
      emoji: '🧩',
      category: AchievementCategory.minigame,
      requiredValue: 1,
    ),
    Achievement(
      id: 'memoria_fotografica',
      nameKey: 'achievement_photographic_memory',
      descriptionKey: 'achievement_photographic_memory_desc',
      emoji: '🧠',
      category: AchievementCategory.minigame,
      requiredValue: 1,
    ),
    Achievement(
      id: 'atirador_elite',
      nameKey: 'achievement_sharpshooter',
      descriptionKey: 'achievement_sharpshooter_desc',
      emoji: '🎯',
      category: AchievementCategory.minigame,
      requiredValue: 10,
    ),
    Achievement(
      id: 'campeao_minigames',
      nameKey: 'achievement_minigame_champion',
      descriptionKey: 'achievement_minigame_champion_desc',
      emoji: '🌟',
      category: AchievementCategory.minigame,
      requiredValue: 21,  // Vencer cada minigame 3 vezes (7 x 3)
    ),

    // ==================== SOCIAL (2 conquistas) ====================
    Achievement(
      id: 'social',
      nameKey: 'achievement_social',
      descriptionKey: 'achievement_social_desc',
      emoji: '🌐',
      category: AchievementCategory.social,
      requiredValue: 1,
    ),
    Achievement(
      id: 'competidor',
      nameKey: 'achievement_competitor',
      descriptionKey: 'achievement_competitor_desc',
      emoji: '🏆',
      category: AchievementCategory.social,
      requiredValue: 5,
    ),

    // ==================== MASTER (2 conquistas) ====================
    Achievement(
      id: 'colecionador',
      nameKey: 'achievement_collector',
      descriptionKey: 'achievement_collector_desc',
      emoji: '💎',
      category: AchievementCategory.master,
      requiredValue: 10,
    ),
    Achievement(
      id: 'lenda',
      nameKey: 'achievement_legend',
      descriptionKey: 'achievement_legend_desc',
      emoji: '👑',
      category: AchievementCategory.master,
      requiredValue: 15,  // Todas as conquistas
    ),
  ];

  /// Obter conquista por ID
  static Achievement? getById(String id) {
    try {
      return all.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obter conquistas por categoria
  static List<Achievement> getByCategory(AchievementCategory category) {
    return all.where((a) => a.category == category).toList();
  }

  /// Obter conquistas desbloqueadas
  static List<Achievement> getUnlocked(List<Achievement> achievements) {
    return achievements.where((a) => a.isUnlocked).toList();
  }

  /// Obter conquistas bloqueadas
  static List<Achievement> getLocked(List<Achievement> achievements) {
    return achievements.where((a) => !a.isUnlocked).toList();
  }
}
