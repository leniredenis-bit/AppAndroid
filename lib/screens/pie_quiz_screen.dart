import 'dart:math';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import '../utils/i18n.dart';
import '../widgets/bible_reference_button.dart';
import 'minigames/common/game_ui.dart';

const Color _accent = Color(0xFFFF8A3D);
const List<Color> _playerColors = [Color(0xFF60A5FA), Color(0xFFF472B6)];

/// Torta na Cara: duelo local com apresentador.
/// O apresentador lê a pergunta, os dois respondem em voz alta, ele revela
/// a resposta e marca quem acertou — quem perde a rodada leva uma torta! 🥧
class PieQuizScreen extends StatefulWidget {
  final List<Question> questions;
  final String playerName; // mantido por compatibilidade
  final Future<List<Question>> Function()? replay;

  const PieQuizScreen({super.key, required this.questions, this.playerName = '', this.replay});

  @override
  State<PieQuizScreen> createState() => _PieQuizScreenState();
}

class _PieQuizScreenState extends State<PieQuizScreen> with TickerProviderStateMixin {
  final _names = [TextEditingController(), TextEditingController()];
  bool _started = false;
  List<Question> _questions = [];
  int _index = 0;
  final List<int> _scores = [0, 0];
  final List<int> _pies = [0, 0];
  bool _revealed = false;
  int? _roundResult; // 0, 1 = vencedor; -1 = ninguém
  late final AnimationController _pieAnim;
  List<int> _pieTargets = [];

  @override
  void initState() {
    super.initState();
    _questions = widget.questions;
    _pieAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    AudioService().playBackgroundMusic('pie');
  }

  @override
  void dispose() {
    for (final c in _names) {
      c.dispose();
    }
    _pieAnim.dispose();
    AudioService().stopBackgroundMusic();
    super.dispose();
  }

  String _name(int i) {
    final n = _names[i].text.trim();
    return n.isEmpty ? t3('Jogador ${i + 1}', 'Player ${i + 1}', 'Jugador ${i + 1}') : n;
  }

  Question get _q => _questions[_index];
  bool get _last => _index == _questions.length - 1;

  void _reveal() {
    AudioService().playSfx('whoosh', volume: 0.7);
    setState(() => _revealed = true);
  }

