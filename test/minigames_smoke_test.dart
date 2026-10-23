import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jw_splash_games/l10n/app_localizations.dart';
import 'package:jw_splash_games/screens/memory_game_screen.dart';
import 'package:jw_splash_games/screens/minigames/coloring_game.dart';
import 'package:jw_splash_games/screens/minigames/hangman_game.dart';
import 'package:jw_splash_games/screens/minigames/jigsaw_puzzle_game.dart';
import 'package:jw_splash_games/screens/minigames/maze_game.dart';
import 'package:jw_splash_games/screens/minigames/sequence_crystal_game.dart';
import 'package:jw_splash_games/screens/minigames/tic_tac_toe_neon.dart';
import 'package:jw_splash_games/screens/minigames/word_search_enhanced.dart';
import 'package:jw_splash_games/screens/minigames_menu_screen.dart';

Widget _app(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('pt'),
      home: child,
    );

/// Abre cada minigame num celular simulado e garante que não há exceções
/// nem estouro de layout na tela inicial e no início da partida.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    for (final ch in ['xyz.luan/audioplayers', 'xyz.luan/audioplayers.global', 'plugins.flutter.io/path_provider']) {
      messenger.setMockMethodCallHandler(MethodChannel(ch), (call) async => null);
    }
  });

  setUp(() {
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(1080, 1920);
    view.devicePixelRatio = 3.0;
  });

  Future<void> open(WidgetTester tester, Widget game, {String? startLabel}) async {
    // Ruído do plugin de áudio (não existe em testes) é ignorado
    final errors = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = (d) {
      if (d.exception is! MissingPluginException) errors.add(d);
    };
    await tester.pumpWidget(_app(game));
    await tester.pump(const Duration(milliseconds: 600));
    if (startLabel != null && find.text(startLabel).evaluate().isNotEmpty) {
      await tester.tap(find.text(startLabel).first);
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 600));
    }
    FlutterError.onError = previous;
    expect(errors, isEmpty, reason: errors.map((e) => e.exceptionAsString()).join('\n'));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 6));
  }

  testWidgets('menu', (t) => open(t, const MinigamesMenuScreen()));
  testWidgets('memória', (t) => open(t, const MemoryGameScreen(), startLabel: 'Começar'));
  testWidgets('jogo da velha', (t) => open(t, const TicTacToeGame()));
  testWidgets('forca', (t) => open(t, const HangmanGame()));
  testWidgets('caça-palavras', (t) => open(t, const WordSearchGame(), startLabel: 'Começar'));
  testWidgets('labirinto', (t) => open(t, const MazeGame(), startLabel: '1'));
  testWidgets('sequência', (t) => open(t, const SequenceCrystalGame(), startLabel: 'Começar'));
  testWidgets('quebra-cabeça', (t) => open(t, const JigsawPuzzleGame()));
  testWidgets('colorir', (t) => open(t, const ColoringGame(), startLabel: 'Arca de Noé'));
}
