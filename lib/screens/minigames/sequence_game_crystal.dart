import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart'; // Para HapticFeedback
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';

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

final List<String> _colorNames = [
  'Vermelho', 'Azul', 'Verde', 'Amarelo', 'Roxo', 'Laranja', 'Ciano', 'Lima', 'Rosa',
];

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
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Escolha a Dificuldade', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDifficultyOption(GameDifficulty.easy, 'Fácil (4 Cores)'),
              _buildDifficultyOption(GameDifficulty.medium, 'Médio (6 Cores)'),
              _buildDifficultyOption(GameDifficulty.hard, 'Difícil (9 Cores)'),
              const Divider(),
              _buildDifficultyOption(
                GameDifficulty.progressive, 
                'PROGRESSIVO (4 -> 9 Cores)',
                subtitle: 'Aumenta uma cor a cada 3 acertos seguidos.',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Voltar'),
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

  Widget _buildColorButton(int index) {
    bool isHighlighted = (_isShowingSequence && _currentShowIndex == index) || (_lastTappedColor == index);
    
    // O botão fica desativado (sem brilho) se a cor não estiver ativa na dificuldade progressiva
    bool isAvailable = index < _activeColorCount;

    return _buildCrystalButton(
      baseColor: _allColors[index],
      isLit: isAvailable && isHighlighted,
      isAvailable: isAvailable,
      label: isAvailable ? _colorNames[index] : 'Bloqueado',
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
    final Color shadowColor = isLit ? baseColor.withValues(alpha: 0.8) : Colors.black;

    return GestureDetector(
      onTap: isAvailable ? onPressed : null,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF151515), // Rocha de fundo
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              // Sombra da rocha para dar profundidade de "incrustação"
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
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.all(10), // Espaço para o "rocha" em volta
              decoration: BoxDecoration(
                // Forma do cristal (poligonal/angular é melhor, mas um círculo já simula bem)
                shape: BoxShape.circle,
                // Gradiente para dar a sensação 3D/facetada
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: isLit ? 0.9 : (isAvailable ? 0.3 : 0.1)), // Centro mais claro
                    glowColor,
                  ],
                  stops: const [0.0, 1.0],
                ),
                // Brilho intenso (Glow)
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: isLit ? 30.0 : 5.0, // Brilha mais quando ativado
                    spreadRadius: isLit ? 5.0 : 0.0,
                    offset: const Offset(0, 0),
                  ),
                  BoxShadow(
                    color: baseColor.withValues(alpha: 0.3),
                    blurRadius: isLit ? 20.0 : 0.0,
                    spreadRadius: isLit ? 2.0 : 0.0,
                    offset: const Offset(0, 0),
                  ),
                ],
                border: Border.all(
                  color: isLit ? Colors.white70 : (isAvailable ? Colors.white24 : Colors.transparent),
                  width: 2.0,
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isAvailable ? Colors.white : Colors.white38,
                    fontSize: 14,
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
    );
  }

  // --- UI: Build Principal ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Caverna muito escura
      appBar: AppBar(
        title: const Text('🧠 Sequência Rápida', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF162447),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Recorde: $_highScore',
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
                        Text('CORES ATIVAS: $_activeColorCount / $maxActiveColors',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        if (_difficulty == GameDifficulty.progressive)
                            Text('SEQUÊNCIA: $_consecutiveCorrect / $streakToUpgrade',
                                style: const TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                  ),
                ),
                
                // Nível e Status
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text('NÍVEL', style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('$_currentLevel', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      if (_showSuccessAnimation)
                        const Text('✨ Correto! Próximo Nível! ✨', style: TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold))
                      else if (_isShowingSequence)
                        const Text('👀 Observe a sequência...', style: TextStyle(color: Colors.white, fontSize: 20))
                      else if (_isPlayerTurn)
                        const Text('👆 Sua vez! Repita a sequência', style: TextStyle(color: Colors.yellowAccent, fontSize: 20, fontWeight: FontWeight.bold))
                      else if (_gameOver)
                        Text('❌ Fim de Jogo! Você chegou ao nível ${_currentLevel - 1}',
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

                        return _buildColorButton(index);
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
                      _gameOver ? 'Reiniciar Jogo' : 'Iniciar/Dificuldade',
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