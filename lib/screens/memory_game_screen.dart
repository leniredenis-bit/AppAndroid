import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/stats_service.dart';
import '../services/audio_service.dart';
import '../services/minigame_content_service.dart';
import '../widgets/emoji_text.dart';
import 'minigames/common/game_results.dart';
import 'minigames/common/game_text.dart';
import 'minigames/common/game_ui.dart';

const Color _accent = Color(0xFFFF6B6B);
const List<Color> _playerColors = [Color(0xFF60A5FA), Color(0xFFF472B6), Color(0xFF4ADE80), Color(0xFFFBBF24)];

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class MemoryCard {
  final int id;
  final String emoji;
  final String name;
  bool isFlipped;
  bool isMatched;
  int shake = 0;
  int matchedBy = -1;

  MemoryCard({required this.id, required this.emoji, required this.name, this.isFlipped = false, this.isMatched = false});
}

/// Temas do jogo da memória com nomes traduzidos.
class MemoryThemes {
  static final MinigameContentService _contentService = MinigameContentService();

  static const List<String> keys = [
    'animais', 'frutas', 'aves', 'vida_marinha', 'natureza', 'transportes', 'objetos', 'numeros', 'todos',
  ];

  static Map<String, List<Map<String, String>>> get themes => _contentService.memoryThemes;

  static List<Map<String, String>> getThemeItems(String theme) {
    if (theme == 'todos') {
      final seen = <String>{};
      final all = <Map<String, String>>[];
      for (final list in themes.values) {
        for (final item in list) {
          if (seen.add(item['emoji']!)) all.add(item);
        }
      }
      return all..shuffle();
    }
    return List<Map<String, String>>.from(themes[theme] ?? themes['animais']!);
  }

  static String emoji(String theme) => const {
        'animais': '🐶', 'frutas': '🍎', 'transportes': '🚗', 'vida_marinha': '🐠', 'aves': '🦜',
        'numeros': '🔢', 'objetos': '💡', 'natureza': '🌸', 'todos': '🎲',
      }[theme] ?? '🎴';

  static String name(String theme) {
    switch (theme) {
      case 'animais': return t3('Animais', 'Animals', 'Animales');
      case 'frutas': return t3('Frutas', 'Fruits', 'Frutas');
      case 'transportes': return t3('Transportes', 'Transport', 'Transportes');
      case 'vida_marinha': return t3('Vida Marinha', 'Sea Life', 'Vida Marina');
      case 'aves': return t3('Aves', 'Birds', 'Aves');
      case 'numeros': return t3('Números', 'Numbers', 'Números');
      case 'objetos': return t3('Objetos', 'Objects', 'Objetos');
      case 'natureza': return t3('Natureza', 'Nature', 'Naturaleza');
      default: return t3('Todos', 'All', 'Todos');
    }
  }
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  // Configuração
  bool _configuring = true;
  String _theme = 'animais';
  int _pairs = 10;
  int _players = 1;

