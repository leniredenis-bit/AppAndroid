import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../models/achievement.dart';
import '../models/achievement_texts.dart';
import '../services/achievement_service.dart';
import '../services/audio_service.dart';
import '../services/language_service.dart';
import '../theme/app_theme.dart';
import '../utils/i18n.dart';
import '../widgets/app_ui.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final AchievementService _service = AchievementService();
  List<Achievement> _all = [];
  AchievementCategory? _category;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await _service.getAchievements();
    if (!mounted) return;
    setState(() {
      _all = list;
      _loading = false;
    });
  }

  String _categoryName(AchievementCategory? c) {
    switch (c) {
      case AchievementCategory.quiz:
        return t3('Quiz', 'Quiz', 'Quiz');
      case AchievementCategory.minigame:
        return t3('Minigames', 'Minigames', 'Minijuegos');
      case AchievementCategory.social:
        return t3('Online', 'Online', 'En línea');
      case AchievementCategory.master:
        return t3('Mestre', 'Master', 'Maestro');
      default:
        return t3('Todas', 'All', 'Todos');
    }
  }

  /// Conquistas bloqueadas mais perto de desbloquear.
  List<Achievement> get _next {
    final locked = _all.where((a) => !a.isUnlocked).toList()
      ..sort((a, b) => b.progressPercentage.compareTo(a.progressPercentage));
    return locked.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final unlocked = _all.where((a) => a.isUnlocked).length;
    final total = _all.length;
    final pct = total == 0 ? 0.0 : unlocked / total;
    final shown = _category == null ? _all : _all.where((a) => a.category == _category).toList();

    return AppPage(
      title: t3('🏆 Conquistas', '🏆 Achievements', '🏆 Logros'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  sliver: SliverList.list(children: [
                    AppCard(
                      borderColor: p.goldText.withValues(alpha: 0.6),
                      child: Column(children: [
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Text('🏆', style: TextStyle(fontSize: 30)),
                          const SizedBox(width: 10),
                          Text('$unlocked / $total', style: TextStyle(color: p.text, fontSize: 28, fontWeight: FontWeight.w900)),
                        ]),
                        Text(t3('conquistas desbloqueadas', 'achievements unlocked', 'logros desbloqueados'),
                            style: TextStyle(color: p.textMuted)),
                        const SizedBox(height: 12),
                        _progress(p, pct, pct >= 1 ? p.gold : p.accent, height: 12),
                        const SizedBox(height: 6),
                        Text('${(pct * 100).round()}%', style: TextStyle(color: p.text, fontWeight: FontWeight.w800)),
                      ]),
                    ),
                    if (_next.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      SectionLabel(t3('Quase lá', 'Almost there', 'Casi lo logras')),
                      ..._next.map((a) => Padding(padding: const EdgeInsets.only(bottom: 8), child: _nextRow(p, a))),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 42,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [null, ...AchievementCategory.values].map((c) {
                          final sel = c == _category;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                AudioService().playClick();
                                setState(() => _category = c);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 160),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: sel ? p.primary : p.surface,
                                  borderRadius: BorderRadius.circular(21),
                                  border: Border.all(color: sel ? p.primary : p.border),
                                ),
                                child: Text(_categoryName(c),
                                    style: TextStyle(color: sel ? Colors.white : p.text, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ]),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.86,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => TweenAnimationBuilder<double>(
                        key: ValueKey('${_category?.name}-$i'),
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 250 + i * 50),
                        curve: Curves.easeOutBack,
                        builder: (_, v, child) => Opacity(
                          opacity: v.clamp(0.0, 1.0),
                          child: Transform.scale(scale: 0.85 + 0.15 * v, child: child),
                        ),
                        child: _card(p, shown[i]),
                      ),
                      childCount: shown.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _progress(AppPalette p, double value, Color color, {double height = 8}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: p.surfaceAlt,
        borderRadius: BorderRadius.circular(height),
        border: Border.all(color: p.border, width: 0.8),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(height))),
      ),
    );
  }

  Widget _nextRow(AppPalette p, Achievement a) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      onTap: () => _details(a),
      child: Row(children: [
        Text(a.emoji, style: const TextStyle(fontSize: 30)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(achievementName(a.nameKey), style: TextStyle(color: p.text, fontWeight: FontWeight.w800)),
            Text(achievementDescription(a.nameKey),
                maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: p.textMuted, fontSize: 12)),
            const SizedBox(height: 6),
            _progress(p, a.progressPercentage / 100, p.accent),
          ]),
        ),
        const SizedBox(width: 10),
        Text('${a.currentProgress}/${a.requiredValue}', style: TextStyle(color: p.accent, fontWeight: FontWeight.w900)),
      ]),
    );
  }

  Widget _card(AppPalette p, Achievement a) {
    final on = a.isUnlocked;
    return AppCard(
      onTap: () => _details(a),
      padding: const EdgeInsets.all(12),
      color: on ? p.gold.withValues(alpha: p.isDark ? 0.16 : 0.22) : p.surface,
      borderColor: on ? p.goldText : p.border,
      borderWidth: on ? 2 : 1.2,
      child: LayoutBuilder(builder: (context, c) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(opacity: on ? 1 : 0.4, child: Text(a.emoji, style: TextStyle(fontSize: c.maxWidth * 0.32))),
            const SizedBox(height: 8),
            Text(achievementName(a.nameKey),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: p.text, fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(height: 8),
            if (on)
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.check_circle_rounded, color: p.goldText, size: 16),
                const SizedBox(width: 4),
                Text(t3('Desbloqueada', 'Unlocked', 'Desbloqueado'),
                    style: TextStyle(color: p.goldText, fontSize: 12, fontWeight: FontWeight.w700)),
              ])
            else ...[
              _progress(p, a.progressPercentage / 100, p.accent, height: 7),
              const SizedBox(height: 4),
              Text('${a.currentProgress}/${a.requiredValue}', style: TextStyle(color: p.textMuted, fontSize: 11)),
            ],
          ],
        );
      }),
    );
  }

  void _details(Achievement a) {
    final p = context.palette;
    final date = a.unlockedAt == null
        ? ''
        : DateFormat.yMMMd(LanguageService().currentLocale.toString()).format(a.unlockedAt!);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(a.emoji, style: const TextStyle(fontSize: 68)),
            const SizedBox(height: 10),
            Text(achievementName(a.nameKey),
                textAlign: TextAlign.center, style: TextStyle(color: p.text, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(achievementDescription(a.nameKey), textAlign: TextAlign.center, style: TextStyle(color: p.textMuted)),
            const SizedBox(height: 14),
            AppChip(label: _categoryName(a.category), color: p.accent),
            const SizedBox(height: 14),
            if (a.isUnlocked)
              Text('✅ ${t3('Desbloqueada em', 'Unlocked on', 'Desbloqueado el')} $date',
                  style: TextStyle(color: p.goldText, fontWeight: FontWeight.w800))
            else ...[
              _progress(p, a.progressPercentage / 100, p.accent, height: 10),
              const SizedBox(height: 6),
              Text('${a.currentProgress}/${a.requiredValue}', style: TextStyle(color: p.text, fontWeight: FontWeight.w800)),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(t3('Fechar', 'Close', 'Cerrar'))),
        ],
      ),
    );
  }
}
