import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_core/firebase_core.dart'; // DESABILITADO PARA TESTE WEB
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'services/multiplayer/mock_multiplayer_service.dart';
import 'services/audio_service.dart';
import 'services/language_service.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ============================================================
  // FIREBASE DESABILITADO TEMPORARIAMENTE PARA TESTE NO NAVEGADOR
  // Ver docs/FIREBASE_BACKUP.md para restaurar
  // ============================================================
  // try {
  //   await Firebase.initializeApp();
  //   debugPrint('Firebase inicializado com sucesso!');
  // } catch (e) {
  //   debugPrint('Erro ao inicializar Firebase: $e');
  //   debugPrint('O app continuará usando o modo offline/mock.');
  // }
  debugPrint('Modo de teste: Firebase desabilitado, usando MockMultiplayerService');
  
  // Inicializar serviço multiplayer
  MockMultiplayerService.initialize();
  
  // Inicializar serviço de áudio
  await AudioService().initialize();
  
  // Inicializar idioma salvo
  await LanguageService().initialize();
  
  runApp(const MyApp());
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
