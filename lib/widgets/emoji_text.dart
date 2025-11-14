import 'package:flutter/material.dart';

/// Widget que renderiza emojis de forma consistente em todas as plataformas,
/// especialmente em Flutter Web onde emojis podem aparecer sem cor.
class EmojiText extends StatelessWidget {
  final String emoji;
  final double size;
  final TextStyle? style;

  const EmojiText(
    this.emoji, {
    super.key,
    this.size = 48,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      emoji,
      style: style?.copyWith(
        fontSize: size,
        // Força a fonte a usar variação de emoji colorido
        fontFamily: 'NotoColorEmoji',
        fontFamilyFallback: const [
          'Noto Color Emoji',
          'Apple Color Emoji',
          'Segoe UI Emoji',
          'Segoe UI Symbol',
          'Noto Sans Symbols',
          'Noto Sans Symbols 2',
        ],
      ) ?? TextStyle(
        fontSize: size,
        fontFamily: 'NotoColorEmoji',
        fontFamilyFallback: const [
          'Noto Color Emoji',
          'Apple Color Emoji',
          'Segoe UI Emoji',
          'Segoe UI Symbol',
          'Noto Sans Symbols',
          'Noto Sans Symbols 2',
        ],
      ),
    );
  }
}
