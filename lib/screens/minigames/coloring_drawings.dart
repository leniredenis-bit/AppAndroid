import 'dart:math';
import 'package:flutter/material.dart';
import 'coloring_lineart.dart';

/// Desenho para colorir: regiões fecháveis (em ordem de pintura) e
/// detalhes (traços que não recebem cor), num espaço de 1000 x 1000.
class ColoringDrawing {
  final String id;
  final String emoji;
  final String namePt, nameEn, nameEs;
  final List<Path> regions;
  final List<Path> details;

  /// Desenho importado pelo usuário (regiões detectadas na imagem).
  final LineArt? lineArt;

  ColoringDrawing({
    required this.id,
    required this.emoji,
    required this.namePt,
    required this.nameEn,
    required this.nameEs,
    required this.regions,
    this.details = const [],
    this.lineArt,
  });

  factory ColoringDrawing.custom(String id, LineArt art) => ColoringDrawing(
        id: id,
        emoji: '🖼️',
        namePt: 'Meu desenho',
        nameEn: 'My drawing',
        nameEs: 'Mi dibujo',
        regions: const [],
        lineArt: art,
      );

  bool get isCustom => lineArt != null;

  bool get isFree => id == 'free';

  List<Path>? _masks;

  /// Para cada região, a área NÃO coberta pelas regiões desenhadas por cima.
  /// Usada para recortar o contorno, evitando linhas "atravessando" a frente.
  List<Path> get outlineMasks {
    if (_masks != null) return _masks!;
    final big = Path()..addRect(const Rect.fromLTWH(-50, -50, 1100, 1100));
    final masks = List<Path>.filled(regions.length, big);
    Path? above;
    for (int i = regions.length - 1; i >= 0; i--) {
      masks[i] = above == null ? big : Path.combine(PathOperation.difference, big, above);
      above = above == null ? regions[i] : Path.combine(PathOperation.union, above, regions[i]);
    }
    return _masks = masks;
  }
}

// --------------------------------------------------------------------------
// Primitivas
// --------------------------------------------------------------------------

Path _circle(double x, double y, double r) => Path()..addOval(Rect.fromCircle(center: Offset(x, y), radius: r));

Path _ellipse(double x, double y, double w, double h, [double angle = 0]) {
  final p = Path()..addOval(Rect.fromCenter(center: Offset(x, y), width: w, height: h));
  return angle == 0 ? p : _rotate(p, x, y, angle);
}

Path _rect(double l, double t, double r, double b, [double radius = 0]) =>
    Path()..addRRect(RRect.fromLTRBR(l, t, r, b, Radius.circular(radius)));

Path _poly(List<double> xy) {
  final p = Path()..moveTo(xy[0], xy[1]);
  for (int i = 2; i < xy.length; i += 2) {
    p.lineTo(xy[i], xy[i + 1]);
  }
  return p..close();
}

Path _rotate(Path p, double cx, double cy, double angle) {
  final m = Matrix4.identity()
    ..translateByDouble(cx, cy, 0, 1)
    ..rotateZ(angle)
    ..translateByDouble(-cx, -cy, 0, 1);
  return p.transform(m.storage);
}

Path _union(List<Path> paths) => paths.reduce((a, b) => Path.combine(PathOperation.union, a, b));
Path _intersect(Path a, Path b) => Path.combine(PathOperation.intersect, a, b);
Path _minus(Path a, Path b) => Path.combine(PathOperation.difference, a, b);

/// Nuvem / juba / lã: círculo central cercado de "bolinhas".
Path _bumpy(double cx, double cy, double rx, double ry, int n, double bump) {
  final parts = <Path>[_ellipse(cx, cy, rx * 2, ry * 2)];
  for (int i = 0; i < n; i++) {
    final a = i * 2 * pi / n;
    parts.add(_circle(cx + cos(a) * rx, cy + sin(a) * ry, bump));
  }
  return _union(parts);
}

/// Folha pontuda apontando para [angle] a partir da base (x, y).
Path _leaf(double x, double y, double len, double width, double angle) {
  final p = Path()
    ..moveTo(x, y)
    ..quadraticBezierTo(x + len * 0.5, y - width, x + len, y)
    ..quadraticBezierTo(x + len * 0.5, y + width, x, y)
    ..close();
  return _rotate(p, x, y, angle);
}

