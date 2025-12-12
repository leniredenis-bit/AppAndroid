import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'services/multiplayer/mock_multiplayer_service.dart';
import 'services/audio_service.dart';
import 'services/language_service.dart';
import 'services/firebase_service.dart';
import 'services/analytics_service.dart';
import 'services/crashlytics_service.dart';
import 'l10n/app_localizations.dart';

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
    
    runApp(const MyApp());
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: LanguageService(),
      builder: (context, child) {
        return MaterialApp(
          title: 'JW SPLASH GAMES',
          debugShowCheckedModeBanner: false,
          
          // Suporte a internacionalização
          locale: LanguageService().currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            // Configura fonte padrão com suporte a emojis
            textTheme: GoogleFonts.robotoTextTheme(
              Theme.of(context).textTheme,
            ).apply(
              fontFamily: 'Roboto',
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const WelcomeScreen(),
            '/home': (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}
