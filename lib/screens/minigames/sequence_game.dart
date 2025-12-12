import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import '../../services/achievement_service.dart';
import '../../widgets/achievement_unlock_dialog.dart';

class SequenceGame extends StatefulWidget {
  const SequenceGame({super.key});

  @override
  State<SequenceGame> createState() => _SequenceGameState();
}

class _SequenceGameState extends State<SequenceGame> {
  final AudioService _audioService = AudioService();
  final StorageService _storage = StorageService();
  final AchievementService _achievementService = AchievementService();

  // Game state
  List<int> _sequence = [];
  List<int> _playerSequence = [];
  int _currentLevel = 1;
  int _highScore = 0;
  bool _isShowingSequence = false;
  bool _isPlayerTurn = false;
  bool _gameOver = false;
  int _currentShowIndex = 0;
  int _lastTappedColor = -1; // Para animação de toque
  bool _showSuccessAnimation = false; // Animação de acerto
  DateTime? _gameStartTime;
  
  static const int maxLevel = 20; // Aumentado para 20 níveis

  @override
  void initState() {
    super.initState();
    _audioService.playBackgroundMusic('memory-game.mp3');
  }

  @override
  void dispose() {
    _audioService.stopBackgroundMusic();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _sequence = [];
      _playerSequence = [];
      _currentLevel = 1;
      _gameOver = false;
      _isPlayerTurn = false;
      _gameStartTime = DateTime.now();
    });
    _nextLevel();
  }

  void _nextLevel() {
    setState(() {
      _sequence.add(_generateRandomColor());
      _playerSequence = [];
      _isShowingSequence = true;
      _currentShowIndex = 0;
    });
    _showSequence();
  }

  int _generateRandomColor() {
    return DateTime.now().millisecondsSinceEpoch % 4;
  }

  Future<void> _showSequence() async {
    await Future.delayed(const Duration(milliseconds: 800));

    for (int i = 0; i < _sequence.length; i++) {
      setState(() {
        _currentShowIndex = i;
      });
      _audioService.playClick();
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() {
        _currentShowIndex = -1;
      });
      await Future.delayed(const Duration(milliseconds: 300));
    }

    setState(() {
      _isShowingSequence = false;
      _isPlayerTurn = true;
    });
  }

  void _onColorTap(int colorIndex) async {
    if (!_isPlayerTurn || _gameOver) return;

    // Animação de toque
    setState(() {
      _lastTappedColor = colorIndex;
    });
    _audioService.playClick();
    
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _lastTappedColor = -1;
    });

    _playerSequence.add(colorIndex);

    // Check if player's move is correct
    int currentIndex = _playerSequence.length - 1;
    if (_playerSequence[currentIndex] != _sequence[currentIndex]) {
      _endGame(false);
      return;
    }

    // Check if player completed the sequence
    if (_playerSequence.length == _sequence.length) {
      // Verifica se ganhou o jogo (chegou no nível 20)
      if (_currentLevel >= maxLevel) {
        _endGame(true);
        return;
      }
      
      setState(() {
        _isPlayerTurn = false;
        _showSuccessAnimation = true;
        _currentLevel++;
        if (_currentLevel - 1 > _highScore) {
          _highScore = _currentLevel - 1;
        }
      });
      _audioService.playCorrectAnswer();
      
      // Animação de sucesso
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        _showSuccessAnimation = false;
      });
      
      await Future.delayed(const Duration(milliseconds: 500));
      _nextLevel();
    }
  }

  void _endGame(bool won) {
    setState(() {
      _gameOver = true;
      _isPlayerTurn = false;
      if (_currentLevel - 1 > _highScore) {
        _highScore = _currentLevel - 1;
      }
    });
    if (won) {
      _audioService.playVictory();
      _saveGameResult(won: true);
    } else {
      _audioService.playWrongAnswer();
      _saveGameResult(won: false);
    }
  }

  Future<void> _saveGameResult({required bool won}) async {
    final timeSpent = _gameStartTime != null
        ? DateTime.now().difference(_gameStartTime!).inSeconds
        : 0;

    await _storage.saveMinigameRecord(
      'sequence',
      score: _currentLevel - 1,
      won: won,
      timeInSeconds: timeSpent,
    );

    if (won) {
      final records = await _storage.getMinigameRecords();
      final sequenceRecord = records.getRecord('sequence');
      
      final unlockedAchievements = await _achievementService.checkMinigameAchievements(
        gameId: 'sequence',
        totalGamesPlayed: sequenceRecord.gamesPlayed,
        won: won,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💎 Caverna dos Cristais'),
        backgroundColor: Color(0xFF1A0A2E),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Recorde: $_highScore',
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
            colors: [
              Color(0xFF1A0A2E), // Roxo escuro caverna
              Color(0xFF0D0515), // Quase preto
              Color(0xFF0A0A0A), // Preto profundo
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Level indicator - estilo pedra mística
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFF2D1F3D),
                      Color(0xFF1A1025),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Color(0xFF6B4D8A).withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF6B4D8A).withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'NÍVEL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$_currentLevel',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Status text / Success Animation
              if (_showSuccessAnimation)
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: 0.5 + (value * 0.5),
                      child: Opacity(
                        opacity: value,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withValues(alpha: 0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white, size: 50),
                              SizedBox(height: 10),
                              Text(
                                '✨ Correto! ✨',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Nível $_currentLevel',
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              else if (_isShowingSequence)
                const Text(
                  'Observe a sequência...',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              else if (_isPlayerTurn)
                const Text(
                  'Sua vez! Repita a sequência',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              else if (_gameOver)
                Column(
                  children: [
                    Text(
                      _currentLevel >= maxLevel ? '🎉 PARABÉNS! VOCÊ VENCEU! 🎉' : '❌ Fim de Jogo!',
                      style: TextStyle(
                        color: _currentLevel >= maxLevel ? Colors.green : Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _currentLevel >= maxLevel 
                        ? 'Você completou todos os 20 níveis!'
                        : 'Você alcançou o nível $_currentLevel',
                      style: const TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ],
                ),

              const SizedBox(height: 40),

              // Color buttons - Crystal Design
              if (!_gameOver && _sequence.isNotEmpty)
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: List.generate(4, (index) {
                    bool isHighlighted = (_isShowingSequence && 
                        _currentShowIndex >= 0 && 
                        _sequence[_currentShowIndex] == index) ||
                        (_lastTappedColor == index);
                    
                    return GestureDetector(
                      onTap: () => _onColorTap(index),
                      child: _buildCrystalButton(index, isHighlighted),
                    );
                  }),
                ),

              const SizedBox(height: 40),

              // Start/Restart button
              if (_sequence.isEmpty || _gameOver)
                ElevatedButton.icon(
                  onPressed: _startGame,
                  icon: const Icon(Icons.play_arrow, size: 28),
                  label: Text(
                    _gameOver ? 'Jogar Novamente' : 'Iniciar Jogo',
                    style: const TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget de cristal incrustado na caverna
  Widget _buildCrystalButton(int index, bool isHighlighted) {
    // Cores dos cristais com tons de gema
    final List<List<Color>> crystalGradients = [
      [Color(0xFFFF1744), Color(0xFFD50000), Color(0xFF7F0000)], // Rubi
      [Color(0xFF448AFF), Color(0xFF2962FF), Color(0xFF0D47A1)], // Safira
      [Color(0xFF69F0AE), Color(0xFF00E676), Color(0xFF00695C)], // Esmeralda  
      [Color(0xFFFFD740), Color(0xFFFFC400), Color(0xFFFF8F00)], // Topázio
    ];

    final crystalColors = crystalGradients[index];
    final double glowIntensity = isHighlighted ? 1.0 : 0.3;
    final double scale = isHighlighted ? 1.1 : 1.0;

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: 130,
        height: 140,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Cavidade da rocha (fundo escuro)
            Container(
              width: 120,
              height: 130,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF2D2D2D),
                    Color(0xFF1A1A1A),
                    Color(0xFF0D0D0D),
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xFF3D3D3D),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.8),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
            ),
            
            // Brilho ambiente do cristal quando iluminado
            if (isHighlighted)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 140,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: crystalColors[0].withValues(alpha: 0.6),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                    BoxShadow(
                      color: crystalColors[1].withValues(alpha: 0.4),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            
            // Cristal principal (forma de gema hexagonal)
            CustomPaint(
              size: Size(90, 100),
              painter: CrystalPainter(
                baseColor: crystalColors[0],
                midColor: crystalColors[1],
                darkColor: crystalColors[2],
                glowIntensity: glowIntensity,
              ),
            ),
            
            // Reflexo superior (brilho)
            Positioned(
              top: 25,
              left: 35,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isHighlighted ? 1.0 : 0.4,
                child: Container(
                  width: 20,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.9),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            
            // Pequeno brilho secundário
            Positioned(
              top: 35,
              right: 40,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isHighlighted ? 0.8 : 0.2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Nome da cor (emoji estilo)
            Positioned(
              bottom: 8,
              child: Text(
                _getCrystalEmoji(index),
                style: TextStyle(
                  fontSize: 20,
                  shadows: [
                    Shadow(
                      color: crystalColors[0],
                      blurRadius: isHighlighted ? 15 : 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCrystalEmoji(int index) {
    switch (index) {
      case 0: return '❤️'; // Rubi
      case 1: return '💙'; // Safira
      case 2: return '💚'; // Esmeralda
      case 3: return '💛'; // Topázio
      default: return '💎';
    }
  }
}

// Painter customizado para desenhar o cristal
class CrystalPainter extends CustomPainter {
  final Color baseColor;
  final Color midColor;
  final Color darkColor;
  final double glowIntensity;

  CrystalPainter({
    required this.baseColor,
    required this.midColor,
    required this.darkColor,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Facetas do cristal (forma de gema)
    final path = Path();
    
    // Topo do cristal
    path.moveTo(centerX, 5);
    path.lineTo(centerX + 35, centerY - 15);
    path.lineTo(centerX + 30, centerY + 25);
    path.lineTo(centerX, size.height - 5);
    path.lineTo(centerX - 30, centerY + 25);
    path.lineTo(centerX - 35, centerY - 15);
    path.close();
    
    // Gradiente do cristal
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          baseColor.withValues(alpha: 0.3 + (glowIntensity * 0.7)),
          midColor.withValues(alpha: 0.5 + (glowIntensity * 0.5)),
          darkColor.withValues(alpha: 0.7 + (glowIntensity * 0.3)),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawPath(path, paint);
    
    // Borda do cristal
    final borderPaint = Paint()
      ..color = baseColor.withValues(alpha: 0.5 + (glowIntensity * 0.5))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawPath(path, borderPaint);
    
    // Linha de faceta interna (esquerda)
    final facetPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2 + (glowIntensity * 0.3))
      ..strokeWidth = 1.5;
    
    canvas.drawLine(
      Offset(centerX, 5),
      Offset(centerX, size.height - 5),
      facetPaint,
    );
    
    // Faceta diagonal esquerda
    canvas.drawLine(
      Offset(centerX, 5),
      Offset(centerX - 30, centerY + 25),
      facetPaint,
    );
    
    // Faceta diagonal direita
    canvas.drawLine(
      Offset(centerX, 5),
      Offset(centerX + 30, centerY + 25),
      facetPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CrystalPainter oldDelegate) {
    return oldDelegate.glowIntensity != glowIntensity;
  }
}
