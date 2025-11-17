// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'JW SPLASH GAMES';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get start => 'Start';

  @override
  String get restart => 'Restart';

  @override
  String get continue_ => 'Continue';

  @override
  String get score => 'Score';

  @override
  String get time => 'Time';

  @override
  String get moves => 'Moves';

  @override
  String get attempts => 'Attempts';

  @override
  String get victory => 'Victory!';

  @override
  String get defeat => 'Defeat';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get homeWelcome => 'Welcome to';

  @override
  String get homeSubtitle => 'Learn and have fun!';

  @override
  String get playQuiz => '🎯 Play Quiz';

  @override
  String get playMinigames => '🎮 Minigames';

  @override
  String get viewStats => '📊 Statistics';

  @override
  String get settings => '⚙️ Settings';

  @override
  String get about => 'ℹ️ About';

  @override
  String get quizModeSelection => 'Choose Mode';

  @override
  String get quizModeNormal => 'Normal';

  @override
  String get quizModeNormalDesc => 'Standard quiz with timer';

  @override
  String get quizModeStudy => 'Study';

  @override
  String get quizModeStudyDesc => 'No time pressure';

  @override
  String get quizModeFast => 'Fast';

  @override
  String get quizModeFastDesc => 'Race against the clock';

  @override
  String get quizQuestion => 'Question';

  @override
  String get quizExplanation => '📖 Explanation';

  @override
  String quizNextIn(int seconds) {
    return 'Next question in ${seconds}s...';
  }

  @override
  String get quizFinished => 'Quiz Finished!';

  @override
  String get quizExcellent => 'Excellent!';

  @override
  String get quizVeryGood => 'Very Good!';

  @override
  String get quizGoodJob => 'Good Job!';

  @override
  String get quizKeepPracticing => 'Keep Practicing!';

  @override
  String get quizCorrectAnswers => 'Correct';

  @override
  String get quizAccuracy => 'Accuracy';

  @override
  String get quizBackToMenu => 'Back to Menu';

  @override
  String get quizDifficultyEasy => 'EASY';

  @override
  String get quizDifficultyMedium => 'MEDIUM';

  @override
  String get quizDifficultyHard => 'HARD';

  @override
  String get minigamesTitle => '🎮 Bible Minigames';

  @override
  String get minigamesPuzzle => '🧩 Jigsaw Puzzle';

  @override
  String get minigamesPuzzleDesc => 'Complete the puzzle';

  @override
  String get minigamesHangman => '🎯 Bible Hangman';

  @override
  String get minigamesHangmanDesc => 'Guess the word';

  @override
  String get minigamesWordSearch => '🔍 Word Search';

  @override
  String get minigamesWordSearchDesc => 'Find the words';

  @override
  String get minigamesMaze => '🗺️ Maze';

  @override
  String get minigamesMazeDesc => 'Find the exit';

  @override
  String get minigamesSequence => '🎵 Sequence';

  @override
  String get minigamesSequenceDesc => 'Repeat the sequence';

  @override
  String get minigamesTicTacToe => '⭕ Tic-Tac-Toe';

  @override
  String get minigamesTicTacToeDesc => 'Against AI';

  @override
  String get achievementsTitle => '🏆 Achievements';

  @override
  String achievementsUnlocked(int count) {
    return '$count Unlocked';
  }

  @override
  String achievementsProgress(int percent) {
    return 'Progress: $percent%';
  }

  @override
  String get achievementsCategoryAll => 'All';

  @override
  String get achievementsCategoryQuiz => 'Quiz';

  @override
  String get achievementsCategoryMinigames => 'Minigames';

  @override
  String get achievementsCategorySocial => 'Social';

  @override
  String get achievementsCategoryMaster => 'Master';

  @override
  String get achievementUnlocked => 'Achievement Unlocked!';

  @override
  String achievementUnlockedAt(String date) {
    return 'Unlocked on $date';
  }

  @override
  String get achPrimeiroPasso => 'First Step';

  @override
  String get achPrimeiroPassoDesc => 'Complete your first quiz';

  @override
  String get achEstudioso => 'Scholar';

  @override
  String get achEstudiosoDesc => 'Complete 10 quizzes';

  @override
  String get achPerfeccionista => 'Perfectionist';

  @override
  String get achPerfeccionistaDesc => 'Get 100% correct answers';

  @override
  String get achVelocista => 'Speedster';

  @override
  String get achVelocistaDesc => 'Complete quiz in under 2 minutes';

  @override
  String get achSequenciaPerfeita => 'Perfect Streak';

  @override
  String get achSequenciaPerfeitaDesc => '5 quizzes in a row with 80%+';

  @override
  String get achMestreBiblico => 'Bible Master';

  @override
  String get achMestreBiblicoDesc => 'Complete 50 quizzes';

  @override
  String get achExplorador => 'Explorer';

  @override
  String get achExploradorDesc => 'Play all minigames';

  @override
  String get achMestrePuzzles => 'Puzzle Master';

  @override
  String get achMestrePuzzlesDesc => 'Complete puzzle in <2min';

  @override
  String get achMemoriaFotografica => 'Photographic Memory';

  @override
  String get achMemoriaFotograficaDesc => 'Memory game with no mistakes';

  @override
  String get achAtiradorElite => 'Elite Sharpshooter';

  @override
  String get achAtiradorEliteDesc => '10 wins at Tic-Tac-Toe';

  @override
  String get achCampeaoMinigames => 'Minigame Champion';

  @override
  String get achCampeaoMinigamesDesc => 'Win each minigame 3 times';

  @override
  String get achSocial => 'Social';

  @override
  String get achSocialDesc => 'Share your result';

  @override
  String get achCompetidor => 'Competitor';

  @override
  String get achCompetidorDesc => 'Complete 5 multiplayer matches';

  @override
  String get achColecionador => 'Collector';

  @override
  String get achColecionadorDesc => 'Unlock 10 achievements';

  @override
  String get achLenda => 'Legend';

  @override
  String get achLendaDesc => 'Unlock all achievements';

  @override
  String get settingsTitle => '⚙️ Settings';

  @override
  String get settingsAudio => '🔊 Audio';

  @override
  String get settingsMusic => 'Music';

  @override
  String get settingsSoundEffects => 'Sound Effects';

  @override
  String get settingsLanguage => '🌍 Language';

  @override
  String get settingsLanguagePortuguese => '🇧🇷 Portuguese';

  @override
  String get settingsLanguageEnglish => '🇺🇸 English';

  @override
  String get settingsLanguageSpanish => '🇪🇸 Spanish';

  @override
  String get settingsTheme => '🎨 Theme';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsHapticFeedback => '📳 Haptic Feedback';

  @override
  String get settingsShowTutorial => '📚 Tutorial';

  @override
  String get settingsAchievements => '🏆 Achievements';

  @override
  String get settingsStatistics => '📊 Statistics';

  @override
  String get settingsAbout => 'ℹ️ About';

  @override
  String get statsTitle => '📊 Statistics';

  @override
  String get statsGlobal => 'Global';

  @override
  String get statsTotalQuizzes => 'Total Quizzes';

  @override
  String get statsTotalQuestions => 'Total Questions';

  @override
  String get statsCorrectAnswers => 'Correct Answers';

  @override
  String get statsWrongAnswers => 'Wrong Answers';

  @override
  String get statsAccuracy => 'Accuracy';

  @override
  String get statsHighScore => 'High Score';

  @override
  String get statsCurrentStreak => 'Current Streak';

  @override
  String get statsLongestStreak => 'Longest Streak';

  @override
  String get statsHistory => 'History';

  @override
  String get statsMinigameRecords => 'Minigame Records';

  @override
  String get statsNoData => 'No data available yet';

  @override
  String get statsPlayToSeeData => 'Play to see your statistics!';

  @override
  String get errorLoadingQuestions => 'Error loading questions';

  @override
  String get errorNoQuestions => 'No questions available';

  @override
  String get errorGeneric => 'An error occurred. Please try again.';

  @override
  String get errorConnection => 'Connection error. Check your internet.';

  @override
  String get gameWon => 'You won!';

  @override
  String get gameLost => 'You lost!';

  @override
  String get gameDraw => 'Draw!';

  @override
  String get gamePaused => 'Game Paused';

  @override
  String get gameResume => 'Resume';

  @override
  String get gameQuit => 'Quit';

  @override
  String get gameCompleted => 'Completed!';

  @override
  String gameTimeElapsed(String time) {
    return 'Time elapsed: $time';
  }
}
