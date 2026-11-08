import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import '../utils/i18n.dart';
import '../widgets/app_ui.dart';
import '../widgets/bible_reference_button.dart';
import 'minigames/common/game_ui.dart' show ConfettiBurst, StarRow;
import 'quiz_screen.dart';

/// Resultado do quiz: estrelas, pontuação, números e revisão dos erros.
class QuizResultScreen extends StatefulWidget {
  final List<AnsweredQuestion> answers;
  final int score;
  final int seconds;
  final int bestStreak;
  final bool studyMode;
  final Future<List<Question>> Function()? replay;

  const QuizResultScreen({
    super.key,
    required this.answers,
    required this.score,
    required this.seconds,
    required this.bestStreak,
    required this.studyMode,
    this.replay,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  bool _loading = false;

  int get _correct => widget.answers.where((a) => a.correct).length;
  int get _percent => widget.answers.isEmpty ? 0 : (_correct * 100 / widget.answers.length).round();
  int get _stars => _percent >= 90 ? 3 : (_percent >= 70 ? 2 : (_percent >= 50 ? 1 : 0));

  @override
  void initState() {
    super.initState();
    if (_percent >= 70) {
      AudioService().playVictory();
      Haptics.heavy();
    } else {
      AudioService().playSfx('star');
    }
  }

  (String, String) get _headline {
    if (_percent >= 90) return ('🏆', t3('Excelente!', 'Excellent!', '¡Excelente!'));
    if (_percent >= 70) return ('🎉', t3('Muito bem!', 'Well done!', '¡Muy bien!'));
    if (_percent >= 50) return ('👏', t3('Bom trabalho!', 'Good job!', '¡Buen trabajo!'));
    return ('💪', t3('Continue praticando!', 'Keep practicing!', '¡Sigue practicando!'));
  }

  Future<void> _playAgain() async {
    final replay = widget.replay;
    if (replay == null) return;
    setState(() => _loading = true);
    final questions = await replay();
    if (!mounted) return;
    if (questions.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => QuizScreen(questions: questions, studyMode: widget.studyMode, replay: replay),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final (emoji, title) = _headline;
    final wrong = widget.answers.where((a) => !a.correct).toList();
    return Stack(
      children: [
        AppPage(
          title: t3('Resultado', 'Results', 'Resultado'),
          leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.of(context).pop()),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            children: [
              AppCard(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
                child: Column(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.3, end: 1),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      builder: (_, v, child) => Transform.scale(scale: v, child: child),
                      child: Text(emoji, style: const TextStyle(fontSize: 64)),
                    ),
                    const SizedBox(height: 6),
                    Text(title, style: TextStyle(color: p.text, fontSize: 26, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    StarRow(stars: _stars, emptyColor: p.border),
                    const SizedBox(height: 12),
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: widget.score),
                      duration: const Duration(milliseconds: 1400),
                      curve: Curves.easeOutCubic,
                      builder: (_, v, __) => Text('$v',
                          style: TextStyle(color: p.goldText, fontSize: 52, fontWeight: FontWeight.w900, height: 1)),
                    ),
                    Text(t3('pontos', 'points', 'puntos'), style: TextStyle(color: p.textMuted, fontSize: 14)),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _stat(p, '✅', '$_correct/${widget.answers.length}', t3('Acertos', 'Correct', 'Aciertos')),
                        _stat(p, '🎯', '$_percent%', t3('Precisão', 'Accuracy', 'Precisión')),
                        _stat(p, '🔥', '${widget.bestStreak}', t3('Sequência', 'Streak', 'Racha')),
                        _stat(p, '⏱️', formatGameTime(widget.seconds), t3('Tempo', 'Time', 'Tiempo')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (widget.replay != null)
                AppButton(
                  label: _loading ? t3('Carregando…', 'Loading…', 'Cargando…') : t3('Jogar de novo', 'Play again', 'Jugar de nuevo'),
                  icon: Icons.replay_rounded,
                  onTap: _loading ? null : _playAgain,
                ),
              const SizedBox(height: 10),
              AppButton(
                label: t3('Voltar ao início', 'Back to home', 'Volver al inicio'),
                icon: Icons.home_rounded,
                outlined: true,
                onTap: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 22),
              if (wrong.isEmpty)
                AppCard(
                  child: Row(
                    children: [
                      const Text('🌟', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          t3('Você acertou todas! Nenhuma pergunta para revisar.', 'You got them all! Nothing to review.',
                              '¡Acertaste todas! Nada que repasar.'),
                          style: TextStyle(color: p.text, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                SectionLabel(t3('Revise o que errou', 'Review your mistakes', 'Repasa tus errores')),
                ...wrong.map((a) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _review(p, a))),
              ],
            ],
          ),
        ),
        if (_percent >= 70) const Positioned.fill(child: ConfettiBurst()),
      ],
    );
  }

  Widget _stat(AppPalette p, String emoji, String value, String label) {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(color: p.text, fontSize: 17, fontWeight: FontWeight.w900)),
            Text(label, style: TextStyle(color: p.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _review(AppPalette p, AnsweredQuestion a) {
    final q = a.question;
    String opt(int i) => '${String.fromCharCode(65 + i)}) ${q.opcoes[i]}';
    return AppCard(
      padding: const EdgeInsets.all(14),
      borderColor: p.danger.withValues(alpha: 0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(q.pergunta, style: TextStyle(color: p.text, fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.close_rounded, color: p.danger, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  a.chosen == null ? t3('Tempo esgotado', 'Time ran out', 'Se acabó el tiempo') : opt(a.chosen!),
                  style: TextStyle(color: p.danger, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_rounded, color: p.success, size: 18),
              const SizedBox(width: 6),
              Expanded(child: Text(opt(q.respostaCorreta), style: TextStyle(color: p.success, fontWeight: FontWeight.w700))),
            ],
          ),
          if (q.textoBiblico != null && q.textoBiblico!.isNotEmpty) ...[
            const SizedBox(height: 10),
            BibleReferenceButton(reference: q.textoBiblico!),
          ],
        ],
      ),
    );
  }
}
