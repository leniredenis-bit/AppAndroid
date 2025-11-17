// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'JW Quiz';

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
  String get attempts => 'Intentos';

  @override
  String get victory => '¡Victoria!';

  @override
  String get defeat => 'Derrota';

  @override
  String get tryAgain => 'Intentar de Nuevo';

  @override
  String get homeWelcome => 'Bienvenido a';

  @override
  String get homeSubtitle => '¡Aprende y diviértete!';

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
  String get minigamesPuzzle => '🧩 Rompecabezas';

  @override
  String get minigamesPuzzleDesc => 'Completa el rompecabezas';

  @override
  String get minigamesHangman => '🎯 Ahorcado Bíblico';

  @override
  String get minigamesHangmanDesc => 'Adivina la palabra';

  @override
  String get minigamesWordSearch => '🔍 Sopa de Letras';

  @override
  String get minigamesWordSearchDesc => 'Encuentra las palabras';

  @override
  String get minigamesMaze => '🗺️ Laberinto';

  @override
  String get minigamesMazeDesc => 'Encuentra la salida';

  @override
  String get minigamesSequence => '🎵 Secuencia';

  @override
  String get minigamesSequenceDesc => 'Repite la secuencia';

  @override
  String get minigamesTicTacToe => '⭕ Tres en Raya';

  @override
  String get minigamesTicTacToeDesc => 'Contra la IA';

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
}
