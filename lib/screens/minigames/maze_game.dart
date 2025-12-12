import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async'; // Timer para movimento contínuo
import 'dart:ui' as ui; // Necessário para efeitos visuais avançados
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import '../../services/achievement_service.dart';
import '../../widgets/achievement_unlock_dialog.dart';
import '../../l10n/app_localizations.dart';

// --- Constantes do Jogo ---
const int tileSize = 32; // Tamanho visual de cada quadrado do labirinto
const int wallTile = 1;
const int pathTile = 0;
const int startTile = 2;
const int endTile = 3;

// --- Enum para os Modos de Jogo ---
enum GameMode { campaign, quickPlay }

// --- Classe Geradora de Labirintos (Procedural com Backtracking) ---
class MazeGenerator {
  static List<List<int>> generate(int rows, int cols, {double extraPathsChance = 0.05}) {
    // 1. Começa com tudo preenchido com paredes
    List<List<int>> maze = List.generate(rows, (_) => List.filled(cols, wallTile));
    final random = Random();

    // 2. Usa Recursive Backtracking para criar labirinto com caminho único garantido
    // Isso cria labirintos com muitas curvas e voltas
    
    // Certifica que dimensões são ímpares para o algoritmo funcionar melhor
    int effectiveRows = rows.isOdd ? rows : rows - 1;
    int effectiveCols = cols.isOdd ? cols : cols - 1;
    
    // Ponto inicial (canto superior esquerdo, posição ímpar)
    int startRow = 1;
    int startCol = 1;
    
    // Ponto final (canto inferior direito, posição ímpar)
    int endRow = effectiveRows - 2;
    int endCol = effectiveCols - 2;
    
    // Função recursiva de escavação usando backtracking
    void carve(int row, int col) {
      maze[row][col] = pathTile;
      
      // Direções: cima, baixo, esquerda, direita (pulando 2 células)
      List<List<int>> directions = [
        [-2, 0], // cima
        [2, 0],  // baixo
        [0, -2], // esquerda
        [0, 2],  // direita
      ];
      
      // Embaralha direções para criar caminhos aleatórios
      directions.shuffle(random);
      
      for (var dir in directions) {
        int newRow = row + dir[0];
        int newCol = col + dir[1];
        
        // Verifica se a nova posição é válida e ainda é parede
        if (newRow > 0 && newRow < effectiveRows - 1 &&
            newCol > 0 && newCol < effectiveCols - 1 &&
            maze[newRow][newCol] == wallTile) {
          // Escava a parede entre a posição atual e a nova
          maze[row + dir[0] ~/ 2][col + dir[1] ~/ 2] = pathTile;
          // Continua escavando recursivamente
          carve(newRow, newCol);
        }
      }
    }
    
    // Inicia a escavação do labirinto a partir do ponto inicial
    carve(startRow, startCol);
    
    // Marca início e fim
    maze[startRow][startCol] = startTile;
    maze[endRow][endCol] = endTile;
    
    // Garante que há caminho até o fim (pode não estar conectado se dimensões pares)
    // Cria um caminho forçado se necessário
    if (maze[endRow][endCol - 1] == wallTile && maze[endRow - 1][endCol] == wallTile) {
      // Abre caminho para o fim
      if (endCol - 1 > 0) maze[endRow][endCol - 1] = pathTile;
    }
    
    // 3. Adiciona alguns caminhos falsos extras (becos sem saída)
    // Mas NÃO sobrescreve o caminho principal já criado
    for (int r = 1; r < effectiveRows - 1; r++) {
      for (int c = 1; c < effectiveCols - 1; c++) {
        if (maze[r][c] == wallTile && random.nextDouble() < extraPathsChance) {
          // Verifica se tem pelo menos um caminho adjacente
          int adjacentPaths = 0;
          if (r > 0 && maze[r-1][c] == pathTile) adjacentPaths++;
          if (r < effectiveRows - 1 && maze[r+1][c] == pathTile) adjacentPaths++;
          if (c > 0 && maze[r][c-1] == pathTile) adjacentPaths++;
          if (c < effectiveCols - 1 && maze[r][c+1] == pathTile) adjacentPaths++;
          
          // Só abre se tiver exatamente 1 caminho adjacente (cria beco sem saída)
          if (adjacentPaths == 1) {
            maze[r][c] = pathTile;
          }
        }
      }
    }

    return maze;
  }
}

