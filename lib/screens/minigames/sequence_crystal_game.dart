import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/audio_service.dart';
import 'common/game_results.dart';
import 'common/game_text.dart';
import 'common/game_ui.dart';
import '../../theme/app_theme.dart';

const Color _accent = Color(0xFFA78BFA);
const int _maxLevel = 30;

/// Gemas: cor clara, cor média, cor escura.
const List<List<Color>> _gems = [
  [Color(0xFFFF8A9B), Color(0xFFE11D48), Color(0xFF7F1028)], // rubi
  [Color(0xFF93C5FD), Color(0xFF2563EB), Color(0xFF1E3A8A)], // safira
  [Color(0xFF86EFAC), Color(0xFF16A34A), Color(0xFF14532D)], // esmeralda
  [Color(0xFFFDE68A), Color(0xFFF59E0B), Color(0xFF92400E)], // topázio
  [Color(0xFFD8B4FE), Color(0xFF9333EA), Color(0xFF4C1D95)], // ametista
  [Color(0xFFA5F3FC), Color(0xFF06B6D4), Color(0xFF155E75)], // água-marinha
  [Color(0xFFFDBA74), Color(0xFFEA580C), Color(0xFF7C2D12)], // âmbar
  [Color(0xFFFBCFE8), Color(0xFFDB2777), Color(0xFF831843)], // quartzo rosa
  [Color(0xFFD9F99D), Color(0xFF65A30D), Color(0xFF365314)], // peridoto
];

enum SeqMode { classic, master, progressive }

class SequenceCrystalGame extends StatefulWidget {
  const SequenceCrystalGame({super.key});

  @override
  State<SequenceCrystalGame> createState() => _SequenceCrystalGameState();
}

class _SequenceCrystalGameState extends State<SequenceCrystalGame> with TickerProviderStateMixin {
  final _audio = AudioService();
  final _random = Random();
  late final AnimationController _ambient =
      AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();

  bool _configuring = true;
  SeqMode _mode = SeqMode.classic;
  final Map<SeqMode, int> _best = {};

