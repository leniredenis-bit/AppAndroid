import 'package:flutter/material.dart';
import '../models/quiz_service.dart';
import '../models/question.dart';
import 'quiz_screen.dart';
import 'pie_quiz_screen.dart';

import 'stats_screen.dart';
import 'multiplayer/multiplayer_menu_screen.dart';
import '../widgets/emoji_text.dart';
import '../services/audio_service.dart';
import 'minigames_menu_screen.dart';

import '../widgets/settings_dialog.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> allTags = [];
  List<String> displayedTags = [];
  bool isLoadingTags = true;
  bool showAllTags = false;
  final int initialTagsCount = 7;

  int? selectedDifficultyIndex; // Usa índice ao invés de string
  String? selectedTag;
  
  // Retorna as dificuldades traduzidas
  List<String> _getDifficulties(AppLocalizations l10n) {
    return [l10n.easy, l10n.medium, l10n.hard];
  }
  
  // Retorna os modos de jogo traduzidos
  List<Map<String, String>> _getModes(AppLocalizations l10n) {
    return [
      {'emoji': '🧠', 'title': l10n.homeQuizClassic, 'desc': l10n.homeQuizClassicDesc},
      {'emoji': '🥧', 'title': l10n.homeQuizPie, 'desc': l10n.homeQuizPieDesc},
      {'emoji': '🌐', 'title': l10n.homeOnlineMatch, 'desc': l10n.homeOnlineMatchDesc},
      {'emoji': '🎮', 'title': l10n.homeMinigames, 'desc': l10n.homeMinigamesDesc},
      {'emoji': '📊', 'title': l10n.homeStats, 'desc': l10n.homeStatsDesc},
    ];
  }

  @override
  void initState() {
    super.initState();
    loadTags();
    // Inicia música de fundo da home
    AudioService().playBackgroundMusic('home');
  }

  @override
  void dispose() {
    // Para música ao sair da tela
    AudioService().stopBackgroundMusic();
    super.dispose();
  }

  Future<void> loadTags() async {
    try {
      final popularTags = await QuizService.getPopularTags();
      setState(() {
        allTags = popularTags.map((entry) => entry.key).toList();
        displayedTags = allTags.take(initialTagsCount).toList();
        isLoadingTags = false;
      });
    } catch (e) {
      setState(() {
        isLoadingTags = false;
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.homeLoadingCategoriesError(e.toString()))),
        );
      }
    }
  }

  void toggleShowAllTags() {
    setState(() {
      showAllTags = !showAllTags;
      displayedTags = showAllTags ? allTags : allTags.take(initialTagsCount).toList();
    });
  }

  void startQuiz() async {
    try {
      List<Question> questions = await QuizService.loadQuestions();
      
      // Aplicar filtros
      if (selectedDifficultyIndex != null) {
        // Converter índice para nível de dificuldade (1=Fácil, 2=Médio, 3=Difícil)
        int difficultyLevel = selectedDifficultyIndex! + 1;
        questions = QuizService.filterByDifficulty(questions, difficultyLevel);
      }
      
      if (selectedTag != null) {
        questions = QuizService.filterByTag(questions, selectedTag!);
      }
      
      // Pegar 10 perguntas aleatórias
      questions = QuizService.getRandomQuestions(questions, 10);
      
      if (questions.isEmpty) {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.homeNoQuestionsFound)),
        );
        return;
      }
      
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(questions: questions),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.homeLoadingError(e.toString()))),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final difficulties = _getDifficulties(l10n);
    final modes = _getModes(l10n);
    
    return Scaffold(
      backgroundColor: Color(0xFF101A2C),
      appBar: AppBar(
        title: Text(l10n.appTitle, style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF162447),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botões compactos de modo de jogo (MOVIDOS PARA CIMA)
            ...modes.asMap().entries.map((entry) {
              final index = entry.key;
              final mode = entry.value;
              
              VoidCallback? onPressed;
              if (index == 0) {
                onPressed = () {
                  AudioService().playClick();
                  startQuiz();
                };
              } else if (index == 1) {
                // Quiz Torta na Cara - Duelo 1v1
                onPressed = () async {
                  AudioService().playClick();
                  try {
                    List<Question> questions = await QuizService.loadQuestions();
                    
                    // Aplicar filtros se houver
                    if (selectedDifficultyIndex != null) {
                      int difficultyLevel = selectedDifficultyIndex! + 1;
                      questions = QuizService.filterByDifficulty(questions, difficultyLevel);
                    }
                    
                    if (selectedTag != null) {
                      questions = QuizService.filterByTag(questions, selectedTag!);
                    }
                    
                    // Pegar 10 perguntas aleatórias
                    questions = QuizService.getRandomQuestions(questions, 10);
                    
                    if (questions.isEmpty) {
                      if (!mounted) return;
                      final l10n = AppLocalizations.of(context)!;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.homeNoQuestionsFound)),
                      );
                      return;
                    }
                    
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PieQuizScreen(
                          questions: questions,
                          playerName: 'Apresentador',
                        ),
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    final l10n = AppLocalizations.of(context)!;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.homeLoadingError(e.toString()))),
                    );
                  }
                };
              } else if (index == 2) {
                onPressed = () {
                  AudioService().playClick();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MultiplayerMenuScreen()),
                  );
                };
              } else if (index == 3) {
                // Minigames
                onPressed = () {
                  AudioService().playClick();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MinigamesMenuScreen()),
                  );
                };
              } else if (index == 4) {
                // Estatísticas
                onPressed = () {
                  AudioService().playClick();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatsScreen()),
                  );
                };
              }
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF23395D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    elevation: 2,
                  ),
                  onPressed: onPressed,
                  child: Row(
                    children: [
                      EmojiText(mode['emoji']!, size: 28),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mode['title']!, 
                              style: TextStyle(
                                color: Colors.white, 
                                fontWeight: FontWeight.bold, 
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              mode['desc']!, 
                              style: TextStyle(
                                color: Colors.white70, 
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            
            SizedBox(height: 24),
            Divider(color: Colors.white24),
            SizedBox(height: 16),
            
            // Filtros de dificuldade (MOVIDOS PARA BAIXO)
            Text(l10n.homeDifficulty, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Row(
              children: difficulties.asMap().entries.map((entry) {
                final index = entry.key;
                final dif = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(dif),
                    selected: selectedDifficultyIndex == index,
                    backgroundColor: Color(0xFF23395D),
                    selectedColor: Color(0xFF3A5A8C),
                    labelStyle: TextStyle(color: Colors.white),
                    onSelected: (selected) {
                      setState(() {
                        selectedDifficultyIndex = selected ? index : null;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            // Tags de categorias
            Text(l10n.homeCategories, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            isLoadingTags 
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Color(0xFF3A5A8C)),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: showAllTags ? 300 : double.infinity,
                      ),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: displayedTags.map((tag) => FilterChip(
                            label: Text(tag),
                            selected: selectedTag == tag,
                            backgroundColor: Color(0xFF23395D),
                            selectedColor: Color(0xFF3A5A8C),
                            labelStyle: TextStyle(color: Colors.white),
                            onSelected: (selected) {
                              setState(() {
                                selectedTag = selected ? tag : null;
                              });
                            },
                          )).toList(),
                        ),
                      ),
                    ),
                    if (allTags.length > initialTagsCount)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextButton.icon(
                          onPressed: toggleShowAllTags,
                          icon: Icon(
                            showAllTags ? Icons.expand_less : Icons.expand_more,
                            color: Color(0xFF3A5A8C),
                          ),
                          label: Text(
                            showAllTags ? l10n.homeShowLess : l10n.homeShowMore(allTags.length - initialTagsCount),
                            style: TextStyle(color: Color(0xFF3A5A8C)),
                          ),
                        ),
                      ),
                  ],
                ),
            SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AudioService().playClick();
          final l10n = AppLocalizations.of(context)!;
          showDialog(
            context: context,
            builder: (context) => SettingsDialog(
              onThemeChanged: (isDark) {
                final theme = isDark ? l10n.homeThemeDark : l10n.homeThemeLight;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.homeThemeActivated(theme)),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          );
        },
        backgroundColor: Color(0xFF4A90E2),
        child: Icon(Icons.settings, color: Colors.white),
      ),
    );
  }
}
