// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'JW SPLASH GAMES';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Cerrar';

  @override
  String get back => 'Volver';

  @override
  String get next => 'Siguiente';

  @override
  String get start => 'Iniciar';

  @override
  String get restart => 'Reiniciar';

  @override
  String get continue_ => 'Continuar';

  @override
  String get score => 'Puntuación';

  @override
  String get time => 'Tiempo';

  @override
  String get moves => 'Movimientos';

  @override
  String get pieces => 'Piezas';

  @override
  String get level => 'Nivel';

  @override
  String get difficulty => 'Dificultad';

  @override
  String get easy => 'Fácil';

  @override
  String get medium => 'Medio';

  @override
  String get hard => 'Difícil';

  @override
  String get attempts => 'Intentos';

  @override
  String get victory => '¡Victoria!';

  @override
  String get defeat => 'Derrota';

  @override
  String get complete => '¡COMPLETO!';

  @override
  String get tryAgain => 'Intentar de Nuevo';

  @override
  String get homeWelcome => 'Bienvenido a';

  @override
  String get homeSubtitle => '¡Aprende y diviértete!';

  @override
  String get homeDifficulty => 'Dificultad';

  @override
  String get homeCategories => 'Categorías';

  @override
  String homeShowMore(int count) {
    return 'Ver más ($count+)';
  }

  @override
  String get homeShowLess => 'Ver menos';

  @override
  String get homeNoQuestionsFound =>
      '¡No se encontraron preguntas con estos filtros!';

  @override
  String homeLoadingError(String error) {
    return 'Error al cargar preguntas: $error';
  }

  @override
  String homeLoadingCategoriesError(String error) {
    return 'Error al cargar categorías: $error';
  }

  @override
  String homeThemeActivated(String theme) {
    return '¡Tema $theme activado!';
  }

  @override
  String get homeThemeDark => 'oscuro';

  @override
  String get homeThemeLight => 'claro';

  @override
  String get homeQuizClassic => 'Quiz Clásico';

  @override
  String get homeQuizClassicDesc => '¡Responde preguntas y suma puntos!';

  @override
  String get homeQuizPie => 'Quiz Pastelazo';

  @override
  String get homeQuizPieDesc => '¡Duelo 1v1 local - quien falla pierde!';

  @override
  String get homeOnlineMatch => 'Partida en Línea';

  @override
  String get homeOnlineMatchDesc => '¡Juega con amigos en tiempo real!';

  @override
  String get homeMinigames => 'Minijuegos';

  @override
  String get homeMinigamesDesc => '¡Juegos divertidos te esperan!';

  @override
  String get homeStats => 'Estadísticas';

  @override
  String get homeStatsDesc => '¡Mira tu rendimiento y logros!';

  @override
  String get playQuiz => '🎯 Jugar Quiz';

  @override
  String get playMinigames => '🎮 Minijuegos';

  @override
  String get viewStats => '📊 Estadísticas';

  @override
  String get settings => '⚙️ Configuración';

  @override
  String get about => 'ℹ️ Acerca de';

  @override
  String get quizModeSelection => 'Elige el Modo';

  @override
  String get quizModeNormal => 'Normal';

  @override
  String get quizModeNormalDesc => 'Quiz estándar con temporizador';

  @override
  String get quizModeStudy => 'Estudio';

  @override
  String get quizModeStudyDesc => 'Sin presión de tiempo';

  @override
  String get quizModeFast => 'Rápido';

  @override
  String get quizModeFastDesc => 'Carrera contra el reloj';

  @override
  String get quizQuestion => 'Pregunta';

  @override
  String quizTitle(int current, int total) {
    return 'Quiz - $current/$total';
  }

  @override
  String get quizExplanation => '📖 Explicación';

  @override
  String quizNextIn(int seconds) {
    return 'Siguiente pregunta en ${seconds}s...';
  }

  @override
  String get quizFinished => '¡Quiz Finalizado!';

  @override
  String get quizExcellent => '¡Excelente!';

  @override
  String get quizVeryGood => '¡Muy Bien!';

  @override
  String get quizGoodJob => '¡Buen Trabajo!';

  @override
  String get quizKeepPracticing => '¡Sigue Practicando!';

  @override
  String get quizCorrectAnswers => 'Aciertos';

  @override
  String get quizAccuracy => 'Precisión';

  @override
  String get quizBackToMenu => 'Volver al Menú';

  @override
  String get quizDifficultyEasy => 'FÁCIL';

  @override
  String get quizDifficultyMedium => 'MEDIO';

  @override
  String get quizDifficultyHard => 'DIFÍCIL';

  @override
  String get minigamesTitle => '🎮 Minijuegos Bíblicos';

  @override
  String get minigamesMemory => '🧠 Juego de Memoria';

  @override
  String get minigamesMemoryDesc => '¡Encuentra parejas bíblicas!';

  @override
  String get minigamesPuzzle => '🧩 Rompecabezas';

  @override
  String get minigamesPuzzleDesc => 'Completa el rompecabezas';

  @override
  String get minigamesJigsaw => '🖼️ Rompecabezas Foto';

  @override
  String get minigamesJigsawDesc => '¡Arma imágenes reales!';

  @override
  String get minigamesHangman => '🎯 Ahorcado Bíblico';

  @override
  String get minigamesHangmanDesc => '¡Adivina la palabra bíblica!';

  @override
  String get minigamesWordSearch => '🔍 Sopa de Letras';

  @override
  String get minigamesWordSearchDesc => '¡Encuentra palabras ocultas!';

  @override
  String get minigamesMaze => '🌀 Laberinto';

  @override
  String get minigamesMazeDesc => '¡Encuentra la salida!';

  @override
  String get minigamesSequence => '� Secuencia Rápida';

  @override
  String get minigamesSequenceDesc => '¡Memoriza el patrón de colores!';

  @override
  String get minigamesSequenceCrystal => '💠 Secuencia Cristal';

  @override
  String get minigamesSequenceCrystalDesc => '¡Versión cristal con brillos!';

  @override
  String get minigamesTicTacToe => '⭕ Tres en Raya';

  @override
  String get minigamesTicTacToeDesc => '¡2 jugadores o vs IA!';

  @override
  String get achievementsTitle => '🏆 Logros';

  @override
  String achievementsUnlocked(int count) {
    return '$count Desbloqueados';
  }

  @override
  String achievementsProgress(int percent) {
    return 'Progreso: $percent%';
  }

  @override
  String get achievementsCategoryAll => 'Todos';

  @override
  String get achievementsCategoryQuiz => 'Quiz';

  @override
  String get achievementsCategoryMinigames => 'Minijuegos';

  @override
  String get achievementsCategorySocial => 'Social';

  @override
  String get achievementsCategoryMaster => 'Maestro';

  @override
  String get achievementUnlocked => '¡Logro Desbloqueado!';

  @override
  String achievementUnlockedAt(String date) {
    return 'Desbloqueado el $date';
  }

  @override
  String get achPrimeiroPasso => 'Primer Paso';

  @override
  String get achPrimeiroPassoDesc => 'Completa tu primer quiz';

  @override
  String get achEstudioso => 'Estudioso';

  @override
  String get achEstudiosoDesc => 'Completa 10 quizzes';

  @override
  String get achPerfeccionista => 'Perfeccionista';

  @override
  String get achPerfeccionistaDesc => 'Responde correctamente al 100%';

  @override
  String get achVelocista => 'Velocista';

  @override
  String get achVelocistaDesc => 'Completa quiz en menos de 2 minutos';

  @override
  String get achSequenciaPerfeita => 'Racha Perfecta';

  @override
  String get achSequenciaPerfeitaDesc => '5 quizzes seguidos con 80%+';

  @override
  String get achMestreBiblico => 'Maestro Bíblico';

  @override
  String get achMestreBiblicoDesc => 'Completa 50 quizzes';

  @override
  String get achExplorador => 'Explorador';

  @override
  String get achExploradorDesc => 'Juega todos los minijuegos';

  @override
  String get achMestrePuzzles => 'Maestro de Rompecabezas';

  @override
  String get achMestrePuzzlesDesc => 'Completa rompecabezas en <2min';

  @override
  String get achMemoriaFotografica => 'Memoria Fotográfica';

  @override
  String get achMemoriaFotograficaDesc => 'Juego de memoria sin errores';

  @override
  String get achAtiradorElite => 'Tirador de Elite';

  @override
  String get achAtiradorEliteDesc => '10 victorias en Tres en Raya';

  @override
  String get achCampeaoMinigames => 'Campeón de Minijuegos';

  @override
  String get achCampeaoMinigamesDesc => 'Gana cada minijuego 3 veces';

  @override
  String get achSocial => 'Social';

  @override
  String get achSocialDesc => 'Comparte tu resultado';

  @override
  String get achCompetidor => 'Competidor';

  @override
  String get achCompetidorDesc => 'Completa 5 partidas multijugador';

  @override
  String get achColecionador => 'Coleccionista';

  @override
  String get achColecionadorDesc => 'Desbloquea 10 logros';

  @override
  String get achLenda => 'Leyenda';

  @override
  String get achLendaDesc => 'Desbloquea todos los logros';

  @override
  String get settingsTitle => '⚙️ Configuración';

  @override
  String get settingsAudio => '🔊 Audio';

  @override
  String get settingsMusic => 'Música';

  @override
  String get settingsSoundEffects => 'Efectos de Sonido';

  @override
  String get settingsLanguage => '🌍 Idioma';

  @override
  String get settingsLanguagePortuguese => '🇧🇷 Português';

  @override
  String get settingsLanguageEnglish => '🇺🇸 English';

  @override
  String get settingsLanguageSpanish => '🇪🇸 Español';

  @override
  String get settingsTheme => '🎨 Tema';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsHapticFeedback => '📳 Vibración';

  @override
  String get settingsShowTutorial => '📚 Tutorial';

  @override
  String get settingsAchievements => '🏆 Logros';

  @override
  String get settingsStatistics => '📊 Estadísticas';

  @override
  String get settingsAbout => 'ℹ️ Acerca de';

  @override
  String get statsTitle => '📊 Estadísticas';

  @override
  String get statsGlobal => 'Globales';

  @override
  String get statsTotalQuizzes => 'Total de Quizzes';

  @override
  String get statsTotalQuestions => 'Total de Preguntas';

  @override
  String get statsCorrectAnswers => 'Respuestas Correctas';

  @override
  String get statsWrongAnswers => 'Respuestas Incorrectas';

  @override
  String get statsAccuracy => 'Precisión';

  @override
  String get statsHighScore => 'Puntuación Máxima';

  @override
  String get statsCurrentStreak => 'Racha Actual';

  @override
  String get statsLongestStreak => 'Racha Más Larga';

  @override
  String get statsHistory => 'Historial';

  @override
  String get statsMinigameRecords => 'Récords de Minijuegos';

  @override
  String get statsNoData => 'Aún no hay datos disponibles';

  @override
  String get statsPlayToSeeData => '¡Juega para ver tus estadísticas!';

  @override
  String get errorLoadingQuestions => 'Error al cargar preguntas';

  @override
  String get errorNoQuestions => 'No hay preguntas disponibles';

  @override
  String get errorGeneric => 'Ocurrió un error. Inténtalo de nuevo.';

  @override
  String get errorConnection => 'Error de conexión. Verifica tu internet.';

  @override
  String get bibleReadFullText => 'Toca para leer el texto completo';

  @override
  String get bibleOpenError => 'No se pudo abrir la referencia.';

  @override
  String get gameWon => '¡Ganaste!';

  @override
  String get gameLost => '¡Perdiste!';

  @override
  String get gameDraw => '¡Empate!';

  @override
  String get gamePaused => 'Juego Pausado';

  @override
  String get gameResume => 'Reanudar';

  @override
  String get gameQuit => 'Salir';

  @override
  String get gameCompleted => '¡Completado!';

  @override
  String gameTimeElapsed(String time) {
    return 'Tiempo transcurrido: $time';
  }

  @override
  String get memoryGameTitle => '🧠 Juego de Memoria';

  @override
  String get memoryGameDifficulty => 'Dificultad';

  @override
  String get memoryGameEasy => 'Fácil (4x4)';

  @override
  String get memoryGameMedium => 'Medio (6x6)';

  @override
  String get memoryGameHard => 'Difícil (8x8)';

  @override
  String get memoryGameTheme => 'Tema';

  @override
  String get memoryGamePlayers => 'Jugadores';

  @override
  String get memoryGameStartGame => 'Iniciar Jogo';

  @override
  String get memoryGameAttempts => 'Intentos';

  @override
  String get memoryGameMatches => 'Aciertos';

  @override
  String get memoryGameTime => 'Tempo';

  @override
  String memoryGamePlayerTurn(int player) {
    return 'Vez do Jogador $player';
  }

  @override
  String memoryGameScore(int score) {
    return 'Puntuación: $score';
  }

  @override
  String get memoryGameCongrats => 'Parabéns! 🎉';

  @override
  String get memoryGamePlayAgain => 'Jogar Novamente';

  @override
  String get ticTacToeTitle => '⭕❌ Tres en Raya';

  @override
  String get ticTacToeMode => 'Modo';

  @override
  String get ticTacToeTwoPlayers => 'Dos Jugadores';

  @override
  String get ticTacToeVsAI => 'vs IA';

  @override
  String get ticTacToeDifficulty => 'Dificultad';

  @override
  String get ticTacToeEasy => 'Fácil';

  @override
  String get ticTacToeImpossible => 'Impossível';

  @override
  String get ticTacToePlayerX => 'Jugador X';

  @override
  String get ticTacToePlayerO => 'Jugador O';

  @override
  String get ticTacToeYourTurn => 'Sua vez!';

  @override
  String get ticTacToeWins => 'Victorias';

  @override
  String get ticTacToeDraws => 'Empates';

  @override
  String get ticTacToeResetScores => 'Resetar Placar';

  @override
  String get ticTacToeNewGame => 'Novo Jogo';

  @override
  String get hangmanTitle => 'Ahorcado';

  @override
  String get hangmanCategory => 'Categoría';

  @override
  String get hangmanAttempts => 'Intentos restantes: null';

  @override
  String get hangmanGuess => 'Adivina la letra';

  @override
  String get hangmanWin => '¡Felicitaciones! ¡Ganaste!';

  @override
  String get hangmanLose => '¡Juego terminado! La palabra era: null';

  @override
  String get hangmanTheWordWas => 'A palavra era:';

  @override
  String get hangmanPlayAgain => 'Jugar de Nuevo';

  @override
  String hangmanErrors(int errors, int max) {
    return 'Errores: $errors / $max';
  }

  @override
  String get hangmanCongrats => '🎉 ¡Felicidades! ¡Acertaste!';

  @override
  String get hangmanYouLost => '😢 ¡Perdiste!';

  @override
  String hangmanWordWas(String word) {
    return 'La palabra era: $word';
  }

  @override
  String hangmanWrongLetters(String letters) {
    return 'Letras incorrectas: $letters';
  }

  @override
  String get wordSearchTitle => '🔍 Sopa de Letras';

  @override
  String wordSearchWordsFound(int found, int total) {
    return 'Palabras encontradas: $found/$total';
  }

  @override
  String wordSearchTimeElapsed(String time) {
    return 'Tiempo: $time';
  }

  @override
  String get wordSearchComplete => 'Completado! 🎉';

  @override
  String get wordSearchNewGame => 'Novo Jogo';

  @override
  String get mazeTitle => '🌀 Laberinto';

  @override
  String get mazeMoves => 'Movimientos: null';

  @override
  String mazeMovesCount(int count) {
    return 'Movimientos: $count';
  }

  @override
  String get mazeTime => 'Tiempo: null';

  @override
  String get mazeControls => 'Usa las flechas para moverte';

  @override
  String get mazeUseButtons => 'Use os botões ou teclas de seta';

  @override
  String get mazeGoal => 'Encontre a saída!';

  @override
  String get mazeVictory => '¡Encontraste la salida!';

  @override
  String get mazePlayAgain => 'Jogar Novamente';

  @override
  String get mazeCavern => '🏔️ Caverna del Laberinto';

  @override
  String mazeCampaignMode(int level) {
    return 'Modo Campaña (Nivel $level)';
  }

  @override
  String get mazeQuickPlayCustom => 'Partida Rápida Personalizada';

  @override
  String mazeRows(int count) {
    return 'Filas: $count';
  }

  @override
  String mazeColumns(int count) {
    return 'Columnas: $count';
  }

  @override
  String get mazePlayQuick => 'Jugar Partida Rápida';

  @override
  String get mazeEscaped => '✨ ¡ESCAPASTE! ✨';

  @override
  String mazeCompletedIn(int moves) {
    return 'Completaste el laberinto en $moves movimientos.';
  }

  @override
  String get mazeBackToMenu => 'Volver al Menú';

  @override
  String mazeLevelComplete(int level) {
    return '¡Nivel $level Completado!';
  }

  @override
  String get mazeLoadingNextCavern => 'Cargando próxima caverna...';

  @override
  String get sequenceTitle => '🎯 Secuencia';

  @override
  String get sequenceLevel => 'Nivel: null';

  @override
  String get sequenceHighScore => 'Puntuación Máxima: null';

  @override
  String get sequenceWatchSequence => 'Observe a sequência...';

  @override
  String get sequenceYourTurn => '¡Tu turno!';

  @override
  String get sequenceGameOver => '¡Juego Terminado!';

  @override
  String sequenceReached(int level) {
    return 'Você chegou ao nível $level!';
  }

  @override
  String get sequenceNewRecord => '¡Nuevo récord!';

  @override
  String get sequenceTryAgain => 'Tentar Novamente';

  @override
  String sequenceActiveColors(int active, int max) {
    return 'COLORES ACTIVOS: $active / $max';
  }

  @override
  String sequenceStreak(int current, int target) {
    return 'RACHA: $current / $target';
  }

  @override
  String get sequenceCorrect => '✨ ¡Correcto! ¡Siguiente Nivel! ✨';

  @override
  String get sequenceObserve => '👀 Observa la secuencia...';

  @override
  String get sequenceRepeat => '👆 ¡Tu turno! Repite la secuencia';

  @override
  String sequenceGameOverLevel(int level) {
    return '❌ ¡Fin del Juego! Llegaste al nivel $level';
  }

  @override
  String get sequenceRestartGame => 'Reiniciar Juego';

  @override
  String get sequenceStartDifficulty => 'Iniciar/Dificultad';

  @override
  String get sequenceChooseDifficulty => 'Elige la Dificultad';

  @override
  String sequenceEasyColors(int count) {
    return 'Fácil ($count Colores)';
  }

  @override
  String sequenceMediumColors(int count) {
    return 'Medio ($count Colores)';
  }

  @override
  String sequenceHardColors(int count) {
    return 'Difícil ($count Colores)';
  }

  @override
  String sequenceProgressive(int start, int end) {
    return 'PROGRESIVO ($start -> $end Colores)';
  }

  @override
  String sequenceProgressiveDesc(int count) {
    return 'Añade un color cada $count aciertos seguidos.';
  }

  @override
  String sequenceHighScoreLabel(int score) {
    return 'Récord: $score';
  }

  @override
  String get colorRed => 'Rojo';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorYellow => 'Amarillo';

  @override
  String get colorPurple => 'Morado';

  @override
  String get colorOrange => 'Naranja';

  @override
  String get colorCyan => 'Cian';

  @override
  String get colorLime => 'Lima';

  @override
  String get colorPink => 'Rosa';

  @override
  String get colorLocked => 'Bloqueado';

  @override
  String get puzzleTitle => '🧩 Rompecabezas';

  @override
  String get puzzleMoves => 'Movimientos: null';

  @override
  String get puzzleDragPieces =>
      'Arrastra las piezas para resolver el rompecabezas';

  @override
  String get puzzleComplete => '¡Rompecabezas completado!';

  @override
  String get puzzleNewGame => 'Novo Jogo';

  @override
  String completedInMoves(Object moves) {
    return 'Completado en $moves movimientos';
  }

  @override
  String get newGame => 'Nueva Partida';
}
