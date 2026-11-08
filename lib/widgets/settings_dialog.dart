import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stats_service.dart';
import '../screens/about_screen.dart';
import '../screens/achievements_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/terms_screen.dart';
import '../services/achievement_service.dart';
import '../services/audio_service.dart';
import '../services/chat_service.dart';
import '../services/language_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../utils/i18n.dart';

/// Configurações: aparência, idioma, áudio, atalhos e zerar progresso.
class SettingsDialog extends StatefulWidget {
  /// Mantido por compatibilidade; o tema agora é aplicado pelo [ThemeService].
  final Function(bool)? onThemeChanged;

  const SettingsDialog({super.key, this.onThemeChanged});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final AudioService _audio = AudioService();
  final ThemeService _theme = ThemeService();
  double _musicVolume = 0.4;
  double _sfxVolume = 0.7;
  String _version = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    String version = '';
    try {
      final info = await PackageInfo.fromPlatform();
      version = '${info.version} (${info.buildNumber})';
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _musicVolume = prefs.getDouble('musicVolume') ?? 0.4;
      _sfxVolume = prefs.getDouble('sfxVolume') ?? 0.7;
      _version = version;
    });
  }

  Future<void> _saveVolumes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('musicVolume', _musicVolume);
    await prefs.setDouble('sfxVolume', _sfxVolume);
  }

  void _go(Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _resetProgress() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t3('Zerar todo o progresso?', 'Reset all progress?', '¿Borrar todo el progreso?')),
        content: Text(t3(
            'Estatísticas, recordes, conquistas, níveis do labirinto e a sequência da Pergunta do Dia serão apagados. Suas pinturas do Colorir são mantidas. Não dá para desfazer.',
            'Statistics, records, achievements, maze levels and the Question of the Day streak will be erased. Your Coloring artwork is kept. This cannot be undone.',
            'Se borrarán estadísticas, récords, logros, niveles del laberinto y la racha de la Pregunta del Día. Tus pinturas se conservan. No se puede deshacer.')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t3('Cancelar', 'Cancel', 'Cancelar'))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t3('Zerar', 'Reset', 'Borrar'), style: TextStyle(color: context.palette.danger)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await StorageService().clearAllData();
    await StatsService.resetStats();
    await AchievementService().resetAchievements();
    final prefs = await SharedPreferences.getInstance();
    for (final k in prefs.getKeys().toList()) {
      if (k == 'played_minigames' || k.startsWith('daily_') || k.startsWith('seq_best_') || k.startsWith('maze_')) {
        await prefs.remove(k);
      }
    }
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(t3('Progresso zerado.', 'Progress reset.', 'Progreso borrado.')),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440, maxHeight: 680),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 8, 6),
              child: Row(children: [
                Icon(Icons.settings_rounded, color: p.text),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(t3('Configurações', 'Settings', 'Configuración'),
                      style: TextStyle(color: p.text, fontSize: 22, fontWeight: FontWeight.w900)),
                ),
                IconButton(icon: Icon(Icons.close_rounded, color: p.textMuted), onPressed: () => Navigator.pop(context)),
              ]),
            ),
            Divider(height: 1, color: p.border),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                children: [
                  _label(p, t3('Aparência', 'Appearance', 'Apariencia')),
                  _switchTile(
                    p,
                    icon: _theme.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    iconColor: _theme.isDark ? p.goldText : const Color(0xFFB45309),
                    title: t3('Tema escuro', 'Dark theme', 'Tema oscuro'),
                    value: _theme.isDark,
                    onChanged: (v) async {
                      await _theme.setDark(v);
                      widget.onThemeChanged?.call(v);
                      setState(() {});
                    },
                  ),
                  _switchTile(
                    p,
                    icon: Icons.format_size_rounded,
                    iconColor: p.accent,
                    title: t3('Texto maior', 'Larger text', 'Texto más grande'),
                    subtitle: t3('Facilita a leitura', 'Easier to read', 'Facilita la lectura'),
                    value: _theme.largeText,
                    onChanged: (v) async {
                      await _theme.setLargeText(v);
                      setState(() {});
                    },
                  ),
                  _switchTile(
                    p,
                    icon: Icons.vibration_rounded,
                    iconColor: p.accent,
                    title: t3('Vibração', 'Vibration', 'Vibración'),
                    value: _theme.haptics,
                    onChanged: (v) async {
                      await _theme.setHaptics(v);
                      if (v) Haptics.medium();
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 10),
                  _label(p, t3('Idioma', 'Language', 'Idioma')),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: LanguageService().getAvailableLanguages().map((lang) {
                      final sel = lang['code'] == LanguageService().currentLanguageCode;
                      return GestureDetector(
                        onTap: () async {
                          await LanguageService().changeLanguage(lang['code']!);
                          if (mounted) setState(() {});
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                          decoration: BoxDecoration(
                            color: sel ? p.primary : p.surfaceAlt,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: sel ? p.primary : p.border),
                          ),
                          child: Text('${lang['flag']}  ${lang['name']}',
                              style: TextStyle(color: sel ? Colors.white : p.text, fontWeight: FontWeight.w700)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  _label(p, t3('Áudio', 'Audio', 'Audio')),
                  _slider(p, Icons.music_note_rounded, t3('Música', 'Music', 'Música'), _musicVolume, (v) {
                    setState(() => _musicVolume = v);
                    _audio.setMusicVolume(v);
                    _saveVolumes();
                  }),
                  _slider(p, Icons.graphic_eq_rounded, t3('Efeitos', 'Effects', 'Efectos'), _sfxVolume, (v) {
                    setState(() => _sfxVolume = v);
                    _audio.setSfxVolume(v);
                    _saveVolumes();
                  }, onEnd: (_) => _audio.playSfx('pop')),
                  const SizedBox(height: 10),
                  _label(p, t3('Mais', 'More', 'Más')),
                  _link(p, Icons.emoji_events_rounded, const Color(0xFFB45309), t3('Conquistas', 'Achievements', 'Logros'),
                      () => _go(const AchievementsScreen())),
                  _link(p, Icons.bar_chart_rounded, const Color(0xFF15803D), t3('Estatísticas', 'Statistics', 'Estadísticas'),
                      () => _go(const StatsScreen())),
                  _link(p, Icons.chat_bubble_rounded, const Color(0xFF0E7490), t3('Ajuda e suporte', 'Help & support', 'Ayuda y soporte'),
                      () {
                    Navigator.pop(context);
                    ChatService().openSupportChat(currentScreen: 'Settings');
                  }),
                  _link(p, Icons.description_rounded, const Color(0xFF7C3AED),
                      t3('Termos e privacidade', 'Terms & privacy', 'Términos y privacidad'), () => _go(const TermsScreen())),
                  _link(p, Icons.info_rounded, p.primary, t3('Sobre o app', 'About the app', 'Acerca de la app'),
                      () => _go(const AboutScreen())),
                  const SizedBox(height: 8),
                  _link(p, Icons.restart_alt_rounded, p.danger, t3('Zerar progresso', 'Reset progress', 'Borrar progreso'),
                      _resetProgress),
                  const SizedBox(height: 12),
                  Center(
                    child: Text('JW Splash Games ${_version.isEmpty ? '' : 'v$_version'}',
                        style: TextStyle(color: p.textMuted, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(AppPalette p, String text) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
        child: Text(text.toUpperCase(),
            style: TextStyle(color: p.textMuted, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.1)),
      );

  Widget _switchTile(AppPalette p,
      {required IconData icon,
      required Color iconColor,
      required String title,
      String? subtitle,
      required bool value,
      required ValueChanged<bool> onChanged}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: p.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.border),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(color: p.text, fontWeight: FontWeight.w700)),
        subtitle: subtitle == null ? null : Text(subtitle, style: TextStyle(color: p.textMuted, fontSize: 12)),
      ),
    );
  }

  Widget _slider(AppPalette p, IconData icon, String label, double value, ValueChanged<double> onChanged,
      {ValueChanged<double>? onEnd}) {
    return Row(children: [
      Icon(icon, color: p.textMuted, size: 22),
      const SizedBox(width: 8),
      SizedBox(width: 70, child: Text(label, style: TextStyle(color: p.text, fontWeight: FontWeight.w600))),
      Expanded(
        child: Slider(value: value, divisions: 10, label: '${(value * 100).round()}%', onChanged: onChanged, onChangeEnd: onEnd),
      ),
    ]);
  }

  Widget _link(AppPalette p, IconData icon, Color color, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          AudioService().playClick();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: p.surfaceAlt,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: p.border),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: TextStyle(color: p.text, fontWeight: FontWeight.w700))),
            Icon(Icons.chevron_right_rounded, color: p.textMuted),
          ]),
        ),
      ),
    );
  }
}
