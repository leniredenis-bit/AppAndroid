import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart'; // Para HapticFeedback
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import '../../l10n/app_localizations.dart';

// --- Configuração das Cores ---
// Definimos a paleta máxima (9 cores)
final List<Color> _allColors = [
  Colors.red,        // 0
  Colors.blue,       // 1
  Colors.green,      // 2
  Colors.yellow,     // 3
  Colors.purple,     // 4
  Colors.orange,     // 5
  Colors.cyan,       // 6
  Colors.lime,       // 7
  Colors.pink,       // 8
];

// Nomes das cores são obtidos via l10n dentro do widget

// --- Opções de Dificuldade ---
enum GameDifficulty {
  easy(4),
  medium(6),
  hard(9),
  progressive(4); // Começa com 4 e aumenta

  final int initialColors;
  const GameDifficulty(this.initialColors);
}

class SequenceGame extends StatefulWidget {
  const SequenceGame({super.key});

  @override
  State<SequenceGame> createState() => _SequenceGameState();
}

class _SequenceGameState extends State<SequenceGame> {
  final AudioService _audioService = AudioService();
  final StorageService _storage = StorageService();
  final Random _random = Random();

  // --- Estados do Jogo ---
  List<int> _sequence = [];
  List<int> _playerSequence = [];
  int _currentLevel = 1;
  int _highScore = 0;
  bool _isShowingSequence = false;
  bool _isPlayerTurn = false;
  bool _gameOver = false;
  int _currentShowIndex = -1;
  int _lastTappedColor = -1;
  bool _showSuccessAnimation = false;

  // Progressivo/Dificuldade
  GameDifficulty _difficulty = GameDifficulty.easy;
  int _activeColorCount = 4; // Cores disponíveis no nível atual
  int _consecutiveCorrect = 0; // Para o modo progressivo
  static const int maxActiveColors = 9;
  static const int streakToUpgrade = 3; // Aumenta cor a cada 3 acertos