  /// Marca o resultado da rodada. Quem não acertou leva torta.
  void _score(int result) {
    if (_roundResult != null) return;
    final losers = result == -1 ? [0, 1] : [1 - result];
    setState(() {
      _roundResult = result;
      if (result >= 0) _scores[result]++;
      _pieTargets = losers;
    });
    if (result >= 0) AudioService().playCorrectAnswer();
    _pieAnim.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 520), () {
      if (!mounted) return;
      AudioService().playSfx('paint');
      Haptics.heavy();
      setState(() {
        for (final l in losers) {
          _pies[l]++;
        }
      });
    });
  }

  void _next() {
    if (_last) {
      _finish();
      return;
    }
    setState(() {
      _index++;
      _revealed = false;
      _roundResult = null;
      _pieTargets = [];
    });
    _pieAnim.reset();
  }

  Future<void> _finish() async {
    final tie = _scores[0] == _scores[1];
    final winner = _scores[0] > _scores[1] ? 0 : 1;
    await showGameResult(
      context,
      won: true,
      accent: _accent,
      title: tie ? t3('Empate!', "It's a tie!", '¡Empate!') : '👑 ${_name(winner)}',
      subtitle: tie
          ? t3('Os dois mandaram bem!', 'Both did great!', '¡Los dos lo hicieron genial!')
          : t3('é o campeão da Torta na Cara!', 'is the Pie in the Face champion!', '¡es el campeón del Pastelazo!'),
      stats: [
        ResultStat('🏆', _name(0), '${_scores[0]}'),
        ResultStat('🥧', t3('tortas', 'pies', 'pasteles'), '${_pies[0]} × ${_pies[1]}'),
        ResultStat('🏆', _name(1), '${_scores[1]}'),
      ],
      primaryLabel: t3('Revanche', 'Rematch', 'Revancha'),
      onPrimary: _rematch,
      secondaryLabel: t3('Início', 'Home', 'Inicio'),
      onSecondary: () => Navigator.of(context).pop(),
    );
  }

  Future<void> _rematch() async {
    final fresh = widget.replay != null ? await widget.replay!() : (List<Question>.from(_questions)..shuffle());
    if (!mounted) return;
    setState(() {
      _questions = fresh.isEmpty ? _questions : fresh;
      _index = 0;
      _scores.setAll(0, [0, 0]);
      _pies.setAll(0, [0, 0]);
      _revealed = false;
      _roundResult = null;
      _pieTargets = [];
    });
    _pieAnim.reset();
  }

  // ==========================================================================
  // UI
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: t3('🥧 Torta na Cara', '🥧 Pie in the Face', '🥧 Pastelazo'),
      accent: _accent,
      backgroundColors: const [Color(0xFF3A1F14), Color(0xFF1A0F0A)],
      body: _started ? _game() : _setup(),
    );
  }

  Widget _setup() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      children: [
        GameHero(
          emoji: '🥧',
          title: t3('Torta na Cara', 'Pie in the Face', 'Pastelazo'),
          subtitle: t3(
              'Um apresentador lê a pergunta, os dois respondem em voz alta. Quem errar leva uma torta!',
              'A host reads the question and both answer out loud. Whoever gets it wrong takes a pie!',
              'Un presentador lee la pregunta y ambos responden en voz alta. ¡Quien falle se lleva un pastel!'),
          accent: _accent,
        ),
        const SizedBox(height: 22),
        GamePanel(
          child: Column(
            children: List.generate(2, (i) {
              return Padding(
                padding: EdgeInsets.only(bottom: i == 0 ? 14 : 0),
                child: TextField(
                  controller: _names[i],
                  maxLength: 16,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    counterText: '',
                    prefixIcon: Icon(Icons.person_rounded, color: _playerColors[i]),
                    labelText: t3('Nome do jogador ${i + 1}', 'Player ${i + 1} name', 'Nombre del jugador ${i + 1}'),
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: GameColors.panelLight.withValues(alpha: 0.5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: _playerColors[i].withValues(alpha: 0.6)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: _playerColors[i], width: 2),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 22),
        PillButton(
          label: t3('Começar duelo', 'Start duel', 'Comenzar duelo'),
          icon: Icons.play_arrow_rounded,
          color: _accent,
          expand: true,
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() => _started = true);
          },
        ),
      ],
    );
  }

  Widget _game() {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: Row(children: [
                Expanded(child: _playerPanel(0)),
                const SizedBox(width: 10),
                Expanded(child: _playerPanel(1)),
              ]),
            ),
            Text(t3('Pergunta ${_index + 1} de ${_questions.length}', 'Question ${_index + 1} of ${_questions.length}',
                    'Pregunta ${_index + 1} de ${_questions.length}'),
                style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                children: [
                  GamePanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(_q.getDificuldadeTexto().toUpperCase(),
                            style: const TextStyle(color: GameColors.gold, fontWeight: FontWeight.w800, fontSize: 12)),
                        const SizedBox(height: 8),
                        Text(_q.pergunta,
                            style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700, height: 1.3)),
                        const SizedBox(height: 12),
                        ...List.generate(_q.opcoes.length, (i) {
                          final right = _revealed && i == _q.respostaCorreta;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: right ? const Color(0xFF166534) : GameColors.panelLight.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: right ? const Color(0xFF4ADE80) : Colors.white24, width: right ? 2 : 1),
                            ),
                            child: Row(children: [
                              Text('${String.fromCharCode(65 + i)}  ',
                                  style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w900)),
                              Expanded(
                                child: Text(_q.opcoes[i],
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                              ),
                              if (right) const Icon(Icons.check_circle_rounded, color: Color(0xFF4ADE80)),
                            ]),
                          );
                        }),
                        if (_revealed && _q.textoBiblico != null && _q.textoBiblico!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          BibleReferenceButton(reference: _q.textoBiblico!),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: _actions(),
            ),
          ],
        ),
        // Tortas voando
        if (_pieTargets.isNotEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _pieAnim,
                builder: (context, _) => LayoutBuilder(builder: (context, c) {
                  final t = _pieAnim.value;
                  return Stack(
                    children: _pieTargets.map((target) {
                      final fly = Curves.easeInCubic.transform((t / 0.58).clamp(0.0, 1.0));
                      final startX = c.maxWidth / 2;
                      final endX = target == 0 ? c.maxWidth * 0.25 : c.maxWidth * 0.75;
                      final x = startX + (endX - startX) * fly;
                      final y = c.maxHeight * 0.75 - (c.maxHeight * 0.75 - 50) * fly - sin(fly * pi) * 80;
                      final size = 40 + 50 * fly;
                      if (t > 0.6) return const SizedBox.shrink();
                      return Positioned(
                        left: x - size / 2,
                        top: y - size / 2,
                        child: Transform.rotate(
                            angle: fly * pi * 2, child: Text('🥧', style: TextStyle(fontSize: size))),
                      );
                    }).toList(),
                  );
                }),
              ),
            ),
          ),
      ],
    );
  }

  Widget _playerPanel(int i) {
    final color = _playerColors[i];
    final won = _roundResult == i;
    final hit = _pieTargets.contains(i) && _pies[i] > 0 && _roundResult != null;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 96,
      decoration: BoxDecoration(
        color: won ? color.withValues(alpha: 0.3) : GameColors.panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: won ? color : color.withValues(alpha: 0.5), width: won ? 2.5 : 1.5),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_name(i),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 15)),
                TweenAnimationBuilder<double>(
                  key: ValueKey(_scores[i]),
                  tween: Tween(begin: 1.4, end: 1),
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.elasticOut,
                  builder: (_, v, child) => Transform.scale(scale: v, child: child),
                  child: Text('${_scores[i]}',
                      style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
                ),
                Text('🥧 × ${_pies[i]}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          // Creme da torta na "cara" de quem errou
          if (hit)
            Positioned.fill(
              child: IgnorePointer(
                child: TweenAnimationBuilder<double>(
                  key: ValueKey('splat$_index$i'),
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1600),
                  builder: (_, v, __) => CustomPaint(painter: _SplatPainter(v)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _actions() {
    if (!_revealed) {
      return PillButton(
          label: t3('Revelar resposta', 'Reveal answer', 'Revelar respuesta'),
          icon: Icons.visibility_rounded,
          color: _accent,
          expand: true,
          onTap: _reveal);
    }
    if (_roundResult == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(t3('Quem acertou primeiro?', 'Who got it first?', '¿Quién acertó primero?'),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: PillButton(label: _name(0), color: _playerColors[0], expand: true, onTap: () => _score(0))),
            const SizedBox(width: 8),
            Expanded(child: PillButton(label: _name(1), color: _playerColors[1], expand: true, onTap: () => _score(1))),
          ]),
          const SizedBox(height: 8),
          PillButton(
            label: t3('Ninguém 🥧🥧', 'Nobody 🥧🥧', 'Nadie 🥧🥧'),
            color: Colors.white70,
            filled: false,
            expand: true,
            onTap: () => _score(-1),
          ),
        ],
      );
    }
    return PillButton(
      label: _last ? t3('Ver campeão', 'See champion', 'Ver campeón') : t3('Próxima pergunta', 'Next question', 'Siguiente pregunta'),
      icon: _last ? Icons.emoji_events_rounded : Icons.arrow_forward_rounded,
      color: _accent,
      expand: true,
      onTap: _next,
    );
  }
}

