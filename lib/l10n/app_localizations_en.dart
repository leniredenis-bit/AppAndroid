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
  String get pieces => 'Pieces';

  @override
  String get level => 'Level';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get attempts => 'Attempts';

  @override
  String get victory => 'Victory!';

  @override
  String get defeat => 'Defeat';

  @override
  String get complete => 'COMPLETE!';

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
  String get homeQuizClassic => 'Classic Quiz';

  @override
  String get homeQuizClassicDesc => 'Answer questions and score points!';

  @override
  String get homeQuizPie => 'Pie Face Quiz';

  @override
  String get homeQuizPieDesc => 'Local 1v1 duel - wrong answer loses!';

  @override
  String get homeOnlineMatch => 'Online Match';

  @override
  String get homeOnlineMatchDesc => 'Play with friends in real time!';

  @override
  String get homeMinigames => 'Minigames';

  @override
  String get homeMinigamesDesc => 'Fun games await you!';

  @override
  String get homeStats => 'Statistics';

  @override
  String get homeStatsDesc => 'See your performance and achievements!';

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
  String get minigamesMemory => '🧠 Memory Game';

  @override
  String get minigamesMemoryDesc => 'Find biblical pairs!';

  @override
  String get minigamesPuzzle => '🧩 Jigsaw Puzzle';

  @override
  String get minigamesPuzzleDesc => 'Complete the puzzle';

  @override
  String get minigamesJigsaw => '🖼️ Photo Puzzle';

  @override
  String get minigamesJigsawDesc => 'Assemble real images!';

  @override
  String get minigamesHangman => '🎯 Bible Hangman';

  @override
  String get minigamesHangmanDesc => 'Guess the biblical word!';

  @override
  String get minigamesWordSearch => '🔍 Word Search';

  @override
  String get minigamesWordSearchDesc => 'Find hidden words!';

  @override
  String get minigamesMaze => '🌀 Maze';

  @override
  String get minigamesMazeDesc => 'Find the exit!';

  @override
  String get minigamesSequence => '� Quick Sequence';

  @override
  String get minigamesSequenceDesc => 'Memorize the color pattern!';

  @override
  String get minigamesSequenceCrystal => '💠 Crystal Sequence';

  @override
  String get minigamesSequenceCrystalDesc => 'Crystal version with sparkles!';

  @override
  String get minigamesTicTacToe => '⭕ Tic-Tac-Toe';

  @override
  String get minigamesTicTacToeDesc => '2 players or vs AI!';

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
  String get memoryGameStartGame => 'Start Game';

  @override
  String get memoryGameAttempts => 'Attempts';

  @override
  String get memoryGameMatches => 'Matches';

  @override
  String get memoryGameTime => 'Time';

  @override
  String memoryGamePlayerTurn(int player) {
    return 'Player $player\'s Turn';
  }

  @override
  String memoryGameScore(int score) {
    return 'Score: $score';
  }

  @override
  String get memoryGameCongrats => 'Congratulations! 🎉';

  @override
  String get memoryGamePlayAgain => 'Play Again';

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
  String get ticTacToeImpossible => 'Impossible';

  @override
  String get ticTacToePlayerX => 'Player X';

  @override
  String get ticTacToePlayerO => 'Player O';

  @override
  String get ticTacToeYourTurn => 'Your turn!';

  @override
  String get ticTacToeWins => 'Wins';

  @override
  String get ticTacToeDraws => 'Draws';

  @override
  String get ticTacToeResetScores => 'Reset Scores';

  @override
  String get ticTacToeNewGame => 'New Game';

  @override
  String get hangmanTitle => 'Hangman';

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
  String get hangmanTheWordWas => 'The word was:';

  @override
  String get hangmanPlayAgain => 'Play Again';

  @override
  String hangmanErrors(int errors, int max) {
    return 'Errors: $errors / $max';
  }

  @override
  String get hangmanCongrats => '🎉 Congratulations! You got it!';

  @override
  String get hangmanYouLost => '😢 You lost!';

  @override
  String hangmanWordWas(String word) {
    return 'The word was: $word';
  }

  @override
  String hangmanWrongLetters(String letters) {
    return 'Wrong letters: $letters';
  }

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
  String get wordSearchComplete => 'Completed! 🎉';

  @override
  String get wordSearchNewGame => 'New Game';

  @override
  String get mazeTitle => '🌀 Maze';

  @override
  String get mazeMoves => 'Moves: null';

  @override
  String mazeMovesCount(int count) {
    return 'Moves: $count';
  }

  @override
  String get mazeTime => 'Time: null';

  @override
  String get mazeControls => 'Use arrows to move';

  @override
  String get mazeUseButtons => 'Use the buttons or arrow keys';

  @override
  String get mazeGoal => 'Find the exit!';

  @override
  String get mazeVictory => 'You found the exit!';

  @override
  String get mazePlayAgain => 'Play Again';

  @override
  String get mazeCavern => '🏔️ Maze Cavern';

  @override
  String mazeCampaignMode(int level) {
    return 'Campaign Mode (Level $level)';
  }

  @override
  String get mazeQuickPlayCustom => 'Custom Quick Play';

  @override
  String mazeRows(int count) {
    return 'Rows: $count';
  }

  @override
  String mazeColumns(int count) {
    return 'Columns: $count';
  }

  @override
  String get mazePlayQuick => 'Play Quick Game';

  @override
  String get mazeEscaped => '✨ ESCAPED! ✨';

  @override
  String mazeCompletedIn(int moves) {
    return 'You completed the maze in $moves moves.';
  }

  @override
  String get mazeBackToMenu => 'Back to Menu';

  @override
  String mazeLevelComplete(int level) {
    return 'Level $level Complete!';
  }

  @override
  String get mazeLoadingNextCavern => 'Loading next cavern...';

  @override
  String get sequenceTitle => '🎯 Sequence';

  @override
  String get sequenceLevel => 'Level: null';

  @override
  String get sequenceHighScore => 'High Score: null';

  @override
  String get sequenceWatchSequence => 'Watch the sequence...';

  @override
  String get sequenceYourTurn => 'Your turn!';

  @override
  String get sequenceGameOver => 'Game Over!';

  @override
  String sequenceReached(int level) {
    return 'You reached level $level!';
  }

  @override
  String get sequenceNewRecord => 'New record!';

  @override
  String get sequenceTryAgain => 'Try Again';

  @override
  String sequenceActiveColors(int active, int max) {
    return 'ACTIVE COLORS: $active / $max';
  }

  @override
  String sequenceStreak(int current, int target) {
    return 'STREAK: $current / $target';
  }

  @override
  String get sequenceCorrect => '✨ Correct! Next Level! ✨';

  @override
  String get sequenceObserve => '👀 Watch the sequence...';

  @override
  String get sequenceRepeat => '👆 Your turn! Repeat the sequence';

  @override
  String sequenceGameOverLevel(int level) {
    return '❌ Game Over! You reached level $level';
  }

  @override
  String get sequenceRestartGame => 'Restart Game';

  @override
  String get sequenceStartDifficulty => 'Start/Difficulty';

  @override
  String get sequenceChooseDifficulty => 'Choose Difficulty';

  @override
  String sequenceEasyColors(int count) {
    return 'Easy ($count Colors)';
  }

  @override
  String sequenceMediumColors(int count) {
    return 'Medium ($count Colors)';
  }

  @override
  String sequenceHardColors(int count) {
    return 'Hard ($count Colors)';
  }

  @override
  String sequenceProgressive(int start, int end) {
    return 'PROGRESSIVE ($start -> $end Colors)';
  }

  @override
  String sequenceProgressiveDesc(int count) {
    return 'Adds one color every $count consecutive correct answers.';
  }

  @override
  String sequenceHighScoreLabel(int score) {
    return 'High Score: $score';
  }

  @override
  String get colorRed => 'Red';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get colorPurple => 'Purple';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorCyan => 'Cyan';

  @override
  String get colorLime => 'Lime';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorLocked => 'Locked';

  @override
  String get puzzleTitle => '🧩 Puzzle';

  @override
  String get puzzleMoves => 'Moves: null';

  @override
  String get puzzleDragPieces => 'Drag the pieces to solve the puzzle';

  @override
  String get puzzleComplete => 'Puzzle completed!';

  @override
  String get puzzleNewGame => 'New Game';

  @override
  String completedInMoves(Object moves) {
    return 'Completed in $moves moves';
  }

  @override
  String get newGame => 'New Game';
}
