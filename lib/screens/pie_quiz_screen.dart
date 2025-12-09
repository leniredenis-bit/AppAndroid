import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/audio_service.dart';
import '../widgets/bible_reference_button.dart';
import '../l10n/app_localizations.dart';

class PieQuizScreen extends StatefulWidget {
  final List<Question> questions;
  final String playerName;

  const PieQuizScreen({
    super.key,
    required this.questions,
    required this.playerName,
  });

  @override
  State<PieQuizScreen> createState() => _PieQuizScreenState();
}

class _PieQuizScreenState extends State<PieQuizScreen> {
  int _currentQuestionIndex = 0;
  int _player1Score = 0;
  int _player2Score = 0;
  bool _showAnswer = false;
  int? _currentRoundWinner; // null, 1 ou 2

  @override
  void initState() {
    super.initState();
    // Inicia música de fundo
    AudioService().playBackgroundMusic('pie');
  }

  @override
  void dispose() {
    AudioService().stopBackgroundMusic();
    super.dispose();
  }

  Question get _currentQuestion => widget.questions[_currentQuestionIndex];
  bool get _isLastQuestion => _currentQuestionIndex == widget.questions.length - 1;

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  void _markPoint(int player) {
    setState(() {
      if (_currentRoundWinner == player) {
        // Se já marcou para este jogador, desmarca
        _currentRoundWinner = null;
      } else {
        // Som de acerto ao marcar ponto
        AudioService().playCorrectAnswer();
        
        // Remove ponto do outro jogador se tiver
        if (_currentRoundWinner != null) {
          if (_currentRoundWinner == 1) {
            _player1Score--;
          } else {
            _player2Score--;
          }
        }
        // Marca ponto para o jogador atual
        _currentRoundWinner = player;
        if (player == 1) {
          _player1Score++;
        } else {
          _player2Score++;
        }
      }
    });
  }

  void _nextQuestion() {
    if (_isLastQuestion) {
      _showResults();
    } else {
      setState(() {
        _currentQuestionIndex++;
        _showAnswer = false;
        _currentRoundWinner = null;
      });
    }
  }

  void _showResults() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF162447),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '🎉 ${l10n.pieEndGame}',
          style: const TextStyle(color: Colors.white, fontSize: 24),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            _buildFinalScoreCard(1, _player1Score, l10n.pieQuizPlayer(1)),
            const SizedBox(height: 16),
            _buildFinalScoreCard(2, _player2Score, l10n.pieQuizPlayer(2)),
            const SizedBox(height: 20),
            Text(
              _player1Score > _player2Score
                  ? '🏆 ${l10n.piePlayerWon(1)}'
                  : _player2Score > _player1Score
                      ? '🏆 ${l10n.piePlayerWon(2)}'
                      : '🤝 ${l10n.pieTie}',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              '🏠 ${l10n.pieHome}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalScoreCard(int player, int score, String playerLabel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF23395D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _player1Score == _player2Score
              ? Colors.amber
              : (player == 1 && _player1Score > _player2Score) ||
                      (player == 2 && _player2Score > _player1Score)
                  ? Colors.amber
                  : Colors.white24,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            playerLabel,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            score.toString(),
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF101A2C),
      appBar: AppBar(
        title: const Text('🥧 Quiz Torta na Cara', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF23395D),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Placar
            Row(
              children: [
                Expanded(
                  child: _buildScoreCard(
                    player: 1,
                    score: _player1Score,
                    hasPoint: _currentRoundWinner == 1,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildScoreCard(
                    player: 2,
                    score: _player2Score,
                    hasPoint: _currentRoundWinner == 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Contador de perguntas
            Text(
              'Pergunta ${_currentQuestionIndex + 1} de ${widget.questions.length}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),

            // Pergunta
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF162447),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dificuldade e ID
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(_currentQuestion.dificuldade),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _getDifficultyText(_currentQuestion.dificuldade),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'ID: ${_currentQuestion.id}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Pergunta
                          Text(
                            _currentQuestion.pergunta,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Botão Ver/Ocultar Resposta
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _toggleAnswer,
                        icon: Icon(_showAnswer ? Icons.visibility_off : Icons.visibility),
                        label: Text(
                          _showAnswer ? l10n.pieQuizHideAnswer : l10n.pieQuizShowAnswer,
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF23395D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    // Resposta (quando visível)
                    if (_showAnswer) ...[
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B5E20),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.lightGreenAccent),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.pieCorrectAnswer,
                                  style: const TextStyle(
                                    color: Colors.lightGreenAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currentQuestion.opcoes[_currentQuestion.respostaCorreta],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Referência Bíblica (agora é um link clicável)
                            if (_currentQuestion.textoBiblico != null && 
                                _currentQuestion.textoBiblico!.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              BibleReferenceButton(reference: _currentQuestion.textoBiblico!),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botões de pontuação
            Text(
              l10n.pieWhoGotIt,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _markPoint(1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentRoundWinner == 1
                          ? Colors.amber
                          : const Color(0xFF23395D),
                      foregroundColor: _currentRoundWinner == 1
                          ? Colors.black
                          : Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: _currentRoundWinner == 1
                              ? Colors.amber
                              : Colors.white24,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      _currentRoundWinner == 1
                          ? '✓ ${l10n.pieQuizPlayer(1)}'
                          : '👤 ${l10n.pieQuizPlayer(1)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _markPoint(2),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentRoundWinner == 2
                          ? Colors.amber
                          : const Color(0xFF23395D),
                      foregroundColor: _currentRoundWinner == 2
                          ? Colors.black
                          : Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: _currentRoundWinner == 2
                              ? Colors.amber
                              : Colors.white24,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      _currentRoundWinner == 2
                          ? '✓ ${l10n.pieQuizPlayer(2)}'
                          : '👤 ${l10n.pieQuizPlayer(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Botão Próxima
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isLastQuestion ? l10n.pieQuizFinalResult : l10n.pieQuizNextQuestion,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard({
    required int player,
    required int score,
    required bool hasPoint,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162447),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasPoint ? Colors.amber : Colors.white24,
          width: hasPoint ? 3 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.pieQuizPlayer(player),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              if (hasPoint)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            score.toString(),
            style: TextStyle(
              color: hasPoint ? Colors.amber : Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getDifficultyText(int difficulty) {
    final l10n = AppLocalizations.of(context)!;
    switch (difficulty) {
      case 1:
        return l10n.difficultyEasy;
      case 2:
        return l10n.difficultyMedium;
      case 3:
        return l10n.difficultyHard;
      default:
        return l10n.difficultyNormal;
    }
  }
}
