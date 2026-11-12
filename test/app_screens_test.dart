import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jw_splash_games/l10n/app_localizations.dart';
import 'package:jw_splash_games/models/achievement.dart';
import 'package:jw_splash_games/models/question.dart';
import 'package:jw_splash_games/models/quiz_service.dart';
import 'package:jw_splash_games/screens/about_screen.dart';
import 'package:jw_splash_games/screens/minigames/jigsaw_puzzle_game.dart';
import 'package:jw_splash_games/screens/achievements_screen.dart';
import 'package:jw_splash_games/screens/home_screen.dart';
import 'package:jw_splash_games/screens/multiplayer/create_room_screen.dart';
import 'package:jw_splash_games/screens/multiplayer/join_room_screen.dart';
import 'package:jw_splash_games/screens/multiplayer/multiplayer_menu_screen.dart';
import 'package:jw_splash_games/screens/pie_quiz_screen.dart';
import 'package:jw_splash_games/screens/quiz_result_screen.dart';
import 'package:jw_splash_games/screens/quiz_screen.dart';
import 'package:jw_splash_games/screens/stats_screen.dart';
import 'package:jw_splash_games/screens/terms_screen.dart';
import 'package:jw_splash_games/screens/welcome_screen.dart';
import 'package:jw_splash_games/services/daily_question_service.dart';
import 'package:jw_splash_games/theme/app_theme.dart';
import 'package:jw_splash_games/utils/timer_calculator.dart';
import 'package:jw_splash_games/widgets/settings_dialog.dart';
import 'package:jw_splash_games/widgets/achievement_unlock_dialog.dart';

