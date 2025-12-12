import 'dart:math';
import 'package:flutter/material.dart';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import '../../services/achievement_service.dart';
import '../../widgets/achievement_unlock_dialog.dart';
import '../../l10n/app_localizations.dart';

// --- Constantes de Design ---
const Color kNeonBlue = Color(0xFF00F0FF);
const Color kNeonPink = Color(0xFFFF00AA);
const Color kGridColor = Color(0xFF2D2F45);
const Color kBackground = Color(0xFF10121B);

enum Player { X, O, none }
enum Mode { twoPlayers, vsAi }
enum AiDifficulty { easy, impossible }

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> with TickerProviderStateMixin {
  final StorageService _storage = StorageService();
  final AchievementService _achievementService = AchievementService();
  
  // Game State
  List<Player> board = List<Player>.filled(9, Player.none);
  Player current = Player.X;
  Mode mode = Mode.vsAi;
  AiDifficulty aiDifficulty = AiDifficulty.impossible;
  bool xStarts = true;
  bool gameOver = false;
  List<int>? winningLine; // Índices das células vencedoras para desenhar o risco

  // Score
  int xWins = 0;
  int oWins = 0;
  int draws = 0;

  DateTime? _gameStartTime;
  final Random _rnd = Random();

  // Controllers para animação de cada célula (para desenhar o X ou O)
  late List<AnimationController> _cellControllers;

  @override
  void initState() {
    super.initState();
    // Inicializa 9 controllers, um para cada célula
    _cellControllers = List.generate(9, (index) => AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    ));
    resetBoard();
  }

  @override
  void dispose() {
    for (var c in _cellControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void resetBoard({bool keepStarter = true}) {
    _gameStartTime = DateTime.now();
    setState(() {
      board = List<Player>.filled(9, Player.none);
      gameOver = false;
      winningLine = null;
      
      // Reseta animações
      for (var c in _cellControllers) {
        c.reset();
      }

      if (!keepStarter) {
        xStarts = !xStarts;
      }
      current = xStarts ? Player.X : Player.O;
      
      // AI Start logic
      if (mode == Mode.vsAi && current == Player.O) {
        Future.delayed(const Duration(milliseconds: 500), () => aiMove());
      }
    });
  }

  void resetAll() {
    AudioService().playClick();
    setState(() {
      xWins = 0;
      oWins = 0;
      draws = 0;
    });
    resetBoard(keepStarter: true);
  }

  void handleTap(int index) {
    if (gameOver || board[index] != Player.none) return;
    if (mode == Mode.vsAi && current == Player.O) return; // Bloqueia toque na vez da IA

    _makeMove(index, current);

    if (!gameOver && mode == Mode.vsAi && current == Player.O) {
      // Delay variável para parecer "humano"
      int thinkTime = 400 + _rnd.nextInt(400); 
      Future.delayed(Duration(milliseconds: thinkTime), () => aiMove());
    }
  }

  void _makeMove(int index, Player p) {
    AudioService().playClick();
    setState(() {
      board[index] = p;
      // Dispara a animação de escrita da célula
      _cellControllers[index].forward();
      evaluateAfterMove();
    });
  }

  void evaluateAfterMove() {
    final winner = checkWinner(board);
    
    if (winner != Player.none) {
      _finishGame(winner);
      return;
    }

    if (!board.contains(Player.none)) {
      _finishGame(Player.none); // Empate
      return;
    }

    // Troca turno
    current = (current == Player.X) ? Player.O : Player.X;
  }

  void _finishGame(Player winner) {
    gameOver = true;
    
    if (winner == Player.X) {
      xWins++;
      AudioService().playVictory();
      _saveGameResult(true); // Player X (Usuário) ganhou
    } else if (winner == Player.O) {
      oWins++;
      AudioService().playGameOver();
      // Se for vsAI, perdeu. Se for 2 players, O ganhou.
      _saveGameResult(mode == Mode.twoPlayers); 
    } else {
      draws++;
      _saveGameResult(false);
    }

    // Atualiza visual
    setState(() {});
  }

  Future<void> _saveGameResult(bool won) async {
    if (_gameStartTime == null) return;
    final timeSpent = DateTime.now().difference(_gameStartTime!).inSeconds;
    
    await _storage.saveMinigameRecord(
      'tictactoe',
      score: won ? 100 : 0,
      won: won,
      timeInSeconds: timeSpent,
    );
    
    if (won && mounted) {
        final records = await _storage.getMinigameRecords();
        final record = records.getRecord('tictactoe');
        final achievements = await _achievementService.checkMinigameAchievements(
            gameId: 'tictactoe',
            totalGamesPlayed: record.gamesPlayed,
            won: true,
            timeInSeconds: timeSpent
        );
        if (!mounted) return;
        for (var a in achievements) {
             showDialog(context: context, builder: (_) => AchievementUnlockDialog(achievement: a));
        }
    }
  }

  // --- Lógica da IA (Mantida e Otimizada) ---
  void aiMove() {
    if (gameOver) return;
    
    int move;
    if (aiDifficulty == AiDifficulty.easy) {
      final empties = List.generate(9, (i) => i).where((i) => board[i] == Player.none).toList();
      if (empties.isEmpty) return;
      move = empties[_rnd.nextInt(empties.length)];
    } else {
      move = findBestMove(board, Player.O);
    }
    _makeMove(move, Player.O);
  }

  int findBestMove(List<Player> b, Player p) {
    int bestVal = -1000;
    int bestMove = -1;
    for (int i = 0; i < 9; i++) {
      if (b[i] == Player.none) {
        b[i] = p;
        int moveVal = minimax(b, 0, false, p);
        b[i] = Player.none;
        if (moveVal > bestVal) {
          bestMove = i;
          bestVal = moveVal;
        }
      }
    }
    return bestMove != -1 ? bestMove : b.indexOf(Player.none);
  }

  int minimax(List<Player> b, int depth, bool isMax, Player aiPlayer) {
    final win = checkWinner(b, updateGlobal: false);
    if (win == aiPlayer) return 10 - depth;
    if (win != Player.none) return depth - 10;
    if (!b.contains(Player.none)) return 0;

    if (isMax) {
      int best = -1000;
      for (int i = 0; i < 9; i++) {
        if (b[i] == Player.none) {
          b[i] = aiPlayer;
          best = max(best, minimax(b, depth + 1, false, aiPlayer));
          b[i] = Player.none;
        }
      }
      return best;
    } else {
      Player opp = (aiPlayer == Player.X) ? Player.O : Player.X;
      int best = 1000;
      for (int i = 0; i < 9; i++) {
        if (b[i] == Player.none) {
          b[i] = opp;
          best = min(best, minimax(b, depth + 1, true, aiPlayer));
          b[i] = Player.none;
        }
      }
      return best;
    }
  }

  Player checkWinner(List<Player> b, {bool updateGlobal = true}) {
    const lines = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]];
    for (var line in lines) {
      if (b[line[0]] != Player.none && b[line[0]] == b[line[1]] && b[line[0]] == b[line[2]]) {
        if (updateGlobal) winningLine = line; // Salva a linha vencedora para desenhar o risco
        return b[line[0]];
      }
    }
    return Player.none;
  }

  // --- Widgets e UI ---

  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreItem("VOCÊ (X)", xWins, kNeonBlue),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildScoreItem("EMPATES", draws, Colors.white70),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildScoreItem(mode == Mode.vsAi ? "IA (O)" : "P2 (O)", oWins, kNeonPink),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, int score, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        const SizedBox(height: 5),
        Text("$score", style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold, shadows: [
          Shadow(color: color.withValues(alpha: 0.8), blurRadius: 10)
        ])),
      ],
    );
  }

  Widget _buildControlPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botão Modo
        _buildGlassButton(
          icon: mode == Mode.vsAi ? Icons.computer : Icons.people,
          label: mode == Mode.vsAi ? "vs IA" : "PvP",
          onTap: () {
            AudioService().playClick();
            setState(() {
              mode = mode == Mode.vsAi ? Mode.twoPlayers : Mode.vsAi;
              resetBoard();
            });
          },
        ),
        const SizedBox(width: 15),
        // Botão Reiniciar
        _buildGlassButton(
          icon: Icons.refresh_rounded,
          label: "Reiniciar",
          color: Colors.orangeAccent,
          onTap: () {
            AudioService().playClick();
            resetBoard();
          },
        ),
         if (mode == Mode.vsAi) ...[
            const SizedBox(width: 15),
            _buildGlassButton(
               icon: aiDifficulty == AiDifficulty.impossible ? Icons.bolt : Icons.sentiment_satisfied,
               label: aiDifficulty == AiDifficulty.impossible ? "Hard" : "Easy",
               color: aiDifficulty == AiDifficulty.impossible ? Colors.redAccent : Colors.greenAccent,
               onTap: (){
                   AudioService().playClick();
                   setState(() {
                       aiDifficulty = aiDifficulty == AiDifficulty.impossible ? AiDifficulty.easy : AiDifficulty.impossible;
                       resetBoard();
                   });
               }
            )
         ]
      ],
    );
  }

  Widget _buildGlassButton({required IconData icon, required String label, VoidCallback? onTap, Color color = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text(l10n.ticTacToeTitle, style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF162447),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildScoreBoard(),
              
              const Spacer(),
              
              // O Tabuleiro
              Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      // 1. A Grade (Desenhada)
                      CustomPaint(
                        size: Size.infinite,
                        painter: GridPainter(),
                      ),
                      
                      // 2. As Peças (Clicáveis e Animadas)
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque, // Importante para detectar toque em área vazia
                            onTap: () => handleTap(index),
                            child: AnimatedBuilder(
                              animation: _cellControllers[index],
                              builder: (context, child) {
                                return CustomPaint(
                                  painter: MarkPainter(
                                    player: board[index],
                                    progress: _cellControllers[index].value,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),

                      // 3. Linha de Vitória (Sobreposta)
                      if (gameOver && winningLine != null)
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return CustomPaint(
                              size: Size.infinite,
                              painter: WinningLinePainter(
                                lineIndices: winningLine!,
                                progress: value,
                                winner: checkWinner(board, updateGlobal: false),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),

              const Spacer(),
              _buildControlPanel(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// --- PAINTERS (O Segredo do Visual) ---

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kGridColor
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    // Efeito de sombra (Glow)
    final glowPaint = Paint()
      ..color = kGridColor.withValues(alpha: 0.5)
      ..strokeWidth = 12
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    double w = size.width;
    double h = size.height;
    double cellW = w / 3;
    double cellH = h / 3;
    double padding = 20;

    // Linhas Verticais
    _drawLine(canvas, Offset(cellW, padding), Offset(cellW, h - padding), paint, glowPaint);
    _drawLine(canvas, Offset(cellW * 2, padding), Offset(cellW * 2, h - padding), paint, glowPaint);

    // Linhas Horizontais
    _drawLine(canvas, Offset(padding, cellH), Offset(w - padding, cellH), paint, glowPaint);
    _drawLine(canvas, Offset(padding, cellH * 2), Offset(w - padding, cellH * 2), paint, glowPaint);
  }

  void _drawLine(Canvas canvas, Offset p1, Offset p2, Paint paint, Paint glow) {
    canvas.drawLine(p1, p2, glow);
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MarkPainter extends CustomPainter {
  final Player player;
  final double progress;

  MarkPainter({required this.player, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (player == Player.none || progress == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final s = size.width * 0.25; // Tamanho do símbolo

    if (player == Player.X) {
      final paint = Paint()
        ..color = kNeonBlue
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
        
      final glow = Paint()
        ..color = kNeonBlue.withValues(alpha: 0.6)
        ..strokeWidth = 15
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

      // Traço 1 (Esquerda-Cima para Direita-Baixo)
      if (progress > 0) {
        double p1 = (progress * 2).clamp(0.0, 1.0);
        Offset start = center - Offset(s, s);
        Offset end = center + Offset(s, s);
        Offset currentEnd = Offset.lerp(start, end, p1)!;
        canvas.drawLine(start, currentEnd, glow);
        canvas.drawLine(start, currentEnd, paint);
      }

      // Traço 2 (Direita-Cima para Esquerda-Baixo)
      if (progress > 0.5) {
        double p2 = ((progress - 0.5) * 2).clamp(0.0, 1.0);
        Offset start = center + Offset(s, -s);
        Offset end = center - Offset(s, -s);
        Offset currentEnd = Offset.lerp(start, end, p2)!;
        canvas.drawLine(start, currentEnd, glow);
        canvas.drawLine(start, currentEnd, paint);
      }

    } else { // Player O
      final paint = Paint()
        ..color = kNeonPink
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
        
       final glow = Paint()
        ..color = kNeonPink.withValues(alpha: 0.6)
        ..strokeWidth = 15
        ..style = PaintingStyle.stroke // Importante para o glow do circulo ser stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

      // Desenha o arco animado
      double sweepAngle = 2 * pi * progress;
      Rect rect = Rect.fromCircle(center: center, radius: s);
      
      canvas.drawArc(rect, -pi / 2, sweepAngle, false, glow);
      canvas.drawArc(rect, -pi / 2, sweepAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant MarkPainter oldDelegate) => 
    oldDelegate.progress != progress || oldDelegate.player != player;
}

class WinningLinePainter extends CustomPainter {
  final List<int> lineIndices;
  final double progress;
  final Player winner;

  WinningLinePainter({required this.lineIndices, required this.progress, required this.winner});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final color = winner == Player.X ? kNeonBlue : kNeonPink;
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
      
    final glow = Paint()
      ..color = color
      ..strokeWidth = 20
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    // Calcula coordenadas das células
    // Indice 0 é (0,0), Indice 8 é (2,2)
    int startIdx = lineIndices.first;
    int endIdx = lineIndices.last;

    double cellW = size.width / 3;
    double cellH = size.height / 3;

    // Centro da célula inicial
    double x1 = (startIdx % 3) * cellW + (cellW / 2);
    double y1 = (startIdx ~/ 3) * cellH + (cellH / 2);

    // Centro da célula final
    double x2 = (endIdx % 3) * cellW + (cellW / 2);
    double y2 = (endIdx ~/ 3) * cellH + (cellH / 2);

    Offset start = Offset(x1, y1);
    Offset end = Offset(x2, y2);
    Offset currentEnd = Offset.lerp(start, end, progress)!;

    canvas.drawLine(start, currentEnd, glow);
    canvas.drawLine(start, currentEnd, paint);
  }

  @override
  bool shouldRepaint(covariant WinningLinePainter oldDelegate) => oldDelegate.progress != progress;
}