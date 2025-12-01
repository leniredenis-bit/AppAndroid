import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../../models/multiplayer/room.dart';
import '../../models/multiplayer/player.dart';
import '../../models/quiz_service.dart';
import '../auth_service.dart';

class FirebaseMultiplayerService {
  static final FirebaseMultiplayerService _instance = FirebaseMultiplayerService._internal();
  factory FirebaseMultiplayerService() => _instance;
  FirebaseMultiplayerService._internal();

  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final AuthService _authService = AuthService();

  /// Cria uma nova sala de jogo
  Future<Room> createRoom({
    required String hostId,
    required String hostNickname,
    int totalQuestions = 10,
    int roundTimeLimit = 15,
    int maxPlayers = 100,
  }) async {
    try {
      // Gerar código da sala (6 caracteres)
      final roomCode = _generateRoomCode();

      // Criar objeto da sala
      final room = Room(
        id: roomCode,
        hostId: hostId,
        players: {
          hostId: Player(
            id: hostId,
            nickname: hostNickname,
            isHost: true,
            avatar: '👑',
          ),
        },
        maxPlayers: maxPlayers,
        totalQuestions: totalQuestions,
        roundTimeLimit: roundTimeLimit,
        status: RoomStatus.waiting,
        currentQuestionIndex: 0,
        questionIds: [],
      );

      // Salvar sala no Firebase
      await _database.child('rooms').child(roomCode).set(room.toMap());

      debugPrint('FirebaseMultiplayerService: Sala criada: $roomCode');
      return room;
    } catch (e) {
      debugPrint('FirebaseMultiplayerService: Erro ao criar sala: $e');
      rethrow;
    }
  }

  /// Entra em uma sala existente
  Future<Room> joinRoom({
    required String roomCode,
    required String playerId,
    required String nickname,
  }) async {
    try {
      final roomRef = _database.child('rooms').child(roomCode);
      final snapshot = await roomRef.get();

      if (!snapshot.exists) {
        throw Exception('Sala não encontrada');
      }

      final roomData = Map<String, dynamic>.from(snapshot.value as Map);
      final room = Room.fromMap(roomData);

      // Verificar se a sala está cheia
      if (room.isFull) {
        throw Exception('Sala cheia');
      }

      // Verificar se jogador já está na sala
      if (room.players.containsKey(playerId)) {
        throw Exception('Você já está nesta sala');
      }

      // Verificar se já começou
      if (room.status != RoomStatus.waiting) {
        throw Exception('Esta sala já está em andamento');
      }

      // Selecionar avatar aleatório
      final avatars = ['😊', '🙂', '😄', '🤗', '😇', '🤓', '😎', '🥳'];
      final randomIndex = DateTime.now().millisecondsSinceEpoch % avatars.length;
      final avatar = avatars[randomIndex];

      // Adicionar jogador à sala
      final newPlayer = Player(
        id: playerId,
        nickname: nickname,
        isHost: false,
        avatar: avatar,
      );

      await roomRef.child('players').child(playerId).set(newPlayer.toMap());
      await roomRef.child('lastActivity').set(DateTime.now().toIso8601String());

      debugPrint('FirebaseMultiplayerService: Entrou na sala: $roomCode');

      // Retornar sala atualizada
      final updatedSnapshot = await roomRef.get();
      final updatedData = Map<String, dynamic>.from(updatedSnapshot.value as Map);
      return Room.fromMap(updatedData);
    } catch (e) {
      debugPrint('FirebaseMultiplayerService: Erro ao entrar na sala: $e');
      rethrow;
    }
  }

  /// Marca jogador como pronto
  Future<void> setPlayerReady(String roomCode, bool isReady) async {
    try {
      final userId = _authService.userId;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      await _database
          .child('rooms')
          .child(roomCode)
          .child('players')
          .child(userId)
          .child('isReady')
          .set(isReady);

      debugPrint('FirebaseMultiplayerService: Jogador $userId pronto: $isReady');
    } catch (e) {
      debugPrint('FirebaseMultiplayerService: Erro ao marcar como pronto: $e');
      rethrow;
    }
  }

