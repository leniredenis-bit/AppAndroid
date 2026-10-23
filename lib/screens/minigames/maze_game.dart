import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/audio_service.dart';
import 'common/game_results.dart';
import 'common/game_text.dart';
import 'common/game_ui.dart';

const Color _accent = Color(0xFFFFA94D);
const int _levelCount = 30;

/// Labirinto gerado (grade de células: true = parede).
class MazeData {
  final int rows, cols;
  final List<List<bool>> wall;
  final Point<int> start, exit;
  final List<Point<int>> gems;
  MazeData(this.rows, this.cols, this.wall, this.start, this.exit, this.gems);

  bool open(int r, int c) => r >= 0 && r < rows && c >= 0 && c < cols && !wall[r][c];

  int exits(int r, int c) =>
      (open(r - 1, c) ? 1 : 0) + (open(r + 1, c) ? 1 : 0) + (open(r, c - 1) ? 1 : 0) + (open(r, c + 1) ? 1 : 0);
}

class MazeGenerator {
  /// Labirinto perfeito (backtracking iterativo) com alguns atalhos extras.
  static MazeData generate(int cellsH, int cellsW, {required int seed, double braid = 0.08}) {
    final rnd = Random(seed);
    final rows = cellsH * 2 + 1, cols = cellsW * 2 + 1;
    final wall = List.generate(rows, (_) => List.filled(cols, true));
    final stack = <Point<int>>[const Point(1, 1)];
    wall[1][1] = false;
    while (stack.isNotEmpty) {
      final cur = stack.last;
      final dirs = [const Point(-2, 0), const Point(2, 0), const Point(0, -2), const Point(0, 2)]..shuffle(rnd);
      bool moved = false;
      for (final d in dirs) {
        final nr = cur.x + d.x, nc = cur.y + d.y;
        if (nr > 0 && nr < rows - 1 && nc > 0 && nc < cols - 1 && wall[nr][nc]) {
          wall[cur.x + d.x ~/ 2][cur.y + d.y ~/ 2] = false;
          wall[nr][nc] = false;
          stack.add(Point(nr, nc));
          moved = true;
          break;
        }
      }
      if (!moved) stack.removeLast();
    }
    // Atalhos: abre algumas paredes internas entre dois corredores
    for (int r = 1; r < rows - 1; r++) {
      for (int c = 1; c < cols - 1; c++) {
        if (!wall[r][c] || rnd.nextDouble() > braid) continue;
        final horiz = !wall[r][c - 1] && !wall[r][c + 1] && wall[r - 1][c] && wall[r + 1][c];
        final vert = !wall[r - 1][c] && !wall[r + 1][c] && wall[r][c - 1] && wall[r][c + 1];
        if (horiz || vert) wall[r][c] = false;
      }
    }

    // Saída = célula mais distante da entrada
    const start = Point(1, 1);
    final dist = _bfs(wall, rows, cols, start);
    Point<int> exit = start;
    int best = -1;
    dist.forEach((p, d) {
      if (d > best) {
        best = d;
        exit = p;
      }
    });

    // Gemas em becos sem saída distantes entre si
    final temp = MazeData(rows, cols, wall, start, exit, const []);
    final deadEnds = dist.keys.where((p) => p != start && p != exit && temp.exits(p.x, p.y) == 1).toList()
      ..sort((a, b) => dist[b]!.compareTo(dist[a]!));
    final gems = <Point<int>>[];
    for (final p in deadEnds) {
      if (gems.length == 3) break;
      if (gems.every((g) => (g.x - p.x).abs() + (g.y - p.y).abs() > (rows + cols) ~/ 5)) gems.add(p);
    }
    for (final p in dist.keys) {
      if (gems.length == 3) break;
      if (p != start && p != exit && !gems.contains(p) && dist[p]! > best ~/ 3) gems.add(p);
    }
    return MazeData(rows, cols, wall, start, exit, gems);
  }

