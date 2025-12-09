import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Tela "Sobre o Jogo"
/// 
/// TODO: Esta tela atualmente mostra conteúdo placeholder.
/// No futuro, deve carregar informações de uma página online dedicada.
/// Considerar usar WebView ou integração com site oficial quando disponível.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aboutTitle),
        backgroundColor: const Color(0xFF4A90E2),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF4A90E2).withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Icon/Logo Placeholder
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '📖',
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // App Name
              const Text(
                'JW SPLASH GAMES',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                ),
              ),
              const SizedBox(height: 8),
              
              // Version
              Text(
                l10n.aboutVersion,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              
              // Description Card
              _buildCard(
                icon: '🎮',
                title: l10n.aboutWhatIs,
                content: l10n.aboutWhatIsDesc,
              ),
              const SizedBox(height: 16),
              
              _buildCard(
                icon: '🎯',
                title: l10n.aboutFeatures,
                content: l10n.aboutFeaturesDesc,
              ),
              const SizedBox(height: 16),
              
              _buildCard(
                icon: '👥',
                title: l10n.aboutDevelopedBy,
                content: l10n.aboutDevelopedByDesc,
              ),
              const SizedBox(height: 16),
              
              _buildCard(
                icon: '💡',
                title: l10n.aboutObjective,
                content: l10n.aboutObjectiveDesc,
              ),
              const SizedBox(height: 32),
              
              // TODO Note for developers
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.aboutUpdateNote,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.amber.shade900,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // GitHub Link
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Abrir GitHub no navegador
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('GitHub: leniredenis-bit/JWQuizAndroid'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.code),
                label: Text(l10n.aboutVisitGithub),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
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

  Widget _buildCard({required String icon, required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
