import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'JW SPLASH GAMES'**
  String get appTitle;

  /// No description provided for @loading.
  ///
  /// In pt, this message translates to:
  /// **'Carregando...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In pt, this message translates to:
  /// **'Erro'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In pt, this message translates to:
  /// **'Fechar'**
  String get close;

  /// No description provided for @back.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get back;

  /// No description provided for @next.
  ///
  /// In pt, this message translates to:
  /// **'Próxima'**
  String get next;

  /// No description provided for @start.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar'**
  String get start;

  /// No description provided for @restart.
  ///
  /// In pt, this message translates to:
  /// **'Reiniciar'**
  String get restart;

  /// No description provided for @continue_.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get continue_;

  /// No description provided for @score.
  ///
  /// In pt, this message translates to:
  /// **'Pontuação'**
  String get score;

  /// No description provided for @time.
  ///
  /// In pt, this message translates to:
  /// **'Tempo'**
  String get time;

  /// No description provided for @moves.
  ///
  /// In pt, this message translates to:
  /// **'Movimentos'**
  String get moves;

  /// No description provided for @attempts.
  ///
  /// In pt, this message translates to:
  /// **'Tentativas'**
  String get attempts;

  /// No description provided for @victory.
  ///
  /// In pt, this message translates to:
  /// **'Vitória!'**
  String get victory;

  /// No description provided for @defeat.
  ///
  /// In pt, this message translates to:
  /// **'Derrota'**
  String get defeat;

  /// No description provided for @tryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Tentar Novamente'**
  String get tryAgain;

  /// No description provided for @homeWelcome.
  ///
  /// In pt, this message translates to:
  /// **'Bem-vindo ao'**
  String get homeWelcome;

  /// No description provided for @homeSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Aprenda e divirta-se!'**
  String get homeSubtitle;

  /// No description provided for @homeDifficulty.
  ///
  /// In pt, this message translates to:
  /// **'Dificuldade'**
  String get homeDifficulty;

  /// No description provided for @homeCategories.
  ///
  /// In pt, this message translates to:
  /// **'Categorias'**
  String get homeCategories;

  /// No description provided for @homeShowMore.
  ///
  /// In pt, this message translates to:
  /// **'Ver mais ({count}+)'**
  String homeShowMore(int count);

  /// No description provided for @homeShowLess.
  ///
  /// In pt, this message translates to:
  /// **'Ver menos'**
  String get homeShowLess;

  /// No description provided for @homeNoQuestionsFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma pergunta encontrada com esses filtros!'**
  String get homeNoQuestionsFound;

  /// No description provided for @homeLoadingError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar perguntas: {error}'**
  String homeLoadingError(String error);

  /// No description provided for @homeLoadingCategoriesError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar categorias: {error}'**
  String homeLoadingCategoriesError(String error);

  /// No description provided for @homeThemeActivated.
  ///
  /// In pt, this message translates to:
  /// **'Tema {theme} ativado!'**
  String homeThemeActivated(String theme);

  /// No description provided for @homeThemeDark.
  ///
  /// In pt, this message translates to:
  /// **'escuro'**
  String get homeThemeDark;

  /// No description provided for @homeThemeLight.
  ///
  /// In pt, this message translates to:
  /// **'claro'**
  String get homeThemeLight;

  /// No description provided for @playQuiz.
  ///
  /// In pt, this message translates to:
  /// **'🎯 Jogar Quiz'**
  String get playQuiz;

  /// No description provided for @playMinigames.
  ///
  /// In pt, this message translates to:
  /// **'🎮 Minigames'**
  String get playMinigames;

  /// No description provided for @viewStats.
  ///
  /// In pt, this message translates to:
  /// **'📊 Estatísticas'**
  String get viewStats;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'⚙️ Configurações'**
  String get settings;

  /// No description provided for @about.
  ///
  /// In pt, this message translates to:
  /// **'ℹ️ Sobre'**
  String get about;

  /// No description provided for @quizModeSelection.
  ///
  /// In pt, this message translates to:
  /// **'Escolha o Modo'**
  String get quizModeSelection;

  /// No description provided for @quizModeNormal.
  ///
  /// In pt, this message translates to:
  /// **'Normal'**
  String get quizModeNormal;

  /// No description provided for @quizModeNormalDesc.
  ///
  /// In pt, this message translates to:
  /// **'Quiz padrão com timer'**
  String get quizModeNormalDesc;

  /// No description provided for @quizModeStudy.
  ///
  /// In pt, this message translates to:
  /// **'Estudo'**
  String get quizModeStudy;

  /// No description provided for @quizModeStudyDesc.
  ///
  /// In pt, this message translates to:
  /// **'Sem pressão de tempo'**
  String get quizModeStudyDesc;

  /// No description provided for @quizModeFast.
  ///
  /// In pt, this message translates to:
  /// **'Rápido'**
  String get quizModeFast;

  /// No description provided for @quizModeFastDesc.
  ///
  /// In pt, this message translates to:
  /// **'Desafio contra o relógio'**
  String get quizModeFastDesc;

  /// No description provided for @quizQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Pergunta'**
  String get quizQuestion;

  /// No description provided for @quizTitle.
  ///
  /// In pt, this message translates to:
  /// **'Quiz - {current}/{total}'**
  String quizTitle(int current, int total);

  /// No description provided for @quizExplanation.
  ///
  /// In pt, this message translates to:
  /// **'📖 Explicação'**
  String get quizExplanation;

  /// No description provided for @quizNextIn.
  ///
  /// In pt, this message translates to:
  /// **'Próxima pergunta em {seconds}s...'**
  String quizNextIn(int seconds);

  /// No description provided for @quizFinished.
  ///
  /// In pt, this message translates to:
  /// **'Quiz Finalizado!'**
  String get quizFinished;

  /// No description provided for @quizExcellent.
  ///
  /// In pt, this message translates to:
  /// **'Excelente!'**
  String get quizExcellent;

  /// No description provided for @quizVeryGood.
  ///
  /// In pt, this message translates to:
  /// **'Muito Bem!'**
  String get quizVeryGood;

  /// No description provided for @quizGoodJob.
  ///
  /// In pt, this message translates to:
  /// **'Bom Trabalho!'**
  String get quizGoodJob;

  /// No description provided for @quizKeepPracticing.
  ///
  /// In pt, this message translates to:
  /// **'Continue Praticando!'**
  String get quizKeepPracticing;

  /// No description provided for @quizCorrectAnswers.
  ///
  /// In pt, this message translates to:
  /// **'Acertos'**
  String get quizCorrectAnswers;

  /// No description provided for @quizAccuracy.
  ///
  /// In pt, this message translates to:
  /// **'Aproveitamento'**
  String get quizAccuracy;

  /// No description provided for @quizBackToMenu.
  ///
  /// In pt, this message translates to:
  /// **'Voltar ao Menu'**
  String get quizBackToMenu;

  /// No description provided for @quizDifficultyEasy.
  ///
  /// In pt, this message translates to:
  /// **'FÁCIL'**
  String get quizDifficultyEasy;

  /// No description provided for @quizDifficultyMedium.
  ///
  /// In pt, this message translates to:
  /// **'MÉDIO'**
  String get quizDifficultyMedium;

  /// No description provided for @quizDifficultyHard.
  ///
  /// In pt, this message translates to:
  /// **'DIFÍCIL'**
  String get quizDifficultyHard;

  /// No description provided for @minigamesTitle.
  ///
  /// In pt, this message translates to:
  /// **'🎮 Minigames Bíblicos'**
  String get minigamesTitle;

  /// No description provided for @minigamesPuzzle.
  ///
  /// In pt, this message translates to:
  /// **'🧩 Quebra-Cabeça'**
  String get minigamesPuzzle;

  /// No description provided for @minigamesPuzzleDesc.
  ///
  /// In pt, this message translates to:
  /// **'Monte o quebra-cabeça'**
  String get minigamesPuzzleDesc;

  /// No description provided for @minigamesHangman.
  ///
  /// In pt, this message translates to:
  /// **'🎯 Forca Bíblica'**
  String get minigamesHangman;

  /// No description provided for @minigamesHangmanDesc.
  ///
  /// In pt, this message translates to:
  /// **'Adivinhe a palavra'**
  String get minigamesHangmanDesc;

  /// No description provided for @minigamesWordSearch.
  ///
  /// In pt, this message translates to:
  /// **'🔍 Caça-Palavras'**
  String get minigamesWordSearch;

  /// No description provided for @minigamesWordSearchDesc.
  ///
  /// In pt, this message translates to:
  /// **'Encontre as palavras'**
  String get minigamesWordSearchDesc;

  /// No description provided for @minigamesMaze.
  ///
  /// In pt, this message translates to:
  /// **'🗺️ Labirinto'**
  String get minigamesMaze;

  /// No description provided for @minigamesMazeDesc.
  ///
  /// In pt, this message translates to:
  /// **'Encontre a saída'**
  String get minigamesMazeDesc;

  /// No description provided for @minigamesSequence.
  ///
  /// In pt, this message translates to:
  /// **'🎵 Sequência'**
  String get minigamesSequence;

  /// No description provided for @minigamesSequenceDesc.
  ///
  /// In pt, this message translates to:
  /// **'Repita a sequência'**
  String get minigamesSequenceDesc;

  /// No description provided for @minigamesTicTacToe.
  ///
  /// In pt, this message translates to:
  /// **'⭕ Jogo da Velha'**
  String get minigamesTicTacToe;

  /// No description provided for @minigamesTicTacToeDesc.
  ///
  /// In pt, this message translates to:
  /// **'Contra a IA'**
  String get minigamesTicTacToeDesc;

  /// No description provided for @achievementsTitle.
  ///
  /// In pt, this message translates to:
  /// **'🏆 Conquistas'**
  String get achievementsTitle;

  /// No description provided for @achievementsUnlocked.
  ///
  /// In pt, this message translates to:
  /// **'{count} Desbloqueadas'**
  String achievementsUnlocked(int count);

  /// No description provided for @achievementsProgress.
  ///
  /// In pt, this message translates to:
  /// **'Progresso: {percent}%'**
  String achievementsProgress(int percent);

  /// No description provided for @achievementsCategoryAll.
  ///
  /// In pt, this message translates to:
  /// **'Todas'**
  String get achievementsCategoryAll;

  /// No description provided for @achievementsCategoryQuiz.
  ///
  /// In pt, this message translates to:
  /// **'Quiz'**
  String get achievementsCategoryQuiz;

  /// No description provided for @achievementsCategoryMinigames.
  ///
  /// In pt, this message translates to:
  /// **'Minigames'**
  String get achievementsCategoryMinigames;

  /// No description provided for @achievementsCategorySocial.
  ///
  /// In pt, this message translates to:
  /// **'Social'**
  String get achievementsCategorySocial;

  /// No description provided for @achievementsCategoryMaster.
  ///
  /// In pt, this message translates to:
  /// **'Master'**
  String get achievementsCategoryMaster;

  /// No description provided for @achievementUnlocked.
  ///
  /// In pt, this message translates to:
  /// **'Conquista Desbloqueada!'**
  String get achievementUnlocked;

  /// No description provided for @achievementUnlockedAt.
  ///
  /// In pt, this message translates to:
  /// **'Desbloqueada em {date}'**
  String achievementUnlockedAt(String date);

  /// No description provided for @achPrimeiroPasso.
  ///
  /// In pt, this message translates to:
  /// **'Primeiro Passo'**
  String get achPrimeiroPasso;

  /// No description provided for @achPrimeiroPassoDesc.
  ///
  /// In pt, this message translates to:
  /// **'Complete seu primeiro quiz'**
  String get achPrimeiroPassoDesc;

  /// No description provided for @achEstudioso.
  ///
  /// In pt, this message translates to:
  /// **'Estudioso'**
  String get achEstudioso;

  /// No description provided for @achEstudiosoDesc.
  ///
  /// In pt, this message translates to:
  /// **'Complete 10 quizzes'**
  String get achEstudiosoDesc;

  /// No description provided for @achPerfeccionista.
  ///
  /// In pt, this message translates to:
  /// **'Perfeccionista'**
  String get achPerfeccionista;

  /// No description provided for @achPerfeccionistaDesc.
  ///
  /// In pt, this message translates to:
  /// **'Acerte 100% das perguntas'**
  String get achPerfeccionistaDesc;

  /// No description provided for @achVelocista.
  ///
  /// In pt, this message translates to:
  /// **'Velocista'**
  String get achVelocista;

  /// No description provided for @achVelocistaDesc.
  ///
  /// In pt, this message translates to:
  /// **'Complete quiz em menos de 2 minutos'**
  String get achVelocistaDesc;

  /// No description provided for @achSequenciaPerfeita.
  ///
  /// In pt, this message translates to:
  /// **'Sequência Perfeita'**
  String get achSequenciaPerfeita;

  /// No description provided for @achSequenciaPerfeitaDesc.
  ///
  /// In pt, this message translates to:
  /// **'5 quizzes seguidos com 80%+'**
  String get achSequenciaPerfeitaDesc;

  /// No description provided for @achMestreBiblico.
  ///
  /// In pt, this message translates to:
  /// **'Mestre Bíblico'**
  String get achMestreBiblico;

  /// No description provided for @achMestreBiblicoDesc.
  ///
  /// In pt, this message translates to:
  /// **'Complete 50 quizzes'**
  String get achMestreBiblicoDesc;

  /// No description provided for @achExplorador.
  ///
  /// In pt, this message translates to:
  /// **'Explorador'**
  String get achExplorador;

  /// No description provided for @achExploradorDesc.
  ///
  /// In pt, this message translates to:
  /// **'Jogue todos os minigames'**
  String get achExploradorDesc;

  /// No description provided for @achMestrePuzzles.
  ///
  /// In pt, this message translates to:
  /// **'Mestre dos Puzzles'**
  String get achMestrePuzzles;

  /// No description provided for @achMestrePuzzlesDesc.
  ///
  /// In pt, this message translates to:
  /// **'Complete puzzle em <2min'**
  String get achMestrePuzzlesDesc;

  /// No description provided for @achMemoriaFotografica.
  ///
  /// In pt, this message translates to:
  /// **'Memória Fotográfica'**
  String get achMemoriaFotografica;

  /// No description provided for @achMemoriaFotograficaDesc.
  ///
  /// In pt, this message translates to:
  /// **'Memory game sem erros'**
  String get achMemoriaFotograficaDesc;

  /// No description provided for @achAtiradorElite.
  ///
  /// In pt, this message translates to:
  /// **'Atirador de Elite'**
  String get achAtiradorElite;

  /// No description provided for @achAtiradorEliteDesc.
  ///
  /// In pt, this message translates to:
  /// **'10 vitórias no Jogo da Velha'**
  String get achAtiradorEliteDesc;

  /// No description provided for @achCampeaoMinigames.
  ///
  /// In pt, this message translates to:
  /// **'Campeão dos Minigames'**
  String get achCampeaoMinigames;

  /// No description provided for @achCampeaoMinigamesDesc.
  ///
  /// In pt, this message translates to:
  /// **'Vença cada minigame 3 vezes'**
  String get achCampeaoMinigamesDesc;

  /// No description provided for @achSocial.
  ///
  /// In pt, this message translates to:
  /// **'Social'**
  String get achSocial;

  /// No description provided for @achSocialDesc.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhe resultado'**
  String get achSocialDesc;

  /// No description provided for @achCompetidor.
  ///
  /// In pt, this message translates to:
  /// **'Competidor'**
  String get achCompetidor;

  /// No description provided for @achCompetidorDesc.
  ///
  /// In pt, this message translates to:
  /// **'Complete 5 partidas multiplayer'**
  String get achCompetidorDesc;

  /// No description provided for @achColecionador.
  ///
  /// In pt, this message translates to:
  /// **'Colecionador'**
  String get achColecionador;

  /// No description provided for @achColecionadorDesc.
  ///
  /// In pt, this message translates to:
  /// **'Desbloqueie 10 conquistas'**
  String get achColecionadorDesc;

  /// No description provided for @achLenda.
  ///
  /// In pt, this message translates to:
  /// **'Lenda'**
  String get achLenda;

  /// No description provided for @achLendaDesc.
  ///
  /// In pt, this message translates to:
  /// **'Desbloqueie todas as conquistas'**
  String get achLendaDesc;

  /// No description provided for @settingsTitle.
  ///
  /// In pt, this message translates to:
  /// **'⚙️ Configurações'**
  String get settingsTitle;

  /// No description provided for @settingsAudio.
  ///
  /// In pt, this message translates to:
  /// **'🔊 Áudio'**
  String get settingsAudio;

  /// No description provided for @settingsMusic.
  ///
  /// In pt, this message translates to:
  /// **'Música'**
  String get settingsMusic;

  /// No description provided for @settingsSoundEffects.
  ///
  /// In pt, this message translates to:
  /// **'Efeitos Sonoros'**
  String get settingsSoundEffects;

  /// No description provided for @settingsLanguage.
  ///
  /// In pt, this message translates to:
  /// **'🌍 Idioma'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguagePortuguese.
  ///
  /// In pt, this message translates to:
  /// **'🇧🇷 Português'**
  String get settingsLanguagePortuguese;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In pt, this message translates to:
  /// **'🇺🇸 English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageSpanish.
  ///
  /// In pt, this message translates to:
  /// **'🇪🇸 Español'**
  String get settingsLanguageSpanish;

  /// No description provided for @settingsTheme.
  ///
  /// In pt, this message translates to:
  /// **'🎨 Tema'**
  String get settingsTheme;

  /// No description provided for @settingsThemeDark.
  ///
  /// In pt, this message translates to:
  /// **'Escuro'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeLight.
  ///
  /// In pt, this message translates to:
  /// **'Claro'**
  String get settingsThemeLight;

  /// No description provided for @settingsHapticFeedback.
  ///
  /// In pt, this message translates to:
  /// **'📳 Vibração'**
  String get settingsHapticFeedback;

  /// No description provided for @settingsShowTutorial.
  ///
  /// In pt, this message translates to:
  /// **'📚 Tutorial'**
  String get settingsShowTutorial;

  /// No description provided for @settingsAchievements.
  ///
  /// In pt, this message translates to:
  /// **'🏆 Conquistas'**
  String get settingsAchievements;

  /// No description provided for @settingsStatistics.
  ///
  /// In pt, this message translates to:
  /// **'📊 Estatísticas'**
  String get settingsStatistics;

  /// No description provided for @settingsAbout.
  ///
  /// In pt, this message translates to:
  /// **'ℹ️ Sobre o App'**
  String get settingsAbout;

  /// No description provided for @statsTitle.
  ///
  /// In pt, this message translates to:
  /// **'📊 Estatísticas'**
  String get statsTitle;

  /// No description provided for @statsGlobal.
  ///
  /// In pt, this message translates to:
  /// **'Globais'**
  String get statsGlobal;

  /// No description provided for @statsTotalQuizzes.
  ///
  /// In pt, this message translates to:
  /// **'Total de Quizzes'**
  String get statsTotalQuizzes;

  /// No description provided for @statsTotalQuestions.
  ///
  /// In pt, this message translates to:
  /// **'Total de Perguntas'**
  String get statsTotalQuestions;

  /// No description provided for @statsCorrectAnswers.
  ///
  /// In pt, this message translates to:
  /// **'Respostas Corretas'**
  String get statsCorrectAnswers;

  /// No description provided for @statsWrongAnswers.
  ///
  /// In pt, this message translates to:
  /// **'Respostas Erradas'**
  String get statsWrongAnswers;

  /// No description provided for @statsAccuracy.
  ///
  /// In pt, this message translates to:
  /// **'Precisão'**
  String get statsAccuracy;

  /// No description provided for @statsHighScore.
  ///
  /// In pt, this message translates to:
  /// **'Recorde de Pontos'**
  String get statsHighScore;

  /// No description provided for @statsCurrentStreak.
  ///
  /// In pt, this message translates to:
  /// **'Sequência Atual'**
  String get statsCurrentStreak;

  /// No description provided for @statsLongestStreak.
  ///
  /// In pt, this message translates to:
  /// **'Maior Sequência'**
  String get statsLongestStreak;

  /// No description provided for @statsHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico'**
  String get statsHistory;

  /// No description provided for @statsMinigameRecords.
  ///
  /// In pt, this message translates to:
  /// **'Recordes de Minigames'**
  String get statsMinigameRecords;

  /// No description provided for @statsNoData.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum dado disponível ainda'**
  String get statsNoData;

  /// No description provided for @statsPlayToSeeData.
  ///
  /// In pt, this message translates to:
  /// **'Jogue para ver suas estatísticas!'**
  String get statsPlayToSeeData;

  /// No description provided for @errorLoadingQuestions.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar perguntas'**
  String get errorLoadingQuestions;

  /// No description provided for @errorNoQuestions.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma pergunta disponível'**
  String get errorNoQuestions;

  /// No description provided for @errorGeneric.
  ///
  /// In pt, this message translates to:
  /// **'Ocorreu um erro. Tente novamente.'**
  String get errorGeneric;

  /// No description provided for @errorConnection.
  ///
  /// In pt, this message translates to:
  /// **'Erro de conexão. Verifique sua internet.'**
  String get errorConnection;

  /// No description provided for @gameWon.
  ///
  /// In pt, this message translates to:
  /// **'Você ganhou!'**
  String get gameWon;

  /// No description provided for @gameLost.
  ///
  /// In pt, this message translates to:
  /// **'Você perdeu!'**
  String get gameLost;

  /// No description provided for @gameDraw.
  ///
  /// In pt, this message translates to:
  /// **'Empate!'**
  String get gameDraw;

  /// No description provided for @gamePaused.
  ///
  /// In pt, this message translates to:
  /// **'Jogo Pausado'**
  String get gamePaused;

  /// No description provided for @gameResume.
  ///
  /// In pt, this message translates to:
  /// **'Retomar'**
  String get gameResume;

  /// No description provided for @gameQuit.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get gameQuit;

  /// No description provided for @gameCompleted.
  ///
  /// In pt, this message translates to:
  /// **'Completado!'**
  String get gameCompleted;

  /// No description provided for @gameTimeElapsed.
  ///
  /// In pt, this message translates to:
  /// **'Tempo decorrido: {time}'**
  String gameTimeElapsed(String time);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
