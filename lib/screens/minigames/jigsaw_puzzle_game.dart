import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import '../../services/achievement_service.dart';
import '../../widgets/achievement_unlock_dialog.dart';
import '../../l10n/app_localizations.dart';

// --- Configurações do Quebra-Cabeça ---
const int DEFAULT_GRID_SIZE = 3; // 3x3 (fácil: 3, médio: 4, difícil: 5)
const double SNAP_THRESHOLD_PERCENT = 0.95; // 95% de proximidade para encaixar

// --- Estrutura da Peça ---
class JigsawPiece {
  final int id;
  final int row;
  final int col;
  final ImageProvider image;
  final Size originalImageSize;
  Offset currentPos;
  final Offset correctPos;
  bool isLocked;
  
  // Definição das abas (0=reto, 1=pra fora, -1=pra dentro)
  final int topTab;
  final int rightTab;
  final int bottomTab;
  final int leftTab;

  JigsawPiece({
    required this.id,
    required this.row,
    required this.col,
    required this.image,
    required this.originalImageSize,
    required this.currentPos,
    required this.correctPos,
    this.isLocked = false,
    required this.topTab,
    required this.rightTab,
    required this.bottomTab,
    required this.leftTab,
  });
}

class JigsawPuzzleGame extends StatefulWidget {
  const JigsawPuzzleGame({super.key});

  @override
  State<JigsawPuzzleGame> createState() => _JigsawPuzzleGameState();
}

class _JigsawPuzzleGameState extends State<JigsawPuzzleGame> {
  final AudioService _audioService = AudioService();
  final StorageService _storage = StorageService();
  final AchievementService _achievementService = AchievementService();

  // Estado do Jogo
  ImageProvider? _selectedImage;
  List<JigsawPiece> _pieces = [];
  Size? _boardSize;
  bool _isGameStarted = false;
  bool _isGameWon = false;
  bool _showPreview = true;
  int _gridSize = DEFAULT_GRID_SIZE;
  int _moves = 0;
  DateTime? _gameStartTime;
  final Random _random = Random();

  // Imagens embutidas do app (assets)
  final List<String> _systemImages = [
    'assets/images/puzzle1.jpg',
    'assets/images/puzzle2.jpg',
    'assets/images/puzzle3.jpg',
    'assets/images/puzzle4.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _audioService.playBackgroundMusic('puzzle-theme.mp3');
  }