  /// Inicia o jogo (apenas host)
  Future<Room> startGame(String roomCode) async {
    try {
      final userId = _authService.userId;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final roomRef = _database.child('rooms').child(roomCode);
      final snapshot = await roomRef.get();

      if (!snapshot.exists) {
        throw Exception('Sala não encontrada');
      }

      final roomData = Map<String, dynamic>.from(snapshot.value as Map);
      final room = Room.fromMap(roomData);

      // Verificar se é o host
      if (room.hostId != userId) {
        throw Exception('Apenas o host pode iniciar o jogo');
      }

      // Verificar se há jogadores suficientes
      if (room.players.length < 2) {
        throw Exception('É necessário pelo menos 2 jogadores para iniciar');
      }

      // Buscar perguntas (se ainda não tiver)
      if (room.questionIds.isEmpty) {
        final allQuestions = await QuizService.loadQuestions();
        final questions = QuizService.getRandomQuestions(
          allQuestions, 
          room.totalQuestions,
        );
        final questionIds = questions.map((q) => q.id).toList();
        
        await roomRef.update({
          'questionIds': questionIds,
        });
      }

      // Atualizar sala para status "starting"
      await roomRef.update({
        'status': RoomStatus.starting.toString().split('.').last,
        'currentQuestionIndex': 0,
        'lastActivity': DateTime.now().toIso8601String(),
      });

      // Aguardar 3 segundos e mudar para "playing"
      Future.delayed(Duration(seconds: 3), () async {
        await roomRef.update({
          'status': RoomStatus.playing.toString().split('.').last,
          'roundStartTime': DateTime.now().toIso8601String(),
        });
      });

      // Retornar sala atualizada
      final updatedSnapshot = await roomRef.get();
      final updatedData = Map<String, dynamic>.from(updatedSnapshot.value as Map);
      return Room.fromMap(updatedData);
    } catch (e) {
      debugPrint('FirebaseMultiplayerService: Erro ao iniciar jogo: $e');
      rethrow;
    }
  }

  /// Submete resposta do jogador
  Future<Room> submitAnswer({
    required String roomCode,
    required String playerId,
    required int answerIndex,
    required bool isCorrect,
    required int points,
  }) async {
    try {
      final roomRef = _database.child('rooms').child(roomCode);
      final playerRef = roomRef.child('players').child(playerId);

      // Atualizar informações do jogador
      final playerSnapshot = await playerRef.get();
      if (!playerSnapshot.exists) {
        throw Exception('Jogador não encontrado na sala');
      }

      final playerData = Map<String, dynamic>.from(playerSnapshot.value as Map);
      final player = Player.fromMap(playerData);

      // Calcular nova pontuação
      final newScore = player.score + (isCorrect ? points : 0);

      await playerRef.update({
        'hasAnswered': true,
        'lastAnswer': answerIndex,
        'lastAnswerCorrect': isCorrect,
        'score': newScore,
        'lastActivity': DateTime.now().toIso8601String(),
      });

      debugPrint('FirebaseMultiplayerService: Resposta submetida pelo jogador $playerId');

      // Retornar sala atualizada
      final roomSnapshot = await roomRef.get();
      final roomData = Map<String, dynamic>.from(roomSnapshot.value as Map);
      return Room.fromMap(roomData);
    } catch (e) {
      debugPrint('FirebaseMultiplayerService: Erro ao submeter resposta: $e');
      rethrow;
    }
  }

  /// Avança para a próxima pergunta (apenas host)
  Future<Room> nextQuestion(String roomCode) async {
    try {
      final userId = _authService.userId;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final roomRef = _database.child('rooms').child(roomCode);
      final snapshot = await roomRef.get();

      if (!snapshot.exists) {
        throw Exception('Sala não encontrada');
      }

      final roomData = Map<String, dynamic>.from(snapshot.value as Map);
      final room = Room.fromMap(roomData);

      // Verificar se é o host
      if (room.hostId != userId) {
        throw Exception('Apenas o host pode avançar as perguntas');
      }

      final nextIndex = room.currentQuestionIndex + 1;

      // Resetar estado dos jogadores
      final updates = <String, dynamic>{};
      for (final player in room.players.values) {
        updates['players/${player.id}/hasAnswered'] = false;
        updates['players/${player.id}/lastAnswer'] = null;
        updates['players/${player.id}/lastAnswerCorrect'] = false;
      }

      // Verificar se acabou o quiz
      if (nextIndex >= room.questionIds.length) {
        updates['status'] = RoomStatus.finished.toString().split('.').last;
        updates['lastActivity'] = DateTime.now().toIso8601String();
        debugPrint('FirebaseMultiplayerService: Quiz finalizado');
      } else {
        updates['currentQuestionIndex'] = nextIndex;
        updates['status'] = RoomStatus.playing.toString().split('.').last;
        updates['roundStartTime'] = DateTime.now().toIso8601String();
        updates['lastActivity'] = DateTime.now().toIso8601String();
        debugPrint('FirebaseMultiplayerService: Próxima pergunta: $nextIndex');
      }

      await roomRef.update(updates);

      // Retornar sala atualizada
      final updatedSnapshot = await roomRef.get();
      final updatedData = Map<String, dynamic>.from(updatedSnapshot.value as Map);
      return Room.fromMap(updatedData);
    } catch (e) {
      debugPrint('FirebaseMultiplayerService: Erro ao avançar pergunta: $e');
      rethrow;
    }
  }

  /// Escuta mudanças na sala em tempo real
  Stream<Room> watchRoom(String roomCode) {
    return _database.child('rooms').child(roomCode).onValue.map((event) {
      if (!event.snapshot.exists) {
        throw Exception('Sala não existe mais');
      }
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return Room.fromMap(data);
    });
  }