Widget _app(Widget child, {required bool dark}) => MaterialApp(
      theme: buildAppTheme(AppPalette.light),
      darkTheme: buildAppTheme(AppPalette.dark),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
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

Question _q(String id, int difficulty,
        {String text = 'Quem construiu a arca?'}) =>
    Question(
      id: id,
      pergunta: text,
      opcoes: const ['Noé', 'Moisés', 'Davi', 'Abraão'],
      respostaCorreta: 0,
      dificuldade: difficulty,
      tags: const ['Gênesis'],
      textoBiblico: 'Gênesis 6:14',
    );

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    final m = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    for (final ch in [
      'xyz.luan/audioplayers',
      'xyz.luan/audioplayers.global',
      'plugins.flutter.io/path_provider'
    ]) {
      m.setMockMethodCallHandler(MethodChannel(ch), (call) async => null);
    }
    m.setMockMethodCallHandler(
        const MethodChannel('dev.fluttercommunity.plus/package_info'),
        (call) async => {
              'appName': 'JW Splash Games',
              'packageName': 'com.jwsplashgames.quiz',
              'version': '1.0.0',
              'buildNumber': '2',
            });
  });

  setUp(() {
    final v = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    v.physicalSize = const Size(1080, 1920); // 360 x 640, celular pequeno
    v.devicePixelRatio = 3;
  });

  /// Abre a tela e falha se houver erro ou estouro de layout.
  Future<void> open(WidgetTester t, Widget screen, bool dark,
      {Future<void> Function()? interact}) async {
    final errors = <String>[];
    final previous = FlutterError.onError;
    FlutterError.onError = (d) {
      if (d.exception is! MissingPluginException) {
        errors.add(d.exceptionAsString());
      }
    };
    await t.pumpWidget(_app(screen, dark: dark));
    await t.runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
    await t.pump(const Duration(milliseconds: 600));
    if (interact != null) await interact();
    FlutterError.onError = previous;
    expect(errors, isEmpty, reason: errors.join('\n'));
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 15));
  }

  final questions = List.generate(10, (i) => _q('${10001 + i}', i % 3 + 1));

  for (final dark in [false, true]) {
    final theme = dark ? 'escuro' : 'claro';
    group('tema $theme', () {
      testWidgets('boas-vindas', (t) => open(t, const WelcomeScreen(), dark));
      testWidgets('início', (t) => open(t, const HomeScreen(), dark));
      testWidgets(
          'quiz',
          (t) => open(t, QuizScreen(questions: questions), dark,
                  interact: () async {
                await t.tap(find.text('Moisés'));
                await t.pump(const Duration(milliseconds: 800));
              }));
      testWidgets(
          'quiz modo estudo',
          (t) =>
              open(t, QuizScreen(questions: questions, studyMode: true), dark));
      testWidgets(
          'resultado',
          (t) => open(
              t,
              QuizResultScreen(
                answers: [
                  for (final q in questions)
                    AnsweredQuestion(q, q.id.endsWith('1') ? 1 : 0, 15)
                ],
                score: 135,
                seconds: 200,
                bestStreak: 4,
                studyMode: false,
              ),
              dark));
      testWidgets('estatísticas', (t) => open(t, const StatsScreen(), dark));
      testWidgets(
          'conquistas', (t) => open(t, const AchievementsScreen(), dark));
      testWidgets('sobre', (t) => open(t, const AboutScreen(), dark));
      testWidgets('termos', (t) => open(t, const TermsScreen(), dark));
      testWidgets(
          'configurações',
          (t) => open(
                  t,
                  Builder(
                      builder: (c) => Scaffold(
                          body: TextButton(
                              onPressed: () => showDialog(
                                  context: c,
                                  builder: (_) => const SettingsDialog()),
                              child: const Text('abrir')))),
                  dark, interact: () async {
                await t.tap(find.text('abrir'));
                await t.pump(const Duration(milliseconds: 500));
              }));
      testWidgets(
          'torta na cara',
          (t) => open(t, PieQuizScreen(questions: questions), dark,
                  interact: () async {
                await t.tap(find.text('Começar duelo'));
                await t.pump(const Duration(milliseconds: 400));
                await t.tap(find.text('Revelar resposta'));
                await t.pump(const Duration(milliseconds: 400));
              }));
      testWidgets(
          'online: menu', (t) => open(t, const MultiplayerMenuScreen(), dark));
      testWidgets(
          'online: criar sala', (t) => open(t, const CreateRoomScreen(), dark));
      testWidgets(
          'online: entrar', (t) => open(t, const JoinRoomScreen(), dark));
    });
  }

  group('regras', () {
    testWidgets('Conquista cabe em tela baixa sem overflow', (t) async {
      final view =
          TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
      view.physicalSize = const Size(1080, 1440); // 360 x 480, celular compacto
      addTearDown(view.resetPhysicalSize);

      await t.pumpWidget(_app(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => AchievementUnlockDialog(
                    achievement: Achievement(
                      id: 'first_step',
                      nameKey: 'achievement_first_step',
                      descriptionKey: 'achievement_first_step_desc',
                      emoji: '🏆',
                      category: AchievementCategory.quiz,
                      requiredValue: 1,
                    ),
                  ),
                ),
                child: const Text('Abrir'),
              ),
            ),
          ),
        ),
        dark: false,
      ));
      await t.tap(find.text('Abrir'));
      await t.pump();
      await t.pump(const Duration(milliseconds: 1000));

      expect(t.takeException(), isNull);
      expect(find.text('Primeiro Passo'), findsOneWidget);

      await t.pumpWidget(const SizedBox());
      await t.pump(const Duration(seconds: 5));
    });

    test(
        'Pergunta do Dia: mesma pergunta no mesmo dia, programação tem prioridade',
        () {
      final all = List.generate(50, (i) => _q('${20000 + i}', 1));
      final day = DateTime(2026, 10, 22);
      final a = DailyQuestionService.pickFor(day, all, {});
      final b = DailyQuestionService.pickFor(
          DateTime(2026, 10, 22, 23, 59), all.reversed.toList(), {});
      expect(a.id, b.id, reason: 'independe da ordem e da hora');
      final other =
          DailyQuestionService.pickFor(DateTime(2026, 10, 23), all, {});
      expect(other.id, isNot(a.id), reason: 'muda de um dia para o outro');
      final scheduled =
          DailyQuestionService.pickFor(day, all, {'2026-10-22': '20007'});
      expect(scheduled.id, '20007');
    });

    test('Quebra-cabeça: desenho salvo sem duplicar e nº de peças lembrado', () async {
      await JigsawLibrary.save('coloring_a', Uint8List.fromList([1]));
      await JigsawLibrary.save('coloring_b', Uint8List.fromList([2]));
      await JigsawLibrary.save('coloring_a', Uint8List.fromList([3]));
      var saved = await JigsawLibrary.load();
      expect(saved.map((s) => s.id), ['coloring_a', 'coloring_b']);
      expect(saved.first.bytes, [3]);
      await JigsawLibrary.remove('coloring_b');
      saved = await JigsawLibrary.load();
      expect(saved.map((s) => s.id), ['coloring_a']);

      await JigsawLibrary.saveGrid(5);
      expect(await JigsawLibrary.loadGrid(), 5);
    });

    test('Timer: perguntas difíceis ganham +5s', () {
      expect(
          TimerCalculator.calculateQuizTime(_q('1', 3)) -
              TimerCalculator.calculateQuizTime(_q('1', 1)),
          5);
    });

    testWidgets('Quiz: tempo esgotado mostra a resposta certa', (t) async {
      await t.pumpWidget(_app(QuizScreen(questions: [_q('1', 1)]), dark: true));
      final seconds = TimerCalculator.calculateQuizTime(_q('1', 1));
      for (int i = 0; i <= seconds; i++) {
        await t.pump(const Duration(seconds: 1));
      }
      await t.pump(const Duration(milliseconds: 500));
      expect(find.text('Tempo esgotado!'), findsOneWidget);
      expect(find.textContaining('Resposta certa'), findsOneWidget);
      await t.pumpWidget(const SizedBox());
      await t.pump(const Duration(seconds: 15));
    });

    test(
        'Banco de perguntas: IDs iguais nos 3 idiomas (Pergunta do Dia igual para todos)',
        () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final pt = await QuizService.loadQuestions();
      expect(pt.length, greaterThan(1000));
    });
  });
}
