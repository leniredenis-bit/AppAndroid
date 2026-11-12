import 'dart:math';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/stats_data.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../utils/i18n.dart';
import '../widgets/app_ui.dart';
import '../widgets/daily_question_card.dart';
import '../widgets/quiz_setup_sheet.dart';
import '../widgets/settings_dialog.dart';
import 'achievements_screen.dart';
import 'minigames_menu_screen.dart';
import 'multiplayer/multiplayer_menu_screen.dart';
import 'pie_quiz_screen.dart';
import 'quiz_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalStats? _stats;
  int _dailyStreak = 0;
  Key _dailyKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    AudioService().playBackgroundMusic('home');
    _loadStats();
  }

  @override
  void dispose() {
    AudioService().stopBackgroundMusic();
    super.dispose();
  }

  Future<void> _loadStats() async {
    final s = await StorageService().getGlobalStats();
    if (mounted) setState(() => _stats = s);
  }

  /// Abre uma tela e, ao voltar, retoma a música e atualiza os números.
  Future<void> _open(Widget screen) async {
    AudioService().playClick();
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    if (!mounted) return;
    AudioService().playBackgroundMusic('home');
    _loadStats();
    setState(() => _dailyKey = UniqueKey()); // a data pode ter virado
  }

  Future<void> _startClassic() async {
    final l10n = AppLocalizations.of(context)!;
    final cfg = await showQuizSetup(context, title: '🧠 ${l10n.homeQuizClassic}');
    if (cfg == null || !mounted) return;
    final questions = await cfg.build();
    if (!mounted) return;
    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.homeNoQuestionsFound)));
      return;
    }
    _open(QuizScreen(questions: questions, studyMode: cfg.studyMode, replay: cfg.build));
  }

  Future<void> _startPie() async {
    final l10n = AppLocalizations.of(context)!;
    final cfg = await showQuizSetup(context, title: '🥧 ${l10n.homeQuizPie}', allowStudyMode: false);
    if (cfg == null || !mounted) return;
    final questions = await cfg.build();
    if (!mounted) return;
    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.homeNoQuestionsFound)));
      return;
    }
    _open(PieQuizScreen(questions: questions, replay: cfg.build));
  }

  void _openSettings() {
    AudioService().playClick();
    showDialog(context: context, builder: (_) => SettingsDialog(onThemeChanged: (_) {}));
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return t3('Bom dia! ☀️', 'Good morning! ☀️', '¡Buenos días! ☀️');
    if (h < 18) return t3('Boa tarde! 🌤️', 'Good afternoon! 🌤️', '¡Buenas tardes! 🌤️');
    return t3('Boa noite! 🌙', 'Good evening! 🌙', '¡Buenas noches! 🌙');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = context.palette;
    return AppPage(
      title: 'JW Splash Games',
      leading: const SizedBox.shrink(),
      actions: [
        IconButton(
          tooltip: t3('Configurações', 'Settings', 'Configuración'),
          icon: const Icon(Icons.settings_rounded),
          onPressed: _openSettings,
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          _header(p),
          const SizedBox(height: 16),
          DailyQuestionCard(key: _dailyKey, onStreak: (s) => setState(() => _dailyStreak = s)),
          const SizedBox(height: 16),
          _classicCard(l10n),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, c) {
            final cols = max(2, (c.maxWidth / 200).floor());
            final w = (c.maxWidth - (cols - 1) * 12) / cols;
            final modes = [
              _Mode('🥧', l10n.homeQuizPie, l10n.homeQuizPieDesc, const [Color(0xFFC2410C), Color(0xFF9A3412)], _startPie),
              _Mode('🌐', l10n.homeOnlineMatch, l10n.homeOnlineMatchDesc, const [Color(0xFF0F766E), Color(0xFF134E4A)],
                  () => _open(const MultiplayerMenuScreen())),
              _Mode('🎮', l10n.homeMinigames, l10n.homeMinigamesDesc, const [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                  () => _open(const MinigamesMenuScreen())),
              _Mode('📊', l10n.homeStats, t3('Seu desempenho', 'Your performance', 'Tu desempeño'),
                  const [Color(0xFF2563EB), Color(0xFF1E40AF)], () => _open(const StatsScreen())),
              _Mode('🏆', t3('Conquistas', 'Achievements', 'Logros'), t3('15 para desbloquear', '15 to unlock', '15 por desbloquear'),
                  const [Color(0xFFB45309), Color(0xFF92400E)], () => _open(const AchievementsScreen())),
            ];
            // Se sobrar um cartão sozinho na última linha, ele ocupa a largura toda
            final leftover = modes.length % cols;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (int i = 0; i < modes.length; i++)
                  leftover == 1 && i == modes.length - 1
                      ? SizedBox(width: c.maxWidth, height: w * 0.62, child: _ModeCard(mode: modes[i], wide: true))
                      : SizedBox(width: w, height: w * 0.78, child: _ModeCard(mode: modes[i])),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _header(AppPalette p) {
    final s = _stats;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_greeting, style: TextStyle(color: p.text, fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 2),
        Text(t3('Pronto para aprender brincando?', 'Ready to learn while you play?', '¿Listo para aprender jugando?'),
            style: TextStyle(color: p.textMuted, fontSize: 15)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _statPill(p, '🔥', '$_dailyStreak', t3('dias seguidos', 'day streak', 'días seguidos')),
            _statPill(p, '⭐', '${s?.highScore ?? 0}', t3('recorde', 'best score', 'récord')),
            _statPill(p, '🧠', '${s?.totalQuizzes ?? 0}', t3('quizzes', 'quizzes', 'quizzes')),
          ],
        ),
      ],
    );
  }

  Widget _statPill(AppPalette p, String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.border),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(emoji, style: const TextStyle(fontSize: 15)),
        const SizedBox(width: 6),
        Text(value, style: TextStyle(color: p.text, fontWeight: FontWeight.w900)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: p.textMuted, fontSize: 12)),
      ]),
    );
  }

  Widget _classicCard(AppLocalizations l10n) {
    return AppCard(
      onTap: _startClassic,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2563EB), Color(0xFF6D28D9)],
      ),
      borderColor: Colors.white.withValues(alpha: 0.25),
      padding: const EdgeInsets.all(18),
      child: LayoutBuilder(builder: (context, c) {
        final emoji = (c.maxWidth * 0.17).clamp(52.0, 96.0);
        return Row(
          children: [
            Text('🧠', style: TextStyle(fontSize: emoji)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.homeQuizClassic,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(t3('1.180 perguntas · escolha tema e dificuldade', '1,180 questions · pick topic and difficulty',
                          '1.180 preguntas · elige tema y dificultad'),
                      style: const TextStyle(color: Colors.white, fontSize: 13)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.play_arrow_rounded, color: Color(0xFF1E40AF)),
                      const SizedBox(width: 4),
                      Text(t3('Jogar', 'Play', 'Jugar'),
                          style: const TextStyle(color: Color(0xFF1E40AF), fontWeight: FontWeight.w900, fontSize: 15)),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _Mode {
  final String emoji, title, desc;
  final List<Color> colors;
  final VoidCallback onTap;
  _Mode(this.emoji, this.title, this.desc, this.colors, this.onTap);
}

class _ModeCard extends StatelessWidget {
  final _Mode mode;
  final bool wide;
  const _ModeCard({required this.mode, this.wide = false});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: mode.onTap,
      padding: EdgeInsets.zero,
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: mode.colors),
      borderColor: Colors.white.withValues(alpha: 0.22),
      child: LayoutBuilder(builder: (context, c) {
        if (wide) {
          final iconSize = min(48.0, c.maxHeight * 0.52);
          final k = (c.maxWidth / 300).clamp(0.85, 1.2);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(mode.emoji, style: TextStyle(fontSize: iconSize)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(mode.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15 * k)),
                      Text(mode.desc,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 11.5 * k, height: 1.2)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Emoji e texto proporcionais ao cartão (web/tablet não ficam com ícone minúsculo)
        final k = (c.maxWidth / 170).clamp(0.85, 1.6);
        return Padding(
          padding: EdgeInsets.all(12 * k),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mode.emoji, style: TextStyle(fontSize: c.maxWidth * 0.22)),
              const Spacer(),
              Text(mode.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15 * k)),
              Text(mode.desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 11.5 * k, height: 1.2)),
            ],
          ),
        );
      }),
    );
  }
}
