import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import '../../services/achievement_service.dart';
import '../../widgets/achievement_unlock_dialog.dart';

class MazeGame extends StatefulWidget {
  const MazeGame({super.key});

  @override
  State<MazeGame> createState() => _MazeGameState();
}

class _MazeGameState extends State<MazeGame> {
  final AudioService _audioService = AudioService();
  final StorageService _storage = StorageService();
  final AchievementService _achievementService = AchievementService();
  
  // Player position
  int _playerRow = 0;
  int _playerCol = 0;
  
  // Game state
  bool _isGameWon = false;
  int _moves = 0;
  DateTime? _gameStartTime;
  
  // Para repetição de movimento ao segurar botão
  bool _isMoving = false;
  int _moveDirection = 0; // 1=up, 2=down, 3=left, 4=right
  
  // Labirinto atual (será selecionado aleatoriamente)
  late List<List<int>> _maze;
  
  // 10 labirintos diferentes (20x20) - 0 = caminho, 1 = parede, 2 = início, 3 = fim
  static const List<List<List<int>>> _allMazes = [
    // Labirinto 1 - Corredores Longos
    [
      [2, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3],
    ],
    
    // Labirinto 2 - Complexo com Múltiplos Caminhos
    [
      [2,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1],
      [1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,0,0,1],
      [1,0,0,0,0,0,0,0,0,0,1,0,1,0,1,1,1,1,0,1],
      [1,0,1,1,1,1,1,1,1,0,1,0,1,0,1,0,0,1,0,1],
      [1,0,1,0,0,0,0,0,1,0,1,0,1,0,1,0,1,1,0,1],
      [1,0,1,0,1,1,1,0,1,0,1,0,1,0,1,0,0,0,0,1],
      [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,1,1,1,1],
      [1,0,1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,1],
      [1,0,1,0,1,0,1,0,1,0,1,1,1,1,1,1,1,1,0,1],
      [1,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,1,0,1],
      [1,0,1,0,1,0,1,0,1,1,1,1,1,1,1,1,0,1,0,1],
      [1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1],
      [1,0,1,0,1,0,1,1,1,1,1,1,1,1,0,1,0,1,0,1],
      [1,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1],
      [1,1,1,0,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1,0,1,0,1,1,1,1,1],
      [1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1],
      [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1],
    ],
    
    // Labirinto 3 - Labirinto Denso com Salas
    [
      [2,0,0,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1],
      [1,1,0,1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,1],
      [1,1,0,1,0,1,1,1,0,1,0,1,0,1,0,1,1,1,0,1],
      [1,0,0,1,0,1,0,1,0,1,0,1,0,0,0,1,0,1,0,1],
      [1,0,1,1,0,1,0,1,0,1,0,1,1,1,0,1,0,1,0,1],
      [1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1],
      [1,1,1,1,0,1,1,1,1,1,1,1,0,1,0,1,0,1,0,1],
      [1,0,0,1,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1],
      [1,0,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,1,0,1],
      [1,1,1,1,1,1,1,1,0,1,0,1,0,1,0,1,0,1,0,1],
      [1,0,0,0,0,0,0,1,0,1,0,0,0,1,0,1,0,1,0,1],
      [1,0,1,1,1,1,0,1,0,1,1,1,0,1,0,1,0,1,0,1],
      [1,0,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,1,0,1],
      [1,1,1,1,0,1,0,1,1,1,0,1,0,1,1,1,0,1,0,1],
      [1,0,0,1,0,0,0,0,0,1,0,1,0,0,0,1,0,1,0,1],
      [1,0,1,1,1,1,1,1,0,1,0,1,1,1,0,1,0,1,0,1],
      [1,0,1,0,0,0,0,1,0,1,0,0,0,1,0,1,0,1,0,1],
      [1,0,1,0,1,1,0,1,1,1,1,1,0,1,0,1,0,1,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,1],
    ],
    
    // Labirinto 4 - Labirinto Clássico
    [
      [2, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 3],
    ],
    
    // Labirinto 5 - Quartos
    [
      [2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3],
    ],
    
    // Labirinto 6 - Cruz Central
    [
      [2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1],
      [1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1],
      [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1],
      [1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1],
      [1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 3],
    ],
    
    // Labirinto 7 - Caminhos Entrelaçados
    [
      [2,0,1,1,0,0,0,1,1,1,0,0,0,1,1,1,0,0,1,1],
      [1,0,0,1,0,1,0,0,0,1,0,1,0,0,0,1,0,1,0,1],
      [1,1,0,1,0,1,1,1,0,1,0,1,0,1,0,1,0,1,0,1],
      [1,0,0,0,0,0,0,1,0,0,0,1,0,1,0,0,0,1,0,1],
      [1,0,1,1,1,1,0,1,1,1,0,1,0,1,1,1,0,1,0,1],
      [1,0,1,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1],
      [1,0,1,0,1,1,1,1,0,1,1,1,1,1,0,1,1,1,0,1],
      [1,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1],
      [1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,0,1],
      [1,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,1],
      [1,0,1,1,0,1,1,1,1,1,0,1,1,1,0,1,0,1,0,1],
      [1,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,1,0,1],
      [1,1,0,1,1,1,1,1,0,1,1,1,0,1,1,1,1,1,0,1],
      [1,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1],
      [1,0,1,1,1,1,0,1,1,1,1,1,0,1,1,1,0,1,1,1],
      [1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,1,0,0,0,1],
      [1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0,1,0,1],
      [1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1],
      [1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1],
      [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,1],
    ],
    
    // Labirinto 8 - Bifurcações
    [
      [2, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1],
      [1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
      [1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
      [1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 3],
    ],
    
    // Labirinto 9 - Caminho Tortuoso
    [
      [2, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1],
      [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 3],
    ],
    
    // Labirinto 10 - Grande Desafio
    [
      [2, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1],
      [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1],
      [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 3],
    ],
  ];

  @override
  void initState() {
    super.initState();
    _selectRandomMaze();
    _gameStartTime = DateTime.now();
    _audioService.playBackgroundMusic('quiz-home.mp3');
  }
  
  /// Seleciona um labirinto aleatório da lista
  void _selectRandomMaze() {
    final random = Random();
    final mazeIndex = random.nextInt(_allMazes.length);
    _maze = List.generate(
      _allMazes[mazeIndex].length,
      (i) => List<int>.from(_allMazes[mazeIndex][i]),
    );
  }

  @override
  void dispose() {
    _audioService.stopBackgroundMusic();
    super.dispose();
  }

  void _movePlayer(int deltaRow, int deltaCol) {
    if (_isGameWon) return;

    int newRow = _playerRow + deltaRow;
    int newCol = _playerCol + deltaCol;

    // Check boundaries
    if (newRow < 0 || newRow >= _maze.length || newCol < 0 || newCol >= _maze[0].length) {
      return;
    }

    // Check if it's a wall
    if (_maze[newRow][newCol] == 1) {
      _audioService.playWrongAnswer();
      return;
    }

    setState(() {
      _playerRow = newRow;
      _playerCol = newCol;
      _moves++;
    });

    _audioService.playClick();

    // Check if reached the end
    if (_maze[newRow][newCol] == 3) {
      setState(() {
        _isGameWon = true;
      });
      _audioService.playVictory();
      _saveGameResult();
    }
  }

  Future<void> _saveGameResult() async {
    final timeSpent = _gameStartTime != null
        ? DateTime.now().difference(_gameStartTime!).inSeconds
        : 0;

    await _storage.saveMinigameRecord(
      'maze',
      score: 1000 - (_moves * 5),
      won: true,
      timeInSeconds: timeSpent,
    );

    final records = await _storage.getMinigameRecords();
    final mazeRecord = records.getRecord('maze');
    
    final unlockedAchievements = await _achievementService.checkMinigameAchievements(
      gameId: 'maze',
      totalGamesPlayed: mazeRecord.gamesPlayed,
      won: true,
      timeInSeconds: timeSpent,
    );
    
    if (mounted && unlockedAchievements.isNotEmpty) {
      for (final achievement in unlockedAchievements) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AchievementUnlockDialog(achievement: achievement),
        );
      }
    }
  }

