import 'dart:math';
import 'package:flutter/material.dart';
import '../models/stats_data.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import 'memory_game_screen.dart';
import 'minigames/coloring_game.dart';
import 'minigames/common/game_text.dart';
import 'minigames/common/game_ui.dart';
import 'minigames/hangman_game.dart';
import 'minigames/jigsaw_puzzle_game.dart';
import 'minigames/maze_game.dart';
import 'minigames/sequence_crystal_game.dart';
import 'minigames/tic_tac_toe_neon.dart' as neon;
import 'minigames/word_search_enhanced.dart' as words;
import '../theme/app_theme.dart';

class _GameEntry {
  final String id; // id usado nos recordes
  final String emoji;
  final String title;
  final String desc;
  final List<Color> colors;
  final bool isNew;
  final Widget Function() builder;
  const _GameEntry(this.id, this.emoji, this.title, this.desc, this.colors, this.builder, {this.isNew = false});
}

class MinigamesMenuScreen extends StatefulWidget {
  const MinigamesMenuScreen({super.key});

  @override
  State<MinigamesMenuScreen> createState() => _MinigamesMenuScreenState();
}

class _MinigamesMenuScreenState extends State<MinigamesMenuScreen> with SingleTickerProviderStateMixin {
  MinigameRecords? _records;
  late final AnimationController _float = AnimationController(vsync: this, duration: const Duration(seconds: 3))
    ..repeat();

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  Future<void> _loadRecords() async {
    final r = await StorageService().getMinigameRecords();
    if (mounted) setState(() => _records = r);
  }

  List<_GameEntry> get _games => [
        _GameEntry(
            'memory',
            '🧠',
            t3('Memória', 'Memory', 'Memoria'),
            t3('Vire as cartas e ache os pares', 'Flip cards and find pairs', 'Voltea cartas y encuentra pares'),
            const [Color(0xFFE11D48), Color(0xFF9F1239)],
            () => const MemoryGameScreen()),
        _GameEntry(
            'jigsaw_puzzle',
            '🧩',
            t3('Quebra-Cabeça', 'Jigsaw', 'Rompecabezas'),
            t3('Monte imagens peça por peça', 'Build images piece by piece', 'Arma imágenes pieza por pieza'),
            const [Color(0xFF0F766E), Color(0xFF134E4A)],
            () => const JigsawPuzzleGame()),
        _GameEntry(
            'coloring',
            '🎨',
            t3('Colorir', 'Coloring', 'Colorear'),
            t3('Pinte desenhos bíblicos', 'Paint Bible drawings', 'Pinta dibujos bíblicos'),
            const [Color(0xFFA21CAF), Color(0xFF6B21A8)],
            () => const ColoringGame(),
            isNew: true),
        _GameEntry(
            'hangman',
            '🎯',
            t3('Forca', 'Hangman', 'Ahorcado'),
            t3('Adivinhe a palavra com dicas', 'Guess the word with hints', 'Adivina la palabra con pistas'),
            const [Color(0xFFC2410C), Color(0xFF9A3412)],
            () => const HangmanGame()),
        _GameEntry(
            'word_search',
            '🔍',
            t3('Caça-Palavras', 'Word Search', 'Sopa de Letras'),
            t3('Encontre as palavras escondidas', 'Find the hidden words', 'Encuentra las palabras'),
            const [Color(0xFF047857), Color(0xFF065F46)],
            () => const words.WordSearchGame()),
        _GameEntry(
            'maze',
            '🌀',
            t3('Labirinto', 'Maze', 'Laberinto'),
            t3('30 cavernas com gemas', '30 caverns with gems', '30 cavernas con gemas'),
            const [Color(0xFFB45309), Color(0xFF92400E)],
            () => const MazeGame()),
        _GameEntry(
            'sequence',
            '💎',
            t3('Sequência Cristal', 'Crystal Sequence', 'Secuencia Cristal'),
            t3('Repita a melodia dos cristais', 'Repeat the crystal melody', 'Repite la melodía'),
            const [Color(0xFF7C3AED), Color(0xFF5B21B6)],
            () => const SequenceCrystalGame()),
        _GameEntry(
            'tictactoe',
            '⭕',
            t3('Jogo da Velha', 'Tic-Tac-Toe', 'Tres en Raya'),
            t3('Desafie a IA ou um amigo', 'Challenge the AI or a friend', 'Desafía a la IA o a un amigo'),
            const [Color(0xFF2563EB), Color(0xFF1E40AF)],
            () => const neon.TicTacToeGame()),
      ];

