import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/audio_service.dart';
import 'coloring_drawings.dart';
import 'coloring_lineart.dart';
import 'common/game_results.dart';
import 'common/game_text.dart';
import 'common/game_ui.dart';
import 'jigsaw_puzzle_game.dart';
import '../../theme/app_theme.dart';

const Color _accent = Color(0xFFF472B6);

const List<Color> _palette = [
  Color(0xFFE53935),
  Color(0xFFFF7043),
  Color(0xFFFF9800),
  Color(0xFFFFC107),
  Color(0xFFFFEB3B),
  Color(0xFFCDDC39),
  Color(0xFF8BC34A),
  Color(0xFF43A047),
  Color(0xFF00897B),
  Color(0xFF26C6DA),
  Color(0xFF29B6F6),
  Color(0xFF1E88E5),
  Color(0xFF3949AB),
  Color(0xFF8E24AA),
  Color(0xFFBA68C8),
  Color(0xFFEC407A),
  Color(0xFFF8BBD0),
  Color(0xFFFFCCBC),
  Color(0xFFF2C29B),
  Color(0xFFC68642),
  Color(0xFF8D6E63),
  Color(0xFF5D4037),
  Color(0xFF9E9E9E),
  Color(0xFF607D8B),
  Color(0xFF212121),
  Color(0xFFFFFFFF),
];

enum _Tool { fill, brush, eraser }

// Desenhos importados: ids, imagem (PNG em tons de cinza) e miniatura
const String _customIdsKey = 'coloring_custom_ids';
String _customPngKey(String id) => 'coloring_custom_png_$id';
String _customThumbKey(String id) => 'coloring_custom_thumb_$id';

class _Fill {
  final int color;
  final bool shine;
  const _Fill(this.color, this.shine);
  List<int> toJson() => [color, shine ? 1 : 0];
}

class _Stroke {
  final int color;
  final double width;
  final List<Offset> points;
  _Stroke(this.color, this.width, this.points);

  Map<String, dynamic> toJson() => {
        'c': color,
        'w': width,
        'p': [
          for (final p in points) ...[p.dx.round(), p.dy.round()]
        ],
      };

  static _Stroke fromJson(Map<String, dynamic> j) {
    final raw = List<num>.from(j['p'] as List);
    return _Stroke(j['c'] as int, (j['w'] as num).toDouble(),
        [for (int i = 0; i + 1 < raw.length; i += 2) Offset(raw[i].toDouble(), raw[i + 1].toDouble())]);
  }
}

class _Snapshot {
  final Map<int, _Fill> fills;
  final List<_Stroke> strokes;
  _Snapshot(Map<int, _Fill> f, List<_Stroke> s)
      : fills = Map.of(f),
        strokes = List.of(s);
}

// ============================================================================
// GALERIA
// ============================================================================

class ColoringGame extends StatefulWidget {
  const ColoringGame({super.key});

  @override
  State<ColoringGame> createState() => _ColoringGameState();
}

class _ColoringGameState extends State<ColoringGame> {
  final List<ColoringDrawing> _drawings = buildColoringDrawings();
  final Map<String, _SavedArt> _saved = {};
  List<String> _customIds = [];
  final Map<String, Uint8List> _thumbs = {};

  @override
  void initState() {
    super.initState();
    AudioService().playBackgroundMusic('home');
    _load();
  }

  @override
  void dispose() {
    AudioService().stopBackgroundMusic();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    for (final d in _drawings) {
      _saved[d.id] = _SavedArt.read(prefs, d.id);
    }
    _customIds = prefs.getStringList(_customIdsKey) ?? [];
    for (final id in _customIds) {
      final t = prefs.getString(_customThumbKey(id)) ?? prefs.getString(_customPngKey(id));
      if (t != null) _thumbs[id] = base64Decode(t);
    }
    if (mounted) setState(() {});
  }