// --- Widget Principal do Jogo ---
class MazeGame extends StatefulWidget {
  const MazeGame({super.key});

  @override
  State<MazeGame> createState() => _MazeGameState();
}

class _MazeGameState extends State<MazeGame> with SingleTickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  final StorageService _storage = StorageService();
  final AchievementService _achievementService = AchievementService();

  // Estados do Jogo
  bool _isPlaying = false;
  GameMode _gameMode = GameMode.campaign;
  int _campaignLevel = 1;
  int _mazeRows = 15; // Tamanho inicial
  int _mazeCols = 15;

  // Dados da Partida Atual
  List<List<int>> _maze = [];
  int _playerRow = 0;
  int _playerCol = 0;
  bool _isGameWon = false;
  int _moves = 0;
  DateTime? _gameStartTime;
  Point<int>? _endPoint;

  // Controle de Movimento (Joystick Virtual)
  Offset? _joystickStartLocalPosition;
  Offset _joystickCurrentLocalPosition = Offset.zero;
  bool _isJoystickActive = false;
  Timer? _moveTimer; // Timer para movimento contínuo
  int _currentDeltaRow = 0; // Direção atual do movimento
  int _currentDeltaCol = 0;
  static const int _moveIntervalMs = 150; // Intervalo entre movimentos contínuos (ms)

  // Animação do Jogador
  late AnimationController _playerAnimController;
  double _playerBounceY = 0.0;

  @override
  void initState() {
    super.initState();
    // Configura animação de "caminhada" (um balanço simples)
    _playerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
      setState(() {
        // Cria um movimento de sobe e desce suave (senoide)
        _playerBounceY = sin(_playerAnimController.value * pi) * 4.0;
      });
    });

    _audioService.playBackgroundMusic('cave_ambience.mp3'); // Sugestão: mude a música para algo mais "caverna"
  }

  @override
  void dispose() {
    _stopMovement(); // Para o timer de movimento
    _audioService.stopBackgroundMusic();
    _playerAnimController.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _isPlaying = true;
      _isGameWon = false;
      _moves = 0;
      _gameStartTime = DateTime.now();

      // Define tamanho baseado no modo/nível
      if (_gameMode == GameMode.campaign) {
        // Aumenta o tamanho a cada 2 níveis, até um limite
        int sizeBonus = (_campaignLevel / 2).floor() * 2;
        _mazeRows = min(10 + sizeBonus, 40); // Começa 10x10, máx 40x40
        _mazeCols = min(10 + sizeBonus, 40);
      }
      // No quickPlay usa os valores dos sliders

      // Gera o labirinto
      // Níveis mais altos podem ter menos caminhos extras, ficando mais "labirínticos"
      double chance = _gameMode == GameMode.campaign ? max(0.05, 0.20 - (_campaignLevel * 0.01)) : 0.15;
      _maze = MazeGenerator.generate(_mazeRows, _mazeCols, extraPathsChance: chance);

      // Encontra posição inicial e final
      for(int r=0; r<_mazeRows; r++) {
        for(int c=0; c<_mazeCols; c++) {
          if (_maze[r][c] == startTile) {
            _playerRow = r;
            _playerCol = c;
          } else if (_maze[r][c] == endTile) {
            _endPoint = Point(r, c);
          }
        }
      }
    });
  }

  void _returnToMenu() {
    _stopMovement(); // Para o timer ao sair
    setState(() {
      _isPlaying = false;
      _isGameWon = false;
    });
  }

  // Inicia o timer de movimento contínuo
  void _startContinuousMovement(int deltaRow, int deltaCol, int directionCode) {
    // Atualiza a direção atual
    _currentDeltaRow = deltaRow;
    _currentDeltaCol = deltaCol;
    
    // Executa o primeiro movimento imediatamente
    _executeMove();
    
    // Se não houver timer ativo, cria um
    if (_moveTimer == null || !_moveTimer!.isActive) {
      _moveTimer = Timer.periodic(
        Duration(milliseconds: _moveIntervalMs),
        (_) => _executeMove(),
      );
    }
  }
  
  // Para o movimento contínuo
  void _stopMovement() {
    _moveTimer?.cancel();
    _moveTimer = null;
    _playerAnimController.stop();
  }

  // Executa um movimento na direção atual
  void _executeMove() {
    if (_isGameWon || _maze.isEmpty || !_isJoystickActive) {
      _stopMovement();
      return;
    }
    
    int newRow = _playerRow + _currentDeltaRow;
    int newCol = _playerCol + _currentDeltaCol;

    // Verifica limites do mapa
    if (newRow < 0 || newRow >= _mazeRows || newCol < 0 || newCol >= _mazeCols) {
      return; // Não para, apenas não move
    }

    // Verifica colisão com parede
    if (_maze[newRow][newCol] == wallTile) {
      return; // Não para, apenas não move
    }

    // Movimento Válido!
    setState(() {
      _playerRow = newRow;
      _playerCol = newCol;
      _moves++;
    });
    
    // Toca som de passo e inicia animação
    if (!_playerAnimController.isAnimating) {
      _audioService.playClick();
      _playerAnimController.forward(from: 0.0);
    }

    // Verifica Vitória
    if (_maze[newRow][newCol] == endTile) {
      _stopMovement();
      _handleVictory();
    }
  }

  // Lógica central de movimento - chamada quando direção muda
  void _tryMove(int deltaRow, int deltaCol, int directionCode) {
    if (_isGameWon || _maze.isEmpty) return;
    
    // Se a direção mudou, atualiza e continua movimento
    if (deltaRow != _currentDeltaRow || deltaCol != _currentDeltaCol) {
      _startContinuousMovement(deltaRow, deltaCol, directionCode);
    }
  }

  void _handleVictory() async {
    setState(() {
      _isGameWon = true;
    });
    _audioService.playVictory();
    _playerAnimController.stop();

    final timeSpent = _gameStartTime != null
        ? DateTime.now().difference(_gameStartTime!).inSeconds
        : 0;

    // Salva resultado base
    await _storage.saveMinigameRecord(
      'maze',
      score: max(100, 1000 - (_moves * 2) + (_campaignLevel * 50)), // Pontuação ajustada
      won: true,
      timeInSeconds: timeSpent,
    );

    // Lógica de Conquistas (Mantida do seu código original)
    final records = await _storage.getMinigameRecords();
    final mazeRecord = records.getRecord('maze');
    final unlockedAchievements = await _achievementService.checkMinigameAchievements(
      gameId: 'maze',
      totalGamesPlayed: mazeRecord.gamesPlayed,
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

    // Prepara próximo nível se for campanha
    if (_gameMode == GameMode.campaign) {
      await Future.delayed(const Duration(seconds: 2)); // Espera um pouco para celebrar
      if (mounted) {
        setState(() {
          _campaignLevel++;
          _startGame(); // Inicia o próximo nível automaticamente
        });
      }
    }
  }
  
  // --- Lógica do Joystick Virtual ---
  void _handleJoystickUpdate(Offset localPosition) {
    // Calcula o vetor do centro do joystick até o dedo
    Offset vector = localPosition - (_joystickStartLocalPosition ?? localPosition);

    // Se o arrasto for muito curto, consideramos "zona morta" (nenhuma intenção clara)
    if (vector.distance < 20.0) {
        return; // Zona morta aumentada para evitar movimentos acidentais
    }

    // Calcula o ângulo em graus (-180 a 180)
    double angle = atan2(vector.dy, vector.dx) * 180 / pi;

    // Determina a direção baseada no ângulo (com uma zona de histerese para não ficar trocando rápido demais)
    if (angle > -45 && angle <= 45) {
      _tryMove(0, 1, 4); // Direita
    } else if (angle > 45 && angle <= 135) {
      _tryMove(1, 0, 2); // Baixo
    } else if (angle > 135 || angle <= -135) {
      _tryMove(0, -1, 3); // Esquerda
    } else if (angle > -135 && angle <= -45) {
      _tryMove(-1, 0, 1); // Cima
    }
  }


  // --- Telas ---
  Widget _buildMenuScreen() {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        color: Colors.brown.shade800.withValues(alpha: 0.9),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.mazeCavern, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
              const SizedBox(height: 30),
              
              // Botão Modo Campanha
              ElevatedButton.icon(
                icon: const Icon(Icons.flag),
                label: Text(l10n.mazeCampaignMode(_campaignLevel)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.brown.shade900,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18)
                ),
                onPressed: () {
                  setState(() {
                    _gameMode = GameMode.campaign;
                  });
                  _startGame();
                },
              ),
              const SizedBox(height: 20),

              // Configurações Jogo Rápido
              Text(l10n.mazeQuickPlayCustom, style: const TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 10),
              Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(l10n.mazeRows(_mazeRows), style: const TextStyle(color: Colors.orangeAccent)),
                   Slider(
                     value: _mazeRows.toDouble(),
                     min: 10,
                     max: 50, // Permite mapas gigantes para teste
                     divisions: 40,
                     activeColor: Colors.orange,
                     onChanged: (val) => setState(() => _mazeRows = val.toInt()),
                   ),
                 ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.mazeColumns(_mazeCols), style: const TextStyle(color: Colors.orangeAccent)),
                  Slider(
                    value: _mazeCols.toDouble(),
                    min: 10,
                    max: 50,
                    divisions: 40,
                    activeColor: Colors.orange,
                    onChanged: (val) => setState(() => _mazeCols = val.toInt()),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.mazePlayQuick),
                 style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  setState(() {
                    _gameMode = GameMode.quickPlay;
                  });
                  _startGame();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameScreen() {
    final l10n = AppLocalizations.of(context)!;
    
    return Stack(
      children: [
        // 1. O Jogo Renderizado (CustomPaint) dentro de uma câmera interativa
        InteractiveViewer(
          // Configurações da câmera para seguir o jogador e permitir zoom limitado
          constrained: false, // Permite que o conteúdo seja maior que a tela
          boundaryMargin: const EdgeInsets.all(double.infinity), // Sem limites de pan
          minScale: 0.5, // Zoom out máximo
          maxScale: 2.0, // Zoom in máximo
          // O ponto crucial: a transformação inicial para centralizar o jogador
          transformationController: TransformationController(
            Matrix4.translationValues(
               - (_playerCol * tileSize.toDouble()) + (MediaQuery.of(context).size.width / 2) - (tileSize/2),
               - (_playerRow * tileSize.toDouble()) + (MediaQuery.of(context).size.height / 2) - (tileSize/2),
               0
            )
          ),
          child: CustomPaint(
            // O tamanho total do canvas é o tamanho do labirinto * tamanho do tile
            size: Size(_mazeCols * tileSize.toDouble(), _mazeRows * tileSize.toDouble()),
            painter: MazePainter(
              maze: _maze,
              playerRow: _playerRow,
              playerCol: _playerCol,
              rows: _mazeRows,
              cols: _mazeCols,
              endPoint: _endPoint,
              playerBounceY: _playerBounceY, // Passa o valor da animação
            ),
          ),
        ),

        // 2. Camada de Controle (Joystick Virtual)
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent, // Captura toques mesmo sendo transparente
            onPanStart: (details) {
              setState(() {
                _isJoystickActive = true;
                // Define onde o centro do joystick vai aparecer (onde o dedo tocou)
                _joystickStartLocalPosition = details.localPosition;
                _joystickCurrentLocalPosition = details.localPosition;
              });
            },
            onPanUpdate: (details) {
               setState(() {
                   _joystickCurrentLocalPosition = details.localPosition;
               });
              // Chama a lógica de movimento continuamente enquanto arrasta
              _handleJoystickUpdate(details.localPosition);
            },
            onPanEnd: (_) {
              _stopMovement(); // Para o movimento contínuo
              setState(() {
                _isJoystickActive = false;
                _joystickStartLocalPosition = null;
                _currentDeltaRow = 0;
                _currentDeltaCol = 0;
              });
            },
            // Desenha o joystick visualmente apenas se estiver ativo
            child: _isJoystickActive && _joystickStartLocalPosition != null
                ? CustomPaint(
                    painter: JoystickPainter(
                      startPos: _joystickStartLocalPosition!,
                      currentPos: _joystickCurrentLocalPosition,
                    ),
                  )
                : Container(), // Se não estiver ativo, não desenha nada na camada de gesto
          ),
        ),

        // 3. Interface do Usuário (HUD)
        Positioned(
          top: 40,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botão Voltar
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 30),
                onPressed: _returnToMenu,
                style: IconButton.styleFrom(backgroundColor: Colors.black45),
              ),
              // Contador de Movimentos
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.5))
                ),
                child: Text(
                  l10n.mazeMovesCount(_moves),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                ),
              ),
            ],
          ),
        ),

        // 4. Tela de Vitória (se ganhou)
        if (_isGameWon && _gameMode == GameMode.quickPlay)
          Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.green.shade800,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 15, spreadRadius: 5)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Text(l10n.mazeEscaped, style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 20),
                   Text(l10n.mazeCompletedIn(_moves), style: const TextStyle(fontSize: 18, color: Colors.white70)),
                   const SizedBox(height: 30),
                   ElevatedButton(
                     onPressed: _returnToMenu,
                     style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green.shade900),
                     child: Text(l10n.mazeBackToMenu),
                   )
                ],
              ),
            ),
          ),
           // Tela de transição de nível na campanha
        if (_isGameWon && _gameMode == GameMode.campaign)
           Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(color: Colors.orange.shade800.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(20)),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                 Text(l10n.mazeLevelComplete(_campaignLevel), style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                 const SizedBox(height: 10),
                 const CircularProgressIndicator(color: Colors.white),
                 const SizedBox(height: 10),
                 Text(l10n.mazeLoadingNextCavern, style: const TextStyle(color: Colors.white70)),
              ]),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Usa KeyboardListener apenas como fallback ou para testes em emulador
    return Scaffold(
      backgroundColor: Colors.brown.shade900, // Fundo escuro da caverna
      appBar: _isPlaying ? null : AppBar(
        title: Text(l10n.mazeTitle, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF162447),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _isPlaying ? _buildGameScreen() : _buildMenuScreen(),
      ),
    );
  }
}