/// Creme de torta espalhado sobre o painel de quem errou (some aos poucos).
class _SplatPainter extends CustomPainter {
  final double t;
  _SplatPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final grow = Curves.elasticOut.transform((t / 0.35).clamp(0.0, 1.0));
    final fade = t < 0.7 ? 1.0 : 1 - (t - 0.7) / 0.3;
    final c = size.center(Offset.zero);
    final cream = Paint()..color = const Color(0xFFFFF4E0).withValues(alpha: 0.92 * fade);
    final r = Random(7);
    canvas.drawCircle(c, size.shortestSide * 0.32 * grow, cream);
    for (int i = 0; i < 9; i++) {
      final a = i * 2 * pi / 9 + r.nextDouble() * 0.4;
      final d = size.shortestSide * (0.3 + r.nextDouble() * 0.25) * grow;
      canvas.drawCircle(c + Offset(cos(a) * d * 1.4, sin(a) * d), size.shortestSide * (0.06 + r.nextDouble() * 0.07) * grow, cream);
    }
    // Morango no topo
    canvas.drawCircle(c - Offset(0, size.shortestSide * 0.1 * grow), size.shortestSide * 0.07 * grow,
        Paint()..color = const Color(0xFFE11D48).withValues(alpha: fade));
  }

  @override
  bool shouldRepaint(covariant _SplatPainter old) => old.t != t;
}
