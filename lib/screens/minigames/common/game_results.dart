import 'package:flutter/material.dart';
import '../../../services/achievement_service.dart';
import '../../../services/storage_service.dart';
import '../../../widgets/achievement_unlock_dialog.dart';

/// Resultado salvo de uma partida.
class RecordedResult {
  final bool newRecord;
  final int bestScore;
  final int? bestTime;
  const RecordedResult({required this.newRecord, required this.bestScore, this.bestTime});
}

/// Salva o resultado de um minigame, verifica conquistas e mostra as
/// conquistas desbloqueadas. Chame antes de [showGameResult].
///
/// [seconds] só é gravado como "melhor tempo" quando [won] é verdadeiro.
/// [perfect] indica partida sem erros (usado por algumas conquistas).
Future<RecordedResult> recordGameResult(
  BuildContext context, {
  required String gameId,
  required bool won,
  int score = 0,
  int? seconds,
  bool perfect = false,
}) async {
  final storage = StorageService();
  final before = (await storage.getMinigameRecords()).getRecord(gameId);

  await storage.saveMinigameRecord(
    gameId,
    score: score,
    won: won,
    timeInSeconds: won ? seconds : null,
  );

  final after = (await storage.getMinigameRecords()).getRecord(gameId);
  final unlocked = await AchievementService().checkMinigameAchievements(
    gameId: gameId,
    totalGamesPlayed: after.gamesPlayed,
    won: won,
    timeInSeconds: seconds,
    perfect: perfect,
  );

  if (context.mounted) {
    for (final achievement in unlocked) {
      if (!context.mounted) break;
      await AchievementUnlockDialog.show(context, achievement);
    }
  }

  return RecordedResult(
    newRecord: won && before.gamesPlayed > 0 && score > before.highScore,
    bestScore: after.highScore,
    bestTime: after.bestTime,
  );
}