  // Método helper para obter nomes das cores traduzidos
  List<String> _getColorNames(AppLocalizations l10n) {
    return [
      l10n.colorRed,
      l10n.colorBlue,
      l10n.colorGreen,
      l10n.colorYellow,
      l10n.colorPurple,
      l10n.colorOrange,
      l10n.colorCyan,
      l10n.colorLime,
      l10n.colorPink,
    ];
  }

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _audioService.playBackgroundMusic('memory-game.mp3');
  }

  @override
  void dispose() {
    _audioService.stopBackgroundMusic();
    super.dispose();
  }

  Future<void> _loadHighScore() async {
    final record = await _storage.getMinigameRecords().then((r) => r.getRecord('sequence'));
    setState(() {
      _highScore = record.highScore;
    });
  }

  // --- Lógica de Início e Nível ---

  void _startGame({GameDifficulty? selectedDifficulty}) {
    if (selectedDifficulty != null) {
      _difficulty = selectedDifficulty;
    }

    setState(() {
      _activeColorCount = _difficulty.initialColors;
      _sequence = [];
      _playerSequence = [];
      _currentLevel = 1;
      _gameOver = false;
      _isPlayerTurn = false;
      _consecutiveCorrect = 0;
    });
    Navigator.of(context).pop(); // Fecha o seletor de dificuldade
    _nextLevel();
  }

  void _nextLevel() {
    // Verifica se deve aumentar o número de cores (apenas no modo progressivo)
    if (_difficulty == GameDifficulty.progressive && 
        _consecutiveCorrect >= streakToUpgrade && 
        _activeColorCount < maxActiveColors) {
      
      setState(() {
        _activeColorCount++;
        _consecutiveCorrect = 0;
        // Opcional: Animação de "Upgrade!"
      });
    }

    setState(() {
      // Adiciona uma cor aleatória dentro do limite atual de cores ativas
      _sequence.add(_random.nextInt(_activeColorCount));
      _playerSequence = [];
      _isShowingSequence = true;
      _currentShowIndex = -1;
    });
    _showSequence();
  }

  Future<void> _showSequence() async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Atraso entre o nível (diminui o tempo de espera com o aumento do nível)
    int delay = max(350, 600 - (_currentLevel * 10)); 

    for (int i = 0; i < _sequence.length; i++) {
      setState(() {
        _currentShowIndex = _sequence[i]; // Agora _currentShowIndex guarda a COR
      });
      _audioService.playClick();
      await Future.delayed(Duration(milliseconds: delay));
      setState(() {
        _currentShowIndex = -1;
      });
      await Future.delayed(const Duration(milliseconds: 150));
    }

    setState(() {
      _isShowingSequence = false;
      _isPlayerTurn = true;
    });
  }

  // --- Lógica de Toque do Jogador ---

  void _onColorTap(int colorIndex) async {
    if (!_isPlayerTurn || _gameOver) return;
    
    // Haptic Feedback e som
    HapticFeedback.lightImpact();
    _audioService.playClick();

    // Animação de toque: acende e apaga
    setState(() {
      _lastTappedColor = colorIndex;
    });
    await Future.delayed(const Duration(milliseconds: 150));
    setState(() {
      _lastTappedColor = -1;
    });

    _playerSequence.add(colorIndex);
    int currentIndex = _playerSequence.length - 1;

    // 1. Verificação de Erro
    if (_playerSequence[currentIndex] != _sequence[currentIndex]) {
      _endGame(false);
      return;
    }

    // 2. Verificação de Sequência Completa
    if (_playerSequence.length == _sequence.length) {
      
      setState(() {
        _isPlayerTurn = false;
        _showSuccessAnimation = true;
        _currentLevel++;
        _consecutiveCorrect++; // Incrementa o contador de acertos
        _highScore = max(_currentLevel - 1, _highScore);
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
      _highScore = max(_currentLevel - 1, _highScore);
    });

    if (won) {
      _audioService.playVictory();
    } else {
      _audioService.playWrongAnswer();
    }
    _saveGameResult(won: won);
  }

  Future<void> _saveGameResult({required bool won}) async {
    // ... lógica de gravação de resultados e conquistas (mantida) ...
    // Apenas a pontuação é o nível atingido
    final score = _currentLevel - 1;
    
    // Simplificando o salvamento e check de achievements
    await _storage.saveMinigameRecord(
      'sequence',
      score: score,
      won: won,
      timeInSeconds: 0,
    );
    
    await _loadHighScore(); // Recarrega o recorde após o jogo
  }
  
  // --- UI: Seletor de Dificuldade ---

  Future<void> _showDifficultySelector() async {
    final l10n = AppLocalizations.of(context)!;
    
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.sequenceChooseDifficulty, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDifficultyOption(GameDifficulty.easy, l10n.sequenceEasyColors(4)),
              _buildDifficultyOption(GameDifficulty.medium, l10n.sequenceMediumColors(6)),
              _buildDifficultyOption(GameDifficulty.hard, l10n.sequenceHardColors(9)),
              const Divider(),
              _buildDifficultyOption(
                GameDifficulty.progressive, 
                l10n.sequenceProgressive(4, 9),
                subtitle: l10n.sequenceProgressiveDesc(3),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.back),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDifficultyOption(GameDifficulty difficulty, String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        color: Colors.deepPurple.shade50,
        elevation: 2,
        child: ListTile(
          onTap: () => _startGame(selectedDifficulty: difficulty),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 12)) : null,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }


  // --- UI: Botão de Cor (Estilo Cristal) ---

  Widget _buildColorButton(int index, AppLocalizations l10n) {
    bool isHighlighted = (_isShowingSequence && _currentShowIndex == index) || (_lastTappedColor == index);
    
    // O botão fica desativado (sem brilho) se a cor não estiver ativa na dificuldade progressiva
    bool isAvailable = index < _activeColorCount;
    final colorNames = _getColorNames(l10n);

    return _buildCrystalButton(
      baseColor: _allColors[index],
      isLit: isAvailable && isHighlighted,
      isAvailable: isAvailable,
      label: isAvailable ? colorNames[index] : l10n.colorLocked,
      onPressed: isAvailable ? () => _onColorTap(index) : () {},
    );
  }

  // --- Widget do Botão Cristal ---
  Widget _buildCrystalButton({
    required Color baseColor,
    required bool isLit, // Indica se o botão está brilhando (sequência ou pressionado)
    required bool isAvailable, // Se a cor está disponível no nível atual
    required String label,
    required VoidCallback onPressed,
  }) {
    // A cor base será o núcleo do cristal, a cor de brilho é mais intensa
    final Color glowColor = isLit 
        ? baseColor.withValues(alpha: 0.9) 
        : (isAvailable ? baseColor.withValues(alpha: 0.4) : Colors.grey.shade800.withValues(alpha: 0.3));

    return GestureDetector(
      onTap: isAvailable ? onPressed : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF151515), // Rocha de fundo
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 8.0,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.all(8),
              child: CustomPaint(
                painter: CrystalPainter(
                  baseColor: baseColor,
                  glowColor: glowColor,
                  isLit: isLit,
                  isAvailable: isAvailable,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isAvailable ? Colors.white : Colors.white38,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 3),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- UI: Build Principal ---

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Caverna muito escura
      appBar: AppBar(
        title: Text('🧠 ${l10n.minigamesSequence}', style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF162447),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                l10n.sequenceHighScoreLabel(_highScore),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1C1C1C), // Rocha escura no topo
              const Color(0xFF0A0A0A), // Caverna profunda embaixo
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Indicador de Cores Ativas / Streak
                Container(
                  margin: const EdgeInsets.only(bottom: 20, top: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                      children: [
                        Text(l10n.sequenceActiveColors(_activeColorCount, maxActiveColors),
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        if (_difficulty == GameDifficulty.progressive)
                            Text(l10n.sequenceStreak(_consecutiveCorrect, streakToUpgrade),
                                style: const TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                  ),
                ),
                
                // Nível e Status
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(l10n.level.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('$_currentLevel', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      if (_showSuccessAnimation)
                        Text(l10n.sequenceCorrect, style: const TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold))
                      else if (_isShowingSequence)
                        Text(l10n.sequenceObserve, style: const TextStyle(color: Colors.white, fontSize: 20))
                      else if (_isPlayerTurn)
                        Text(l10n.sequenceRepeat, style: const TextStyle(color: Colors.yellowAccent, fontSize: 20, fontWeight: FontWeight.bold))
                      else if (_gameOver)
                        Text(l10n.sequenceGameOverLevel(_currentLevel - 1),
                             style: const TextStyle(color: Colors.redAccent, fontSize: 24, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Botões de Cores (Organizados em 2x2, 2x3 ou 3x3)
                if (!_gameOver && _sequence.isNotEmpty)
                  SizedBox(
                    width: 400, // Limita a largura para melhor layout
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _activeColorCount <= 4 ? 2 : 3, // Layout dinâmico
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: _allColors.length,
                      itemBuilder: (context, index) {
                        // Só exibe botões que estão dentro do limite de cores ativas
                        if (index >= maxActiveColors) return const SizedBox.shrink();

                        return _buildColorButton(index, l10n);
                      },
                    ),
                  ),
                
                const SizedBox(height: 60),

                // Start/Restart button
                if (_sequence.isEmpty || _gameOver)
                  ElevatedButton.icon(
                    onPressed: _showDifficultySelector,
                    icon: const Icon(Icons.settings, size: 28),
                    label: Text(
                      _gameOver ? l10n.sequenceRestartGame : l10n.sequenceStartDifficulty,
                      style: const TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.deepPurple,
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
      ),
      ),
    );
  }
}

// --- Painter para desenhar forma de cristal/diamante ---
class CrystalPainter extends CustomPainter {
  final Color baseColor;
  final Color glowColor;
  final bool isLit;
  final bool isAvailable;

  CrystalPainter({
    required this.baseColor,
    required this.glowColor,
    required this.isLit,
    required this.isAvailable,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double w = size.width * 0.85;
    final double h = size.height * 0.85;
    
    // Pontos do cristal (forma de diamante/hexágono alongado)
    final path = Path();
    
    // Forma de cristal com 6 pontos (hexágono vertical alongado)
    path.moveTo(center.dx, center.dy - h / 2); // Topo
    path.lineTo(center.dx + w / 2, center.dy - h / 4); // Superior direito
    path.lineTo(center.dx + w / 2, center.dy + h / 4); // Inferior direito
    path.lineTo(center.dx, center.dy + h / 2); // Base
    path.lineTo(center.dx - w / 2, center.dy + h / 4); // Inferior esquerdo
    path.lineTo(center.dx - w / 2, center.dy - h / 4); // Superior esquerdo
    path.close();

    // Glow/sombra externa quando ativado
    if (isLit) {
      final glowPaint = Paint()
        ..color = baseColor.withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
      canvas.drawPath(path, glowPaint);
    }

    // Preenchimento com gradiente
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withValues(alpha: isLit ? 0.8 : (isAvailable ? 0.4 : 0.1)),
        glowColor,
        baseColor.withValues(alpha: isLit ? 0.9 : 0.5),
      ],
      stops: const [0.0, 0.3, 1.0],
    );

    final fillPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCenter(center: center, width: w, height: h));
    canvas.drawPath(path, fillPaint);

    // Facetas internas do cristal (linhas de reflexo)
    final facetPaint = Paint()
      ..color = Colors.white.withValues(alpha: isLit ? 0.5 : 0.2)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Linha central vertical
    canvas.drawLine(
      Offset(center.dx, center.dy - h / 2),
      Offset(center.dx, center.dy + h / 2),
      facetPaint,
    );

    // Linhas diagonais do topo
    canvas.drawLine(
      Offset(center.dx, center.dy - h / 2),
      Offset(center.dx + w / 2, center.dy - h / 4),
      facetPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - h / 2),
      Offset(center.dx - w / 2, center.dy - h / 4),
      facetPaint,
    );

    // Linhas para o centro
    canvas.drawLine(
      Offset(center.dx + w / 2, center.dy - h / 4),
      center,
      facetPaint,
    );
    canvas.drawLine(
      Offset(center.dx - w / 2, center.dy - h / 4),
      center,
      facetPaint,
    );

    // Borda externa
    final borderPaint = Paint()
      ..color = isLit ? Colors.white70 : (isAvailable ? Colors.white30 : Colors.white10)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, borderPaint);

    // Brilho no canto superior (reflexo)
    if (isAvailable) {
      final shinePaint = Paint()
        ..color = Colors.white.withValues(alpha: isLit ? 0.7 : 0.3);
      canvas.drawCircle(
        Offset(center.dx - w / 5, center.dy - h / 4),
        isLit ? 6 : 4,
        shinePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CrystalPainter oldDelegate) {
    return oldDelegate.isLit != isLit || 
           oldDelegate.isAvailable != isAvailable ||
           oldDelegate.baseColor != baseColor;
  }
}