  @override
  void dispose() {
    _audioService.stopBackgroundMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade800, // Mesa de madeira
      appBar: AppBar(
        title: const Text('🧩 Quebra-Cabeça', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF162447),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_isGameStarted)
            IconButton(
              icon: Icon(_showPreview ? Icons.visibility : Icons.visibility_off, color: Colors.white),
              onPressed: () {
                setState(() => _showPreview = !_showPreview);
                _audioService.playClick();
              },
              tooltip: 'Ver gabarito',
            ),
          if (_isGameStarted)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isGameStarted = false;
                  _pieces.clear();
                  _isGameWon = false;
                  _moves = 0;
                });
                _audioService.playClick();
              },
            ),
        ],
      ),
      body: SafeArea(
        child: _isGameStarted ? _buildGameBoard() : _buildMenu(),
      ),
    );
  }

  // --- TELA 1: MENU DE SELEÇÃO ---
  Widget _buildMenu() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Escolha sua imagem",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // Seletor de Dificuldade
          Card(
            color: Colors.brown.shade700,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.difficulty, style: const TextStyle(color: Colors.white70, fontSize: 18)),
                  const SizedBox(height: 10),
                  SegmentedButton<int>(
                    segments: [
                      ButtonSegment(value: 3, label: Text('${AppLocalizations.of(context)!.easy}\n3x3')),
                      ButtonSegment(value: 4, label: Text('${AppLocalizations.of(context)!.medium}\n4x4')),
                      ButtonSegment(value: 5, label: Text('${AppLocalizations.of(context)!.hard}\n5x5')),
                    ],
                    selected: {_gridSize},
                    onSelectionChanged: (Set<int> newSelection) {
                      setState(() => _gridSize = newSelection.first);
                      _audioService.playClick();
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Botão Upload
          ElevatedButton.icon(
            icon: const Icon(Icons.add_photo_alternate, size: 30),
            label: Text(AppLocalizations.of(context)!.jigsawLoadFromGallery),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: _pickImageFromGallery,
          ),
          
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.jigsawOrChooseImage, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          
          // Grid de Imagens do Sistema
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _systemImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _audioService.playClick();
                    _startGame(AssetImage(_systemImages[index]));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(_systemImages[index]),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 5)],
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                    child: const Center(
                      child: Icon(Icons.check_circle_outline, size: 50, color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Lógica de Seleção de Imagem ---
  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        _audioService.playClick();
        _startGame(FileImage(File(image.path)));
      }
    } catch (e) {
      // Caso não tenha o pacote image_picker ou dê erro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.jigsawGalleryError)),
        );
      }
    }
  }

  // --- TELA 2: TABULEIRO DO JOGO ---
  Widget _buildGameBoard() {
    if (_boardSize == null) {
      // Precisamos medir a tela antes de criar as peças
      return LayoutBuilder(builder: (context, constraints) {
        // Define o tamanho do tabuleiro quadrado baseado na largura da tela
        double size = min(constraints.maxWidth, constraints.maxHeight - 100) - 40;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _generatePuzzlePieces(Size(size, size));
        });
        return const Center(child: CircularProgressIndicator(color: Colors.orange));
      });
    }

    return Stack(
      children: [
        // Container principal
        Positioned.fill(
          child: Column(
            children: [
              // HUD
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard(AppLocalizations.of(context)!.moves, _moves.toString(), Icons.touch_app),
                    _buildStatCard(AppLocalizations.of(context)!.pieces, '${_pieces.where((p) => p.isLocked).length}/${_pieces.length}', Icons.extension),
                  ],
                ),
              ),
              
              // Área de Jogo
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: _boardSize!.width,
                    height: _boardSize!.height,
                    child: Stack(
                      children: [
                        // 1. Imagem Fantasma (Guia)
                        if (_showPreview)
                          Opacity(
                            opacity: 0.25,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        
                        // 2. Grade de referência
                        CustomPaint(
                          painter: GridPainter(
                            gridSize: _gridSize,
                            boardSize: _boardSize!,
                            showGrid: _showPreview,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 3. As Peças (Renderizadas como Stack items móveis)
        // Primeiro as peças locked (ficam por baixo), depois as soltas (por cima)
        ..._getSortedPieces().map((piece) {
          return Positioned(
            left: piece.currentPos.dx,
            top: piece.currentPos.dy,
            // Peças travadas ignoram toques completamente
            child: IgnorePointer(
              ignoring: piece.isLocked,
              child: GestureDetector(
                onPanStart: (_) {
                  if (!piece.isLocked && !_isGameWon) {
                    // Move a peça para o topo da pilha (renderiza por último)
                    setState(() {
                      _pieces.remove(piece);
                      _pieces.add(piece);
                    });
                  }
                },
              onPanUpdate: (details) {
                if (piece.isLocked || _isGameWon) return;
                setState(() {
                  piece.currentPos += details.delta;
                });
              },
              onPanEnd: (details) {
                if (piece.isLocked) return;
                setState(() => _moves++);
                _checkSnap(piece);
              },
              child: _buildPieceWidget(piece),
              ),
            ),
          );
        }),

        // 4. Tela de Vitória
        if (_isGameWon)
          Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.green.shade900.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("🧩", style: TextStyle(fontSize: 50)),
                  const SizedBox(height: 10),
                  Text(AppLocalizations.of(context)!.complete, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.completedInMoves(_moves),
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _audioService.playClick();
                      setState(() {
                        _isGameStarted = false;
                        _isGameWon = false;
                        _pieces.clear();
                        _boardSize = null;
                        _moves = 0;
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.newGame),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orangeAccent.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
              Text(value, style: const TextStyle(color: Colors.orangeAccent, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  // --- Lógica de Geração do Quebra-Cabeça ---
  void _startGame(ImageProvider image) {
    setState(() {
      _selectedImage = image;
      _isGameStarted = true;
      _boardSize = null; // Força recálculo do layout
      _gameStartTime = DateTime.now();
      _moves = 0;
    });
  }

  void _generatePuzzlePieces(Size boardSize) {
    List<JigsawPiece> newPieces = [];
    double pieceSize = boardSize.width / _gridSize;
    
    // Matriz para guardar as abas (para que a peça da direita encaixe na da esquerda)
    var verticalTabs = List.generate(_gridSize, (_) => List.filled(_gridSize, 0));
    var horizontalTabs = List.generate(_gridSize, (_) => List.filled(_gridSize, 0));

    // Gerar conexões aleatórias
    for (int r = 0; r < _gridSize; r++) {
      for (int c = 0; c < _gridSize; c++) {
        if (c < _gridSize - 1) verticalTabs[r][c] = _random.nextBool() ? 1 : -1;
        if (r < _gridSize - 1) horizontalTabs[r][c] = _random.nextBool() ? 1 : -1;
      }
    }

    // Calcula offset do tabuleiro para spawnar peças fora dele
    double screenWidth = MediaQuery.of(context).size.width;
    double boardX = (screenWidth - boardSize.width) / 2;
    double boardY = 100; // Aproximado (HUD + margem)

    for (int r = 0; r < _gridSize; r++) {
      for (int c = 0; c < _gridSize; c++) {
        // Define as 4 abas da peça
        int top = (r == 0) ? 0 : -horizontalTabs[r-1][c];
        int right = (c == _gridSize - 1) ? 0 : verticalTabs[r][c];
        int bottom = (r == _gridSize - 1) ? 0 : horizontalTabs[r][c];
        int left = (c == 0) ? 0 : -verticalTabs[r][c-1];

        // Posição correta no tabuleiro (relativa à tela)
        Offset correctScreen = Offset(
          boardX + (c * pieceSize),
          boardY + (r * pieceSize),
        );
        
        // Posição inicial na ÁREA DE PEÇAS (parte superior da tela)
        // Área de peças ocupa os primeiros ~120px da tela
        double pieceAreaHeight = 100.0;
        double piecePadding = 10.0;
        
        // Distribui as peças em uma grade na área superior
        int piecesPerRow = (_gridSize * 2).clamp(4, 8); // Mais peças por linha para caber
        int pieceIndex = r * _gridSize + c;
        
        double miniPieceSize = min(
          (screenWidth - piecePadding * 2) / piecesPerRow - piecePadding,
          (pieceAreaHeight - piecePadding) / 2 - piecePadding
        );
        
        int rowInArea = pieceIndex ~/ piecesPerRow;
        int colInArea = pieceIndex % piecesPerRow;
        
        double randomX = piecePadding + colInArea * (miniPieceSize + piecePadding) + _random.nextDouble() * 10;
        double randomY = piecePadding + rowInArea * (miniPieceSize + piecePadding) + _random.nextDouble() * 10;
        
        newPieces.add(JigsawPiece(
          id: r * _gridSize + c,
          row: r,
          col: c,
          image: _selectedImage!,
          originalImageSize: boardSize,
          correctPos: correctScreen,
          currentPos: Offset(randomX, randomY),
          topTab: top,
          rightTab: right,
          bottomTab: bottom,
          leftTab: left,
        ));
      }
    }

    setState(() {
      _boardSize = boardSize;
      _pieces = newPieces;
      _pieces.shuffle(); 
    });
  }

  // Retorna peças ordenadas: locked primeiro (por baixo), soltas por cima
  List<JigsawPiece> _getSortedPieces() {
    final locked = _pieces.where((p) => p.isLocked).toList();
    final unlocked = _pieces.where((p) => !p.isLocked).toList();
    return [...locked, ...unlocked];
  }

  void _checkSnap(JigsawPiece piece) {
    // Calcula a distância máxima aceitável baseada no tamanho da peça
    double pieceSize = _boardSize!.width / _gridSize;
    double maxSnapDistance = pieceSize * (1 - SNAP_THRESHOLD_PERCENT) * 2; // ~5% do tamanho da peça
    
    double dist = (piece.currentPos - piece.correctPos).distance;

    if (dist < maxSnapDistance) {
      // SNAP!
      setState(() {
        piece.currentPos = piece.correctPos;
        piece.isLocked = true;
      });
      
      _audioService.playCorrectAnswer(); // Som de encaixe
      
      // Verifica vitória
      if (_pieces.every((p) => p.isLocked)) {
        _handleVictory();
      }
    }
  }

  void _handleVictory() async {
    setState(() => _isGameWon = true);
    _audioService.playVictory();

    final timeSpent = _gameStartTime != null
        ? DateTime.now().difference(_gameStartTime!).inSeconds
        : 0;

    // Calcula pontuação (menos movimentos = melhor)
    int baseScore = _gridSize * _gridSize * 100;
    int penalty = _moves * 2;
    int score = max(100, baseScore - penalty);

    await _storage.saveMinigameRecord(
      'jigsaw_puzzle',
      score: score,
      won: true,
      timeInSeconds: timeSpent,
    );

    // Conquistas
    final records = await _storage.getMinigameRecords();
    final jigsawRecord = records.getRecord('jigsaw_puzzle');
    final unlockedAchievements = await _achievementService.checkMinigameAchievements(
      gameId: 'jigsaw_puzzle',
      totalGamesPlayed: jigsawRecord.gamesPlayed,
      won: true,
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

  // --- Renderização Visual da Peça ---
  Widget _buildPieceWidget(JigsawPiece piece) {
    double baseSize = _boardSize!.width / _gridSize;
    double drawSize = baseSize + 20;

    return SizedBox(
      width: drawSize,
      height: drawSize,
      child: Stack(
        children: [
          // Sombra
          if (!piece.isLocked)
            Positioned(
              left: 3, top: 3,
              child: CustomPaint(
                size: Size(drawSize, drawSize),
                painter: JigsawPathPainter(
                  piece: piece,
                  baseSize: baseSize,
                  color: Colors.black.withOpacity(0.5),
                  isShadow: true,
                ),
              ),
            ),
          // A Peça com Imagem
          ClipPath(
            clipper: JigsawClipper(piece: piece, baseSize: baseSize),
            child: Container(
              width: drawSize,
              height: drawSize,
              child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                alignment: Alignment.topLeft,
                child: Container(
                  width: _boardSize!.width,
                  height: _boardSize!.height,
                  transform: Matrix4.translationValues(
                    -piece.col * baseSize + 10,
                    -piece.row * baseSize + 10, 
                    0
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: piece.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Borda
          CustomPaint(
            size: Size(drawSize, drawSize),
            painter: JigsawPathPainter(
              piece: piece,
              baseSize: baseSize,
              color: piece.isLocked ? Colors.green.withOpacity(0.6) : Colors.white.withOpacity(0.3),
              isShadow: false,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Painter da Grade de Referência ---
class GridPainter extends CustomPainter {
  final int gridSize;
  final Size boardSize;
  final bool showGrid;

  GridPainter({required this.gridSize, required this.boardSize, required this.showGrid});

  @override
  void paint(Canvas canvas, Size size) {
    if (!showGrid) return;

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    double cellSize = boardSize.width / gridSize;

    for (int i = 0; i <= gridSize; i++) {
      // Linhas horizontais
      canvas.drawLine(
        Offset(0, i * cellSize),
        Offset(boardSize.width, i * cellSize),
        paint,
      );
      // Linhas verticais
      canvas.drawLine(
        Offset(i * cellSize, 0),
        Offset(i * cellSize, boardSize.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// --- Geometria do Quebra-Cabeça ---
class JigsawClipper extends CustomClipper<Path> {
  final JigsawPiece piece;
  final double baseSize;

  JigsawClipper({required this.piece, required this.baseSize});

  @override
  Path getClip(Size size) => getPiecePath(piece, baseSize);

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class JigsawPathPainter extends CustomPainter {
  final JigsawPiece piece;
  final double baseSize;
  final Color color;
  final bool isShadow;

  JigsawPathPainter({
    required this.piece,
    required this.baseSize,
    required this.color,
    required this.isShadow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = isShadow ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = isShadow ? 0 : 2.0;
      
    if (isShadow) {
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    }

    canvas.drawPath(getPiecePath(piece, baseSize), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Função que desenha o caminho com curvas Bézier
Path getPiecePath(JigsawPiece piece, double size) {
  final path = Path();
  double padding = 10.0;
  double width = size;
  double height = size;
  
  double left = padding;
  double top = padding;
  double right = padding + width;
  double bottom = padding + height;
  double tabSize = size / 4;

  path.moveTo(left, top);

  // TOPO
  if (piece.topTab == 0) {
    path.lineTo(right, top);
  } else {
    double midX = left + width / 2;
    double sgn = (piece.topTab == 1) ? -1.0 : 1.0;
    path.lineTo(midX - tabSize/2, top);
    path.cubicTo(
      midX - tabSize, top + (tabSize * sgn),
      midX + tabSize, top + (tabSize * sgn),
      midX + tabSize/2, top
    );
    path.lineTo(right, top);
  }

  // DIREITA
  if (piece.rightTab == 0) {
    path.lineTo(right, bottom);
  } else {
    double midY = top + height / 2;
    double sgn = (piece.rightTab == 1) ? 1.0 : -1.0;
    path.lineTo(right, midY - tabSize/2);
    path.cubicTo(
      right + (tabSize * sgn), midY - tabSize,
      right + (tabSize * sgn), midY + tabSize,
      right, midY + tabSize/2
    );
    path.lineTo(right, bottom);
  }

  // EMBAIXO
  if (piece.bottomTab == 0) {
    path.lineTo(left, bottom);
  } else {
    double midX = left + width / 2;
    double sgn = (piece.bottomTab == 1) ? 1.0 : -1.0;
    path.lineTo(midX + tabSize/2, bottom);
    path.cubicTo(
      midX + tabSize, bottom + (tabSize * sgn),
      midX - tabSize, bottom + (tabSize * sgn),
      midX - tabSize/2, bottom
    );
    path.lineTo(left, bottom);
  }

  // ESQUERDA
  if (piece.leftTab == 0) {
    path.lineTo(left, top);
  } else {
    double midY = top + height / 2;
    double sgn = (piece.leftTab == 1) ? -1.0 : 1.0;
    path.lineTo(left, midY + tabSize/2);
    path.cubicTo(
      left + (tabSize * sgn), midY + tabSize,
      left + (tabSize * sgn), midY - tabSize,
      left, midY - tabSize/2
    );
    path.lineTo(left, top);
  }

  path.close();
  return path;
}