  String? _recordLine(String id) {
    final r = _records?.getRecord(id);
    if (r == null || r.gamesPlayed == 0) return null;
    if (id == 'sequence') return '🏆 ${t3('nível', 'level', 'nivel')} ${r.highScore}';
    if (id == 'coloring') return '🖼️ ${r.gamesWon}';
    if (r.gamesWon > 0) {
      final one = r.gamesWon == 1;
      return '🏆 ${r.gamesWon} ${t3(one ? 'vitória' : 'vitórias', one ? 'win' : 'wins', one ? 'victoria' : 'victorias')}';
    }
    return '🎮 ${r.gamesPlayed}';
  }

  @override
  Widget build(BuildContext context) {
    final games = _games;
    final palette = context.palette;
    return GameScaffold(
      title: t3('🎮 Minigames', '🎮 Minigames', '🎮 Minijuegos'),
      backgroundColors: [palette.backgroundTop, palette.background],
      forceDarkTheme: false, // o menu segue o tema do app
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
        // 2 colunas no celular, mais em telas largas
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 240,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.92,
        ),
        itemCount: games.length,
        itemBuilder: (context, i) {
          final g = games[i];
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 380 + i * 70),
            curve: Curves.easeOutBack,
            builder: (_, v, child) => Opacity(
              opacity: v.clamp(0.0, 1.0),
              child: Transform.translate(offset: Offset(0, (1 - v) * 40), child: child),
            ),
            child: _GameCard(
              entry: g,
              record: _recordLine(g.id),
              float: _float,
              phase: i * 0.37,
              onTap: () async {
                AudioService().playClick();
                Haptics.selection();
                await Navigator.of(context).push(MaterialPageRoute(builder: (_) => g.builder()));
                AudioService().playBackgroundMusic('home');
                _loadRecords();
              },
            ),
          );
        },
      ),
    );
  }
}

class _GameCard extends StatefulWidget {
  final _GameEntry entry;
  final String? record;
  final Animation<double> float;
  final double phase;
  final VoidCallback onTap;
  const _GameCard(
      {required this.entry, required this.record, required this.float, required this.phase, required this.onTap});

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final g = widget.entry;
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) {
        setState(() => _down = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _down ? 0.95 : 1,
        duration: const Duration(milliseconds: 110),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: g.colors),
            boxShadow: [
              BoxShadow(color: g.colors.first.withValues(alpha: 0.35), blurRadius: 14, offset: const Offset(0, 6))
            ],
          ),
          child: Stack(
            children: [
              // Brilho decorativo
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.12)),
                ),
              ),
              LayoutBuilder(builder: (context, box) {
                // Emoji e textos proporcionais ao tamanho do cartão
                final k = (box.maxWidth / 180).clamp(0.85, 1.5);
                return Padding(
                  padding: EdgeInsets.fromLTRB(14 * k, 14 * k, 14 * k, 12 * k),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: widget.float,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(0, sin((widget.float.value + widget.phase) * 2 * pi) * 4),
                          child: child,
                        ),
                        child: Text(g.emoji, style: TextStyle(fontSize: box.maxWidth * 0.26)),
                      ),
                      const Spacer(),
                      Text(g.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 17 * k, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 2),
                      Text(g.desc,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11.5 * k, height: 1.2)),
                      if (widget.record != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                          child: Text(widget.record!,
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                );
              }),
              if (g.isNew)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: GameColors.gold,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: Text(t3('NOVO', 'NEW', 'NUEVO'),
                        style: const TextStyle(color: Color(0xFF3A2A00), fontSize: 10, fontWeight: FontWeight.w900)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