  /// Alias para watchRoom (compatibilidade com MockMultiplayerService)
  Stream<Room> roomStream(String roomCode) => watchRoom(roomCode);

  /// Obtém sala de forma síncrona (apenas cache local)
  /// NOTA: No Firebase, preferir usar watchRoom() para dados em tempo real
  Room? getRoom(String roomCode) {
    // Firebase não oferece acesso síncrono, retorna null
    // As telas devem usar Stream<Room> via watchRoom()
    debugPrint('FirebaseMultiplayerService: getRoom() não disponível, use watchRoom()');
    return null;
  }

  /// Remove jogador da sala (alias para leaveRoom para compatibilidade)
  Future<Room?> removePlayer({
    required String roomCode,
    required String playerId,
  }) async {
    try {
      await leaveRoom(roomCode);
      
      // Retornar sala atualizada via snapshot
      final snapshot = await _database.child('rooms').child(roomCode).get();
      if (!snapshot.exists) return null;
      
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return Room.fromMap(data);
    } catch (e) {
      debugPrint('FirebaseMultiplayerService: Erro em removePlayer: $e');
      return null;
    }
  }

  /// Fecha a sala (alias para deleteRoom para compatibilidade)
  Future<Room?> closeRoom(String roomCode) async {
    try {
      await deleteRoom(roomCode);
      return null; // Sala deletada
    } catch (e) {
      debugPrint('FirebaseMultiplayerService: Erro em closeRoom: $e');
      return null;
    }
  }

  /// Reinicia o jogo (mantém jogadores, reseta perguntas e pontuação)
  Future<Room> restartGame(String roomCode) async {
    try {
      final userId = _authService.userId;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final roomRef = _database.child('rooms').child(roomCode);
      final snapshot = await roomRef.get();

      if (!snapshot.exists) {
        throw Exception('Sala não encontrada');
      }

      final roomData = Map<String, dynamic>.from(snapshot.value as Map);
      final room = Room.fromMap(roomData);

      // Verificar se é o host
      if (room.hostId != userId) {
        throw Exception('Apenas o host pode reiniciar o jogo');
      }

      // Resetar jogadores
      final updates = <String, dynamic>{};
      for (final player in room.players.values) {
        updates['players/${player.id}/score'] = 0;
        updates['players/${player.id}/hasAnswered'] = false;
        updates['players/${player.id}/lastAnswer'] = null;
        updates['players/${player.id}/lastAnswerCorrect'] = false;
        updates['players/${player.id}/isReady'] = player.isHost; // Host pronto, outros não
      }

      // Resetar estado da sala
      updates['status'] = RoomStatus.waiting.toString().split('.').last;
      updates['currentQuestionIndex'] = 0;
      updates['roundStartTime'] = null;

      await roomRef.update(updates);

      // Retornar sala atualizada
      final updatedSnapshot = await roomRef.get();
      final updatedData = Map<String, dynamic>.from(updatedSnapshot.value as Map);
      return Room.fromMap(updatedData);
    } catch (e) {
      debugPrint('FirebaseMultiplayerService: Erro ao reiniciar jogo: $e');
      rethrow;
    }
  }

  /// Remove sala (apenas host)
  Future<void> deleteRoom(String roomCode) async {
    try {
      final userId = _authService.userId;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final roomRef = _database.child('rooms').child(roomCode);
      final snapshot = await roomRef.get();

      if (!snapshot.exists) {
        return; // Sala já não existe
      }

      final roomData = Map<String, dynamic>.from(snapshot.value as Map);
      final room = Room.fromMap(roomData);

      // Verificar se é o host
      if (room.hostId != userId) {
        throw Exception('Apenas o host pode deletar a sala');
      }

      await roomRef.remove();
      debugPrint('FirebaseMultiplayerService: Sala deletada: $roomCode');
    } catch (e) {
      debugPrint('FirebaseMultiplayerService: Erro ao deletar sala: $e');
      rethrow;
    }
  }

  /// Sai da sala
  Future<void> leaveRoom(String roomCode) async {
    try {
      final userId = _authService.userId;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final roomRef = _database.child('rooms').child(roomCode);
      final snapshot = await roomRef.get();

      if (!snapshot.exists) {
        return; // Sala já não existe
      }

      final roomData = Map<String, dynamic>.from(snapshot.value as Map);
      final room = Room.fromMap(roomData);

      // Se for o host, deletar a sala
      if (room.hostId == userId) {
        await deleteRoom(roomCode);
      } else {
        // Remover jogador da sala
        await roomRef.child('players').child(userId).remove();
        debugPrint('FirebaseMultiplayerService: Saiu da sala: $roomCode');
      }
    } catch (e) {
      debugPrint('FirebaseMultiplayerService: Erro ao sair da sala: $e');
      rethrow;
    }
  }

  /// Gera código aleatório de 6 caracteres para a sala
  String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    var code = '';
    
    for (var i = 0; i < 6; i++) {
      code += chars[(timestamp + i * 7) % chars.length];
    }
    
    return code;
  }
}
