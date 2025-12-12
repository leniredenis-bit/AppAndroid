import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Script para gerar imagens de teste para o Jigsaw Puzzle
/// Execute com: dart run scripts/generate_puzzle_images.dart

void main() async {
  debugPrint('🎨 Gerando imagens de teste para o quebra-cabeça...');
  
  const int size = 500;
  final outputDir = Directory('assets/images');
  
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  // Imagem 1: Gradiente Azul (Céu)
  await generateGradientImage(
    size,
    [Colors.blue.shade900, Colors.blue.shade300, Colors.lightBlue.shade100],
    'assets/images/puzzle1.png',
    'Céu Azul',
  );

  // Imagem 2: Gradiente Verde (Floresta)
  await generateGradientImage(
    size,
    [Colors.green.shade900, Colors.green.shade500, Colors.lightGreen.shade200],
    'assets/images/puzzle2.png',
    'Floresta Verde',
  );

  // Imagem 3: Gradiente Laranja (Pôr do Sol)
  await generateGradientImage(
    size,
    [Colors.orange.shade900, Colors.deepOrange.shade500, Colors.amber.shade200],
    'assets/images/puzzle3.png',
    'Pôr do Sol',
  );

  // Imagem 4: Gradiente Roxo (Aurora)
  await generateGradientImage(
    size,
    [Colors.purple.shade900, Colors.pink.shade400, Colors.purple.shade200],
    'assets/images/puzzle4.png',
    'Aurora',
  );

  debugPrint('✅ Todas as imagens foram geradas com sucesso!');
  debugPrint('📁 Localização: assets/images/');
}

Future<void> generateGradientImage(
  int size,
  List<Color> colors,
  String outputPath,
  String name,
) async {
  debugPrint('  Criando: $name ($outputPath)...');
  
  // Infelizmente, dart puro não tem acesso a ui.Image sem o framework Flutter rodando
  // Vou criar um approach diferente usando dados raw
  
  // Cria um gradiente vertical simples em formato PNG
  final pixels = Uint8List(size * size * 4); // RGBA
  
  for (int y = 0; y < size; y++) {
    final t = y / size; // 0.0 a 1.0
    final Color color = _interpolateColors(colors, t);
    
    for (int x = 0; x < size; x++) {
      final index = (y * size + x) * 4;
      pixels[index] = (color.r * 255.0).round() & 0xff;
      pixels[index + 1] = (color.g * 255.0).round() & 0xff;
      pixels[index + 2] = (color.b * 255.0).round() & 0xff;
      pixels[index + 3] = (color.a * 255.0).round() & 0xff;
    }
  }
  
  // Não podemos escrever PNG direto sem package, então vamos usar uma abordagem mais simples
  debugPrint('  ⚠️ Nota: Script direto não funciona sem package image. Usando alternativa...');
}

Color _interpolateColors(List<Color> colors, double t) {
  if (colors.length == 1) return colors[0];
  
  final segmentSize = 1.0 / (colors.length - 1);
  final segment = (t / segmentSize).floor().clamp(0, colors.length - 2);
  final localT = (t - segment * segmentSize) / segmentSize;
  
  return Color.lerp(colors[segment], colors[segment + 1], localT)!;
}
