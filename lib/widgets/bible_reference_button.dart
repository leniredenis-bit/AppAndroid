import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;

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

  /// Converte a referência textual para URL do JW.org
  /// 
  /// Formato: https://www.jw.org/pt/biblioteca-biblica/biblia/busca/?q=Genesis+6:13
  String _buildJWUrl() {
    final query = Uri.encodeComponent(reference.trim());
    return 'https://www.jw.org/pt/biblioteca-biblica/biblia/busca/?q=$query';
  }

  /// Abre o link com preview usando Custom Tabs (melhor experiência)
  /// 
  /// Custom Tabs oferece:
  /// - Preview da página dentro do app
  /// - Animação de entrada/saída suave
  /// - Botão X para fechar rapidamente
  /// - Melhor performance que WebView
  Future<void> _openReferenceWithPreview(BuildContext context) async {
    final url = _buildJWUrl();
    
    try {
      // Tenta abrir com Custom Tabs (preview dentro do app)
      await custom_tabs.launchUrl(
        Uri.parse(url),
        customTabsOptions: custom_tabs.CustomTabsOptions(
          colorSchemes: custom_tabs.CustomTabsColorSchemes.defaults(
            toolbarColor: const Color(0xFF23395D), // Cor do toolbar
          ),
          shareState: custom_tabs.CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
          closeButton: custom_tabs.CustomTabsCloseButton(
            icon: custom_tabs.CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: custom_tabs.SafariViewControllerOptions(
          preferredBarTintColor: const Color(0xFF23395D),
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          dismissButtonStyle: custom_tabs.SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // Fallback: se Custom Tabs falhar, usa método padrão
      if (context.mounted) {
        await _openReferenceFallback(context);
      }
    }
  }

  /// Fallback: abre com url_launcher padrão (sem preview)
  Future<void> _openReferenceFallback(BuildContext context) async {
    final url = _buildJWUrl();
    final uri = Uri.parse(url);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        _showError(context, 'Não foi possível abrir a referência.');
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Erro ao abrir: ${e.toString()}');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openReferenceWithPreview(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF23395D),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.blue.shade700.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.menu_book_rounded,
              color: Colors.blue.shade300,
              size: 20,
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
                      color: Colors.blue.shade200,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Toque para ler o texto completo',
                    style: TextStyle(
                      color: Colors.white60,
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

/// Variante compacta do botão (apenas referência clicável, sem caixa)
class BibleReferenceLink extends StatelessWidget {
  final String reference;
  
  const BibleReferenceLink({
    super.key,
    required this.reference,
  });

  String _buildJWUrl() {
    final query = Uri.encodeComponent(reference.trim());
    return 'https://www.jw.org/pt/biblioteca-biblica/biblia/busca/?q=$query';
  }

  Future<void> _openReference(BuildContext context) async {
    final url = _buildJWUrl();
    final uri = Uri.parse(url);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Não foi possível abrir a referência.'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openReference(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.book, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Text(
            reference,
            style: TextStyle(
              color: Colors.blue.shade300,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.open_in_new,
            color: Colors.white54,
            size: 14,
          ),
        ],
      ),
    );
  }
}