// --- Pintor do Labirinto e Elementos (Renderização Avançada) ---
class MazePainter extends CustomPainter {
  final List<List<int>> maze;
  final int playerRow;
  final int playerCol;
  final int rows;
  final int cols;
  final Point<int>? endPoint;
  final double playerBounceY; // Valor da animação de pulo

  MazePainter({
    required this.maze,
    required this.playerRow,
    required this.playerCol,
    required this.rows,
    required this.cols,
    required this.endPoint,
    required this.playerBounceY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint wallPaint = Paint()..color = Colors.brown.shade800; // Cor da rocha
    final Paint floorPaint = Paint()..color = Colors.brown.shade600; // Cor do chão de terra
    final Paint startPaint = Paint()..color = Colors.greenAccent.withValues(alpha: 0.5);

    // 1. Desenha o Mapa (Chão e Paredes)
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final rect = Rect.fromLTWH(c * tileSize.toDouble(), r * tileSize.toDouble(), tileSize.toDouble(), tileSize.toDouble());
        
        if (maze[r][c] == wallTile) {
          // Desenha parede com uma textura simples (um retângulo menor mais claro em cima para dar volume)
          canvas.drawRect(rect, wallPaint);
           canvas.drawRect(rect.deflate(4.0), Paint()..color = Colors.brown.shade700);
        } else {
          // Desenha chão
          canvas.drawRect(rect, floorPaint);
          // Opcional: adicionar pontinhos ou textura de terra aqui
        }

        if (maze[r][c] == startTile) {
           canvas.drawCircle(rect.center, tileSize / 3, startPaint);
        }
      }
    }
    
