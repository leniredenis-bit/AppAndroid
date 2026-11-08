import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';

/// Página padrão do app: AppBar da marca, fundo em degradê do tema e
/// conteúdo com largura máxima (centralizado em telas largas).
class AppPage extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;
  final bool constrainWidth;

  const AppPage({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.leading,
    this.constrainWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      backgroundColor: p.background,
      appBar: AppBar(title: Text(title), centerTitle: true, actions: actions, leading: leading),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [p.backgroundTop, p.background],
          ),
        ),
        child: SafeArea(top: false, child: constrainWidth ? MaxWidth(child: body) : body),
      ),
    );
  }
}

/// Cartão com superfície e borda do tema (nunca some no fundo).
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final Gradient? gradient;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderColor,
    this.borderWidth = 1.2,
    this.onTap,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? p.surface) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor ?? p.border, width: borderWidth),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: p.isDark ? 0.28 : 0.08), blurRadius: 14, offset: const Offset(0, 5)),
        ],
      ),
      child: child,
    );
    if (onTap == null) return card;
    return _Pressable(onTap: onTap!, child: card);
  }
}

/// Botão principal (cheio). A cor do texto é escolhida pelo contraste.
class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? color;
  final bool outlined;
  final bool expand;

  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.color,
    this.outlined = false,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final base = color ?? p.primary;
    final fg = outlined ? (color ?? p.accent) : AppPalette.onColor(base);
    final content = AnimatedOpacity(
      opacity: onTap == null ? 0.5 : 1,
      duration: const Duration(milliseconds: 150),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: outlined ? p.surface : base,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: outlined ? (color ?? p.accent) : Colors.black.withValues(alpha: 0.12), width: 1.5),
          boxShadow: outlined
              ? null
              : [BoxShadow(color: base.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, color: fg, size: 20), const SizedBox(width: 8)],
            Flexible(
              child: Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
    if (onTap == null) return content;
    return _Pressable(onTap: onTap!, child: content);
  }
}

/// Selo pequeno (dificuldade, tema, etc.).
class AppChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;
  const AppChip({super.key, required this.label, required this.color, this.filled = false});

  @override
  Widget build(BuildContext context) {
    final fg = filled ? AppPalette.onColor(color) : color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: filled ? 1 : 0.7)),
      ),
      child: Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}

/// Título de seção.
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(text.toUpperCase(),
          style: TextStyle(
              color: context.palette.textMuted, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
    );
  }
}

/// Cores de dificuldade (1 fácil, 2 médio, 3 difícil) legíveis nos dois temas.
Color difficultyColor(BuildContext context, int level) {
  final dark = context.palette.isDark;
  switch (level) {
    case 1:
      return dark ? const Color(0xFF4ADE80) : const Color(0xFF15803D);
    case 3:
      return dark ? const Color(0xFFF87171) : const Color(0xFFC62828);
    default:
      return dark ? const Color(0xFFFBBF24) : const Color(0xFF9A6200);
  }
}

class _Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _Pressable({required this.child, required this.onTap});

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) {
        setState(() => _down = false);
        Haptics.selection();
        AudioService().playClick();
        widget.onTap();
      },
      child: AnimatedScale(scale: _down ? 0.97 : 1, duration: const Duration(milliseconds: 100), child: widget.child),
    );
  }
}
