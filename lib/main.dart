import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'services/multiplayer/mock_multiplayer_service.dart';
import 'services/audio_service.dart';
import 'services/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
          // Key para forçar rebuild quando idioma mudar
          key: ValueKey(LanguageService().currentLanguageCode),
          title: 'JW SPLASH GAMES',
          debugShowCheckedModeBanner: false,
          
          // Suporte a internacionalização
          locale: LanguageService().currentLocale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: LanguageService.supportedLocales,
          
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
