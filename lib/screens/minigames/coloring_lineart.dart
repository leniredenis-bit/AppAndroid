import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/painting.dart';

/// Desenho de contorno importado pelo usuário.
///
/// A imagem é convertida num quadrado [size] x [size] em tons de cinza;
/// pixels escuros são "linha" e o resto é dividido em regiões (áreas
/// fechadas pelas linhas), cada uma pintável com o balde.
class LineArt {
  static const int maxSide = 900;
  static const int _lineThreshold = 150; // luminância abaixo disto = linha

  final int size;
  final Uint8List lum; // luminância 0..255 por pixel
  final Int32List labels; // região de cada pixel (-1 = linha)
  final int regionCount;
  final Int32List _order; // pixels agrupados por região
  final Int32List _start; // início de cada região em _order (tamanho regionCount + 1)
  final List<Rect> bounds; // retângulo de cada região (em pixels)
  final Set<int> significant; // regiões grandes o bastante para contar no progresso
  final ui.Image linesImage; // linhas pretas sobre fundo transparente

  LineArt._(this.size, this.lum, this.labels, this.regionCount, this._order, this._start, this.bounds,
      this.significant, this.linesImage);

  int areaOf(int region) => _start[region + 1] - _start[region];

  /// Região no ponto (em coordenadas 0..1000), ou -1 se for linha.
  int regionAt(Offset virtual) {
    final x = (virtual.dx / 1000 * size).floor(), y = (virtual.dy / 1000 * size).floor();
    if (x < 0 || y < 0 || x >= size || y >= size) return -1;
    return labels[y * size + x];
  }

  // --------------------------------------------------------------------------
  // Criação
  // --------------------------------------------------------------------------

