import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/i18n.dart';
import '../utils/in_app_browser.dart';
import '../widgets/app_ui.dart';
import 'terms_screen.dart' show privacyPolicyUrl;

/// Tela "Sobre o app"
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = context.palette;

    return AppPage(
      title: l10n.aboutTitle,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 116,
              height: 116,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF6D28D9)]),
                border: Border.all(color: p.border, width: 2),
                boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withValues(alpha: 0.35), blurRadius: 20)],
              ),
              child: const Text('📖', style: TextStyle(fontSize: 58)),
            ),
          ),
          const SizedBox(height: 18),
          Text('JW SPLASH GAMES',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: p.text)),
          const SizedBox(height: 4),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (_, snap) => Text(
              snap.hasData ? '${t3('Versão', 'Version', 'Versión')} ${snap.data!.version}' : ' ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: p.textMuted),
            ),
          ),
          const SizedBox(height: 24),
          _card(p, '🎮', l10n.aboutWhatIs, l10n.aboutWhatIsDesc),
          _card(p, '🎯', l10n.aboutFeatures, l10n.aboutFeaturesDesc),
          _card(p, '👥', l10n.aboutDevelopedBy, l10n.aboutDevelopedByDesc),
          _card(p, '💡', l10n.aboutObjective, l10n.aboutObjectiveDesc),
          _card(p, '🎵', l10n.aboutCredits, l10n.aboutMusicCredits),
          const SizedBox(height: 8),
          AppButton(
            label: l10n.privacyPolicy,
            icon: Icons.privacy_tip_outlined,
            onTap: () => openInAppBrowser(context, privacyPolicyUrl),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _card(AppPalette p, String icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: p.accent)),
              ),
            ]),
            const SizedBox(height: 10),
            Text(content, style: TextStyle(fontSize: 14, color: p.textMuted, height: 1.55)),
          ],
        ),
      ),
    );
  }
}
