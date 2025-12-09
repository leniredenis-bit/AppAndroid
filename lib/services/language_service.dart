import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../services/storage_service.dart';
import '../models/quiz_service.dart'; // Para limpar cache de perguntas

/// Serviço para gerenciamento de idioma do aplicativo
class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  final StorageService _storage = StorageService();
  Locale _currentLocale = const Locale('pt', ''); // Será sobrescrito na inicialização

  /// Idiomas suportados
  static const List<Locale> supportedLocales = [
    Locale('pt', ''), // Português
    Locale('en', ''), // English
    Locale('es', ''), // Español
  ];

  /// Idiomas com informações de exibição
  static const Map<String, Map<String, String>> languageInfo = {
    'pt': {'name': 'Português', 'flag': '🇧🇷'},
    'en': {'name': 'English', 'flag': '🇺🇸'},
    'es': {'name': 'Español', 'flag': '🇪🇸'},
  };

  /// Obter locale atual
  Locale get currentLocale => _currentLocale;

  /// Obter código do idioma atual (pt, en, es)
  String get currentLanguageCode => _currentLocale.languageCode;

  /// Obter nome do idioma atual
  String get currentLanguageName => languageInfo[currentLanguageCode]?['name'] ?? 'Português';

  /// Obter bandeira do idioma atual
  String get currentLanguageFlag => languageInfo[currentLanguageCode]?['flag'] ?? '🇧🇷';

  /// Inicializar idioma salvo ou detectar do dispositivo
  Future<void> initialize() async {
    try {
      final prefs = await _storage.getPreferences();
      final savedLanguage = prefs.language;
      
      if (savedLanguage.isNotEmpty) {
        // Usuário já escolheu um idioma antes
        final locale = Locale(savedLanguage, '');
        if (supportedLocales.contains(locale)) {
          _currentLocale = locale;
          debugPrint('🌍 Idioma carregado das preferências: $savedLanguage');
          notifyListeners();
          return;
        }
      }
      
      // Primeira vez: detectar idioma do dispositivo
      final deviceLocale = ui.PlatformDispatcher.instance.locale;
      final deviceLanguage = deviceLocale.languageCode;
      
      if (languageInfo.containsKey(deviceLanguage)) {
        // Idioma do dispositivo é suportado
        _currentLocale = Locale(deviceLanguage, '');
        debugPrint('🌍 Idioma detectado do dispositivo: $deviceLanguage');
      } else {
        // Idioma não suportado, usar inglês como fallback global
        _currentLocale = const Locale('en', '');
        debugPrint('🌍 Idioma do dispositivo ($deviceLanguage) não suportado, usando inglês');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar idioma: $e');
      // Manter idioma padrão (pt)
    }
  }

  /// Mudar idioma
  Future<void> changeLanguage(String languageCode) async {
    if (!languageInfo.containsKey(languageCode)) {
      debugPrint('Idioma não suportado: $languageCode');
      return;
    }

    final newLocale = Locale(languageCode, '');
    if (_currentLocale == newLocale) {
      return; // Já está no idioma selecionado
    }

    _currentLocale = newLocale;
    
    // Limpar cache de perguntas para recarregar no novo idioma
    QuizService.clearCache();
    debugPrint('✅ Idioma alterado para $languageCode - Cache de perguntas limpo');
    
    // Salvar preferência
    try {
      final prefs = await _storage.getPreferences();
      final updatedPrefs = prefs.copyWith(language: languageCode);
      await _storage.savePreferences(updatedPrefs);
    } catch (e) {
      debugPrint('Erro ao salvar idioma: $e');
    }

    notifyListeners();
  }

  /// Verificar se um idioma é suportado
  bool isLanguageSupported(String languageCode) {
    return languageInfo.containsKey(languageCode);
  }

  /// Obter lista de idiomas disponíveis
  List<Map<String, String>> getAvailableLanguages() {
    return languageInfo.entries.map((entry) {
      return {
        'code': entry.key,
        'name': entry.value['name']!,
        'flag': entry.value['flag']!,
      };
    }).toList();
  }
}
