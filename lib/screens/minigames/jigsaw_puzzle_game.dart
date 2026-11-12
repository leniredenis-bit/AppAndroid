import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/audio_service.dart';
import 'common/game_results.dart';
import 'common/game_text.dart';
import 'common/game_ui.dart';
import '../../theme/app_theme.dart';
import '../../services/app_lifecycle.dart';

const Color _accent = Color(0xFF2DD4BF);

/// Opções de tamanho (lado da grade → nº de peças), usadas no menu e na pintura.
List<OptionItem<int>> jigsawGridOptions() => [
      OptionItem(3, t3('Fácil', 'Easy', 'Fácil'), '9'),
      OptionItem(4, t3('Médio', 'Medium', 'Medio'), '16'),
      OptionItem(5, t3('Difícil', 'Hard', 'Difícil'), '25'),
      OptionItem(6, t3('Mestre', 'Master', 'Maestro'), '36'),
    ];

/// Desenho guardado na pasta do quebra-cabeça (ex.: pintura do jogo de colorir).
class SavedPuzzle {
  final String id;
  final Uint8List bytes;
  const SavedPuzzle(this.id, this.bytes);
}

/// Desenhos salvos do quebra-cabeça e a quantidade de peças escolhida.
class JigsawLibrary {
  static const _gridKey = 'jigsaw_grid';
  static const _idsKey = 'jigsaw_saved_ids';
  static String _pngKey(String id) => 'jigsaw_saved_$id';

  /// Lado da grade escolhido por último (vale para qualquer imagem aberta).
  static Future<int> loadGrid() async {
    final grid = (await SharedPreferences.getInstance()).getInt(_gridKey) ?? 3;
    return grid.clamp(3, 6);
  }

  static Future<void> saveGrid(int grid) async => (await SharedPreferences.getInstance()).setInt(_gridKey, grid);

  static Future<List<SavedPuzzle>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = <SavedPuzzle>[];
    for (final id in prefs.getStringList(_idsKey) ?? const <String>[]) {
      final raw = prefs.getString(_pngKey(id));
      if (raw != null) list.add(SavedPuzzle(id, base64Decode(raw)));
    }
    return list;
  }

  /// Salva (ou substitui) o desenho [id], que passa a ser o primeiro da lista.
  static Future<void> save(String id, Uint8List png) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pngKey(id), base64Encode(png));
    final ids = prefs.getStringList(_idsKey) ?? [];
    ids
      ..remove(id)
      ..insert(0, id);
    await prefs.setStringList(_idsKey, ids);
  }

  static Future<void> remove(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pngKey(id));
    await prefs.setStringList(_idsKey, (prefs.getStringList(_idsKey) ?? [])..remove(id));
  }
}

/// Quebra-cabeça clássico com peças de encaixe.
///
/// Todas as peças são desenhadas por um único [CustomPainter]; o toque é
/// testado contra o formato real da peça (não a caixa retangular), então
/// sempre se pega a peça que está visível sob o dedo.
class JigsawPuzzleGame extends StatefulWidget {
  /// Imagem inicial opcional (ex.: um desenho feito no jogo de colorir).
  final Uint8List? initialImageBytes;

  /// Lado da grade para a imagem inicial; sem ele, usa a configuração salva.
  final int? grid;

  const JigsawPuzzleGame({super.key, this.initialImageBytes, this.grid});

  @override
  State<JigsawPuzzleGame> createState() => _JigsawPuzzleGameState();
}

class _Piece {
  final int row, col;
  final int top, right, bottom, left; // 0 = reto, 1 = saliência, -1 = reentrância
  Offset center = Offset.zero;
  double scale = 1;
  double targetScale = 1;
  bool locked = false;
  Offset? snapFrom; // animação de encaixe
  double snapT = 1;
  double flash = 0; // brilho ao encaixar
  late Path path; // em coordenadas do núcleo (0..s)

  _Piece(this.row, this.col, this.top, this.right, this.bottom, this.left);

  bool get isEdge => top == 0 || right == 0 || bottom == 0 || left == 0;
}

class _JigsawPuzzleGameState extends State<JigsawPuzzleGame> with SingleTickerProviderStateMixin {
  final _audio = AudioService();
  final _random = Random();