    // 2. Desenha a Saída Iluminada
    if (endPoint != null) {
       final endRect = Rect.fromLTWH(endPoint!.x * tileSize.toDouble(), endPoint!.y * tileSize.toDouble(), tileSize.toDouble(), tileSize.toDouble());
       
       // Cria o efeito de brilho (gradiente radial)
       final glowPaint = Paint()
       ..shader = ui.Gradient.radial(
           endRect.center,
           tileSize.toDouble() * 1.5, // Raio do brilho
           [Colors.yellowAccent.withValues(alpha: 0.6), Colors.orange.withValues(alpha: 0.0)], // Cores do centro pra fora
           [0.0, 1.0], // Paradas do gradiente
           TileMode.clamp
       );
       // Desenha o brilho maior que a célula
       canvas.drawCircle(endRect.center, tileSize.toDouble() * 1.5, glowPaint);
       
       // Desenha um ícone de saída no centro (pode ser uma escada, um buraco de luz, etc)
       // Usando um círculo brilhante sólido por enquanto
       canvas.drawCircle(endRect.center, tileSize / 3, Paint()..color = Colors.yellow..maskFilter = const MaskFilter.blur(BlurStyle.solid, 5));
    }

    // 3. Desenha o Jogador Animado
    drawPlayer(canvas);
  }

  void drawPlayer(Canvas canvas) {
      final centerX = (playerCol * tileSize.toDouble()) + (tileSize / 2);
      // Aplica a animação de "bounce" na posição Y
      final centerY = (playerRow * tileSize.toDouble()) + (tileSize / 2) + playerBounceY;

      // --- Bonequinho Simples (Estilo Explorador) ---
      // Corpo
      final bodyPaint = Paint()..color = Colors.blue.shade400;
      canvas.drawCircle(Offset(centerX, centerY), tileSize / 3, bodyPaint);

      // Capacete (Um semi-círculo amarelo em cima)
      final helmetPaint = Paint()..color = Colors.amber;
      canvas.drawArc(
          Rect.fromCenter(center: Offset(centerX, centerY - (tileSize/6)), width: tileSize/1.8, height: tileSize/2),
          pi, // Começa em 180 graus
          pi, // Desenha 180 graus (semi-círculo)
          true, // Usa o centro
          helmetPaint
      );
      
      // Luz do capacete (um pequeno círculo branco brilhante)
      canvas.drawCircle(Offset(centerX, centerY - (tileSize/3.5)), 3, Paint()..color = Colors.white..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2));

      // Olhos (dois pontinhos pretos)
      final eyePaint = Paint()..color = Colors.black;
      canvas.drawCircle(Offset(centerX - 4, centerY - 2), 2, eyePaint);
      canvas.drawCircle(Offset(centerX + 4, centerY - 2), 2, eyePaint);

      // Sombra do pé (para dar a impressão que ele está pulando)
      canvas.drawOval(Rect.fromCenter(center: Offset(centerX, centerY + (tileSize/2.5) - playerBounceY), width: tileSize/2, height: tileSize/5), Paint()..color = Colors.black.withValues(alpha: 0.3));
  }

  @override
  bool shouldRepaint(covariant MazePainter oldDelegate) {
    // Repinta sempre que qualquer estado mudar (posição, animação, mapa)
    return oldDelegate.playerRow != playerRow ||
           oldDelegate.playerCol != playerCol ||
           oldDelegate.playerBounceY != playerBounceY ||
           oldDelegate.maze != maze;
  }
}