Path _cloud(double x, double y, double s) => _union([
      _ellipse(x, y, 260 * s, 110 * s),
      _circle(x - 60 * s, y - 30 * s, 60 * s),
      _circle(x + 30 * s, y - 50 * s, 75 * s),
      _circle(x + 95 * s, y - 10 * s, 50 * s),
    ]);

Path _wave(double y, double amp, int waves) {
  final p = Path()..moveTo(-10, y);
  final w = 1020 / waves;
  for (int i = 0; i < waves; i++) {
    final x0 = -10 + i * w;
    p.quadraticBezierTo(x0 + w / 4, y - amp, x0 + w / 2, y);
    p.quadraticBezierTo(x0 + w * 3 / 4, y + amp, x0 + w, y);
  }
  p
    ..lineTo(1010, 1010)
    ..lineTo(-10, 1010)
    ..close();
  return p;
}

Path _hill(double y) => Path()
  ..moveTo(-10, y)
  ..quadraticBezierTo(500, y - 90, 1010, y + 10)
  ..lineTo(1010, 1010)
  ..lineTo(-10, 1010)
  ..close();

Path _line(List<double> xy) {
  final p = Path()..moveTo(xy[0], xy[1]);
  for (int i = 2; i < xy.length; i += 2) {
    p.lineTo(xy[i], xy[i + 1]);
  }
  return p;
}

Path _arc(double x, double y, double r, double start, double sweep) =>
    Path()..addArc(Rect.fromCircle(center: Offset(x, y), radius: r), start, sweep);

final Path _sky = _rect(0, 0, 1000, 1000);

// --------------------------------------------------------------------------
// Desenhos
// --------------------------------------------------------------------------

List<ColoringDrawing> buildColoringDrawings() => [
      _ark(),
      _lion(),
      _fish(),
      _dove(),
      _flower(),
      _sheep(),
      _house(),
      ColoringDrawing(id: 'free', emoji: '🖌️', namePt: 'Tela livre', nameEn: 'Free canvas', nameEs: 'Lienzo libre', regions: [_sky]),
    ];

ColoringDrawing _ark() {
  final upper = _rect(0, 0, 1000, 640);
  final bands = <Path>[];
  for (int i = 0; i < 4; i++) {
    final r = 440.0 - i * 45;
    bands.add(_intersect(_minus(_circle(500, 640, r), _circle(500, 640, r - 45)), upper));
  }
  final hull = Path()
    ..moveTo(190, 620)
    ..lineTo(810, 620)
    ..quadraticBezierTo(780, 790, 650, 810)
    ..lineTo(350, 810)
    ..quadraticBezierTo(220, 790, 190, 620)
    ..close();
  return ColoringDrawing(
    id: 'ark',
    emoji: '🚢',
    namePt: 'Arca de Noé',
    nameEn: "Noah's Ark",
    nameEs: 'Arca de Noé',
    regions: [
      _sky,
      _circle(860, 150, 75),
      _cloud(200, 190, 1),
      ...bands,
      _wave(720, 30, 5),
      hull,
      _intersect(hull, _rect(0, 680, 1000, 720)),
      _rect(330, 470, 670, 622, 8),
      _poly([300, 485, 500, 365, 700, 485]),
      _circle(420, 545, 32),
      _circle(500, 545, 32),
      _circle(580, 545, 32),
      _rect(475, 395, 525, 455, 6), // janelinha do telhado
      _wave(800, 35, 4),
    ],
    details: [
      for (final x in [260.0, 400.0, 540.0, 680.0]) _line([x, 740, x + 40, 740]),
    ],
  );
}

