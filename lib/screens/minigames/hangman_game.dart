import 'package:flutter/material.dart';
import 'dart:math';
import '../../services/audio_service.dart';

class HangmanGame extends StatefulWidget {
  const HangmanGame({super.key});

  @override
  State<HangmanGame> createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  // Palavras bíblicas seguras
  final List<String> words = [
    "MOISES", "DANIEL", "JESUS", "RUTE", "ESTER", "ISAIAS",
    "AMOR", "FE", "SALMO", "JOSE", "PAZ", "ABRAAO", "ORACAO",
    "DAVI", "MARIA", "PEDRO", "PAULO", "JOAO", "ATOS", "GENESIS"
  ];

  late String chosenWord;
  List<String> guessedLetters = [];
  List<String> wrongLetters = [];
  int maxErrors = 6;

  @override
  void initState() {
    super.initState();
    _restartGame();
  }

  void _restartGame() {
    AudioService().playClick();
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
      } else {
        AudioService().playCorrectAnswer();
      }
    } else {
      wrongLetters.add(letter);
      if (hasLost) {
        AudioService().playGameOver();
      } else {
        AudioService().playWrongAnswer();
      }
    }

    setState(() {});
  }

  Widget _buildHangmanDrawing() {
    int errors = wrongLetters.length;

    return Column(
      children: [
        Text("Erros: $errors / $maxErrors",
            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Container(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Base
              if (errors >= 1) Positioned(bottom: 0, child: Container(width: 100, height: 5, color: Colors.brown)),
              // Poste vertical
              if (errors >= 2) Positioned(bottom: 0, left: 40, child: Container(width: 5, height: 150, color: Colors.brown)),
              // Poste horizontal
              if (errors >= 3) Positioned(top: 0, left: 40, child: Container(width: 80, height: 5, color: Colors.brown)),
              // Corda
              if (errors >= 4) Positioned(top: 5, right: 20, child: Container(width: 2, height: 30, color: Colors.brown)),
              // Cabeça
              if (errors >= 5) Positioned(top: 35, right: 10, child: Container(width: 30, height: 30, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)))),
              // Corpo
              if (errors >= 6) Positioned(top: 65, right: 23, child: Container(width: 4, height: 50, color: Colors.white)),
            ],
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

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: letters.split('').map((letter) {
        bool disabled = guessedLetters.contains(letter) ||
            wrongLetters.contains(letter) ||
            hasWon ||
            hasLost;

        bool isWrong = wrongLetters.contains(letter);
        bool isCorrect = guessedLetters.contains(letter);

        return ElevatedButton(
          onPressed: disabled ? null : () => _guessLetter(letter),
          style: ElevatedButton.styleFrom(
            backgroundColor: isCorrect ? Colors.green : (isWrong ? Colors.red.shade300 : Color(0xFF4A90E2)),
            disabledBackgroundColor: isCorrect ? Colors.green.shade700 : (isWrong ? Colors.red.shade700 : Colors.grey.shade600),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: Text(letter, style: TextStyle(fontWeight: FontWeight.bold)),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101A2C),
      appBar: AppBar(
        title: const Text("Jogo da Forca", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF162447),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHangmanDrawing(),
              const SizedBox(height: 20),
              _buildWordDisplay(),
              const SizedBox(height: 20),
              if (!hasWon && !hasLost) _buildKeyboard(),
              const SizedBox(height: 20),
              if (hasWon)
                const Text(
                  "🎉 Parabéns! Você acertou!",
                  style: TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              if (hasLost)
                Text(
                  "😢 Você perdeu!\nA palavra era: $chosenWord",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _restartGame,
                icon: Icon(Icons.refresh),
                label: const Text("Jogar Novamente"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE24A4A),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
