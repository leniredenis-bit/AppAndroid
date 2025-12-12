import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'firebase_service.dart';

/// Serviço singleton para Firebase Crashlytics
/// 
/// Responsável por:
/// - Capturar crashes e erros não-fatais
/// - Adicionar logs contextuais
/// - Definir chaves personalizadas
/// - Identificar usuários
class CrashlyticsService {
  static final CrashlyticsService _instance = CrashlyticsService._internal();
  factory CrashlyticsService() => _instance;
  CrashlyticsService._internal();

  FirebaseCrashlytics? _crashlytics;
  bool _isEnabled = true;

  /// Verifica se o Crashlytics está habilitado
  bool get isEnabled => _isEnabled && FirebaseService().isInitialized;

  /// Inicializa o serviço de Crashlytics
  Future<void> initialize() async {
    if (!FirebaseService().isInitialized) {
      debugPrint('🔥 CrashlyticsService: Firebase não inicializado, pulando...');
      return;
    }

    try {
      _crashlytics = FirebaseCrashlytics.instance;
      
      // Habilitar coleta de relatórios de crash
      await _crashlytics!.setCrashlyticsCollectionEnabled(true);
      
      debugPrint('✅ CrashlyticsService: Inicializado com sucesso!');
    } catch (e) {
      debugPrint('❌ CrashlyticsService: Erro na inicialização: $e');
      _isEnabled = false;
    }
  }

  /// Configura a captura global de erros do Flutter
  /// Deve ser chamado no main() antes de runApp()
  void setupGlobalErrorHandling() {
    if (!isEnabled || _crashlytics == null) return;

    // Captura erros do Flutter Framework
    FlutterError.onError = (FlutterErrorDetails details) {
      debugPrint('🔥 CrashlyticsService: Flutter error capturado');
      _crashlytics!.recordFlutterFatalError(details);
    };

    // Captura erros assíncronos não tratados
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('🔥 CrashlyticsService: Platform error capturado');
      _crashlytics!.recordError(error, stack, fatal: true);
      return true;
    };

    debugPrint('✅ CrashlyticsService: Captura global configurada');
  }

  /// Habilita ou desabilita a coleta de crashes
  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    if (_crashlytics != null) {
      await _crashlytics!.setCrashlyticsCollectionEnabled(enabled);
    }
    debugPrint('🔥 CrashlyticsService: Coleta ${enabled ? "habilitada" : "desabilitada"}');
  }

  /// Define o ID do usuário para associar crashes
  Future<void> setUserId(String userId) async {
    if (!isEnabled || _crashlytics == null) return;
    
    try {
      await _crashlytics!.setUserIdentifier(userId);
      debugPrint('🔥 CrashlyticsService: UserId definido: $userId');
    } catch (e) {
      debugPrint('❌ CrashlyticsService: Erro ao definir userId: $e');
    }
  }

  // ============================================
  // LOGS CONTEXTUAIS
  // ============================================

  /// Adiciona um log que será incluído no próximo relatório de crash
  void log(String message) {
    if (!isEnabled || _crashlytics == null) return;
    
    _crashlytics!.log(message);
    debugPrint('🔥 CrashlyticsService: Log - $message');
  }

  /// Adiciona múltiplos logs de uma vez
  void logMultiple(List<String> messages) {
    for (final message in messages) {
      log(message);
    }
  }

  // ============================================
  // CHAVES PERSONALIZADAS
  // ============================================

  /// Define uma chave personalizada (string)
  Future<void> setCustomKey(String key, String value) async {
    if (!isEnabled || _crashlytics == null) return;
    
    try {
      await _crashlytics!.setCustomKey(key, value);
      debugPrint('🔥 CrashlyticsService: Key "$key" = "$value"');
    } catch (e) {
      debugPrint('❌ CrashlyticsService: Erro ao definir key "$key": $e');
    }
  }

  /// Define uma chave personalizada (int)
  Future<void> setCustomKeyInt(String key, int value) async {
    if (!isEnabled || _crashlytics == null) return;
    
    try {
      await _crashlytics!.setCustomKey(key, value);
      debugPrint('🔥 CrashlyticsService: Key "$key" = $value');
    } catch (e) {
      debugPrint('❌ CrashlyticsService: Erro ao definir key "$key": $e');
    }
  }

  /// Define uma chave personalizada (bool)
  Future<void> setCustomKeyBool(String key, bool value) async {
    if (!isEnabled || _crashlytics == null) return;
    
    try {
      await _crashlytics!.setCustomKey(key, value);
      debugPrint('🔥 CrashlyticsService: Key "$key" = $value');
    } catch (e) {
      debugPrint('❌ CrashlyticsService: Erro ao definir key "$key": $e');
    }
  }

  // ============================================
  // CONTEXTO DE JOGO
  // ============================================

  /// Atualiza o contexto da tela atual
  Future<void> setCurrentScreen(String screenName) async {
    await setCustomKey('current_screen', screenName);
    log('Navegou para: $screenName');
  }

  /// Atualiza o contexto do jogo atual
  Future<void> setCurrentGame(String? gameName) async {
    await setCustomKey('current_game', gameName ?? 'none');
  }

  /// Atualiza a última ação do usuário
  Future<void> setLastAction(String action) async {
    await setCustomKey('last_action', action);
    log('Ação: $action');
  }

  /// Define o idioma do usuário
  Future<void> setUserLanguage(String languageCode) async {
    await setCustomKey('user_language', languageCode);
  }

  /// Define informações de contexto do jogo
  Future<void> setGameContext({
    String? gameName,
    int? level,
    int? score,
    String? difficulty,
  }) async {
    if (gameName != null) await setCustomKey('game_name', gameName);
    if (level != null) await setCustomKeyInt('game_level', level);
    if (score != null) await setCustomKeyInt('game_score', score);
    if (difficulty != null) await setCustomKey('game_difficulty', difficulty);
  }

  // ============================================
  // REGISTRO DE ERROS
  // ============================================

  /// Registra um erro não-fatal
  Future<void> recordError(
    dynamic exception, {
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
  }) async {
    if (!isEnabled || _crashlytics == null) return;
    
    try {
      if (reason != null) {
        log('Erro: $reason');
      }
      
      await _crashlytics!.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
      
      debugPrint('🔥 CrashlyticsService: Erro registrado - $exception');
    } catch (e) {
      debugPrint('❌ CrashlyticsService: Erro ao registrar erro: $e');
    }
  }

  /// Registra um erro com contexto adicional
  Future<void> recordErrorWithContext(
    dynamic exception, {
    StackTrace? stackTrace,
    required String context,
    Map<String, String>? extraInfo,
  }) async {
    // Adicionar contexto como log
    log('Contexto do erro: $context');
    
    // Adicionar informações extras
    if (extraInfo != null) {
      for (final entry in extraInfo.entries) {
        await setCustomKey('error_${entry.key}', entry.value);
      }
    }
    
    // Registrar o erro
    await recordError(exception, stackTrace: stackTrace, reason: context);
  }

  // ============================================
  // TESTE
  // ============================================

  /// Força um crash para testar (APENAS PARA DESENVOLVIMENTO)
  void testCrash() {
    if (!isEnabled || _crashlytics == null) return;
    
    debugPrint('🔥 CrashlyticsService: Forçando crash de teste...');
    _crashlytics!.crash();
  }
}
