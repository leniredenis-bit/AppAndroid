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

  /// No description provided for @pieces.
  ///
  /// In pt, this message translates to:
  /// **'Peças'**
  String get pieces;

  /// No description provided for @level.
  ///
  /// In pt, this message translates to:
  /// **'Nível'**
  String get level;

  /// No description provided for @difficulty.
  ///
  /// In pt, this message translates to:
  /// **'Dificuldade'**
  String get difficulty;

  /// No description provided for @easy.
  ///
  /// In pt, this message translates to:
  /// **'Fácil'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In pt, this message translates to:
  /// **'Médio'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In pt, this message translates to:
  /// **'Difícil'**
  String get hard;

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

  /// No description provided for @complete.
  ///
  /// In pt, this message translates to:
  /// **'COMPLETO!'**
  String get complete;

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

  /// No description provided for @homeQuizClassic.
  ///
  /// In pt, this message translates to:
  /// **'Quiz Clássico'**
  String get homeQuizClassic;

  /// No description provided for @homeQuizClassicDesc.
  ///
  /// In pt, this message translates to:
  /// **'Responda perguntas e marque pontos!'**
  String get homeQuizClassicDesc;

  /// No description provided for @homeQuizPie.
  ///
  /// In pt, this message translates to:
  /// **'Quiz Torta na Cara'**
  String get homeQuizPie;

  /// No description provided for @homeQuizPieDesc.
  ///
  /// In pt, this message translates to:
  /// **'Duelo 1v1 local - quem errar perde!'**
  String get homeQuizPieDesc;

  /// No description provided for @homeOnlineMatch.
  ///
  /// In pt, this message translates to:
  /// **'Partida Online'**
  String get homeOnlineMatch;

  /// No description provided for @homeOnlineMatchDesc.
  ///
  /// In pt, this message translates to:
  /// **'Jogue com amigos em tempo real!'**
  String get homeOnlineMatchDesc;

  /// No description provided for @homeMinigames.
  ///
  /// In pt, this message translates to:
  /// **'Minigames'**
  String get homeMinigames;

  /// No description provided for @homeMinigamesDesc.
  ///
  /// In pt, this message translates to:
  /// **'Jogos divertidos te aguardam!'**
  String get homeMinigamesDesc;

  /// No description provided for @homeStats.
  ///
  /// In pt, this message translates to:
  /// **'Estatísticas'**
  String get homeStats;

  /// No description provided for @homeStatsDesc.
  ///
  /// In pt, this message translates to:
  /// **'Veja seu desempenho e conquistas!'**
  String get homeStatsDesc;

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

  /// No description provided for @minigamesMemory.
  ///
  /// In pt, this message translates to:
  /// **'🧠 Jogo da Memória'**
  String get minigamesMemory;

  /// No description provided for @minigamesMemoryDesc.
  ///
  /// In pt, this message translates to:
  /// **'Encontre pares bíblicos!'**
  String get minigamesMemoryDesc;

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

  /// No description provided for @minigamesJigsaw.
  ///
  /// In pt, this message translates to:
  /// **'🖼️ Quebra-Cabeça Foto'**
  String get minigamesJigsaw;

  /// No description provided for @minigamesJigsawDesc.
  ///
  /// In pt, this message translates to:
  /// **'Monte imagens reais!'**
  String get minigamesJigsawDesc;

  /// No description provided for @minigamesHangman.
  ///
  /// In pt, this message translates to:
  /// **'🎯 Forca Bíblica'**
  String get minigamesHangman;

  /// No description provided for @minigamesHangmanDesc.
  ///
  /// In pt, this message translates to:
  /// **'Adivinhe a palavra bíblica!'**
  String get minigamesHangmanDesc;

  /// No description provided for @minigamesWordSearch.
  ///
  /// In pt, this message translates to:
  /// **'🔍 Caça-Palavras'**
  String get minigamesWordSearch;

  /// No description provided for @minigamesWordSearchDesc.
  ///
  /// In pt, this message translates to:
  /// **'Encontre palavras escondidas!'**
  String get minigamesWordSearchDesc;

  /// No description provided for @minigamesMaze.
  ///
  /// In pt, this message translates to:
  /// **'🌀 Labirinto'**
  String get minigamesMaze;

  /// No description provided for @minigamesMazeDesc.
  ///
  /// In pt, this message translates to:
  /// **'Encontre a saída!'**
  String get minigamesMazeDesc;

  /// No description provided for @minigamesSequence.
  ///
  /// In pt, this message translates to:
  /// **'� Sequência Rápida'**
  String get minigamesSequence;

  /// No description provided for @minigamesSequenceDesc.
  ///
  /// In pt, this message translates to:
  /// **'Memorize o padrão de cores!'**
  String get minigamesSequenceDesc;

  /// No description provided for @minigamesSequenceCrystal.
  ///
  /// In pt, this message translates to:
  /// **'💠 Sequência Cristal'**
  String get minigamesSequenceCrystal;

  /// No description provided for @minigamesSequenceCrystalDesc.
  ///
  /// In pt, this message translates to:
  /// **'Versão cristal com brilhos!'**
  String get minigamesSequenceCrystalDesc;

  /// No description provided for @minigamesTicTacToe.
  ///
  /// In pt, this message translates to:
  /// **'⭕ Jogo da Velha'**
  String get minigamesTicTacToe;

  /// No description provided for @minigamesTicTacToeDesc.
  ///
  /// In pt, this message translates to:
  /// **'Duelo 2 jogadores ou vs IA!'**
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
  /// **'Sequência\nAtual'**
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
  /// **'Nenhum dado disponível'**
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

  /// No description provided for @bibleReadFullText.
  ///
  /// In pt, this message translates to:
  /// **'Toque para ler o texto completo'**
  String get bibleReadFullText;

  /// No description provided for @bibleOpenError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível abrir a referência.'**
  String get bibleOpenError;

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

  /// No description provided for @memoryGameTitle.
  ///
  /// In pt, this message translates to:
  /// **'🧠 Jogo da Memória'**
  String get memoryGameTitle;

  /// No description provided for @memoryGameDifficulty.
  ///
  /// In pt, this message translates to:
  /// **'Dificuldade'**
  String get memoryGameDifficulty;

  /// No description provided for @memoryGameEasy.
  ///
  /// In pt, this message translates to:
  /// **'Fácil (6 pares)'**
  String get memoryGameEasy;

  /// No description provided for @memoryGameMedium.
  ///
  /// In pt, this message translates to:
  /// **'Médio (10 pares)'**
  String get memoryGameMedium;

  /// No description provided for @memoryGameHard.
  ///
  /// In pt, this message translates to:
  /// **'Difícil (15 pares)'**
  String get memoryGameHard;

  /// No description provided for @memoryGameTheme.
  ///
  /// In pt, this message translates to:
  /// **'Tema'**
  String get memoryGameTheme;

  /// No description provided for @memoryGamePlayers.
  ///
  /// In pt, this message translates to:
  /// **'Jogadores'**
  String get memoryGamePlayers;

  /// No description provided for @memoryGameStartGame.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar Jogo'**
  String get memoryGameStartGame;

  /// No description provided for @memoryGameAttempts.
  ///
  /// In pt, this message translates to:
  /// **'Tentativas'**
  String get memoryGameAttempts;

  /// No description provided for @memoryGameMatches.
  ///
  /// In pt, this message translates to:
  /// **'Pares'**
  String get memoryGameMatches;

  /// No description provided for @memoryGameTime.
  ///
  /// In pt, this message translates to:
  /// **'Tempo'**
  String get memoryGameTime;

  /// No description provided for @memoryGamePlayerTurn.
  ///
  /// In pt, this message translates to:
  /// **'Vez do Jogador {player}'**
  String memoryGamePlayerTurn(int player);

  /// No description provided for @memoryGameScore.
  ///
  /// In pt, this message translates to:
  /// **'Pontos: {score}'**
  String memoryGameScore(int score);

  /// No description provided for @memoryGameCongrats.
  ///
  /// In pt, this message translates to:
  /// **'Parabéns! 🎉'**
  String get memoryGameCongrats;

  /// No description provided for @memoryGamePlayAgain.
  ///
  /// In pt, this message translates to:
  /// **'Jogar Novamente'**
  String get memoryGamePlayAgain;

  /// No description provided for @ticTacToeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Jogo da Velha Neon'**
  String get ticTacToeTitle;

  /// No description provided for @ticTacToeMode.
  ///
  /// In pt, this message translates to:
  /// **'Modo'**
  String get ticTacToeMode;

  /// No description provided for @ticTacToeTwoPlayers.
  ///
  /// In pt, this message translates to:
  /// **'2 Jogadores'**
  String get ticTacToeTwoPlayers;

  /// No description provided for @ticTacToeVsAI.
  ///
  /// In pt, this message translates to:
  /// **'vs IA'**
  String get ticTacToeVsAI;

  /// No description provided for @ticTacToeDifficulty.
  ///
  /// In pt, this message translates to:
  /// **'Dificuldade da IA'**
  String get ticTacToeDifficulty;

  /// No description provided for @ticTacToeEasy.
  ///
  /// In pt, this message translates to:
  /// **'Fácil'**
  String get ticTacToeEasy;

  /// No description provided for @ticTacToeImpossible.
  ///
  /// In pt, this message translates to:
  /// **'Impossível'**
  String get ticTacToeImpossible;

  /// No description provided for @ticTacToePlayerX.
  ///
  /// In pt, this message translates to:
  /// **'Jogador X'**
  String get ticTacToePlayerX;

  /// No description provided for @ticTacToePlayerO.
  ///
  /// In pt, this message translates to:
  /// **'Jogador O'**
  String get ticTacToePlayerO;

  /// No description provided for @ticTacToeYourTurn.
  ///
  /// In pt, this message translates to:
  /// **'Sua vez'**
  String get ticTacToeYourTurn;

  /// No description provided for @ticTacToeWins.
  ///
  /// In pt, this message translates to:
  /// **'Vitórias'**
  String get ticTacToeWins;

  /// No description provided for @ticTacToeDraws.
  ///
  /// In pt, this message translates to:
  /// **'Empates'**
  String get ticTacToeDraws;

  /// No description provided for @ticTacToeResetScores.
  ///
  /// In pt, this message translates to:
  /// **'Resetar Placar'**
  String get ticTacToeResetScores;

  /// No description provided for @ticTacToeNewGame.
  ///
  /// In pt, this message translates to:
  /// **'Novo Jogo'**
  String get ticTacToeNewGame;

  /// No description provided for @hangmanTitle.
  ///
  /// In pt, this message translates to:
  /// **'Jogo da Forca'**
  String get hangmanTitle;

  /// No description provided for @hangmanCategory.
  ///
  /// In pt, this message translates to:
  /// **'Categoria'**
  String get hangmanCategory;

  /// No description provided for @hangmanAttempts.
  ///
  /// In pt, this message translates to:
  /// **'Tentativas restantes'**
  String get hangmanAttempts;

  /// No description provided for @hangmanGuess.
  ///
  /// In pt, this message translates to:
  /// **'Adivinhe a letra'**
  String get hangmanGuess;

  /// No description provided for @hangmanWin.
  ///
  /// In pt, this message translates to:
  /// **'Você ganhou! 🎉'**
  String get hangmanWin;

  /// No description provided for @hangmanLose.
  ///
  /// In pt, this message translates to:
  /// **'Fim de jogo!'**
  String get hangmanLose;

  /// No description provided for @hangmanTheWordWas.
  ///
  /// In pt, this message translates to:
  /// **'A palavra era:'**
  String get hangmanTheWordWas;

  /// No description provided for @hangmanPlayAgain.
  ///
  /// In pt, this message translates to:
  /// **'Jogar Novamente'**
  String get hangmanPlayAgain;

  /// No description provided for @hangmanErrors.
  ///
  /// In pt, this message translates to:
  /// **'Erros: {errors} / {max}'**
  String hangmanErrors(int errors, int max);

  /// No description provided for @hangmanCongrats.
  ///
  /// In pt, this message translates to:
  /// **'🎉 Parabéns! Você acertou!'**
  String get hangmanCongrats;

  /// No description provided for @hangmanYouLost.
  ///
  /// In pt, this message translates to:
  /// **'😢 Você perdeu!'**
  String get hangmanYouLost;

  /// No description provided for @hangmanWordWas.
  ///
  /// In pt, this message translates to:
  /// **'A palavra era: {word}'**
  String hangmanWordWas(String word);

  /// No description provided for @hangmanWrongLetters.
  ///
  /// In pt, this message translates to:
  /// **'Letras erradas: {letters}'**
  String hangmanWrongLetters(String letters);

  /// No description provided for @wordSearchTitle.
  ///
  /// In pt, this message translates to:
  /// **'Caça-Palavras'**
  String get wordSearchTitle;

  /// No description provided for @wordSearchWordsFound.
  ///
  /// In pt, this message translates to:
  /// **'Palavras encontradas: {found}/{total}'**
  String wordSearchWordsFound(int found, int total);

  /// No description provided for @wordSearchTimeElapsed.
  ///
  /// In pt, this message translates to:
  /// **'Tempo: {time}'**
  String wordSearchTimeElapsed(String time);

  /// No description provided for @wordSearchComplete.
  ///
  /// In pt, this message translates to:
  /// **'COMPLETO!'**
  String get wordSearchComplete;

  /// No description provided for @wordSearchNewGame.
  ///
  /// In pt, this message translates to:
  /// **'Novo Jogo'**
  String get wordSearchNewGame;

  /// No description provided for @mazeTitle.
  ///
  /// In pt, this message translates to:
  /// **'🗺️ Labirinto'**
  String get mazeTitle;

  /// No description provided for @mazeMoves.
  ///
  /// In pt, this message translates to:
  /// **'Movimentos'**
  String get mazeMoves;

  /// No description provided for @mazeMovesCount.
  ///
  /// In pt, this message translates to:
  /// **'Movimentos: {count}'**
  String mazeMovesCount(int count);

  /// No description provided for @mazeTime.
  ///
  /// In pt, this message translates to:
  /// **'Tempo'**
  String get mazeTime;

  /// No description provided for @mazeControls.
  ///
  /// In pt, this message translates to:
  /// **'Controles'**
  String get mazeControls;

  /// No description provided for @mazeUseButtons.
  ///
  /// In pt, this message translates to:
  /// **'Use os botões ou teclas de seta'**
  String get mazeUseButtons;

  /// No description provided for @mazeGoal.
  ///
  /// In pt, this message translates to:
  /// **'Encontre a saída!'**
  String get mazeGoal;

  /// No description provided for @mazeVictory.
  ///
  /// In pt, this message translates to:
  /// **'Saída encontrada! 🎉'**
  String get mazeVictory;

  /// No description provided for @mazePlayAgain.
  ///
  /// In pt, this message translates to:
  /// **'Jogar Novamente'**
  String get mazePlayAgain;

  /// No description provided for @mazeCavern.
  ///
  /// In pt, this message translates to:
  /// **'🏔️ Caverna do Labirinto'**
  String get mazeCavern;

  /// No description provided for @mazeCampaignMode.
  ///
  /// In pt, this message translates to:
  /// **'Modo Campanha (Nível {level})'**
  String mazeCampaignMode(int level);

  /// No description provided for @mazeQuickPlayCustom.
  ///
  /// In pt, this message translates to:
  /// **'Jogo Rápido Personalizado'**
  String get mazeQuickPlayCustom;

  /// No description provided for @mazeRows.
  ///
  /// In pt, this message translates to:
  /// **'Linhas: {count}'**
  String mazeRows(int count);

  /// No description provided for @mazeColumns.
  ///
  /// In pt, this message translates to:
  /// **'Colunas: {count}'**
  String mazeColumns(int count);

  /// No description provided for @mazePlayQuick.
  ///
  /// In pt, this message translates to:
  /// **'Jogar Partida Rápida'**
  String get mazePlayQuick;

  /// No description provided for @mazeEscaped.
  ///
  /// In pt, this message translates to:
  /// **'✨ ESCAPOU! ✨'**
  String get mazeEscaped;

  /// No description provided for @mazeCompletedIn.
  ///
  /// In pt, this message translates to:
  /// **'Você completou o labirinto em {moves} movimentos.'**
  String mazeCompletedIn(int moves);

  /// No description provided for @mazeBackToMenu.
  ///
  /// In pt, this message translates to:
  /// **'Voltar ao Menu'**
  String get mazeBackToMenu;

  /// No description provided for @mazeLevelComplete.
  ///
  /// In pt, this message translates to:
  /// **'Nível {level} Concluído!'**
  String mazeLevelComplete(int level);

  /// No description provided for @mazeLoadingNextCavern.
  ///
  /// In pt, this message translates to:
  /// **'Carregando próxima caverna...'**
  String get mazeLoadingNextCavern;

  /// No description provided for @sequenceTitle.
  ///
  /// In pt, this message translates to:
  /// **'🎵 Sequência de Cores'**
  String get sequenceTitle;

  /// No description provided for @sequenceLevel.
  ///
  /// In pt, this message translates to:
  /// **'NÍVEL'**
  String get sequenceLevel;

  /// No description provided for @sequenceHighScore.
  ///
  /// In pt, this message translates to:
  /// **'Recorde'**
  String get sequenceHighScore;

  /// No description provided for @sequenceWatchSequence.
  ///
  /// In pt, this message translates to:
  /// **'Observe a sequência...'**
  String get sequenceWatchSequence;

  /// No description provided for @sequenceYourTurn.
  ///
  /// In pt, this message translates to:
  /// **'Sua vez! Repita a sequência'**
  String get sequenceYourTurn;

  /// No description provided for @sequenceGameOver.
  ///
  /// In pt, this message translates to:
  /// **'❌ Fim de Jogo!'**
  String get sequenceGameOver;

  /// No description provided for @sequenceReached.
  ///
  /// In pt, this message translates to:
  /// **'Você chegou ao nível {level}!'**
  String sequenceReached(int level);

  /// No description provided for @sequenceNewRecord.
  ///
  /// In pt, this message translates to:
  /// **'Novo recorde! 🏆'**
  String get sequenceNewRecord;

  /// No description provided for @sequenceTryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Tentar Novamente'**
  String get sequenceTryAgain;

  /// No description provided for @sequenceActiveColors.
  ///
  /// In pt, this message translates to:
  /// **'CORES ATIVAS: {active} / {max}'**
  String sequenceActiveColors(int active, int max);

  /// No description provided for @sequenceStreak.
  ///
  /// In pt, this message translates to:
  /// **'SEQUÊNCIA: {current} / {target}'**
  String sequenceStreak(int current, int target);

  /// No description provided for @sequenceCorrect.
  ///
  /// In pt, this message translates to:
  /// **'✨ Correto! ✨'**
  String get sequenceCorrect;

  /// No description provided for @sequenceObserve.
  ///
  /// In pt, this message translates to:
  /// **'Observe a sequência...'**
  String get sequenceObserve;

  /// No description provided for @sequenceRepeat.
  ///
  /// In pt, this message translates to:
  /// **'👆 Sua vez! Repita a sequência'**
  String get sequenceRepeat;

  /// No description provided for @sequenceGameOverLevel.
  ///
  /// In pt, this message translates to:
  /// **'❌ Fim de Jogo! Você chegou ao nível {level}'**
  String sequenceGameOverLevel(int level);

  /// No description provided for @sequenceRestartGame.
  ///
  /// In pt, this message translates to:
  /// **'Reiniciar Jogo'**
  String get sequenceRestartGame;

  /// No description provided for @sequenceStartDifficulty.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar/Dificuldade'**
  String get sequenceStartDifficulty;

  /// No description provided for @sequenceChooseDifficulty.
  ///
  /// In pt, this message translates to:
  /// **'Escolha a Dificuldade'**
  String get sequenceChooseDifficulty;

  /// No description provided for @sequenceEasyColors.
  ///
  /// In pt, this message translates to:
  /// **'Fácil ({count} Cores)'**
  String sequenceEasyColors(int count);

  /// No description provided for @sequenceMediumColors.
  ///
  /// In pt, this message translates to:
  /// **'Médio ({count} Cores)'**
  String sequenceMediumColors(int count);

  /// No description provided for @sequenceHardColors.
  ///
  /// In pt, this message translates to:
  /// **'Difícil ({count} Cores)'**
  String sequenceHardColors(int count);

  /// No description provided for @sequenceProgressive.
  ///
  /// In pt, this message translates to:
  /// **'PROGRESSIVO ({start} -> {end} Cores)'**
  String sequenceProgressive(int start, int end);

  /// No description provided for @sequenceProgressiveDesc.
  ///
  /// In pt, this message translates to:
  /// **'Aumenta uma cor a cada {count} acertos seguidos.'**
  String sequenceProgressiveDesc(int count);

  /// No description provided for @sequenceHighScoreLabel.
  ///
  /// In pt, this message translates to:
  /// **'Recorde: {score}'**
  String sequenceHighScoreLabel(int score);

  /// No description provided for @colorRed.
  ///
  /// In pt, this message translates to:
  /// **'Vermelho'**
  String get colorRed;

  /// No description provided for @colorBlue.
  ///
  /// In pt, this message translates to:
  /// **'Azul'**
  String get colorBlue;

  /// No description provided for @colorGreen.
  ///
  /// In pt, this message translates to:
  /// **'Verde'**
  String get colorGreen;

  /// No description provided for @colorYellow.
  ///
  /// In pt, this message translates to:
  /// **'Amarelo'**
  String get colorYellow;

  /// No description provided for @colorPurple.
  ///
  /// In pt, this message translates to:
  /// **'Roxo'**
  String get colorPurple;

  /// No description provided for @colorOrange.
  ///
  /// In pt, this message translates to:
  /// **'Laranja'**
  String get colorOrange;

  /// No description provided for @colorCyan.
  ///
  /// In pt, this message translates to:
  /// **'Ciano'**
  String get colorCyan;

  /// No description provided for @colorLime.
  ///
  /// In pt, this message translates to:
  /// **'Lima'**
  String get colorLime;

  /// No description provided for @colorPink.
  ///
  /// In pt, this message translates to:
  /// **'Rosa'**
  String get colorPink;

  /// No description provided for @colorLocked.
  ///
  /// In pt, this message translates to:
  /// **'Bloqueado'**
  String get colorLocked;

  /// No description provided for @puzzleTitle.
  ///
  /// In pt, this message translates to:
  /// **'🧩 Quebra-Cabeça'**
  String get puzzleTitle;

  /// No description provided for @puzzleMoves.
  ///
  /// In pt, this message translates to:
  /// **'Movimentos'**
  String get puzzleMoves;

  /// No description provided for @puzzleDragPieces.
  ///
  /// In pt, this message translates to:
  /// **'Arraste as peças para os lugares corretos'**
  String get puzzleDragPieces;

  /// No description provided for @puzzleComplete.
  ///
  /// In pt, this message translates to:
  /// **'Quebra-cabeça completo! 🎉'**
  String get puzzleComplete;

  /// No description provided for @puzzleNewGame.
  ///
  /// In pt, this message translates to:
  /// **'Novo Jogo'**
  String get puzzleNewGame;

  /// No description provided for @completedInMoves.
  ///
  /// In pt, this message translates to:
  /// **'Concluído em {moves} movimentos'**
  String completedInMoves(Object moves);

  /// No description provided for @newGame.
  ///
  /// In pt, this message translates to:
  /// **'Nova Partida'**
  String get newGame;

  /// No description provided for @settingsLanguageChanged.
  ///
  /// In pt, this message translates to:
  /// **'Idioma alterado com sucesso!'**
  String get settingsLanguageChanged;

  /// No description provided for @settingsMusicVolume.
  ///
  /// In pt, this message translates to:
  /// **'🎵 Volume da Música'**
  String get settingsMusicVolume;

  /// No description provided for @settingsSfxVolume.
  ///
  /// In pt, this message translates to:
  /// **'🔊 Volume dos Efeitos'**
  String get settingsSfxVolume;

  /// No description provided for @settingsAchievementsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Veja suas conquistas desbloqueadas'**
  String get settingsAchievementsSubtitle;

  /// No description provided for @settingsStatisticsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Veja seu desempenho'**
  String get settingsStatisticsSubtitle;

  /// No description provided for @settingsTerms.
  ///
  /// In pt, this message translates to:
  /// **'📜 Termos e Condições'**
  String get settingsTerms;

  /// No description provided for @settingsTermsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Política de privacidade e termos'**
  String get settingsTermsSubtitle;

  /// No description provided for @settingsAboutSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Informações sobre o aplicativo'**
  String get settingsAboutSubtitle;

  /// No description provided for @termsTitle.
  ///
  /// In pt, this message translates to:
  /// **'ℹ️ Termos e Condições'**
  String get termsTitle;

  /// No description provided for @termsOfUse.
  ///
  /// In pt, this message translates to:
  /// **'📋 Termos de Uso'**
  String get termsOfUse;

  /// No description provided for @termsWelcome.
  ///
  /// In pt, this message translates to:
  /// **'Bem-vindo ao JW SPLASH GAMES! Este aplicativo foi desenvolvido para fins educacionais e de entretenimento, visando promover o conhecimento bíblico de forma interativa.'**
  String get termsWelcome;

  /// No description provided for @termsAppUsage.
  ///
  /// In pt, this message translates to:
  /// **'1. Uso do Aplicativo'**
  String get termsAppUsage;

  /// No description provided for @termsAppUsageDesc.
  ///
  /// In pt, this message translates to:
  /// **'O JW SPLASH GAMES é um aplicativo gratuito para uso pessoal. Você pode:'**
  String get termsAppUsageDesc;

  /// No description provided for @termsAppUsageItem1.
  ///
  /// In pt, this message translates to:
  /// **'Jogar quizzes individuais ou em grupo'**
  String get termsAppUsageItem1;

  /// No description provided for @termsAppUsageItem2.
  ///
  /// In pt, this message translates to:
  /// **'Acessar estatísticas pessoais'**
  String get termsAppUsageItem2;

  /// No description provided for @termsAppUsageItem3.
  ///
  /// In pt, this message translates to:
  /// **'Usar o modo estudo sem limite de tempo'**
  String get termsAppUsageItem3;

  /// No description provided for @termsAppUsageItem4.
  ///
  /// In pt, this message translates to:
  /// **'Jogar minigames educativos'**
  String get termsAppUsageItem4;

  /// No description provided for @termsAppUsageItem5.
  ///
  /// In pt, this message translates to:
  /// **'Desbloquear conquistas'**
  String get termsAppUsageItem5;

  /// No description provided for @termsBiblicalContent.
  ///
  /// In pt, this message translates to:
  /// **'2. Conteúdo Bíblico'**
  String get termsBiblicalContent;

  /// No description provided for @termsBiblicalContentDesc.
  ///
  /// In pt, this message translates to:
  /// **'As perguntas e respostas são baseadas na Bíblia Sagrada. Este aplicativo não substitui o estudo pessoal das Escrituras Sagradas nem representa uma organização religiosa oficial.'**
  String get termsBiblicalContentDesc;

  /// No description provided for @termsResponsibilities.
  ///
  /// In pt, this message translates to:
  /// **'3. Responsabilidades'**
  String get termsResponsibilities;

  /// No description provided for @termsResponsibilitiesDesc.
  ///
  /// In pt, this message translates to:
  /// **'O usuário é responsável por seu uso adequado do aplicativo. Não nos responsabilizamos por:'**
  String get termsResponsibilitiesDesc;

  /// No description provided for @termsResponsibilitiesItem1.
  ///
  /// In pt, this message translates to:
  /// **'Uso indevido das informações apresentadas'**
  String get termsResponsibilitiesItem1;

  /// No description provided for @termsResponsibilitiesItem2.
  ///
  /// In pt, this message translates to:
  /// **'Interpretações pessoais do conteúdo bíblico'**
  String get termsResponsibilitiesItem2;

  /// No description provided for @termsResponsibilitiesItem3.
  ///
  /// In pt, this message translates to:
  /// **'Problemas técnicos ou perda de dados'**
  String get termsResponsibilitiesItem3;

  /// No description provided for @privacyPolicy.
  ///
  /// In pt, this message translates to:
  /// **'🔒 Política de Privacidade'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyIntro.
  ///
  /// In pt, this message translates to:
  /// **'Respeitamos sua privacidade. Este aplicativo:'**
  String get privacyPolicyIntro;

  /// No description provided for @privacyDataCollected.
  ///
  /// In pt, this message translates to:
  /// **'1. Dados Coletados'**
  String get privacyDataCollected;

  /// No description provided for @privacyDataItem1.
  ///
  /// In pt, this message translates to:
  /// **'Dados de uso: Estatísticas de jogo, preferências de tema'**
  String get privacyDataItem1;

  /// No description provided for @privacyDataItem2.
  ///
  /// In pt, this message translates to:
  /// **'Dados técnicos: Tipo de dispositivo, navegador, sistema operacional'**
  String get privacyDataItem2;

  /// No description provided for @privacyDataItem3.
  ///
  /// In pt, this message translates to:
  /// **'Dados de sessão: Tempo de uso, páginas visitadas'**
  String get privacyDataItem3;

  /// No description provided for @privacyStorage.
  ///
  /// In pt, this message translates to:
  /// **'2. Armazenamento'**
  String get privacyStorage;

  /// No description provided for @privacyStorageDesc.
  ///
  /// In pt, this message translates to:
  /// **'Todos os dados são armazenados localmente no seu dispositivo. Não enviamos dados para servidores externos.'**
  String get privacyStorageDesc;

  /// No description provided for @privacyLocalStorage.
  ///
  /// In pt, this message translates to:
  /// **'3. LocalStorage'**
  String get privacyLocalStorage;

  /// No description provided for @privacyLocalStorageDesc.
  ///
  /// In pt, this message translates to:
  /// **'Usamos localStorage do navegador para salvar:'**
  String get privacyLocalStorageDesc;

  /// No description provided for @privacyLocalStorageItem1.
  ///
  /// In pt, this message translates to:
  /// **'Preferências do usuário (tema, idioma)'**
  String get privacyLocalStorageItem1;

  /// No description provided for @privacyLocalStorageItem2.
  ///
  /// In pt, this message translates to:
  /// **'Estatísticas pessoais de jogo'**
  String get privacyLocalStorageItem2;

  /// No description provided for @privacyLocalStorageItem3.
  ///
  /// In pt, this message translates to:
  /// **'Conquistas desbloqueadas'**
  String get privacyLocalStorageItem3;

  /// No description provided for @privacySharing.
  ///
  /// In pt, this message translates to:
  /// **'4. Compartilhamento'**
  String get privacySharing;

  /// No description provided for @privacySharingDesc.
  ///
  /// In pt, this message translates to:
  /// **'Não compartilhamos seus dados pessoais com terceiros. Os dados permanecem exclusivamente no seu dispositivo.'**
  String get privacySharingDesc;

  /// No description provided for @copyright.
  ///
  /// In pt, this message translates to:
  /// **'©️ Direitos Autorais'**
  String get copyright;

  /// No description provided for @copyrightAppContent.
  ///
  /// In pt, this message translates to:
  /// **'1. Conteúdo do Aplicativo'**
  String get copyrightAppContent;

  /// No description provided for @copyrightAppContentDesc.
  ///
  /// In pt, this message translates to:
  /// **'O código do aplicativo JW SPLASH GAMES é distribuído sob licença MIT. As perguntas e respostas são de domínio público ou foram criadas especificamente para este projeto educacional.'**
  String get copyrightAppContentDesc;

  /// No description provided for @copyrightBible.
  ///
  /// In pt, this message translates to:
  /// **'2. Bíblia e Textos Sagrados'**
  String get copyrightBible;

  /// No description provided for @copyrightBibleDesc.
  ///
  /// In pt, this message translates to:
  /// **'Os textos bíblicos citados seguem a Tradução do Novo Mundo (TNM) das Escrituras Sagradas, usada com permissão para fins educacionais não comerciais.'**
  String get copyrightBibleDesc;

  /// No description provided for @copyrightImages.
  ///
  /// In pt, this message translates to:
  /// **'3. Imagens e Ícones'**
  String get copyrightImages;

  /// No description provided for @copyrightImagesDesc.
  ///
  /// In pt, this message translates to:
  /// **'Os ícones e emojis utilizados são de fontes públicas ou licenciadas para uso gratuito.'**
  String get copyrightImagesDesc;

  /// No description provided for @copyrightNonCommercial.
  ///
  /// In pt, this message translates to:
  /// **'4. Uso Não Comercial'**
  String get copyrightNonCommercial;

  /// No description provided for @copyrightNonCommercialDesc.
  ///
  /// In pt, this message translates to:
  /// **'Este aplicativo é desenvolvido para fins educacionais e não comerciais. Qualquer uso comercial requer autorização prévia.'**
  String get copyrightNonCommercialDesc;

  /// No description provided for @contactSection.
  ///
  /// In pt, this message translates to:
  /// **'📞 Contato'**
  String get contactSection;

  /// No description provided for @contactDesc.
  ///
  /// In pt, this message translates to:
  /// **'Para dúvidas, sugestões ou relatar problemas:'**
  String get contactDesc;

  /// No description provided for @lastUpdated.
  ///
  /// In pt, this message translates to:
  /// **'📅 Última Atualização: Novembro 2025'**
  String get lastUpdated;

  /// No description provided for @aboutTitle.
  ///
  /// In pt, this message translates to:
  /// **'📱 Sobre o Jogo'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In pt, this message translates to:
  /// **'Versão 1.0.0'**
  String get aboutVersion;

  /// No description provided for @aboutWhatIs.
  ///
  /// In pt, this message translates to:
  /// **'O que é?'**
  String get aboutWhatIs;

  /// No description provided for @aboutWhatIsDesc.
  ///
  /// In pt, this message translates to:
  /// **'JW SPLASH GAMES é um aplicativo educativo que torna o aprendizado bíblico divertido e interativo através de quizzes, minigames e desafios.'**
  String get aboutWhatIsDesc;

  /// No description provided for @aboutFeatures.
  ///
  /// In pt, this message translates to:
  /// **'Recursos'**
  String get aboutFeatures;

  /// No description provided for @aboutFeaturesDesc.
  ///
  /// In pt, this message translates to:
  /// **'• Quiz Bíblico Interativo\n• Jogo da Memória\n• Caça-Palavras\n• Labirinto\n• Sistema de Conquistas\n• Estatísticas Detalhadas\n• Modo Multiplayer\n• 3 Idiomas (PT, EN, ES)'**
  String get aboutFeaturesDesc;

  /// No description provided for @aboutDevelopedBy.
  ///
  /// In pt, this message translates to:
  /// **'Desenvolvido por'**
  String get aboutDevelopedBy;

  /// No description provided for @aboutDevelopedByDesc.
  ///
  /// In pt, this message translates to:
  /// **'Equipe JW SPLASH GAMES\nProjeto open-source disponível no GitHub'**
  String get aboutDevelopedByDesc;

  /// No description provided for @aboutObjective.
  ///
  /// In pt, this message translates to:
  /// **'Objetivo'**
  String get aboutObjective;

  /// No description provided for @aboutObjectiveDesc.
  ///
  /// In pt, this message translates to:
  /// **'Proporcionar uma forma divertida e educativa de aprender e memorizar conhecimentos bíblicos, adequado para todas as idades.'**
  String get aboutObjectiveDesc;

  /// No description provided for @aboutUpdateNote.
  ///
  /// In pt, this message translates to:
  /// **'📝 Esta página será atualizada em breve com mais informações e link para página online oficial.'**
  String get aboutUpdateNote;

  /// No description provided for @aboutVisitGithub.
  ///
  /// In pt, this message translates to:
  /// **'Visitar GitHub'**
  String get aboutVisitGithub;

  /// No description provided for @statsTabQuiz.
  ///
  /// In pt, this message translates to:
  /// **'Quiz'**
  String get statsTabQuiz;

  /// No description provided for @statsTabMinigames.
  ///
  /// In pt, this message translates to:
  /// **'Minigames'**
  String get statsTabMinigames;

  /// No description provided for @statsTabHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico'**
  String get statsTabHistory;

  /// No description provided for @statsGeneralPerformance.
  ///
  /// In pt, this message translates to:
  /// **'📊 Desempenho Geral'**
  String get statsGeneralPerformance;

  /// No description provided for @statsQuizzesCompleted.
  ///
  /// In pt, this message translates to:
  /// **'Quizzes\nRealizados'**
  String get statsQuizzesCompleted;

  /// No description provided for @statsAccuracyRate.
  ///
  /// In pt, this message translates to:
  /// **'Taxa de\nAcerto'**
  String get statsAccuracyRate;

  /// No description provided for @statsBestScore.
  ///
  /// In pt, this message translates to:
  /// **'Melhor\nScore'**
  String get statsBestScore;

  /// No description provided for @statsBestStreak.
  ///
  /// In pt, this message translates to:
  /// **'Melhor Sequência'**
  String get statsBestStreak;

  /// No description provided for @statsStreakTip.
  ///
  /// In pt, this message translates to:
  /// **'Mantenha 80%+ de acerto para continuar a sequência!'**
  String get statsStreakTip;

  /// No description provided for @statsByCategory.
  ///
  /// In pt, this message translates to:
  /// **'📚 Por Categoria'**
  String get statsByCategory;

  /// No description provided for @statsAccuracyByDifficulty.
  ///
  /// In pt, this message translates to:
  /// **'🎯 Precisão por Dificuldade'**
  String get statsAccuracyByDifficulty;

  /// No description provided for @statsNoMinigames.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum minigame jogado ainda'**
  String get statsNoMinigames;

  /// No description provided for @statsMinigamesTitle.
  ///
  /// In pt, this message translates to:
  /// **'🕹️ Estatísticas dos Minigames'**
  String get statsMinigamesTitle;

  /// No description provided for @statsGames.
  ///
  /// In pt, this message translates to:
  /// **'Jogos'**
  String get statsGames;

  /// No description provided for @statsWins.
  ///
  /// In pt, this message translates to:
  /// **'Vitórias'**
  String get statsWins;

  /// No description provided for @statsRate.
  ///
  /// In pt, this message translates to:
  /// **'Taxa'**
  String get statsRate;

  /// No description provided for @statsRecord.
  ///
  /// In pt, this message translates to:
  /// **'Recorde'**
  String get statsRecord;

  /// No description provided for @statsBestTime.
  ///
  /// In pt, this message translates to:
  /// **'⏱️ Melhor tempo: {time}'**
  String statsBestTime(String time);

  /// No description provided for @statsNoHistory.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum histórico disponível'**
  String get statsNoHistory;

  /// No description provided for @statsGamePuzzle.
  ///
  /// In pt, this message translates to:
  /// **'🧩 Quebra-Cabeça'**
  String get statsGamePuzzle;

  /// No description provided for @statsGameHangman.
  ///
  /// In pt, this message translates to:
  /// **'📝 Forca'**
  String get statsGameHangman;

  /// No description provided for @statsGameWordSearch.
  ///
  /// In pt, this message translates to:
  /// **'🔍 Caça-Palavras'**
  String get statsGameWordSearch;

  /// No description provided for @statsGameMaze.
  ///
  /// In pt, this message translates to:
  /// **'🌀 Labirinto'**
  String get statsGameMaze;

  /// No description provided for @statsGameSequence.
  ///
  /// In pt, this message translates to:
  /// **'🎵 Sequência'**
  String get statsGameSequence;

  /// No description provided for @statsGameTicTacToe.
  ///
  /// In pt, this message translates to:
  /// **'⭕ Jogo da Velha'**
  String get statsGameTicTacToe;

  /// No description provided for @statsGameMemory.
  ///
  /// In pt, this message translates to:
  /// **'🧠 Jogo da Memória'**
  String get statsGameMemory;

  /// No description provided for @playAgain.
  ///
  /// In pt, this message translates to:
  /// **'JOGAR NOVAMENTE'**
  String get playAgain;

  /// No description provided for @welcomeStart.
  ///
  /// In pt, this message translates to:
  /// **'Começar'**
  String get welcomeStart;

  /// No description provided for @quizNext.
  ///
  /// In pt, this message translates to:
  /// **'Próxima'**
  String get quizNext;

  /// No description provided for @quizScore.
  ///
  /// In pt, this message translates to:
  /// **'Pontuação'**
  String get quizScore;

  /// No description provided for @quizPresenter.
  ///
  /// In pt, this message translates to:
  /// **'Apresentador'**
  String get quizPresenter;

  /// No description provided for @pieQuizPlayer.
  ///
  /// In pt, this message translates to:
  /// **'Jogador {number}'**
  String pieQuizPlayer(int number);

  /// No description provided for @pieQuizShowAnswer.
  ///
  /// In pt, this message translates to:
  /// **'👁️ Ver Resposta'**
  String get pieQuizShowAnswer;

  /// No description provided for @pieQuizHideAnswer.
  ///
  /// In pt, this message translates to:
  /// **'Ocultar Resposta'**
  String get pieQuizHideAnswer;

  /// No description provided for @pieQuizNextQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Próxima Pergunta'**
  String get pieQuizNextQuestion;

  /// No description provided for @pieQuizFinalResult.
  ///
  /// In pt, this message translates to:
  /// **'Ver Resultado Final'**
  String get pieQuizFinalResult;

  /// No description provided for @difficultyEasy.
  ///
  /// In pt, this message translates to:
  /// **'Fácil'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In pt, this message translates to:
  /// **'Médio'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In pt, this message translates to:
  /// **'Difícil'**
  String get difficultyHard;

  /// No description provided for @difficultyNormal.
  ///
  /// In pt, this message translates to:
  /// **'Normal'**
  String get difficultyNormal;

  /// No description provided for @pieEndGame.
  ///
  /// In pt, this message translates to:
  /// **'Fim do Jogo!'**
  String get pieEndGame;

  /// No description provided for @piePlayerWon.
  ///
  /// In pt, this message translates to:
  /// **'Jogador {number} Venceu!'**
  String piePlayerWon(int number);

  /// No description provided for @pieTie.
  ///
  /// In pt, this message translates to:
  /// **'Empate!'**
  String get pieTie;

  /// No description provided for @pieHome.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get pieHome;

  /// No description provided for @pieWhoGotIt.
  ///
  /// In pt, this message translates to:
  /// **'Quem acertou?'**
  String get pieWhoGotIt;

  /// No description provided for @pieCorrectAnswer.
  ///
  /// In pt, this message translates to:
  /// **'Resposta Correta:'**
  String get pieCorrectAnswer;

  /// No description provided for @sequenceRecord.
  ///
  /// In pt, this message translates to:
  /// **'Recorde'**
  String get sequenceRecord;

  /// No description provided for @sequenceCongrats.
  ///
  /// In pt, this message translates to:
  /// **'🎉 PARABÉNS! VOCÊ VENCEU! 🎉'**
  String get sequenceCongrats;

  /// No description provided for @sequenceCompletedAll.
  ///
  /// In pt, this message translates to:
  /// **'Você completou todos os 20 níveis!'**
  String get sequenceCompletedAll;

  /// No description provided for @sequenceReachedLevel.
  ///
  /// In pt, this message translates to:
  /// **'Você alcançou o nível {level}'**
  String sequenceReachedLevel(int level);

  /// No description provided for @sequencePlayAgain.
  ///
  /// In pt, this message translates to:
  /// **'Jogar Novamente'**
  String get sequencePlayAgain;

  /// No description provided for @sequenceStartGame.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar Jogo'**
  String get sequenceStartGame;

  /// No description provided for @wordSearchFoundAll.
  ///
  /// In pt, this message translates to:
  /// **'Você encontrou todas as palavras em {seconds} segundos!'**
  String wordSearchFoundAll(int seconds);

  /// No description provided for @memoryNewGame.
  ///
  /// In pt, this message translates to:
  /// **'Nova Partida'**
  String get memoryNewGame;

  /// No description provided for @memoryHome.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get memoryHome;

  /// No description provided for @memoryConfigureGame.
  ///
  /// In pt, this message translates to:
  /// **'Configurar Jogo'**
  String get memoryConfigureGame;

  /// No description provided for @memoryMoves.
  ///
  /// In pt, this message translates to:
  /// **'Jogadas'**
  String get memoryMoves;

  /// No description provided for @memoryPairs.
  ///
  /// In pt, this message translates to:
  /// **'Pares'**
  String get memoryPairs;

  /// No description provided for @memoryTime.
  ///
  /// In pt, this message translates to:
  /// **'Tempo'**
  String get memoryTime;

  /// No description provided for @memoryDifficulty.
  ///
  /// In pt, this message translates to:
  /// **'Dificuldade'**
  String get memoryDifficulty;

  /// No description provided for @memoryCongrats.
  ///
  /// In pt, this message translates to:
  /// **'🎉 Parabéns!'**
  String get memoryCongrats;

  /// No description provided for @memoryFoundAllPairs.
  ///
  /// In pt, this message translates to:
  /// **'Você encontrou todos os pares!'**
  String get memoryFoundAllPairs;

  /// No description provided for @ticTacToeOpponentTurn.
  ///
  /// In pt, this message translates to:
  /// **'Vez do oponente'**
  String get ticTacToeOpponentTurn;

  /// No description provided for @ticTacToeYouWin.
  ///
  /// In pt, this message translates to:
  /// **'Você venceu!'**
  String get ticTacToeYouWin;

  /// No description provided for @ticTacToeYouLose.
  ///
  /// In pt, this message translates to:
  /// **'Você perdeu!'**
  String get ticTacToeYouLose;

  /// No description provided for @ticTacToeDraw.
  ///
  /// In pt, this message translates to:
  /// **'Empate!'**
  String get ticTacToeDraw;

  /// No description provided for @jigsawTitle.
  ///
  /// In pt, this message translates to:
  /// **'Quebra-Cabeça'**
  String get jigsawTitle;

  /// No description provided for @jigsawLoadFromGallery.
  ///
  /// In pt, this message translates to:
  /// **'Carregar da Galeria'**
  String get jigsawLoadFromGallery;

  /// No description provided for @jigsawOrChooseImage.
  ///
  /// In pt, this message translates to:
  /// **'Ou escolha uma imagem:'**
  String get jigsawOrChooseImage;

  /// No description provided for @jigsawGalleryError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao abrir galeria. Verifique as permissões.'**
  String get jigsawGalleryError;

  /// No description provided for @jigsawPieces.
  ///
  /// In pt, this message translates to:
  /// **'peças'**
  String get jigsawPieces;

  /// No description provided for @jigsawComplete.
  ///
  /// In pt, this message translates to:
  /// **'Quebra-cabeça completo!'**
  String get jigsawComplete;

  /// No description provided for @achievementsTitle2.
  ///
  /// In pt, this message translates to:
  /// **'Conquistas'**
  String get achievementsTitle2;

  /// No description provided for @achievementsAll.
  ///
  /// In pt, this message translates to:
  /// **'Todas'**
  String get achievementsAll;

  /// No description provided for @achievementsLoadError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar conquistas'**
  String get achievementsLoadError;

  /// No description provided for @multiplayerOnlineMatch.
  ///
  /// In pt, this message translates to:
  /// **'Partida Online'**
  String get multiplayerOnlineMatch;

  /// No description provided for @multiplayerPlayRealtime.
  ///
  /// In pt, this message translates to:
  /// **'Jogue com seus amigos em tempo real!'**
  String get multiplayerPlayRealtime;

  /// No description provided for @multiplayerBeHost.
  ///
  /// In pt, this message translates to:
  /// **'Seja o anfitrião e convide amigos'**
  String get multiplayerBeHost;

  /// No description provided for @multiplayerEnterCode.
  ///
  /// In pt, this message translates to:
  /// **'Digite o código da sala'**
  String get multiplayerEnterCode;

  /// No description provided for @multiplayerInfo1.
  ///
  /// In pt, this message translates to:
  /// **'• Até 8 jogadores por sala'**
  String get multiplayerInfo1;

  /// No description provided for @multiplayerInfo2.
  ///
  /// In pt, this message translates to:
  /// **'• Perguntas simultâneas'**
  String get multiplayerInfo2;

  /// No description provided for @multiplayerInfo3.
  ///
  /// In pt, this message translates to:
  /// **'• Pontuação por velocidade'**
  String get multiplayerInfo3;

  /// No description provided for @multiplayerInfo4.
  ///
  /// In pt, this message translates to:
  /// **'• Ranking em tempo real'**
  String get multiplayerInfo4;

  /// No description provided for @multiplayerCreateRoom.
  ///
  /// In pt, this message translates to:
  /// **'Criar Sala'**
  String get multiplayerCreateRoom;

  /// No description provided for @multiplayerJoinRoom.
  ///
  /// In pt, this message translates to:
  /// **'Entrar em Sala'**
  String get multiplayerJoinRoom;

  /// No description provided for @multiplayerRoom.
  ///
  /// In pt, this message translates to:
  /// **'Sala'**
  String get multiplayerRoom;

  /// No description provided for @multiplayerRemovePlayer.
  ///
  /// In pt, this message translates to:
  /// **'Remover jogador?'**
  String get multiplayerRemovePlayer;

  /// No description provided for @multiplayerRemove.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get multiplayerRemove;

  /// No description provided for @multiplayerLeaveRoom.
  ///
  /// In pt, this message translates to:
  /// **'Sair da sala?'**
  String get multiplayerLeaveRoom;

  /// No description provided for @multiplayerLeave.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get multiplayerLeave;

  /// No description provided for @multiplayerEndRoom.
  ///
  /// In pt, this message translates to:
  /// **'Encerrar Sala?'**
  String get multiplayerEndRoom;

  /// No description provided for @multiplayerEnd.
  ///
  /// In pt, this message translates to:
  /// **'Encerrar'**
  String get multiplayerEnd;

  /// No description provided for @multiplayerAllDisconnected.
  ///
  /// In pt, this message translates to:
  /// **'Todos os jogadores serão desconectados.'**
  String get multiplayerAllDisconnected;

  /// No description provided for @multiplayerCodeCopied.
  ///
  /// In pt, this message translates to:
  /// **'Código copiado'**
  String get multiplayerCodeCopied;

  /// No description provided for @multiplayerShareCode.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhe o código {code} com seus amigos!'**
  String multiplayerShareCode(String code);

  /// No description provided for @multiplayerRoomClosed.
  ///
  /// In pt, this message translates to:
  /// **'Sala encerrada'**
  String get multiplayerRoomClosed;

  /// No description provided for @multiplayerRoomClosedHost.
  ///
  /// In pt, this message translates to:
  /// **'O anfitrião encerrou a sala.'**
  String get multiplayerRoomClosedHost;

  /// No description provided for @multiplayerShareCodeBtn.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar Código'**
  String get multiplayerShareCodeBtn;

  /// No description provided for @multiplayerStartGame.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar Jogo'**
  String get multiplayerStartGame;

  /// No description provided for @multiplayerWaitingPlayers.
  ///
  /// In pt, this message translates to:
  /// **'Aguardando jogadores...'**
  String get multiplayerWaitingPlayers;

  /// No description provided for @multiplayerHowItWorks.
  ///
  /// In pt, this message translates to:
  /// **'Como funciona?'**
  String get multiplayerHowItWorks;

  /// No description provided for @multiplayerUseSuggestion.
  ///
  /// In pt, this message translates to:
  /// **'Usar sugestão'**
  String get multiplayerUseSuggestion;

  /// No description provided for @multiplayerChooseAnother.
  ///
  /// In pt, this message translates to:
  /// **'Escolher outro'**
  String get multiplayerChooseAnother;

  /// No description provided for @multiplayerUnderstood.
  ///
  /// In pt, this message translates to:
  /// **'Entendi'**
  String get multiplayerUnderstood;

  /// No description provided for @multiplayerQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Pergunta'**
  String get multiplayerQuestion;

  /// No description provided for @multiplayerRoundResults.
  ///
  /// In pt, this message translates to:
  /// **'Resultados da Rodada'**
  String get multiplayerRoundResults;

  /// No description provided for @multiplayerCorrect.
  ///
  /// In pt, this message translates to:
  /// **'Acertou!'**
  String get multiplayerCorrect;

  /// No description provided for @multiplayerWrong.
  ///
  /// In pt, this message translates to:
  /// **'Errou'**
  String get multiplayerWrong;

  /// No description provided for @multiplayerPosition.
  ///
  /// In pt, this message translates to:
  /// **'Posição'**
  String get multiplayerPosition;

  /// No description provided for @multiplayerPoints.
  ///
  /// In pt, this message translates to:
  /// **'Pontos'**
  String get multiplayerPoints;

  /// No description provided for @multiplayerCurrentRanking.
  ///
  /// In pt, this message translates to:
  /// **'Ranking Atual'**
  String get multiplayerCurrentRanking;

  /// No description provided for @multiplayerNextQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Próxima Pergunta'**
  String get multiplayerNextQuestion;

  /// No description provided for @multiplayerWaitingHost.
  ///
  /// In pt, this message translates to:
  /// **'Aguardando o anfitrião...'**
  String get multiplayerWaitingHost;

  /// No description provided for @multiplayerYourNickname.
  ///
  /// In pt, this message translates to:
  /// **'Seu apelido'**
  String get multiplayerYourNickname;

  /// No description provided for @multiplayerRoomCode.
  ///
  /// In pt, this message translates to:
  /// **'Código da sala'**
  String get multiplayerRoomCode;

  /// No description provided for @multiplayerPlayers.
  ///
  /// In pt, this message translates to:
  /// **'Jogadores'**
  String get multiplayerPlayers;

  /// No description provided for @multiplayerHost.
  ///
  /// In pt, this message translates to:
  /// **'Anfitrião'**
  String get multiplayerHost;

  /// No description provided for @multiplayerGameOver.
  ///
  /// In pt, this message translates to:
  /// **'Fim de Jogo!'**
  String get multiplayerGameOver;

  /// No description provided for @multiplayerCongrats.
  ///
  /// In pt, this message translates to:
  /// **'Parabéns! Você venceu! 🎉'**
  String get multiplayerCongrats;

  /// No description provided for @multiplayerMatchEnded.
  ///
  /// In pt, this message translates to:
  /// **'Partida finalizada'**
  String get multiplayerMatchEnded;

  /// No description provided for @multiplayerRestarting.
  ///
  /// In pt, this message translates to:
  /// **'Reiniciando...'**
  String get multiplayerRestarting;

  /// No description provided for @multiplayerPlayAgainBtn.
  ///
  /// In pt, this message translates to:
  /// **'Jogar Novamente'**
  String get multiplayerPlayAgainBtn;

  /// No description provided for @multiplayerCloseRoom.
  ///
  /// In pt, this message translates to:
  /// **'Encerrar Sala'**
  String get multiplayerCloseRoom;

  /// No description provided for @multiplayerRestartingMatch.
  ///
  /// In pt, this message translates to:
  /// **'Reiniciando partida...'**
  String get multiplayerRestartingMatch;

  /// No description provided for @multiplayerWaitingHostDecision.
  ///
  /// In pt, this message translates to:
  /// **'Aguardando decisão do anfitrião...'**
  String get multiplayerWaitingHostDecision;
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
