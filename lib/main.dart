import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'services/multiplayer/mock_multiplayer_service.dart';
import 'services/audio_service.dart';
import 'services/language_service.dart';
import 'services/firebase_service.dart';
import 'services/analytics_service.dart';
import 'services/crashlytics_service.dart';
import 'l10n/app_localizations.dart';
import 'services/app_lifecycle.dart';
import 'theme/app_theme.dart';

void main() async {
  // Captura erros assíncronos não tratados
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // ============================================================
    // INICIALIZAÇÃO DO FIREBASE
    // ============================================================
    final firebaseInitialized = await FirebaseService().initialize();
    
    if (firebaseInitialized) {
      // Inicializar Analytics
      await AnalyticsService().initialize();
      
      // Inicializar Crashlytics e configurar captura global de erros
      await CrashlyticsService().initialize();
      CrashlyticsService().setupGlobalErrorHandling();
      
      // Definir idioma do usuário no Crashlytics
      final languageCode = LanguageService().currentLanguageCode;
      await CrashlyticsService().setUserLanguage(languageCode);
      
      debugPrint('✅ Firebase, Analytics e Crashlytics inicializados!');
    } else {
      debugPrint('⚠️ Firebase não disponível, usando modo offline/mock');
    }
    
    // Inicializar serviço multiplayer (mock por enquanto)
    MockMultiplayerService.initialize();
    
    // Inicializar serviço de áudio
    await AudioService().initialize();
    
    // Inicializar idioma salvo
    await LanguageService().initialize();

    // Tema, tamanho do texto e vibração salvos
    await ThemeService().initialize();

    // Pausa música/cronômetros quando o app vai para segundo plano
    AppLifecycle().attach();

    // Boas-vindas só na primeira abertura
    final prefs = await SharedPreferences.getInstance();
    final firstRun = !(prefs.getBool('seenWelcome') ?? false);

    runApp(MyApp(firstRun: firstRun));
  }, (error, stackTrace) {
    // Registrar erros assíncronos não capturados
    debugPrint('❌ Erro não capturado: $error');
    CrashlyticsService().recordError(
      error,
      stackTrace: stackTrace,
      reason: 'Erro assíncrono não capturado',
      fatal: true,
    );
  });
}

class MyApp extends StatelessWidget {
  final bool firstRun;
  const MyApp({super.key, this.firstRun = true});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([LanguageService(), ThemeService()]),
      builder: (context, child) {
        final themeService = ThemeService();
        return MaterialApp(
          title: 'JW SPLASH GAMES',
          debugShowCheckedModeBanner: false,
          // Permite arrastar listas com mouse/trackpad (web e desktop), como no toque
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: PointerDeviceKind.values.toSet(),
          ),

          // Suporte a internacionalização
          locale: LanguageService().currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,

          // Tema claro/escuro (Configurações) e texto maior (acessibilidade)
          theme: buildAppTheme(AppPalette.light),
          darkTheme: buildAppTheme(AppPalette.dark),
          themeMode: themeService.isDark ? ThemeMode.dark : ThemeMode.light,
          builder: (context, child) {
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(textScaler: TextScaler.linear(mq.textScaler.scale(1) * themeService.textScale)),
              child: child!,
            );
          },
          initialRoute: firstRun ? '/' : '/home',
          routes: {
            '/': (context) => const WelcomeScreen(),
            '/home': (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}
