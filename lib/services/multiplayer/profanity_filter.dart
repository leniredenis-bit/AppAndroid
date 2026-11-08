import 'dart:math';
import '../../utils/i18n.dart';

/// Serviço para validar apelidos e filtrar palavras ofensivas
class ProfanityFilter {
  // Lista de palavras proibidas (expandir conforme necessário)
  static final List<String> _bannedWords = [
    // Palavrões comuns
    'idiota', 'burro', 'estupido', 'imbecil', 'otario', 'babaca',
    'fdp', 'porra', 'merda', 'bosta', 'corno', 'viado',
    'piranha', 'vagabundo', 'lixo', 'desgraça', 'inferno',
    
    // Variações
    'idiot', 'stupid', 'fool', 'dumb', 'moron',
    
    // Termos ofensivos religiosos
    'demonio', 'satanas', 'diabo', 'infernal',
    
    // Adicionar mais conforme necessário
  ];

  // Sugestões de apelidos alternativos
  static final List<String> _suggestedNicknames = [
    'Discípulo', 'Pescador', 'Benção', 'Fiel', 'Servo',
    'Amigo', 'Irmão', 'Pregador', 'Zeloso', 'Devoto',
    'Adorador', 'Crente', 'Santo', 'Justo', 'Piedoso',
    'Obreiro', 'Pastor', 'Mestre', 'Doutor', 'Sábio',
  ];

  // Emojis para complementar apelidos
  static final List<String> _emojiSuffixes = [
    '✨', '🙏', '⭐', '🌟', '💫', '✝️', '📖', '🕊️', '🎯', '💪',
  ];

  /// Valida se o apelido contém palavras proibidas
  static bool containsProfanity(String nickname) {
    final normalizedNickname = _normalize(nickname);
    
    for (final word in _bannedWords) {
      if (normalizedNickname.contains(_normalize(word))) {
        return true;
      }
    }
    
    return false;
  }

  /// Gera um apelido alternativo aleatório
  static String generateAlternativeNickname() {
    final random = Random();
    final baseName = _suggestedNicknames[random.nextInt(_suggestedNicknames.length)];
    final number = random.nextInt(9999) + 1;
    final emoji = _emojiSuffixes[random.nextInt(_emojiSuffixes.length)];
    
    // Formatos variados
    final formats = [
      '$baseName$number',
      '$baseName$emoji',
      '$baseName$number$emoji',
      '${baseName}Feliz$number',
      '$emoji$baseName$number',
    ];
    
    return formats[random.nextInt(formats.length)];
  }

  /// Valida e retorna um apelido válido
  /// Se contém palavrão, retorna uma sugestão alternativa
  static ValidationResult validateNickname(String nickname) {
    // Validar tamanho
    if (nickname.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: t3('O apelido não pode estar vazio', 'The nickname cannot be empty', 'El apodo no puede estar vacío'),
        suggestedNickname: generateAlternativeNickname(),
      );
    }

    if (nickname.trim().length < 3) {
      return ValidationResult(
        isValid: false,
        message: t3('O apelido deve ter pelo menos 3 caracteres', 'The nickname must have at least 3 characters', 'El apodo debe tener al menos 3 caracteres'),
        suggestedNickname: null,
      );
    }

    if (nickname.trim().length > 20) {
      return ValidationResult(
        isValid: false,
        message: t3('O apelido deve ter no máximo 20 caracteres', 'The nickname must have at most 20 characters', 'El apodo debe tener como máximo 20 caracteres'),
        suggestedNickname: null,
      );
    }

    // Validar palavras proibidas
    if (containsProfanity(nickname)) {
      return ValidationResult(
        isValid: false,
        message: t3('Este apelido contém palavras não permitidas', 'This nickname contains words that are not allowed', 'Este apodo contiene palabras no permitidas'),
        suggestedNickname: generateAlternativeNickname(),
      );
    }

    // Apelido válido
    return ValidationResult(
      isValid: true,
      message: t3('Apelido válido!', 'Valid nickname!', '¡Apodo válido!'),
      suggestedNickname: null,
    );
  }

  /// Normaliza texto para comparação (remove acentos, lowercase, etc)
  static String _normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[áàâã]'), 'a')
        .replaceAll(RegExp(r'[éèê]'), 'e')
        .replaceAll(RegExp(r'[íì]'), 'i')
        .replaceAll(RegExp(r'[óòôõ]'), 'o')
        .replaceAll(RegExp(r'[úù]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[^a-z0-9]'), ''); // Remove caracteres especiais
  }

  /// Gera uma lista de sugestões de apelidos
  static List<String> generateSuggestions({int count = 3}) {
    final suggestions = <String>[];
    for (int i = 0; i < count; i++) {
      suggestions.add(generateAlternativeNickname());
    }
    return suggestions;
  }
}

/// Resultado da validação de apelido
class ValidationResult {
  final bool isValid;
  final String message;
  final String? suggestedNickname;

  ValidationResult({
    required this.isValid,
    required this.message,
    this.suggestedNickname,
  });
}