// --- Pintor do Joystick Virtual ---
class JoystickPainter extends CustomPainter {
    final Offset startPos; // Centro do joystick
    final Offset currentPos; // Onde o dedo está agora

    JoystickPainter({required this.startPos, required this.currentPos});

  @override
  void paint(Canvas canvas, Size size) {
      // Configurações visuais do joystick
      const double baseRadius = 60.0;
      const double knobRadius = 25.0;

      // Pinta a base (círculo externo transparente)
      final basePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;
       canvas.drawCircle(startPos, baseRadius, basePaint);
       
       // Pinta a borda da base
       final baseBorderPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
       canvas.drawCircle(startPos, baseRadius, baseBorderPaint);

       // Calcula a posição do "knob" (o círculo interno que segue o dedo)
       // Ele não pode sair de dentro da base.
       Offset delta = currentPos - startPos;
       double distance = delta.distance;
       Offset knobPos = currentPos;

       // Se o dedo arrastou para fora da base, limita o knob na borda
       if (distance > baseRadius) {
           knobPos = startPos + (delta / distance) * baseRadius;
       }

       // Pinta o knob (círculo interno)
       final knobPaint = Paint()..color = Colors.orangeAccent.withValues(alpha: 0.8);
       canvas.drawCircle(knobPos, knobRadius, knobPaint);

       // (Opcional) Desenha uma linha do centro até o knob para indicar direção visualmente
       // canvas.drawLine(startPos, knobPos, Paint()..color = Colors.white30..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant JoystickPainter oldDelegate) {
      return oldDelegate.startPos != startPos || oldDelegate.currentPos != currentPos;
  }
}
