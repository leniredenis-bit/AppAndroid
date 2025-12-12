import 'package:crisp_chat/crisp_chat.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'firebase_service.dart';
import 'language_service.dart';

/// Serviço singleton para Chat de Suporte (Crisp)
/// 
/// Responsável por:
/// - Inicializar o SDK do Crisp
/// - Enviar contexto do usuário/dispositivo
/// - Abrir o chat de suporte
class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  // ✅ Website ID do Crisp configurado
  static const String _websiteId = 'b4dfbc25-cbae-48cc-a9fb-67047334ae2e';
  
  bool _isInitialized = false;
  CrispConfig? _config;
  PackageInfo? _packageInfo;
  
  /// Verifica se o chat está inicializado
  bool get isInitialized => _isInitialized;

  /// Inicializa o serviço de Chat
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('💬 ChatService: Já inicializado');
      return;
    }

    // Verificar se temos um Website ID válido
    if (_websiteId == 'SEU_WEBSITE_ID_AQUI' || _websiteId.isEmpty) {
      debugPrint('⚠️ ChatService: Website ID não configurado!');
      debugPrint('   Configure o _websiteId em chat_service.dart');
      return;
    }

    try {
      // Obter informações do pacote
      _packageInfo = await PackageInfo.fromPlatform();
      
      // Criar a configuração do Crisp
      _config = CrispConfig(
        websiteID: _websiteId,
        enableNotifications: true,
      );
      
      _isInitialized = true;
      debugPrint('✅ ChatService: Inicializado com sucesso!');
    } catch (e) {
      debugPrint('❌ ChatService: Erro na inicialização: $e');
    }
  }

  /// Define o usuário do chat
  Future<void> setUser({
    String? email,
    String? nickname,
    String? phone,
    String? avatar,
  }) async {
    if (!_isInitialized || _config == null) return;
    
    try {
      _config = CrispConfig(
        websiteID: _websiteId,
        enableNotifications: true,
        user: User(
          email: email,
          nickName: nickname,
          phone: phone,
          avatar: avatar,
        ),
      );
      debugPrint('💬 ChatService: Usuário configurado');
    } catch (e) {
      debugPrint('❌ ChatService: Erro ao configurar usuário: $e');
    }
  }

  /// Abre o chat de suporte com contexto
  Future<void> openSupportChat({
    String? currentScreen,
    String? currentGame,
    Map<String, String>? extraData,
  }) async {
    if (!_isInitialized || _config == null) {
      debugPrint('⚠️ ChatService: Não inicializado, não é possível abrir chat');
      return;
    }

    try {
      // Abrir o chat
      await FlutterCrispChat.openCrispChat(config: _config!);
      
      // Enviar dados de contexto após abrir
      await _sendContextData(
        currentScreen: currentScreen,
        currentGame: currentGame,
        extraData: extraData,
      );
      
      debugPrint('💬 ChatService: Chat aberto');
    } catch (e) {
      debugPrint('❌ ChatService: Erro ao abrir chat: $e');
    }
  }

  /// Envia dados de contexto para o chat
  Future<void> _sendContextData({
    String? currentScreen,
    String? currentGame,
    Map<String, String>? extraData,
  }) async {
    try {
      // Informações do App
      if (_packageInfo != null) {
        FlutterCrispChat.setSessionString(key: 'app_version', value: _packageInfo!.version);
        FlutterCrispChat.setSessionString(key: 'app_build', value: _packageInfo!.buildNumber);
        FlutterCrispChat.setSessionString(key: 'app_name', value: _packageInfo!.appName);
      }

      // Informações do dispositivo
      final deviceInfo = await _getDeviceInfo();
      for (final entry in deviceInfo.entries) {
        FlutterCrispChat.setSessionString(key: entry.key, value: entry.value);
      }

      // Idioma do usuário
      FlutterCrispChat.setSessionString(key: 'user_language', value: LanguageService().currentLanguageCode);

      // Firebase disponível?
      FlutterCrispChat.setSessionString(key: 'firebase_enabled', value: FirebaseService().isInitialized.toString());

      // Contexto atual
      if (currentScreen != null) {
        FlutterCrispChat.setSessionString(key: 'current_screen', value: currentScreen);
      }
      if (currentGame != null) {
        FlutterCrispChat.setSessionString(key: 'current_game', value: currentGame);
      }

      // Dados extras
      if (extraData != null) {
        for (final entry in extraData.entries) {
          FlutterCrispChat.setSessionString(key: entry.key, value: entry.value);
        }
      }

      debugPrint('💬 ChatService: Contexto enviado');
    } catch (e) {
      debugPrint('❌ ChatService: Erro ao enviar contexto: $e');
    }
  }

  /// Obtém informações do dispositivo
  Future<Map<String, String>> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final info = <String, String>{};

    try {
      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        info['platform'] = 'Web';
        info['browser'] = webInfo.browserName.name;
        info['user_agent'] = webInfo.userAgent ?? 'Unknown';
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        info['platform'] = 'Android';
        info['device_model'] = androidInfo.model;
        info['device_brand'] = androidInfo.brand;
        info['android_version'] = androidInfo.version.release;
        info['sdk_version'] = androidInfo.version.sdkInt.toString();
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        info['platform'] = 'iOS';
        info['device_model'] = iosInfo.model;
        info['device_name'] = iosInfo.name;
        info['ios_version'] = iosInfo.systemVersion;
      }
    } catch (e) {
      debugPrint('❌ ChatService: Erro ao obter info do dispositivo: $e');
      info['platform'] = 'Unknown';
    }

    return info;
  }

  /// Reseta o chat (logout)
  Future<void> reset() async {
    if (!_isInitialized) return;
    
    try {
      await FlutterCrispChat.resetCrispChatSession();
      debugPrint('💬 ChatService: Sessão resetada');
    } catch (e) {
      debugPrint('❌ ChatService: Erro ao resetar: $e');
    }
  }
}
