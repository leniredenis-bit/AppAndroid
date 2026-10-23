import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../../models/multiplayer/room.dart';
import '../../models/multiplayer/player.dart';
import '../../models/quiz_service.dart';
import '../auth_service.dart';
import '../firebase_service.dart';
import 'mock_multiplayer_service.dart';

/// Serviço multiplayer online (Firebase Realtime Database).
///
/// Estrutura no banco: /rooms/{codigo} -> Room.toMap()
/// Regras de segurança: database.rules.json (raiz do projeto).
///
/// Quando o Firebase não está disponível (ex.: web), delega para o
/// [MockMultiplayerService], que funciona apenas localmente.
class FirebaseMultiplayerService {
  static final FirebaseMultiplayerService _instance = FirebaseMultiplayerService._internal();
  factory FirebaseMultiplayerService() => _instance;
  FirebaseMultiplayerService._internal();

  final AuthService _authService = AuthService();

  bool get _online => FirebaseService().isInitialized;

  DatabaseReference _roomRef(String roomCode) =>
      FirebaseDatabase.instance.ref('rooms/$roomCode');

  static String _status(RoomStatus status) => status.toString().split('.').last;

  /// Converte recursivamente o Map do Firebase (`Map<Object?, Object?>`)
  /// para o formato esperado pelos modelos (`Map<String, dynamic>`).
  static dynamic _normalize(dynamic value) {
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), _normalize(v)));
    }
    if (value is List) {
      return value.map(_normalize).toList();
    }
    return value;
  }

  static Room _roomFromSnapshot(DataSnapshot snapshot) {
    return Room.fromMap(Map<String, dynamic>.from(_normalize(snapshot.value) as Map));
  }

  Future<Room> _readRoom(String roomCode) async {
    final snapshot = await _roomRef(roomCode).get();
    if (!snapshot.exists) throw Exception('Sala não encontrada. Verifique o código.');
    return _roomFromSnapshot(snapshot);
  }

  Future<String> _generateRoomCode() async {
    final random = Random.secure();
    for (var attempt = 0; attempt < 10; attempt++) {
      final code = (random.nextInt(900000) + 100000).toString();
      final exists = (await _roomRef(code).get()).exists;
      if (!exists) return code;
    }
    throw Exception('Não foi possível gerar um código de sala. Tente novamente.');
  }

  Future<List<String>> _pickQuestionIds(int total) async {
    final allQuestions = await QuizService.loadQuestions();
    return QuizService.getRandomQuestions(allQuestions, total)
        .map((q) => q.id.toString())
        .toList();
  }

  /// ID do jogador atual (login anônimo no Firebase ou ID local no mock)
  Future<String> currentPlayerId() => _authService.ensureSignedIn();

  /// Cria uma nova sala de jogo
  Future<Room> createRoom({
    required String hostId,
    required String hostNickname,
    int totalQuestions = 10,
    int roundTimeLimit = 15,
    int maxPlayers = 100,
  }) async {
    if (!_online) {
      return MockMultiplayerService.createRoom(
        hostId: hostId,
        hostNickname: hostNickname,
        totalQuestions: totalQuestions,
        roundTimeLimit: roundTimeLimit,
        maxPlayers: maxPlayers,
      );
    }

    final roomCode = await _generateRoomCode();
    final room = Room(
      id: roomCode,
      hostId: hostId,
      players: {
        hostId: Player(id: hostId, nickname: hostNickname, isHost: true, avatar: '👑'),
      },
      totalQuestions: totalQuestions,
      questionIds: await _pickQuestionIds(totalQuestions),
      roundTimeLimit: roundTimeLimit,
      maxPlayers: maxPlayers,
    );

    await _roomRef(roomCode).set(room.toMap());
    debugPrint('FirebaseMultiplayerService: sala criada $roomCode');
    return room;
  }

  /// Entra em uma sala existente
  Future<Room> joinRoom({
    required String roomCode,
    required String playerId,
    required String nickname,
  }) async {
    if (!_online) {
      return MockMultiplayerService.joinRoom(
        roomCode: roomCode,
        playerId: playerId,
        nickname: nickname,
      );
    }

    final room = await _readRoom(roomCode);
    if (room.status != RoomStatus.waiting) throw Exception('Esta sala já está em andamento.');
    if (room.isFull) throw Exception('Esta sala está cheia.');
    if (room.players.containsKey(playerId)) return room;

    const avatars = ['😊', '🙂', '😄', '🤗', '😇', '🤓', '😎', '🥳'];
    final player = Player(
      id: playerId,
      nickname: nickname,
      avatar: avatars[Random().nextInt(avatars.length)],
    );

    await _roomRef(roomCode).child('players/$playerId').set(player.toMap());
    await _roomRef(roomCode).child('lastActivity').set(DateTime.now().toIso8601String());
    return _readRoom(roomCode);
  }

  /// Marca jogador como pronto
  Future<void> setPlayerReady(String roomCode, bool isReady) async {
    final userId = _authService.userId;
    if (!_online || userId == null) return;
    await _roomRef(roomCode).child('players/$userId/isReady').set(isReady);
  }

  /// Inicia o jogo (apenas host)
  Future<Room> startGame(String roomCode) async {
    if (!_online) return MockMultiplayerService.startGame(roomCode);

    final room = await _readRoom(roomCode);
    if (room.players.length < 2) {
      throw Exception('É necessário pelo menos 2 jogadores para iniciar');
    }

    final ref = _roomRef(roomCode);
    await ref.update({
      'status': _status(RoomStatus.starting),
      'lastActivity': DateTime.now().toIso8601String(),
    });

    // Contagem regressiva de 3s antes de começar
    Future.delayed(const Duration(seconds: 3), () => _startRound(ref, room, 0));

    return room.copyWith(status: RoomStatus.starting);
  }

  /// Coloca a sala em "playing" na pergunta [index], zerando as respostas
  Future<void> _startRound(DatabaseReference ref, Room room, int index) async {
    final now = DateTime.now().toIso8601String();
    final updates = <String, dynamic>{
      'status': _status(RoomStatus.playing),
      'currentQuestionIndex': index,
      'roundStartTime': now,
      'lastActivity': now,
    };
    for (final id in room.players.keys) {
      updates['players/$id/hasAnswered'] = false;
      updates['players/$id/lastAnswer'] = null;
      updates['players/$id/lastAnswerCorrect'] = false;
    }
    await ref.update(updates);
  }

  /// Registra resposta do jogador. Quando todos responderem, a sala vai
  /// para "roundEnd" e as telas mostram o resultado da rodada.
  Future<void> submitAnswer({
    required String roomCode,
    required String playerId,
    int? questionIndex,
    int? selectedAnswer,
    int? answerIndex,
    required bool isCorrect,
    int? responseTimeMs,
    int? points,
  }) async {
    final finalPoints = points ?? (isCorrect ? (100 + ((responseTimeMs != null) ? (15000 - responseTimeMs) ~/ 100 : 50)).clamp(100, 200) : 0);
    final finalAnswerIndex = answerIndex ?? selectedAnswer ?? -1;

    if (!_online) {
      await MockMultiplayerService.submitAnswer(
        roomCode: roomCode,
        playerId: playerId,
        answerIndex: finalAnswerIndex,
        isCorrect: isCorrect,
        points: finalPoints,
      );
      return;
    }

    final ref = _roomRef(roomCode);
    final playerRef = ref.child('players/$playerId');
    final scoreSnapshot = await playerRef.child('score').get();
    final currentScore = (scoreSnapshot.value as num?)?.toInt() ?? 0;

    await playerRef.update({
      'hasAnswered': true,
      'lastAnswer': finalAnswerIndex,
      'lastAnswerCorrect': isCorrect,
      'score': currentScore + (isCorrect ? finalPoints : 0),
      'lastActivity': DateTime.now().toIso8601String(),
    });

    await _endRoundIfEveryoneAnswered(roomCode);
  }

  Future<void> _endRoundIfEveryoneAnswered(String roomCode) async {
    final room = await _readRoom(roomCode);
    if (room.status == RoomStatus.playing && room.allPlayersAnswered) {
      await endRound(roomCode);
    }
  }

  /// Encerra a rodada atual (também usado pelo host quando o tempo
  /// acaba e algum jogador desconectado não respondeu).
  Future<void> endRound(String roomCode) async {
    if (!_online) {
      await MockMultiplayerService.endRound(roomCode);
      return;
    }
    await _roomRef(roomCode).update({
      'status': _status(RoomStatus.roundEnd),
      'lastActivity': DateTime.now().toIso8601String(),
    });
  }

  /// Avança para próxima pergunta (apenas host)
  Future<void> nextQuestion(String roomCode) async {
    if (!_online) {
      await MockMultiplayerService.nextQuestion(roomCode);
      return;
    }

    final room = await _readRoom(roomCode);
    final ref = _roomRef(roomCode);
    final nextIndex = room.currentQuestionIndex + 1;

    if (nextIndex >= room.questionIds.length) {
      await ref.update({
        'status': _status(RoomStatus.finished),
        'lastActivity': DateTime.now().toIso8601String(),
      });
      return;
    }
    await _startRound(ref, room, nextIndex);
  }

  /// Stream da sala em tempo real. Se a sala for apagada, emite uma
  /// sala com status "closed" para as telas exibirem o aviso.
  Stream<Room> roomStream(String roomCode) {
    if (!_online) return MockMultiplayerService.roomStream(roomCode);

    return _roomRef(roomCode).onValue.map((event) {
      if (!event.snapshot.exists) {
        return Room(id: roomCode, hostId: '', status: RoomStatus.closed);
      }
      return _roomFromSnapshot(event.snapshot);
    });
  }

  /// Alias para roomStream
  Stream<Room> watchRoom(String roomCode) => roomStream(roomCode);

  /// Obtém a sala atual
  Future<Room?> getRoom(String roomCode) async {
    if (!_online) return MockMultiplayerService.getRoom(roomCode);
    final snapshot = await _roomRef(roomCode).get();
    return snapshot.exists ? _roomFromSnapshot(snapshot) : null;
  }

  /// Remove um jogador da sala. Se o host sair, a sala é encerrada.
  Future<Room?> removePlayer({
    required String roomCode,
    required String playerId,
  }) async {
    if (!_online) {
      return MockMultiplayerService.removePlayer(roomCode: roomCode, playerId: playerId);
    }

    final room = await getRoom(roomCode);
    if (room == null) return null;

    if (playerId == room.hostId) {
      await closeRoom(roomCode);
      return null;
    }

    await _roomRef(roomCode).child('players/$playerId').remove();
    return getRoom(roomCode);
  }

  /// Sai da sala
  Future<void> leaveRoom(String roomCode) async {
    final playerId = _authService.userId;
    if (playerId == null) return;
    await removePlayer(roomCode: roomCode, playerId: playerId);
  }

  /// Fecha a sala (apenas host): avisa os jogadores e apaga os dados
  Future<void> closeRoom(String roomCode) async {
    if (!_online) {
      await MockMultiplayerService.closeRoom(roomCode);
      return;
    }

    final ref = _roomRef(roomCode);
    await ref.child('status').set(_status(RoomStatus.closed));
    // Dá tempo dos outros jogadores receberem o aviso antes de apagar
    Future.delayed(const Duration(seconds: 5), () => ref.remove());
  }

  /// Reinicia o jogo (mesmos jogadores, novas perguntas)
  Future<Room> restartGame(String roomCode) async {
    if (!_online) return MockMultiplayerService.restartGame(roomCode);

    final room = await _readRoom(roomCode);
    final updates = <String, dynamic>{
      'status': _status(RoomStatus.waiting),
      'currentQuestionIndex': 0,
      'questionIds': await _pickQuestionIds(room.totalQuestions),
      'roundStartTime': null,
      'lastActivity': DateTime.now().toIso8601String(),
    };
    for (final id in room.players.keys) {
      updates['players/$id/score'] = 0;
      updates['players/$id/hasAnswered'] = false;
      updates['players/$id/lastAnswer'] = null;
      updates['players/$id/lastAnswerCorrect'] = false;
    }
    await _roomRef(roomCode).update(updates);
    return _readRoom(roomCode);
  }

  /// Finaliza o jogo
  Future<void> finishGame(String roomCode) => closeRoom(roomCode);
}