ColoringDrawing _lion() {
  return ColoringDrawing(
    id: 'lion',
    emoji: '🦁',
    namePt: 'Leão de Daniel',
    nameEn: "Daniel's Lion",
    nameEs: 'León de Daniel',
    regions: [
      _sky,
      _circle(880, 120, 70),
      _hill(820),
      _bumpy(500, 450, 240, 230, 14, 85),
      _circle(320, 260, 62),
      _circle(680, 260, 62),
      _circle(320, 260, 32),
      _circle(680, 260, 32),
      _circle(500, 460, 195),
      _union([_circle(448, 555, 70), _circle(552, 555, 70)]),
      _ellipse(500, 630, 70, 50),
      _circle(420, 410, 40),
      _circle(580, 410, 40),
      _circle(428, 418, 19),
      _circle(588, 418, 19),
      Path()
        ..moveTo(450, 488)
        ..quadraticBezierTo(500, 470, 550, 488)
        ..quadraticBezierTo(540, 530, 500, 540)
        ..quadraticBezierTo(460, 530, 450, 488)
        ..close(),
    ],
    details: [
      _line([500, 540, 500, 585]),
      for (final y in [540.0, 570.0]) ...[_line([380, y, 300, y - 12]), _line([620, y, 700, y - 12])],
      _arc(470, 585, 30, 0.2, 2.2),
      _arc(530, 585, 30, 0.7, 2.2),
    ],
  );
}

ColoringDrawing _fish() {
  final body = _ellipse(540, 500, 620, 400);
  return ColoringDrawing(
    id: 'fish',
    emoji: '🐟',
    namePt: 'Peixe de Jonas',
    nameEn: "Jonah's Fish",
    nameEs: 'Pez de Jonás',
    regions: [
      _sky,
      _wave(860, 25, 3),
      Path()
        ..moveTo(120, 880)
        ..quadraticBezierTo(60, 760, 130, 680)
        ..quadraticBezierTo(190, 600, 140, 520)
        ..quadraticBezierTo(230, 610, 170, 700)
        ..quadraticBezierTo(120, 780, 170, 880)
        ..close(),
      Path()
        ..moveTo(860, 890)
        ..quadraticBezierTo(930, 780, 870, 700)
        ..quadraticBezierTo(820, 630, 880, 560)
        ..quadraticBezierTo(800, 640, 830, 720)
        ..quadraticBezierTo(870, 800, 810, 890)
        ..close(),
      Path()
        ..moveTo(470, 330)
        ..quadraticBezierTo(520, 210, 640, 230)
        ..quadraticBezierTo(620, 290, 610, 335)
        ..close(),
      _poly([270, 500, 110, 360, 150, 500, 110, 640]),
      body,
      _intersect(body, _rect(0, 540, 1000, 1000)),
      _intersect(body, _rect(380, 0, 425, 1000)),
      _intersect(body, _rect(470, 0, 515, 1000)),
      _ellipse(560, 560, 120, 70, 0.5),
      _circle(730, 450, 46),
      _circle(740, 455, 22),
      _circle(860, 300, 26),
      _circle(905, 215, 18),
      _circle(875, 150, 12),
    ],
    details: [
      _arc(800, 540, 40, 1.9, 1.0),
    ],
  );
}

ColoringDrawing _dove() {
  return ColoringDrawing(
    id: 'dove',
    emoji: '🕊️',
    namePt: 'Pomba com oliveira',
    nameEn: 'Dove with olive leaf',
    nameEs: 'Paloma con olivo',
    regions: [
      _sky,
      _circle(150, 150, 85),
      _cloud(760, 190, 0.9),
      _cloud(260, 820, 1.1),
      _poly([320, 560, 130, 470, 160, 560, 130, 650]),
      _ellipse(500, 570, 460, 250),
      Path()
        ..moveTo(420, 545)
        ..quadraticBezierTo(440, 330, 630, 250)
        ..quadraticBezierTo(700, 228, 750, 255)
        ..quadraticBezierTo(680, 285, 655, 320)
        ..quadraticBezierTo(715, 312, 735, 335)
        ..quadraticBezierTo(665, 365, 640, 405)
        ..quadraticBezierTo(690, 405, 700, 425)
        ..quadraticBezierTo(620, 470, 575, 555)
        ..close(),
      _circle(705, 470, 92),
      _poly([785, 455, 870, 485, 785, 512]),
      _circle(728, 450, 15),
      _leaf(860, 500, 110, 34, 0.5),
      _leaf(880, 520, 100, 30, -0.4),
      _leaf(845, 515, 95, 28, 1.3),
    ],
    details: [
      _line([830, 490, 960, 590]),
      _arc(500, 600, 60, 0.3, 1.2),
    ],
  );
}

