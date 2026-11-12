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
import 'maze_ark_stages.dart';
import '../../theme/app_theme.dart';
import '../../services/app_lifecycle.dart';

const Color _accent = Color(0xFFFFA94D);
const int _levelCount = 30;
const double _speed = 6.5; // células por segundo
const double _joyRadius = 54;

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
  /// [items] objetos (gemas ou animais) ficam em becos distantes.
  static MazeData generate(int cellsH, int cellsW, {required int seed, double braid = 0.08, int items = 3}) {
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
    final dist = bfs(wall, rows, cols, start);
    Point<int> exit = start;
    int best = -1;
    dist.forEach((p, d) {
      if (d > best) {
        best = d;
        exit = p;
      }
    });

    // Objetos em becos sem saída distantes entre si
    final temp = MazeData(rows, cols, wall, start, exit, const []);
    final deadEnds = dist.keys.where((p) => p != start && p != exit && temp.exits(p.x, p.y) == 1).toList()
      ..sort((a, b) => dist[b]!.compareTo(dist[a]!));
    final gems = <Point<int>>[];
    for (final p in deadEnds) {
      if (gems.length == items) break;
      if (gems.every((g) => (g.x - p.x).abs() + (g.y - p.y).abs() > (rows + cols) ~/ 5)) gems.add(p);
    }
    for (final p in [...deadEnds, ...dist.keys]) {
      if (gems.length == items) break;
      if (p != start && p != exit && !gems.contains(p) && dist[p]! > best ~/ 3) gems.add(p);
    }
    return MazeData(rows, cols, wall, start, exit, gems);
  }

  static Map<Point<int>, int> bfs(List<List<bool>> wall, int rows, int cols, Point<int> from) {
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

  static final _keyDirs = <LogicalKeyboardKey, Offset>{
    LogicalKeyboardKey.arrowUp: Offset(0, -1),
    LogicalKeyboardKey.keyW: Offset(0, -1),
    LogicalKeyboardKey.arrowDown: Offset(0, 1),
    LogicalKeyboardKey.keyS: Offset(0, 1),
    LogicalKeyboardKey.arrowLeft: Offset(-1, 0),
    LogicalKeyboardKey.keyA: Offset(-1, 0),
    LogicalKeyboardKey.arrowRight: Offset(1, 0),
    LogicalKeyboardKey.keyD: Offset(1, 0),
  };

  // Progresso salvo
  int _unlocked = 1;
  final Map<int, int> _stars = {};
  int _arkUnlocked = 1;
  final Map<int, int> _arkStars = {};

  // Partida
  bool _playing = false;
  bool _ark = false; // modo Arca de Noé
  int _level = 1; // cavernas
  int _stage = 0; // índice em arkStages
  MazeData? _maze;
  Point<int> _cell = const Point(1, 1);
  Offset _visual = const Offset(1, 1); // (coluna, linha) contínuo
  final Queue<Point<int>> _queue = Queue();
  Point<int> _facing = const Point(0, 1);
  Point<int>? _bumped; // evita repetir o som de parede enquanto segura
  Point<int>? _stickDir; // direção atual do controle (com folga entre eixos)
  final Set<Point<int>> _gemsTaken = {};
  final List<int> _followers = []; // espécies que seguem o jogador (modo Arca)
  final List<Point<int>> _path = []; // células recentes, para a fila de animais
  final List<Point<int>> _trail = [];
  late List<List<bool>> _seen;
  int _moves = 0;
  int _seconds = 0;
  int _parSeconds = 0;
  Timer? _clock;
  bool _won = false;
  bool _showMap = false;
  bool _intro = false;
  String? _notice;
  double _noticeUntil = 0;
  double _anim = 0;

  // Controle direcional flutuante
  int? _joyPointer;
  Offset? _joyCenter;
  Offset _joyKnob = Offset.zero;

  // Cache de desenho
  ui.Picture? _mazePicture;
  double _pictureTile = 0;
  Duration _lastTick = Duration.zero;

  ArkStage get _arkStage => arkStages[_stage];
  MazeTheme get _theme => _ark ? _arkStage.theme : MazeTheme.cave;
  bool get _dark => _ark ? _arkStage.dark : _level >= 6 && _level % 3 == 0;

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
      _arkUnlocked = prefs.getInt('maze_ark_unlocked') ?? 1;
      for (int s = 0; s < arkStages.length; s++) {
        _arkStars[s] = prefs.getInt('maze_ark_stars_$s') ?? 0;
      }
    });
  }

  void _startLevel(int level) {
    final cells = min(5 + level, 20);
    _ark = false;
    _level = level;
    _begin(MazeGenerator.generate(cells, (cells * 0.85).round().clamp(5, 18),
        seed: level * 7349 + 11, braid: level < 4 ? 0.12 : 0.06));
  }

  void _startArk(int stage) {
    final s = arkStages[stage];
    _ark = true;
    _stage = stage;
    final maze = MazeGenerator.generate(s.size, (s.size * 0.85).round().clamp(5, 18),
        seed: stage * 9173 + 5, braid: 0.12, items: s.animals.length * 2);
    _parSeconds = _estimatePar(maze);
    _begin(maze);
    _intro = true;
  }

  /// Tempo-alvo para 3 estrelas: rota gulosa entrada → animais → arca.
  int _estimatePar(MazeData m) {
    var from = m.start;
    final left = [...m.gems];
    int steps = 0;
    while (true) {
      final dist = MazeGenerator.bfs(m.wall, m.rows, m.cols, from);
      if (left.isEmpty) {
        steps += dist[m.exit] ?? 0;
        break;
      }
      left.sort((a, b) => (dist[a] ?? 0).compareTo(dist[b] ?? 0));
      steps += dist[left.first] ?? 0;
      from = left.removeAt(0);
    }
    return (steps / _speed * 1.6 + 6).round();
  }

  void _begin(MazeData maze) {
    _mazePicture?.dispose();
    _mazePicture = null;
    setState(() {
      _maze = maze;
      _playing = true;
      _won = false;
      _showMap = false;
      _intro = false;
      _notice = null;
      _cell = maze.start;
      _visual = Offset(maze.start.y.toDouble(), maze.start.x.toDouble());
      _facing = const Point(0, 1);
      _queue.clear();
      _gemsTaken.clear();
      _followers.clear();
      _path
        ..clear()
        ..add(maze.start);
      _trail.clear();
      _seen = List.generate(maze.rows, (_) => List.filled(maze.cols, false));
      _moves = 0;
      _seconds = 0;
      _releaseJoystick();
    });
    _reveal();
    _clock?.cancel();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!AppLifecycle.foreground.value || _intro) return; // pausado em segundo plano
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

  void _say(String text) {
    _notice = text;
    _noticeUntil = _anim + 2.2;
  }

  // ==========================================================================
  // MOVIMENTO
  // ==========================================================================

  /// Direção pedida agora (controle na tela ou teclado), em pixels de tela.
  Offset? get _input {
    if (_joyCenter != null) {
      final v = _joyKnob - _joyCenter!;
      return v.distance < 16 ? null : v;
    }
    var v = Offset.zero;
    final keys = HardwareKeyboard.instance.logicalKeysPressed;
    _keyDirs.forEach((k, d) {
      if (keys.contains(k)) v += d;
    });
    return v == Offset.zero ? null : v;
  }

  /// Uma das 4 direções, com folga: só troca de eixo quando o outro eixo
  /// fica bem mais forte, para não alternar sozinho perto da diagonal.
  Point<int>? _wantedDir() {
    final v = _input;
    if (v == null) return _stickDir = null;
    var horiz = v.dx.abs() >= v.dy.abs();
    final cur = _stickDir;
    if (cur != null) {
      final curHoriz = cur.x == 0;
      if (curHoriz && v.dy.abs() < v.dx.abs() * 1.4) horiz = true;
      if (!curHoriz && v.dx.abs() < v.dy.abs() * 1.4) horiz = false;
    }
    return _stickDir = horiz ? Point(0, v.dx.sign.toInt()) : Point(v.dy.sign.toInt(), 0);
  }

  /// Com o controle pressionado, anda na direção pedida; na parede, fica parado.
  bool _continueMove() {
    final d = _wantedDir();
    if (d == null || _intro) {
      _bumped = null;
      return false;
    }
    final next = Point(_cell.x + d.x, _cell.y + d.y);
    if (_maze!.open(next.x, next.y)) {
      _queue.add(next);
      _bumped = null;
      return true;
    }
    if (_bumped != d) {
      _bumped = d;
      _facing = d;
      _audio.playSfx('bump', volume: 0.4);
      Haptics.light();
    }
    return false;
  }

  void _tick(Duration elapsed) {
    final dt = _lastTick == Duration.zero ? 0.016 : min(0.05, (elapsed - _lastTick).inMicroseconds / 1e6);
    _lastTick = elapsed;
    _anim += dt;
    if (_maze == null) return;

    _wantedDir(); // mantém a seta acesa do controle em dia
    // Movimento contínuo: a sobra do quadro passa para a célula seguinte
    var budget = _speed * dt;
    while (budget > 0 && !_won) {
      if (_queue.isEmpty && !_continueMove()) break;
      final target = _queue.first;
      final tv = Offset(target.y.toDouble(), target.x.toDouble());
      final delta = tv - _visual;
      if (delta.distance <= budget) {
        budget -= delta.distance;
        _visual = tv;
        _facing = Point(target.x - _cell.x, target.y - _cell.y);
        _cell = target;
        _queue.removeFirst();
        _moves++;
        _trail.add(target);
        if (_trail.length > 40) _trail.removeAt(0);
        _path.add(target);
        if (_path.length > 40) _path.removeAt(0);
        _reveal();
        _arrive(target);
      } else {
        _visual += delta / delta.distance * budget;
        budget = 0;
      }
    }
    if (_notice != null && _anim > _noticeUntil) _notice = null;
    if (mounted) setState(() {});
  }

  void _arrive(Point<int> p) {
    final m = _maze!;
    if (_moves % 2 == 0) _audio.playSfx('step', volume: 0.35);
    final i = m.gems.indexOf(p);
    if (i >= 0 && _gemsTaken.add(p)) {
      Haptics.medium();
      if (_ark) {
        final kind = i % _arkStage.animals.length;
        _followers.add(kind);
        _audio.playSfx('pickup');
        _say('${_arkStage.animals[kind]} ${_followers.where((k) => k == kind).length}/2');
      } else {
        _audio.playSfx('gem');
      }
    }
    if (p == m.exit) {
      final missing = m.gems.length - _gemsTaken.length;
      if (!_ark || missing == 0) {
        _win();
      } else {
        _say(t3('Faltam $missing animais!', '$missing animals to go!', '¡Faltan $missing animales!'));
      }
    }
  }

  Future<void> _win() async {
    _won = true;
    _queue.clear();
    _releaseJoystick();
    _clock?.cancel();
    if (_ark) _audio.playSfx('victory');
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    if (_ark) return _winArk();

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
          ? t3('Pegue as 3 gemas para 3 estrelas', 'Collect all 3 gems for 3 stars',
              'Recoge las 3 gemas para 3 estrellas')
          : null,
      stars: stars,
      newRecord: saved.newRecord,
      stats: [
        ResultStat('⏱️', t3('Tempo', 'Time', 'Tiempo'), formatGameTime(_seconds)),
        ResultStat('💎', t3('Gemas', 'Gems', 'Gemas'), '${_gemsTaken.length}/3'),
        ResultStat('👣', t3('Passos', 'Steps', 'Pasos'), '$_moves'),
      ],
      primaryLabel: last
          ? t3('Jogar de novo', 'Play again', 'Jugar de nuevo')
          : t3('Próximo nível', 'Next level', 'Siguiente nivel'),
      onPrimary: () => _startLevel(last ? _level : _level + 1),
      secondaryLabel: t3('Escolher nível', 'Choose level', 'Elegir nivel'),
      onSecondary: _toMenu,
    );
  }

  Future<void> _winArk() async {
    final stars = _seconds <= _parSeconds ? 3 : (_seconds <= _parSeconds * 2 ? 2 : 1);
    final prefs = await SharedPreferences.getInstance();
    if (stars > (_arkStars[_stage] ?? 0)) {
      _arkStars[_stage] = stars;
      await prefs.setInt('maze_ark_stars_$_stage', stars);
    }
    if (_stage + 2 > _arkUnlocked && _stage + 1 < arkStages.length) {
      _arkUnlocked = _stage + 2;
      await prefs.setInt('maze_ark_unlocked', _arkUnlocked);
    }
    if (!mounted) return;
    final score = (_stage + 1) * 150 + stars * 50 - _seconds;
    final saved = await recordGameResult(context, gameId: 'maze', won: true, score: max(10, score), seconds: _seconds);
    if (!mounted) return;
    final s = _arkStage;
    final last = _stage + 1 >= arkStages.length;
    await showGameResult(
      context,
      won: true,
      accent: _accent,
      title: last
          ? t3('Todos na arca! 🌈', 'Everyone is aboard! 🌈', '¡Todos en el arca! 🌈')
          : t3('${s.namePt} concluída!', '${s.nameEn} complete!', '¡${s.nameEs} completada!'),
      subtitle: last
          ? t3(
              'Você reuniu os ${arkStages.length * 4} animais. Parabéns!',
              'You gathered all ${arkStages.length * 4} animals. Well done!',
              'Reuniste los ${arkStages.length * 4} animales. ¡Felicidades!')
          : (stars < 3
              ? t3('Chegue mais rápido para 3 estrelas', 'Be faster for 3 stars', 'Llega más rápido para 3 estrellas')
              : null),
      stars: stars,
      newRecord: saved.newRecord,
      stats: [
        ResultStat('⏱️', t3('Tempo', 'Time', 'Tiempo'), formatGameTime(_seconds)),
        ResultStat(s.animals.join(), t3('Animais', 'Animals', 'Animales'), '${_gemsTaken.length}'),
        ResultStat('👣', t3('Passos', 'Steps', 'Pasos'), '$_moves'),
      ],
      primaryLabel: last
          ? t3('Jogar de novo', 'Play again', 'Jugar de nuevo')
          : t3('Próxima fase', 'Next stage', 'Siguiente fase'),
      onPrimary: () => _startArk(last ? _stage : _stage + 1),
      secondaryLabel: t3('Escolher fase', 'Choose stage', 'Elegir fase'),
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
    // O movimento lê as teclas pressionadas a cada quadro; aqui só as consome
    if (!_playing || !_keyDirs.containsKey(e.logicalKey)) return KeyEventResult.ignored;
    if (e is KeyDownEvent && _intro) setState(() => _intro = false);
    return KeyEventResult.handled;
  }

  // ==========================================================================
  // CONTROLE FLUTUANTE
  // ==========================================================================

  void _onPointerDown(PointerDownEvent e, Size area) {
    if (_joyPointer != null || _won) return;
    final c = Offset(e.localPosition.dx.clamp(_joyRadius, max(_joyRadius, area.width - _joyRadius)),
        e.localPosition.dy.clamp(_joyRadius, max(_joyRadius, area.height - _joyRadius)));
    setState(() {
      _intro = false;
      _joyPointer = e.pointer;
      _joyCenter = c;
      _joyKnob = e.localPosition;
    });
  }

  void _onPointerMove(PointerMoveEvent e) {
    if (e.pointer != _joyPointer || _joyCenter == null) return;
    var v = e.localPosition - _joyCenter!;
    if (v.distance > _joyRadius) {
      // O controle acompanha o dedo quando ele sai do círculo
      v = v / v.distance * _joyRadius;
      _joyCenter = e.localPosition - v;
    }
    _joyKnob = _joyCenter! + v;
  }

  void _onPointerUp(PointerEvent e) {
    if (e.pointer != _joyPointer) return;
    setState(_releaseJoystick);
  }

  void _releaseJoystick() {
    _joyPointer = null;
    _joyCenter = null;
    _bumped = null;
    _stickDir = null;
  }

  /// Posições (coluna, linha) dos animais em fila atrás do jogador.
  List<Offset> _followerSpots() {
    final pts = <Offset>[
      _visual,
      for (int i = _path.length - 1; i >= 0; i--) Offset(_path[i].y.toDouble(), _path[i].x.toDouble())
    ];
    final out = <Offset>[];
    for (int k = 1; k <= _followers.length; k++) {
      var need = k * 0.78;
      var pos = pts.last;
      for (int j = 0; j + 1 < pts.length; j++) {
        final seg = (pts[j + 1] - pts[j]).distance;
        if (seg >= need) {
          pos = seg == 0 ? pts[j] : Offset.lerp(pts[j], pts[j + 1], need / seg)!;
          break;
        }
        need -= seg;
      }
      out.add(pos);
    }
    return out;
  }

  // ==========================================================================
  // UI
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: _playing && _ark
          ? '${_arkStage.emoji} ${t3(_arkStage.namePt, _arkStage.nameEn, _arkStage.nameEs)}'
          : t3('🌀 Labirinto', '🌀 Maze', '🌀 Laberinto'),
      accent: _accent,
      onBack: _playing ? _toMenu : null,
      backgroundColors: _playing ? _theme.background : MazeTheme.cave.background,
      body: Focus(
        focusNode: _focus,
        autofocus: true,
        onKeyEvent: _onKey,
        child: _playing ? _buildGame() : _buildMenu(),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 10),
        child: Text(text,
            style:
                const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
      );

  Widget _buildMenu() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      children: [
        GameHero(
          emoji: '🚢',
          title: t3('Labirinto', 'Maze', 'Laberinto'),
          subtitle: t3(
              'Toque na tela e arraste para andar. Leve os animais até a arca ou explore as cavernas!',
              'Touch the screen and drag to walk. Lead the animals to the ark or explore the caves!',
              'Toca la pantalla y arrastra para caminar. ¡Lleva los animales al arca o explora las cuevas!'),
          accent: _accent,
        ),
        const SizedBox(height: 20),
        _sectionLabel(t3('🚢 ARCA DE NOÉ', '🚢 NOAH\'S ARK', '🚢 ARCA DE NOÉ')),
        Row(
          children: [
            for (int i = 0; i < arkStages.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(child: _arkTile(i)),
            ],
          ],
        ),
        const SizedBox(height: 24),
        _sectionLabel(t3('🔦 CAVERNAS', '🔦 CAVES', '🔦 CUEVAS')),
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
                  border: Border.all(
                      color: level == _unlocked ? _accent : Colors.white12, width: level == _unlocked ? 2 : 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (locked)
                      const Icon(Icons.lock_rounded, color: Colors.white30, size: 20)
                    else
                      Text('$level',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    _starRow(stars, 11),
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

  Widget _starRow(int stars, double size) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            3,
            (s) => Icon(Icons.star_rounded,
                size: size, color: s < stars ? GameColors.gold : Colors.white.withValues(alpha: 0.15))),
      );

  Widget _arkTile(int i) {
    final s = arkStages[i];
    final locked = i + 1 > _arkUnlocked;
    final current = i + 1 == _arkUnlocked;
    return GestureDetector(
      onTap: locked
          ? null
          : () {
              _audio.playClick();
              _startArk(i);
            },
      child: AspectRatio(
        aspectRatio: 0.72,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: BoxDecoration(
            gradient: locked
                ? null
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [s.theme.wallTop, s.theme.wallBase]),
            color: locked ? Colors.black26 : null,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: current ? _accent : Colors.white12, width: current ? 2 : 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Opacity(opacity: locked ? 0.35 : 1, child: Text(s.emoji, style: const TextStyle(fontSize: 24))),
              FittedBox(
                child: locked
                    ? const Icon(Icons.lock_rounded, color: Colors.white30, size: 16)
                    : Text(t3(s.namePt, s.nameEn, s.nameEs),
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
              ),
              FittedBox(child: _starRow(_arkStars[i] ?? 0, 10)),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _hud(MazeData m) {
    if (!_ark) {
      return [
        HudChip(emoji: '🏔️', value: '$_level', color: _accent, highlight: true),
        HudChip(emoji: '⏱️', value: formatGameTime(_seconds)),
        HudChip(
            emoji: '💎',
            value: '${_gemsTaken.length}/${m.gems.length}',
            color: const Color(0xFF67E8F9),
            highlight: _gemsTaken.isNotEmpty),
      ];
    }
    return [
      HudChip(emoji: '⏱️', value: formatGameTime(_seconds)),
      for (int k = 0; k < _arkStage.animals.length; k++)
        () {
          final got = _followers.where((f) => f == k).length;
          return HudChip(emoji: _arkStage.animals[k], value: '$got/2', color: _accent, highlight: got == 2);
        }(),
    ];
  }

  Widget _buildGame() {
    final m = _maze!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
          child: Row(
            children: [
              Expanded(child: Wrap(spacing: 6, runSpacing: 6, children: _hud(m))),
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
            final spots = _ark ? _followerSpots() : const <Offset>[];
            return Stack(
              children: [
                Positioned.fill(
                  child: Listener(
                    key: const ValueKey('maze-area'),
                    behavior: HitTestBehavior.opaque,
                    onPointerDown: (e) => _onPointerDown(e, view),
                    onPointerMove: _onPointerMove,
                    onPointerUp: _onPointerUp,
                    onPointerCancel: _onPointerUp,
                    child: ClipRect(
                      child: CustomPaint(
                        size: view,
                        painter: _MazePainter(
                          maze: m,
                          picture: _mazePicture!,
                          tile: tile,
                          player: _visual,
                          facing: _facing,
                          gemsTaken: _gemsTaken,
                          trail: _trail,
                          seen: _seen,
                          dark: _dark && !_showMap,
                          t: _anim,
                          animals: _ark ? _arkStage.animals : null,
                          followers: [
                            for (int i = 0; i < _followers.length; i++) (_arkStage.animals[_followers[i]], spots[i])
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (_joyCenter != null) _joystick(),
                if (_notice != null)
                  Positioned(
                    top: 12,
                    left: 0,
                    right: 0,
                    child: IgnorePointer(child: Center(child: _bubble(_notice!, 18))),
                  ),
                if (_intro) Positioned.fill(child: IgnorePointer(child: _introCard())),
                if (!_intro && _moves == 0 && _joyCenter == null)
                  Positioned(
                    bottom: 18,
                    left: 16,
                    right: 16,
                    child: IgnorePointer(
                      child: Center(
                        child: _bubble(
                            t3('👆 Toque em qualquer lugar e arraste para andar', '👆 Touch anywhere and drag to walk',
                                '👆 Toca en cualquier lugar y arrastra para caminar'),
                            13),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _bubble(String text, double size) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: size, fontWeight: FontWeight.w800)),
      );

  Widget _introCard() {
    final s = _arkStage;
    String names(List<String> n) => '2 ${s.animals[0]} ${n[0]} · 2 ${s.animals[1]} ${n[1]}';
    return Container(
      color: Colors.black.withValues(alpha: 0.45),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: GamePanel(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(s.emoji, style: const TextStyle(fontSize: 46)),
            const SizedBox(height: 6),
            Text(
                t3('Fase ${_stage + 1} · ${s.namePt}', 'Stage ${_stage + 1} · ${s.nameEn}',
                    'Fase ${_stage + 1} · ${s.nameEs}'),
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            Text(t3('Encontre os animais:', 'Find the animals:', 'Encuentra los animales:'),
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 4),
            Text(t3(names(s.animalsPt), names(s.animalsEn), names(s.animalsEs)),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(t3('e leve todos até a arca!', 'and bring them all to the ark!', '¡y llévalos todos al arca!'),
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 14),
            Text(t3('👆 Toque para começar', '👆 Tap to start', '👆 Toca para empezar'),
                style: const TextStyle(color: _accent, fontSize: 14, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }

  Widget _joystick() {
    final c = _joyCenter!;
    final v = _joyKnob - c;
    final d = _stickDir;
    final active = d == null ? null : Offset(d.y.toDouble(), d.x.toDouble());
    Widget arrow(IconData icon, Offset dir) => Positioned(
          left: _joyRadius + dir.dx * (_joyRadius - 16) - 13,
          top: _joyRadius + dir.dy * (_joyRadius - 16) - 13,
          child: Icon(icon, size: 26, color: active == dir ? Colors.white : Colors.white38),
        );
    return Positioned(
      left: c.dx - _joyRadius,
      top: c.dy - _joyRadius,
      child: IgnorePointer(
        child: SizedBox(
          width: _joyRadius * 2,
          height: _joyRadius * 2,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.28),
                  border: Border.all(color: Colors.white38, width: 2),
                ),
              ),
              arrow(Icons.keyboard_arrow_up_rounded, const Offset(0, -1)),
              arrow(Icons.keyboard_arrow_down_rounded, const Offset(0, 1)),
              arrow(Icons.keyboard_arrow_left_rounded, const Offset(-1, 0)),
              arrow(Icons.keyboard_arrow_right_rounded, const Offset(1, 0)),
              Positioned(
                left: _joyRadius + v.dx - 22,
                top: _joyRadius + v.dy - 22,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(colors: [Color(0xFFFFD29A), _accent]),
                    border: Border.all(color: Colors.white70, width: 2),
                    boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 3))],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Grava o labirinto estático (chão + paredes) uma vez por nível/zoom.
  ui.Picture _recordMaze(MazeData m, double t) {
    final theme = _theme;
    final rec = ui.PictureRecorder();
    final canvas = Canvas(rec);
    final floor = Paint()..color = theme.floor;
    final floorDot = Paint()..color = theme.floorDot;
    final wallBase = Paint()..color = theme.wallBase;
    final wallTop = Paint()..color = theme.wallTop;
    final shadow = Paint()..color = const Color(0x55000000);
    final rnd = Random(m.rows * 31 + m.cols);
    final decor = <String, TextPainter>{
      for (final e in theme.decor)
        e: TextPainter(text: TextSpan(text: e, style: TextStyle(fontSize: t * 0.62)), textDirection: TextDirection.ltr)
          ..layout(),
    };

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
            RRect.fromRectAndRadius(
                Rect.fromLTWH(rect.left + 1, rect.top + 1, t - 2, t * 0.72), Radius.circular(t * 0.18)),
            wallTop);
        if (decor.isNotEmpty && rnd.nextDouble() < 0.16) {
          final tp = decor.values.elementAt(rnd.nextInt(decor.length));
          tp.paint(canvas, rect.center - Offset(tp.width / 2, tp.height / 2 + t * 0.06));
        }
      }
    }
    return rec.endRecording();
  }
}

class _MazePainter extends CustomPainter {
  final MazeData maze;
  final ui.Picture picture;
  final double tile;
  final Offset player; // (coluna, linha)
  final Point<int> facing;
  final Set<Point<int>> gemsTaken;
  final List<Point<int>> trail;
  final List<List<bool>> seen;
  final bool dark;
  final double t;
  final List<String>? animals; // modo Arca: emojis das espécies
  final List<(String, Offset)> followers; // emoji e posição (coluna, linha)

  _MazePainter({
    required this.maze,
    required this.picture,
    required this.tile,
    required this.player,
    required this.facing,
    required this.gemsTaken,
    required this.trail,
    required this.seen,
    required this.dark,
    required this.t,
    required this.animals,
    required this.followers,
  });

  static final Map<String, TextPainter> _emojiCache = {};

  void _emoji(Canvas canvas, String e, Offset center, double size) {
    final tp = _emojiCache.putIfAbsent('$e|${size.round()}', () {
      return TextPainter(text: TextSpan(text: e, style: TextStyle(fontSize: size)), textDirection: TextDirection.ltr)
        ..layout();
    });
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  Offset _px(Offset colRow) => Offset((colRow.dx + 0.5) * tile, (colRow.dy + 0.5) * tile);

  @override
  void paint(Canvas canvas, Size size) {
    final mazeW = maze.cols * tile, mazeH = maze.rows * tile;
    final pp = _px(player);
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

    final ex = Offset((maze.exit.y + 0.5) * tile, (maze.exit.x + 0.5) * tile);
    if (animals != null) {
      _drawArk(canvas, ex, gemsTaken.length == maze.gems.length);
      for (int i = 0; i < maze.gems.length; i++) {
        final g = maze.gems[i];
        if (gemsTaken.contains(g)) continue;
        final c = Offset((g.y + 0.5) * tile, (g.x + 0.5) * tile + sin(t * 3 + i) * tile * 0.06);
        canvas.drawCircle(
            c,
            tile * 0.42,
            Paint()
              ..color = Colors.white.withValues(alpha: 0.25)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
        _emoji(canvas, animals![i % animals!.length], c, tile * 0.66);
      }
      for (int i = followers.length - 1; i >= 0; i--) {
        final (e, pos) = followers[i];
        _emoji(canvas, e, _px(pos) - Offset(0, sin(t * 10 + i).abs() * tile * 0.05), tile * 0.6);
      }
    } else {
      _drawPortal(canvas, ex);
      _drawGems(canvas);
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
            ..shader = ui.Gradient.radial(
                pp, light, [Colors.black, Colors.black, Colors.black.withValues(alpha: 0)], [0, 0.55, 1]));
      canvas.restore();
    }
    canvas.restore();
  }

  void _drawPortal(Canvas canvas, Offset ex) {
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
    canvas.drawCircle(
        ex,
        tile * 0.34,
        Paint()
          ..shader = ui.Gradient.radial(
              ex, tile * 0.34, [Colors.white, const Color(0xFFFFC94A), const Color(0x00FFC94A)], [0, 0.4, 1]));
  }

  void _drawGems(Canvas canvas) {
    for (final g in maze.gems) {
      if (gemsTaken.contains(g)) continue;
      final c = Offset((g.y + 0.5) * tile, (g.x + 0.5) * tile + sin(t * 3 + g.x) * tile * 0.06);
      final s = tile * 0.28;
      canvas.drawCircle(
          c,
          s * 1.4,
          Paint()
            ..color = const Color(0x4467E8F9)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
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
      canvas.drawPath(
          gem,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
            ..color = Colors.white70);
    }
  }

  /// Arca de madeira; brilha e acende a janela quando todos os animais chegaram.
  void _drawArk(Canvas canvas, Offset c, bool ready) {
    final s = tile * 1.25;
    if (ready) {
      for (int k = 0; k < 2; k++) {
        final ph = (t * 0.7 + k / 2) % 1;
        canvas.drawCircle(
            c,
            s * (0.3 + ph * 0.5),
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = tile * 0.06
              ..color = const Color(0xFFFFE066).withValues(alpha: 1 - ph));
      }
    }
    canvas.drawOval(Rect.fromCenter(center: c + Offset(0, s * 0.3), width: s * 0.9, height: s * 0.14),
        Paint()..color = Colors.black.withValues(alpha: 0.3));
    final hull = Path()
      ..moveTo(c.dx - s * 0.48, c.dy)
      ..lineTo(c.dx + s * 0.48, c.dy)
      ..lineTo(c.dx + s * 0.34, c.dy + s * 0.28)
      ..lineTo(c.dx - s * 0.34, c.dy + s * 0.28)
      ..close();
    canvas.drawPath(hull, Paint()..color = const Color(0xFF8B5A2B));
    canvas.drawLine(
        Offset(c.dx - s * 0.42, c.dy + s * 0.11),
        Offset(c.dx + s * 0.42, c.dy + s * 0.11),
        Paint()
          ..color = const Color(0xFF5E3A1A)
          ..strokeWidth = max(1, s * 0.025));
    canvas.drawRect(
        Rect.fromLTWH(c.dx - s * 0.26, c.dy - s * 0.2, s * 0.52, s * 0.2), Paint()..color = const Color(0xFFB07A45));
    canvas.drawPath(
        Path()
          ..moveTo(c.dx - s * 0.33, c.dy - s * 0.18)
          ..lineTo(c.dx, c.dy - s * 0.4)
          ..lineTo(c.dx + s * 0.33, c.dy - s * 0.18)
          ..close(),
        Paint()..color = const Color(0xFF6B3F1D));
    canvas.drawRect(Rect.fromLTWH(c.dx - s * 0.07, c.dy - s * 0.15, s * 0.14, s * 0.12),
        Paint()..color = ready ? const Color(0xFFFFE066) : const Color(0xFF3B2410));
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
    canvas.drawCircle(
        body - Offset(0, s * 0.22),
        s * 0.14,
        Paint()
          ..color = const Color(0x55FFF7AE)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
  }

  @override
  bool shouldRepaint(covariant _MazePainter old) => true;
}
