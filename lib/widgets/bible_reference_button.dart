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
  /// Formato: https://www.jw.org/pt/biblioteca-biblica/biblia/nwt/livros/Genesis/6/
  String _buildJWUrl() {
    final cleanRef = reference.trim();
    
    // Mapeamento de nomes de livros para o formato JW.org
    final Map<String, String> bookMap = {
      'gênesis': 'Genesis', 'genesis': 'Genesis',
      'êxodo': 'Exodus', 'exodo': 'Exodus',
      'levítico': 'Leviticus', 'levitico': 'Leviticus',
      'números': 'Numbers', 'numeros': 'Numbers',
      'deuteronômio': 'Deuteronomy', 'deuteronomio': 'Deuteronomy',
      'josué': 'Joshua', 'josue': 'Joshua',
      'juízes': 'Judges', 'juizes': 'Judges',
      'rute': 'Ruth',
      '1 samuel': '1-Samuel', 'i samuel': '1-Samuel',
      '2 samuel': '2-Samuel', 'ii samuel': '2-Samuel',
      '1 reis': '1-Kings', 'i reis': '1-Kings',
      '2 reis': '2-Kings', 'ii reis': '2-Kings',
      '1 crônicas': '1-Chronicles', '1 cronicas': '1-Chronicles',
      '2 crônicas': '2-Chronicles', '2 cronicas': '2-Chronicles',
      'esdras': 'Ezra',
      'neemias': 'Nehemiah',
      'ester': 'Esther',
      'jó': 'Job', 'jo': 'Job',
      'salmos': 'Psalms', 'salmo': 'Psalms',
      'provérbios': 'Proverbs', 'proverbios': 'Proverbs',
      'eclesiastes': 'Ecclesiastes',
      'cântico dos cânticos': 'Song-of-Solomon', 'cantico': 'Song-of-Solomon',
      'isaías': 'Isaiah', 'isaias': 'Isaiah',
      'jeremias': 'Jeremiah',
      'lamentações': 'Lamentations', 'lamentacoes': 'Lamentations',
      'ezequiel': 'Ezekiel',
      'daniel': 'Daniel',
      'oséias': 'Hosea', 'oseias': 'Hosea',
      'joel': 'Joel',
      'amós': 'Amos', 'amos': 'Amos',
      'obadias': 'Obadiah',
      'jonas': 'Jonah',
      'miquéias': 'Micah', 'miqueias': 'Micah',
      'naum': 'Nahum',
      'habacuque': 'Habakkuk',
      'sofonias': 'Zephaniah',
      'ageu': 'Haggai',
      'zacarias': 'Zechariah',
      'malaquias': 'Malachi',
      'mateus': 'Matthew',
      'marcos': 'Mark',
      'lucas': 'Luke',
      'joão': 'John', 'joao': 'John',
      'atos': 'Acts',
      'romanos': 'Romans',
      '1 coríntios': '1-Corinthians', '1 corintios': '1-Corinthians',
      '2 coríntios': '2-Corinthians', '2 corintios': '2-Corinthians',
      'gálatas': 'Galatians', 'galatas': 'Galatians',
      'efésios': 'Ephesians', 'efesios': 'Ephesians',
      'filipenses': 'Philippians',
      'colossenses': 'Colossians',
      '1 tessalonicenses': '1-Thessalonians',
      '2 tessalonicenses': '2-Thessalonians',
      '1 timóteo': '1-Timothy', '1 timoteo': '1-Timothy',
      '2 timóteo': '2-Timothy', '2 timoteo': '2-Timothy',
      'tito': 'Titus',
      'filemom': 'Philemon', 'filemon': 'Philemon',
      'hebreus': 'Hebrews',
      'tiago': 'James',
      '1 pedro': '1-Peter',
      '2 pedro': '2-Peter',
      '1 joão': '1-John', '1 joao': '1-John',
      '2 joão': '2-John', '2 joao': '2-John',
      '3 joão': '3-John', '3 joao': '3-John',
      'judas': 'Jude',
      'apocalipse': 'Revelation', 'revelação': 'Revelation',
    };
    
    try {
      // Regex para capturar: "Livro capítulo:versículo(s)"
      final regex = RegExp(r'^([0-9\s]*[^\d:]+)\s*(\d+):(\d+)(?:-(\d+))?', caseSensitive: false);
      final match = regex.firstMatch(cleanRef);
      
      if (match != null) {
        final bookName = match.group(1)!.trim().toLowerCase();
        final chapter = match.group(2)!;
        final verse = match.group(3)!;
        // verseEnd (match.group(4)) poderia ser usado para intervalos no futuro
        
        final jwBook = bookMap[bookName];
        if (jwBook != null) {
          // URL direta para o capítulo com âncora no versículo
          return 'https://www.jw.org/pt/biblioteca-biblica/biblia/nwt/livros/$jwBook/$chapter/#v$chapter:$verse';
        }
      }
    } catch (e) {
      // Se parsing falhar, usa busca genérica
    }
    
    // Fallback: busca genérica
    final query = Uri.encodeComponent(cleanRef);
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
