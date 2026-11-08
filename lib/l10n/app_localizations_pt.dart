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
  String get statsCurrentStreak => 'Sequência\nAtual';

  @override
  String get statsLongestStreak => 'Maior Sequência';

  @override
  String get statsHistory => 'Histórico';

  @override
  String get statsMinigameRecords => 'Recordes de Minigames';

  @override
  String get statsNoData => 'Nenhum dado disponível';

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
  String get ticTacToeTitle => 'Jogo da Velha Neon';

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
  String get ticTacToeYourTurn => 'Sua vez';

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
  String get wordSearchTitle => 'Caça-Palavras';

  @override
  String wordSearchWordsFound(int found, int total) {
    return 'Palavras encontradas: $found/$total';
  }

  @override
  String wordSearchTimeElapsed(String time) {
    return 'Tempo: $time';
  }

  @override
  String get wordSearchComplete => 'COMPLETO!';

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
  String get sequenceLevel => 'NÍVEL';

  @override
  String get sequenceHighScore => 'Recorde';

  @override
  String get sequenceWatchSequence => 'Observe a sequência...';

  @override
  String get sequenceYourTurn => 'Sua vez! Repita a sequência';

  @override
  String get sequenceGameOver => '❌ Fim de Jogo!';

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
  String get sequenceCorrect => '✨ Correto! ✨';

  @override
  String get sequenceObserve => 'Observe a sequência...';

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

  @override
  String get settingsLanguageChanged => 'Idioma alterado com sucesso!';

  @override
  String get settingsMusicVolume => '🎵 Volume da Música';

  @override
  String get settingsSfxVolume => '🔊 Volume dos Efeitos';

  @override
  String get settingsAchievementsSubtitle =>
      'Veja suas conquistas desbloqueadas';

  @override
  String get settingsStatisticsSubtitle => 'Veja seu desempenho';

  @override
  String get settingsTerms => '📜 Termos e Condições';

  @override
  String get settingsTermsSubtitle => 'Política de privacidade e termos';

  @override
  String get settingsAboutSubtitle => 'Informações sobre o aplicativo';

  @override
  String get settingsSupport => '💬 Ajuda e Suporte';

  @override
  String get settingsSupportSubtitle =>
      'Fale conosco, envie feedback ou dúvidas';

  @override
  String get termsTitle => 'ℹ️ Termos e Condições';

  @override
  String get termsOfUse => '📋 Termos de Uso';

  @override
  String get termsWelcome =>
      'Bem-vindo ao JW SPLASH GAMES! Este aplicativo foi desenvolvido para fins educacionais e de entretenimento, visando promover o conhecimento bíblico de forma interativa.';

  @override
  String get termsAppUsage => '1. Uso do Aplicativo';

  @override
  String get termsAppUsageDesc =>
      'O JW SPLASH GAMES é um aplicativo gratuito para uso pessoal. Você pode:';

  @override
  String get termsAppUsageItem1 => 'Jogar quizzes individuais ou em grupo';

  @override
  String get termsAppUsageItem2 => 'Acessar estatísticas pessoais';

  @override
  String get termsAppUsageItem3 => 'Jogar partidas online com amigos';

  @override
  String get termsAppUsageItem4 => 'Jogar minigames educativos';

  @override
  String get termsAppUsageItem5 => 'Desbloquear conquistas';

  @override
  String get termsBiblicalContent => '2. Conteúdo Bíblico';

  @override
  String get termsBiblicalContentDesc =>
      'As perguntas e respostas são baseadas na Bíblia Sagrada. Este é um aplicativo independente, feito por voluntários: não é um aplicativo oficial e não tem vínculo com a organização das Testemunhas de Jeová nem com o site jw.org. Os links de referência apenas abrem o site público jw.org para consulta do texto bíblico.';

  @override
  String get termsResponsibilities => '3. Responsabilidades';

  @override
  String get termsResponsibilitiesDesc =>
      'O usuário é responsável por seu uso adequado do aplicativo. Não nos responsabilizamos por:';

  @override
  String get termsResponsibilitiesItem1 =>
      'Uso indevido das informações apresentadas';

  @override
  String get termsResponsibilitiesItem2 =>
      'Interpretações pessoais do conteúdo bíblico';

  @override
  String get termsResponsibilitiesItem3 =>
      'Problemas técnicos ou perda de dados';

  @override
  String get privacyPolicy => '🔒 Política de Privacidade';

  @override
  String get privacyPolicyIntro =>
      'Respeitamos sua privacidade. O app não pede cadastro, nome real, e-mail, telefone ou localização, e não exibe anúncios.';

  @override
  String get privacyDataCollected => '1. Dados Coletados';

  @override
  String get privacyDataItem1 =>
      'Estatísticas de uso anônimas (telas e jogos acessados), via Google Firebase Analytics, para melhorar o app.';

  @override
  String get privacyDataItem2 =>
      'Relatórios de falhas (modelo do aparelho, versão do sistema e do app), via Firebase Crashlytics, para corrigir erros.';

  @override
  String get privacyDataItem3 =>
      'Modo online: um identificador anônimo, o apelido escolhido e a pontuação da partida, armazenados temporariamente no Firebase e apagados quando a sala é encerrada.';

  @override
  String get privacyStorage => '2. Armazenamento';

  @override
  String get privacyStorageDesc =>
      'Estatísticas pessoais, conquistas e preferências (idioma, som) ficam salvas apenas no seu aparelho. Fotos escolhidas para o quebra-cabeça nunca saem do aparelho.';

  @override
  String get privacySupportChat => '3. Chat de Suporte';

  @override
  String get privacySupportChatDesc =>
      'Se você usar o chat de suporte, as mensagens enviadas e dados técnicos do aparelho são processados pelo Crisp (crisp.chat) apenas para responder ao seu atendimento.';

  @override
  String get privacySharing => '4. Compartilhamento';

  @override
  String get privacySharingDesc =>
      'Não vendemos nem compartilhamos seus dados com terceiros para publicidade. Os serviços citados (Google Firebase e Crisp) atuam somente como operadores técnicos.';

  @override
  String get privacyRights => '5. Seus Direitos (LGPD)';

  @override
  String get privacyRightsDesc =>
      'Você pode pedir a exclusão de dados pelo chat de suporte. Desinstalar o app apaga todos os dados locais. Política completa:';

  @override
  String get copyright => '©️ Direitos Autorais';

  @override
  String get copyrightAppContent => '1. Conteúdo do Aplicativo';

  @override
  String get copyrightAppContentDesc =>
      'O código do aplicativo JW SPLASH GAMES é distribuído sob licença MIT. As perguntas e respostas são de domínio público ou foram criadas especificamente para este projeto educacional.';

  @override
  String get copyrightBible => '2. Bíblia e Textos Sagrados';

  @override
  String get copyrightBibleDesc =>
      'Os textos bíblicos citados seguem a Tradução do Novo Mundo (TNM) das Escrituras Sagradas, usada com permissão para fins educacionais não comerciais.';

  @override
  String get copyrightImages => '3. Imagens e Ícones';

  @override
  String get copyrightImagesDesc =>
      'Os ícones e emojis utilizados são de fontes públicas ou licenciadas para uso gratuito.';

  @override
  String get copyrightNonCommercial => '4. Uso Não Comercial';

  @override
  String get copyrightNonCommercialDesc =>
      'Este aplicativo é desenvolvido para fins educacionais e não comerciais. Qualquer uso comercial requer autorização prévia.';

  @override
  String get contactSection => '📞 Contato';

  @override
  String get contactDesc => 'Para dúvidas, sugestões ou relatar problemas:';

  @override
  String get contactSupportChat => 'Chat de suporte: menu Configurações do app';

  @override
  String get lastUpdated => '📅 Última Atualização: Outubro 2026';

  @override
  String get aboutTitle => '📱 Sobre o Jogo';

  @override
  String get aboutVersion => 'Versão 1.0.0';

  @override
  String get aboutWhatIs => 'O que é?';

  @override
  String get aboutWhatIsDesc =>
      'JW SPLASH GAMES é um aplicativo educativo que torna o aprendizado bíblico divertido e interativo através de quizzes, minigames e desafios.';

  @override
  String get aboutFeatures => 'Recursos';

  @override
  String get aboutFeaturesDesc =>
      '• Quiz Bíblico Interativo\n• Jogo da Memória\n• Caça-Palavras\n• Labirinto\n• Sistema de Conquistas\n• Estatísticas Detalhadas\n• Modo Multiplayer\n• 3 Idiomas (PT, EN, ES)';

  @override
  String get aboutDevelopedBy => 'Desenvolvido por';

  @override
  String get aboutDevelopedByDesc =>
      'Equipe JW SPLASH GAMES\nProjeto voluntário e independente';

  @override
  String get aboutObjective => 'Objetivo';

  @override
  String get aboutObjectiveDesc =>
      'Proporcionar uma forma divertida e educativa de aprender e memorizar conhecimentos bíblicos, adequado para todas as idades.';

  @override
  String get aboutMusicCredits =>
      'Cheery Monday, Carefree, Cipher, Life of Riley, Pixel Peeker Polka\nKevin MacLeod (incompetech.com)\nLicença: Creative Commons By Attribution 4.0\ncreativecommons.org/licenses/by/4.0';

  @override
  String get aboutCredits => 'Créditos';

  @override
  String get statsTabQuiz => 'Quiz';

  @override
  String get statsTabMinigames => 'Minigames';

  @override
  String get statsTabHistory => 'Histórico';

  @override
  String get statsGeneralPerformance => '📊 Desempenho Geral';

  @override
  String get statsQuizzesCompleted => 'Quizzes\nRealizados';

  @override
  String get statsAccuracyRate => 'Taxa de\nAcerto';

  @override
  String get statsBestScore => 'Melhor\nScore';

  @override
  String get statsBestStreak => 'Melhor Sequência';

  @override
  String get statsStreakTip =>
      'Mantenha 80%+ de acerto para continuar a sequência!';

  @override
  String get statsByCategory => '📚 Por Categoria';

  @override
  String get statsAccuracyByDifficulty => '🎯 Precisão por Dificuldade';

  @override
  String get statsNoMinigames => 'Nenhum minigame jogado ainda';

  @override
  String get statsMinigamesTitle => '🕹️ Estatísticas dos Minigames';

  @override
  String get statsGames => 'Jogos';

  @override
  String get statsWins => 'Vitórias';

  @override
  String get statsRate => 'Taxa';

  @override
  String get statsRecord => 'Recorde';

  @override
  String statsBestTime(String time) {
    return '⏱️ Melhor tempo: $time';
  }

  @override
  String get statsNoHistory => 'Nenhum histórico disponível';

  @override
  String get statsGamePuzzle => '🧩 Quebra-Cabeça';

  @override
  String get statsGameHangman => '📝 Forca';

  @override
  String get statsGameWordSearch => '🔍 Caça-Palavras';

  @override
  String get statsGameMaze => '🌀 Labirinto';

  @override
  String get statsGameSequence => '🎵 Sequência';

  @override
  String get statsGameTicTacToe => '⭕ Jogo da Velha';

  @override
  String get statsGameMemory => '🧠 Jogo da Memória';

  @override
  String get playAgain => 'JOGAR NOVAMENTE';

  @override
  String get welcomeStart => 'Começar';

  @override
  String get quizNext => 'Próxima';

  @override
  String get quizScore => 'Pontuação';

  @override
  String get quizPresenter => 'Apresentador';

  @override
  String pieQuizPlayer(int number) {
    return 'Jogador $number';
  }

  @override
  String get pieQuizShowAnswer => '👁️ Ver Resposta';

  @override
  String get pieQuizHideAnswer => 'Ocultar Resposta';

  @override
  String get pieQuizNextQuestion => 'Próxima Pergunta';

  @override
  String get pieQuizFinalResult => 'Ver Resultado Final';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyMedium => 'Médio';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get pieEndGame => 'Fim do Jogo!';

  @override
  String piePlayerWon(int number) {
    return 'Jogador $number Venceu!';
  }

  @override
  String get pieTie => 'Empate!';

  @override
  String get pieHome => 'Início';

  @override
  String get pieWhoGotIt => 'Quem acertou?';

  @override
  String get pieCorrectAnswer => 'Resposta Correta:';

  @override
  String get sequenceRecord => 'Recorde';

  @override
  String get sequenceCongrats => '🎉 PARABÉNS! VOCÊ VENCEU! 🎉';

  @override
  String get sequenceCompletedAll => 'Você completou todos os 20 níveis!';

  @override
  String sequenceReachedLevel(int level) {
    return 'Você alcançou o nível $level';
  }

  @override
  String get sequencePlayAgain => 'Jogar Novamente';

  @override
  String get sequenceStartGame => 'Iniciar Jogo';

  @override
  String wordSearchFoundAll(int seconds) {
    return 'Você encontrou todas as palavras em $seconds segundos!';
  }

  @override
  String get memoryNewGame => 'Nova Partida';

  @override
  String get memoryHome => 'Início';

  @override
  String get memoryConfigureGame => 'Configurar Jogo';

  @override
  String get memoryMoves => 'Jogadas';

  @override
  String get memoryPairs => 'Pares';

  @override
  String get memoryTime => 'Tempo';

  @override
  String get memoryDifficulty => 'Dificuldade';

  @override
  String get memoryCongrats => '🎉 Parabéns!';

  @override
  String get memoryFoundAllPairs => 'Você encontrou todos os pares!';

  @override
  String get ticTacToeOpponentTurn => 'Vez do oponente';

  @override
  String get ticTacToeYouWin => 'Você venceu!';

  @override
  String get ticTacToeYouLose => 'Você perdeu!';

  @override
  String get ticTacToeDraw => 'Empate!';

  @override
  String get jigsawTitle => 'Quebra-Cabeça';

  @override
  String get jigsawLoadFromGallery => 'Carregar da Galeria';

  @override
  String get jigsawOrChooseImage => 'Ou escolha uma imagem:';

  @override
  String get jigsawGalleryError =>
      'Erro ao abrir galeria. Verifique as permissões.';

  @override
  String get jigsawPieces => 'peças';

  @override
  String get jigsawComplete => 'Quebra-cabeça completo!';

  @override
  String get achievementsTitle2 => 'Conquistas';

  @override
  String get achievementsAll => 'Todas';

  @override
  String get achievementsLoadError => 'Erro ao carregar conquistas';

  @override
  String get multiplayerOnlineMatch => 'Partida Online';

  @override
  String get multiplayerPlayRealtime => 'Jogue com seus amigos em tempo real!';

  @override
  String get multiplayerBeHost => 'Seja o anfitrião e convide amigos';

  @override
  String get multiplayerEnterCode => 'Digite o código da sala';

  @override
  String get multiplayerInfo1 => '• Até 100 jogadores por sala';

  @override
  String get multiplayerInfo2 => '• Perguntas simultâneas';

  @override
  String get multiplayerInfo3 => '• Pontuação por velocidade';

  @override
  String get multiplayerInfo4 => '• Ranking em tempo real';

  @override
  String get multiplayerCreateRoom => 'Criar Sala';

  @override
  String get multiplayerJoinRoom => 'Entrar em Sala';

  @override
  String get multiplayerRoom => 'Sala';

  @override
  String get multiplayerRemovePlayer => 'Remover jogador?';

  @override
  String get multiplayerRemove => 'Remover';

  @override
  String get multiplayerLeaveRoom => 'Sair da sala?';

  @override
  String get multiplayerLeave => 'Sair';

  @override
  String get multiplayerEndRoom => 'Encerrar Sala?';

  @override
  String get multiplayerEnd => 'Encerrar';

  @override
  String get multiplayerAllDisconnected =>
      'Todos os jogadores serão desconectados.';

  @override
  String get multiplayerCodeCopied => 'Código copiado';

  @override
  String multiplayerShareCode(String code) {
    return 'Compartilhe o código $code com seus amigos!';
  }

  @override
  String get multiplayerRoomClosed => 'Sala encerrada';

  @override
  String get multiplayerRoomClosedHost => 'O anfitrião encerrou a sala.';

  @override
  String get multiplayerShareCodeBtn => 'Compartilhar Código';

  @override
  String get multiplayerStartGame => 'Iniciar Jogo';

  @override
  String get multiplayerWaitingPlayers => 'Aguardando jogadores...';

  @override
  String get multiplayerHowItWorks => 'Como funciona?';

  @override
  String get multiplayerUseSuggestion => 'Usar sugestão';

  @override
  String get multiplayerChooseAnother => 'Escolher outro';

  @override
  String get multiplayerUnderstood => 'Entendi';

  @override
  String get multiplayerQuestion => 'Pergunta';

  @override
  String get multiplayerRoundResults => 'Resultados da Rodada';

  @override
  String get multiplayerCorrect => 'Acertou!';

  @override
  String get multiplayerWrong => 'Errou';

  @override
  String get multiplayerPosition => 'Posição';

  @override
  String get multiplayerPoints => 'Pontos';

  @override
  String get multiplayerCurrentRanking => 'Ranking Atual';

  @override
  String get multiplayerNextQuestion => 'Próxima Pergunta';

  @override
  String get multiplayerWaitingHost => 'Aguardando o anfitrião...';

  @override
  String get multiplayerYourNickname => 'Seu apelido';

  @override
  String get multiplayerRoomCode => 'Código da sala';

  @override
  String get multiplayerPlayers => 'Jogadores';

  @override
  String get multiplayerHost => 'Anfitrião';

  @override
  String get multiplayerGameOver => 'Fim de Jogo!';

  @override
  String get multiplayerCongrats => 'Parabéns! Você venceu! 🎉';

  @override
  String get multiplayerMatchEnded => 'Partida finalizada';

  @override
  String get multiplayerRestarting => 'Reiniciando...';

  @override
  String get multiplayerPlayAgainBtn => 'Jogar Novamente';

  @override
  String get multiplayerCloseRoom => 'Encerrar Sala';

  @override
  String get multiplayerRestartingMatch => 'Reiniciando partida...';

  @override
  String get multiplayerWaitingHostDecision =>
      'Aguardando decisão do anfitrião...';
}