ColoringDrawing _flower() {
  final petals = <Path>[];
  for (int i = 0; i < 8; i++) {
    final a = i * pi / 4;
    petals.add(_ellipse(500 + cos(a) * 125, 380 + sin(a) * 125, 150, 90, a));
  }
  return ColoringDrawing(
    id: 'flower',
    emoji: '🌻',
    namePt: 'Flor e borboleta',
    nameEn: 'Flower and butterfly',
    nameEs: 'Flor y mariposa',
    regions: [
      _sky,
      _circle(120, 120, 70),
      _hill(820),
      _rect(486, 470, 514, 860, 10),
      _leaf(500, 700, 170, 50, -0.6),
      _leaf(500, 620, 150, 45, -2.5),
      ...petals,
      _circle(500, 380, 82),
      // borboleta
      _ellipse(770, 210, 120, 150, -0.4),
      _ellipse(880, 210, 120, 150, 0.4),
      _ellipse(785, 310, 80, 100, 0.4),
      _ellipse(865, 310, 80, 100, -0.4),
      _ellipse(825, 260, 30, 170),
      _circle(770, 200, 22),
      _circle(880, 200, 22),
    ],
    details: [
      _line([815, 180, 790, 120]),
      _line([835, 180, 860, 120]),
      for (int i = 0; i < 6; i++) _circle(470 + (i % 3) * 30.0, 360 + (i ~/ 3) * 40.0, 4),
    ],
  );
}

ColoringDrawing _sheep() {
  final wool = <Path>[_ellipse(450, 540, 400, 260)];
  for (int i = 0; i < 12; i++) {
    final a = i * 2 * pi / 12;
    wool.add(_circle(450 + cos(a) * 200, 540 + sin(a) * 125, 72));
  }
  return ColoringDrawing(
    id: 'sheep',
    emoji: '🐑',
    namePt: 'Ovelhinha',
    nameEn: 'Little sheep',
    nameEs: 'Ovejita',
    regions: [
      _sky,
      _circle(860, 140, 75),
      _cloud(230, 170, 0.9),
      _hill(760),
      _rect(330, 640, 375, 820, 14),
      _rect(410, 650, 455, 830, 14),
      _rect(480, 650, 525, 830, 14),
      _rect(560, 640, 605, 820, 14),
      _union(wool),
      _ellipse(625, 395, 120, 60, 0.5),
      _ellipse(815, 395, 120, 60, -0.5),
      _ellipse(720, 470, 170, 210),
      _bumpy(720, 370, 55, 30, 6, 32),
      _circle(690, 470, 16),
      _circle(752, 470, 16),
      _ellipse(720, 540, 70, 40),
      for (final x in [120.0, 900.0, 220.0]) _circle(x, 900, 22),
    ],
    details: [
      _arc(720, 545, 22, 0.4, 2.3),
    ],
  );
}

ColoringDrawing _house() {
  return ColoringDrawing(
    id: 'house',
    emoji: '🏡',
    namePt: 'Casinha no campo',
    nameEn: 'Little house',
    nameEs: 'Casita en el campo',
    regions: [
      _sky,
      _circle(130, 130, 75),
      _cloud(720, 150, 0.85),
      _hill(800),
      _poly([450, 1010, 550, 1010, 530, 805, 470, 805]),
      _rect(615, 250, 690, 400, 4),
      _rect(250, 455, 750, 805, 6),
      _poly([200, 475, 500, 230, 800, 475]),
      _rect(450, 620, 550, 805, 40),
      _rect(295, 520, 405, 615, 6),
      _rect(595, 520, 705, 615, 6),
      _circle(500, 380, 40),
      _rect(825, 560, 875, 810, 8),
      _bumpy(850, 470, 70, 80, 8, 60),
      for (final p in [const Offset(880, 440), const Offset(820, 500), const Offset(875, 520)]) _circle(p.dx, p.dy, 14),
    ],
    details: [
      _line([350, 520, 350, 615]),
      _line([295, 567, 405, 567]),
      _line([650, 520, 650, 615]),
      _line([595, 567, 705, 567]),
      _circle(530, 715, 8),
    ],
  );
}
