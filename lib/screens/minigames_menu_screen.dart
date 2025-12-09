import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../l10n/app_localizations.dart';
import 'minigames/tic_tac_toe_neon.dart' as neon;
import 'minigames/hangman_game.dart';
import 'minigames/word_search_enhanced.dart' as enhanced;
import 'minigames/maze_game.dart';
import 'minigames/sequence_game.dart';
import 'minigames/sequence_game_crystal.dart' as crystal;
import 'minigames/jigsaw_puzzle_game.dart';
import 'memory_game_screen.dart';

class MinigamesMenuScreen extends StatelessWidget {
  const MinigamesMenuScreen({super.key});

  // Retorna lista de jogos com strings traduzidas
  List<Map<String, dynamic>> _getMinigames(AppLocalizations l10n) {
    return [
      {
        'title': l10n.minigamesMemory,
        'desc': l10n.minigamesMemoryDesc,
        'color': const Color(0xFFFF6B6B),
        'screen': 'MemoryGame',
        'emoji': '🧠',
      },
      {
        'title': l10n.minigamesTicTacToe,
        'desc': l10n.minigamesTicTacToeDesc,
        'color': const Color(0xFF4A90E2),
        'screen': 'TicTacToeNeon',
        'emoji': '⭕',
      },
      {
        'title': l10n.minigamesHangman,
        'desc': l10n.minigamesHangmanDesc,
        'color': const Color(0xFFE24A4A),
        'screen': 'HangmanGame',
        'emoji': '🎯',
      },
      {
        'title': l10n.minigamesWordSearch,
        'desc': l10n.minigamesWordSearchDesc,
        'color': const Color(0xFF50C878),
        'screen': 'WordSearchEnhanced',
        'emoji': '🔍',
      },
      {
        'title': l10n.minigamesMaze,
        'desc': l10n.minigamesMazeDesc,
        'color': const Color(0xFFFF9500),
        'screen': 'MazeGame',
        'emoji': '🏃',
      },
      {
        'title': l10n.minigamesSequence,
        'desc': l10n.minigamesSequenceDesc,
        'color': const Color(0xFF9B59B6),
        'screen': 'SequenceGame',
        'emoji': '🔢',
      },
      {
        'title': l10n.minigamesSequenceCrystal,
        'desc': l10n.minigamesSequenceCrystalDesc,
        'color': const Color(0xFF1C1C1C),
        'screen': 'SequenceCrystal',
        'emoji': '💎',
      },
      {
        'title': l10n.minigamesJigsaw,
        'desc': l10n.minigamesJigsawDesc,
        'color': const Color(0xFF16A085),
        'screen': 'JigsawPuzzleGame',
        'emoji': '🧩',
      },
    ];
  }

  Widget _getGameScreen(String screenName) {
    switch (screenName) {
      case 'MemoryGame':
        return const MemoryGameScreen();
      case 'TicTacToeNeon':
        return const neon.TicTacToeGame();
      case 'HangmanGame':
        return const HangmanGame();
      case 'WordSearchEnhanced':
        return const enhanced.WordSearchGame();
      case 'MazeGame':
        return const MazeGame();
      case 'SequenceGame':
        return const SequenceGame();
      case 'SequenceCrystal':
        return const crystal.SequenceGame();
      case 'JigsawPuzzleGame':
        return const JigsawPuzzleGame();
      default:
        return const neon.TicTacToeGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Color(0xFF101A2C),
      appBar: AppBar(
        title: Text(l10n.minigamesTitle, style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF162447),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            AudioService().playClick();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Builder(
          builder: (context) {
            final minigames = _getMinigames(l10n);
            return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: minigames.length,
          itemBuilder: (context, index) {
            final game = minigames[index];
            return GestureDetector(
              onTap: () {
                AudioService().playClick();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _getGameScreen(game['screen'] as String),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      game['color'],
                      game['color'].withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: game['color'].withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      game['emoji'],
                      style: TextStyle(fontSize: 48),
                    ),
                    SizedBox(height: 8),
                    Text(
                      game['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        game['desc'],
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
          },
        ),
        ),
      ),
    );
  }
}