  // Partida
  List<MemoryCard> _cards = [];
  final List<int> _open = [];
  int _attempts = 0;
  int _matches = 0;
  int _combo = 0;
  int _bestCombo = 0;
  int _seconds = 0;
  int _current = 0;
  List<int> _scores = [0];
  bool _busy = false;
  bool _peeking = false;
  String? _toast;
  int _toastId = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    AudioService().playBackgroundMusic('memory');
  }

  @override
  void dispose() {
    _timer?.cancel();
    AudioService().stopBackgroundMusic();
    super.dispose();
  }

  void _start() {
    final items = MemoryThemes.getThemeItems(_theme)..shuffle();
    final chosen = items.take(_pairs).toList();
    int id = 0;
    final cards = <MemoryCard>[];
    for (final item in chosen) {
      cards.add(MemoryCard(id: id++, emoji: item['emoji']!, name: item['name']!));
      cards.add(MemoryCard(id: id++, emoji: item['emoji']!, name: item['name']!));
    }
    cards.shuffle();

    setState(() {
      _configuring = false;
      _cards = cards;
      _open.clear();
      _attempts = 0;
      _matches = 0;
      _combo = 0;
      _bestCombo = 0;
      _seconds = 0;
      _current = 0;
      _scores = List.filled(_players, 0);
      _busy = true;
      _peeking = true;
    });

    // Espiada inicial: mais longa no fácil, nenhuma no difícil
    final peekMs = _pairs <= 6 ? 1800 : (_pairs <= 10 ? 1100 : 0);
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted || peekMs == 0) return;
      setState(() {
        for (final c in _cards) {
          c.isFlipped = true;
        }
      });
      AudioService().playSfx('whoosh', volume: 0.6);
    });
    Future.delayed(Duration(milliseconds: 350 + peekMs + (peekMs > 0 ? 200 : 0)), () {
      if (!mounted) return;
      setState(() {
        for (final c in _cards) {
          c.isFlipped = false;
        }
        _peeking = false;
        _busy = false;
      });
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _seconds++);
      });
    });
  }

  void _showToast(String text) {
    final id = ++_toastId;
    setState(() => _toast = text);
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted && _toastId == id) setState(() => _toast = null);
    });
  }

  void _tap(int index) {
    final card = _cards[index];
    if (_busy || card.isFlipped || card.isMatched || _open.length >= 2) return;

    AudioService().playCardFlip();
    HapticFeedback.selectionClick();
    setState(() {
      card.isFlipped = true;
      _open.add(index);
    });
    if (_open.length == 2) {
      _busy = true;
      Future.delayed(const Duration(milliseconds: 380), _check);
    }
  }

  void _check() {
    if (!mounted) return;
    final a = _cards[_open[0]];
    final b = _cards[_open[1]];
    _attempts++;

    if (a.emoji == b.emoji) {
      _combo++;
      _bestCombo = max(_bestCombo, _combo);
      setState(() {
        a.isMatched = b.isMatched = true;
        a.matchedBy = b.matchedBy = _current;
        _matches++;
        _scores[_current]++;
        _open.clear();
        _busy = false;
      });
      HapticFeedback.mediumImpact();
      if (_combo >= 2) {
        AudioService().playSfx('combo');
        _showToast('🔥 Combo x$_combo!');
      } else {
        AudioService().playMatch();
        _showToast('✨ ${a.name}');
      }
      if (_matches == _pairs) _finish();
    } else {
      _combo = 0;
      AudioService().playMismatch();
      HapticFeedback.lightImpact();
      setState(() {
        a.shake++;
        b.shake++;
      });
      Future.delayed(const Duration(milliseconds: 650), () {
        if (!mounted) return;
        setState(() {
          a.isFlipped = b.isFlipped = false;
          _open.clear();
          _busy = false;
          if (_players > 1) _current = (_current + 1) % _players;
        });
      });
    }
  }

  Future<void> _finish() async {
    _timer?.cancel();
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final perfect = _attempts == _pairs;
    final ratio = _attempts / _pairs;
    final stars = ratio <= 1.4 ? 3 : (ratio <= 2.0 ? 2 : 1);
    final score = max(10, _pairs * 100 - (_attempts - _pairs) * 10 - _seconds);

    StatsService.saveMemoryGameStats(timeInSeconds: _seconds);
    final saved = await recordGameResult(context,
        gameId: 'memory', won: true, score: score, seconds: _seconds, perfect: perfect && _players == 1);
    if (!mounted) return;

    String title;
    String? subtitle;
    if (_players > 1) {
      final best = _scores.reduce(max);
      final winners = [for (int i = 0; i < _players; i++) if (_scores[i] == best) i];
      title = winners.length == 1
          ? t3('Jogador ${winners.first + 1} venceu!', 'Player ${winners.first + 1} wins!',
              '¡Jugador ${winners.first + 1} ganó!')
          : t3('Empate!', "It's a tie!", '¡Empate!');
      subtitle = List.generate(_players, (i) => 'J${i + 1}: ${_scores[i]}').join('   ·   ');
    } else {
      title = perfect ? t3('Memória perfeita!', 'Perfect memory!', '¡Memoria perfecta!') : t3('Parabéns!', 'Well done!', '¡Felicidades!');
    }

    await showGameResult(
      context,
      won: true,
      accent: _accent,
      title: title,
      subtitle: subtitle,
      stars: _players == 1 ? stars : -1,
      newRecord: _players == 1 && saved.newRecord,
      stats: [
        ResultStat('⏱️', t3('Tempo', 'Time', 'Tiempo'), formatGameTime(_seconds)),
        ResultStat('🎯', t3('Tentativas', 'Attempts', 'Intentos'), '$_attempts'),
        ResultStat('🔥', t3('Maior combo', 'Best combo', 'Mejor combo'), 'x$_bestCombo'),
      ],
      primaryLabel: t3('Jogar de novo', 'Play again', 'Jugar de nuevo'),
      onPrimary: _start,
      secondaryLabel: t3('Mudar opções', 'Change options', 'Cambiar opciones'),
      onSecondary: () => setState(() => _configuring = true),
    );
  }

  // ==========================================================================
  // UI
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: t3('🧠 Jogo da Memória', '🧠 Memory Game', '🧠 Juego de Memoria'),
      accent: _accent,
      onBack: _configuring
          ? null
          : () {
              _timer?.cancel();
              setState(() => _configuring = true);
            },
      backgroundColors: const [Color(0xFF2A1730), Color(0xFF120E1E)],
      body: _configuring ? _buildConfig() : _buildGame(),
    );
  }

  Widget _buildConfig() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      children: [
        GameHero(
          emoji: '🧠',
          title: t3('Jogo da Memória', 'Memory Game', 'Juego de Memoria'),
          subtitle: t3('Encontre todos os pares no menor número de tentativas',
              'Find all the pairs in as few attempts as possible', 'Encuentra todos los pares con menos intentos'),
          accent: _accent,
        ),
        const SizedBox(height: 22),
        GamePanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t3('TEMA', 'THEME', 'TEMA'),
                  style: const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.15,
                children: MemoryThemes.keys.map((k) {
                  final sel = k == _theme;
                  return GestureDetector(
                    onTap: () {
                      AudioService().playClick();
                      setState(() => _theme = k);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      decoration: BoxDecoration(
                        color: sel ? _accent.withValues(alpha: 0.22) : GameColors.panelLight.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: sel ? _accent : Colors.white10, width: sel ? 2 : 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmojiText(MemoryThemes.emoji(k), size: 28),
                          const SizedBox(height: 4),
                          Text(MemoryThemes.name(k),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: sel ? Colors.white : Colors.white70,
                                  fontSize: 12,
                                  fontWeight: sel ? FontWeight.w800 : FontWeight.w600)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              OptionPicker<int>(
                title: t3('Dificuldade', 'Difficulty', 'Dificultad'),
                accent: _accent,
                selected: _pairs,
                onChanged: (v) => setState(() => _pairs = v),
                options: [
                  OptionItem(6, t3('Fácil', 'Easy', 'Fácil'), t3('6 pares', '6 pairs', '6 pares')),
                  OptionItem(10, t3('Médio', 'Medium', 'Medio'), t3('10 pares', '10 pairs', '10 pares')),
                  OptionItem(15, t3('Difícil', 'Hard', 'Difícil'), t3('15 pares', '15 pairs', '15 pares')),
                ],
              ),
              const SizedBox(height: 18),
              OptionPicker<int>(
                title: t3('Jogadores', 'Players', 'Jugadores'),
                accent: _accent,
                selected: _players,
                onChanged: (v) => setState(() => _players = v),
                options: [
                  OptionItem(1, t3('Solo', 'Solo', 'Solo'), '👤'),
                  const OptionItem(2, '2', '👥'),
                  const OptionItem(3, '3', '👥'),
                  const OptionItem(4, '4', '👥'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        PillButton(
          label: t3('Começar', 'Start', 'Comenzar'),
          icon: Icons.play_arrow_rounded,
          color: _accent,
          expand: true,
          onTap: _start,
        ),
      ],
    );
  }

  Widget _buildGame() {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: _players > 1 ? _playersBar() : _soloBar(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                child: LayoutBuilder(builder: (context, c) => _grid(c.maxWidth, c.maxHeight)),
              ),
            ),
          ],
        ),
        // Mensagem flutuante (par / combo)
        Positioned(
          left: 0,
          right: 0,
          top: 64,
          child: IgnorePointer(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: FadeTransition(opacity: anim, child: child)),
              child: _toast == null
                  ? const SizedBox.shrink()
                  : Center(
                      key: ValueKey(_toastId),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: GameColors.gold.withValues(alpha: 0.6)),
                        ),
                        child: Text(_toast!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                      ),
                    ),
            ),
          ),
        ),
        if (_peeking)
          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: Center(
              child: Text(t3('👀 Memorize!', '👀 Memorize!', '👀 ¡Memoriza!'),
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
            ),
          ),
      ],
    );
  }

  Widget _soloBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        HudChip(emoji: '⏱️', value: formatGameTime(_seconds)),
        HudChip(emoji: '🎯', value: '$_attempts'),
        HudChip(emoji: '✅', value: '$_matches/$_pairs', color: GameColors.success, highlight: _matches > 0),
        HudChip(emoji: '🔥', value: 'x$_combo', color: GameColors.gold, highlight: _combo >= 2),
      ],
    );
  }

  Widget _playersBar() {
    return Row(
      children: List.generate(_players, (i) {
        final active = i == _current;
        final color = _playerColors[i];
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: active ? color.withValues(alpha: 0.25) : GameColors.panel,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: active ? color : Colors.white10, width: active ? 2 : 1),
            ),
            child: Column(
              children: [
                Text('${active ? '▶ ' : ''}J${i + 1}',
                    style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13)),
                Text('${_scores[i]}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Grade que sempre cabe na tela: escolhe o nº de colunas que dá a maior carta.
  Widget _grid(double w, double h) {
    final n = _cards.length;
    const gap = 8.0;
    const aspect = 0.78; // largura / altura
    int bestCols = 3;
    double bestW = 0;
    for (int cols = 2; cols <= 8; cols++) {
      final rows = (n / cols).ceil();
      final cw = (w - gap * (cols - 1)) / cols;
      final ch = (h - gap * (rows - 1)) / rows;
      final cardW = min(cw, ch * aspect);
      if (cardW > bestW) {
        bestW = cardW;
        bestCols = cols;
      }
    }
    final cardH = bestW / aspect;
    final rows = (n / bestCols).ceil();
    return Center(
      child: SizedBox(
        width: bestCols * bestW + gap * (bestCols - 1),
        height: rows * cardH + gap * (rows - 1),
        child: Wrap(
          spacing: gap,
          runSpacing: gap,
          children: List.generate(n, (i) {
            return SizedBox(
              width: bestW,
              height: cardH,
              child: _MemoryCardView(
                card: _cards[i],
                onTap: () => _tap(i),
                ownerColor: _players > 1 && _cards[i].matchedBy >= 0 ? _playerColors[_cards[i].matchedBy] : null,
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _MemoryCardView extends StatelessWidget {
  final MemoryCard card;
  final VoidCallback onTap;
  final Color? ownerColor;
  const _MemoryCardView({required this.card, required this.onTap, this.ownerColor});

  @override
  Widget build(BuildContext context) {
    final faceUp = card.isFlipped || card.isMatched;
    return GestureDetector(
      onTap: onTap,
      child: ShakeOnChange(
        trigger: card.shake,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: faceUp ? 1 : 0),
          duration: const Duration(milliseconds: 360),
          curve: Curves.easeInOutCubic,
          builder: (context, v, _) {
            final showFront = v >= 0.5;
            final angle = v * pi;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0015)
                ..rotateY(angle),
              child: showFront
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi),
                      child: _front(context),
                    )
                  : _back(),
            );
          },
        ),
      ),
    );
  }

  Widget _back() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7C3AED), Color(0xFF3B1E8C)],
        ),
        border: Border.all(color: Colors.white24, width: 1.5),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: CustomPaint(
        painter: _CardBackPainter(),
        child: const Center(child: Icon(Icons.auto_awesome, color: Color(0xCCFFE08A), size: 26)),
      ),
    );
  }

  Widget _front(BuildContext context) {
    final matched = card.isMatched;
    final border = ownerColor ?? (matched ? GameColors.gold : Colors.white24);
    return LayoutBuilder(builder: (context, c) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: matched
                ? [const Color(0xFF2E5A3E), const Color(0xFF1C3A2A)]
                : [const Color(0xFFFDFBF7), const Color(0xFFE9E4F5)],
          ),
          border: Border.all(color: border, width: matched ? 2.5 : 1.5),
          boxShadow: [
            if (matched) BoxShadow(color: border.withValues(alpha: 0.5), blurRadius: 12),
            const BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: FittedBox(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1, end: matched ? 1.15 : 1),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                    builder: (_, s, child) => Transform.scale(scale: s, child: child),
                    child: EmojiText(card.emoji, size: 44),
                  ),
                ),
              ),
              if (c.maxHeight > 64)
                Text(
                  card.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: matched ? Colors.white : const Color(0xFF3B2E5A),
                    fontSize: (c.maxWidth / 7).clamp(9.0, 13.0),
                    fontWeight: FontWeight.w800,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _CardBackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final inner = RRect.fromRectAndRadius(
        Rect.fromLTWH(5, 5, size.width - 10, size.height - 10), const Radius.circular(10));
    canvas.drawRRect(
        inner,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = const Color(0x55FFE08A));
    final dot = Paint()..color = Colors.white.withValues(alpha: 0.08);
    const step = 10.0;
    for (double y = 10; y < size.height - 6; y += step) {
      for (double x = 10 + (y ~/ step).isOdd.toInt() * step / 2; x < size.width - 6; x += step) {
        canvas.drawCircle(Offset(x, y), 1.4, dot);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension on bool {
  int toInt() => this ? 1 : 0;
}