  void _snack(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  /// Mostra "preparando…" enquanto [work] roda.
  Future<T?> _busy<T>(Future<T> Function() work) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: GamePanel(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: _accent),
                  const SizedBox(height: 14),
                  Text(t3('Preparando seu desenho…', 'Preparing your drawing…', 'Preparando tu dibujo…'),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 80)); // deixa o aviso aparecer
    try {
      return await work();
    } catch (e) {
      debugPrint('Colorir: falha ao processar desenho: $e');
      return null;
    } finally {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<void> _importDrawing() async {
    XFile? file;
    try {
      file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 2000, maxHeight: 2000);
    } catch (_) {
      _snack(t3('Não foi possível abrir a galeria.', 'Could not open the gallery.', 'No se pudo abrir la galería.'));
      return;
    }
    if (file == null || !mounted) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    final art = await _busy(() => LineArt.fromImageBytes(bytes));
    if (!mounted) return;
    if (art == null || art.significant.isEmpty) {
      _snack(t3('Não encontrei áreas para pintar nessa imagem.', 'No paintable areas found in this image.',
          'No encontré áreas para pintar en esta imagen.'));
      return;
    }
    if (art.significant.length > 350) {
      final n = art.significant.length;
      final go = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: GameColors.panel,
          title: Text(t3('Muitos detalhes', 'Lots of detail', 'Muchos detalles'),
              style: const TextStyle(color: Colors.white)),
          content: Text(
            t3(
                'Encontrei $n áreas. Funciona melhor com desenhos de contorno preto e branco (como livros de colorir). Usar mesmo assim?',
                'I found $n areas. It works best with black-and-white outline drawings (like coloring books). Use it anyway?',
                'Encontré $n áreas. Funciona mejor con dibujos de contorno en blanco y negro (como libros para colorear). ¿Usarlo igual?'),
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t3('Cancelar', 'Cancel', 'Cancelar'))),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(t3('Usar', 'Use it', 'Usar'))),
          ],
        ),
      );
      if (go != true || !mounted) return;
    }

    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString(_customPngKey(id), base64Encode(await art.encodePng()));
      _customIds.insert(0, id);
      await prefs.setStringList(_customIdsKey, _customIds);
    } catch (_) {
      _snack(t3('Sem espaço para salvar. Apague algum desenho importado.',
          'No space to save. Delete an imported drawing.', 'Sin espacio para guardar. Borra algún dibujo importado.'));
      return;
    }
    if (!mounted) return;
    AudioService().playSfx('star');
    await _openEditor(ColoringDrawing.custom(id, art));
  }

  Future<void> _openCustom(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_customPngKey(id));
    if (raw == null || !mounted) return;
    final art = await _busy(() => LineArt.fromPng(base64Decode(raw)));
    if (art == null || !mounted) return;
    await _openEditor(ColoringDrawing.custom(id, art));
  }

  Future<void> _deleteCustom(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: GameColors.panel,
        title: Text(t3('Apagar este desenho?', 'Delete this drawing?', '¿Borrar este dibujo?'),
            style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t3('Cancelar', 'Cancel', 'Cancelar'))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t3('Apagar', 'Delete', 'Borrar'), style: const TextStyle(color: GameColors.danger))),
        ],
      ),
    );
    if (ok != true) return;
    final prefs = await SharedPreferences.getInstance();
    for (final k in [_customPngKey(id), _customThumbKey(id), _SavedArt.key(id)]) {
      await prefs.remove(k);
    }
    _customIds.remove(id);
    _thumbs.remove(id);
    await prefs.setStringList(_customIdsKey, _customIds);
    if (mounted) setState(() {});
  }

  Future<void> _openEditor(ColoringDrawing d) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => _ColoringEditor(drawing: d)));
    _load();
  }

  Widget _tile({
    required Widget image,
    required String emoji,
    required String title,
    String? badge,
    bool golden = false,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) {
    return GestureDetector(
      onTap: () {
        AudioService().playClick();
        onTap();
      },
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: GameColors.panel,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: golden ? GameColors.gold : Colors.white12, width: golden ? 2 : 1),
          boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 5))],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child:
                  ClipRRect(borderRadius: BorderRadius.circular(14), child: AspectRatio(aspectRatio: 1, child: image)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                ),
                if (badge != null)
                  Text(badge,
                      style: const TextStyle(color: GameColors.gold, fontWeight: FontWeight.w800, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _tiles() {
    final tiles = <Widget>[
      _tile(
        image: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFF472B6), Color(0xFF9333EA)])),
          padding: const EdgeInsets.all(8),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_photo_alternate_rounded, color: Colors.white, size: 46),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    t3('Use qualquer desenho\nde contorno', 'Use any\noutline drawing',
                        'Usa cualquier dibujo\nde contorno'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
        emoji: '➕',
        title: t3('Importar desenho', 'Import drawing', 'Importar dibujo'),
        onTap: _importDrawing,
      ),
    ];
    for (final id in _customIds) {
      final thumb = _thumbs[id];
      tiles.add(_tile(
        image: thumb == null
            ? Container(color: Colors.white)
            : Image.memory(thumb, fit: BoxFit.cover, gaplessPlayback: true),
        emoji: '🖼️',
        title: t3('Meu desenho', 'My drawing', 'Mi dibujo'),
        onTap: () => _openCustom(id),
        onLongPress: () => _deleteCustom(id),
      ));
    }
    for (final d in _drawings) {
      final art = _saved[d.id] ?? _SavedArt.empty();
      final percent = d.isFree ? null : (art.fills.length * 100 ~/ d.regions.length);
      tiles.add(_tile(
        image: CustomPaint(painter: _ArtPainter(drawing: d, fills: art.fills, strokes: art.strokes, outline: 9)),
        emoji: d.emoji,
        title: _name(d),
        badge: percent == null || percent == 0 ? null : (percent >= 100 ? '⭐' : '$percent%'),
        golden: percent != null && percent >= 100,
        onTap: () => _openEditor(d),
      ));
    }
    return tiles;
  }

  String _name(ColoringDrawing d) => t3(d.namePt, d.nameEn, d.nameEs);

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: t3('🎨 Colorir', '🎨 Coloring', '🎨 Colorear'),
      accent: _accent,
      backgroundColors: const [Color(0xFF3B1C3A), Color(0xFF160C1C)],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
        children: [
          GameHero(
            emoji: '🎨',
            title: t3('Ateliê de Pintura', 'Art Studio', 'Taller de Pintura'),
            subtitle: t3(
                'Escolha um desenho, toque para pintar e solte a criatividade!',
                'Pick a drawing, tap to paint and let your creativity shine!',
                '¡Elige un dibujo, toca para pintar y deja volar tu creatividad!'),
            accent: _accent,
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.82,
            children: _tiles(),
          ),
          if (_customIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                t3(
                    'Dica: segure um desenho importado para apagá-lo.',
                    'Tip: long-press an imported drawing to delete it.',
                    'Consejo: mantén pulsado un dibujo importado para borrarlo.'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

class _SavedArt {
  final Map<int, _Fill> fills;
  final List<_Stroke> strokes;
  _SavedArt(this.fills, this.strokes);
  factory _SavedArt.empty() => _SavedArt({}, []);

  static String key(String id) => 'coloring_v1_$id';

  static _SavedArt read(SharedPreferences prefs, String id) {
    final raw = prefs.getString(key(id));
    if (raw == null) return _SavedArt.empty();
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      final fills = <int, _Fill>{};
      (j['f'] as Map<String, dynamic>).forEach((k, v) {
        final l = List<int>.from(v as List);
        fills[int.parse(k)] = _Fill(l[0], l[1] == 1);
      });
      final strokes = (j['s'] as List).map((e) => _Stroke.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      return _SavedArt(fills, strokes);
    } catch (_) {
      return _SavedArt.empty();
    }
  }

  Future<void> write(SharedPreferences prefs, String id) => prefs.setString(
        key(id),
        jsonEncode({
          'f': {for (final e in fills.entries) '${e.key}': e.value.toJson()},
          's': [for (final s in strokes) s.toJson()],
        }),
      );
}

// ============================================================================
// EDITOR
// ============================================================================

class _ColoringEditor extends StatefulWidget {
  final ColoringDrawing drawing;
  const _ColoringEditor({required this.drawing});

  @override
  State<_ColoringEditor> createState() => _ColoringEditorState();
}

class _ColoringEditorState extends State<_ColoringEditor> with SingleTickerProviderStateMixin {
  ColoringDrawing get d => widget.drawing;

  Map<int, _Fill> _fills = {};
  List<_Stroke> _strokes = [];
  final List<_Snapshot> _undo = [];
  final List<_Snapshot> _redo = [];
  _Stroke? _current;

  _Tool _tool = _Tool.fill;
  Color _base = _palette[0];
  Color _color = _palette[0];
  bool _shine = false;
  double _brush = 24;
  bool _celebrated = false;
  bool _confetti = false;
  bool _loaded = false;
  DateTime _startedAt = DateTime.now();

  // Animação de "respingo" ao pintar
  late final AnimationController _splash =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
  int _splashRegion = -1;
  _Fill? _splashFrom;
  Offset _splashOrigin = Offset.zero;

  final TransformationController _zoom = TransformationController();

  // Desenho importado: cores renderizadas como imagem
  LineArt? get _art => d.lineArt;
  ui.Image? _colorImage;
  ui.Image? _prevColorImage;
  int _renderToken = 0;

  bool get _isFree => d.isFree;
  bool get _complete {
    if (_art != null) return _art!.significant.every(_fills.containsKey);
    return !_isFree && d.regions.isNotEmpty && _fills.length >= d.regions.length;
  }

  double? get _progress {
    if (_art != null) {
      final sig = _art!.significant;
      return sig.isEmpty ? null : sig.where(_fills.containsKey).length / sig.length;
    }
    return _isFree ? null : _fills.length / d.regions.length;
  }

  /// Recria a imagem de cores do desenho importado. Com [splash], anima a
  /// tinta se espalhando a partir do toque.
  Future<void> _refreshColors({bool splash = false}) async {
    final art = _art;
    if (art == null) return;
    final token = ++_renderToken;
    final img = await art.renderColors(
      {for (final e in _fills.entries) e.key: e.value.color},
      {
        for (final e in _fills.entries)
          if (e.value.shine) e.key
      },
    );
    if (!mounted || token != _renderToken) return;
    setState(() {
      _prevColorImage = splash ? _colorImage : null;
      _colorImage = img;
    });
    if (splash) _splash.forward(from: 0);
  }

  @override
  void initState() {
    super.initState();
    if (_isFree) _tool = _Tool.brush;
    _load();
  }

  @override
  void dispose() {
    _save();
    _splash.dispose();
    _zoom.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final art = _SavedArt.read(prefs, d.id);
    if (!mounted) return;
    setState(() {
      _fills = art.fills;
      _strokes = art.strokes;
      _celebrated = _complete;
      _loaded = true;
      _startedAt = DateTime.now();
    });
    _refreshColors();
  }

  Future<void> _save() async {
    if (!_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    await _SavedArt(_fills, _strokes).write(prefs, d.id);
    if (_art != null) {
      // Miniatura para a galeria
      final png = await _renderPng(320);
      if (png != null) {
        try {
          await prefs.setString(_customThumbKey(d.id), base64Encode(png));
        } catch (_) {}
      }
    }
  }

  Future<Uint8List?> _renderPng(int size) async {
    final rec = ui.PictureRecorder();
    final canvas = Canvas(rec);
    _ArtPainter(drawing: d, fills: _fills, strokes: _strokes, outline: 7, colorImage: _colorImage)
        .paint(canvas, Size(size.toDouble(), size.toDouble()));
    final image = await rec.endRecording().toImage(size, size);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return bytes?.buffer.asUint8List();
  }

  void _pushUndo() {
    _undo.add(_Snapshot(_fills, _strokes));
    if (_undo.length > 50) _undo.removeAt(0);
    _redo.clear();
  }

  void _restore(List<_Snapshot> from, List<_Snapshot> to) {
    if (from.isEmpty) return;
    to.add(_Snapshot(_fills, _strokes));
    final s = from.removeLast();
    AudioService().playSfx('whoosh', volume: 0.5);
    setState(() {
      _fills = Map.of(s.fills);
      _strokes = List.of(s.strokes);
    });
    _refreshColors();
  }

  int _regionAt(Offset v) {
    if (_art != null) return _art!.regionAt(v);
    for (int i = d.regions.length - 1; i >= 0; i--) {
      if (d.regions[i].contains(v)) return i;
    }
    return -1;
  }

  void _tapAt(Offset v) {
    if (_tool == _Tool.brush) {
      // Toque simples com pincel = um ponto
      _pushUndo();
      setState(() => _strokes.add(_Stroke(_color.toARGB32(), _brush, [v, v + const Offset(0.1, 0.1)])));
      AudioService().playSfx('pop', volume: 0.4);
      return;
    }
    if (_tool == _Tool.eraser) {
      _eraseAt(v, fillToo: true);
      return;
    }
    final r = _regionAt(v);
    if (r < 0) return;
    final next = _Fill(_color.toARGB32(), _shine);
    final prev = _fills[r];
    if (prev != null && prev.color == next.color && prev.shine == next.shine) return;
    _pushUndo();
    Haptics.selection();
    AudioService().playSfx('paint', volume: 0.7);
    setState(() {
      _splashRegion = r;
      _splashFrom = prev;
      _splashOrigin = v;
      _fills[r] = next;
    });
    if (_art != null) {
      _refreshColors(splash: true);
    } else {
      _splash.forward(from: 0);
    }
    _checkComplete();
  }

  void _eraseAt(Offset v, {required bool fillToo}) {
    final before = _Snapshot(_fills, _strokes);
    var changed = false;
    final keep = <_Stroke>[];
    for (final s in _strokes) {
      final hit = s.points.any((p) => (p - v).distance < s.width / 2 + 22);
      if (hit) {
        changed = true;
      } else {
        keep.add(s);
      }
    }
    final r = fillToo ? _regionAt(v) : -1;
    if (r >= 0 && _fills.containsKey(r)) changed = true;
    if (!changed) return;
    _undo.add(before);
    _redo.clear();
    AudioService().playSfx('erase', volume: 0.6);
    setState(() {
      _strokes = keep;
      if (r >= 0) _fills.remove(r);
    });
    if (r >= 0) _refreshColors();
  }

  Future<void> _checkComplete() async {
    if (!_complete || _celebrated) return;
    _celebrated = true;
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _confetti = true);
    await recordGameResult(context,
        gameId: 'coloring',
        won: true,
        score: (_art?.significant.length ?? d.regions.length) * 10,
        seconds: DateTime.now().difference(_startedAt).inSeconds);
    if (!mounted) return;
    await showGameResult(
      context,
      won: true,
      accent: _accent,
      title: t3('Obra-prima!', 'Masterpiece!', '¡Obra maestra!'),
      subtitle: t3('Que tal transformar seu desenho em quebra-cabeça?', 'How about turning your drawing into a puzzle?',
          '¿Y si conviertes tu dibujo en rompecabezas?'),
      stars: 3,
      primaryLabel: t3('🧩 Virar quebra-cabeça', '🧩 Make it a puzzle', '🧩 Hacer rompecabezas'),
      onPrimary: _toPuzzle,
      secondaryLabel: t3('Continuar pintando', 'Keep painting', 'Seguir pintando'),
      onSecondary: () {},
    );
    if (mounted) setState(() => _confetti = false);
  }

  Future<void> _toPuzzle() async {
    await _save();
    final bytes = await _renderPng(1000);
    if (bytes == null || !mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => JigsawPuzzleGame(initialImageBytes: bytes),
    ));
  }

  void _clearAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: GameColors.panel,
        title:
            Text(t3('Apagar tudo?', 'Clear everything?', '¿Borrar todo?'), style: const TextStyle(color: Colors.white)),
        content: Text(t3('Você pode desfazer depois.', 'You can undo it afterwards.', 'Puedes deshacerlo después.'),
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t3('Cancelar', 'Cancel', 'Cancelar'))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t3('Apagar', 'Clear', 'Borrar'), style: const TextStyle(color: GameColors.danger))),
        ],
      ),
    );
    if (ok != true) return;
    _pushUndo();
    AudioService().playSfx('erase');
    setState(() {
      _fills = {};
      _strokes = [];
      _celebrated = false;
    });
    _refreshColors();
  }

  List<Color> get _shades => [
        Color.lerp(_base, Colors.white, 0.6)!,
        Color.lerp(_base, Colors.white, 0.3)!,
        _base,
        Color.lerp(_base, Colors.black, 0.25)!,
        Color.lerp(_base, Colors.black, 0.5)!,
      ];

  // ==========================================================================
  // UI
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final progress = _progress;
    return Stack(
      children: [
        GameScaffold(
          title: '${d.emoji} ${t3(d.namePt, d.nameEn, d.nameEs)}',
          accent: _accent,
          backgroundColors: const [Color(0xFF2E1A35), Color(0xFF140B19)],
          actions: [
            IconButton(
              tooltip: t3('Desfazer', 'Undo', 'Deshacer'),
              icon: Icon(Icons.undo_rounded, color: _undo.isEmpty ? Colors.white30 : Colors.white),
              onPressed: _undo.isEmpty ? null : () => _restore(_undo, _redo),
            ),
            IconButton(
              tooltip: t3('Refazer', 'Redo', 'Rehacer'),
              icon: Icon(Icons.redo_rounded, color: _redo.isEmpty ? Colors.white30 : Colors.white),
              onPressed: _redo.isEmpty ? null : () => _restore(_redo, _undo),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
              color: GameColors.panel,
              onSelected: (v) {
                if (v == 'clear') _clearAll();
                if (v == 'puzzle') _toPuzzle();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                    value: 'puzzle',
                    child: Text(t3('🧩 Virar quebra-cabeça', '🧩 Make it a puzzle', '🧩 Hacer rompecabezas'),
                        style: const TextStyle(color: Colors.white))),
                PopupMenuItem(
                    value: 'clear',
                    child: Text(t3('🗑️ Apagar tudo', '🗑️ Clear all', '🗑️ Borrar todo'),
                        style: const TextStyle(color: Colors.white))),
              ],
            ),
          ],
          body: Column(
            children: [
              if (progress != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 7,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation(progress >= 1 ? GameColors.gold : _accent),
                    ),
                  ),
                ),
              Expanded(child: _canvas()),
              _toolsRow(),
              _paletteRow(),
              _shadesRow(),
              const SizedBox(height: 10),
            ],
          ),
        ),
        if (_confetti) const Positioned.fill(child: ConfettiBurst()),
      ],
    );
  }

  Widget _canvas() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: LayoutBuilder(builder: (context, c) {
        final side = min(c.maxWidth, c.maxHeight);
        final k = side / 1000;
        Offset toVirtual(Offset local) => local / k;
        final brushing = _tool != _Tool.fill;
        return Center(
          child: Container(
            width: side,
            height: side,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 18, offset: Offset(0, 8))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: InteractiveViewer(
                transformationController: _zoom,
                minScale: 1,
                maxScale: 5,
                panEnabled: !brushing,
                scaleEnabled: !brushing,
                child: GestureDetector(
                  onTapUp: (e) => _tapAt(toVirtual(e.localPosition)),
                  onPanStart: brushing
                      ? (e) {
                          final v = toVirtual(e.localPosition);
                          if (_tool == _Tool.brush) {
                            _pushUndo();
                            setState(() => _current = _Stroke(_color.toARGB32(), _brush, [v]));
                          } else {
                            _eraseAt(v, fillToo: false);
                          }
                        }
                      : null,
                  onPanUpdate: brushing
                      ? (e) {
                          final v = toVirtual(e.localPosition);
                          if (_tool == _Tool.brush && _current != null) {
                            final last = _current!.points.last;
                            if ((v - last).distance > 3) setState(() => _current!.points.add(v));
                          } else if (_tool == _Tool.eraser) {
                            _eraseAt(v, fillToo: false);
                          }
                        }
                      : null,
                  onPanEnd: brushing
                      ? (_) {
                          if (_current != null) {
                            setState(() {
                              _strokes.add(_current!);
                              _current = null;
                            });
                          }
                        }
                      : null,
                  child: AnimatedBuilder(
                    animation: _splash,
                    builder: (_, __) => CustomPaint(
                      size: Size(side, side),
                      painter: _ArtPainter(
                        drawing: d,
                        fills: _fills,
                        strokes: _strokes,
                        current: _current,
                        splashRegion: _splash.isAnimating ? _splashRegion : -1,
                        colorImage: _colorImage,
                        prevColorImage: _splash.isAnimating ? _prevColorImage : null,
                        splashFrom: _splashFrom,
                        splashOrigin: _splashOrigin,
                        splashT: Curves.easeOutCubic.transform(_splash.value),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _toolsRow() {
    Widget tool(_Tool t, IconData icon, String label) {
      final sel = _tool == t;
      return GestureDetector(
        onTap: () {
          AudioService().playClick();
          setState(() => _tool = t);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: sel ? _accent.withValues(alpha: 0.25) : GameColors.panel,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: sel ? _accent : Colors.white12, width: sel ? 2 : 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: sel ? Colors.white : Colors.white60, size: 20),
              const SizedBox(width: 5),
              Text(label,
                  style:
                      TextStyle(color: sel ? Colors.white : Colors.white60, fontWeight: FontWeight.w700, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            tool(_Tool.fill, Icons.format_color_fill_rounded, t3('Balde', 'Fill', 'Cubo')),
            const SizedBox(width: 6),
            tool(_Tool.brush, Icons.brush_rounded, t3('Pincel', 'Brush', 'Pincel')),
            const SizedBox(width: 6),
            tool(_Tool.eraser, Icons.auto_fix_normal_rounded, t3('Borracha', 'Eraser', 'Borrador')),
            const SizedBox(width: 10),
            if (_tool == _Tool.fill)
              GestureDetector(
                onTap: () {
                  AudioService().playSfx('star', volume: 0.6);
                  setState(() => _shine = !_shine);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: _shine ? const LinearGradient(colors: [Color(0xFFFFE08A), Color(0xFFF472B6)]) : null,
                    color: _shine ? null : GameColors.panel,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _shine ? Colors.white : Colors.white12),
                  ),
                  child: Text('✨ ${t3('Brilho', 'Shine', 'Brillo')}',
                      style: TextStyle(
                          color: _shine ? const Color(0xFF3B1C3A) : Colors.white60,
                          fontWeight: FontWeight.w800,
                          fontSize: 12)),
                ),
              )
            else if (_tool == _Tool.brush)
              ...[12.0, 24.0, 44.0].map((w) => GestureDetector(
                    onTap: () => setState(() => _brush = w),
                    child: Container(
                      width: 38,
                      height: 38,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: GameColors.panel,
                        shape: BoxShape.circle,
                        border: Border.all(color: _brush == w ? _accent : Colors.white12, width: _brush == w ? 2 : 1),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: w / 2 + 4,
                        height: w / 2 + 4,
                        decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _paletteRow() {
    // Esmaecido nas bordas indica que a paleta continua dos lados
    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        colors: [Colors.transparent, Colors.white, Colors.white, Colors.transparent],
        stops: [0, 0.04, 0.9, 1],
      ).createShader(rect),
      blendMode: BlendMode.dstIn,
      child: SizedBox(
        height: 58,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 10, 28, 4),
          scrollDirection: Axis.horizontal,
          itemCount: _palette.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final c = _palette[i];
            final sel = c == _base;
            return GestureDetector(
              onTap: () {
                Haptics.selection();
                AudioService().playSfx('pop', volume: 0.35);
                setState(() {
                  _base = c;
                  _color = c;
                  if (_tool == _Tool.eraser) _tool = _Tool.fill;
                });
              },
              child: AnimatedScale(
                scale: sel ? 1.15 : 1,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  width: 40,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(color: sel ? Colors.white : Colors.white24, width: sel ? 3 : 1.5),
                    boxShadow: sel ? [BoxShadow(color: c.withValues(alpha: 0.7), blurRadius: 10)] : null,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _shadesRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
      child: Row(
        children: [
          Text(t3('Tons', 'Shades', 'Tonos'),
              style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(width: 10),
          ..._shades.map((c) {
            final sel = c == _color;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  Haptics.selection();
                  setState(() => _color = c);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: sel ? 30 : 24,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: sel ? Colors.white : Colors.white24, width: sel ? 2.5 : 1),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ============================================================================
// PINTURA
// ============================================================================

class _ArtPainter extends CustomPainter {
  final ColoringDrawing drawing;
  final Map<int, _Fill> fills;
  final List<_Stroke> strokes;
  final _Stroke? current;
  final double outline;
  final int splashRegion;
  final _Fill? splashFrom;
  final Offset splashOrigin;
  final double splashT;
  final ui.Image? colorImage; // desenho importado: cores
  final ui.Image? prevColorImage; // desenho importado: cores antes do último toque

  _ArtPainter({
    required this.drawing,
    required this.fills,
    required this.strokes,
    this.current,
    this.outline = 6,
    this.splashRegion = -1,
    this.splashFrom,
    this.splashOrigin = Offset.zero,
    this.splashT = 1,
    this.colorImage,
    this.prevColorImage,
  });

  Paint _fillPaint(_Fill? f, Rect bounds) {
    if (f == null) return Paint()..color = Colors.white;
    final color = Color(f.color);
    if (!f.shine) return Paint()..color = color;
    return Paint()
      ..shader = ui.Gradient.radial(
        bounds.topLeft + Offset(bounds.width * 0.35, bounds.height * 0.3),
        max(bounds.width, bounds.height) * 0.75,
        [Color.lerp(color, Colors.white, 0.65)!, color, Color.lerp(color, Colors.black, 0.25)!],
        [0, 0.55, 1],
      );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / 1000;
    canvas.save();
    canvas.scale(k);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 1000, 1000), Paint()..color = Colors.white);

    final art = drawing.lineArt;
    if (art != null) {
      _paintLineArt(canvas, art);
      canvas.restore();
      return;
    }

    for (int i = 0; i < drawing.regions.length; i++) {
      final path = drawing.regions[i];
      final bounds = path.getBounds();
      if (i == splashRegion && splashT < 1) {
        canvas.drawPath(path, _fillPaint(splashFrom, bounds));
        canvas.save();
        canvas.clipPath(path);
        final far = [bounds.topLeft, bounds.topRight, bounds.bottomLeft, bounds.bottomRight]
            .map((p) => (p - splashOrigin).distance)
            .reduce(max);
        canvas.drawCircle(splashOrigin, far * splashT, _fillPaint(fills[i], bounds));
        canvas.restore();
      } else {
        canvas.drawPath(path, _fillPaint(fills[i], bounds));
      }
    }

    // Traços do pincel (presos à área do desenho)
    canvas.save();
    canvas.clipRect(const Rect.fromLTWH(0, 0, 1000, 1000));
    for (final s in [...strokes, if (current != null) current!]) {
      _drawStroke(canvas, s);
    }
    canvas.restore();

    // Contornos por cima de tudo
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = outline
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF2A2333);
    final masks = drawing.outlineMasks;
    for (int i = 1; i < drawing.regions.length; i++) {
      canvas.save();
      canvas.clipPath(masks[i]);
      canvas.drawPath(drawing.regions[i], line);
      canvas.restore();
    }
    for (final p in drawing.details) {
      canvas.drawPath(p, line);
    }
    canvas.restore();
  }

  void _paintLineArt(Canvas canvas, LineArt art) {
    final src = Rect.fromLTWH(0, 0, art.size.toDouble(), art.size.toDouble());
    const dst = Rect.fromLTWH(0, 0, 1000, 1000);
    final paint = Paint()..filterQuality = FilterQuality.medium;
    final base = prevColorImage ?? colorImage;
    if (base != null) canvas.drawImageRect(base, src, dst, paint);
    if (prevColorImage != null && colorImage != null && splashT < 1) {
      canvas.save();
      canvas.clipPath(Path()..addOval(Rect.fromCircle(center: splashOrigin, radius: 1450 * splashT)));
      canvas.drawImageRect(colorImage!, src, dst, paint);
      canvas.restore();
    }
    canvas.save();
    canvas.clipRect(dst);
    for (final s in [...strokes, if (current != null) current!]) {
      _drawStroke(canvas, s);
    }
    canvas.restore();
    canvas.drawImageRect(art.linesImage, src, dst, paint);
  }

  void _drawStroke(Canvas canvas, _Stroke s) {
    if (s.points.isEmpty) return;
    final paint = Paint()
      ..color = Color(s.color)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()..moveTo(s.points.first.dx, s.points.first.dy);
    for (int i = 1; i < s.points.length; i++) {
      final a = s.points[i - 1], b = s.points[i];
      final mid = (a + b) / 2;
      path.quadraticBezierTo(a.dx, a.dy, mid.dx, mid.dy);
    }
    path.lineTo(s.points.last.dx, s.points.last.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArtPainter old) => true;
}
