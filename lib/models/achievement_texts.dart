import '../services/language_service.dart';

/// Nomes e descrições das conquistas nos 3 idiomas (chave = nameKey).
const Map<String, Map<String, List<String>>> _texts = {
  'achievement_first_step': {
    'pt': ['Primeiro Passo', 'Complete seu primeiro quiz'],
    'en': ['First Step', 'Complete your first quiz'],
    'es': ['Primer Paso', 'Completa tu primer quiz'],
  },
  'achievement_scholar': {
    'pt': ['Estudioso', 'Complete 10 quizzes'],
    'en': ['Scholar', 'Complete 10 quizzes'],
    'es': ['Estudioso', 'Completa 10 quizzes'],
  },
  'achievement_perfectionist': {
    'pt': ['Perfeccionista', 'Acerte todas as perguntas de um quiz'],
    'en': ['Perfectionist', 'Answer every question of a quiz correctly'],
    'es': ['Perfeccionista', 'Acierta todas las preguntas de un quiz'],
  },
  'achievement_speedster': {
    'pt': ['Velocista', 'Termine um quiz de 10+ perguntas em menos de 2 minutos'],
    'en': ['Speedster', 'Finish a 10+ question quiz in under 2 minutes'],
    'es': ['Velocista', 'Termina un quiz de 10+ preguntas en menos de 2 minutos'],
  },
  'achievement_perfect_streak': {
    'pt': ['Sequência Perfeita', 'Faça 5 quizzes seguidos com 80% de acertos ou mais'],
    'en': ['Perfect Streak', 'Score 80%+ on 5 quizzes in a row'],
    'es': ['Racha Perfecta', 'Logra 80%+ en 5 quizzes seguidos'],
  },
  'achievement_bible_master': {
    'pt': ['Mestre Bíblico', 'Complete 50 quizzes'],
    'en': ['Bible Master', 'Complete 50 quizzes'],
    'es': ['Maestro Bíblico', 'Completa 50 quizzes'],
  },
  'achievement_explorer': {
    'pt': ['Explorador', 'Jogue 7 minigames diferentes'],
    'en': ['Explorer', 'Play 7 different minigames'],
    'es': ['Explorador', 'Juega 7 minijuegos diferentes'],
  },
  'achievement_puzzle_master': {
    'pt': ['Mestre dos Puzzles', 'Monte um quebra-cabeça em menos de 2 minutos'],
    'en': ['Puzzle Master', 'Finish a jigsaw puzzle in under 2 minutes'],
    'es': ['Maestro de Puzzles', 'Arma un rompecabezas en menos de 2 minutos'],
  },
  'achievement_photographic_memory': {
    'pt': ['Memória Fotográfica', 'Vença o jogo da memória sem errar nenhum par'],
    'en': ['Photographic Memory', 'Win the memory game without a single mistake'],
    'es': ['Memoria Fotográfica', 'Gana el juego de memoria sin fallar ningún par'],
  },
  'achievement_sharpshooter': {
    'pt': ['Estrategista', 'Vença a IA 10 vezes no Jogo da Velha'],
    'en': ['Strategist', 'Beat the AI 10 times at Tic-Tac-Toe'],
    'es': ['Estratega', 'Vence a la IA 10 veces en Tres en Raya'],
  },
  'achievement_minigame_champion': {
    'pt': ['Campeão dos Minigames', 'Vença 21 partidas de minigames'],
    'en': ['Minigame Champion', 'Win 21 minigame matches'],
    'es': ['Campeón de Minijuegos', 'Gana 21 partidas de minijuegos'],
  },
  'achievement_social': {
    'pt': ['Social', 'Jogue uma partida online'],
    'en': ['Social', 'Play an online match'],
    'es': ['Social', 'Juega una partida en línea'],
  },
  'achievement_competitor': {
    'pt': ['Competidor', 'Vença 5 partidas online'],
    'en': ['Competitor', 'Win 5 online matches'],
    'es': ['Competidor', 'Gana 5 partidas en línea'],
  },
  'achievement_collector': {
    'pt': ['Colecionador', 'Desbloqueie 10 conquistas'],
    'en': ['Collector', 'Unlock 10 achievements'],
    'es': ['Coleccionista', 'Desbloquea 10 logros'],
  },
  'achievement_legend': {
    'pt': ['Lenda', 'Desbloqueie todas as conquistas'],
    'en': ['Legend', 'Unlock every achievement'],
    'es': ['Leyenda', 'Desbloquea todos los logros'],
  },
};

List<String>? _lookup(String nameKey) {
  final entry = _texts[nameKey];
  if (entry == null) return null;
  return entry[LanguageService().currentLanguageCode] ?? entry['pt'];
}

String achievementName(String nameKey) =>
    _lookup(nameKey)?[0] ?? nameKey.replaceAll('achievement_', '').replaceAll('_', ' ');

String achievementDescription(String nameKey) => _lookup(nameKey)?[1] ?? '';