  // Partida
  List<int> _sequence = [];
  int _inputIndex = 0;
  int _crystals = 4;
  int _level = 0;
  int _lit = -1;
  int _wrongCrystal = -1;
  bool _playerTurn = false;
  bool _secondChanceUsed = false;
  int _shake = 0;
  String _message = '';
  int _token = 0;
  DateTime _startedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _audio.playBackgroundMusic('memory');
    _loadBest();
  }

  @override
  void dispose() {
    _token++;
    _ambient.dispose();
    _audio.stopBackgroundMusic();
    super.dispose();
  }

  Future<void> _loadBest() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      for (final m in SeqMode.values) {
        _best[m] = prefs.getInt('seq_best_${m.name}') ?? 0;
      }
    });
  }

  int _crystalsFor(int level) {
    switch (_mode) {
      case SeqMode.classic:
        return 4;
      case SeqMode.master:
        return 6;
      case SeqMode.progressive:
        return min(9, 4 + (level - 1) ~/ 3);
    }
  }

  void _start() {
    _token++;
    setState(() {
      _configuring = false;
      _sequence = [];
      _level = 0;
      _secondChanceUsed = false;
      _crystals = _crystalsFor(1);
      _wrongCrystal = -1;
      _startedAt = DateTime.now();
    });
    _nextLevel();
  }

  Future<void> _nextLevel() async {
    _level++;
    final newCount = _crystalsFor(_level);
    final grew = newCount > _crystals;
    setState(() {
      _crystals = newCount;
      _sequence.add(_random.nextInt(_crystals));
      _inputIndex = 0;
      _playerTurn = false;
      _message = grew ? t3('✨ Novo cristal!', '✨ New crystal!', '✨ ¡Nuevo cristal!') : t3('Observe…', 'Watch…', 'Observa…');
    });
    if (grew) _audio.playSfx('star');
    await _playSequence();
  }

  Future<void> _playSequence() async {
    final token = ++_token;
    await Future.delayed(const Duration(milliseconds: 750));
    final on = max(240, 560 - _level * 14);
    final gap = max(110, 200 - _level * 4);
    for (final c in _sequence) {
      if (!mounted || token != _token) return;
      setState(() => _lit = c);
      _audio.playNote(c);
      await Future.delayed(Duration(milliseconds: on));
      if (!mounted || token != _token) return;
      setState(() => _lit = -1);
      await Future.delayed(Duration(milliseconds: gap));
    }
    if (!mounted || token != _token) return;
    setState(() {
      _playerTurn = true;
      _message = t3('Sua vez!', 'Your turn!', '¡Tu turno!');
    });
  }

  Future<void> _tapCrystal(int i) async {
    if (!_playerTurn) return;
    Haptics.light();
    _audio.playNote(i);
    setState(() => _lit = i);
    final token = _token;
    Future.delayed(const Duration(milliseconds: 190), () {
      if (mounted && token == _token && _lit == i) setState(() => _lit = -1);
    });

    if (_sequence[_inputIndex] != i) {
      _mistake(i);
      return;
    }
    setState(() => _inputIndex++);
    if (_inputIndex == _sequence.length) {
      setState(() {
        _playerTurn = false;
        _message = _level % 5 == 0
            ? t3('🌟 Incrível!', '🌟 Amazing!', '🌟 ¡Increíble!')
            : t3('✔ Muito bem!', '✔ Well done!', '✔ ¡Muy bien!');
      });
      await Future.delayed(const Duration(milliseconds: 250));
      if (_level % 5 == 0) {
        _audio.playSfx('combo');
      } else {
        _audio.playCorrectAnswer();
      }
      if (_level >= _maxLevel) {
        _endGame(true);
        return;
      }
      await Future.delayed(const Duration(milliseconds: 650));
      if (mounted && token == _token) _nextLevel();
    }
  }

  Future<void> _mistake(int wrong) async {
    _token++;
    Haptics.heavy();
    _audio.playWrongAnswer();
    setState(() {
      _playerTurn = false;
      _wrongCrystal = wrong;
      _shake++;
    });
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _wrongCrystal = -1);

    if (!_secondChanceUsed && _mode != SeqMode.master) {
      setState(() {
        _secondChanceUsed = true;
        _inputIndex = 0;
        _message = t3('💫 Segunda chance! Observe de novo', '💫 Second chance! Watch again', '💫 ¡Segunda oportunidad! Mira otra vez');
      });
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) _playSequence();
      return;
    }
    _endGame(false);
  }

  Future<void> _endGame(bool completedAll) async {
    final reached = completedAll ? _maxLevel : _level - 1;
    final prefs = await SharedPreferences.getInstance();
    final prev = _best[_mode] ?? 0;
    if (reached > prev) {
      await prefs.setInt('seq_best_${_mode.name}', reached);
      _best[_mode] = reached;
    }
    if (!mounted) return;
    final seconds = DateTime.now().difference(_startedAt).inSeconds;
    final won = reached >= 10;
    await recordGameResult(context, gameId: 'sequence', won: won, score: reached, seconds: seconds);
    if (!mounted) return;
    final stars = reached >= 20 ? 3 : (reached >= 12 ? 2 : (reached >= 6 ? 1 : 0));
    await showGameResult(
      context,
      won: won,
      accent: _accent,
      title: completedAll
          ? t3('Mestre dos Cristais!', 'Crystal Master!', '¡Maestro de Cristales!')
          : t3('Sequência de $reached', 'Sequence of $reached', 'Secuencia de $reached'),
      subtitle: won
          ? t3('Que memória musical!', 'What a musical memory!', '¡Qué memoria musical!')
          : t3('Chegue ao nível 10 para vencer', 'Reach level 10 to win', 'Llega al nivel 10 para ganar'),
      stars: stars,
      newRecord: reached > prev && prev > 0,
      stats: [
        ResultStat('💎', t3('Nível', 'Level', 'Nivel'), '$reached'),
        ResultStat('🏆', t3('Recorde', 'Best', 'Récord'), '${_best[_mode]}'),
        ResultStat('⏱️', t3('Tempo', 'Time', 'Tiempo'), formatGameTime(seconds)),
      ],
      primaryLabel: t3('Jogar de novo', 'Play again', 'Jugar de nuevo'),
      onPrimary: _start,
      secondaryLabel: t3('Mudar modo', 'Change mode', 'Cambiar modo'),
      onSecondary: () => setState(() => _configuring = true),
    );
  }

  // ==========================================================================
  // UI
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: t3('💎 Sequência Cristal', '💎 Crystal Sequence', '💎 Secuencia Cristal'),
      accent: _accent,
      onBack: _configuring
          ? null
          : () {
              _token++;
              setState(() => _configuring = true);
            },
      backgroundColors: const [Color(0xFF241542), Color(0xFF0B0716)],
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _ambient,
              builder: (_, __) => CustomPaint(painter: _SparklePainter(_ambient.value)),
            ),
          ),
          _configuring ? _buildConfig() : _buildGame(),
        ],
      ),
    );
  }

  Widget _buildConfig() {
    String modeName(SeqMode m) => {
          SeqMode.classic: t3('Clássico', 'Classic', 'Clásico'),
          SeqMode.master: t3('Mestre', 'Master', 'Maestro'),
          SeqMode.progressive: t3('Progressivo', 'Progressive', 'Progresivo'),
        }[m]!;
    String modeDesc(SeqMode m) => {
          SeqMode.classic: t3('4 cristais · segunda chance', '4 crystals · second chance', '4 cristales · segunda oportunidad'),
          SeqMode.master: t3('6 cristais · sem segunda chance', '6 crystals · no second chance', '6 cristales · sin segunda oportunidad'),
          SeqMode.progressive: t3('Começa com 4 e ganha cristais até 9', 'Starts with 4 and grows up to 9', 'Empieza con 4 y crece hasta 9'),
        }[m]!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      children: [
        GameHero(
          emoji: '💎',
          title: t3('Sequência Cristal', 'Crystal Sequence', 'Secuencia Cristal'),
          subtitle: t3('Cada cristal canta uma nota. Ouça, observe e repita a melodia!',
              'Each crystal sings a note. Listen, watch and repeat the melody!',
              'Cada cristal canta una nota. ¡Escucha, observa y repite la melodía!'),
          accent: _accent,
        ),
        const SizedBox(height: 20),
        ...SeqMode.values.map((m) {
          final sel = m == _mode;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                _audio.playNote(m.index * 2);
                setState(() => _mode = m);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: sel ? _accent.withValues(alpha: 0.2) : GameColors.panel.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: sel ? _accent : Colors.white10, width: sel ? 2 : 1),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 46,
                      height: 52,
                      child: CustomPaint(painter: _CrystalPainter(colors: _gems[[0, 4, 5][m.index]], lit: sel, glow: 0)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(modeName(m), style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                          Text(modeDesc(m), style: const TextStyle(color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const Text('🏆', style: TextStyle(fontSize: 16)),
                        Text('${_best[m] ?? 0}', style: const TextStyle(color: GameColors.gold, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        PillButton(label: t3('Começar', 'Start', 'Comenzar'), icon: Icons.play_arrow_rounded, color: _accent, expand: true, onTap: _start),
      ],
    );
  }

  Widget _buildGame() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
          child: Row(
            children: [
              HudChip(emoji: '💎', value: '${t3('Nível', 'Level', 'Nivel')} $_level', color: _accent, highlight: true),
              const Spacer(),
              HudChip(emoji: '🏆', value: '${_best[_mode] ?? 0}', color: GameColors.gold),
              if (_mode != SeqMode.master) ...[
                const SizedBox(width: 8),
                HudChip(emoji: _secondChanceUsed ? '🖤' : '💫', value: _secondChanceUsed ? '0' : '1'),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            _message,
            key: ValueKey(_message),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _playerTurn ? GameColors.gold : Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              shadows: const [Shadow(color: Colors.black54, blurRadius: 8)],
            ),
          ),
        ),
        const SizedBox(height: 10),
        _progressDots(),
        Expanded(
          child: LayoutBuilder(builder: (context, c) {
            final side = min(c.maxWidth, c.maxHeight) - 16;
            return Center(
              child: ShakeOnChange(
                trigger: _shake,
                amplitude: 10,
                child: SizedBox(width: side, height: side, child: _ring(side)),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _progressDots() {
    final total = _sequence.length;
    if (total == 0) return const SizedBox(height: 14);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 5,
        runSpacing: 5,
        children: List.generate(total, (i) {
          final done = _playerTurn ? i < _inputIndex : false;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? GameColors.gold : Colors.white.withValues(alpha: 0.18),
              boxShadow: done ? [const BoxShadow(color: Color(0x88FFC94A), blurRadius: 6)] : null,
            ),
          );
        }),
      ),
    );
  }

  Widget _ring(double side) {
    final n = _crystals;
    final radius = side * (n <= 4 ? 0.31 : (n <= 6 ? 0.34 : 0.36));
    final crystalW = side * (n <= 4 ? 0.28 : (n <= 6 ? 0.22 : 0.18));
    final center = Offset(side / 2, side / 2);
    return Stack(
      children: [
        // Orbe central
        Positioned(
          left: center.dx - side * 0.15,
          top: center.dy - side * 0.15,
          width: side * 0.3,
          height: side * 0.3,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                _lit >= 0 ? _gems[_lit][0] : const Color(0xFF6D5BA8),
                const Color(0xFF1A1033),
              ]),
              boxShadow: [
                BoxShadow(
                  color: (_lit >= 0 ? _gems[_lit][1] : _accent).withValues(alpha: _lit >= 0 ? 0.8 : 0.3),
                  blurRadius: _lit >= 0 ? 40 : 18,
                ),
              ],
              border: Border.all(color: Colors.white24, width: 2),
            ),
            alignment: Alignment.center,
            child: Text('$_level',
                style: TextStyle(color: Colors.white, fontSize: side * 0.09, fontWeight: FontWeight.w900)),
          ),
        ),
        ...List.generate(n, (i) {
          final angle = -pi / 2 + i * 2 * pi / n;
          final pos = center + Offset(cos(angle), sin(angle)) * radius;
          final lit = _lit == i;
          final wrong = _wrongCrystal == i;
          return Positioned(
            left: pos.dx - crystalW / 2,
            top: pos.dy - crystalW * 0.6,
            width: crystalW,
            height: crystalW * 1.2,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (_) => _tapCrystal(i),
              child: AnimatedScale(
                scale: lit ? 1.14 : 1,
                duration: const Duration(milliseconds: 120),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(end: lit ? 1 : 0),
                  duration: Duration(milliseconds: lit ? 60 : 260),
                  builder: (_, g, __) => CustomPaint(
                    painter: _CrystalPainter(
                      colors: wrong ? const [Color(0xFFFFFFFF), Color(0xFFEF4444), Color(0xFF7F1D1D)] : _gems[i],
                      lit: lit || wrong,
                      glow: wrong ? 1 : g,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

/// Gema facetada com brilho.
class _CrystalPainter extends CustomPainter {
  final List<Color> colors;
  final bool lit;
  final double glow;
  _CrystalPainter({required this.colors, required this.lit, required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final top = Offset(w / 2, h * 0.04);
    final ul = Offset(w * 0.06, h * 0.3);
    final ur = Offset(w * 0.94, h * 0.3);
    final ll = Offset(w * 0.18, h * 0.72);
    final lr = Offset(w * 0.82, h * 0.72);
    final bottom = Offset(w / 2, h * 0.98);
    final mid = Offset(w / 2, h * 0.42);

    final outline = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(ur.dx, ur.dy)
      ..lineTo(lr.dx, lr.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(ll.dx, ll.dy)
      ..lineTo(ul.dx, ul.dy)
      ..close();

    if (glow > 0) {
      canvas.drawPath(
          outline,
          Paint()
            ..color = colors[1].withValues(alpha: 0.75 * glow)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 18 * glow + 4));
    }
    // Sombra no chão
    canvas.drawOval(Rect.fromCenter(center: Offset(w / 2, h * 0.99), width: w * 0.6, height: h * 0.06),
        Paint()..color = Colors.black.withValues(alpha: 0.35));

    final dim = lit ? 1.0 : 0.62;
    Color shade(Color c, double f) => Color.lerp(Colors.black, c, f * dim)!;

    void facet(List<Offset> pts, Color c) {
      final p = Path()..moveTo(pts[0].dx, pts[0].dy);
      for (final o in pts.skip(1)) {
        p.lineTo(o.dx, o.dy);
      }
      p.close();
      canvas.drawPath(p, Paint()..color = c);
    }

    facet([top, ul, mid], shade(colors[0], 1.0));
    facet([top, mid, ur], shade(colors[0], 0.85));
    facet([ul, ll, mid], shade(colors[1], 1.0));
    facet([ur, mid, lr], shade(colors[1], 0.75));
    facet([ll, bottom, mid], shade(colors[2], 1.1));
    facet([mid, bottom, lr], shade(colors[2], 0.85));

    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withValues(alpha: lit ? 0.6 : 0.22);
    canvas.drawPath(outline, edge);
    for (final p in [ul, ur, ll, lr, top, bottom]) {
      canvas.drawLine(mid, p, edge..strokeWidth = 0.7);
    }
    // Reflexo
    canvas.drawPath(
        Path()
          ..moveTo(w * 0.32, h * 0.2)
          ..lineTo(w * 0.42, h * 0.14)
          ..lineTo(w * 0.36, h * 0.36)
          ..close(),
        Paint()..color = Colors.white.withValues(alpha: lit ? 0.8 : 0.35));
    if (lit) {
      canvas.drawCircle(Offset(w * 0.7, h * 0.24), w * 0.05, Paint()..color = Colors.white.withValues(alpha: 0.9));
    }
  }

  @override
  bool shouldRepaint(covariant _CrystalPainter old) => old.lit != lit || old.glow != glow || old.colors != colors;
}

/// Brilhos suaves no fundo da caverna.
class _SparklePainter extends CustomPainter {
  final double t;
  _SparklePainter(this.t);
  static final _pts = List.generate(40, (i) {
    final r = Random(i * 7919);
    return [r.nextDouble(), r.nextDouble(), r.nextDouble(), 0.6 + r.nextDouble() * 1.6];
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _pts) {
      final a = (sin((t + p[2]) * 2 * pi) + 1) / 2;
      canvas.drawCircle(Offset(p[0] * size.width, p[1] * size.height), p[3],
          Paint()..color = Colors.white.withValues(alpha: 0.08 + a * 0.35));
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter old) => old.t != t;
}
