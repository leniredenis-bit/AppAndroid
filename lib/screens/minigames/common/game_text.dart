import '../../../services/language_service.dart';

/// Texto curto nos 3 idiomas do app, escolhido pelo idioma atual.
///
/// Usado nos minigames para textos de interface específicos de cada jogo,
/// mantendo PT/EN/ES lado a lado no ponto de uso.
String t3(String pt, String en, String es) {
  switch (LanguageService().currentLanguageCode) {
    case 'en':
      return en;
    case 'es':
      return es;
    default:
      return pt;
  }
}

/// Código do idioma atual ('pt', 'en' ou 'es').
String get gameLang => LanguageService().currentLanguageCode;

/// Remove acentos e cedilha, mantendo Ñ (letra própria do espanhol).
String stripAccents(String text) {
  const from = 'ÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇáàâãäéèêëíìîïóòôõöúùûüç';
  const to = 'AAAAAEEEEIIIIOOOOOUUUUCaaaaaeeeeiiiiooooouuuuc';
  final buffer = StringBuffer();
  for (final ch in text.split('')) {
    final i = from.indexOf(ch);
    buffer.write(i >= 0 ? to[i] : ch);
  }
  return buffer.toString();
}

/// mm:ss
String formatGameTime(int seconds) {
  final m = (seconds ~/ 60).toString().padLeft(2, '0');
  final s = (seconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}