  static Map<Point<int>, int> _bfs(List<List<bool>> wall, int rows, int cols, Point<int> from) {
    final dist = <Point<int>, int>{from: 0};
    final q = Queue<Point<int>>()..add(from);
    while (q.isNotEmpty) {
      final p = q.removeFirst();
      for (final d in const [Point(-1, 0), Point(1, 0), Point(0, -1), Point(0, 1)]) {
        final n = Point(p.x + d.x, p.y + d.y);
        if (n.x < 0 || n.x >= rows || n.y < 0 || n.y >= cols || wall[n.x][n.y] || dist.containsKey(n)) continue;
        dist[n] = dist[p]! + 1;
        q.add(n);
      }
    }
    return dist;
  }
}

class MazeGame extends StatefulWidget {
  const MazeGame({super.key});

  @override
  State<MazeGame> createState() => _MazeGameState();
}

class _MazeGameState extends State<MazeGame> with SingleTickerProviderStateMixin {
  final _audio = AudioService();
  final FocusNode _focus = FocusNode();
  late final Ticker _ticker;

  // Progresso salvo
  int _unlocked = 1;
  final Map<int, int> _stars = {};

  // Partida
  bool _playing = false;
  int _level = 1;
  MazeData? _maze;
  Point<int> _cell = const Point(1, 1);
  Offset _visual = const Offset(1, 1); // (coluna, linha) contínuo
  final Queue<Point<int>> _queue = Queue();
  Point<int> _facing = const Point(0, 1);
  final Set<Point<int>> _gemsTaken = {};
  final List<Point<int>> _trail = [];
  late List<List<bool>> _seen;
  int _moves = 0;
  int _seconds = 0;
  Timer? _clock;
  bool _won = false;
  bool _showMap = false;
  double _anim = 0;

  // Controles
  Offset? _swipeStart;
  Timer? _holdTimer;
  Point<int>? _holdDir;

  // Cache de desenho
  ui.Picture? _mazePicture;
  double _pictureTile = 0;
  Duration _lastTick = Duration.zero;

