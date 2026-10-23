import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/audio_service.dart';
import 'common/game_results.dart';
import 'common/game_text.dart';
import 'common/game_ui.dart';

// --- Constantes de Design ---
const Color kNeonBlue = Color(0xFF00F0FF);
const Color kNeonPink = Color(0xFFFF00AA);
const Color kGridColor = Color(0xFF2D2F45);
const Color kBackground = Color(0xFF10121B);

enum Player { X, O, none }
enum Mode { twoPlayers, vsAi }
enum AiDifficulty { easy, medium, hard }

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> with TickerProviderStateMixin {
  // Estado do jogo
  List<Player> board = List<Player>.filled(9, Player.none);
  Player current = Player.X;
  Mode mode = Mode.vsAi;
  AiDifficulty aiDifficulty = AiDifficulty.medium;
  bool xStarts = true;
  bool gameOver = false;
  Player? result; // vencedor (none = empate)
  List<int>? winningLine;

  // Placar da sessão
  int xWins = 0;
  int oWins = 0;
  int draws = 0;
  int streak = 0; // vitórias seguidas contra a IA

  DateTime? _gameStartTime;
  final Random _rnd = Random();
  int _generation = 0; // invalida jogadas da IA agendadas antes de reiniciar

  late List<AnimationController> _cellControllers;
  late final AnimationController _pulse =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    _cellControllers = List.generate(
        9, (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 400)));
    resetBoard();
  }

  @override
  void dispose() {
    _generation++;
    for (final c in _cellControllers) {
      c.dispose();
    }
    _pulse.dispose();
    super.dispose();
  }

  void resetBoard({bool alternate = false}) {
    _generation++;
    _gameStartTime = DateTime.now();
    setState(() {
      board = List<Player>.filled(9, Player.none);
      gameOver = false;
      result = null;
      winningLine = null;
      for (final c in _cellControllers) {
        c.reset();
      }
      if (alternate) xStarts = !xStarts;
      current = xStarts ? Player.X : Player.O;
    });
    if (mode == Mode.vsAi && current == Player.O) _scheduleAi(600);
  }

  void _scheduleAi(int ms) {
    final gen = _generation;
    Future.delayed(Duration(milliseconds: ms), () {
      if (!mounted || gen != _generation) return;
      aiMove();
    });
  }

  void handleTap(int index) {
    if (gameOver || board[index] != Player.none) return;
    if (mode == Mode.vsAi && current == Player.O) return;
    _makeMove(index, current);
    if (!gameOver && mode == Mode.vsAi && current == Player.O) {
      _scheduleAi(380 + _rnd.nextInt(420));
    }
  }

  void _makeMove(int index, Player p) {
    AudioService().playSfx('pop', volume: 0.8);
    HapticFeedback.selectionClick();
    setState(() {
      board[index] = p;
      _cellControllers[index].forward();
      _evaluateAfterMove();
    });
  }

  void _evaluateAfterMove() {
    final winner = checkWinner(board);
    if (winner != Player.none) {
      _finishGame(winner);
    } else if (!board.contains(Player.none)) {
      _finishGame(Player.none);
    } else {
      current = current == Player.X ? Player.O : Player.X;
    }
  }

  void _finishGame(Player winner) {
    gameOver = true;
    result = winner;
    final vsAi = mode == Mode.vsAi;
    if (winner == Player.X) {
      xWins++;
      if (vsAi) streak++;
      AudioService().playVictory();
      HapticFeedback.heavyImpact();
    } else if (winner == Player.O) {
      oWins++;
      if (vsAi) {
        streak = 0;
        AudioService().playGameOver();
      } else {
        AudioService().playVictory();
      }
    } else {
      draws++;
      AudioService().playSfx('mismatch', volume: 0.7);
    }
    _saveGameResult(winner);
  }

  Future<void> _saveGameResult(Player winner) async {
    final seconds = DateTime.now().difference(_gameStartTime ?? DateTime.now()).inSeconds;
    // Só conta como vitória o X contra a IA, ou qualquer vitória no 2 jogadores
    final won = winner == Player.X || (mode == Mode.twoPlayers && winner == Player.O);
    final levelBonus = {AiDifficulty.easy: 1, AiDifficulty.medium: 2, AiDifficulty.hard: 4}[aiDifficulty]!;
    await recordGameResult(context,
        gameId: 'tictactoe',
        won: won && mode == Mode.vsAi,
        score: won && mode == Mode.vsAi ? 100 * levelBonus + streak * 10 : 0,
        seconds: seconds);
  }

  // --- IA ---
  void aiMove() {
    if (gameOver) return;
    final empties = [for (int i = 0; i < 9; i++) if (board[i] == Player.none) i];
    if (empties.isEmpty) return;

    int move;
    switch (aiDifficulty) {
      case AiDifficulty.easy:
        // Ganha se puder, senão joga ao acaso (quase nunca bloqueia)
        move = _winningMove(Player.O) ?? empties[_rnd.nextInt(empties.length)];
        break;
      case AiDifficulty.medium:
        // Ganha/bloqueia sempre; no resto joga perfeito em 55% das vezes
        move = _winningMove(Player.O) ??
            _winningMove(Player.X) ??
            (_rnd.nextDouble() < 0.55 ? findBestMove(board, Player.O) : empties[_rnd.nextInt(empties.length)]);
        break;
      case AiDifficulty.hard:
        move = findBestMove(board, Player.O);
        break;
    }
    _makeMove(move, Player.O);
  }

  int? _winningMove(Player p) {
    for (int i = 0; i < 9; i++) {
      if (board[i] != Player.none) continue;
      board[i] = p;
      final w = checkWinner(board, updateGlobal: false);
      board[i] = Player.none;
      if (w == p) return i;
    }
    return null;
  }

  int findBestMove(List<Player> b, Player p) {
    int bestVal = -1000;
    final best = <int>[];
    for (int i = 0; i < 9; i++) {
      if (b[i] == Player.none) {
        b[i] = p;
        final val = minimax(b, 0, false, p);
        b[i] = Player.none;
        if (val > bestVal) {
          bestVal = val;
          best
            ..clear()
            ..add(i);
        } else if (val == bestVal) {
          best.add(i);
        }
      }
    }
    // Varia entre jogadas igualmente boas para não ficar repetitivo
    return best.isEmpty ? b.indexOf(Player.none) : best[_rnd.nextInt(best.length)];
  }

  int minimax(List<Player> b, int depth, bool isMax, Player aiPlayer) {
    final win = checkWinner(b, updateGlobal: false);
    if (win == aiPlayer) return 10 - depth;
    if (win != Player.none) return depth - 10;
    if (!b.contains(Player.none)) return 0;
    final opp = aiPlayer == Player.X ? Player.O : Player.X;
    int best = isMax ? -1000 : 1000;
    for (int i = 0; i < 9; i++) {
      if (b[i] == Player.none) {
        b[i] = isMax ? aiPlayer : opp;
        final v = minimax(b, depth + 1, !isMax, aiPlayer);
        b[i] = Player.none;
        best = isMax ? max(best, v) : min(best, v);
      }
    }
    return best;
  }

  Player checkWinner(List<Player> b, {bool updateGlobal = true}) {
    const lines = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]];
    for (final line in lines) {
      if (b[line[0]] != Player.none && b[line[0]] == b[line[1]] && b[line[0]] == b[line[2]]) {
        if (updateGlobal) winningLine = line;
        return b[line[0]];
      }
    }
    return Player.none;
  }

  // --- UI ---

  String get _xName => mode == Mode.vsAi ? t3('VOCÊ', 'YOU', 'TÚ') : t3('JOGADOR 1', 'PLAYER 1', 'JUGADOR 1');
  String get _oName => mode == Mode.vsAi ? t3('IA', 'AI', 'IA') : t3('JOGADOR 2', 'PLAYER 2', 'JUGADOR 2');

  String get _statusText {
    if (gameOver) {
      if (result == Player.none) return t3('Empate! 🤝', 'Draw! 🤝', '¡Empate! 🤝');
      if (result == Player.X) {
        return mode == Mode.vsAi ? t3('Você venceu! 🎉', 'You win! 🎉', '¡Ganaste! 🎉') : t3('Jogador 1 venceu! 🎉', 'Player 1 wins! 🎉', '¡Jugador 1 ganó! 🎉');
      }
      return mode == Mode.vsAi ? t3('A IA venceu 🤖', 'The AI wins 🤖', 'La IA ganó 🤖') : t3('Jogador 2 venceu! 🎉', 'Player 2 wins! 🎉', '¡Jugador 2 ganó! 🎉');
    }
    if (mode == Mode.vsAi) {
      return current == Player.X ? t3('Sua vez (X)', 'Your turn (X)', 'Tu turno (X)') : t3('IA pensando…', 'AI thinking…', 'IA pensando…');
    }
    return current == Player.X ? t3('Vez do Jogador 1 (X)', 'Player 1 turn (X)', 'Turno Jugador 1 (X)') : t3('Vez do Jogador 2 (O)', 'Player 2 turn (O)', 'Turno Jugador 2 (O)');
  }

  Color get _statusColor {
    if (gameOver) {
      if (result == Player.X) return kNeonBlue;
      if (result == Player.O) return kNeonPink;
      return Colors.white70;
    }
    return current == Player.X ? kNeonBlue : kNeonPink;
  }

  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreItem('$_xName (X)', xWins, kNeonBlue, !gameOver && current == Player.X),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildScoreItem(t3('EMPATES', 'DRAWS', 'EMPATES'), draws, Colors.white70, false),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildScoreItem('$_oName (O)', oWins, kNeonPink, !gameOver && current == Player.O),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, int score, Color color, bool active) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: gameOver || active || color == Colors.white70 ? 1 : 0.55,
      child: Column(
        children: [
          Text(label,
              style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
          const SizedBox(height: 5),
          Text('$score',
              style: TextStyle(
                  color: color,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: color.withValues(alpha: 0.8), blurRadius: 10)])),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            _segment(t3('vs IA', 'vs AI', 'vs IA'), Icons.smart_toy_rounded, mode == Mode.vsAi, () {
              mode = Mode.vsAi;
              streak = 0;
              xWins = oWins = draws = 0;
              resetBoard();
            }),
            _segment(t3('2 jogadores', '2 players', '2 jugadores'), Icons.people_alt_rounded, mode == Mode.twoPlayers, () {
              mode = Mode.twoPlayers;
              xWins = oWins = draws = 0;
              resetBoard();
            }),
          ],
        ),
        if (mode == Mode.vsAi) ...[
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final d in AiDifficulty.values) ...[
                _segment(
                  {
                    AiDifficulty.easy: t3('Fácil', 'Easy', 'Fácil'),
                    AiDifficulty.medium: t3('Médio', 'Medium', 'Medio'),
                    AiDifficulty.hard: t3('Difícil', 'Hard', 'Difícil'),
                  }[d]!,
                  {AiDifficulty.easy: Icons.sentiment_satisfied_alt, AiDifficulty.medium: Icons.psychology_alt, AiDifficulty.hard: Icons.bolt}[d]!,
                  aiDifficulty == d,
                  () {
                    aiDifficulty = d;
                    streak = 0;
                    resetBoard();
                  },
                  color: {AiDifficulty.easy: Colors.greenAccent, AiDifficulty.medium: Colors.amberAccent, AiDifficulty.hard: Colors.redAccent}[d]!,
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _segment(String label, IconData icon, bool selected, VoidCallback onTap, {Color color = Colors.white}) {
    return GestureDetector(
      onTap: () {
        AudioService().playClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.16) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? color : Colors.white12, width: selected ? 1.6 : 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? color : Colors.white54, size: 17),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(color: selected ? color : Colors.white60, fontWeight: FontWeight.w700, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: t3('⭕ Jogo da Velha', '⭕ Tic-Tac-Toe', '⭕ Tres en Raya'),
      accent: kNeonBlue,
      backgroundColors: const [Color(0xFF151A2E), kBackground],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
        child: Column(
          children: [
            _buildScoreBoard(),
            const SizedBox(height: 14),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, a) => ScaleTransition(scale: a, child: child),
              child: Text(
                _statusText,
                key: ValueKey(_statusText),
                style: TextStyle(
                  color: _statusColor,
                  fontSize: gameOver ? 24 : 18,
                  fontWeight: FontWeight.w900,
                  shadows: [Shadow(color: _statusColor.withValues(alpha: 0.7), blurRadius: 12)],
                ),
              ),
            ),
            if (mode == Mode.vsAi && streak >= 2)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(t3('🔥 $streak vitórias seguidas', '🔥 $streak wins in a row', '🔥 $streak victorias seguidas'),
                    style: const TextStyle(color: GameColors.gold, fontWeight: FontWeight.w700)),
              ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      const Positioned.fill(child: CustomPaint(painter: GridPainter())),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          final isWinCell = gameOver && (winningLine?.contains(index) ?? false);
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => handleTap(index),
                            child: AnimatedBuilder(
                              animation: Listenable.merge([_cellControllers[index], _pulse]),
                              builder: (context, child) {
                                final scale = isWinCell ? 1.0 + _pulse.value * 0.12 : 1.0;
                                return Transform.scale(
                                  scale: scale,
                                  child: CustomPaint(
                                    painter: MarkPainter(
                                      player: board[index],
                                      progress: Curves.easeOutBack.transform(_cellControllers[index].value).clamp(0.0, 1.0),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      if (gameOver && winningLine != null)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 450),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) => CustomPaint(
                                painter: WinningLinePainter(
                                  lineIndices: winningLine!,
                                  progress: value,
                                  winner: result ?? Player.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: gameOver
                  ? Padding(
                      key: const ValueKey('again'),
                      padding: const EdgeInsets.only(bottom: 10),
                      child: PillButton(
                        label: t3('Próxima partida', 'Next round', 'Siguiente partida'),
                        icon: Icons.replay_rounded,
                        color: kNeonBlue,
                        onTap: () => resetBoard(alternate: true),
                      ),
                    )
                  : const SizedBox(key: ValueKey('none'), height: 0),
            ),
            _buildSettings(),
          ],
        ),
      ),
    );
  }
}

// --- PAINTERS (O Segredo do Visual) ---

class GridPainter extends CustomPainter {
  const GridPainter();
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