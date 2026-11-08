import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../services/audio_service.dart';
import '../../services/minigame_content_service.dart';
import 'common/game_results.dart';
import 'common/game_text.dart';
import 'common/game_ui.dart';
import '../../theme/app_theme.dart';
import '../../services/app_lifecycle.dart';

const Color _accent = Color(0xFF34D399);

const List<Color> kWordColors = [
  Color(0xFFF87171),
  Color(0xFFC084FC),
  Color(0xFF60A5FA),
  Color(0xFF2DD4BF),
  Color(0xFFFBBF24),
  Color(0xFFFB923C),
  Color(0xFFF472B6),
  Color(0xFFA3E635),
  Color(0xFF38BDF8),
];

class WordLine {
  final Point<int> start; // (linha, coluna)
  final Point<int> end;
  final Color color;
  WordLine(this.start, this.end, this.color);
}

class _Level {
  final int size, words;
  final bool diagonal, reverse;
  const _Level(this.size, this.words, this.diagonal, this.reverse);
}

const _levels = {
  0: _Level(8, 5, false, false),
  1: _Level(10, 7, true, false),
  2: _Level(12, 9, true, true),
};

class WordSearchGame extends StatefulWidget {
  const WordSearchGame({super.key});

  @override
  State<WordSearchGame> createState() => _WordSearchGameState();
}

class _WordSearchGameState extends State<WordSearchGame> with SingleTickerProviderStateMixin {
  final _audio = AudioService();
  final _random = Random();
  late final AnimationController _pulse;

  bool _configuring = true;
  int _level = 1;

  // Partida
  int _n = 10;
  List<List<String>> _grid = [];
  List<String> _words = []; // como exibidas (com acento)
  List<String> _keys = []; // sem acento, usadas na grade
  final Map<String, WordLine> _found = {};
  Point<int>? _selStart;
  Point<int>? _selEnd;
  Point<int>? _tapStart; // seleção por toque-toque
  Point<int>? _hintCell;
  int _hintsLeft = 3;
  int _shake = 0;
  int _seconds = 0;
  Timer? _clock;
  double _cell = 0;

  @override
  void initState() {
    super.initState();
    // Criado já na abertura: dispose() roda mesmo se a pessoa sair antes de jogar
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..repeat(reverse: true);
    _audio.playBackgroundMusic('quiz');
  }

  @override
  void dispose() {
    _clock?.cancel();
    _pulse.dispose();
    _audio.stopBackgroundMusic();
    super.dispose();
  }

  // ==========================================================================
  // GERAÇÃO
  // ==========================================================================

