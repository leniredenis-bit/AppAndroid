import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/question.dart';
import '../models/stats_data.dart';
import '../models/stats_service.dart';
import '../services/achievement_service.dart';
import '../services/app_lifecycle.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../utils/i18n.dart';
import '../utils/timer_calculator.dart';
import '../widgets/achievement_unlock_dialog.dart';
import '../widgets/app_ui.dart';
import '../widgets/bible_reference_button.dart';
import 'quiz_result_screen.dart';

/// Resultado de cada pergunta, usado na revisão final.
class AnsweredQuestion {
  final Question question;
  final int? chosen; // null = tempo esgotado
  final int points;
  AnsweredQuestion(this.question, this.chosen, this.points);
  bool get correct => chosen == question.respostaCorreta;
}

class QuizScreen extends StatefulWidget {
  final List<Question> questions;

  /// Sem cronômetro (para estudar com calma).
  final bool studyMode;

  /// Gera um novo conjunto de perguntas com os mesmos filtros ("Jogar de novo").
  final Future<List<Question>> Function()? replay;

  const QuizScreen({super.key, required this.questions, this.studyMode = false, this.replay});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  static const int _autoAdvanceSeconds = 12;

  int _index = 0;
  int _score = 0;
  int _streak = 0;
  int _bestStreak = 0;
  int? _chosen; // alternativa escolhida (-1 = tempo esgotado)
  int _lastPoints = 0;
  int _questionTime = 30;
  int _autoAdvance = _autoAdvanceSeconds;
  Timer? _advanceTimer;
  late final AnimationController _clock;
  late final AnimationController _pulse;
  final List<AnsweredQuestion> _answers = [];
  final List<QuestionResult> _results = [];
  final DateTime _startedAt = DateTime.now();
  bool _finishing = false;

