import 'package:flutter/material.dart';
import 'dart:math';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import '../../services/achievement_service.dart';
import '../../services/minigame_content_service.dart';
import '../../widgets/achievement_unlock_dialog.dart';
import '../../l10n/app_localizations.dart';

// Custom Painter para desenhar o boneco da forca
class HangmanPainter extends CustomPainter {
  final int errors;

  HangmanPainter(this.errors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double centerX = size.width / 2;
    double headY = size.height * 0.22;
    double headRadius = 28.0;
    
    // 1. Cabeça com detalhes
    if (errors >= 1) {
      // Sombra da cabeça
      canvas.drawCircle(
        Offset(centerX + 2, headY + 2),
        headRadius,
        shadowPaint,
      );
      
      // Cabeça
      canvas.drawCircle(
        Offset(centerX, headY),
        headRadius,
        paint,
      );
      
      // Cabelo (mechas simples)
      final hairPaint = Paint()
        ..color = Colors.white70
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      
      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX - 10, headY - 20), radius: 12),
        3.14, 1.5, false, hairPaint,
      );
      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX + 5, headY - 22), radius: 10),
        3.14, 1.2, false, hairPaint,
      );
      
      // Olhos - mudam conforme erros
      if (errors < 6) {
        // Olhos preocupados (círculos)
        canvas.drawCircle(
          Offset(centerX - 9, headY - 3),
          4,
          fillPaint,
        );
        canvas.drawCircle(
          Offset(centerX + 9, headY - 3),
          4,
          fillPaint,
        );
        
        // Sobrancelhas preocupadas
        canvas.drawLine(
          Offset(centerX - 15, headY - 12),
          Offset(centerX - 5, headY - 10),
          hairPaint,
        );
        canvas.drawLine(
          Offset(centerX + 15, headY - 12),
          Offset(centerX + 5, headY - 10),
          hairPaint,
        );
      } else {
        // Olhos X (morto)
        final xPaint = Paint()
          ..color = Colors.white
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;
        
        canvas.drawLine(
          Offset(centerX - 12, headY - 6),
          Offset(centerX - 5, headY + 1),
          xPaint,
        );
        canvas.drawLine(
          Offset(centerX - 12, headY + 1),
          Offset(centerX - 5, headY - 6),
          xPaint,
        );
        canvas.drawLine(
          Offset(centerX + 5, headY - 6),
          Offset(centerX + 12, headY + 1),
          xPaint,
        );
        canvas.drawLine(
          Offset(centerX + 5, headY + 1),
          Offset(centerX + 12, headY - 6),
          xPaint,
        );
      }
      
      // Boca - muda conforme erros
      final mouthPath = Path();
      if (errors < 3) {
        // Boca neutra/preocupada
        mouthPath.moveTo(centerX - 8, headY + 10);
        mouthPath.lineTo(centerX + 8, headY + 10);
      } else if (errors < 6) {
        // Boca triste
        mouthPath.moveTo(centerX - 10, headY + 13);
        mouthPath.quadraticBezierTo(
          centerX, headY + 8,
          centerX + 10, headY + 13,
        );
      } else {
        // Boca com língua pra fora
        mouthPath.moveTo(centerX - 10, headY + 10);
        mouthPath.quadraticBezierTo(
          centerX, headY + 6,
          centerX + 10, headY + 10,
        );
        // Língua
        final tonguePaint = Paint()
          ..color = Colors.pinkAccent.withValues(alpha: 0.7)
          ..style = PaintingStyle.fill;
        canvas.drawOval(
          Rect.fromCenter(center: Offset(centerX, headY + 16), width: 8, height: 10),
          tonguePaint,
        );
      }
      canvas.drawPath(mouthPath, paint..strokeWidth = 2);
      paint.strokeWidth = 3.5;
    }

    double neckY = headY + headRadius + 2;
    double bodyEndY = size.height * 0.52;

    // 2. Corpo (torso)
    if (errors >= 2) {
      // Sombra
      canvas.drawLine(
        Offset(centerX + 2, neckY + 2),
        Offset(centerX + 2, bodyEndY + 2),
        shadowPaint,
      );
      // Corpo
      canvas.drawLine(
        Offset(centerX, neckY),
        Offset(centerX, bodyEndY),
        paint,
      );
    }

    double armY = neckY + 15;

    // 3. Braço esquerdo com mão
    if (errors >= 3) {
      double armEndX = centerX - 30;
      double armEndY = size.height * 0.42;
      
      canvas.drawLine(
        Offset(centerX, armY),
        Offset(armEndX, armEndY),
        paint,
      );
      
      // Mão (círculo pequeno)
      canvas.drawCircle(
        Offset(armEndX - 3, armEndY + 2),
        5,
        fillPaint,
      );
    }

    // 4. Braço direito com mão
    if (errors >= 4) {
      double armEndX = centerX + 30;
      double armEndY = size.height * 0.42;
      
      canvas.drawLine(
        Offset(centerX, armY),
        Offset(armEndX, armEndY),
        paint,
      );
      
      // Mão
      canvas.drawCircle(
        Offset(armEndX + 3, armEndY + 2),
        5,
        fillPaint,
      );
    }

    // 5. Perna esquerda com pé
    if (errors >= 5) {
      double legEndX = centerX - 22;
      double legEndY = size.height * 0.72;
      
      canvas.drawLine(
        Offset(centerX, bodyEndY),
        Offset(legEndX, legEndY),
        paint,
      );
      
      // Pé (oval horizontal)
      canvas.drawOval(
        Rect.fromCenter(center: Offset(legEndX - 5, legEndY + 3), width: 14, height: 8),
        fillPaint,
      );
    }

    // 6. Perna direita com pé - GAME OVER
    if (errors >= 6) {
      double legEndX = centerX + 22;
      double legEndY = size.height * 0.72;
      
      canvas.drawLine(
        Offset(centerX, bodyEndY),
        Offset(legEndX, legEndY),
        paint,
      );
      
      // Pé
      canvas.drawOval(
        Rect.fromCenter(center: Offset(legEndX + 5, legEndY + 3), width: 14, height: 8),
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(HangmanPainter oldDelegate) => errors != oldDelegate.errors;
}

class HangmanGame extends StatefulWidget {
  const HangmanGame({super.key});

  @override
  State<HangmanGame> createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  final StorageService _storage = StorageService();
  final AchievementService _achievementService = AchievementService();
  final MinigameContentService _contentService = MinigameContentService();

  late String chosenWord;
  List<String> guessedLetters = [];
  List<String> wrongLetters = [];
  int maxErrors = 6;
  DateTime? _gameStartTime;

  // Key para animações de nova partida
  Key _gameKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _gameStartTime = DateTime.now();
    _restartGame();
  }

  void _restartGame() {
    AudioService().playClick();
    _gameKey = UniqueKey();
    final words = _contentService.hangmanWords;
    chosenWord = words[Random().nextInt(words.length)];
    guessedLetters = [];
    wrongLetters = [];
    setState(() {});
  }

  bool get hasWon =>
      chosenWord.split('').every((letter) => guessedLetters.contains(letter));

  bool get hasLost => wrongLetters.length >= maxErrors;

  void _guessLetter(String letter) {
    if (guessedLetters.contains(letter) || wrongLetters.contains(letter)) {
      return;
    }

    AudioService().playClick();

    if (chosenWord.contains(letter)) {
      guessedLetters.add(letter);
      if (hasWon) {
        AudioService().playVictory();
        _saveGameResult(won: true);
      } else {
        AudioService().playCorrectAnswer();
      }
    } else {
      wrongLetters.add(letter);
      if (hasLost) {
        AudioService().playGameOver();
        _saveGameResult(won: false);
      } else {
        AudioService().playWrongAnswer();
      }
    }

    setState(() {});
  }

  Future<void> _saveGameResult({required bool won}) async {
    final timeSpent = _gameStartTime != null
        ? DateTime.now().difference(_gameStartTime!).inSeconds
        : 0;

    await _storage.saveMinigameRecord(
      'hangman',
      score: won ? (100 - wrongLetters.length * 10) : 0,
      won: won,
      timeInSeconds: timeSpent,
    );

    if (won) {
      final records = await _storage.getMinigameRecords();
      final hangmanRecord = records.getRecord('hangman');
      
      final unlockedAchievements = await _achievementService.checkMinigameAchievements(
        gameId: 'hangman',
        totalGamesPlayed: hangmanRecord.gamesPlayed,
        won: won,
        timeInSeconds: timeSpent,
      );
      
      if (mounted && unlockedAchievements.isNotEmpty) {
        for (final achievement in unlockedAchievements) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AchievementUnlockDialog(achievement: achievement),
          );
        }
      }
    }
  }

  Widget _buildHangmanDrawing(AppLocalizations l10n) {
    int errors = wrongLetters.length;

    return Column(
      children: [
        Text(l10n.hangmanErrors(errors, maxErrors),
            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Center(
          child: Container(
            height: 200,
            width: 200,
            alignment: Alignment.center,
            child: CustomPaint(
              painter: HangmanPainter(errors),
              size: const Size(200, 200),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWordDisplay() {
    return Wrap(
      spacing: 8,
      alignment: WrapAlignment.center,
      children: chosenWord
          .split('')
          .map((letter) => Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFF1E2A3A),
                ),
                child: Text(
                  guessedLetters.contains(letter) ? letter : "_",
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildKeyboard() {
    const letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    // Layout responsivo para mobile
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcula tamanho dos botões baseado na largura disponível
        double buttonSize = (constraints.maxWidth - 60) / 7; // 7 botões por linha com espaçamento
        buttonSize = buttonSize.clamp(32.0, 48.0); // Mínimo 32, máximo 48

        return Wrap(
          spacing: 4,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: letters.split('').map((letter) {
            bool disabled = guessedLetters.contains(letter) ||
                wrongLetters.contains(letter) ||
                hasWon ||
                hasLost;

            bool isWrong = wrongLetters.contains(letter);
            bool isCorrect = guessedLetters.contains(letter);

            return SizedBox(
              width: buttonSize,
              height: buttonSize,
              child: ElevatedButton(
                onPressed: disabled ? null : () => _guessLetter(letter),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCorrect ? Colors.green : (isWrong ? Colors.red.shade300 : Color(0xFF4A90E2)),
                  disabledBackgroundColor: isCorrect ? Colors.green.shade700 : (isWrong ? Colors.red.shade700 : Colors.grey.shade600),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.all(4),
                ),
                child: FittedBox(
                  child: Text(
                    letter,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Scaffold(
        key: _gameKey,
      appBar: AppBar(
        title: Text(l10n.hangmanTitle, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF162447),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHangmanDrawing(l10n),
            const SizedBox(height: 20),
            _buildWordDisplay(),
            const SizedBox(height: 20),
            if (hasWon)
              Text(
                l10n.hangmanCongrats,
                style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            if (hasLost)
              Column(
                children: [
                  Text(
                    "${l10n.hangmanYouLost}\n${l10n.hangmanWordWas(chosenWord)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  if (wrongLetters.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.hangmanWrongLetters(wrongLetters.join(', ')),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w500),
                    ),
                  ],
                ],
              ),
            const SizedBox(height: 20),
            if (!hasWon && !hasLost) _buildKeyboard(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _restartGame,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.hangmanPlayAgain),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE24A4A),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
        ),
      ),
    );
  }
}