  // Inicia movimento contínuo
  void _startContinuousMove(int direction) {
    if (_isMoving) return;
    setState(() {
      _isMoving = true;
      _moveDirection = direction;
    });
    _continuousMove();
  }

  // Para movimento contínuo
  void _stopContinuousMove() {
    setState(() {
      _isMoving = false;
      _moveDirection = 0;
    });
  }

  // Move continuamente enquanto botão estiver pressionado
  void _continuousMove() async {
    if (!_isMoving) return;

    switch (_moveDirection) {
      case 1: _movePlayer(-1, 0); break; // Up
      case 2: _movePlayer(1, 0); break;  // Down
      case 3: _movePlayer(0, -1); break; // Left
      case 4: _movePlayer(0, 1); break;  // Right
    }

    await Future.delayed(const Duration(milliseconds: 150));
    
    if (_isMoving && mounted) {
      _continuousMove();
    }
  }

  void _resetGame() {
    setState(() {
      _selectRandomMaze(); // Novo labirinto aleatório a cada reinício
      _playerRow = 0;
      _playerCol = 0;
      _isGameWon = false;
      _moves = 0;
    });
  }

  Color _getCellColor(int row, int col) {
    if (row == _playerRow && col == _playerCol) {
      return Colors.blue; // Player
    }
    
    switch (_maze[row][col]) {
      case 0:
        return Colors.white; // Path
      case 1:
        return Colors.grey.shade800; // Wall
      case 2:
        return Colors.green; // Start
      case 3:
        return Colors.red; // End
      default:
        return Colors.white;
    }
  }

