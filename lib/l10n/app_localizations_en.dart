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
  String get homeDifficulty => 'Difficulty';

  @override
  String get homeCategories => 'Categories';

  @override
  String homeShowMore(int count) {
    return 'Show more ($count+)';
  }

  @override
  String get homeShowLess => 'Show less';

  @override
  String get homeNoQuestionsFound => 'No questions found with these filters!';

  @override
  String homeLoadingError(String error) {
    return 'Error loading questions: $error';
  }

  @override
  String homeLoadingCategoriesError(String error) {
    return 'Error loading categories: $error';
  }

  @override
  String homeThemeActivated(String theme) {
    return '$theme theme activated!';
  }

  @override
  String get homeThemeDark => 'dark';

  @override
  String get homeThemeLight => 'light';

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
  String quizTitle(int current, int total) {
    return 'Quiz - $current/$total';
  }

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
  String get bibleReadFullText => 'Tap to read the full text';

  @override
  String get bibleOpenError => 'Could not open the reference.';

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

  @override
  String get memoryGameTitle => '🧠 Memory Game';

  @override
  String get memoryGameDifficulty => 'Difficulty';

  @override
  String get memoryGameEasy => 'Easy (4x4)';

  @override
  String get memoryGameMedium => 'Medium (6x6)';

  @override
  String get memoryGameHard => 'Hard (8x8)';

  @override
  String get memoryGameTheme => 'Theme';

  @override
  String get memoryGamePlayers => 'Players';

  @override
  String get memoryGameStartGame => 'Iniciar Jogo';

  @override
  String get memoryGameAttempts => 'Attempts';

  @override
  String get memoryGameMatches => 'Matches';

  @override
  String get memoryGameTime => 'Tempo';

  @override
  String memoryGamePlayerTurn(int player) {
    return 'Vez do Jogador $player';
  }

  @override
  String memoryGameScore(int score) {
    return 'Score: $score';
  }

  @override
  String get memoryGameCongrats => 'Parabéns! 🎉';

  @override
  String get memoryGamePlayAgain => 'Jogar Novamente';

  @override
  String get ticTacToeTitle => '⭕❌ Tic-Tac-Toe';

  @override
  String get ticTacToeMode => 'Mode';

  @override
  String get ticTacToeTwoPlayers => 'Two Players';

  @override
  String get ticTacToeVsAI => 'vs AI';

  @override
  String get ticTacToeDifficulty => 'Difficulty';

  @override
  String get ticTacToeEasy => 'Easy';

  @override
  String get ticTacToeImpossible => 'Impossível';

  @override
  String get ticTacToePlayerX => 'Player X';

  @override
  String get ticTacToePlayerO => 'Player O';

  @override
  String get ticTacToeYourTurn => 'Sua vez!';

  @override
  String get ticTacToeWins => 'Wins';

  @override
  String get ticTacToeDraws => 'Draws';

  @override
  String get ticTacToeResetScores => 'Resetar Placar';

  @override
  String get ticTacToeNewGame => 'Novo Jogo';

  @override
  String get hangmanTitle => '🔤 Hangman';

  @override
  String get hangmanCategory => 'Category';

  @override
  String get hangmanAttempts => 'Attempts remaining: null';

  @override
  String get hangmanGuess => 'Guess the letter';

  @override
  String get hangmanWin => 'Congratulations! You won!';

  @override
  String get hangmanLose => 'Game over! The word was: null';

  @override
  String get hangmanTheWordWas => 'A palavra era:';

  @override
  String get hangmanPlayAgain => 'Jogar Novamente';

  @override
  String get wordSearchTitle => '🔍 Word Search';

  @override
  String wordSearchWordsFound(int found, int total) {
    return 'Words found: $found/$total';
  }

  @override
  String wordSearchTimeElapsed(String time) {
    return 'Time: $time';
  }

  @override
  String get wordSearchComplete => 'Completado! 🎉';

  @override
  String get wordSearchNewGame => 'Novo Jogo';

  @override
  String get mazeTitle => '🌀 Maze';

  @override
  String get mazeMoves => 'Moves: null';

  @override
  String get mazeTime => 'Time: null';

  @override
  String get mazeControls => 'Use arrows to move';

  @override
  String get mazeUseButtons => 'Use os botões ou teclas de seta';

  @override
  String get mazeGoal => 'Encontre a saída!';

  @override
  String get mazeVictory => 'You found the exit!';

  @override
  String get mazePlayAgain => 'Jogar Novamente';

  @override
  String get sequenceTitle => '🎯 Sequence';

  @override
  String get sequenceLevel => 'Level: null';

  @override
  String get sequenceHighScore => 'High Score: null';

  @override
  String get sequenceWatchSequence => 'Observe a sequência...';

  @override
  String get sequenceYourTurn => 'Your turn!';

  @override
  String get sequenceGameOver => 'Game Over!';

  @override
  String sequenceReached(int level) {
    return 'Você chegou ao nível $level!';
  }

  @override
  String get sequenceNewRecord => 'New record!';

  @override
  String get sequenceTryAgain => 'Tentar Novamente';

  @override
  String get puzzleTitle => '🧩 Puzzle';

  @override
  String get puzzleMoves => 'Moves: null';

  @override
  String get puzzleDragPieces => 'Drag the pieces to solve the puzzle';

  @override
  String get puzzleComplete => 'Puzzle completed!';

  @override
  String get puzzleNewGame => 'Novo Jogo';
}
