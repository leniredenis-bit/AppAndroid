// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'JW SPLASH GAMES';

  @override
  String get loading => 'Carregando...';

  @override
  String get error => 'Erro';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Fechar';

  @override
  String get back => 'Voltar';

  @override
  String get next => 'Próxima';

  @override
  String get start => 'Iniciar';

  @override
  String get restart => 'Reiniciar';

  @override
  String get continue_ => 'Continuar';

  @override
  String get score => 'Pontuação';

  @override
  String get time => 'Tempo';

  @override
  String get moves => 'Movimentos';

  @override
  String get attempts => 'Tentativas';

  @override
  String get victory => 'Vitória!';

  @override
  String get defeat => 'Derrota';

  @override
  String get tryAgain => 'Tentar Novamente';

  @override
  String get homeWelcome => 'Bem-vindo ao';

  @override
  String get homeSubtitle => 'Aprenda e divirta-se!';

  @override
  String get homeDifficulty => 'Dificuldade';

  @override
  String get homeCategories => 'Categorias';

  @override
  String homeShowMore(int count) {
    return 'Ver mais ($count+)';
  }

  @override
  String get homeShowLess => 'Ver menos';

  @override
  String get homeNoQuestionsFound =>
      'Nenhuma pergunta encontrada com esses filtros!';

  @override
  String homeLoadingError(String error) {
    return 'Erro ao carregar perguntas: $error';
  }

  @override
  String homeLoadingCategoriesError(String error) {
    return 'Erro ao carregar categorias: $error';
  }

  @override
  String homeThemeActivated(String theme) {
    return 'Tema $theme ativado!';
  }

  @override
  String get homeThemeDark => 'escuro';

  @override
  String get homeThemeLight => 'claro';

  @override
  String get playQuiz => '🎯 Jogar Quiz';

  @override
  String get playMinigames => '🎮 Minigames';

  @override
  String get viewStats => '📊 Estatísticas';

  @override
  String get settings => '⚙️ Configurações';

  @override
  String get about => 'ℹ️ Sobre';

  @override
  String get quizModeSelection => 'Escolha o Modo';

  @override
  String get quizModeNormal => 'Normal';

  @override
  String get quizModeNormalDesc => 'Quiz padrão com timer';

  @override
  String get quizModeStudy => 'Estudo';

  @override
  String get quizModeStudyDesc => 'Sem pressão de tempo';

  @override
  String get quizModeFast => 'Rápido';

  @override
  String get quizModeFastDesc => 'Desafio contra o relógio';

  @override
  String get quizQuestion => 'Pergunta';

  @override
  String quizTitle(int current, int total) {
    return 'Quiz - $current/$total';
  }

  @override
  String get quizExplanation => '📖 Explicação';

  @override
  String quizNextIn(int seconds) {
    return 'Próxima pergunta em ${seconds}s...';
  }

  @override
  String get quizFinished => 'Quiz Finalizado!';

  @override
  String get quizExcellent => 'Excelente!';

  @override
  String get quizVeryGood => 'Muito Bem!';

  @override
  String get quizGoodJob => 'Bom Trabalho!';

  @override
  String get quizKeepPracticing => 'Continue Praticando!';

  @override
  String get quizCorrectAnswers => 'Acertos';

  @override
  String get quizAccuracy => 'Aproveitamento';

  @override
  String get quizBackToMenu => 'Voltar ao Menu';

  @override
  String get quizDifficultyEasy => 'FÁCIL';

  @override
  String get quizDifficultyMedium => 'MÉDIO';

  @override
  String get quizDifficultyHard => 'DIFÍCIL';

  @override
  String get minigamesTitle => '🎮 Minigames Bíblicos';

  @override
  String get minigamesPuzzle => '🧩 Quebra-Cabeça';

  @override
  String get minigamesPuzzleDesc => 'Monte o quebra-cabeça';

  @override
  String get minigamesHangman => '🎯 Forca Bíblica';

  @override
  String get minigamesHangmanDesc => 'Adivinhe a palavra';

  @override
  String get minigamesWordSearch => '🔍 Caça-Palavras';

  @override
  String get minigamesWordSearchDesc => 'Encontre as palavras';

  @override
  String get minigamesMaze => '🗺️ Labirinto';

  @override
  String get minigamesMazeDesc => 'Encontre a saída';

  @override
  String get minigamesSequence => '🎵 Sequência';

  @override
  String get minigamesSequenceDesc => 'Repita a sequência';

  @override
  String get minigamesTicTacToe => '⭕ Jogo da Velha';

  @override
  String get minigamesTicTacToeDesc => 'Contra a IA';

  @override
  String get achievementsTitle => '🏆 Conquistas';

  @override
  String achievementsUnlocked(int count) {
    return '$count Desbloqueadas';
  }

  @override
  String achievementsProgress(int percent) {
    return 'Progresso: $percent%';
  }

  @override
  String get achievementsCategoryAll => 'Todas';

  @override
  String get achievementsCategoryQuiz => 'Quiz';

  @override
  String get achievementsCategoryMinigames => 'Minigames';

  @override
  String get achievementsCategorySocial => 'Social';

  @override
  String get achievementsCategoryMaster => 'Master';

  @override
  String get achievementUnlocked => 'Conquista Desbloqueada!';

  @override
  String achievementUnlockedAt(String date) {
    return 'Desbloqueada em $date';
  }

  @override
  String get achPrimeiroPasso => 'Primeiro Passo';

  @override
  String get achPrimeiroPassoDesc => 'Complete seu primeiro quiz';

  @override
  String get achEstudioso => 'Estudioso';

  @override
  String get achEstudiosoDesc => 'Complete 10 quizzes';

  @override
  String get achPerfeccionista => 'Perfeccionista';

  @override
  String get achPerfeccionistaDesc => 'Acerte 100% das perguntas';

  @override
  String get achVelocista => 'Velocista';

  @override
  String get achVelocistaDesc => 'Complete quiz em menos de 2 minutos';

  @override
  String get achSequenciaPerfeita => 'Sequência Perfeita';

  @override
  String get achSequenciaPerfeitaDesc => '5 quizzes seguidos com 80%+';

  @override
  String get achMestreBiblico => 'Mestre Bíblico';

  @override
  String get achMestreBiblicoDesc => 'Complete 50 quizzes';

  @override
  String get achExplorador => 'Explorador';

  @override
  String get achExploradorDesc => 'Jogue todos os minigames';

  @override
  String get achMestrePuzzles => 'Mestre dos Puzzles';

  @override
  String get achMestrePuzzlesDesc => 'Complete puzzle em <2min';

  @override
  String get achMemoriaFotografica => 'Memória Fotográfica';

  @override
  String get achMemoriaFotograficaDesc => 'Memory game sem erros';

  @override
  String get achAtiradorElite => 'Atirador de Elite';

  @override
  String get achAtiradorEliteDesc => '10 vitórias no Jogo da Velha';

  @override
  String get achCampeaoMinigames => 'Campeão dos Minigames';

  @override
  String get achCampeaoMinigamesDesc => 'Vença cada minigame 3 vezes';

  @override
  String get achSocial => 'Social';

  @override
  String get achSocialDesc => 'Compartilhe resultado';

  @override
  String get achCompetidor => 'Competidor';

  @override
  String get achCompetidorDesc => 'Complete 5 partidas multiplayer';

  @override
  String get achColecionador => 'Colecionador';

  @override
  String get achColecionadorDesc => 'Desbloqueie 10 conquistas';

  @override
  String get achLenda => 'Lenda';

  @override
  String get achLendaDesc => 'Desbloqueie todas as conquistas';

  @override
  String get settingsTitle => '⚙️ Configurações';

  @override
  String get settingsAudio => '🔊 Áudio';

  @override
  String get settingsMusic => 'Música';

  @override
  String get settingsSoundEffects => 'Efeitos Sonoros';

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
  String get settingsThemeDark => 'Escuro';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsHapticFeedback => '📳 Vibração';

  @override
  String get settingsShowTutorial => '📚 Tutorial';

  @override
  String get settingsAchievements => '🏆 Conquistas';

  @override
  String get settingsStatistics => '📊 Estatísticas';

  @override
  String get settingsAbout => 'ℹ️ Sobre o App';

  @override
  String get statsTitle => '📊 Estatísticas';

  @override
  String get statsGlobal => 'Globais';

  @override
  String get statsTotalQuizzes => 'Total de Quizzes';

  @override
  String get statsTotalQuestions => 'Total de Perguntas';

  @override
  String get statsCorrectAnswers => 'Respostas Corretas';

  @override
  String get statsWrongAnswers => 'Respostas Erradas';

  @override
  String get statsAccuracy => 'Precisão';

  @override
  String get statsHighScore => 'Recorde de Pontos';

  @override
  String get statsCurrentStreak => 'Sequência Atual';

  @override
  String get statsLongestStreak => 'Maior Sequência';

  @override
  String get statsHistory => 'Histórico';

  @override
  String get statsMinigameRecords => 'Recordes de Minigames';

  @override
  String get statsNoData => 'Nenhum dado disponível ainda';

  @override
  String get statsPlayToSeeData => 'Jogue para ver suas estatísticas!';

  @override
  String get errorLoadingQuestions => 'Erro ao carregar perguntas';

  @override
  String get errorNoQuestions => 'Nenhuma pergunta disponível';

  @override
  String get errorGeneric => 'Ocorreu um erro. Tente novamente.';

  @override
  String get errorConnection => 'Erro de conexão. Verifique sua internet.';

  @override
  String get gameWon => 'Você ganhou!';

  @override
  String get gameLost => 'Você perdeu!';

  @override
  String get gameDraw => 'Empate!';

  @override
  String get gamePaused => 'Jogo Pausado';

  @override
  String get gameResume => 'Retomar';

  @override
  String get gameQuit => 'Sair';

  @override
  String get gameCompleted => 'Completado!';

  @override
  String gameTimeElapsed(String time) {
    return 'Tempo decorrido: $time';
  }
}
