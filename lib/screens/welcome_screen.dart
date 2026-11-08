import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../services/language_service.dart';
import '../theme/app_theme.dart';
import '../utils/i18n.dart';
import '../widgets/app_ui.dart';

/// Boas-vindas: aparece só na primeira vez que o app é aberto.
/// Já permite escolher o idioma antes de começar.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _start(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenWelcome', true);
    if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = context.palette;
    final langs = LanguageService().getAvailableLanguages();
    return Scaffold(
      backgroundColor: p.background,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [p.backgroundTop, p.background],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.4, end: 1),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.elasticOut,
                      builder: (_, v, child) => Transform.scale(scale: v, child: child),
                      child: Container(
                        width: 130,
                        height: 130,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF6D28D9)]),
                          border: Border.all(color: p.border, width: 2),
                          boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withValues(alpha: 0.4), blurRadius: 30)],
                        ),
                        child: const Text('📖', style: TextStyle(fontSize: 64)),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text('JW SPLASH GAMES',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: p.text, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 1)),
                    const SizedBox(height: 8),
                    Text(
                      t3('Teste seus conhecimentos bíblicos e divirta-se com quiz, minigames e partidas online!',
                          'Test your Bible knowledge and have fun with quizzes, minigames and online matches!',
                          '¡Pon a prueba tus conocimientos bíblicos con quiz, minijuegos y partidas en línea!'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: p.textMuted, fontSize: 16, height: 1.35),
                    ),
                    const SizedBox(height: 28),
                    SectionLabel(t3('Idioma', 'Language', 'Idioma')),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: langs.map((lang) {
                        final selected = lang['code'] == LanguageService().currentLanguageCode;
                        return GestureDetector(
                          onTap: () => LanguageService().changeLanguage(lang['code']!),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected ? p.accent.withValues(alpha: 0.15) : p.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: selected ? p.accent : p.border, width: selected ? 2 : 1),
                            ),
                            child: Text('${lang['flag']}  ${lang['name']}',
                                style: TextStyle(color: p.text, fontWeight: selected ? FontWeight.w800 : FontWeight.w600)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                    AppButton(label: l10n.welcomeStart, icon: Icons.rocket_launch_rounded, onTap: () => _start(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