  /// A partir dos bytes de uma imagem qualquer (PNG/JPG…).
  static Future<LineArt> fromImageBytes(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final src = (await codec.getNextFrame()).image;
    final longest = max(src.width, src.height);
    final scale = min(1.0, maxSide / longest);
    final n = max(64, (longest * scale).round());

    // Centraliza num quadrado branco (imagens com transparência ficam sobre branco)
    final rec = ui.PictureRecorder();
    final canvas = Canvas(rec);
    canvas.drawRect(Rect.fromLTWH(0, 0, n.toDouble(), n.toDouble()), Paint()..color = const Color(0xFFFFFFFF));
    final w = src.width * scale, h = src.height * scale;
    canvas.drawImageRect(
      src,
      Rect.fromLTWH(0, 0, src.width.toDouble(), src.height.toDouble()),
      Rect.fromLTWH((n - w) / 2, (n - h) / 2, w, h),
      Paint()..filterQuality = FilterQuality.high,
    );
    final square = await rec.endRecording().toImage(n, n);
    final rgba = (await square.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List();
    final lum = Uint8List(n * n);
    for (int i = 0; i < n * n; i++) {
      final r = rgba[i * 4], g = rgba[i * 4 + 1], b = rgba[i * 4 + 2];
      lum[i] = ((r * 299 + g * 587 + b * 114) ~/ 1000);
    }
    return fromLuminance(n, lum);
  }

  /// A partir da imagem em tons de cinza salva anteriormente (ver [encodePng]).
  /// Lê os pixels sem redimensionar, para gerar exatamente as mesmas regiões.
  static Future<LineArt> fromPng(Uint8List png) async {
    final codec = await ui.instantiateImageCodec(png);
    final img = (await codec.getNextFrame()).image;
    final n = img.width;
    final rgba = (await img.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List();
    final lum = Uint8List(n * n);
    for (int i = 0; i < n * n; i++) {
      lum[i] = rgba[i * 4];
    }
    return fromLuminance(n, lum);
  }

  static Future<LineArt> fromLuminance(int n, Uint8List lum) async {
    final total = n * n;
    final line = Uint8List(total);
    for (int i = 0; i < total; i++) {
      if (lum[i] < _lineThreshold) line[i] = 1;
    }

    // Engrossa as linhas 1px só para separar regiões (fecha pequenas falhas)
    final closed = Uint8List.fromList(line);
    for (int y = 0; y < n; y++) {
      for (int x = 0; x < n; x++) {
        if (line[y * n + x] == 0) continue;
        if (x > 0) closed[y * n + x - 1] = 1;
        if (x < n - 1) closed[y * n + x + 1] = 1;
        if (y > 0) closed[(y - 1) * n + x] = 1;
        if (y < n - 1) closed[(y + 1) * n + x] = 1;
      }
    }

    // Rotula áreas conectadas (4 vizinhos)
    final labels = Int32List(total)..fillRange(0, total, -1);
    final queue = Int32List(total);
    int regions = 0;
    for (int s = 0; s < total; s++) {
      if (closed[s] == 1 || labels[s] >= 0) continue;
      int head = 0, tail = 0;
      queue[tail++] = s;
      labels[s] = regions;
      while (head < tail) {
        final p = queue[head++];
        final x = p % n, y = p ~/ n;
        void visit(int q) {
          if (closed[q] == 0 && labels[q] < 0) {
            labels[q] = regions;
            queue[tail++] = q;
          }
        }

        if (x > 0) visit(p - 1);
        if (x < n - 1) visit(p + 1);
        if (y > 0) visit(p - n);
        if (y < n - 1) visit(p + n);
      }
      regions++;
    }

    // Devolve às regiões os pixels que só eram linha por causa do engrossamento
    for (int pass = 0; pass < 2; pass++) {
      for (int p = 0; p < total; p++) {
        if (line[p] == 1 || labels[p] >= 0) continue;
        final x = p % n, y = p ~/ n;
        if (x > 0 && labels[p - 1] >= 0) {
          labels[p] = labels[p - 1];
        } else if (x < n - 1 && labels[p + 1] >= 0) {
          labels[p] = labels[p + 1];
        } else if (y > 0 && labels[p - n] >= 0) {
          labels[p] = labels[p - n];
        } else if (y < n - 1 && labels[p + n] >= 0) {
          labels[p] = labels[p + n];
        }
      }
    }

    // Agrupa pixels por região e calcula limites
    final counts = Int32List(regions + 1);
    final minX = Int32List(regions)..fillRange(0, regions, n);
    final minY = Int32List(regions)..fillRange(0, regions, n);
    final maxX = Int32List(regions);
    final maxY = Int32List(regions);
    for (int p = 0; p < total; p++) {
      final l = labels[p];
      if (l < 0) continue;
      counts[l + 1]++;
      final x = p % n, y = p ~/ n;
      if (x < minX[l]) minX[l] = x;
      if (x > maxX[l]) maxX[l] = x;
      if (y < minY[l]) minY[l] = y;
      if (y > maxY[l]) maxY[l] = y;
    }
    final start = Int32List(regions + 1);
    for (int l = 0; l < regions; l++) {
      start[l + 1] = start[l] + counts[l + 1];
    }
    final cursor = Int32List.fromList(start);
    final order = Int32List(start[regions]);
    for (int p = 0; p < total; p++) {
      final l = labels[p];
      if (l >= 0) order[cursor[l]++] = p;
    }
    final bounds = List.generate(
        regions, (l) => Rect.fromLTRB(minX[l].toDouble(), minY[l].toDouble(), maxX[l] + 1.0, maxY[l] + 1.0));

    final minArea = max(40, total ~/ 4000);
    final significant = <int>{
      for (int l = 0; l < regions; l++)
        if (start[l + 1] - start[l] >= minArea) l,
    };

    // Camada de linhas: preta com transparência proporcional ao escuro (bordas suaves)
    final lines = Uint8List(total * 4);
    for (int p = 0; p < total; p++) {
      final dark = 255 - lum[p];
      if (dark < 40) continue;
      final a = (dark * 1.5).clamp(0, 255).toInt();
      lines[p * 4] = 0x2A;
      lines[p * 4 + 1] = 0x23;
      lines[p * 4 + 2] = 0x33;
      lines[p * 4 + 3] = a;
    }
    final linesImage = await _imageFromRgba(lines, n);

    return LineArt._(n, lum, labels, regions, order, start, bounds, significant, linesImage);
  }

  // --------------------------------------------------------------------------
  // Pintura
  // --------------------------------------------------------------------------

  /// Imagem com as cores das regiões (sem as linhas).
  /// [colors]: região -> ARGB; [shine]: regiões com efeito brilho.
  Future<ui.Image> renderColors(Map<int, int> colors, Set<int> shine) {
    final total = size * size;
    final px = Uint32List(total)..fillRange(0, total, 0xFFFFFFFF);
    colors.forEach((region, argb) {
      if (region < 0 || region >= regionCount) return;
      final from = _start[region], to = _start[region + 1];
      if (!shine.contains(region)) {
        final v = _abgr(argb);
        for (int i = from; i < to; i++) {
          px[_order[i]] = v;
        }
        return;
      }
      // Brilho: degradê radial do claro (alto-esquerda) para a cor e um pouco mais escuro
      final b = bounds[region];
      final cx = b.left + b.width * 0.35, cy = b.top + b.height * 0.3;
      final radius = max(b.width, b.height) * 0.75 + 1;
      final c = Color(argb);
      final light = Color.lerp(c, const Color(0xFFFFFFFF), 0.65)!;
      final dark = Color.lerp(c, const Color(0xFF000000), 0.25)!;
      for (int i = from; i < to; i++) {
        final p = _order[i];
        final d = sqrt(pow(p % size - cx, 2) + pow(p ~/ size - cy, 2)) / radius;
        final col = d < 0.55 ? Color.lerp(light, c, d / 0.55)! : Color.lerp(c, dark, ((d - 0.55) / 0.45).clamp(0, 1))!;
        px[p] = _abgr(col.toARGB32());
      }
    });
    return _imageFromRgba(px.buffer.asUint8List(), size);
  }

  /// PNG em tons de cinza para salvar o desenho (e recriá-lo com [fromPng]).
  Future<Uint8List> encodePng() async {
    final total = size * size;
    final px = Uint8List(total * 4);
    for (int p = 0; p < total; p++) {
      px[p * 4] = px[p * 4 + 1] = px[p * 4 + 2] = lum[p];
      px[p * 4 + 3] = 255;
    }
    final img = await _imageFromRgba(px, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  static int _abgr(int argb) {
    final a = (argb >> 24) & 0xFF, r = (argb >> 16) & 0xFF, g = (argb >> 8) & 0xFF, b = argb & 0xFF;
    return (a << 24) | (b << 16) | (g << 8) | r; // bytes RGBA em little-endian
  }

  static Future<ui.Image> _imageFromRgba(Uint8List rgba, int n) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(rgba, n, n, ui.PixelFormat.rgba8888, completer.complete);
    return completer.future;
  }
}
