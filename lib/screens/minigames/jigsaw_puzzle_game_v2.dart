import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart'; // Requer pacote image_picker

// --- Configurações do Quebra-Cabeça ---
const int GRID_SIZE = 3; // 3x3 (pode mudar para 4 ou 5)
const double SNAP_SENSITIVITY = 40.0; // Distância para a peça "grudar"

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

class JigsawGame extends StatefulWidget {
  const JigsawGame({super.key});

  @override
  State<JigsawGame> createState() => _JigsawGameState();
}

class _JigsawGameState extends State<JigsawGame> {
  // Estado do Jogo
  ImageProvider? _selectedImage;
  List<JigsawPiece> _pieces = [];
  Size? _boardSize;
  bool _isGameStarted = false;
  bool _isGameWon = false;
  bool _showPreview = true;
  final Random _random = Random();

  // Imagens do Sistema (URLs para exemplo, mas idealmente seriam assets locais)
  final List<String> _systemImages = [
    'https://picsum.photos/id/237/500/500', // Cachorro
    'https://picsum.photos/id/10/500/500',  // Paisagem
    'https://picsum.photos/id/1025/500/500', // Cachorro peludo
    'https://picsum.photos/id/28/500/500', // Floresta
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade800, // Mesa de madeira
      appBar: AppBar(
        title: const Text('🧩 Puzzle Master'),
        backgroundColor: Colors.brown.shade900,
        actions: [
          if (_isGameStarted)
            IconButton(
              icon: Icon(_showPreview ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _showPreview = !_showPreview),
              tooltip: 'Ver gabarito',
            ),
          if (_isGameStarted)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => setState(() {
                _isGameStarted = false;
                _pieces.clear();
                _isGameWon = false;
              }),
            ),
        ],
      ),
      body: _isGameStarted ? _buildGameBoard() : _buildMenu(),
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
          
