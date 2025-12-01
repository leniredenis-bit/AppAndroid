import 'package:flutter/material.dart';

/// Extensão para fornecer o método withValues(...) usado em todo o projeto.
///
/// Muitos widgets chamam `someColor.withValues(alpha: 0.5)`.
/// Esta extensão usa a nova API do Flutter 3.x (r, g, b) para evitar warnings.
extension ColorWithValues on Color {
  /// Retorna esta cor com o alpha fornecido (0.0-1.0). Se [alpha] for null,
  /// a cor original é retornada.
  ///
  /// Usa a nova API do Flutter para evitar deprecation warnings.
  Color withValues({double? alpha}) {
    if (alpha == null) return this;
    final clamped = alpha.clamp(0.0, 1.0);
    // Usando a nova API do Flutter 3.x
    final intR = (r * 255.0).round() & 0xff;
    final intG = (g * 255.0).round() & 0xff;
    final intB = (b * 255.0).round() & 0xff;
    final intAlpha = (clamped * 255).round().clamp(0, 255);
    return Color.fromARGB(intAlpha, intR, intG, intB);
  }
}
