import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jw_splash_games/screens/minigames/coloring_lineart.dart';

/// Desenho de contorno sintético: moldura, círculo e uma linha vertical
/// com uma falha de 1px (comum em desenhos escaneados).
Future<Uint8List> _sampleDrawing() async {
  const n = 400.0;
  final rec = ui.PictureRecorder();
  final c = Canvas(rec);
  c.drawRect(const Rect.fromLTWH(0, 0, n, n), Paint()..color = Colors.white);
  final ink = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4;
  c.drawRect(const Rect.fromLTWH(40, 40, 320, 320), ink);
  c.drawCircle(const Offset(120, 200), 50, ink);
  // Linha vertical dividindo a moldura, com falha de 1px no meio
  c.drawLine(const Offset(250, 40), const Offset(250, 199), ink);
  c.drawLine(const Offset(250, 201), const Offset(250, 360), ink);
  final img = await rec.endRecording().toImage(400, 400);
  final png = await img.toByteData(format: ui.ImageByteFormat.png);
  return png!.buffer.asUint8List();
}

void main() {
  testWidgets('detecta as áreas fechadas e fecha pequenas falhas', (tester) async {
    await tester.runAsync(() async {
      final bytes = await _sampleDrawing();
      final art = await LineArt.fromImageBytes(bytes);

      // Fundo externo, círculo, lado esquerdo e lado direito da moldura
      expect(art.significant.length, 4);

      int at(double x, double y) => art.regionAt(Offset(x / 400 * 1000, y / 400 * 1000));
      final outside = at(10, 10);
      final circle = at(120, 200);
      final left = at(80, 80);
      final right = at(300, 300);
      expect({outside, circle, left, right}.length, 4, reason: 'cada área é uma região diferente');
      expect(at(300, 80), right, reason: 'a falha de 1px não junta as áreas');
      expect(at(250, 100), -1, reason: 'pixel da linha não é pintável');

      // Recarregar a partir do PNG salvo gera as mesmas regiões
      final again = await LineArt.fromPng(await art.encodePng());
      expect(again.regionCount, art.regionCount);
      expect(again.regionAt(const Offset(300, 200)), art.regionAt(const Offset(300, 200)));

      // Pintar gera uma imagem do tamanho certo
      final img = await art.renderColors({circle: 0xFFE53935}, {});
      expect(img.width, art.size);
    });
  });
}
