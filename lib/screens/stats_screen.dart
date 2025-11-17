import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/stats_data.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with SingleTickerProviderStateMixin {
  final StorageService _storage = StorageService();
  GlobalStats? _globalStats;
  MinigameRecords? _minigameRecords;
  List<QuizHistory> _recentHistory = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadStats();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    
    final globalStats = await _storage.getGlobalStats();
    final minigameRecords = await _storage.getMinigameRecords();
    final history = await _storage.getQuizHistory(limit: 10);
    
    setState(() {
      _globalStats = globalStats;
      _minigameRecords = minigameRecords;
      _recentHistory = history;
      _isLoading = false;
    });
  }

  Widget _buildStatCard({
    required String emoji,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF162447),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: 36)),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({
    required String label,
    required double percentage,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Color(0xFF23395D),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101A2C),
      appBar: AppBar(
        title: Text('Estatísticas', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF162447),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(icon: Icon(Icons.quiz), text: 'Quiz'),
            Tab(icon: Icon(Icons.games), text: 'Minigames'),
            Tab(icon: Icon(Icons.history), text: 'Histórico'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.amber))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildQuizStatsTab(),
                _buildMinigamesStatsTab(),
                _buildHistoryTab(),
              ],
            ),
    );
  }

  Widget _buildQuizStatsTab() {
    if (_globalStats == null) {
      return Center(
        child: Text(
          'Nenhum dado disponível',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estatísticas principais
          Text(
            '📊 Desempenho Geral',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              _buildStatCard(
                emoji: '🧠',
                title: 'Quizzes\nRealizados',
                value: '${_globalStats!.totalQuizzes}',
              ),
              _buildStatCard(
                emoji: '✅',
                title: 'Taxa de\nAcerto',
                value: '${_globalStats!.accuracy.toStringAsFixed(1)}%',
                valueColor: Colors.green,
              ),
              _buildStatCard(
                emoji: '🏆',
                title: 'Melhor\nScore',
                value: '${_globalStats!.highScore}',
                valueColor: Colors.orange,
              ),
              _buildStatCard(
                emoji: '🔥',
                title: 'Sequência\nAtual',
                value: '${_globalStats!.currentStreak}',
                valueColor: Colors.red,
              ),
            ],
          ),
          
          SizedBox(height: 24),
          
          // Streak info
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF162447), Color(0xFF1F4068)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('🔥', style: TextStyle(fontSize: 32)),
                        SizedBox(height: 8),
                        Text(
                          '${_globalStats!.currentStreak}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Sequência Atual',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('🏅', style: TextStyle(fontSize: 32)),
                        SizedBox(height: 8),
                        Text(
                          '${_globalStats!.longestStreak}',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Melhor Sequência',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Mantenha 80%+ de acerto para continuar a sequência!',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24),
          
          // Desempenho por categoria
          if (_globalStats!.scoresByCategory.isNotEmpty) ...[
            Text(
              '📚 Por Categoria',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            ..._globalStats!.scoresByCategory.entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: _buildCategoryBar(entry.key, entry.value),
              );
            }).toList(),
          ],
          
          SizedBox(height: 24),
          
          // Precisão por dificuldade
          if (_globalStats!.accuracyByDifficulty.isNotEmpty) ...[
            Text(
              '🎯 Precisão por Dificuldade',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF162447),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: _globalStats!.accuracyByDifficulty.entries.map((entry) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: _buildProgressBar(
                      label: _getDifficultyLabel(entry.key),
                      percentage: entry.value.toDouble(),
                      color: _getDifficultyColor(entry.key),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMinigamesStatsTab() {
    if (_minigameRecords == null || _minigameRecords!.records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🎮', style: TextStyle(fontSize: 64)),
            SizedBox(height: 16),
            Text(
              'Nenhum minigame jogado ainda',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      );
    }

    final gameNames = {
      'puzzle': '🧩 Quebra-Cabeça',
      'hangman': '📝 Forca',
      'word_search': '🔍 Caça-Palavras',
      'maze': '🌀 Labirinto',
      'sequence': '🎵 Sequência',
      'tictactoe': '⭕ Jogo da Velha',
      'memory': '🧠 Jogo da Memória',
    };

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          '🕹️ Estatísticas dos Minigames',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        
        ..._minigameRecords!.records.entries.map((entry) {
          final gameId = entry.key;
          final record = entry.value;
          final gameName = gameNames[gameId] ?? '🎮 $gameId';
          
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF162447),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gameName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMinigameStat('🎮', 'Jogos', '${record.gamesPlayed}'),
                    _buildMinigameStat('🏆', 'Vitórias', '${record.gamesWon}'),
                    _buildMinigameStat('📊', 'Taxa', '${record.winRate.toStringAsFixed(1)}%'),
                    _buildMinigameStat('⭐', 'Recorde', '${record.highScore}'),
                  ],
                ),
                if (record.bestTime != null && record.bestTime! > 0) ...[
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      '⏱️ Melhor tempo: ${_formatTime(record.bestTime!)}',
                      style: TextStyle(color: Colors.amber, fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildHistoryTab() {
    if (_recentHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('📜', style: TextStyle(fontSize: 64)),
            SizedBox(height: 16),
            Text(
              'Nenhum histórico disponível',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _recentHistory.length,
      itemBuilder: (context, index) {
        final quiz = _recentHistory[index];
        final accuracy = (quiz.correctAnswers / quiz.totalQuestions) * 100;
        
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF162447),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: accuracy >= 80 ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(quiz.playedAt),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getModeColor(quiz.mode),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      quiz.mode.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '⭐ ${quiz.score}',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    '${quiz.correctAnswers}/${quiz.totalQuestions}',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '(${accuracy.toStringAsFixed(1)}%)',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (quiz.category != null) ...[
                SizedBox(height: 4),
                Text(
                  '📚 ${quiz.category}',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
              if (quiz.difficulty != null) ...[
                SizedBox(height: 4),
                Text(
                  '🎯 ${_getDifficultyLabel(quiz.difficulty!)}',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildMinigameStat(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 20)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white60, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildCategoryBar(String category, int score) {
    final maxScore = _globalStats!.scoresByCategory.values.reduce((a, b) => a > b ? a : b);
    final percentage = maxScore > 0 ? (score / maxScore) * 100 : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            Text(
              '$score pts',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Color(0xFF23395D),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  Color _getModeColor(String mode) {
    switch (mode.toLowerCase()) {
      case 'rapido':
        return Colors.orange;
      case 'personalizado':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  String _getDifficultyLabel(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'facil':
        return 'Fácil';
      case 'medio':
        return 'Médio';
      case 'dificil':
        return 'Difícil';
      default:
        return difficulty;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'facil':
        return Colors.green;
      case 'medio':
        return Colors.orange;
      case 'dificil':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
