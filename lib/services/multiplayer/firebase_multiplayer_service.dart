// ============================================================
// VERSÃO MOCK TEMPORÁRIA - Firebase desabilitado para teste web
// Ver docs/FIREBASE_BACKUP.md para código original
// Arquivo original salvo em: firebase_multiplayer_service.dart.bak
// ============================================================

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../models/multiplayer/room.dart';
import 'mock_multiplayer_service.dart';
import '../auth_service.dart';

/// Wrapper que redireciona para MockMultiplayerService durante testes web
class FirebaseMultiplayerService {
  static final FirebaseMultiplayerService _instance = FirebaseMultiplayerService._internal();
  factory FirebaseMultiplayerService() => _instance;
  FirebaseMultiplayerService._internal() {
    debugPrint('FirebaseMultiplayerService: Usando MockMultiplayerService para testes');
  }

  final AuthService _authService = AuthService();

  /// Cria uma nova sala de jogo
  Future<Room> createRoom({
    required String hostId,
    required String hostNickname,
    int totalQuestions = 10,
    int roundTimeLimit = 15,
    int maxPlayers = 100,
  }) async {
    return MockMultiplayerService.createRoom(
      hostId: hostId,
      hostNickname: hostNickname,
      totalQuestions: totalQuestions,
      roundTimeLimit: roundTimeLimit,
      maxPlayers: maxPlayers,
    );
  }

  /// Entra em uma sala existente
  Future<Room> joinRoom({
    required String roomCode,
    required String playerId,
    required String nickname,
  }) async {
    return MockMultiplayerService.joinRoom(
      roomCode: roomCode,
      playerId: playerId,
      nickname: nickname,
    );
  }

  /// Marca jogador como pronto
  Future<void> setPlayerReady(String roomCode, bool isReady) async {
    // Mock não tem essa função, apenas ignora
    debugPrint('setPlayerReady: $roomCode -> $isReady (mock)');
  }

  /// Inicia o jogo (apenas host)
  Future<Room> startGame(String roomCode) async {
    return MockMultiplayerService.startGame(roomCode);
  }

  /// Registra resposta do jogador
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
    // Calcular pontos se não fornecido
    final finalPoints = points ?? (isCorrect ? (100 + ((responseTimeMs != null) ? (15000 - responseTimeMs) ~/ 100 : 50)).clamp(100, 200) : 0);
    final finalAnswerIndex = answerIndex ?? selectedAnswer ?? -1;
    
    await MockMultiplayerService.submitAnswer(
      roomCode: roomCode,
      playerId: playerId,
      answerIndex: finalAnswerIndex,
      isCorrect: isCorrect,
      points: finalPoints,
    );
  }

  /// Avança para próxima pergunta
  Future<void> nextQuestion(String roomCode) async {
    await MockMultiplayerService.nextQuestion(roomCode);
  }

  /// Escuta mudanças na sala (alias para roomStream)
  Stream<Room> watchRoom(String roomCode) {
    return MockMultiplayerService.roomStream(roomCode);
  }

  /// Stream da sala (tempo real)
  Stream<Room> roomStream(String roomCode) {
    return MockMultiplayerService.roomStream(roomCode);
  }

  /// Obtém sala atual
  Future<Room?> getRoom(String roomCode) async {
    return MockMultiplayerService.getRoom(roomCode);
  }

  /// Remove um jogador da sala
  Future<Room?> removePlayer({
    required String roomCode,
    required String playerId,
  }) async {
    return MockMultiplayerService.removePlayer(
      roomCode: roomCode,
      playerId: playerId,
    );
  }

  /// Sai da sala
  Future<void> leaveRoom(String roomCode) async {
    final playerId = _authService.userId ?? 'unknown';
    await MockMultiplayerService.removePlayer(
      roomCode: roomCode,
      playerId: playerId,
    );
  }

  /// Fecha a sala (apenas host)
  Future<void> closeRoom(String roomCode) async {
    await MockMultiplayerService.closeRoom(roomCode);
  }

  /// Reinicia o jogo (mesmos jogadores, novas perguntas)
  Future<Room> restartGame(String roomCode) async {
    return MockMultiplayerService.restartGame(roomCode);
  }

  /// Finaliza o jogo
  Future<void> finishGame(String roomCode) async {
    await MockMultiplayerService.closeRoom(roomCode);
  }
}
