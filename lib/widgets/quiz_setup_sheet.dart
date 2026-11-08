import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/quiz_service.dart';
import '../theme/app_theme.dart';
import '../utils/i18n.dart';
import 'app_ui.dart';

/// Escolhas do jogador antes de começar um quiz.
class QuizConfig {
  final int? difficulty; // null = todas
  final String? tag; // null = todos os temas
  final int count;
  final bool studyMode;
  const QuizConfig({this.difficulty, this.tag, this.count = 10, this.studyMode = false});

  /// Sorteia as perguntas com estes filtros.
  Future<List<Question>> build() async {
    var list = await QuizService.loadQuestions();
    if (difficulty != null) list = QuizService.filterByDifficulty(list, difficulty!);
    if (tag != null) list = QuizService.filterByTag(list, tag!);
    return QuizService.getRandomQuestions(list, count);
  }
}

/// Janela "Personalizar": dificuldade, tema, quantidade e modo estudo.
/// Retorna a configuração escolhida, ou null se a pessoa fechar.
Future<QuizConfig?> showQuizSetup(BuildContext context, {required String title, bool allowStudyMode = true}) {
  return showModalBottomSheet<QuizConfig>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _QuizSetupSheet(title: title, allowStudyMode: allowStudyMode),
  );
}

class _QuizSetupSheet extends StatefulWidget {
  final String title;
  final bool allowStudyMode;
  const _QuizSetupSheet({required this.title, required this.allowStudyMode});

  @override
  State<_QuizSetupSheet> createState() => _QuizSetupSheetState();
}

class _QuizSetupSheetState extends State<_QuizSetupSheet> {
  int? _difficulty;
  String? _tag;
  int _count = 10;
  bool _study = false;
  bool _allTags = false;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    QuizService.getPopularTags().then((t) {
      if (mounted) setState(() => _tags = t.map((e) => e.key).toList());
    });
  }

  Widget _choice(String label, bool selected, VoidCallback onTap, {Color? color}) {
    final p = context.palette;
    final c = color ?? p.accent;
    return GestureDetector(
      onTap: () {
        Haptics.selection();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? c.withValues(alpha: p.isDark ? 0.25 : 0.14) : p.surfaceAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? c : p.border, width: selected ? 2 : 1),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? (p.isDark ? Colors.white : c) : p.text,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final shownTags = _allTags ? _tags : _tags.take(10).toList();
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88, maxWidth: 640),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: p.border)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(color: p.border, borderRadius: BorderRadius.circular(3)),
                ),
              ),
              Text(widget.title, style: TextStyle(color: p.text, fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              SectionLabel(t3('Dificuldade', 'Difficulty', 'Dificultad')),
              Wrap(spacing: 8, runSpacing: 8, children: [
                _choice(t3('Todas', 'All', 'Todas'), _difficulty == null, () => setState(() => _difficulty = null)),
                for (final d in [1, 2, 3])
                  _choice(
                    {1: t3('Fácil', 'Easy', 'Fácil'), 2: t3('Médio', 'Medium', 'Medio'), 3: t3('Difícil', 'Hard', 'Difícil')}[d]!,
                    _difficulty == d,
                    () => setState(() => _difficulty = d),
                    color: difficultyColor(context, d),
                  ),
              ]),
              const SizedBox(height: 16),
              SectionLabel(t3('Quantidade de perguntas', 'Number of questions', 'Cantidad de preguntas')),
              Wrap(spacing: 8, children: [
                for (final c in [5, 10, 15, 20]) _choice('$c', _count == c, () => setState(() => _count = c)),
              ]),
              const SizedBox(height: 16),
              SectionLabel(t3('Tema', 'Topic', 'Tema')),
              Wrap(spacing: 8, runSpacing: 8, children: [
                _choice(t3('Todos', 'All', 'Todos'), _tag == null, () => setState(() => _tag = null)),
                ...shownTags.map((t) => _choice(t, _tag == t, () => setState(() => _tag = t))),
              ]),
              if (_tags.length > 10)
                TextButton.icon(
                  onPressed: () => setState(() => _allTags = !_allTags),
                  icon: Icon(_allTags ? Icons.expand_less : Icons.expand_more),
                  label: Text(_allTags
                      ? t3('Ver menos', 'Show less', 'Ver menos')
                      : t3('Ver todos (${_tags.length})', 'Show all (${_tags.length})', 'Ver todos (${_tags.length})')),
                ),
              if (widget.allowStudyMode) ...[
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: p.surfaceAlt,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _study ? p.accent : p.border),
                  ),
                  child: SwitchListTile(
                    value: _study,
                    onChanged: (v) => setState(() => _study = v),
                    title: Text(t3('📚 Modo estudo', '📚 Study mode', '📚 Modo estudio'),
                        style: TextStyle(color: p.text, fontWeight: FontWeight.w800)),
                    subtitle: Text(
                        t3('Sem cronômetro, para ler com calma', 'No timer, read at your own pace', 'Sin cronómetro, lee con calma'),
                        style: TextStyle(color: p.textMuted, fontSize: 12)),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              AppButton(
                label: t3('Começar', 'Start', 'Comenzar'),
                icon: Icons.play_arrow_rounded,
                onTap: () => Navigator.of(context)
                    .pop(QuizConfig(difficulty: _difficulty, tag: _tag, count: _count, studyMode: _study)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