  Question get _q => widget.questions[_index];
  bool get _answered => _chosen != null;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(vsync: this)..addStatusListener(_onClockStatus);
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
    _clock.addListener(_onClockTick);
    AppLifecycle.foreground.addListener(_onForegroundChanged);
    AudioService().playBackgroundMusic('quiz');
    _startQuestion();
  }

  @override
  void dispose() {
    AppLifecycle.foreground.removeListener(_onForegroundChanged);
    _advanceTimer?.cancel();
    _clock.dispose();
    _pulse.dispose();
    AudioService().stopBackgroundMusic();
    super.dispose();
  }

  // ==========================================================================
  // TEMPO
  // ==========================================================================

  void _startQuestion() {
    _questionTime = TimerCalculator.calculateQuizTime(_q);
    _chosen = null;
    _lastPoints = 0;
    _advanceTimer?.cancel();
    _pulse.stop();
    _pulse.value = 0;
    if (!widget.studyMode) {
      _clock.duration = Duration(seconds: _questionTime);
      _clock.forward(from: 0);
    }
  }

  int get _secondsLeft => max(0, (_questionTime * (1 - _clock.value)).ceil());

  void _onClockTick() {
    // Pulsa nos últimos 25% do tempo
    if (_clock.value > 0.75 && !_pulse.isAnimating && !_answered) {
      _pulse.repeat(reverse: true);
    }
  }

  void _onClockStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_answered) _timeUp();
  }

  /// Pausa o cronômetro com o app em segundo plano (ligação, troca de app).
  void _onForegroundChanged() {
    if (AppLifecycle.foreground.value) {
      if (!_answered && !widget.studyMode && _clock.value < 1) _clock.forward();
    } else {
      _clock.stop();
    }
  }

  // ==========================================================================
  // RESPOSTAS
  // ==========================================================================

  int _pointsFor(Question q) {
    final base = q.dificuldade == 3 ? 20 : (q.dificuldade == 2 ? 15 : 10);
    final timeBonus = widget.studyMode ? 0 : (_secondsLeft * 0.5).round();
    final streakBonus = min(_streak, 5) * 2; // sequência em andamento
    return base + timeBonus + streakBonus;
  }

  void _select(int index) {
    if (_answered) return;
    _clock.stop();
    _pulse.stop();
    final q = _q;
    final correct = index == q.respostaCorreta;
    final elapsed = (_questionTime * _clock.value).round();
    int points = 0;
    if (correct) {
      points = _pointsFor(q);
      _streak++;
      _bestStreak = max(_bestStreak, _streak);
      _score += points;
      Haptics.medium();
      AudioService().playSfx(_streak >= 3 ? 'combo' : 'correct');
    } else {
      _streak = 0;
      Haptics.heavy();
      AudioService().playWrongAnswer();
    }
    _results.add(QuestionResult(questionId: q.id, wasCorrect: correct, timeToAnswer: elapsed));
    _answers.add(AnsweredQuestion(q, index, points));
    setState(() {
      _chosen = index;
      _lastPoints = points;
    });
    _startAutoAdvance();
  }

  /// Tempo esgotado: conta como erro, mostra a resposta certa e a explicação.
  void _timeUp() {
    if (_answered) return;
    final q = _q;
    _streak = 0;
    _pulse.stop();
    AudioService().playWrongAnswer();
    Haptics.heavy();
    _results.add(QuestionResult(questionId: q.id, wasCorrect: false, timeToAnswer: _questionTime));
    _answers.add(AnsweredQuestion(q, null, 0));
    setState(() => _chosen = -1);
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _autoAdvance = _autoAdvanceSeconds;
    _advanceTimer?.cancel();
    _advanceTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !AppLifecycle.foreground.value) return;
      if (_autoAdvance <= 1) {
        _next();
      } else {
        setState(() => _autoAdvance--);
      }
    });
  }

  void _next() {
    _advanceTimer?.cancel();
    if (_index < widget.questions.length - 1) {
      setState(() => _index++);
      _startQuestion();
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    if (_finishing) return;
    _finishing = true;
    final total = widget.questions.length;
    final correct = _answers.where((a) => a.correct).length;
    final seconds = DateTime.now().difference(_startedAt).inSeconds;

    await StatsService.saveQuizStats(score: _score, questionsAnswered: total, correctAnswers: correct);
    final storage = StorageService();
    await storage.saveQuizResult(
      mode: widget.studyMode ? 'quiz_estudo' : 'quiz_normal',
      score: _score,
      correctAnswers: correct,
      totalQuestions: total,
      timeSpent: seconds,
      difficulty: _mostCommonDifficulty(),
      category: _mostCommonCategory(),
      questionResults: _results,
    );
    final global = await storage.getGlobalStats();
    final unlocked = await AchievementService().checkQuizAchievements(
      totalQuizzes: global.totalQuizzes,
      correctAnswers: correct,
      totalQuestions: total,
      timeInSeconds: widget.studyMode ? 9999 : seconds,
      streak: global.currentStreak,
    );
    if (!mounted) return;
    for (final a in unlocked) {
      if (!mounted) return;
      await AchievementUnlockDialog.show(context, a);
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => QuizResultScreen(
        answers: _answers,
        score: _score,
        seconds: seconds,
        bestStreak: _bestStreak,
        studyMode: widget.studyMode,
        replay: widget.replay,
      ),
    ));
  }

  String? _mostCommonDifficulty() {
    final counts = <int, int>{};
    for (final q in widget.questions) {
      counts[q.dificuldade] = (counts[q.dificuldade] ?? 0) + 1;
    }
    if (counts.isEmpty) return null;
    final d = counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    return d == 1 ? 'fácil' : (d == 2 ? 'médio' : 'difícil');
  }

  String? _mostCommonCategory() {
    final counts = <String, int>{};
    for (final q in widget.questions) {
      if (q.tags.isNotEmpty) counts[q.tags.first] = (counts[q.tags.first] ?? 0) + 1;
    }
    if (counts.isEmpty) return null;
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  Future<bool> _confirmExit() async {
    _clock.stop();
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t3('Sair do quiz?', 'Leave the quiz?', '¿Salir del quiz?')),
        content: Text(t3('Seu progresso nesta partida será perdido.', 'Your progress in this round will be lost.',
            'Perderás el progreso de esta partida.')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t3('Continuar', 'Keep playing', 'Seguir'))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t3('Sair', 'Leave', 'Salir'), style: TextStyle(color: context.palette.danger)),
          ),
        ],
      ),
    );
    if (leave != true && !_answered && !widget.studyMode) _clock.forward();
    return leave == true;
  }

  // ==========================================================================
  // UI
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = context.palette;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExit() && context.mounted) Navigator.of(context).pop();
      },
      child: AppPage(
        title: l10n.quizTitle(_index + 1, widget.questions.length),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: TweenAnimationBuilder<int>(
                tween: IntTween(end: _score),
                duration: const Duration(milliseconds: 500),
                builder: (_, v, __) => Text('⭐ $v',
                    style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
              ),
            ),
          ),
        ],
        body: Column(
          children: [
            _progressSegments(p),
            if (!widget.studyMode) _timerBar(p),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                children: [
                  _questionCard(p),
                  const SizedBox(height: 14),
                  ...List.generate(_q.opcoes.length, (i) => _option(i, p)),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: _answered ? _feedbackPanel(p, l10n) : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }

  /// Uma barrinha por pergunta: verde acertou, vermelha errou, destaque na atual.
  Widget _progressSegments(AppPalette p) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: List.generate(widget.questions.length, (i) {
          Color c = p.surfaceAlt;
          if (i < _answers.length) c = _answers[i].correct ? p.success : p.danger;
          final current = i == _index && !_answered;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: current ? 8 : 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: current ? p.accent : c,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: p.border, width: 0.5),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _timerBar(AppPalette p) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: AnimatedBuilder(
        animation: Listenable.merge([_clock, _pulse]),
        builder: (_, __) {
          final left = 1 - _clock.value;
          final color = left > 0.5
              ? p.success
              : (left > 0.25 ? (p.isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309)) : p.danger);
          final grow = _pulse.value * 3;
          return Row(
            children: [
              Expanded(
                child: Container(
                  height: 12 + grow,
                  decoration: BoxDecoration(
                    color: p.surfaceAlt,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: p.border),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _answered ? left.clamp(0.0, 1.0) : left.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6 + grow * 2)],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 44,
                child: Text('${_secondsLeft}s',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: left > 0.25 ? p.text : p.danger, fontWeight: FontWeight.w900, fontSize: 16)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _questionCard(AppPalette p) {
    final q = _q;
    final len = q.pergunta.length;
    final size = len < 70 ? 21.0 : (len < 130 ? 19.0 : 17.0);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, a) => FadeTransition(
        opacity: a,
        child: SlideTransition(position: Tween(begin: const Offset(0.08, 0), end: Offset.zero).animate(a), child: child),
      ),
      child: AppCard(
        key: ValueKey(_index),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                AppChip(label: q.getDificuldadeTexto(), color: difficultyColor(context, q.dificuldade)),
                if (q.tags.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text('#${q.tags.last}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: p.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
                const Spacer(),
                if (widget.studyMode)
                  AppChip(label: t3('📚 Estudo', '📚 Study', '📚 Estudio'), color: p.accent)
                else if (_streak >= 2)
                  TweenAnimationBuilder<double>(
                    key: ValueKey(_streak),
                    tween: Tween(begin: 0.6, end: 1),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                    builder: (_, v, child) => Transform.scale(scale: v, child: child),
                    child: AppChip(label: '🔥 x$_streak', color: p.goldText),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(q.pergunta,
                textAlign: TextAlign.center,
                style: TextStyle(color: p.text, fontSize: size, fontWeight: FontWeight.w600, height: 1.3)),
          ],
        ),
      ),
    );
  }

  Widget _option(int i, AppPalette p) {
    final q = _q;
    final isCorrect = i == q.respostaCorreta;
    final isChosen = _chosen == i;
    Color bg = p.surface;
    Color border = p.border;
    Color letterBg = p.surfaceAlt;
    Color fg = p.text;
    double opacity = 1;
    if (_answered) {
      if (isCorrect) {
        bg = p.success.withValues(alpha: p.isDark ? 0.25 : 0.14);
        border = p.success;
        letterBg = p.success;
      } else if (isChosen) {
        bg = p.danger.withValues(alpha: p.isDark ? 0.25 : 0.12);
        border = p.danger;
        letterBg = p.danger;
      } else {
        opacity = 0.55;
      }
    }
    final letter = String.fromCharCode(65 + i);
    final letterFg = _answered && (isCorrect || isChosen) ? Colors.white : p.text;

    Widget tile = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: _answered && (isCorrect || isChosen) ? 2.2 : 1.2),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: letterBg, shape: BoxShape.circle, border: Border.all(color: border)),
            child: _answered && isCorrect
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                : (_answered && isChosen
                    ? const Icon(Icons.close_rounded, color: Colors.white, size: 20)
                    : Text(letter, style: TextStyle(color: letterFg, fontWeight: FontWeight.w900))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(q.opcoes[i], style: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    // Certa "pula", errada treme
    if (_answered && isCorrect) {
      tile = TweenAnimationBuilder<double>(
        key: ValueKey('ok$_index'),
        tween: Tween(begin: 0.94, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (_, v, child) => Transform.scale(scale: v, child: child),
        child: tile,
      );
    } else if (_answered && isChosen) {
      tile = TweenAnimationBuilder<double>(
        key: ValueKey('bad$_index'),
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 420),
        builder: (_, v, child) => Transform.translate(offset: Offset(sin(v * pi * 6) * 8 * (1 - v), 0), child: child),
        child: tile,
      );
    }

    // Entrada escalonada a cada pergunta
    return TweenAnimationBuilder<double>(
      key: ValueKey('in$_index-$i'),
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + i * 80),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v * opacity,
        child: Transform.translate(offset: Offset(0, (1 - v) * 18), child: child),
      ),
      child: GestureDetector(onTap: () => _select(i), child: tile),
    );
  }

  Widget _feedbackPanel(AppPalette p, AppLocalizations l10n) {
    final q = _q;
    final timedOut = _chosen == -1;
    final correct = _chosen == q.respostaCorreta;
    final color = correct ? p.success : p.danger;
    final title = correct
        ? t3('Você acertou! +$_lastPoints', 'Correct! +$_lastPoints', '¡Correcto! +$_lastPoints')
        : (timedOut ? t3('Tempo esgotado!', "Time's up!", '¡Se acabó el tiempo!') : t3('Não foi dessa vez', 'Not quite', 'Casi'));
    final answerLine =
        '${t3('Resposta certa', 'Correct answer', 'Respuesta correcta')}: ${String.fromCharCode(65 + q.respostaCorreta)}) ${q.opcoes[q.respostaCorreta]}';
    final ref = q.textoBiblico;
    final last = _index == widget.questions.length - 1;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: color, width: 3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(correct ? Icons.check_circle_rounded : (timedOut ? Icons.timer_off_rounded : Icons.cancel_rounded),
                  color: color, size: 26),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900))),
            ],
          ),
          if (!correct) ...[
            const SizedBox(height: 6),
            Text(answerLine, style: TextStyle(color: p.text, fontSize: 14, fontWeight: FontWeight.w600)),
          ],
          if (ref != null && ref.isNotEmpty) ...[
            const SizedBox(height: 10),
            BibleReferenceButton(reference: ref),
          ],
          const SizedBox(height: 12),
          AppButton(
            label: last
                ? t3('Ver resultado ($_autoAdvance)', 'See results ($_autoAdvance)', 'Ver resultado ($_autoAdvance)')
                : '${l10n.quizNext} ($_autoAdvance)',
            icon: last ? Icons.emoji_events_rounded : Icons.arrow_forward_rounded,
            color: correct ? p.success : p.primary,
            onTap: _next,
          ),
        ],
      ),
    );
  }
}
