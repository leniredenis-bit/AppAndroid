import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../services/achievement_service.dart';
import '../services/audio_service.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> with SingleTickerProviderStateMixin {
  final AchievementService _achievementService = AchievementService();
  final AudioService _audioService = AudioService();
  
  List<Achievement> _achievements = [];
  AchievementCategory? _selectedCategory;
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadAchievements();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAchievements() async {
    setState(() => _isLoading = true);
    try {
      final achievements = await _achievementService.getAchievements();
      setState(() {
        _achievements = achievements;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar conquistas: $e')),
        );
      }
    }
  }

  List<Achievement> get _filteredAchievements {
    if (_selectedCategory == null) return _achievements;
    return _achievements.where((a) => a.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _achievementService.getStats();
    final unlockedCount = stats['unlocked'] ?? 0;
    final totalCount = stats['total'] ?? 0;
    final percentage = stats['percentage'] ?? 0;

    return Scaffold(
      backgroundColor: Color(0xFF101A2C),
      appBar: AppBar(
        title: Text('Conquistas', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF162447),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _audioService.playClick();
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF4A90E2)))
          : Column(
              children: [
                // Header com estatísticas
                _buildStatsHeader(unlockedCount, totalCount, percentage),

                // Tabs de categorias
                _buildCategoryTabs(),

                // Grid de conquistas
                Expanded(
                  child: _filteredAchievements.isEmpty
                      ? _buildEmptyState()
                      : _buildAchievementGrid(),
                ),
              ],
            ),
    );
  }

  Widget _buildStatsHeader(int unlocked, int total, int percentage) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E2A3A), Color(0xFF2A3F5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 32),
              SizedBox(width: 12),
              Text(
                '$unlocked / $total',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Conquistas Desbloqueadas',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 12,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage == 100 ? Color(0xFFFFD700) : Color(0xFF4A90E2),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '$percentage% Completo',
            style: TextStyle(
              color: percentage == 100 ? Color(0xFFFFD700) : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      color: Color(0xFF1E2A3A),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Color(0xFF4A90E2),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        onTap: (index) {
          _audioService.playClick();
          setState(() {
            if (index == 0) {
              _selectedCategory = null; // Todas
            } else {
              _selectedCategory = AchievementCategory.values[index - 1];
            }
          });
        },
        tabs: [
          Tab(
            child: Row(
              children: [
                Icon(Icons.grid_view, size: 20),
                SizedBox(width: 8),
                Text('Todas'),
              ],
            ),
          ),
          Tab(
            child: Row(
              children: [
                Icon(Icons.quiz, size: 20),
                SizedBox(width: 8),
                Text('Quiz'),
              ],
            ),
          ),
          Tab(
            child: Row(
              children: [
                Icon(Icons.games, size: 20),
                SizedBox(width: 8),
                Text('Minigames'),
              ],
            ),
          ),
          Tab(
            child: Row(
              children: [
                Icon(Icons.people, size: 20),
                SizedBox(width: 8),
                Text('Social'),
              ],
            ),
          ),
          Tab(
            child: Row(
              children: [
                Icon(Icons.star, size: 20),
                SizedBox(width: 8),
                Text('Master'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _filteredAchievements.length,
      itemBuilder: (context, index) {
        return _buildAchievementCard(_filteredAchievements[index]);
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final isUnlocked = achievement.isUnlocked;
    final progress = achievement.progressPercentage;

    return GestureDetector(
      onTap: () {
        _audioService.playClick();
        _showAchievementDetails(achievement);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isUnlocked
                ? [
                    Color(0xFFFFD700).withOpacity(0.3),
                    Color(0xFFFFA500).withOpacity(0.2),
                  ]
                : [
                    Color(0xFF2A3F5F),
                    Color(0xFF1E2A3A),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked ? Color(0xFFFFD700) : Colors.white.withOpacity(0.2),
            width: isUnlocked ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isUnlocked
                  ? Color(0xFFFFD700).withOpacity(0.3)
                  : Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji grande
              Text(
                achievement.emoji,
                style: TextStyle(
                  fontSize: 56,
                  color: isUnlocked ? null : Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 12),

              // Nome (temporário - será substituído por i18n)
              Text(
                achievement.nameKey.replaceAll('achievement_', '').replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  color: isUnlocked ? Colors.white : Colors.white60,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 8),

              // Progress ou data de desbloqueio
              if (isUnlocked)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFFFFD700), size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Desbloqueada',
                      style: TextStyle(color: Color(0xFFFFD700), fontSize: 12),
                    ),
                  ],
                )
              else ...[
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 6,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(achievement.getCategoryColor()),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${achievement.currentProgress}/${achievement.requiredValue}',
                  style: TextStyle(color: Colors.white60, fontSize: 11),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Color(0xFF162447),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Emoji grande
              Text(achievement.emoji, style: TextStyle(fontSize: 72)),
              SizedBox(height: 16),

              // Nome
              Text(
                achievement.nameKey.replaceAll('achievement_', '').replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 12),

              // Descrição (temporária)
              Text(
                achievement.descriptionKey,
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              // Categoria
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: achievement.getCategoryColor().withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: achievement.getCategoryColor()),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(achievement.getCategoryIcon(), color: achievement.getCategoryColor(), size: 16),
                    SizedBox(width: 6),
                    Text(
                      achievement.category.toString().split('.').last.toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Status
              if (achievement.isUnlocked)
                Column(
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFFFFD700), size: 32),
                    SizedBox(height: 8),
                    Text(
                      'Desbloqueada em',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      _formatDate(achievement.unlockedAt!),
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: achievement.progressPercentage / 100,
                        minHeight: 12,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(achievement.getCategoryColor()),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Progresso: ${achievement.currentProgress}/${achievement.requiredValue}',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),

              SizedBox(height: 20),

              // Botão fechar
              ElevatedButton(
                onPressed: () {
                  _audioService.playClick();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text('Fechar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: Colors.white30,
          ),
          SizedBox(height: 16),
          Text(
            'Nenhuma conquista nesta categoria',
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