  void _start() {
    final level = _levels[_level]!;
    _n = level.size;
    // Uma entrada por forma sem acento (ex.: "JOÃO" e "JOAO" viram a mesma)
    final byKey = <String, String>{};
    for (final w in MinigameContentService().wordSearchWords) {
      final k = stripAccents(w);
      if (k.length >= 3 && k.length <= _n && RegExp(r'^[A-ZÑ]+$').hasMatch(k)) byKey.putIfAbsent(k, () => w);
    }
    final pool = byKey.values.toList();

    // Tenta até conseguir posicionar todas as palavras escolhidas
    for (int attempt = 0; attempt < 40; attempt++) {
      pool.shuffle(_random);
      final chosen = pool.take(level.words).toList();
      final grid = _tryBuild(chosen.map(stripAccents).toList(), level);
      if (grid != null) {
        _grid = grid;
        _words = chosen;
        _keys = chosen.map(stripAccents).toList();
        break;
      }
    }

    setState(() {
      _configuring = false;
      _found.clear();
      _selStart = _selEnd = _tapStart = _hintCell = null;
      _hintsLeft = 3;
      _seconds = 0;
    });
    _clock?.cancel();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!AppLifecycle.foreground.value) return; // pausado em segundo plano
      if (mounted) setState(() => _seconds++);
    });
  }

  List<List<String>>? _tryBuild(List<String> words, _Level level) {
    final grid = List.generate(_n, (_) => List.filled(_n, ''));
    final dirs = <Point<int>>[
      const Point(0, 1),
      const Point(1, 0),
      if (level.diagonal) ...[const Point(1, 1), const Point(-1, 1)],
      if (level.reverse) ...[const Point(0, -1), const Point(-1, 0), if (level.diagonal) const Point(-1, -1)],
    ];
    // Palavras maiores primeiro facilitam o encaixe
    final sorted = List<String>.from(words)..sort((a, b) => b.length.compareTo(a.length));
    for (final w in sorted) {
      bool placed = false;
      for (int i = 0; i < 300 && !placed; i++) {
        final d = dirs[_random.nextInt(dirs.length)];
        final r = _random.nextInt(_n), c = _random.nextInt(_n);
        if (_fits(grid, w, r, c, d)) {
          for (int k = 0; k < w.length; k++) {
            grid[r + d.x * k][c + d.y * k] = w[k];
          }
          placed = true;
        }
      }
      if (!placed) return null;
    }
    final alphabet = gameLang == 'es' ? 'ABCDEFGHIJLMNOPRSTUVZÑ' : 'ABCDEFGHIJLMNOPRSTUV';
    for (final row in grid) {
      for (int c = 0; c < _n; c++) {
        if (row[c].isEmpty) row[c] = alphabet[_random.nextInt(alphabet.length)];
      }
    }
    return grid;
  }

  bool _fits(List<List<String>> g, String w, int r, int c, Point<int> d) {
    for (int k = 0; k < w.length; k++) {
      final rr = r + d.x * k, cc = c + d.y * k;
      if (rr < 0 || rr >= _n || cc < 0 || cc >= _n) return false;
      if (g[rr][cc].isNotEmpty && g[rr][cc] != w[k]) return false;
    }
    return true;
  }

  // ==========================================================================
  // SELEÇÃO
  // ==========================================================================

  Point<int>? _cellAt(Offset p) {
    if (_cell <= 0) return null;
    final c = (p.dx / _cell).floor(), r = (p.dy / _cell).floor();
    if (r < 0 || r >= _n || c < 0 || c >= _n) return null;
    return Point(r, c);
  }

  /// Ajusta o fim para uma linha reta (horizontal, vertical ou diagonal).
  Point<int> _snap(Point<int> s, Point<int> e) {
    final dr = e.x - s.x, dc = e.y - s.y;
    if (dr == 0 && dc == 0) return s;
    if (dr.abs() > dc.abs() * 2) return Point(e.x, s.y);
    if (dc.abs() > dr.abs() * 2) return Point(s.x, e.y);
    final len = max(dr.abs(), dc.abs());
    var end = Point(s.x + dr.sign * len, s.y + dc.sign * len);
    // Mantém dentro da grade
    while (end.x < 0 || end.x >= _n || end.y < 0 || end.y >= _n) {
      end = Point(end.x - dr.sign, end.y - dc.sign);
    }
    return end;
  }

  void _onDown(Offset p) {
    final cell = _cellAt(p);
    if (cell == null) return;
    setState(() {
      _selStart = cell;
      _selEnd = cell;
    });
    Haptics.selection();
  }

  void _onMove(Offset p) {
    if (_selStart == null) return;
    final raw = _cellAt(Offset(p.dx.clamp(0, _cell * _n - 1), p.dy.clamp(0, _cell * _n - 1)));
    if (raw == null) return;
    final end = _snap(_selStart!, raw);
    if (end != _selEnd) {
      setState(() => _selEnd = end);
      Haptics.selection();
    }
  }

  void _onUp() {
    final s = _selStart, e = _selEnd;
    if (s == null || e == null) return;
    if (s == e) {
      // Toque simples: modo toque-toque (início e depois fim)
      if (_tapStart == null) {
        setState(() {
          _tapStart = s;
          _selStart = _selEnd = null;
        });
        _audio.playClick();
        return;
      }
      final start = _tapStart!;
      setState(() {
        _tapStart = null;
        _selStart = _selEnd = null;
      });
      _check(start, _snap(start, s));
      return;
    }
    setState(() {
      _tapStart = null;
      _selStart = _selEnd = null;
    });
    _check(s, e);
  }

  void _check(Point<int> s, Point<int> e) {
    final len = max((e.x - s.x).abs(), (e.y - s.y).abs());
    if (len == 0) return;
    final dr = (e.x - s.x).sign, dc = (e.y - s.y).sign;
    final sb = StringBuffer();
    for (int k = 0; k <= len; k++) {
      sb.write(_grid[s.x + dr * k][s.y + dc * k]);
    }
    final word = sb.toString();
    final reversed = word.split('').reversed.join();
    final idx = _keys.indexWhere((k) => (k == word || k == reversed) && !_found.containsKey(k));

    if (idx >= 0) {
      final key = _keys[idx];
      setState(() {
        _found[key] = WordLine(s, e, kWordColors[_found.length % kWordColors.length]);
        if (_hintCell != null && _isInLine(_hintCell!, s, e)) _hintCell = null;
      });
      _audio.playMatch();
      Haptics.medium();
      if (_found.length == _keys.length) _finish();
    } else if (len >= 1) {
      setState(() => _shake++);
      _audio.playSfx('mismatch', volume: 0.6);
    }
  }

  bool _isInLine(Point<int> p, Point<int> s, Point<int> e) {
    final len = max((e.x - s.x).abs(), (e.y - s.y).abs());
    final dr = (e.x - s.x).sign, dc = (e.y - s.y).sign;
    for (int k = 0; k <= len; k++) {
      if (s.x + dr * k == p.x && s.y + dc * k == p.y) return true;
    }
    return false;
  }

  void _useHint() {
    if (_hintsLeft == 0) return;
    final missing = _keys.where((k) => !_found.containsKey(k)).toList();
    if (missing.isEmpty) return;
    final target = missing[_random.nextInt(missing.length)];
    // Procura a primeira letra da palavra na grade
    for (int r = 0; r < _n; r++) {
      for (int c = 0; c < _n; c++) {
        for (final d in const [
          Point(0, 1),
          Point(1, 0),
          Point(1, 1),
          Point(-1, 1),
          Point(0, -1),
          Point(-1, 0),
          Point(-1, -1),
          Point(1, -1)
        ]) {
          var ok = true;
          for (int k = 0; k < target.length && ok; k++) {
            final rr = r + d.x * k, cc = c + d.y * k;
            ok = rr >= 0 && rr < _n && cc >= 0 && cc < _n && _grid[rr][cc] == target[k];
          }
          if (ok) {
            setState(() {
              _hintsLeft--;
              _hintCell = Point(r, c);
            });
            _audio.playSfx('star');
            return;
          }
        }
      }
    }
  }

  Future<void> _finish() async {
    _clock?.cancel();
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final level = _levels[_level]!;
    final par = level.words * (8 + _level * 4);
    final used = 3 - _hintsLeft;
    final stars = (_seconds <= par && used == 0) ? 3 : (_seconds <= par * 2 && used <= 1 ? 2 : 1);
    final score = max(10, 1000 + _level * 300 - _seconds * 3 - used * 100);
    final saved = await recordGameResult(context,
        gameId: 'word_search', won: true, score: score, seconds: _seconds, perfect: used == 0);
    if (!mounted) return;
    await showGameResult(
      context,
      won: true,
      accent: _accent,
      title: t3('Todas encontradas!', 'All found!', '¡Todas encontradas!'),
      stars: stars,
      newRecord: saved.newRecord,
      stats: [
        ResultStat('⏱️', t3('Tempo', 'Time', 'Tiempo'), formatGameTime(_seconds)),
        ResultStat('🔤', t3('Palavras', 'Words', 'Palabras'), '${_keys.length}'),
        ResultStat('💡', t3('Dicas', 'Hints', 'Pistas'), '$used'),
      ],
      primaryLabel: t3('Nova grade', 'New grid', 'Nueva cuadrícula'),
      onPrimary: _start,
      secondaryLabel: t3('Mudar dificuldade', 'Change difficulty', 'Cambiar dificultad'),
      onSecondary: () => setState(() => _configuring = true),
    );
  }

  // ==========================================================================
  // UI
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: t3('🔍 Caça-Palavras', '🔍 Word Search', '🔍 Sopa de Letras'),
      accent: _accent,
      onBack: _configuring
          ? null
          : () {
              _clock?.cancel();
              setState(() => _configuring = true);
            },
      backgroundColors: const [Color(0xFF123128), Color(0xFF0C1A17)],
      body: _configuring ? _buildConfig() : _buildGame(),
    );
  }

  Widget _buildConfig() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      children: [
        GameHero(
          emoji: '🔍',
          title: t3('Caça-Palavras', 'Word Search', 'Sopa de Letras'),
          subtitle: t3(
              'Arraste sobre as letras (ou toque no início e no fim) para marcar as palavras',
              'Drag over the letters (or tap the first and last) to mark the words',
              'Arrastra sobre las letras (o toca la primera y la última) para marcar las palabras'),
          accent: _accent,
        ),
        const SizedBox(height: 22),
        GamePanel(
          child: OptionPicker<int>(
            title: t3('Dificuldade', 'Difficulty', 'Dificultad'),
            accent: _accent,
            selected: _level,
            onChanged: (v) => setState(() => _level = v),
            options: [
              OptionItem(0, t3('Fácil', 'Easy', 'Fácil'), t3('8×8 · 5 palavras', '8×8 · 5 words', '8×8 · 5 palabras')),
              OptionItem(1, t3('Médio', 'Medium', 'Medio'),
                  t3('10×10 · diagonais', '10×10 · diagonals', '10×10 · diagonales')),
              OptionItem(2, t3('Difícil', 'Hard', 'Difícil'),
                  t3('12×12 · invertidas', '12×12 · backwards', '12×12 · invertidas')),
            ],
          ),
        ),
        const SizedBox(height: 22),
        PillButton(
            label: t3('Começar', 'Start', 'Comenzar'),
            icon: Icons.play_arrow_rounded,
            color: _accent,
            expand: true,
            onTap: _start),
      ],
    );
  }

  Widget _buildGame() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
          child: Row(
            children: [
              HudChip(emoji: '⏱️', value: formatGameTime(_seconds)),
              const SizedBox(width: 8),
              HudChip(
                  emoji: '✅', value: '${_found.length}/${_keys.length}', color: _accent, highlight: _found.isNotEmpty),
              const Spacer(),
              GestureDetector(
                onTap: _hintsLeft > 0 ? _useHint : null,
                child: AnimatedOpacity(
                  opacity: _hintsLeft > 0 ? 1 : 0.4,
                  duration: const Duration(milliseconds: 200),
                  child: HudChip(emoji: '💡', value: '$_hintsLeft', color: GameColors.gold),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: LayoutBuilder(builder: (context, c) {
              final side = min(c.maxWidth, c.maxHeight);
              _cell = side / _n;
              return Center(
                child: ShakeOnChange(
                  trigger: _shake,
                  child: Container(
                    width: side,
                    height: side,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F5EC),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 14, offset: Offset(0, 6))],
                    ),
                    child: Listener(
                      onPointerDown: (e) => _onDown(e.localPosition),
                      onPointerMove: (e) => _onMove(e.localPosition),
                      onPointerUp: (_) => _onUp(),
                      onPointerCancel: (_) => _onUp(),
                      child: AnimatedBuilder(
                        animation: _pulse,
                        builder: (_, __) => CustomPaint(
                          size: Size(side, side),
                          painter: WordSearchPainter(
                            grid: _grid,
                            foundLines: _found.values.toList(),
                            dragStart: _selStart,
                            dragEnd: _selEnd,
                            tapStart: _tapStart,
                            hintCell: _hintCell,
                            pulse: _pulse.value,
                            cellSize: _cell,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(_words.length, (i) {
                final line = _found[_keys[i]];
                final found = line != null;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: found ? line.color.withValues(alpha: 0.25) : GameColors.panel,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: found ? line.color : Colors.white12, width: found ? 2 : 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (found) ...[
                        Icon(Icons.check_circle_rounded, color: line.color, size: 16),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        _words[i],
                        style: TextStyle(
                          color: found ? Colors.white : Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          decoration: found ? TextDecoration.lineThrough : null,
                          decorationColor: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class WordSearchPainter extends CustomPainter {
  final List<List<String>> grid;
  final List<WordLine> foundLines;
  final Point<int>? dragStart, dragEnd, tapStart, hintCell;
  final double pulse;
  final double cellSize;

  WordSearchPainter({
    required this.grid,
    required this.foundLines,
    required this.dragStart,
    required this.dragEnd,
    required this.tapStart,
    required this.hintCell,
    required this.pulse,
    required this.cellSize,
  });

  Offset _center(Point<int> p) => Offset(p.y * cellSize + cellSize / 2, p.x * cellSize + cellSize / 2);

  void _capsule(Canvas canvas, Point<int> a, Point<int> b, Paint paint) {
    canvas.drawLine(_center(a), _center(b), paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final n = grid.length;
    // Linhas guia sutis
    final guide = Paint()..color = const Color(0x11000000);
    for (int i = 1; i < n; i++) {
      canvas.drawRect(Rect.fromLTWH(i * cellSize, 6, 0.6, size.height - 12), guide);
      canvas.drawRect(Rect.fromLTWH(6, i * cellSize, size.width - 12, 0.6), guide);
    }

    final cap = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = cellSize * 0.78;

    for (final line in foundLines) {
      cap.color = line.color.withValues(alpha: 0.55);
      _capsule(canvas, line.start, line.end, cap);
    }

    if (hintCell != null) {
      canvas.drawCircle(_center(hintCell!), cellSize * (0.42 + pulse * 0.12),
          Paint()..color = const Color(0xFFFFC94A).withValues(alpha: 0.35 + pulse * 0.35));
    }

    if (tapStart != null) {
      canvas.drawCircle(_center(tapStart!), cellSize * 0.42, Paint()..color = const Color(0x8834D399));
    }

    if (dragStart != null && dragEnd != null) {
      cap.color = const Color(0xAA34D399);
      _capsule(canvas, dragStart!, dragEnd!, cap);
    }

    final tp = TextPainter(textDirection: TextDirection.ltr, textAlign: TextAlign.center);
    final style = TextStyle(
      color: const Color(0xFF243447),
      fontSize: cellSize * 0.52,
      fontWeight: FontWeight.w800,
    );
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        tp.text = TextSpan(text: grid[r][c], style: style);
        tp.layout(minWidth: cellSize, maxWidth: cellSize);
        tp.paint(canvas, Offset(c * cellSize, r * cellSize + (cellSize - tp.height) / 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant WordSearchPainter old) => true;
}
