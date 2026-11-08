import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../services/daily_question_service.dart';
import '../theme/app_theme.dart';
import '../utils/i18n.dart';
import '../utils/in_app_browser.dart';
import 'app_ui.dart';
import 'bible_reference_button.dart';

/// Cartão da Pergunta do Dia na tela inicial.
class DailyQuestionCard extends StatefulWidget {
  /// Avisa a tela inicial quando a sequência de dias muda.
  final ValueChanged<int>? onStreak;
  const DailyQuestionCard({super.key, this.onStreak});

  @override
  State<DailyQuestionCard> createState() => _DailyQuestionCardState();
}

class _DailyQuestionCardState extends State<DailyQuestionCard> {
  DailyStatus? _status;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await DailyQuestionService.today();
    if (!mounted) return;
    setState(() => _status = s);
    widget.onStreak?.call(s.streak);
  }

  Future<void> _answer(int i) async {
    final s = _status;
    if (s == null || s.answered) return;
    final correct = i == s.question.respostaCorreta;
    if (correct) {
      AudioService().playSfx('combo');
      Haptics.medium();
    } else {
      AudioService().playWrongAnswer();
      Haptics.heavy();
    }
    final streak = await DailyQuestionService.answer(i, correct);
    if (!mounted) return;
    setState(() => _status = DailyStatus(s.question, true, correct, i, streak));
    widget.onStreak?.call(streak);
  }

  /// Texto diário no site oficial, em meia tela por cima do app.
  Future<void> _openDailyText() => openInAppBrowser(context, DailyQuestionService.dailyTextUrl());

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final s = _status;
    final gold = p.goldText;
    return AppCard(
      borderColor: gold.withValues(alpha: 0.7),
      borderWidth: 1.6,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: s == null
          ? const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text('📅', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(t3('Pergunta do Dia', 'Question of the Day', 'Pregunta del Día'),
                          style: TextStyle(color: gold, fontWeight: FontWeight.w900, fontSize: 16)),
                    ),
                    if (s.streak > 0)
                      AppChip(label: '🔥 ${s.streak} ${t3(s.streak == 1 ? 'dia' : 'dias', s.streak == 1 ? 'day' : 'days', s.streak == 1 ? 'día' : 'días')}', color: gold),
                  ],
                ),
                const SizedBox(height: 10),
                Text(s.question.pergunta,
                    style: TextStyle(color: p.text, fontSize: 17, fontWeight: FontWeight.w700, height: 1.3)),
                const SizedBox(height: 12),
                ...List.generate(s.question.opcoes.length, (i) => _option(p, s, i)),
                if (s.answered) ...[
                  const SizedBox(height: 4),
                  Text(
                    s.correct
                        ? t3('✔ Acertou! Volte amanhã para a próxima.', '✔ Correct! Come back tomorrow for the next one.',
                            '✔ ¡Correcto! Vuelve mañana por la siguiente.')
                        : t3('Não foi dessa vez — amanhã tem outra!', 'Not this time — another one tomorrow!',
                            'Esta vez no — ¡mañana hay otra!'),
                    style: TextStyle(color: s.correct ? p.success : p.textMuted, fontWeight: FontWeight.w700),
                  ),
                  if (s.question.textoBiblico != null && s.question.textoBiblico!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    BibleReferenceButton(reference: s.question.textoBiblico!),
                  ],
                ],
                const SizedBox(height: 10),
                AppButton(
                  label: t3('Ler o texto diário', 'Read the daily text', 'Leer el texto diario'),
                  icon: Icons.menu_book_rounded,
                  outlined: true,
                  color: gold,
                  onTap: _openDailyText,
                ),
              ],
            ),
    );
  }

  Widget _option(AppPalette p, DailyStatus s, int i) {
    final isCorrect = i == s.question.respostaCorreta;
    final isChosen = s.chosen == i;
    Color border = p.border;
    Color bg = p.surfaceAlt;
    if (s.answered && isCorrect) {
      border = p.success;
      bg = p.success.withValues(alpha: p.isDark ? 0.25 : 0.14);
    } else if (s.answered && isChosen) {
      border = p.danger;
      bg = p.danger.withValues(alpha: p.isDark ? 0.25 : 0.12);
    }
    return GestureDetector(
      onTap: s.answered ? null : () => _answer(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: s.answered && (isCorrect || isChosen) ? 2 : 1),
        ),
        child: Row(
          children: [
            Text('${String.fromCharCode(65 + i)}  ', style: TextStyle(color: p.textMuted, fontWeight: FontWeight.w900)),
            Expanded(child: Text(s.question.opcoes[i], style: TextStyle(color: p.text, fontWeight: FontWeight.w600))),
            if (s.answered && isCorrect) Icon(Icons.check_circle_rounded, color: p.success, size: 20),
            if (s.answered && isChosen && !isCorrect) Icon(Icons.cancel_rounded, color: p.danger, size: 20),
          ],
        ),
      ),
    );
  }
}
