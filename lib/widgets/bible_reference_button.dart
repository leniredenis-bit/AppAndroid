import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/in_app_browser.dart';
import '../services/language_service.dart';

/// Widget que exibe uma referência bíblica clicável que abre no JW Library app
/// (se instalado) ou no navegador com preview.
/// 
/// USO LEGAL: Este widget NÃO copia o texto bíblico (direitos autorais), apenas
/// cria um link para o jw.org oficial, respeitando os termos de uso.
/// 
/// PREVIEW: Usa Custom Tabs (Android) / Safari View Controller (iOS) para
/// mostrar o conteúdo dentro do app com preview visual.
class BibleReferenceButton extends StatelessWidget {
  final String reference; // Ex: "Gênesis 6:13-14" ou "João 3:16"
  
  const BibleReferenceButton({
    super.key,
    required this.reference,
  });

  /// Converte a referência textual para URL do JW.org baseado no idioma
  /// 
  /// URLs por idioma:
  /// - PT: https://www.jw.org/pt/busca/?q=Daniel+6%3A16&link=%2Fresults%2FT%2Fbible%3Fq%3D
  /// - EN: https://www.jw.org/en/search/?q=Genesis+6%3A13-14&link=%2Fresults%2FE%2Fbible%3Fq%3D
  /// - ES: https://www.jw.org/es/búsquedas/?q=génesis+6%3A13-14&link=%2Fresults%2FS%2Fall%3Fsort%3Drel%26q%3D
  String _buildJWUrl() {
    final cleanRef = reference.trim();
    final query = Uri.encodeComponent(cleanRef).replaceAll('%20', '+');
    final lang = LanguageService().currentLanguageCode;
    
    switch (lang) {
      case 'en':
        return 'https://www.jw.org/en/search/?q=$query&link=%2Fresults%2FE%2Fbible%3Fq%3D';
      case 'es':
        return 'https://www.jw.org/es/búsquedas/?q=$query&link=%2Fresults%2FS%2Fall%3Fsort%3Drel%26q%3D';
      default: // 'pt'
        return 'https://www.jw.org/pt/busca/?q=$query&link=%2Fresults%2FT%2Fbible%3Fq%3D';
    }
  }

  /// Abre a referência em meia tela, por cima do jogo (ver [openInAppBrowser]).
  Future<void> _openReferenceWithPreview(BuildContext context) => openInAppBrowser(context, _buildJWUrl());

  @override
  Widget build(BuildContext context) {
    final lang = LanguageService().currentLanguageCode;
    
    // Texto "Toque para ler o texto completo" por idioma
    final readTextMessages = {
      'pt': 'Toque para ler o texto completo',
      'en': 'Tap to read the full text',
      'es': 'Toca para leer el texto completo',
    };
    
    final p = context.palette;
    return InkWell(
      onTap: () => _openReferenceWithPreview(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: p.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: p.accent.withValues(alpha: 0.6), width: 1.2),
        ),
        child: Row(
          children: [
            Icon(
              Icons.menu_book_rounded,
              color: p.accent,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    reference,
                    style: TextStyle(
                      color: p.accent,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    readTextMessages[lang] ?? readTextMessages['pt']!,
                    style: TextStyle(
                      color: p.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.open_in_new,
              color: Colors.white54,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
