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
  String get pieces => 'Peças';

  @override
  String get level => 'Nível';

  @override
  String get difficulty => 'Dificuldade';

  @override
  String get easy => 'Fácil';

  @override
  String get medium => 'Médio';

  @override
  String get hard => 'Difícil';

  @override
  String get attempts => 'Tentativas';

  @override
  String get victory => 'Vitória!';

  @override
  String get defeat => 'Derrota';

  @override
  String get complete => 'COMPLETO!';

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
  String get homeQuizClassic => 'Quiz Clássico';

  @override
  String get homeQuizClassicDesc => 'Responda perguntas e marque pontos!';

  @override
  String get homeQuizPie => 'Quiz Torta na Cara';

  @override
  String get homeQuizPieDesc => 'Duelo 1v1 local - quem errar perde!';

  @override
  String get homeOnlineMatch => 'Partida Online';

  @override
  String get homeOnlineMatchDesc => 'Jogue com amigos em tempo real!';

  @override
  String get homeMinigames => 'Minigames';

  @override
  String get homeMinigamesDesc => 'Jogos divertidos te aguardam!';

  @override
  String get homeStats => 'Estatísticas';

  @override
  String get homeStatsDesc => 'Veja seu desempenho e conquistas!';

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
  String get minigamesMemory => '🧠 Jogo da Memória';

  @override
  String get minigamesMemoryDesc => 'Encontre pares bíblicos!';

  @override
  String get minigamesPuzzle => '🧩 Quebra-Cabeça';

  @override
  String get minigamesPuzzleDesc => 'Monte o quebra-cabeça';

  @override
  String get minigamesJigsaw => '🖼️ Quebra-Cabeça Foto';

  @override
  String get minigamesJigsawDesc => 'Monte imagens reais!';

  @override
  String get minigamesHangman => '🎯 Forca Bíblica';

  @override
  String get minigamesHangmanDesc => 'Adivinhe a palavra bíblica!';

  @override
  String get minigamesWordSearch => '🔍 Caça-Palavras';

  @override
  String get minigamesWordSearchDesc => 'Encontre palavras escondidas!';

  @override
  String get minigamesMaze => '🌀 Labirinto';

  @override
  String get minigamesMazeDesc => 'Encontre a saída!';

  @override
  String get minigamesSequence => '� Sequência Rápida';

  @override
  String get minigamesSequenceDesc => 'Memorize o padrão de cores!';

  @override
  String get minigamesSequenceCrystal => '💠 Sequência Cristal';

  @override
  String get minigamesSequenceCrystalDesc => 'Versão cristal com brilhos!';

  @override
  String get minigamesTicTacToe => '⭕ Jogo da Velha';

  @override
  String get minigamesTicTacToeDesc => 'Duelo 2 jogadores ou vs IA!';

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
  String get bibleReadFullText => 'Toque para ler o texto completo';

  @override
  String get bibleOpenError => 'Não foi possível abrir a referência.';

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

  @override
  String get memoryGameTitle => '🧠 Jogo da Memória';

  @override
  String get memoryGameDifficulty => 'Dificuldade';

  @override
  String get memoryGameEasy => 'Fácil (6 pares)';

  @override
  String get memoryGameMedium => 'Médio (10 pares)';

  @override
  String get memoryGameHard => 'Difícil (15 pares)';

  @override
  String get memoryGameTheme => 'Tema';

  @override
  String get memoryGamePlayers => 'Jogadores';

  @override
  String get memoryGameStartGame => 'Iniciar Jogo';

  @override
  String get memoryGameAttempts => 'Tentativas';

  @override
  String get memoryGameMatches => 'Pares';

  @override
  String get memoryGameTime => 'Tempo';

  @override
  String memoryGamePlayerTurn(int player) {
    return 'Vez do Jogador $player';
  }

  @override
  String memoryGameScore(int score) {
    return 'Pontos: $score';
  }

  @override
  String get memoryGameCongrats => 'Parabéns! 🎉';

  @override
  String get memoryGamePlayAgain => 'Jogar Novamente';

  @override
  String get ticTacToeTitle => '⭕ Jogo da Velha';

  @override
  String get ticTacToeMode => 'Modo';

  @override
  String get ticTacToeTwoPlayers => '2 Jogadores';

  @override
  String get ticTacToeVsAI => 'vs IA';

  @override
  String get ticTacToeDifficulty => 'Dificuldade da IA';

  @override
  String get ticTacToeEasy => 'Fácil';

  @override
  String get ticTacToeImpossible => 'Impossível';

  @override
  String get ticTacToePlayerX => 'Jogador X';

  @override
  String get ticTacToePlayerO => 'Jogador O';

  @override
  String get ticTacToeYourTurn => 'Sua vez!';

  @override
  String get ticTacToeWins => 'Vitórias';

  @override
  String get ticTacToeDraws => 'Empates';

  @override
  String get ticTacToeResetScores => 'Resetar Placar';

  @override
  String get ticTacToeNewGame => 'Novo Jogo';

  @override
  String get hangmanTitle => 'Jogo da Forca';

  @override
  String get hangmanCategory => 'Categoria';

  @override
  String get hangmanAttempts => 'Tentativas restantes';

  @override
  String get hangmanGuess => 'Adivinhe a letra';

  @override
  String get hangmanWin => 'Você ganhou! 🎉';

  @override
  String get hangmanLose => 'Fim de jogo!';

  @override
  String get hangmanTheWordWas => 'A palavra era:';

  @override
  String get hangmanPlayAgain => 'Jogar Novamente';

  @override
  String hangmanErrors(int errors, int max) {
    return 'Erros: $errors / $max';
  }

  @override
  String get hangmanCongrats => '🎉 Parabéns! Você acertou!';

  @override
  String get hangmanYouLost => '😢 Você perdeu!';

  @override
  String hangmanWordWas(String word) {
    return 'A palavra era: $word';
  }

  @override
  String hangmanWrongLetters(String letters) {
    return 'Letras erradas: $letters';
  }

  @override
  String get wordSearchTitle => '🔍 Caça-Palavras';

  @override
  String wordSearchWordsFound(int found, int total) {
    return 'Palavras encontradas: $found/$total';
  }

  @override
  String wordSearchTimeElapsed(String time) {
    return 'Tempo: $time';
  }

  @override
  String get wordSearchComplete => 'Completado! 🎉';

  @override
  String get wordSearchNewGame => 'Novo Jogo';

  @override
  String get mazeTitle => '🗺️ Labirinto';

  @override
  String get mazeMoves => 'Movimentos';

  @override
  String mazeMovesCount(int count) {
    return 'Movimentos: $count';
  }

  @override
  String get mazeTime => 'Tempo';

  @override
  String get mazeControls => 'Controles';

  @override
  String get mazeUseButtons => 'Use os botões ou teclas de seta';

  @override
  String get mazeGoal => 'Encontre a saída!';

  @override
  String get mazeVictory => 'Saída encontrada! 🎉';

  @override
  String get mazePlayAgain => 'Jogar Novamente';

  @override
  String get mazeCavern => '🏔️ Caverna do Labirinto';

  @override
  String mazeCampaignMode(int level) {
    return 'Modo Campanha (Nível $level)';
  }

  @override
  String get mazeQuickPlayCustom => 'Jogo Rápido Personalizado';

  @override
  String mazeRows(int count) {
    return 'Linhas: $count';
  }

  @override
  String mazeColumns(int count) {
    return 'Colunas: $count';
  }

  @override
  String get mazePlayQuick => 'Jogar Partida Rápida';

  @override
  String get mazeEscaped => '✨ ESCAPOU! ✨';

  @override
  String mazeCompletedIn(int moves) {
    return 'Você completou o labirinto em $moves movimentos.';
  }

  @override
  String get mazeBackToMenu => 'Voltar ao Menu';

  @override
  String mazeLevelComplete(int level) {
    return 'Nível $level Concluído!';
  }

  @override
  String get mazeLoadingNextCavern => 'Carregando próxima caverna...';

  @override
  String get sequenceTitle => '🎵 Sequência de Cores';

  @override
  String get sequenceLevel => 'Nível';

  @override
  String get sequenceHighScore => 'Recorde';

  @override
  String get sequenceWatchSequence => 'Observe a sequência...';

  @override
  String get sequenceYourTurn => 'Sua vez!';

  @override
  String get sequenceGameOver => 'Fim de jogo!';

  @override
  String sequenceReached(int level) {
    return 'Você chegou ao nível $level!';
  }

  @override
  String get sequenceNewRecord => 'Novo recorde! 🏆';

  @override
  String get sequenceTryAgain => 'Tentar Novamente';

  @override
  String sequenceActiveColors(int active, int max) {
    return 'CORES ATIVAS: $active / $max';
  }

  @override
  String sequenceStreak(int current, int target) {
    return 'SEQUÊNCIA: $current / $target';
  }

  @override
  String get sequenceCorrect => '✨ Correto! Próximo Nível! ✨';

  @override
  String get sequenceObserve => '👀 Observe a sequência...';

  @override
  String get sequenceRepeat => '👆 Sua vez! Repita a sequência';

  @override
  String sequenceGameOverLevel(int level) {
    return '❌ Fim de Jogo! Você chegou ao nível $level';
  }

  @override
  String get sequenceRestartGame => 'Reiniciar Jogo';

  @override
  String get sequenceStartDifficulty => 'Iniciar/Dificuldade';

  @override
  String get sequenceChooseDifficulty => 'Escolha a Dificuldade';

  @override
  String sequenceEasyColors(int count) {
    return 'Fácil ($count Cores)';
  }

  @override
  String sequenceMediumColors(int count) {
    return 'Médio ($count Cores)';
  }

  @override
  String sequenceHardColors(int count) {
    return 'Difícil ($count Cores)';
  }

  @override
  String sequenceProgressive(int start, int end) {
    return 'PROGRESSIVO ($start -> $end Cores)';
  }

  @override
  String sequenceProgressiveDesc(int count) {
    return 'Aumenta uma cor a cada $count acertos seguidos.';
  }

  @override
  String sequenceHighScoreLabel(int score) {
    return 'Recorde: $score';
  }

  @override
  String get colorRed => 'Vermelho';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorYellow => 'Amarelo';

  @override
  String get colorPurple => 'Roxo';

  @override
  String get colorOrange => 'Laranja';

  @override
  String get colorCyan => 'Ciano';

  @override
  String get colorLime => 'Lima';

  @override
  String get colorPink => 'Rosa';

  @override
  String get colorLocked => 'Bloqueado';

  @override
  String get puzzleTitle => '🧩 Quebra-Cabeça';

  @override
  String get puzzleMoves => 'Movimentos';

  @override
  String get puzzleDragPieces => 'Arraste as peças para os lugares corretos';

  @override
  String get puzzleComplete => 'Quebra-cabeça completo! 🎉';

  @override
  String get puzzleNewGame => 'Novo Jogo';

  @override
  String completedInMoves(Object moves) {
    return 'Concluído em $moves movimentos';
  }

  @override
  String get newGame => 'Nova Partida';
}
