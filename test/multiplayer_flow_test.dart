import 'package:flutter_test/flutter_test.dart';
import 'package:jw_splash_games/models/multiplayer/room.dart';
import 'package:jw_splash_games/services/multiplayer/firebase_multiplayer_service.dart';

/// Sem Firebase inicializado o serviço usa o mock local, o que permite
/// validar o fluxo de status de uma partida completa.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('partida completa: rodada fecha quando todos respondem', () async {
    final service = FirebaseMultiplayerService();

    final room = await service.createRoom(
      hostId: 'host',
      hostNickname: 'Anfitriao',
      totalQuestions: 2,
    );
    expect(room.id, matches(RegExp(r'^\d{6}$')));
    expect(room.questionIds, hasLength(2));

    await service.joinRoom(roomCode: room.id, playerId: 'p2', nickname: 'Jogador');

    await service.startGame(room.id);
    await Future.delayed(const Duration(milliseconds: 3200));
    expect((await service.getRoom(room.id))!.status, RoomStatus.playing);

    await service.submitAnswer(roomCode: room.id, playerId: 'host', answerIndex: 0, isCorrect: true, points: 10);
    expect((await service.getRoom(room.id))!.status, RoomStatus.playing);

    await service.submitAnswer(roomCode: room.id, playerId: 'p2', answerIndex: 1, isCorrect: false, points: 0);
    final afterRound = (await service.getRoom(room.id))!;
    expect(afterRound.status, RoomStatus.roundEnd);
    expect(afterRound.players['host']!.score, 10);

    await service.nextQuestion(room.id);
    final round2 = (await service.getRoom(room.id))!;
    expect(round2.status, RoomStatus.playing);
    expect(round2.currentQuestionIndex, 1);
    expect(round2.players.values.every((p) => !p.hasAnswered), isTrue);

    await service.nextQuestion(room.id);
    expect((await service.getRoom(room.id))!.status, RoomStatus.finished);

    final restarted = await service.restartGame(room.id);
    expect(restarted.status, RoomStatus.waiting);
    expect(restarted.players['host']!.score, 0);

    await service.closeRoom(room.id);
    expect(await service.getRoom(room.id), isNull);
  });

  test('endRound do anfitrião fecha a rodada mesmo sem todas as respostas', () async {
    final service = FirebaseMultiplayerService();
    final room = await service.createRoom(hostId: 'h', hostNickname: 'H', totalQuestions: 1);
    await service.joinRoom(roomCode: room.id, playerId: 'ausente', nickname: 'Ausente');
    await service.startGame(room.id);
    await Future.delayed(const Duration(milliseconds: 3200));

    await service.submitAnswer(roomCode: room.id, playerId: 'h', answerIndex: 0, isCorrect: true, points: 10);
    await service.endRound(room.id);
    expect((await service.getRoom(room.id))!.status, RoomStatus.roundEnd);
  });
}
