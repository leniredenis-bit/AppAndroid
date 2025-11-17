import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ℹ️ Termos e Condições'),
        backgroundColor: const Color(0xFF9B59B6),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF9B59B6).withOpacity(0.1),
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
                title: '📋 Termos de Uso',
                content: [
                  _buildParagraph(
                    'Bem-vindo ao JW SPLASH GAMES! Este aplicativo foi desenvolvido para fins educacionais e de entretenimento, visando promover o conhecimento bíblico de forma interativa.',
                  ),
                  _buildSubtitle('1. Uso do Aplicativo'),
                  _buildParagraph(
                    'O JW SPLASH GAMES é um aplicativo gratuito para uso pessoal. Você pode:',
                  ),
                  _buildBulletList([
                    'Jogar quizzes individuais ou em grupo',
                    'Acessar estatísticas pessoais',
                    'Usar o modo estudo sem limite de tempo',
                    'Jogar minigames educativos',
                    'Desbloquear conquistas',
                  ]),
                  _buildSubtitle('2. Conteúdo Bíblico'),
                  _buildParagraph(
                    'As perguntas e respostas são baseadas na Bíblia Sagrada. Este aplicativo não substitui o estudo pessoal das Escrituras Sagradas nem representa uma organização religiosa oficial.',
                  ),
                  _buildSubtitle('3. Responsabilidades'),
                  _buildParagraph(
                    'O usuário é responsável por seu uso adequado do aplicativo. Não nos responsabilizamos por:',
                  ),
                  _buildBulletList([
                    'Uso indevido das informações apresentadas',
                    'Interpretações pessoais do conteúdo bíblico',
                    'Problemas técnicos ou perda de dados',
                  ]),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: '🔒 Política de Privacidade',
                content: [
                  _buildParagraph(
                    'Respeitamos sua privacidade. Este aplicativo:',
                  ),
                  _buildSubtitle('1. Dados Coletados'),
                  _buildBulletList([
                    'Dados de uso: Estatísticas de jogo, preferências de tema',
                    'Dados técnicos: Tipo de dispositivo, navegador, sistema operacional',
                    'Dados de sessão: Tempo de uso, páginas visitadas',
                  ]),
                  _buildSubtitle('2. Armazenamento'),
                  _buildParagraph(
                    'Todos os dados são armazenados localmente no seu dispositivo. Não enviamos dados para servidores externos.',
                  ),
                  _buildSubtitle('3. LocalStorage'),
                  _buildParagraph(
                    'Usamos localStorage do navegador para salvar:',
                  ),
                  _buildBulletList([
                    'Preferências do usuário (tema, idioma)',
                    'Estatísticas pessoais de jogo',
                    'Conquistas desbloqueadas',
                  ]),
                  _buildSubtitle('4. Compartilhamento'),
                  _buildParagraph(
                    'Não compartilhamos seus dados pessoais com terceiros. Os dados permanecem exclusivamente no seu dispositivo.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: '©️ Direitos Autorais',
                content: [
                  _buildSubtitle('1. Conteúdo do Aplicativo'),
                  _buildParagraph(
                    'O código do aplicativo JW SPLASH GAMES é distribuído sob licença MIT. As perguntas e respostas são de domínio público ou foram criadas especificamente para este projeto educacional.',
                  ),
                  _buildSubtitle('2. Bíblia e Textos Sagrados'),
                  _buildParagraph(
                    'Os textos bíblicos citados seguem a Tradução do Novo Mundo (TNM) das Escrituras Sagradas, usada com permissão para fins educacionais não comerciais.',
                  ),
                  _buildSubtitle('3. Imagens e Ícones'),
                  _buildParagraph(
                    'Os ícones e emojis utilizados são de fontes públicas ou licenciadas para uso gratuito.',
                  ),
                  _buildSubtitle('4. Uso Não Comercial'),
                  _buildParagraph(
                    'Este aplicativo é desenvolvido para fins educacionais e não comerciais. Qualquer uso comercial requer autorização prévia.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: '📞 Contato',
                content: [
                  _buildParagraph(
                    'Para dúvidas, sugestões ou relatar problemas:',
                  ),
                  _buildBulletList([
                    'GitHub: leniredenis-bit/JWQuizAndroid',
                  ]),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '📅 Última Atualização: Novembro 2025',
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
            color: Colors.black.withOpacity(0.05),
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
