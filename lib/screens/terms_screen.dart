import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.termsTitle),
        backgroundColor: const Color(0xFF9B59B6),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF9B59B6).withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                title: l10n.termsOfUse,
                content: [
                  _buildParagraph(l10n.termsWelcome),
                  _buildSubtitle(l10n.termsAppUsage),
                  _buildParagraph(l10n.termsAppUsageDesc),
                  _buildBulletList([
                    l10n.termsAppUsageItem1,
                    l10n.termsAppUsageItem2,
                    l10n.termsAppUsageItem3,
                    l10n.termsAppUsageItem4,
                    l10n.termsAppUsageItem5,
                  ]),
                  _buildSubtitle(l10n.termsBiblicalContent),
                  _buildParagraph(l10n.termsBiblicalContentDesc),
                  _buildSubtitle(l10n.termsResponsibilities),
                  _buildParagraph(l10n.termsResponsibilitiesDesc),
                  _buildBulletList([
                    l10n.termsResponsibilitiesItem1,
                    l10n.termsResponsibilitiesItem2,
                    l10n.termsResponsibilitiesItem3,
                  ]),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: l10n.privacyPolicy,
                content: [
                  _buildParagraph(l10n.privacyPolicyIntro),
                  _buildSubtitle(l10n.privacyDataCollected),
                  _buildBulletList([
                    l10n.privacyDataItem1,
                    l10n.privacyDataItem2,
                    l10n.privacyDataItem3,
                  ]),
                  _buildSubtitle(l10n.privacyStorage),
                  _buildParagraph(l10n.privacyStorageDesc),
                  _buildSubtitle(l10n.privacyLocalStorage),
                  _buildParagraph(l10n.privacyLocalStorageDesc),
                  _buildBulletList([
                    l10n.privacyLocalStorageItem1,
                    l10n.privacyLocalStorageItem2,
                    l10n.privacyLocalStorageItem3,
                  ]),
                  _buildSubtitle(l10n.privacySharing),
                  _buildParagraph(l10n.privacySharingDesc),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: l10n.copyright,
                content: [
                  _buildSubtitle(l10n.copyrightAppContent),
                  _buildParagraph(l10n.copyrightAppContentDesc),
                  _buildSubtitle(l10n.copyrightBible),
                  _buildParagraph(l10n.copyrightBibleDesc),
                  _buildSubtitle(l10n.copyrightImages),
                  _buildParagraph(l10n.copyrightImagesDesc),
                  _buildSubtitle(l10n.copyrightNonCommercial),
                  _buildParagraph(l10n.copyrightNonCommercialDesc),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: l10n.contactSection,
                content: [
                  _buildParagraph(l10n.contactDesc),
                  _buildBulletList([
                    'GitHub: leniredenis-bit/JWQuizAndroid',
                  ]),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  l10n.lastUpdated,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9B59B6),
            ),
          ),
          const SizedBox(height: 12),
          ...content,
        ],
      ),
    );
  }

  Widget _buildSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF555555),
          height: 1.5,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      children: items.map((item) => Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF555555),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}
