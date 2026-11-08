import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../l10n/app_localizations.dart';
import '../models/stats_data.dart';
import '../services/language_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../utils/i18n.dart';
import '../widgets/app_ui.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with SingleTickerProviderStateMixin {
  final StorageService _storage = StorageService();
  GlobalStats? _global;
  MinigameRecords? _minigames;
  List<QuizHistory> _history = [];
  bool _loading = true;
  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final g = await _storage.getGlobalStats();
    final m = await _storage.getMinigameRecords();
    final h = await _storage.getQuizHistory(limit: 50);
    h.sort((a, b) => b.playedAt.compareTo(a.playedAt)); // mais recente primeiro
    if (!mounted) return;
    setState(() {
      _global = g;
      _minigames = m;
      _history = h;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = context.palette;
    return Scaffold(
      backgroundColor: p.background,
      appBar: AppBar(
        title: Text(t3('📊 Estatísticas', '📊 Statistics', '📊 Estadísticas')),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: p.gold,
          indicatorWeight: 3,
          labelColor: p.gold,
          unselectedLabelColor: Colors.white,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(icon: const Icon(Icons.quiz_rounded), text: l10n.statsTabQuiz),
            Tab(icon: const Icon(Icons.sports_esports_rounded), text: l10n.statsTabMinigames),
            Tab(icon: const Icon(Icons.history_rounded), text: l10n.statsTabHistory),
          ],
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [p.backgroundTop, p.background],
          ),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(controller: _tabs, children: [
                MaxWidth(child: _quizTab(p)),
                MaxWidth(child: _minigamesTab(p)),
                MaxWidth(child: _historyTab(p)),
              ]),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // QUIZ
  // --------------------------------------------------------------------------

  Widget _empty(AppPalette p, String emoji, String title, String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: TextStyle(color: p.text, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(text, textAlign: TextAlign.center, style: TextStyle(color: p.textMuted, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _quizTab(AppPalette p) {
    final g = _global;
    if (g == null || g.totalQuizzes == 0) {
      return _empty(p, '🧠', t3('Jogue seu primeiro quiz!', 'Play your first quiz!', '¡Juega tu primer quiz!'),
          t3('Seus números e gráficos aparecem aqui.', 'Your numbers and charts will show up here.', 'Tus números y gráficos aparecerán aquí.'));
    }
    final recent = _history.take(15).toList().reversed.toList();
    final topics = _topicAccuracy();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        LayoutBuilder(builder: (context, c) {
          final cols = c.maxWidth > 520 ? 4 : 2;
          final w = (c.maxWidth - (cols - 1) * 10) / cols;
          final cards = [
            ('🧠', '${g.totalQuizzes}', t3('Quizzes', 'Quizzes', 'Quizzes'), p.text),
            ('🎯', '${g.accuracy.toStringAsFixed(0)}%', t3('Precisão', 'Accuracy', 'Precisión'), p.success),
            ('🏆', '${g.highScore}', t3('Recorde', 'Best score', 'Récord'), p.goldText),
            ('🔥', '${g.longestStreak}', t3('Maior sequência', 'Best streak', 'Mejor racha'), p.danger),
          ];
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: cards
                .map((c) => SizedBox(
                      width: w,
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                        child: Column(children: [
                          Text(c.$1, style: const TextStyle(fontSize: 26)),
                          const SizedBox(height: 4),
                          Text(c.$2, style: TextStyle(color: c.$4, fontSize: 24, fontWeight: FontWeight.w900)),
                          Text(c.$3, textAlign: TextAlign.center, style: TextStyle(color: p.textMuted, fontSize: 12)),
                        ]),
                      ),
                    ))
                .toList(),
          );
        }),
        const SizedBox(height: 18),
        if (recent.length >= 2) ...[
          SectionLabel(t3('Evolução (últimos quizzes)', 'Progress (recent quizzes)', 'Evolución (últimos quizzes)')),
          AppCard(
            padding: const EdgeInsets.fromLTRB(12, 16, 16, 10),
            child: SizedBox(
              height: 160,
              child: CustomPaint(
                size: Size.infinite,
                painter: _AccuracyChart(
                  values: recent.map((h) => h.totalQuestions == 0 ? 0.0 : h.correctAnswers / h.totalQuestions).toList(),
                  line: p.accent,
                  grid: p.border,
                  label: p.textMuted,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
        if (topics.length >= 2) ...[
          SectionLabel(t3('Seus temas', 'Your topics', 'Tus temas')),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t3('💪 Mais fortes', '💪 Strongest', '💪 Más fuertes'),
                    style: TextStyle(color: p.success, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                ...topics.take(3).map((t) => _topicRow(p, t.key, t.value, p.success)),
                const SizedBox(height: 12),
                Text(t3('📖 Para estudar mais', '📖 Worth studying', '📖 Para estudiar más'),
                    style: TextStyle(color: p.danger, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                ...topics.reversed.take(min(3, topics.length - 1)).map((t) => _topicRow(p, t.key, t.value, p.danger)),
              ],
            ),
          ),
          const SizedBox(height: 18),
        ],
        if (_difficultyEntries(g).isNotEmpty) ...[
          SectionLabel(t3('Precisão por dificuldade', 'Accuracy by difficulty', 'Precisión por dificultad')),
          AppCard(
            child: Column(
              children: _difficultyEntries(g)
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _bar(p, e.$1, e.$2 / 100, e.$3, '${e.$2}%'),
                      ))
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }

  /// Precisão por tema a partir do histórico (ordenado do melhor para o pior).
  List<MapEntry<String, double>> _topicAccuracy() {
    final right = <String, int>{}, total = <String, int>{};
    for (final h in _history) {
      final c = h.category;
      if (c == null || h.totalQuestions == 0) continue;
      right[c] = (right[c] ?? 0) + h.correctAnswers;
      total[c] = (total[c] ?? 0) + h.totalQuestions;
    }
    final list = [for (final c in total.keys) MapEntry(c, right[c]! / total[c]!)];
    list.sort((a, b) => b.value.compareTo(a.value));
    return list;
  }

  /// Entradas de dificuldade (ignora os contadores internos "*_count").
  List<(String, int, Color)> _difficultyEntries(GlobalStats g) {
    const order = ['fácil', 'médio', 'difícil'];
    final out = <(String, int, Color)>[];
    for (int i = 0; i < order.length; i++) {
      final v = g.accuracyByDifficulty[order[i]];
      if (v != null) out.add((_difficultyLabel(order[i]), v, difficultyColor(context, i + 1)));
    }
    return out;
  }

  Widget _topicRow(AppPalette p, String name, double acc, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: _bar(p, name, acc, color, '${(acc * 100).round()}%'),
    );
  }

  Widget _bar(AppPalette p, String label, double value, Color color, String trailing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(child: Text(label, style: TextStyle(color: p.text, fontWeight: FontWeight.w600))),
          Text(trailing, style: TextStyle(color: color, fontWeight: FontWeight.w900)),
        ]),
        const SizedBox(height: 5),
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: p.surfaceAlt,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: p.border, width: 0.8),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // MINIGAMES
  // --------------------------------------------------------------------------

  Map<String, String> get _gameNames => {
        'memory': t3('🧠 Memória', '🧠 Memory', '🧠 Memoria'),
        'jigsaw_puzzle': t3('🧩 Quebra-Cabeça', '🧩 Jigsaw', '🧩 Rompecabezas'),
        'coloring': t3('🎨 Colorir', '🎨 Coloring', '🎨 Colorear'),
        'hangman': t3('🎯 Forca', '🎯 Hangman', '🎯 Ahorcado'),
        'word_search': t3('🔍 Caça-Palavras', '🔍 Word Search', '🔍 Sopa de Letras'),
        'maze': t3('🌀 Labirinto', '🌀 Maze', '🌀 Laberinto'),
        'sequence': t3('💎 Sequência Cristal', '💎 Crystal Sequence', '💎 Secuencia Cristal'),
        'tictactoe': t3('⭕ Jogo da Velha', '⭕ Tic-Tac-Toe', '⭕ Tres en Raya'),
      };

  Widget _minigamesTab(AppPalette p) {
    final records = _minigames?.records ?? {};
    final known = records.entries.where((e) => _gameNames.containsKey(e.key) && e.value.gamesPlayed > 0).toList();
    if (known.isEmpty) {
      return _empty(p, '🎮', t3('Nenhum minigame ainda', 'No minigames yet', 'Aún no hay minijuegos'),
          t3('Jogue um minigame para ver seus recordes.', 'Play a minigame to see your records.', 'Juega un minijuego para ver tus récords.'));
    }
    known.sort((a, b) => b.value.gamesPlayed.compareTo(a.value.gamesPlayed));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: known.map((e) {
        final r = e.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_gameNames[e.key]!, style: TextStyle(color: p.text, fontSize: 17, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _mini(p, '🎮', '${r.gamesPlayed}', t3('Partidas', 'Games', 'Partidas')),
                    _mini(p, '🏆', '${r.gamesWon}', t3('Vitórias', 'Wins', 'Victorias')),
                    _mini(p, '⭐', '${r.highScore}', t3('Recorde', 'Best', 'Récord')),
                    if (r.bestTime != null && r.bestTime! > 0)
                      _mini(p, '⏱️', formatGameTime(r.bestTime!), t3('Melhor tempo', 'Best time', 'Mejor tiempo')),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _mini(AppPalette p, String emoji, String value, String label) {
    return Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)),
      Text(value, style: TextStyle(color: p.text, fontSize: 16, fontWeight: FontWeight.w900)),
      Text(label, style: TextStyle(color: p.textMuted, fontSize: 11)),
    ]);
  }

  // --------------------------------------------------------------------------
  // HISTÓRICO
  // --------------------------------------------------------------------------

  Widget _historyTab(AppPalette p) {
    if (_history.isEmpty) {
      return _empty(p, '📜', t3('Histórico vazio', 'No history yet', 'Historial vacío'),
          t3('Seus últimos quizzes aparecem aqui.', 'Your latest quizzes will show up here.', 'Tus últimos quizzes aparecerán aquí.'));
    }
    final fmt = DateFormat.yMd(LanguageService().currentLocale.toString()).add_Hm();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: min(_history.length, 30),
      itemBuilder: (context, i) {
        final q = _history[i];
        final acc = q.totalQuestions == 0 ? 0.0 : q.correctAnswers / q.totalQuestions;
        final good = acc >= 0.8;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AppCard(
            borderColor: good ? p.success : null,
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (good ? p.success : p.accent).withValues(alpha: 0.15),
                    border: Border.all(color: good ? p.success : p.accent, width: 2),
                  ),
                  child: Text('${(acc * 100).round()}%',
                      style: TextStyle(color: good ? p.success : p.accent, fontWeight: FontWeight.w900, fontSize: 13)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('⭐ ${q.score}  ·  ${q.correctAnswers}/${q.totalQuestions}',
                          style: TextStyle(color: p.text, fontWeight: FontWeight.w800, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(
                        [
                          _modeLabel(q.mode),
                          if (q.difficulty != null) _difficultyLabel(q.difficulty!),
                          if (q.category != null) q.category!,
                        ].join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: p.textMuted, fontSize: 12),
                      ),
                      Text(fmt.format(q.playedAt), style: TextStyle(color: p.textMuted, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _modeLabel(String mode) {
    switch (mode) {
      case 'quiz_estudo':
        return t3('📚 Estudo', '📚 Study', '📚 Estudio');
      case 'pie':
        return t3('🥧 Torta', '🥧 Pie', '🥧 Pastel');
      case 'multiplayer':
        return t3('🌐 Online', '🌐 Online', '🌐 En línea');
      default:
        return t3('🧠 Clássico', '🧠 Classic', '🧠 Clásico');
    }
  }

  String _difficultyLabel(String d) {
    switch (stripAccents(d.toLowerCase())) {
      case 'facil':
        return t3('Fácil', 'Easy', 'Fácil');
      case 'medio':
        return t3('Médio', 'Medium', 'Medio');
      case 'dificil':
        return t3('Difícil', 'Hard', 'Difícil');
      default:
        return d;
    }
  }
}

/// Gráfico de linha simples da precisão (0–100%) dos últimos quizzes.
class _AccuracyChart extends CustomPainter {
  final List<double> values;
  final Color line, grid, label;
  _AccuracyChart({required this.values, required this.line, required this.grid, required this.label});

  @override
  void paint(Canvas canvas, Size size) {
    const left = 34.0;
    final w = size.width - left, h = size.height - 6;
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (final v in [0, 50, 100]) {
      final y = h - h * v / 100 + 3;
      canvas.drawLine(Offset(left, y), Offset(size.width, y), gridPaint);
      tp.text = TextSpan(text: '$v%', style: TextStyle(color: label, fontSize: 10));
      tp.layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }
    if (values.length < 2) return;
    Offset pt(int i) => Offset(left + w * i / (values.length - 1), h - h * values[i] + 3);
    final path = Path()..moveTo(pt(0).dx, pt(0).dy);
    for (int i = 1; i < values.length; i++) {
      final a = pt(i - 1), b = pt(i);
      final mid = (a.dx + b.dx) / 2;
      path.cubicTo(mid, a.dy, mid, b.dy, b.dx, b.dy);
    }
    final fill = Path.from(path)
      ..lineTo(pt(values.length - 1).dx, h + 3)
      ..lineTo(left, h + 3)
      ..close();
    canvas.drawPath(fill, Paint()..color = line.withValues(alpha: 0.15));
    canvas.drawPath(
        path,
        Paint()
          ..color = line
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round);
    for (int i = 0; i < values.length; i++) {
      canvas.drawCircle(pt(i), 4, Paint()..color = line);
    }
  }

  @override
  bool shouldRepaint(covariant _AccuracyChart old) => old.values != values || old.line != line;
}
