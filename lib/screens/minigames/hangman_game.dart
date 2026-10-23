import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/audio_service.dart';
import 'common/game_results.dart';
import 'common/game_text.dart';
import 'common/game_ui.dart';
import 'hangman_words.dart';

const Color _accent = Color(0xFFFF8A65);
const int _maxErrors = 6;

class HangmanGame extends StatefulWidget {
  const HangmanGame({super.key});

  @override
  State<HangmanGame> createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> with SingleTickerProviderStateMixin {
  final _random = Random();
  late final AnimationController _anim =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();
  final FocusNode _focus = FocusNode();

  late HangmanWord _word;
  final Set<String> _right = {};
  final Set<String> _wrong = {};
  final List<String> _recent = [];
  bool _hintShown = false;
  bool _usedReveal = false;
  int _streak = 0;
  int _shake = 0;
  DateTime _startedAt = DateTime.now();
  bool _ending = false;

  @override
  void initState() {
    super.initState();
    _newWord();
  }

  @override
  void dispose() {
    _anim.dispose();
    _focus.dispose();
    super.dispose();
  }

  String get _plain => stripAccents(_word.word);
  Iterable<String> get _letters => _plain.split('').where(_isLetter);
  static bool _isLetter(String c) => RegExp(r'[A-ZÑ]').hasMatch(c);

  bool get _won => _letters.every(_right.contains);
  bool get _lost => _wrong.length >= _maxErrors;
  bool get _over => _won || _lost;

  void _newWord() {
    final bank = hangmanWordBank[gameLang] ?? hangmanWordBank['pt']!;
    HangmanWord next;
    do {
      next = bank[_random.nextInt(bank.length)];
    } while (_recent.contains(next.word) && bank.length > 10);
    _recent.add(next.word);
    if (_recent.length > 10) _recent.removeAt(0);
    setState(() {
      _word = next;
      _right.clear();
      _wrong.clear();
      _hintShown = false;
      _usedReveal = false;
      _ending = false;
      _startedAt = DateTime.now();
    });
    _focus.requestFocus();
  }

  void _guess(String letter) {
    if (_over || _right.contains(letter) || _wrong.contains(letter)) return;
    if (_plain.contains(letter)) {
      setState(() => _right.add(letter));
      HapticFeedback.selectionClick();
      if (_won) {
        _finish(true);
      } else {
        AudioService().playCorrectAnswer();
      }
    } else {
      setState(() {
        _wrong.add(letter);
        _shake++;
      });
      HapticFeedback.mediumImpact();
      if (_lost) {
        _finish(false);
      } else {
        AudioService().playWrongAnswer();
      }
    }
  }

  void _revealLetter() {
    if (_over || _usedReveal || _wrong.length >= _maxErrors - 1) return;
    final missing = _letters.where((l) => !_right.contains(l)).toSet().toList();
    if (missing.isEmpty) return;
    AudioService().playSfx('star');
    setState(() {
      _usedReveal = true;
      _wrong.add('•'); // custa uma vida
      _right.add(missing[_random.nextInt(missing.length)]);
    });
    if (_won) _finish(true);
  }

  Future<void> _finish(bool won) async {
    if (_ending) return;
    _ending = true;
    final errors = _wrong.length;
    if (won) {
      _streak++;
    } else {
      _streak = 0;
    }
    await Future.delayed(Duration(milliseconds: won ? 1100 : 1500));
    if (!mounted) return;
    final seconds = DateTime.now().difference(_startedAt).inSeconds;
    final stars = errors <= 1 ? 3 : (errors <= 3 ? 2 : 1);
    final saved = await recordGameResult(context,
        gameId: 'hangman',
        won: won,
        score: won ? max(10, 100 - errors * 12 + _streak * 5 - (_hintShown ? 5 : 0)) : 0,
        seconds: seconds,
        perfect: errors == 0);
    if (!mounted) return;
    await showGameResult(
      context,
      won: won,
      accent: _accent,
      title: won ? t3('Você acertou!', 'You got it!', '¡Acertaste!') : t3('Não foi dessa vez', 'Not this time', 'Esta vez no'),
      subtitle: '${_word.word}\n${_word.hint}',
      stars: won ? stars : -1,
      newRecord: saved.newRecord,
      stats: [
        ResultStat('❤️', t3('Vidas', 'Lives', 'Vidas'), '${_maxErrors - errors}/$_maxErrors'),
        ResultStat('🔥', t3('Sequência', 'Streak', 'Racha'), '$_streak'),
        ResultStat('⏱️', t3('Tempo', 'Time', 'Tiempo'), formatGameTime(seconds)),
      ],
      primaryLabel: t3('Próxima palavra', 'Next word', 'Siguiente palabra'),
      onPrimary: _newWord,
      secondaryLabel: t3('Sair', 'Exit', 'Salir'),
      onSecondary: () => Navigator.of(context).maybePop(),
    );
  }

  String _categoryLabel(String c) {
    switch (c) {
      case 'person': return t3('👤 Personagem', '👤 Person', '👤 Personaje');
      case 'place': return t3('📍 Lugar', '📍 Place', '📍 Lugar');
      case 'book': return t3('📖 Livro da Bíblia', '📖 Bible book', '📖 Libro bíblico');
      case 'animal': return t3('🐾 Animal', '🐾 Animal', '🐾 Animal');
      default: return t3('✨ Objeto / ideia', '✨ Object / idea', '✨ Objeto / idea');
    }
  }

  // ==========================================================================
  // UI
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: t3('🎯 Forca Bíblica', '🎯 Bible Hangman', '🎯 Ahorcado Bíblico'),
      accent: _accent,
      backgroundColors: const [Color(0xFF1E2A44), Color(0xFF111827)],
      actions: [
        if (_streak > 0)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(child: Text('🔥 $_streak', style: const TextStyle(color: GameColors.gold, fontWeight: FontWeight.w900, fontSize: 16))),
          ),
      ],
      body: Focus(
        focusNode: _focus,
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent && event.character != null) {
            final ch = stripAccents(event.character!.toUpperCase());
            if (ch.length == 1 && _isLetter(ch)) {
              _guess(ch);
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Column(
          children: [
            Expanded(flex: 11, child: _scene()),
            _hintRow(),
            Expanded(flex: 4, child: _wordView()),
            _keyboard(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _scene() {
    final lives = _maxErrors - _wrong.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
      child: ShakeOnChange(
        trigger: _shake,
        amplitude: 6,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _lost
                  ? const [Color(0xFF4C3B6B), Color(0xFFB8737A)]
                  : const [Color(0xFF8FD3FE), Color(0xFFDDF3FF)],
            ),
            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 5))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _anim,
                    builder: (_, __) => CustomPaint(
                      painter: _HangmanScenePainter(
                        errors: _wrong.length,
                        won: _won,
                        lost: _lost,
                        t: _anim.value,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 12,
                  child: Row(
                    children: List.generate(_maxErrors, (i) {
                      final alive = i < lives;
                      return AnimatedScale(
                        scale: alive ? 1 : 0.75,
                        duration: const Duration(milliseconds: 250),
                        child: Text(alive ? '❤️' : '🤍', style: const TextStyle(fontSize: 15)),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _hintRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: _accent.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(12)),
                  child: Text(_categoryLabel(_word.category),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ),
              const SizedBox(width: 6),
              _smallAction(
                '💡 ${t3('Dica', 'Hint', 'Pista')}',
                _hintShown || _over ? null : () => setState(() => _hintShown = true),
              ),
              const SizedBox(width: 6),
              _smallAction(
                '🔤 −❤️',
                _usedReveal || _over || _wrong.length >= _maxErrors - 1 ? null : _revealLetter,
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            child: _hintShown || _over
                ? Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('“${_word.hint}”',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFFFFE0B2), fontSize: 15, fontStyle: FontStyle.italic)),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _smallAction(String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap == null
          ? null
          : () {
              AudioService().playClick();
              onTap();
            },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: onTap == null ? 0.35 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: GameColors.panel,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  Widget _wordView() {
    final display = _word.word.split('');
    final plain = _plain.split('');
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(display.length, (i) {
              final isLetter = _isLetter(plain[i]);
              if (!isLetter) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(display[i], style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                );
              }
              final revealed = _right.contains(plain[i]);
              final missed = _lost && !revealed;
              return Container(
                width: 38,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: revealed ? const Color(0xFF2B3E66) : (missed ? const Color(0xFF5A2330) : GameColors.panel),
                  borderRadius: BorderRadius.circular(10),
                  border: Border(bottom: BorderSide(color: revealed ? _accent : Colors.white38, width: 3)),
                ),
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (c, a) => ScaleTransition(scale: CurvedAnimation(parent: a, curve: Curves.elasticOut), child: c),
                  child: Text(
                    revealed || missed ? display[i] : '',
                    key: ValueKey(revealed || missed),
                    style: TextStyle(
                      color: missed ? const Color(0xFFFF8A80) : Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _keyboard() {
    final rows = gameLang == 'es'
        ? const ['QWERTYUIOP', 'ASDFGHJKLÑ', 'ZXCVBNM']
        : const ['QWERTYUIOP', 'ASDFGHJKL', 'ZXCVBNM'];
    return LayoutBuilder(builder: (context, c) {
      final keyW = min(42.0, (c.maxWidth - 16 - 9 * 5) / 10);
      return Column(
        children: rows.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.split('').map((l) {
                final ok = _right.contains(l);
                final bad = _wrong.contains(l);
                final used = ok || bad;
                final color = ok ? const Color(0xFF22C55E) : (bad ? const Color(0xFF7F1D1D) : const Color(0xFF3B5B92));
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: GestureDetector(
                    onTap: used || _over ? null : () => _guess(l),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: keyW,
                      height: keyW * 1.22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: used ? color.withValues(alpha: 0.85) : color,
                        borderRadius: BorderRadius.circular(9),
                        border: Border(bottom: BorderSide(color: Colors.black.withValues(alpha: used ? 0.1 : 0.35), width: 3)),
                      ),
                      child: Text(l,
                          style: TextStyle(
                            color: used && !ok ? Colors.white38 : Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: keyW * 0.45,
                          )),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      );
    });
  }
}

// ============================================================================
// CENA (forca + personagem), desenhada num espaço virtual de 100 x 80
// ============================================================================

class _HangmanScenePainter extends CustomPainter {
  final int errors;
  final bool won, lost;
  final double t;
  _HangmanScenePainter({required this.errors, required this.won, required this.lost, required this.t});

  static const skin = Color(0xFFF2C29B);
  static const hair = Color(0xFF5B3A1E);
  static const shirt = Color(0xFF3B82F6);
  static const pants = Color(0xFF1E3A8A);
  static const shoe = Color(0xFF3F2A1E);
  static const wood = Color(0xFF9A6334);
  static const woodDark = Color(0xFF6B4423);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = min(size.width / 100, size.height / 80);
    canvas.save();
    canvas.translate((size.width - 100 * scale) / 2, size.height - 80 * scale);
    canvas.scale(scale);

    _background(canvas, size, scale);
    _gallows(canvas);

    if (won) {
      // Personagem livre, comemorando no chão
      final bounce = -sin(t * pi * 2).abs() * 3;
      canvas.save();
      canvas.translate(18, 11 + bounce);
      _character(canvas, parts: 6, mood: _Mood.happy, armsUp: true);
      canvas.restore();
    } else {
      canvas.save();
      if (lost) {
        canvas.translate(62, 10);
        canvas.rotate(sin(t * pi * 2) * 0.07);
        canvas.translate(-62, -10);
      }
      if (errors > 0) {
        _rope(canvas, 19);
      } else {
        _rope(canvas, 16);
      }
      _character(
        canvas,
        parts: errors,
        mood: lost ? _Mood.sad : (errors >= 4 ? _Mood.scared : (errors >= 2 ? _Mood.worried : _Mood.ok)),
        armsUp: false,
      );
      canvas.restore();
    }
    canvas.restore();
  }

  void _background(Canvas canvas, Size size, double scale) {
    // Sol/lua e nuvens
    final sunColor = lost ? const Color(0xFFFFF3C4) : const Color(0xFFFFD54F);
    canvas.drawCircle(const Offset(86, 12), 6, Paint()..color = sunColor.withValues(alpha: 0.35));
    canvas.drawCircle(const Offset(86, 12), 4.3, Paint()..color = sunColor);
    final cloud = Paint()..color = Colors.white.withValues(alpha: lost ? 0.25 : 0.85);
    final dx = (t * 20) % 120 - 10;
    for (final c in [Offset(dx, 16), Offset((dx + 55) % 120 - 10, 8)]) {
      canvas.drawCircle(c, 3.5, cloud);
      canvas.drawCircle(c + const Offset(4, -1.5), 4.2, cloud);
      canvas.drawCircle(c + const Offset(8.5, 0), 3.2, cloud);
    }
    // Chão (colina)
    final ground = Path()
      ..moveTo(-20, 74)
      ..quadraticBezierTo(50, 66, 120, 73)
      ..lineTo(120, 90)
      ..lineTo(-20, 90)
      ..close();
    canvas.drawPath(ground, Paint()..color = lost ? const Color(0xFF4D6B3C) : const Color(0xFF6CC24A));
    final grass = Paint()
      ..color = lost ? const Color(0xFF3E5A30) : const Color(0xFF4FA233)
      ..strokeWidth = 0.6
      ..strokeCap = StrokeCap.round;
    for (double x = 2; x < 100; x += 6) {
      canvas.drawLine(Offset(x, 74.5), Offset(x + 1, 72.5), grass);
    }
  }

  void _gallows(Canvas canvas) {
    final w = Paint()..color = wood;
    final d = Paint()..color = woodDark;
    canvas.drawRRect(RRect.fromLTRBR(10, 69, 42, 73, const Radius.circular(1)), d);
    canvas.drawRRect(RRect.fromLTRBR(22, 7, 26, 70, const Radius.circular(1)), w);
    canvas.drawRect(const Rect.fromLTRB(25, 7, 26, 70), d);
    canvas.drawRRect(RRect.fromLTRBR(21, 6, 66, 10, const Radius.circular(1)), w);
    canvas.drawRect(const Rect.fromLTRB(21, 9, 66, 10), d);
    canvas.drawLine(const Offset(26, 19), const Offset(37, 10), Paint()
      ..color = wood
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round);
    // veios da madeira
    final grain = Paint()
      ..color = woodDark.withValues(alpha: 0.5)
      ..strokeWidth = 0.3;
    for (double y = 15; y < 66; y += 9) {
      canvas.drawLine(Offset(23, y), Offset(23.5, y + 4), grain);
    }
  }

  void _rope(Canvas canvas, double end) {
    canvas.drawLine(
        const Offset(62, 10),
        Offset(62, end),
        Paint()
          ..color = const Color(0xFFD9B77E)
          ..strokeWidth = 0.9);
  }

  void _character(Canvas canvas, {required int parts, required _Mood mood, required bool armsUp}) {
    final stroke = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Pernas (5, 6)
    if (parts >= 5) {
      stroke
        ..color = pants
        ..strokeWidth = 2.8;
      canvas.drawLine(const Offset(60, 44), const Offset(58, 57.5), stroke);
      canvas.drawOval(Rect.fromCenter(center: const Offset(57, 59), width: 4.6, height: 2.2), Paint()..color = shoe);
    }
    if (parts >= 6) {
      stroke
        ..color = pants
        ..strokeWidth = 2.8;
      canvas.drawLine(const Offset(64, 44), const Offset(66, 57.5), stroke);
      canvas.drawOval(Rect.fromCenter(center: const Offset(67, 59), width: 4.6, height: 2.2), Paint()..color = shoe);
    }

    // Braços (3, 4)
    void arm(Offset from, Offset to) {
      stroke
        ..color = shirt
        ..strokeWidth = 2.4;
      final mid = Offset.lerp(from, to, 0.55)!;
      canvas.drawLine(from, mid, stroke);
      stroke
        ..color = skin
        ..strokeWidth = 1.8;
      canvas.drawLine(mid, to, stroke);
      canvas.drawCircle(to, 1.35, Paint()..color = skin);
    }

    if (parts >= 3) arm(const Offset(58.5, 31.5), armsUp ? const Offset(52, 21) : const Offset(53, 40.5));
    if (parts >= 4) arm(const Offset(65.5, 31.5), armsUp ? const Offset(72, 21) : const Offset(71, 40.5));

    // Corpo (2)
    if (parts >= 2) {
      final body = RRect.fromLTRBR(57.5, 29.5, 66.5, 45.5, const Radius.circular(2.6));
      canvas.drawRRect(body, Paint()..color = shirt);
      canvas.drawRect(const Rect.fromLTRB(57.5, 42.5, 66.5, 45.5), Paint()..color = pants);
      canvas.drawRect(const Rect.fromLTRB(57.5, 42, 66.5, 42.8), Paint()..color = const Color(0xFF3F2A1E));
      // gola
      canvas.drawPath(
          Path()
            ..moveTo(60, 29.6)
            ..lineTo(62, 32)
            ..lineTo(64, 29.6),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.9)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.7);
    }

    // Cabeça (1)
    if (parts >= 1) {
      const c = Offset(62, 24.5);
      canvas.drawCircle(c, 5.6, Paint()..color = skin);
      // cabelo
      final hairPath = Path()
        ..moveTo(56.5, 24)
        ..quadraticBezierTo(56, 17.5, 62, 18.2)
        ..quadraticBezierTo(68.4, 17.6, 67.6, 24)
        ..quadraticBezierTo(65, 20.5, 61, 21.4)
        ..quadraticBezierTo(58.5, 21.8, 56.5, 24)
        ..close();
      canvas.drawPath(hairPath, Paint()..color = hair);
      // bochechas
      final cheek = Paint()..color = const Color(0x55FF7A7A);
      canvas.drawCircle(const Offset(58.8, 26.8), 1.1, cheek);
      canvas.drawCircle(const Offset(65.2, 26.8), 1.1, cheek);
      _face(canvas, mood);
    }
  }

  void _face(Canvas canvas, _Mood mood) {
    final ink = Paint()
      ..color = const Color(0xFF2B1B10)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = const Color(0xFF2B1B10);

    // Olhos
    if (mood == _Mood.sad) {
      canvas.drawArc(Rect.fromCenter(center: const Offset(60, 24.2), width: 2, height: 1.4), 0, pi, false, ink);
      canvas.drawArc(Rect.fromCenter(center: const Offset(64, 24.2), width: 2, height: 1.4), 0, pi, false, ink);
    } else if (mood == _Mood.happy) {
      canvas.drawArc(Rect.fromCenter(center: const Offset(60, 24.6), width: 2, height: 1.6), pi, pi, false, ink);
      canvas.drawArc(Rect.fromCenter(center: const Offset(64, 24.6), width: 2, height: 1.6), pi, pi, false, ink);
    } else {
      final r = mood == _Mood.scared ? 0.95 : 0.75;
      canvas.drawCircle(const Offset(60, 24), r, fill);
      canvas.drawCircle(const Offset(64, 24), r, fill);
      canvas.drawCircle(const Offset(60.3, 23.7), 0.25, Paint()..color = Colors.white);
      canvas.drawCircle(const Offset(64.3, 23.7), 0.25, Paint()..color = Colors.white);
    }

    // Sobrancelhas
    if (mood == _Mood.worried || mood == _Mood.scared || mood == _Mood.sad) {
      canvas.drawLine(const Offset(58.8, 22.2), const Offset(60.8, 21.6), ink);
      canvas.drawLine(const Offset(65.2, 22.2), const Offset(63.2, 21.6), ink);
    }

    // Boca
    switch (mood) {
      case _Mood.ok:
        canvas.drawArc(Rect.fromCenter(center: const Offset(62, 27), width: 3.2, height: 2), 0.2, pi - 0.4, false, ink);
        break;
      case _Mood.worried:
        canvas.drawLine(const Offset(60.6, 27.8), const Offset(63.4, 27.6), ink);
        break;
      case _Mood.scared:
        canvas.drawOval(Rect.fromCenter(center: const Offset(62, 28), width: 1.8, height: 2.2), fill);
        break;
      case _Mood.sad:
        canvas.drawArc(Rect.fromCenter(center: const Offset(62, 29), width: 3.2, height: 2), pi + 0.2, pi - 0.4, false, ink);
        break;
      case _Mood.happy:
        final mouth = Path()
          ..moveTo(59.8, 26.8)
          ..quadraticBezierTo(62, 30.6, 64.2, 26.8)
          ..close();
        canvas.drawPath(mouth, fill);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _HangmanScenePainter old) =>
      old.errors != errors || old.won != won || old.lost != lost || old.t != t;
}

enum _Mood { ok, worried, scared, sad, happy }