  static const _assetImages = [
    'assets/images/puzzle1.jpg',
    'assets/images/puzzle2.jpg',
    'assets/images/puzzle3.jpg',
    'assets/images/puzzle4.jpg',
  ];

  /// Imagens extras: qualquer .jpg/.png/.webp colocado em assets/images/puzzles/.
  static const _puzzleFolder = 'assets/images/puzzles/';
  List<String> _folderImages = [];

  // Configuração
  int _grid = 3;
  bool _showSilhouette = true;
  ImageProvider? _chosenProvider;
  List<SavedPuzzle> _saved = [];

  // Partida
  bool _playing = false;
  ui.Image? _image;
  List<_Piece> _pieces = [];
  Size _area = Size.zero;
  Rect _board = Rect.zero;
  Rect _tray = Rect.zero;
  double _s = 0; // lado do núcleo da peça no tabuleiro
  double _trayScale = 0.5;
  int _moves = 0;
  int _seconds = 0;
  Timer? _clock;
  bool _won = false;
  bool _peek = false;
  double _winShine = -1;

  // Arraste
  int? _pointer;
  _Piece? _dragging;
  Offset _grabLocal = Offset.zero;

  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
    _audio.playBackgroundMusic('home');
    if (widget.grid != null) _grid = widget.grid!;
    _loadLibrary(applyGrid: widget.grid == null);
    if (widget.initialImageBytes != null) {
      _chosenProvider = MemoryImage(widget.initialImageBytes!);
      WidgetsBinding.instance.addPostFrameCallback((_) => _start(_chosenProvider!));
    }
  }

  Future<void> _loadLibrary({bool applyGrid = false}) async {
    final grid = await JigsawLibrary.loadGrid();
    final saved = await JigsawLibrary.load();
    final folder = await _listFolderImages();
    if (!mounted) return;
    setState(() {
      if (applyGrid && !_playing) _grid = grid;
      _saved = saved;
      _folderImages = folder;
    });
  }

  Future<List<String>> _listFolderImages() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      return manifest
          .listAssets()
          .where((a) => a.startsWith(_puzzleFolder) && RegExp(r'\.(jpe?g|png|webp)$', caseSensitive: false).hasMatch(a))
          .toList()
        ..sort();
    } catch (_) {
      return [];
    }
  }

  Future<void> _deleteSaved(SavedPuzzle s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: GameColors.panel,
        title: Text(t3('Remover desenho?', 'Remove drawing?', '¿Quitar dibujo?'),
            style: const TextStyle(color: Colors.white)),
        content: Text(
            t3('Ele sai só dos quebra-cabeças; a pintura continua salva.',
                'It is only removed from puzzles; the painting stays saved.',
                'Solo sale de los rompecabezas; la pintura sigue guardada.'),
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t3('Cancelar', 'Cancel', 'Cancelar'))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t3('Remover', 'Remove', 'Quitar'), style: const TextStyle(color: GameColors.danger))),
        ],
      ),
    );
    if (ok != true) return;
    await JigsawLibrary.remove(s.id);
    if (mounted) setState(() => _saved.remove(s));
  }

  @override
  void dispose() {
    _ticker.dispose();
    _clock?.cancel();
    _audio.stopBackgroundMusic();
    super.dispose();
  }

  // ==========================================================================
  // INÍCIO / IMAGEM
  // ==========================================================================

  Future<void> _pickFromGallery() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, maxHeight: 1600);
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      _start(MemoryImage(bytes));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            t3('Não foi possível abrir a galeria.', 'Could not open the gallery.', 'No se pudo abrir la galería.')),
      ));
    }
  }

  Future<ui.Image> _resolve(ImageProvider provider) {
    final completer = Completer<ui.Image>();
    final stream = provider.resolve(ImageConfiguration.empty);
    late final ImageStreamListener listener;
    listener = ImageStreamListener((info, _) {
      completer.complete(info.image);
      stream.removeListener(listener);
    }, onError: (e, st) {
      completer.completeError(e, st);
      stream.removeListener(listener);
    });
    stream.addListener(listener);
    return completer.future;
  }

  Future<void> _start(ImageProvider provider) async {
    _chosenProvider = provider;
    final image = await _resolve(provider);
    if (!mounted) return;
    setState(() {
      _image = image;
      _playing = true;
      _won = false;
      _winShine = -1;
      _moves = 0;
      _seconds = 0;
      _pieces = _createPieces();
      _area = Size.zero; // força novo layout
    });
    _clock?.cancel();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!AppLifecycle.foreground.value) return; // pausado em segundo plano
      if (mounted && !_won) setState(() => _seconds++);
    });
    if (!_ticker.isActive) _ticker.start();
  }

  List<_Piece> _createPieces() {
    final n = _grid;
    // v[r][c]: borda entre (r,c) e (r,c+1) | h[r][c]: borda entre (r,c) e (r+1,c)
    final v = List.generate(n, (_) => List.generate(n, (_) => _random.nextBool() ? 1 : -1));
    final h = List.generate(n, (_) => List.generate(n, (_) => _random.nextBool() ? 1 : -1));
    final list = <_Piece>[];
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        list.add(_Piece(
          r,
          c,
          r == 0 ? 0 : -h[r - 1][c],
          c == n - 1 ? 0 : v[r][c],
          r == n - 1 ? 0 : h[r][c],
          c == 0 ? 0 : -v[r][c - 1],
        ));
      }
    }
    list.shuffle(_random);
    return list;
  }

  /// Calcula tabuleiro e bandeja para o espaço disponível e espalha as peças.
  void _layout(Size area) {
    if (area == _area) return;
    final first = _area == Size.zero;
    final oldBoard = _board;
    final oldS = _s;
    _area = area;

    final boardSide = min(area.width - 24, area.height * 0.6);
    _board = Rect.fromLTWH((area.width - boardSide) / 2, 8, boardSide, boardSide);
    _tray = Rect.fromLTRB(8, _board.bottom + 14, area.width - 8, area.height - 6);
    _s = boardSide / _grid;

    final n = _pieces.length;
    final footprint = _s * 1.56;
    final cols = max(1, sqrt(n * _tray.width / max(_tray.height, 1)).ceil());
    final rows = (n / cols).ceil();
    final cell = min(_tray.width / cols, _tray.height / rows);
    _trayScale = (cell / footprint * 0.98).clamp(0.22, 0.8);

    for (final p in _pieces) {
      p.path = _piecePath(p, _s);
    }

    if (first) {
      _scatterInTray(_pieces);
    } else {
      // Reescala posições após rotação/redimensionamento
      for (final p in _pieces) {
        if (p.locked) {
          p.center = _correctCenter(p);
        } else if (oldS > 0) {
          final inBoard = oldBoard.contains(p.center);
          if (inBoard) {
            p.center = _board.topLeft + (p.center - oldBoard.topLeft) * (_s / oldS);
          }
        }
      }
      _scatterInTray(_pieces.where((p) => !p.locked && !_board.contains(p.center)).toList());
    }
  }

  void _scatterInTray(List<_Piece> pieces) {
    if (pieces.isEmpty) return;
    final n = pieces.length;
    final cols = max(1, sqrt(n * _tray.width / max(_tray.height, 1)).ceil());
    final rows = (n / cols).ceil();
    final cw = _tray.width / cols;
    final ch = _tray.height / rows;
    final order = List<_Piece>.from(pieces)..shuffle(_random);
    for (int i = 0; i < order.length; i++) {
      final p = order[i];
      final r = i ~/ cols, c = i % cols;
      final jitter = Offset((_random.nextDouble() - 0.5) * cw * 0.18, (_random.nextDouble() - 0.5) * ch * 0.18);
      p.center = Offset(_tray.left + cw * (c + 0.5), _tray.top + ch * (r + 0.5)) + jitter;
      p.scale = p.targetScale = _trayScale;
    }
  }

  Offset _correctCenter(_Piece p) => _board.topLeft + Offset((p.col + 0.5) * _s, (p.row + 0.5) * _s);

  // ==========================================================================
  // GEOMETRIA DAS PEÇAS
  // ==========================================================================

  /// Contorno de uma peça em coordenadas do núcleo (quadrado 0..s).
  /// Saliência/reentrância simétrica, então peças vizinhas sempre encaixam.
  static Path _piecePath(_Piece p, double s) {
    final path = Path()..moveTo(0, 0);
    _edge(path, Offset.zero, Offset(s, 0), const Offset(0, -1), p.top, s);
    _edge(path, Offset(s, 0), Offset(s, s), const Offset(1, 0), p.right, s);
    _edge(path, Offset(s, s), Offset(0, s), const Offset(0, 1), p.bottom, s);
    _edge(path, Offset(0, s), Offset.zero, const Offset(-1, 0), p.left, s);
    return path..close();
  }

  static void _edge(Path path, Offset a, Offset b, Offset normal, int tab, double s) {
    if (tab == 0) {
      path.lineTo(b.dx, b.dy);
      return;
    }
    Offset m(double u, double h) => a + (b - a) * u + normal * (h * s * tab);
    void line(double u, double h) {
      final p = m(u, h);
      path.lineTo(p.dx, p.dy);
    }

    void cubic(double u1, double h1, double u2, double h2, double u3, double h3) {
      final p1 = m(u1, h1), p2 = m(u2, h2), p3 = m(u3, h3);
      path.cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);
    }

    line(0.37, 0);
    cubic(0.42, 0.0, 0.44, 0.06, 0.40, 0.11);
    cubic(0.33, 0.20, 0.39, 0.28, 0.50, 0.28);
    cubic(0.61, 0.28, 0.67, 0.20, 0.60, 0.11);
    cubic(0.56, 0.06, 0.58, 0.0, 0.63, 0.0);
    line(1, 0);
  }

  // ==========================================================================
  // INTERAÇÃO
  // ==========================================================================

  bool _hits(_Piece p, Offset point) {
    final local = (point - p.center) / p.scale + Offset(_s / 2, _s / 2);
    return p.path.contains(local);
  }

  void _onDown(PointerDownEvent e) {
    if (_pointer != null || _won || _peek) return;
    for (int i = _pieces.length - 1; i >= 0; i--) {
      final p = _pieces[i];
      if (p.locked) continue;
      if (_hits(p, e.localPosition)) {
        _pointer = e.pointer;
        _dragging = p;
        _grabLocal = (e.localPosition - p.center) / p.scale;
        p.targetScale = 1.04;
        _pieces
          ..removeAt(i)
          ..add(p);
        _audio.playSfx('pickup', volume: 0.6);
        Haptics.selection();
        setState(() {});
        return;
      }
    }
  }

  void _onMove(PointerMoveEvent e) {
    final p = _dragging;
    if (p == null || e.pointer != _pointer) return;
    p.center = e.localPosition - _grabLocal * p.scale;
    setState(() {});
  }

  void _onUp(PointerEvent e) {
    final p = _dragging;
    if (p == null || e.pointer != _pointer) return;
    _pointer = null;
    _dragging = null;
    _moves++;

    final target = _correctCenter(p);
    if ((p.center - target).distance < _s * 0.33) {
      p.snapFrom = p.center;
      p.snapT = 0;
      p.locked = true;
      p.targetScale = 1;
      p.flash = 1;
      _audio.playSfx('snap');
      Haptics.medium();
      // Peças travadas ficam por baixo das soltas
      _pieces
        ..remove(p)
        ..insert(0, p);
      if (_pieces.every((x) => x.locked)) _onWin();
    } else {
      // Mantém dentro da área e define o tamanho conforme onde caiu
      p.center = Offset(
        p.center.dx.clamp(8, _area.width - 8),
        p.center.dy.clamp(8, _area.height - 8),
      );
      p.targetScale = _board.contains(p.center) ? 1 : _trayScale;
      _audio.playSfx('click', volume: 0.4);
    }
    setState(() {});
  }

  void _tidyTray() {
    final loose = _pieces.where((p) => !p.locked && p != _dragging).toList();
    final edgesFirst = [...loose.where((p) => p.isEdge), ...loose.where((p) => !p.isEdge)];
    final old = {for (final p in loose) p: p.center};
    _scatterInTray(edgesFirst);
    for (final p in loose) {
      p.snapFrom = old[p];
      p.snapT = 0;
    }
    _audio.playSfx('whoosh', volume: 0.6);
    setState(() {});
  }

  void _tick(Duration _) {
    bool changed = false;
    for (final p in _pieces) {
      if ((p.scale - p.targetScale).abs() > 0.002) {
        p.scale += (p.targetScale - p.scale) * 0.25;
        changed = true;
      }
      if (p.snapT < 1) {
        p.snapT = min(1, p.snapT + 0.12);
        changed = true;
      }
      if (p.flash > 0) {
        p.flash = max(0, p.flash - 0.04);
        changed = true;
      }
    }
    if (_winShine >= 0 && _winShine < 1.4) {
      _winShine += 0.02;
      changed = true;
    }
    if (changed && mounted) setState(() {});
  }

  /// Centro desenhado (inclui animação de encaixe/organização).
  Offset _drawCenter(_Piece p) {
    if (p.snapT >= 1 || p.snapFrom == null) return p.locked ? _correctCenter(p) : p.center;
    final target = p.locked ? _correctCenter(p) : p.center;
    final t = Curves.easeOutCubic.transform(p.snapT);
    return Offset.lerp(p.snapFrom, target, t)!;
  }

  Future<void> _onWin() async {
    _won = true;
    _clock?.cancel();
    await Future.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() => _winShine = 0);
    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

    final n = _pieces.length;
    final stars = _seconds <= n * 5 ? 3 : (_seconds <= n * 10 ? 2 : 1);
    final score = max(10, n * 100 - _seconds * 2 - max(0, _moves - n) * 5);
    final saved = await recordGameResult(context,
        gameId: 'jigsaw_puzzle', won: true, score: score, seconds: _seconds, perfect: _moves == n);
    if (!mounted) return;
    await showGameResult(
      context,
      won: true,
      accent: _accent,
      title: t3('Quebra-cabeça completo!', 'Puzzle complete!', '¡Rompecabezas completo!'),
      stars: stars,
      newRecord: saved.newRecord,
      stats: [
        ResultStat('⏱️', t3('Tempo', 'Time', 'Tiempo'), formatGameTime(_seconds)),
        ResultStat('✋', t3('Jogadas', 'Moves', 'Jugadas'), '$_moves'),
        ResultStat('🧩', t3('Peças', 'Pieces', 'Piezas'), '$n'),
      ],
      primaryLabel: t3('Jogar de novo', 'Play again', 'Jugar de nuevo'),
      onPrimary: () => _start(_chosenProvider!),
      secondaryLabel: t3('Outra imagem', 'Another image', 'Otra imagen'),
      onSecondary: _backToMenu,
    );
  }

  void _backToMenu() {
    _clock?.cancel();
    _ticker.stop();
    setState(() {
      _playing = false;
      _pieces = [];
      _area = Size.zero;
    });
  }

  // ==========================================================================
  // UI
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: t3('🧩 Quebra-Cabeça', '🧩 Jigsaw Puzzle', '🧩 Rompecabezas'),
      accent: _accent,
      onBack: _playing && widget.initialImageBytes == null ? _backToMenu : null,
      backgroundColors: const [Color(0xFF13302E), Color(0xFF0B1A1C)],
      body: _playing ? _buildGame() : _buildMenu(),
    );
  }

  Widget _buildMenu() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      children: [
        GameHero(
          emoji: '🧩',
          title: t3('Quebra-Cabeça', 'Jigsaw Puzzle', 'Rompecabezas'),
          subtitle: t3('Escolha uma imagem e monte peça por peça', 'Choose an image and build it piece by piece',
              'Elige una imagen y ármala pieza por pieza'),
          accent: _accent,
        ),
        const SizedBox(height: 22),
        GamePanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OptionPicker<int>(
                title: t3('Peças', 'Pieces', 'Piezas'),
                options: jigsawGridOptions(),
                selected: _grid,
                accent: _accent,
                onChanged: (v) {
                  setState(() => _grid = v);
                  JigsawLibrary.saveGrid(v);
                },
              ),
              const SizedBox(height: 14),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeTrackColor: _accent,
                value: _showSilhouette,
                onChanged: (v) => setState(() => _showSilhouette = v),
                title: Text(t3('Mostrar imagem de fundo', 'Show background image', 'Mostrar imagen de fondo'),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                subtitle: Text(
                    t3('Uma sombra da imagem ajuda a montar', 'A faint image helps you build',
                        'Una sombra de la imagen te ayuda'),
                    style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(t3('ESCOLHA A IMAGEM', 'CHOOSE THE IMAGE', 'ELIGE LA IMAGEN'),
            style:
                const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _galleryTile(),
            ..._saved.map((s) => _imageTile(MemoryImage(s.bytes), onDelete: () => _deleteSaved(s))),
            ...[..._folderImages, ..._assetImages].map((a) => _imageTile(AssetImage(a))),
          ],
        ),
      ],
    );
  }

  Widget _imageTile(ImageProvider provider, {VoidCallback? onDelete}) {
    return _PressableTile(
      onTap: () => _start(provider),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(image: provider, fit: BoxFit.cover),
            if (onDelete != null)
              Positioned(
                left: 4,
                top: 4,
                child: IconButton(
                  tooltip: t3('Remover', 'Remove', 'Quitar'),
                  onPressed: onDelete,
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _galleryTile() {
    return _PressableTile(
      onTap: _pickFromGallery,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(colors: [Color(0xFF14B8A6), Color(0xFF0E7490)]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_photo_alternate_rounded, color: Colors.white, size: 44),
            const SizedBox(height: 8),
            Text(t3('Sua foto', 'Your photo', 'Tu foto'),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
            Text(t3('da galeria', 'from gallery', 'de la galería'),
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildGame() {
    final placed = _pieces.where((p) => p.locked).length;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
          child: Row(
            children: [
              HudChip(emoji: '⏱️', value: formatGameTime(_seconds)),
              const SizedBox(width: 8),
              HudChip(emoji: '🧩', value: '$placed/${_pieces.length}', color: _accent, highlight: placed > 0),
              const Spacer(),
              _iconButton(Icons.auto_awesome_mosaic_rounded, t3('Organizar', 'Tidy up', 'Ordenar'), _tidyTray),
              const SizedBox(width: 6),
              GestureDetector(
                onTapDown: (_) => setState(() => _peek = true),
                onTapUp: (_) => setState(() => _peek = false),
                onTapCancel: () => setState(() => _peek = false),
                child: _iconBox(Icons.visibility_rounded, t3('Segure para espiar', 'Hold to peek', 'Mantén para ver')),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            _layout(Size(constraints.maxWidth, constraints.maxHeight));
            return Listener(
              onPointerDown: _onDown,
              onPointerMove: _onMove,
              onPointerUp: _onUp,
              onPointerCancel: _onUp,
              child: CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _JigsawPainter(
                  image: _image!,
                  pieces: _pieces,
                  grid: _grid,
                  board: _board,
                  tray: _tray,
                  s: _s,
                  silhouette: _showSilhouette,
                  peek: _peek,
                  dragging: _dragging,
                  won: _won,
                  winShine: _winShine,
                  centerOf: _drawCenter,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _iconButton(IconData icon, String tooltip, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Haptics.selection();
        onTap();
      },
      child: _iconBox(icon, tooltip),
    );
  }

  Widget _iconBox(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: GameColors.panel,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class _PressableTile extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _PressableTile({required this.child, required this.onTap});

  @override
  State<_PressableTile> createState() => _PressableTileState();
}

class _PressableTileState extends State<_PressableTile> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) {
        setState(() => _down = false);
        AudioService().playClick();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _down ? 0.95 : 1,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 5))],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ============================================================================
// PINTURA
// ============================================================================

class _JigsawPainter extends CustomPainter {
  final ui.Image image;
  final List<_Piece> pieces;
  final int grid;
  final Rect board, tray;
  final double s;
  final bool silhouette, peek, won;
  final _Piece? dragging;
  final double winShine;
  final Offset Function(_Piece) centerOf;

  _JigsawPainter({
    required this.image,
    required this.pieces,
    required this.grid,
    required this.board,
    required this.tray,
    required this.s,
    required this.silhouette,
    required this.peek,
    required this.dragging,
    required this.won,
    required this.winShine,
    required this.centerOf,
  });

  Rect get _src {
    final w = image.width.toDouble(), h = image.height.toDouble();
    final side = min(w, h);
    return Rect.fromLTWH((w - side) / 2, (h - side) / 2, side, side);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final src = _src;
    final boardR = RRect.fromRectAndRadius(board.inflate(6), const Radius.circular(14));

    // Tabuleiro (moldura + feltro)
    canvas.drawRRect(boardR.shift(const Offset(0, 4)), Paint()..color = Colors.black38);
    canvas.drawRRect(boardR, Paint()..color = const Color(0xFF0F2A2A));
    canvas.drawRRect(
        boardR,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color(0x5532E0C8));

    if (silhouette && !won) {
      canvas.drawImageRect(image, src, board, Paint()..color = const Color(0x2EFFFFFF));
    }

    // Bandeja
    canvas.drawRRect(RRect.fromRectAndRadius(tray, const Radius.circular(18)),
        Paint()..color = Colors.black.withValues(alpha: 0.22));

    // Encaixes vazios (contorno tracejado leve)
    if (!won) {
      final slot = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = Colors.white.withValues(alpha: 0.12);
      for (final p in pieces) {
        if (p.locked) continue;
        canvas.save();
        canvas.translate(board.left + p.col * s, board.top + p.row * s);
        canvas.drawPath(p.path, slot);
        canvas.restore();
      }
    }

    if (won && winShine >= 0) {
      // Imagem final inteira, sem emendas
      canvas.drawImageRect(image, src, board, Paint());
    } else {
      for (final p in pieces) {
        _drawPiece(canvas, p, src);
      }
    }

    // Brilho de vitória
    if (winShine >= 0 && winShine < 1.4) {
      canvas.save();
      canvas.clipRect(board);
      final x = board.left + (winShine - 0.2) * board.width * 1.6;
      final shine = Paint()
        ..shader = ui.Gradient.linear(
          Offset(x - 80, board.top),
          Offset(x + 80, board.bottom),
          [Colors.white.withValues(alpha: 0), Colors.white.withValues(alpha: 0.45), Colors.white.withValues(alpha: 0)],
          [0, 0.5, 1],
        );
      canvas.drawRect(board, shine);
      canvas.restore();
    }

    // Espiar: imagem por cima de tudo
    if (peek) {
      canvas.drawRRect(boardR, Paint()..color = Colors.black54);
      canvas.drawImageRect(image, src, board, Paint()..color = const Color(0xF2FFFFFF));
    }
  }

  void _drawPiece(Canvas canvas, _Piece p, Rect src) {
    final c = centerOf(p);
    final lifted = identical(p, dragging);
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.scale(p.scale);
    canvas.translate(-s / 2, -s / 2);

    if (!p.locked) {
      canvas.drawShadow(p.path, Colors.black, lifted ? 10 : 3, false);
    }

    canvas.save();
    canvas.clipPath(p.path);
    final dst = Rect.fromLTWH(-p.col * s, -p.row * s, grid * s, grid * s);
    canvas.drawImageRect(image, src, dst, Paint()..filterQuality = FilterQuality.medium);
    canvas.restore();

    // Relevo: luz em cima/esquerda, sombra embaixo/direita
    if (!p.locked) {
      canvas.save();
      canvas.translate(-0.8, -0.8);
      canvas.drawPath(
          p.path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.6
            ..color = Colors.white.withValues(alpha: 0.45));
      canvas.restore();
      canvas.save();
      canvas.translate(0.8, 0.8);
      canvas.drawPath(
          p.path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.6
            ..color = Colors.black.withValues(alpha: 0.45));
      canvas.restore();
    } else {
      canvas.drawPath(
          p.path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.8
            ..color = Colors.black.withValues(alpha: 0.18));
    }

    if (p.flash > 0) {
      canvas.drawPath(
          p.path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..color = const Color(0xFF5EEAD4).withValues(alpha: p.flash)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _JigsawPainter old) => true;
}
