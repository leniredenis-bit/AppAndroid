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
  String get quizAccuracy => 'Rendimiento';

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
  String get statsCurrentStreak => 'Racha\nActual';

  @override
  String get statsLongestStreak => 'Racha Más Larga';

  @override
  String get statsHistory => 'Historial';

  @override
  String get statsMinigameRecords => 'Récords de Minijuegos';

  @override
  String get statsNoData => 'No hay datos disponibles';

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
  String get memoryGameStartGame => 'Iniciar Juego';

  @override
  String get memoryGameAttempts => 'Intentos';

  @override
  String get memoryGameMatches => 'Aciertos';

  @override
  String get memoryGameTime => 'Tiempo';

  @override
  String memoryGamePlayerTurn(int player) {
    return 'Turno del Jugador $player';
  }

  @override
  String memoryGameScore(int score) {
    return 'Puntuación: $score';
  }

  @override
  String get memoryGameCongrats => '¡Felicidades! 🎉';

  @override
  String get memoryGamePlayAgain => 'Jugar de Nuevo';

  @override
  String get ticTacToeTitle => 'Tres en Raya Neón';

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
  String get ticTacToeImpossible => 'Imposible';

  @override
  String get ticTacToePlayerX => 'Jugador X';

  @override
  String get ticTacToePlayerO => 'Jugador O';

  @override
  String get ticTacToeYourTurn => 'Tu turno';

  @override
  String get ticTacToeWins => 'Victorias';

  @override
  String get ticTacToeDraws => 'Empates';

  @override
  String get ticTacToeResetScores => 'Resetear Marcador';

  @override
  String get ticTacToeNewGame => 'Nuevo Juego';

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
  String get hangmanTheWordWas => 'La palabra era:';

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
  String get wordSearchTitle => 'Sopa de Letras';

  @override
  String wordSearchWordsFound(int found, int total) {
    return 'Palabras encontradas: $found/$total';
  }

  @override
  String wordSearchTimeElapsed(String time) {
    return 'Tiempo: $time';
  }

  @override
  String get wordSearchComplete => '¡COMPLETO!';

  @override
  String get wordSearchNewGame => 'Nuevo Juego';

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
  String get mazeUseButtons => 'Usa los botones o las teclas de flecha';

  @override
  String get mazeGoal => '¡Encuentra la salida!';

  @override
  String get mazeVictory => '¡Encontraste la salida!';

  @override
  String get mazePlayAgain => 'Jugar de Nuevo';

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
  String get sequenceLevel => 'NIVEL';

  @override
  String get sequenceHighScore => 'Puntuación Máxima: null';

  @override
  String get sequenceWatchSequence => 'Observa la secuencia...';

  @override
  String get sequenceYourTurn => '¡Tu turno! Repite la secuencia';

  @override
  String get sequenceGameOver => '❌ ¡Fin del Juego!';

  @override
  String sequenceReached(int level) {
    return '¡Llegaste al nivel $level!';
  }

  @override
  String get sequenceNewRecord => '¡Nuevo récord!';

  @override
  String get sequenceTryAgain => 'Intentar de Nuevo';

  @override
  String sequenceActiveColors(int active, int max) {
    return 'COLORES ACTIVOS: $active / $max';
  }

  @override
  String sequenceStreak(int current, int target) {
    return 'RACHA: $current / $target';
  }

  @override
  String get sequenceCorrect => '✨ ¡Correcto! ✨';

  @override
  String get sequenceObserve => 'Observa la secuencia...';

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
  String get puzzleNewGame => 'Nuevo Juego';

  @override
  String completedInMoves(Object moves) {
    return 'Completado en $moves movimientos';
  }

  @override
  String get newGame => 'Nueva Partida';

  @override
  String get settingsLanguageChanged => '¡Idioma cambiado con éxito!';

  @override
  String get settingsMusicVolume => '🎵 Volumen de Música';

  @override
  String get settingsSfxVolume => '🔊 Volumen de Efectos';

  @override
  String get settingsAchievementsSubtitle => 'Ver tus logros desbloqueados';

  @override
  String get settingsStatisticsSubtitle => 'Ver tu rendimiento';

  @override
  String get settingsTerms => '📜 Términos y Condiciones';

  @override
  String get settingsTermsSubtitle => 'Política de privacidad y términos';

  @override
  String get settingsAboutSubtitle => 'Información sobre la aplicación';

  @override
  String get settingsSupport => '💬 Ayuda y Soporte';

  @override
  String get settingsSupportSubtitle =>
      'Contáctanos, envía comentarios o preguntas';

  @override
  String get termsTitle => 'ℹ️ Términos y Condiciones';

  @override
  String get termsOfUse => '📋 Términos de Uso';

  @override
  String get termsWelcome =>
      '¡Bienvenido a JW SPLASH GAMES! Esta aplicación fue desarrollada con fines educativos y de entretenimiento, con el objetivo de promover el conocimiento bíblico de forma interactiva.';

  @override
  String get termsAppUsage => '1. Uso de la Aplicación';

  @override
  String get termsAppUsageDesc =>
      'JW SPLASH GAMES es una aplicación gratuita para uso personal. Puedes:';

  @override
  String get termsAppUsageItem1 =>
      'Jugar cuestionarios individuales o en grupo';

  @override
  String get termsAppUsageItem2 => 'Acceder a estadísticas personales';

  @override
  String get termsAppUsageItem3 => 'Jugar partidas en línea con amigos';

  @override
  String get termsAppUsageItem4 => 'Jugar minijuegos educativos';

  @override
  String get termsAppUsageItem5 => 'Desbloquear logros';

  @override
  String get termsBiblicalContent => '2. Contenido Bíblico';

  @override
  String get termsBiblicalContentDesc =>
      'Las preguntas y respuestas se basan en la Santa Biblia. Esta es una aplicación independiente hecha por voluntarios: no es una aplicación oficial y no tiene vínculo con la organización de los testigos de Jehová ni con el sitio jw.org. Los enlaces de referencia solo abren el sitio público jw.org para consultar el texto bíblico.';

  @override
  String get termsResponsibilities => '3. Responsabilidades';

  @override
  String get termsResponsibilitiesDesc =>
      'El usuario es responsable del uso adecuado de la aplicación. No nos responsabilizamos por:';

  @override
  String get termsResponsibilitiesItem1 =>
      'Uso indebido de la información presentada';

  @override
  String get termsResponsibilitiesItem2 =>
      'Interpretaciones personales del contenido bíblico';

  @override
  String get termsResponsibilitiesItem3 =>
      'Problemas técnicos o pérdida de datos';

  @override
  String get privacyPolicy => '🔒 Política de Privacidad';

  @override
  String get privacyPolicyIntro =>
      'Respetamos tu privacidad. La app no pide registro, nombre real, correo, teléfono ni ubicación, y no muestra anuncios.';

  @override
  String get privacyDataCollected => '1. Datos Recopilados';

  @override
  String get privacyDataItem1 =>
      'Estadísticas de uso anónimas (pantallas y juegos abiertos), mediante Google Firebase Analytics, para mejorar la app.';

  @override
  String get privacyDataItem2 =>
      'Informes de fallos (modelo del dispositivo, versión del sistema y de la app), mediante Firebase Crashlytics, para corregir errores.';

  @override
  String get privacyDataItem3 =>
      'Modo en línea: un identificador anónimo, el apodo elegido y la puntuación de la partida, guardados temporalmente en Firebase y borrados al cerrar la sala.';

  @override
  String get privacyStorage => '2. Almacenamiento';

  @override
  String get privacyStorageDesc =>
      'Las estadísticas personales, logros y preferencias (idioma, sonido) se guardan solo en tu dispositivo. Las fotos elegidas para el rompecabezas nunca salen del dispositivo.';

  @override
  String get privacySupportChat => '3. Chat de Soporte';

  @override
  String get privacySupportChatDesc =>
      'Si usas el chat de soporte, los mensajes enviados y datos técnicos del dispositivo son procesados por Crisp (crisp.chat) solo para responder tu consulta.';

  @override
  String get privacySharing => '4. Compartir';

  @override
  String get privacySharingDesc =>
      'No vendemos ni compartimos tus datos con terceros para publicidad. Los servicios citados (Google Firebase y Crisp) actúan solo como encargados técnicos.';

  @override
  String get privacyRights => '5. Tus Derechos';

  @override
  String get privacyRightsDesc =>
      'Puedes pedir la eliminación de datos por el chat de soporte. Desinstalar la app borra todos los datos locales. Política completa:';

  @override
  String get copyright => '©️ Derechos de Autor';

  @override
  String get copyrightAppContent => '1. Contenido de la Aplicación';

  @override
  String get copyrightAppContentDesc =>
      'El código de la aplicación JW SPLASH GAMES se distribuye bajo licencia MIT. Las preguntas y respuestas son de dominio público o fueron creadas específicamente para este proyecto educativo.';

  @override
  String get copyrightBible => '2. Biblia y Textos Sagrados';

  @override
  String get copyrightBibleDesc =>
      'Los textos bíblicos citados siguen la Traducción del Nuevo Mundo (TNM) de las Santas Escrituras, usada con permiso para fines educativos no comerciales.';

  @override
  String get copyrightImages => '3. Imágenes e Iconos';

  @override
  String get copyrightImagesDesc =>
      'Los iconos y emojis utilizados son de fuentes públicas o licenciadas para uso gratuito.';

  @override
  String get copyrightNonCommercial => '4. Uso No Comercial';

  @override
  String get copyrightNonCommercialDesc =>
      'Esta aplicación está desarrollada con fines educativos y no comerciales. Cualquier uso comercial requiere autorización previa.';

  @override
  String get contactSection => '📞 Contacto';

  @override
  String get contactDesc => 'Para dudas, sugerencias o reportar problemas:';

  @override
  String get contactSupportChat =>
      'Chat de soporte: menú Configuración de la app';

  @override
  String get lastUpdated => '📅 Última Actualización: Octubre 2026';

  @override
  String get aboutTitle => '📱 Sobre el Juego';

  @override
  String get aboutVersion => 'Versión 1.0.0';

  @override
  String get aboutWhatIs => '¿Qué es?';

  @override
  String get aboutWhatIsDesc =>
      'JW SPLASH GAMES es una aplicación educativa que hace que el aprendizaje bíblico sea divertido e interactivo a través de cuestionarios, minijuegos y desafíos.';

  @override
  String get aboutFeatures => 'Características';

  @override
  String get aboutFeaturesDesc =>
      '• Quiz Bíblico Interactivo\n• Juego de Memoria\n• Sopa de Letras\n• Laberinto\n• Sistema de Logros\n• Estadísticas Detalladas\n• Modo Multijugador\n• 3 Idiomas (PT, EN, ES)';

  @override
  String get aboutDevelopedBy => 'Desarrollado por';

  @override
  String get aboutDevelopedByDesc =>
      'Equipo JW SPLASH GAMES\nProyecto voluntario e independiente';

  @override
  String get aboutObjective => 'Objetivo';

  @override
  String get aboutObjectiveDesc =>
      'Proporcionar una forma divertida y educativa de aprender y memorizar conocimientos bíblicos, adecuada para todas las edades.';

  @override
  String get aboutMusicCredits =>
      'Cheery Monday, Carefree, Cipher, Life of Riley, Pixel Peeker Polka\nKevin MacLeod (incompetech.com)\nLicencia: Creative Commons By Attribution 4.0\ncreativecommons.org/licenses/by/4.0';

  @override
  String get aboutCredits => 'Créditos';

  @override
  String get statsTabQuiz => 'Quiz';

  @override
  String get statsTabMinigames => 'Minijuegos';

  @override
  String get statsTabHistory => 'Historial';

  @override
  String get statsGeneralPerformance => '📊 Rendimiento General';

  @override
  String get statsQuizzesCompleted => 'Quizzes\nCompletados';

  @override
  String get statsAccuracyRate => 'Tasa de\nAcierto';

  @override
  String get statsBestScore => 'Mejor\nPuntuación';

  @override
  String get statsBestStreak => 'Mejor Racha';

  @override
  String get statsStreakTip =>
      '¡Mantén 80%+ de acierto para continuar tu racha!';

  @override
  String get statsByCategory => '📚 Por Categoría';

  @override
  String get statsAccuracyByDifficulty => '🎯 Precisión por Dificultad';

  @override
  String get statsNoMinigames => 'Ningún minijuego jugado todavía';

  @override
  String get statsMinigamesTitle => '🕹️ Estadísticas de Minijuegos';

  @override
  String get statsGames => 'Juegos';

  @override
  String get statsWins => 'Victorias';

  @override
  String get statsRate => 'Tasa';

  @override
  String get statsRecord => 'Récord';

  @override
  String statsBestTime(String time) {
    return '⏱️ Mejor tiempo: $time';
  }

  @override
  String get statsNoHistory => 'No hay historial disponible';

  @override
  String get statsGamePuzzle => '🧩 Rompecabezas';

  @override
  String get statsGameHangman => '📝 Ahorcado';

  @override
  String get statsGameWordSearch => '🔍 Sopa de Letras';

  @override
  String get statsGameMaze => '🌀 Laberinto';

  @override
  String get statsGameSequence => '🎵 Secuencia';

  @override
  String get statsGameTicTacToe => '⭕ Tres en Raya';

  @override
  String get statsGameMemory => '🧠 Juego de Memoria';

  @override
  String get playAgain => 'JUGAR DE NUEVO';

  @override
  String get welcomeStart => 'Empezar';

  @override
  String get quizNext => 'Siguiente';

  @override
  String get quizScore => 'Puntuación';

  @override
  String get quizPresenter => 'Presentador';

  @override
  String pieQuizPlayer(int number) {
    return 'Jugador $number';
  }

  @override
  String get pieQuizShowAnswer => '👁️ Ver Respuesta';

  @override
  String get pieQuizHideAnswer => 'Ocultar Respuesta';

  @override
  String get pieQuizNextQuestion => 'Siguiente Pregunta';

  @override
  String get pieQuizFinalResult => 'Ver Resultado Final';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyMedium => 'Medio';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get pieEndGame => '¡Fin del Juego!';

  @override
  String piePlayerWon(int number) {
    return '¡Jugador $number Ganó!';
  }

  @override
  String get pieTie => '¡Empate!';

  @override
  String get pieHome => 'Inicio';

  @override
  String get pieWhoGotIt => '¿Quién acertó?';

  @override
  String get pieCorrectAnswer => 'Respuesta Correcta:';

  @override
  String get sequenceRecord => 'Récord';

  @override
  String get sequenceCongrats => '🎉 ¡FELICITACIONES! ¡GANASTE! 🎉';

  @override
  String get sequenceCompletedAll => '¡Completaste los 20 niveles!';

  @override
  String sequenceReachedLevel(int level) {
    return 'Alcanzaste el nivel $level';
  }

  @override
  String get sequencePlayAgain => 'Jugar de Nuevo';

  @override
  String get sequenceStartGame => 'Iniciar Juego';

  @override
  String wordSearchFoundAll(int seconds) {
    return '¡Encontraste todas las palabras en $seconds segundos!';
  }

  @override
  String get memoryNewGame => 'Nueva Partida';

  @override
  String get memoryHome => 'Inicio';

  @override
  String get memoryConfigureGame => 'Configurar Juego';

  @override
  String get memoryMoves => 'Movimientos';

  @override
  String get memoryPairs => 'Pares';

  @override
  String get memoryTime => 'Tiempo';

  @override
  String get memoryDifficulty => 'Dificultad';

  @override
  String get memoryCongrats => '🎉 ¡Felicitaciones!';

  @override
  String get memoryFoundAllPairs => '¡Encontraste todos los pares!';

  @override
  String get ticTacToeOpponentTurn => 'Turno del oponente';

  @override
  String get ticTacToeYouWin => '¡Ganaste!';

  @override
  String get ticTacToeYouLose => '¡Perdiste!';

  @override
  String get ticTacToeDraw => '¡Empate!';

  @override
  String get jigsawTitle => 'Rompecabezas';

  @override
  String get jigsawLoadFromGallery => 'Cargar de la Galería';

  @override
  String get jigsawOrChooseImage => 'O elige una imagen:';

  @override
  String get jigsawGalleryError =>
      'Error al abrir galería. Verifica los permisos.';

  @override
  String get jigsawPieces => 'piezas';

  @override
  String get jigsawComplete => '¡Rompecabezas completo!';

  @override
  String get achievementsTitle2 => 'Logros';

  @override
  String get achievementsAll => 'Todos';

  @override
  String get achievementsLoadError => 'Error al cargar logros';

  @override
  String get multiplayerOnlineMatch => 'Partida en Línea';

  @override
  String get multiplayerPlayRealtime => '¡Juega con tus amigos en tiempo real!';

  @override
  String get multiplayerBeHost => 'Sé el anfitrión e invita amigos';

  @override
  String get multiplayerEnterCode => 'Ingresa el código de la sala';

  @override
  String get multiplayerInfo1 => '• Hasta 100 jugadores por sala';

  @override
  String get multiplayerInfo2 => '• Preguntas simultáneas';

  @override
  String get multiplayerInfo3 => '• Puntuación por velocidad';

  @override
  String get multiplayerInfo4 => '• Ranking en tiempo real';

  @override
  String get multiplayerCreateRoom => 'Crear Sala';

  @override
  String get multiplayerJoinRoom => 'Unirse a Sala';

  @override
  String get multiplayerRoom => 'Sala';

  @override
  String get multiplayerRemovePlayer => '¿Remover jugador?';

  @override
  String get multiplayerRemove => 'Remover';

  @override
  String get multiplayerLeaveRoom => '¿Salir de la sala?';

  @override
  String get multiplayerLeave => 'Salir';

  @override
  String get multiplayerEndRoom => '¿Cerrar Sala?';

  @override
  String get multiplayerEnd => 'Cerrar';

  @override
  String get multiplayerAllDisconnected =>
      'Todos los jugadores serán desconectados.';

  @override
  String get multiplayerCodeCopied => 'Código copiado';

  @override
  String multiplayerShareCode(String code) {
    return '¡Comparte el código $code con tus amigos!';
  }

  @override
  String get multiplayerRoomClosed => 'Sala cerrada';

  @override
  String get multiplayerRoomClosedHost => 'El anfitrión cerró la sala.';

  @override
  String get multiplayerShareCodeBtn => 'Compartir Código';

  @override
  String get multiplayerStartGame => 'Iniciar Juego';

  @override
  String get multiplayerWaitingPlayers => 'Esperando jugadores...';

  @override
  String get multiplayerHowItWorks => '¿Cómo funciona?';

  @override
  String get multiplayerUseSuggestion => 'Usar sugerencia';

  @override
  String get multiplayerChooseAnother => 'Elegir otro';

  @override
  String get multiplayerUnderstood => 'Entendido';

  @override
  String get multiplayerQuestion => 'Pregunta';

  @override
  String get multiplayerRoundResults => 'Resultados de la Ronda';

  @override
  String get multiplayerCorrect => '¡Correcto!';

  @override
  String get multiplayerWrong => 'Incorrecto';

  @override
  String get multiplayerPosition => 'Posición';

  @override
  String get multiplayerPoints => 'Puntos';

  @override
  String get multiplayerCurrentRanking => 'Ranking Actual';

  @override
  String get multiplayerNextQuestion => 'Siguiente Pregunta';

  @override
  String get multiplayerWaitingHost => 'Esperando al anfitrión...';

  @override
  String get multiplayerYourNickname => 'Tu apodo';

  @override
  String get multiplayerRoomCode => 'Código de sala';

  @override
  String get multiplayerPlayers => 'Jugadores';

  @override
  String get multiplayerHost => 'Anfitrión';

  @override
  String get multiplayerGameOver => '¡Fin del Juego!';

  @override
  String get multiplayerCongrats => '¡Felicidades! ¡Ganaste! 🎉';

  @override
  String get multiplayerMatchEnded => 'Partida finalizada';

  @override
  String get multiplayerRestarting => 'Reiniciando...';

  @override
  String get multiplayerPlayAgainBtn => 'Jugar de Nuevo';

  @override
  String get multiplayerCloseRoom => 'Cerrar Sala';

  @override
  String get multiplayerRestartingMatch => 'Reiniciando partida...';

  @override
  String get multiplayerWaitingHostDecision =>
      'Esperando decisión del anfitrión...';
}