          // Botão Upload
          ElevatedButton.icon(
            icon: const Icon(Icons.add_photo_alternate, size: 30),
            label: const Text("Carregar da Galeria (Minhas Fotos)"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: _pickImageFromGallery,
          ),
          
          const SizedBox(height: 30),
          const Text("Ou escolha uma coleção:", style: TextStyle(color: Colors.white70)),
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
                  onTap: () => _startGame(NetworkImage(_systemImages[index])),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(_systemImages[index]),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 5)],
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
        _startGame(FileImage(File(image.path)));
      }
    } catch (e) {
      // Caso não tenha o pacote image_picker ou dê erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao abrir galeria. Verifique se o pacote image_picker está instalado.')),
      );
    }
  }

  // --- TELA 2: TABULEIRO DO JOGO ---
  Widget _buildGameBoard() {
    if (_boardSize == null) {
      // Precisamos medir a tela antes de criar as peças
      return LayoutBuilder(builder: (context, constraints) {
        // Define o tamanho do tabuleiro quadrado baseado na largura da tela
        double size = min(constraints.maxWidth, constraints.maxHeight) - 40;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _generatePuzzlePieces(Size(size, size));
        });
        return const Center(child: CircularProgressIndicator());
      });
    }

    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: _boardSize!.width,
            height: _boardSize!.height,
            child: Stack(
              children: [
                // 1. Imagem Fantasma (Guia)
                if (_showPreview)
                  Opacity(
                    opacity: 0.2,
                    child: Image(image: _selectedImage!, fit: BoxFit.cover),
                  ),
                
                // 2. Área de Jogo (Slots invisíveis)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 3. As Peças (Renderizadas como Stack items móveis)
        ..._pieces.map((piece) {
          return Positioned(
            left: piece.currentPos.dx,
            top: piece.currentPos.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                if (piece.isLocked || _isGameWon) return;
                setState(() {
                  piece.currentPos += details.delta;
                });
              },
              onPanEnd: (details) {
                if (piece.isLocked) return;
                _checkSnap(piece);
              },
              child: _buildPieceWidget(piece),
            ),
          );
        }).toList(),

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
                  const Text("COMPLETO!", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _isGameStarted = false;
                      _isGameWon = false;
                      _pieces.clear();
                      _boardSize = null;
                    }),
                    child: const Text("Escolher Outra Imagem"),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }

  // --- Lógica de Geração do Quebra-Cabeça ---
  void _startGame(ImageProvider image) {
    setState(() {
      _selectedImage = image;
      _isGameStarted = true;
      _boardSize = null; // Força recalculo do layout
    });
  }

  void _generatePuzzlePieces(Size boardSize) {
    List<JigsawPiece> newPieces = [];
    double pieceSize = boardSize.width / GRID_SIZE;
    
    // Matriz para guardar as abas (para que a peça da direita encaixe na da esquerda)
    // 0 = reto, 1 = out, -1 = in
    // verticalTabs[row][col] guarda a borda direita da peça (row, col)
    // horizontalTabs[row][col] guarda a borda inferior da peça (row, col)
    var verticalTabs = List.generate(GRID_SIZE, (_) => List.filled(GRID_SIZE, 0));
    var horizontalTabs = List.generate(GRID_SIZE, (_) => List.filled(GRID_SIZE, 0));

    // Gerar conexões aleatórias
    for (int r = 0; r < GRID_SIZE; r++) {
      for (int c = 0; c < GRID_SIZE; c++) {
        if (c < GRID_SIZE - 1) verticalTabs[r][c] = _random.nextBool() ? 1 : -1;
        if (r < GRID_SIZE - 1) horizontalTabs[r][c] = _random.nextBool() ? 1 : -1;
      }
    }

    for (int r = 0; r < GRID_SIZE; r++) {
      for (int c = 0; c < GRID_SIZE; c++) {
        // Define as 4 abas da peça
        int top = (r == 0) ? 0 : -horizontalTabs[r-1][c]; // Oposto da peça de cima
        int right = (c == GRID_SIZE - 1) ? 0 : verticalTabs[r][c];
        int bottom = (r == GRID_SIZE - 1) ? 0 : horizontalTabs[r][c];
        int left = (c == 0) ? 0 : -verticalTabs[r][c-1]; // Oposto da peça da esquerda

        // Posição correta no tabuleiro
        Offset correct = Offset(c * pieceSize, r * pieceSize);
        
        // Posição inicial espalhada (Random em volta do tabuleiro)
        double randomX = _random.nextDouble() * (boardSize.width - 50);
        double randomY = _random.nextDouble() * (boardSize.height + 100); 
        
        // Ajuste para espalhar fora da área central se possível, ou aleatório total
        
        newPieces.add(JigsawPiece(
          id: r * GRID_SIZE + c,
          row: r,
          col: c,
          image: _selectedImage!,
          originalImageSize: boardSize,
          correctPos: correct,
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
      // Embaralha a ordem de renderização (z-index)
      _pieces.shuffle(); 
    });
  }

  void _checkSnap(JigsawPiece piece) {
    // Calculamos a distância entre onde soltou e o lugar certo
    // Nota: O "Lugar certo" é relativo ao tabuleiro. Como usamos Stack global, precisamos compensar
    // Para simplificar neste exemplo, usamos coordenadas relativas ao Stack pai.
    
    // Mas espere! O tabuleiro está centralizado.
    // Vamos simplificar: se a diferença for pequena, trava.
    
    // Precisamos saber o offset do tabuleiro na tela? 
    // Truque: O Stack tem o tamanho da tela. O tabuleiro está no centro.
    double boardX = (MediaQuery.of(context).size.width - _boardSize!.width) / 2;
    double boardY = (MediaQuery.of(context).size.height - _boardSize!.height) / 2;
    
    // A posição absoluta correta da peça na tela é: boardOffset + correctPos
    Offset absoluteCorrect = Offset(boardX + piece.correctPos.dx, boardY + piece.correctPos.dy);

    double dist = (piece.currentPos - absoluteCorrect).distance;

    if (dist < SNAP_SENSITIVITY) {
      // SNAP!
      setState(() {
        piece.currentPos = absoluteCorrect;
        piece.isLocked = true;
        
        // Efeito sonoro aqui seria legal
        // _audioService.playClick();
        
        // Verifica vitória
        if (_pieces.every((p) => p.isLocked)) {
          _isGameWon = true;
          // _audioService.playVictory();
        }
      });
    }
  }

  // --- Renderização Visual da Peça ---
  Widget _buildPieceWidget(JigsawPiece piece) {
    double baseSize = _boardSize!.width / GRID_SIZE;
    // A peça precisa ser maior que o slot para caber as abas saindo
    double drawSize = baseSize + 20; // +20 de padding para as orelhas

    return SizedBox(
      width: drawSize,
      height: drawSize,
      child: Stack(
        children: [
          // Sombra para dar profundidade
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
          // A Peça com a Imagem recortada
          ClipPath(
            clipper: JigsawClipper(piece: piece, baseSize: baseSize),
            child: Container(
              width: drawSize,
              height: drawSize,
              // Aqui está a mágica: Desenhamos a imagem inteira, mas deslocada!
              child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                alignment: Alignment.topLeft,
                child: Container(
                  width: _boardSize!.width,
                  height: _boardSize!.height,
                  // O deslocamento negativo traz a parte correta da imagem para este buraco
                  transform: Matrix4.translationValues(
                    -piece.col * baseSize + 10, // +10 compensa o padding do clipper
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
          // Borda (Stroke) para definir a peça
           CustomPaint(
              size: Size(drawSize, drawSize),
              painter: JigsawPathPainter(
                piece: piece,
                baseSize: baseSize,
                color: Colors.white.withOpacity(0.3),
                isShadow: false,
              ),
            ),
        ],
      ),
    );
  }
}

// --- CLASSE MÁGICA: Geometria do Quebra-Cabeça (Clipper & Painter) ---

class JigsawClipper extends CustomClipper<Path> {
  final JigsawPiece piece;
  final double baseSize;

  JigsawClipper({required this.piece, required this.baseSize});

  @override
  Path getClip(Size size) {
    return getPiecePath(piece, baseSize);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class JigsawPathPainter extends CustomPainter {
  final JigsawPiece piece;
  final double baseSize;
  final Color color;
  final bool isShadow;

  JigsawPathPainter({required this.piece, required this.baseSize, required this.color, required this.isShadow});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = isShadow ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = isShadow ? 0 : 1.0;
      
    if (isShadow) {
       paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    }

    canvas.drawPath(getPiecePath(piece, baseSize), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Função auxiliar que desenha o caminho Bézier
Path getPiecePath(JigsawPiece piece, double size) {
  final path = Path();
  double padding = 10.0; // Espaço para as abas
  double width = size;
  double height = size;
  
  // Pontos de início (deslocado pelo padding)
  double left = padding;
  double top = padding;
  double right = padding + width;
  double bottom = padding + height;

  // Tamanho da aba (orelha)
  double tabSize = size / 4; 

  path.moveTo(left, top);

  // --- TOPO ---
  if (piece.topTab == 0) {
    path.lineTo(right, top);
  } else {
    // Desenha a orelha (Cubic Bezier simplificado)
    double midX = left + width / 2;
    double sgn = (piece.topTab == 1) ? -1.0 : 1.0; // -1 sobe (out), 1 desce (in)
    
    path.lineTo(midX - tabSize/2, top);
    path.cubicTo(
      midX - tabSize, top + (tabSize * sgn), // Control 1
      midX + tabSize, top + (tabSize * sgn), // Control 2
      midX + tabSize/2, top // End
    );
    path.lineTo(right, top);
  }

  // --- DIREITA ---
  if (piece.rightTab == 0) {
    path.lineTo(right, bottom);
  } else {
    double midY = top + height / 2;
    double sgn = (piece.rightTab == 1) ? 1.0 : -1.0; // 1 direita (out), -1 esquerda (in)
    
    path.lineTo(right, midY - tabSize/2);
    path.cubicTo(
      right + (tabSize * sgn), midY - tabSize, 
      right + (tabSize * sgn), midY + tabSize, 
      right, midY + tabSize/2
    );
    path.lineTo(right, bottom);
  }

  // --- EMBAIXO ---
  if (piece.bottomTab == 0) {
    path.lineTo(left, bottom);
  } else {
    double midX = left + width / 2;
    double sgn = (piece.bottomTab == 1) ? 1.0 : -1.0; // 1 desce (out), -1 sobe (in)
    
    path.lineTo(midX + tabSize/2, bottom);
    path.cubicTo(
      midX + tabSize, bottom + (tabSize * sgn), 
      midX - tabSize, bottom + (tabSize * sgn), 
      midX - tabSize/2, bottom
    );
    path.lineTo(left, bottom);
  }

  // --- ESQUERDA ---
  if (piece.leftTab == 0) {
    path.lineTo(left, top);
  } else {
    double midY = top + height / 2;
    double sgn = (piece.leftTab == 1) ? -1.0 : 1.0; // -1 esquerda (out), 1 direita (in)
    
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