  String _getCellEmoji(int row, int col) {
    if (row == _playerRow && col == _playerCol) {
      return '😊';
    }
    if (_maze[row][col] == 2) {
      return '🏁';
    }
    if (_maze[row][col] == 3) {
      return '🏆';
    }
    return '';
  }

  // Controles circulares estilizados
  Widget _buildCircularControls() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
      ),
      child: Stack(
        children: [
          // Botão Cima
          Positioned(
            top: 10,
            left: 75,
            child: GestureDetector(
              onTapDown: (_) => _startContinuousMove(1),
              onTapUp: (_) => _stopContinuousMove(),
              onTapCancel: () => _stopContinuousMove(),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_upward, color: Colors.white, size: 30),
              ),
            ),
          ),
          
          // Botão Baixo
          Positioned(
            bottom: 10,
            left: 75,
            child: GestureDetector(
              onTapDown: (_) => _startContinuousMove(2),
              onTapUp: (_) => _stopContinuousMove(),
              onTapCancel: () => _stopContinuousMove(),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_downward, color: Colors.white, size: 30),
              ),
            ),
          ),
          
          // Botão Esquerda
          Positioned(
            left: 10,
            top: 75,
            child: GestureDetector(
              onTapDown: (_) => _startContinuousMove(3),
              onTapUp: (_) => _stopContinuousMove(),
              onTapCancel: () => _stopContinuousMove(),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              ),
            ),
          ),
          
          // Botão Direita
          Positioned(
            right: 10,
            top: 75,
            child: GestureDetector(
              onTapDown: (_) => _startContinuousMove(4),
              onTapUp: (_) => _stopContinuousMove(),
              onTapCancel: () => _stopContinuousMove(),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_forward, color: Colors.white, size: 30),
              ),
            ),
          ),
          
          // Centro decorativo
          Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.navigation, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent && !_isMoving) {
          // Inicia movimento contínuo com teclas do teclado
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            _startContinuousMove(1);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            _startContinuousMove(2);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _startContinuousMove(3);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _startContinuousMove(4);
          }
        } else if (event is KeyUpEvent) {
          // Para movimento quando soltar a tecla
          _stopContinuousMove();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('🧩 Labirinto'),
          backgroundColor: Colors.orange,
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Movimentos: $_moves',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.orange.shade200, Colors.orange.shade600],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isGameWon)
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '🎉 PARABÉNS! 🎉',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Você completou em $_moves movimentos!',
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),

                // Maze grid - ajustado para não causar overflow
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: List.generate(_maze.length, (row) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_maze[row].length, (col) {
                            return Container(
                              width: 15,
                              height: 15,
                              margin: const EdgeInsets.all(0.5),
                              decoration: BoxDecoration(
                                color: _getCellColor(row, col),
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  width: 0.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _getCellEmoji(row, col),
                                  style: const TextStyle(fontSize: 8),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Controles circulares
                _buildCircularControls(),

                const SizedBox(height: 20),

                // Reset button
                ElevatedButton.icon(
                  onPressed: _resetGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reiniciar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
