import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/app_ui.dart';

/// Versão pública da política (exigida pelas lojas): web/privacidade.html,
/// publicada pelo workflow .github/workflows/deploy.yml
const String privacyPolicyUrl = 'https://leniredenis-bit.github.io/AppAndroid/privacidade.html';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = context.palette;

    return AppPage(
      title: l10n.termsTitle,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(p, l10n.termsOfUse, [
            _paragraph(p, l10n.termsWelcome),
            _subtitle(p, l10n.termsAppUsage),
            _paragraph(p, l10n.termsAppUsageDesc),
            _bullets(p, [
              l10n.termsAppUsageItem1,
              l10n.termsAppUsageItem2,
              l10n.termsAppUsageItem3,
              l10n.termsAppUsageItem4,
              l10n.termsAppUsageItem5,
            ]),
            _subtitle(p, l10n.termsBiblicalContent),
            _paragraph(p, l10n.termsBiblicalContentDesc),
            _subtitle(p, l10n.termsResponsibilities),
            _paragraph(p, l10n.termsResponsibilitiesDesc),
            _bullets(p, [
              l10n.termsResponsibilitiesItem1,
              l10n.termsResponsibilitiesItem2,
              l10n.termsResponsibilitiesItem3,
            ]),
          ]),
          const SizedBox(height: 16),
          _section(p, l10n.privacyPolicy, [
            _paragraph(p, l10n.privacyPolicyIntro),
            _subtitle(p, l10n.privacyDataCollected),
            _bullets(p, [l10n.privacyDataItem1, l10n.privacyDataItem2, l10n.privacyDataItem3]),
            _subtitle(p, l10n.privacyStorage),
            _paragraph(p, l10n.privacyStorageDesc),
            _subtitle(p, l10n.privacySupportChat),
            _paragraph(p, l10n.privacySupportChatDesc),
            _subtitle(p, l10n.privacySharing),
            _paragraph(p, l10n.privacySharingDesc),
            _subtitle(p, l10n.privacyRights),
            _paragraph(p, l10n.privacyRightsDesc),
            _paragraph(p, privacyPolicyUrl),
          ]),
          const SizedBox(height: 16),
          _section(p, l10n.copyright, [
            _subtitle(p, l10n.copyrightAppContent),
            _paragraph(p, l10n.copyrightAppContentDesc),
            _subtitle(p, l10n.copyrightBible),
            _paragraph(p, l10n.copyrightBibleDesc),
            _subtitle(p, l10n.copyrightImages),
            _paragraph(p, l10n.copyrightImagesDesc),
            _subtitle(p, l10n.copyrightNonCommercial),
            _paragraph(p, l10n.copyrightNonCommercialDesc),
          ]),
          const SizedBox(height: 16),
          _section(p, l10n.contactSection, [
            _paragraph(p, l10n.contactDesc),
            _bullets(p, [l10n.contactSupportChat]),
          ]),
          const SizedBox(height: 20),
          Center(
            child: Text(l10n.lastUpdated,
                style: TextStyle(fontSize: 12, color: p.textMuted, fontStyle: FontStyle.italic)),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _section(AppPalette p, String title, List<Widget> content) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: p.accent)),
          const SizedBox(height: 8),
          ...content,
        ],
      ),
    );
  }

  Widget _subtitle(AppPalette p, String text) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: p.text)),
      );

  Widget _paragraph(AppPalette p, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: TextStyle(fontSize: 14, color: p.textMuted, height: 1.5)),
      );

  Widget _bullets(AppPalette p, List<String> items) {
    return Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: p.text)),
                    Expanded(child: Text(item, style: TextStyle(fontSize: 14, color: p.textMuted, height: 1.5))),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
