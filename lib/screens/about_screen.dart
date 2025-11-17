import 'package:flutter/material.dart';

/// Tela "Sobre o Jogo"
/// 
/// TODO: Esta tela atualmente mostra conteúdo placeholder.
/// No futuro, deve carregar informações de uma página online dedicada.
/// Considerar usar WebView ou integração com site oficial quando disponível.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📱 Sobre o Jogo'),
        backgroundColor: const Color(0xFF4A90E2),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF4A90E2).withOpacity(0.1),
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
                      color: Colors.black.withOpacity(0.2),
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
                'Versão 1.0.0',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              
              // Description Card
              _buildCard(
                icon: '🎮',
                title: 'O que é?',
                content: 'JW SPLASH GAMES é um aplicativo educativo que torna o aprendizado bíblico divertido e interativo através de quizzes, minigames e desafios.',
              ),
              const SizedBox(height: 16),
              
              _buildCard(
                icon: '🎯',
                title: 'Recursos',
                content: '''• Quiz Bíblico Interativo
• Jogo da Memória
• Caça-Palavras
• Labirinto
• Sistema de Conquistas
• Estatísticas Detalhadas
• Modo Multiplayer
• 3 Idiomas (PT, EN, ES)''',
              ),
              const SizedBox(height: 16),
              
              _buildCard(
                icon: '👥',
                title: 'Desenvolvido por',
                content: 'Equipe JW SPLASH GAMES\nProjeto open-source disponível no GitHub',
              ),
              const SizedBox(height: 16),
              
              _buildCard(
                icon: '💡',
                title: 'Objetivo',
                content: 'Proporcionar uma forma divertida e educativa de aprender e memorizar conhecimentos bíblicos, adequado para todas as idades.',
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
                        '📝 Esta página será atualizada em breve com mais informações e link para página online oficial.',
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
                label: const Text('Ver no GitHub'),
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
            color: Colors.black.withOpacity(0.05),
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