  bool get _dark => _level >= 6 && _level % 3 == 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
    _audio.playBackgroundMusic('home');
    _loadProgress();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _clock?.cancel();
    _holdTimer?.cancel();
    _focus.dispose();
    _mazePicture?.dispose();
    _audio.stopBackgroundMusic();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _unlocked = prefs.getInt('maze_unlocked') ?? 1;
      for (int l = 1; l <= _levelCount; l++) {
        _stars[l] = prefs.getInt('maze_stars_$l') ?? 0;
      }
    });
  }

  void _startLevel(int level) {
    final cells = min(5 + level, 20);
    final maze = MazeGenerator.generate(cells, (cells * 0.85).round().clamp(5, 18),
        seed: level * 7349 + 11, braid: level < 4 ? 0.12 : 0.06);
    _mazePicture?.dispose();
    _mazePicture = null;
    setState(() {
      _level = level;
      _maze = maze;
      _playing = true;
      _won = false;
      _showMap = false;
      _cell = maze.start;
      _visual = Offset(maze.start.y.toDouble(), maze.start.x.toDouble());
      _queue.clear();
      _gemsTaken.clear();
      _trail.clear();
      _seen = List.generate(maze.rows, (_) => List.filled(maze.cols, false));
      _moves = 0;
      _seconds = 0;
    });
    _reveal();
    _clock?.cancel();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && !_won) setState(() => _seconds++);
    });
    if (!_ticker.isActive) _ticker.start();
    _focus.requestFocus();
  }

  void _reveal() {
    final m = _maze!;
    for (int dr = -4; dr <= 4; dr++) {
      for (int dc = -4; dc <= 4; dc++) {
        final r = _cell.x + dr, c = _cell.y + dc;
        if (r >= 0 && r < m.rows && c >= 0 && c < m.cols && dr * dr + dc * dc <= 13) _seen[r][c] = true;
      }
    }
  }

  // ==========================================================================
  // MOVIMENTO
  // ==========================================================================

  Point<int> get _queueEnd => _queue.isEmpty ? _cell : _queue.last;

  /// Desliza na direção até chegar numa bifurcação, beco ou objetivo,
  /// seguindo as curvas dos corredores.
  void _glide(Point<int> d) {
    if (_won || _maze == null) return;
    final m = _maze!;
    var pos = _queueEnd;
    var dir = d;
    if (!m.open(pos.x + dir.x, pos.y + dir.y)) {
      _audio.playSfx('bump', volume: 0.5);
      HapticFeedback.lightImpact();
      return;
    }
    int guard = 0;
    while (guard++ < 400) {
      final next = Point(pos.x + dir.x, pos.y + dir.y);
      if (!m.open(next.x, next.y)) break;
      _queue.add(next);
      pos = next;
      if (next == m.exit || (m.gems.contains(next) && !_gemsTaken.contains(next))) break;
      if (m.exits(next.x, next.y) != 2) break; // bifurcação ou beco
      // Corredor: segue a única saída que não é a de volta
      final back = Point(-dir.x, -dir.y);
      for (final nd in const [Point(-1, 0), Point(1, 0), Point(0, -1), Point(0, 1)]) {
        if (nd == back) continue;
        if (m.open(next.x + nd.x, next.y + nd.y)) {
          dir = nd;
          break;
        }
      }
    }
  }

  void _step(Point<int> d) {
    if (_won || _maze == null || _queue.length > 1) return;
    final from = _queueEnd;
    final next = Point(from.x + d.x, from.y + d.y);
    if (_maze!.open(next.x, next.y)) {
      _queue.add(next);
    } else if (_queue.isEmpty) {
      _facing = d;
      _audio.playSfx('bump', volume: 0.4);
    }
  }

  void _startHold(Point<int> d) {
    _holdDir = d;
    _step(d);
    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(const Duration(milliseconds: 95), (_) {
      if (_holdDir != null) _step(_holdDir!);
    });
    HapticFeedback.selectionClick();
  }

  void _endHold() {
    _holdDir = null;
    _holdTimer?.cancel();
  }

  void _tick(Duration elapsed) {
    final dt = _lastTick == Duration.zero ? 0.016 : (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    _anim += dt;
    if (_maze == null) return;

    if (_queue.isNotEmpty) {
      final target = _queue.first;
      final tv = Offset(target.y.toDouble(), target.x.toDouble());
      final delta = tv - _visual;
      final speed = 10.5 * dt;
      if (delta.distance <= speed) {
        _visual = tv;
        _facing = Point(target.x - _cell.x, target.y - _cell.y);
        _cell = target;
        _queue.removeFirst();
        _moves++;
        _trail.add(target);
        if (_trail.length > 40) _trail.removeAt(0);
        _reveal();
        _arrive(target);
      } else {
        _visual += delta / delta.distance * speed;
      }
    }
    if (mounted) setState(() {});
  }

  void _arrive(Point<int> p) {
    final m = _maze!;
    if (_moves % 2 == 0) _audio.playSfx('step', volume: 0.35);
    if (m.gems.contains(p) && _gemsTaken.add(p)) {
      _audio.playSfx('gem');
      HapticFeedback.mediumImpact();
    }
    if (p == m.exit) _win();
  }

  Future<void> _win() async {
    _won = true;
    _queue.clear();
    _endHold();
    _clock?.cancel();
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final stars = max(1, _gemsTaken.length);
    final prefs = await SharedPreferences.getInstance();
    if (stars > (_stars[_level] ?? 0)) {
      _stars[_level] = stars;
      await prefs.setInt('maze_stars_$_level', stars);
    }
    if (_level + 1 > _unlocked && _level < _levelCount) {
      _unlocked = _level + 1;
      await prefs.setInt('maze_unlocked', _unlocked);
    }
    if (!mounted) return;
    final score = _level * 100 + _gemsTaken.length * 50 - _seconds;
    final saved = await recordGameResult(context, gameId: 'maze', won: true, score: max(10, score), seconds: _seconds);
    if (!mounted) return;
    final last = _level >= _levelCount;
    await showGameResult(
      context,
      won: true,
      accent: _accent,
      title: t3('Nível $_level concluído!', 'Level $_level complete!', '¡Nivel $_level completado!'),
      subtitle: _gemsTaken.length < 3
          ? t3('Pegue as 3 gemas para 3 estrelas', 'Collect all 3 gems for 3 stars', 'Recoge las 3 gemas para 3 estrellas')
          : null,
      stars: stars,
      newRecord: saved.newRecord,
      stats: [
        ResultStat('⏱️', t3('Tempo', 'Time', 'Tiempo'), formatGameTime(_seconds)),
        ResultStat('💎', t3('Gemas', 'Gems', 'Gemas'), '${_gemsTaken.length}/3'),
        ResultStat('👣', t3('Passos', 'Steps', 'Pasos'), '$_moves'),
      ],
      primaryLabel: last ? t3('Jogar de novo', 'Play again', 'Jugar de nuevo') : t3('Próximo nível', 'Next level', 'Siguiente nivel'),
      onPrimary: () => _startLevel(last ? _level : _level + 1),
      secondaryLabel: t3('Escolher nível', 'Choose level', 'Elegir nivel'),
      onSecondary: _toMenu,
    );
  }

  void _toMenu() {
    _clock?.cancel();
    _ticker.stop();
    _lastTick = Duration.zero;
    setState(() => _playing = false);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    if (!_playing || e is! KeyDownEvent) return KeyEventResult.ignored;
    final map = <LogicalKeyboardKey, Point<int>>{
      LogicalKeyboardKey.arrowUp: Point(-1, 0), LogicalKeyboardKey.keyW: Point(-1, 0),
      LogicalKeyboardKey.arrowDown: Point(1, 0), LogicalKeyboardKey.keyS: Point(1, 0),
      LogicalKeyboardKey.arrowLeft: Point(0, -1), LogicalKeyboardKey.keyA: Point(0, -1),
      LogicalKeyboardKey.arrowRight: Point(0, 1), LogicalKeyboardKey.keyD: Point(0, 1),
    };
    final d = map[e.logicalKey];
    if (d == null) return KeyEventResult.ignored;
    _glide(d);
    return KeyEventResult.handled;
  }

  // ==========================================================================
  // UI
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: t3('🌀 Labirinto', '🌀 Maze', '🌀 Laberinto'),
      accent: _accent,
      onBack: _playing ? _toMenu : null,
      backgroundColors: const [Color(0xFF2B1D14), Color(0xFF140D08)],
      body: Focus(
        focusNode: _focus,
        autofocus: true,
        onKeyEvent: _onKey,
        child: _playing ? _buildGame() : _buildMenu(),
      ),
    );
  }

  Widget _buildMenu() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      children: [
        GameHero(
          emoji: '🔦',
          title: t3('Cavernas do Labirinto', 'Maze Caverns', 'Cavernas del Laberinto'),
          subtitle: t3('Deslize para correr pelos corredores, pegue as 3 gemas e encontre a saída',
              'Swipe to run through corridors, grab the 3 gems and find the exit',
              'Desliza para correr por los pasillos, toma las 3 gemas y encuentra la salida'),
          accent: _accent,
        ),
        const SizedBox(height: 20),
        PillButton(
          label: t3('Continuar · nível $_unlocked', 'Continue · level $_unlocked', 'Continuar · nivel $_unlocked'),
          icon: Icons.play_arrow_rounded,
          color: _accent,
          expand: true,
          onTap: () => _startLevel(_unlocked),
        ),
        const SizedBox(height: 18),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.9),
          itemCount: _levelCount,
          itemBuilder: (context, i) {
            final level = i + 1;
            final locked = level > _unlocked;
            final stars = _stars[level] ?? 0;
            final dark = level >= 6 && level % 3 == 0;
            return GestureDetector(
              onTap: locked
                  ? null
                  : () {
                      _audio.playClick();
                      _startLevel(level);
                    },
              child: Container(
                decoration: BoxDecoration(
                  color: locked ? Colors.black26 : (dark ? const Color(0xFF2A2140) : const Color(0xFF4A3220)),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: level == _unlocked ? _accent : Colors.white12, width: level == _unlocked ? 2 : 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (locked)
                      const Icon(Icons.lock_rounded, color: Colors.white30, size: 20)
                    else
                      Text('$level', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          3,
                          (s) => Icon(Icons.star_rounded,
                              size: 11, color: s < stars ? GameColors.gold : Colors.white.withValues(alpha: 0.15))),
                    ),
                    if (dark && !locked) const Text('🔦', style: TextStyle(fontSize: 9)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGame() {
    final m = _maze!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    HudChip(emoji: '🏔️', value: '$_level', color: _accent, highlight: true),
                    HudChip(emoji: '⏱️', value: formatGameTime(_seconds)),
                    HudChip(
                        emoji: '💎',
                        value: '${_gemsTaken.length}/${m.gems.length}',
                        color: const Color(0xFF67E8F9),
                        highlight: _gemsTaken.isNotEmpty),
                  ],
                ),
              ),
              if (!_dark)
                GestureDetector(
                  onTapDown: (_) => setState(() => _showMap = true),
                  onTapUp: (_) => setState(() => _showMap = false),
                  onTapCancel: () => setState(() => _showMap = false),
                  child: const HudChip(emoji: '🗺️', value: ''),
                ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, c) {
            final view = Size(c.maxWidth, c.maxHeight);
            final fitTile = min(view.width / m.cols, view.height / m.rows);
            final tile = _showMap ? fitTile : max(fitTile, min(40.0, view.shortestSide / 9));
            if (_mazePicture == null || _pictureTile != tile) {
              _mazePicture?.dispose();
              _mazePicture = _recordMaze(m, tile);
              _pictureTile = tile;
            }
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (d) => _swipeStart = d.localPosition,
              onPanUpdate: (d) {
                final s = _swipeStart;
                if (s == null) return;
                final v = d.localPosition - s;
                if (v.distance < 22) return;
                _swipeStart = null;
                _glide(v.dx.abs() > v.dy.abs() ? Point(0, v.dx.sign.toInt()) : Point(v.dy.sign.toInt(), 0));
              },
              onPanEnd: (_) => _swipeStart = null,
              child: ClipRect(
                child: CustomPaint(
                  size: view,
                  painter: _MazePainter(
                    maze: m,
                    picture: _mazePicture!,
                    tile: tile,
                    view: view,
                    player: _visual,
                    facing: _facing,
                    gemsTaken: _gemsTaken,
                    trail: _trail,
                    seen: _seen,
                    dark: _dark && !_showMap,
                    t: _anim,
                  ),
                ),
              ),
            );
          }),
        ),
        _dpad(),
      ],
    );
  }

  Widget _dpad() {
    Widget btn(IconData icon, Point<int> d) {
      return Listener(
        onPointerDown: (_) => _startHold(d),
        onPointerUp: (_) => _endHold(),
        onPointerCancel: (_) => _endHold(),
        child: Container(
          width: 58,
          height: 50,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: GameColors.panel.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _accent.withValues(alpha: 0.4)),
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          btn(Icons.keyboard_arrow_left_rounded, const Point(0, -1)),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              btn(Icons.keyboard_arrow_up_rounded, const Point(-1, 0)),
              btn(Icons.keyboard_arrow_down_rounded, const Point(1, 0)),
            ],
          ),
          btn(Icons.keyboard_arrow_right_rounded, const Point(0, 1)),
        ],
      ),
    );
  }

  /// Grava o labirinto estático (chão + paredes) uma vez por nível/zoom.
  ui.Picture _recordMaze(MazeData m, double t) {
    final rec = ui.PictureRecorder();
    final canvas = Canvas(rec);
    final floor = Paint()..color = const Color(0xFFC9A57A);
    final floorDot = Paint()..color = const Color(0x22000000);
    final wallBase = Paint()..color = const Color(0xFF4A3426);
    final wallTop = Paint()..color = const Color(0xFF6E4E38);
    final shadow = Paint()..color = const Color(0x55000000);
    final rnd = Random(m.rows * 31 + m.cols);

    canvas.drawRect(Rect.fromLTWH(0, 0, m.cols * t, m.rows * t), floor);
    for (int r = 0; r < m.rows; r++) {
      for (int c = 0; c < m.cols; c++) {
        if (!m.wall[r][c]) {
          if (rnd.nextDouble() < 0.5) {
            canvas.drawCircle(Offset((c + rnd.nextDouble()) * t, (r + rnd.nextDouble()) * t), t * 0.04, floorDot);
          }
          continue;
        }
        final rect = Rect.fromLTWH(c * t, r * t, t, t);
        if (r + 1 < m.rows && !m.wall[r + 1][c]) {
          canvas.drawRect(Rect.fromLTWH(c * t, (r + 1) * t, t, t * 0.22), shadow);
        }
        canvas.drawRect(rect, wallBase);
        canvas.drawRRect(
            RRect.fromRectAndRadius(Rect.fromLTWH(rect.left + 1, rect.top + 1, t - 2, t * 0.72), Radius.circular(t * 0.18)),
            wallTop);
      }
    }
    return rec.endRecording();
  }
}

class _MazePainter extends CustomPainter {
  final MazeData maze;
  final ui.Picture picture;
  final double tile;
  final Size view;
  final Offset player; // (coluna, linha)
  final Point<int> facing;
  final Set<Point<int>> gemsTaken;
  final List<Point<int>> trail;
  final List<List<bool>> seen;
  final bool dark;
  final double t;

  _MazePainter({
    required this.maze, required this.picture, required this.tile, required this.view, required this.player,
    required this.facing, required this.gemsTaken, required this.trail, required this.seen, required this.dark,
    required this.t,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final mazeW = maze.cols * tile, mazeH = maze.rows * tile;
    final pp = Offset((player.dx + 0.5) * tile, (player.dy + 0.5) * tile);
    final cam = Offset(
      mazeW <= size.width ? (mazeW - size.width) / 2 : (pp.dx - size.width / 2).clamp(0.0, mazeW - size.width),
      mazeH <= size.height ? (mazeH - size.height) / 2 : (pp.dy - size.height / 2).clamp(0.0, mazeH - size.height),
    );
    canvas.save();
    canvas.translate(-cam.dx, -cam.dy);
    canvas.drawPicture(picture);

    // Rastro
    for (int i = 0; i < trail.length; i++) {
      final p = trail[i];
      canvas.drawCircle(Offset((p.y + 0.5) * tile, (p.x + 0.5) * tile), tile * 0.08,
          Paint()..color = Colors.white.withValues(alpha: 0.05 + 0.25 * i / trail.length));
    }

    // Saída: portal pulsante
    final ex = Offset((maze.exit.y + 0.5) * tile, (maze.exit.x + 0.5) * tile);
    for (int k = 0; k < 3; k++) {
      final ph = (t * 0.8 + k / 3) % 1;
      canvas.drawCircle(
          ex,
          tile * (0.2 + ph * 0.6),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = tile * 0.06
            ..color = const Color(0xFFFFE066).withValues(alpha: 1 - ph));
    }
    canvas.drawCircle(ex, tile * 0.34,
        Paint()..shader = ui.Gradient.radial(ex, tile * 0.34, [Colors.white, const Color(0xFFFFC94A), const Color(0x00FFC94A)], [0, 0.4, 1]));

    // Gemas
    for (final g in maze.gems) {
      if (gemsTaken.contains(g)) continue;
      final c = Offset((g.y + 0.5) * tile, (g.x + 0.5) * tile + sin(t * 3 + g.x) * tile * 0.06);
      final s = tile * 0.28;
      canvas.drawCircle(c, s * 1.4, Paint()..color = const Color(0x4467E8F9)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      final gem = Path()
        ..moveTo(c.dx, c.dy - s)
        ..lineTo(c.dx + s * 0.8, c.dy - s * 0.2)
        ..lineTo(c.dx, c.dy + s)
        ..lineTo(c.dx - s * 0.8, c.dy - s * 0.2)
        ..close();
      canvas.drawPath(gem, Paint()..color = const Color(0xFF22D3EE));
      canvas.drawPath(
          Path()
            ..moveTo(c.dx, c.dy - s)
            ..lineTo(c.dx + s * 0.8, c.dy - s * 0.2)
            ..lineTo(c.dx, c.dy - s * 0.05)
            ..close(),
          Paint()..color = const Color(0xFFA5F3FC));
      canvas.drawPath(gem, Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = Colors.white70);
    }

    _drawPlayer(canvas, pp);

    // Escuridão com luz da lanterna
    if (dark) {
      final world = Rect.fromLTWH(cam.dx, cam.dy, size.width, size.height);
      canvas.saveLayer(world, Paint());
      canvas.drawRect(world, Paint()..color = const Color(0xFB050302));
      final clear = Paint()..blendMode = BlendMode.dstOut;
      clear.color = Colors.black.withValues(alpha: 0.28);
      for (int r = 0; r < maze.rows; r++) {
        for (int c = 0; c < maze.cols; c++) {
          if (seen[r][c]) canvas.drawRect(Rect.fromLTWH(c * tile, r * tile, tile + 0.5, tile + 0.5), clear);
        }
      }
      final light = tile * (4.2 + sin(t * 9) * 0.08);
      canvas.drawCircle(
          pp,
          light,
          Paint()
            ..blendMode = BlendMode.dstOut
            ..shader = ui.Gradient.radial(pp, light, [Colors.black, Colors.black, Colors.black.withValues(alpha: 0)], [0, 0.55, 1]));
      canvas.restore();
    }
    canvas.restore();
  }

  void _drawPlayer(Canvas canvas, Offset c) {
    final s = tile;
    final moving = (player.dx - player.dx.round()).abs() + (player.dy - player.dy.round()).abs() > 0.02;
    final bob = moving ? sin(t * 22).abs() * s * 0.06 : 0.0;
    final body = c - Offset(0, bob);
    canvas.drawOval(Rect.fromCenter(center: c + Offset(0, s * 0.3), width: s * 0.5, height: s * 0.14),
        Paint()..color = Colors.black.withValues(alpha: 0.3));
    // corpo
    canvas.drawCircle(body, s * 0.3, Paint()..color = const Color(0xFF3B82F6));
    canvas.drawCircle(body + Offset(0, s * 0.02), s * 0.22, Paint()..color = const Color(0xFFF2C29B));
    // olhos olhando para a direção
    final look = Offset(facing.y.toDouble(), facing.x.toDouble()) * s * 0.05;
    final eye = Paint()..color = const Color(0xFF2B1B10);
    canvas.drawCircle(body + Offset(-s * 0.08, s * 0.02) + look, s * 0.035, eye);
    canvas.drawCircle(body + Offset(s * 0.08, s * 0.02) + look, s * 0.035, eye);
    // capacete com lanterna
    canvas.drawArc(Rect.fromCenter(center: body - Offset(0, s * 0.06), width: s * 0.5, height: s * 0.42), pi, pi, true,
        Paint()..color = const Color(0xFFFBBF24));
    canvas.drawCircle(body - Offset(0, s * 0.22), s * 0.06, Paint()..color = Colors.white);
    canvas.drawCircle(body - Offset(0, s * 0.22), s * 0.14,
        Paint()..color = const Color(0x55FFF7AE)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
  }

  @override
  bool shouldRepaint(covariant _MazePainter old) => true;
}
