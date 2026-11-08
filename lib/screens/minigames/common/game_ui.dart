import 'dart:math';
import 'package:flutter/material.dart';
import '../../../services/audio_service.dart';
import 'game_text.dart';
import '../../../theme/app_theme.dart';

/// Paleta base dos minigames (mesma família de cores do app).
class GameColors {
  static const background = Color(0xFF0E1726);
  static const backgroundTop = Color(0xFF16233B);
  static const panel = Color(0xFF1B2A45);
  static const panelLight = Color(0xFF25395C);
  static const appBar = Color(0xFF162447);
  static const gold = Color(0xFFFFC94A);
  static const success = Color(0xFF4ADE80);
  static const danger = Color(0xFFFF6B6B);
}

/// Scaffold padrão dos minigames: fundo em degradê, AppBar transparente,
/// botão voltar com som.
class GameScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Color accent;
  final List<Widget>? actions;
  final List<Color>? backgroundColors;
  final VoidCallback? onBack;

  /// Jogos usam sempre o tema escuro internamente (contraste garantido).
  final bool forceDarkTheme;

  const GameScaffold({
    super.key,
    required this.title,
    required this.body,
    this.accent = GameColors.gold,
    this.actions,
    this.backgroundColors,
    this.onBack,
    this.forceDarkTheme = true,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = _scaffold(context);
    return forceDarkTheme ? GameDarkTheme(child: scaffold) : scaffold;
  }

  Widget _scaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: GameColors.background,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: GameColors.appBar,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            AudioService().playClick();
            if (onBack != null) {
              onBack!();
            } else {
              Navigator.of(context).maybePop();
            }
          },
        ),
        actions: actions,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: backgroundColors ?? const [GameColors.backgroundTop, GameColors.background],
          ),
        ),
        // Em telas largas (web/tablet) o jogo fica centralizado com largura máxima
        child: SafeArea(top: false, child: MaxWidth(maxWidth: 720, child: body)),
      ),
    );
  }
}

/// Indicador compacto do HUD (ícone/emoji + valor).
class HudChip extends StatelessWidget {
  final String emoji;
  final String value;
  final String? label;
  final Color color;
  final bool highlight;

  const HudChip({
    super.key,
    required this.emoji,
    required this.value,
    this.label,
    this.color = Colors.white,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: highlight ? color.withValues(alpha: 0.22) : GameColors.panel.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: highlight ? color : Colors.white12, width: highlight ? 1.6 : 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label != null)
                Text(label!, style: const TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 0.5)),
              Text(value, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Botão arredondado com efeito de "apertar".
class PillButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color color;
  final bool filled;
  final bool expand;

  const PillButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.color = GameColors.gold,
    this.filled = true,
    this.expand = false,
  });

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final fg = widget.filled ? _onColor(widget.color) : widget.color;
    final child = AnimatedScale(
      scale: _pressed ? 0.94 : 1.0,
      duration: const Duration(milliseconds: 90),
      child: AnimatedOpacity(
        opacity: enabled ? 1 : 0.45,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            gradient: widget.filled
                ? LinearGradient(colors: [widget.color, Color.lerp(widget.color, Colors.black, 0.18)!])
                : null,
            color: widget.filled ? null : Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: widget.color.withValues(alpha: widget.filled ? 0 : 0.6), width: 1.5),
            boxShadow: widget.filled
                ? [BoxShadow(color: widget.color.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))]
                : null,
          ),
          child: Row(
            mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: fg, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              Haptics.selection();
              AudioService().playClick();
              widget.onTap!();
            }
          : null,
      child: child,
    );
  }

  static Color _onColor(Color c) => c.computeLuminance() > 0.5 ? const Color(0xFF1A1A2E) : Colors.white;
}

/// Grupo de opções selecionáveis (dificuldade, modo, jogadores…).
class OptionPicker<T> extends StatelessWidget {
  final String title;
  final List<OptionItem<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final Color accent;

  const OptionPicker({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.accent = GameColors.gold,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title.toUpperCase(),
              style: const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((o) {
            final isSel = o.value == selected;
            return GestureDetector(
              onTap: () {
                AudioService().playClick();
                Haptics.selection();
                onChanged(o.value);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSel ? accent.withValues(alpha: 0.2) : GameColors.panel,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isSel ? accent : Colors.white12, width: isSel ? 2 : 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(o.label,
                        style: TextStyle(
                            color: isSel ? Colors.white : Colors.white70,
                            fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                            fontSize: 14)),
                    if (o.subtitle != null)
                      Text(o.subtitle!, style: TextStyle(color: isSel ? accent : Colors.white38, fontSize: 11)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class OptionItem<T> {
  final T value;
  final String label;
  final String? subtitle;
  const OptionItem(this.value, this.label, [this.subtitle]);
}

/// Cartão de painel padrão.
class GamePanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const GamePanel({super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: GameColors.panel.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 14, offset: Offset(0, 6))],
      ),
      child: child,
    );
  }
}

/// Faz o filho tremer horizontalmente cada vez que [trigger] muda.
class ShakeOnChange extends StatefulWidget {
  final int trigger;
  final Widget child;
  final double amplitude;
  const ShakeOnChange({super.key, required this.trigger, required this.child, this.amplitude = 8});

  @override
  State<ShakeOnChange> createState() => _ShakeOnChangeState();
}

class _ShakeOnChangeState extends State<ShakeOnChange> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 380));

  @override
  void didUpdateWidget(covariant ShakeOnChange old) {
    super.didUpdateWidget(old);
    if (old.trigger != widget.trigger) _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, child) {
        final dx = sin(_c.value * pi * 6) * widget.amplitude * (1 - _c.value);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: widget.child,
    );
  }
}

// ============================================================================
// CONFETE
// ============================================================================

/// Chuva de confete que toca uma vez ao aparecer.
class ConfettiBurst extends StatefulWidget {
  final int count;
  final Duration duration;
  const ConfettiBurst({super.key, this.count = 90, this.duration = const Duration(milliseconds: 3200)});

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.duration)..forward();
  late final List<_Confetto> _pieces;

  @override
  void initState() {
    super.initState();
    final r = Random();
    const colors = [
      Color(0xFFFF6B6B), Color(0xFFFFC94A), Color(0xFF4ADE80),
      Color(0xFF60A5FA), Color(0xFFC084FC), Color(0xFFF472B6), Color(0xFF2DD4BF),
    ];
    _pieces = List.generate(widget.count, (_) {
      return _Confetto(
        x: r.nextDouble(),
        delay: r.nextDouble() * 0.35,
        speed: 0.55 + r.nextDouble() * 0.6,
        drift: (r.nextDouble() - 0.5) * 0.25,
        spin: (r.nextDouble() - 0.5) * 14,
        size: 6 + r.nextDouble() * 7,
        color: colors[r.nextInt(colors.length)],
        circle: r.nextDouble() < 0.3,
      );
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) => CustomPaint(size: Size.infinite, painter: _ConfettiPainter(_pieces, _c.value)),
        ),
      ),
    );
  }
}

class _Confetto {
  final double x, delay, speed, drift, spin, size;
  final Color color;
  final bool circle;
  _Confetto({
    required this.x, required this.delay, required this.speed, required this.drift,
    required this.spin, required this.size, required this.color, required this.circle,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Confetto> pieces;
  final double t;
  _ConfettiPainter(this.pieces, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in pieces) {
      final local = ((t - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (local <= 0) continue;
      final y = -20 + local * p.speed * (size.height + 60) * 1.3;
      if (y > size.height + 20) continue;
      final x = (p.x + p.drift * local + sin(local * 8 + p.x * 10) * 0.02) * size.width;
      final fade = local > 0.85 ? (1 - local) / 0.15 : 1.0;
      paint.color = p.color.withValues(alpha: fade);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.spin * local);
      if (p.circle) {
        canvas.drawCircle(Offset.zero, p.size / 2.4, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5),
              const Radius.circular(2)),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.t != t;
}

// ============================================================================
// TELA DE RESULTADO
// ============================================================================

class ResultStat {
  final String emoji;
  final String label;
  final String value;
  const ResultStat(this.emoji, this.label, this.value);
}

/// Mostra o painel de resultado com estrelas animadas e confete.
///
/// [stars] de 0 a 3 (use -1 para não mostrar estrelas, ex.: derrota).
Future<void> showGameResult(
  BuildContext context, {
  required bool won,
  required String title,
  String? subtitle,
  int stars = -1,
  List<ResultStat> stats = const [],
  bool newRecord = false,
  required String primaryLabel,
  required VoidCallback onPrimary,
  String? secondaryLabel,
  VoidCallback? onSecondary,
  Color accent = GameColors.gold,
}) {
  if (won) {
    AudioService().playVictory();
    Haptics.heavy();
  } else {
    AudioService().playGameOver();
  }
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'result',
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: const Duration(milliseconds: 380),
    transitionBuilder: (_, anim, __, child) => ScaleTransition(
      scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
      child: FadeTransition(opacity: anim, child: child),
    ),
    pageBuilder: (ctx, _, __) => Stack(
      children: [
        if (won) const Positioned.fill(child: ConfettiBurst()),
        Center(
          child: _ResultCard(
            won: won,
            title: title,
            subtitle: subtitle,
            stars: stars,
            stats: stats,
            newRecord: newRecord,
            accent: accent,
            primaryLabel: primaryLabel,
            onPrimary: () {
              Navigator.of(ctx).pop();
              onPrimary();
            },
            secondaryLabel: secondaryLabel,
            onSecondary: onSecondary == null
                ? null
                : () {
                    Navigator.of(ctx).pop();
                    onSecondary();
                  },
          ),
        ),
      ],
    ),
  );
}

class _ResultCard extends StatelessWidget {
  final bool won;
  final String title;
  final String? subtitle;
  final int stars;
  final List<ResultStat> stats;
  final bool newRecord;
  final Color accent;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  const _ResultCard({
    required this.won, required this.title, this.subtitle, required this.stars,
    required this.stats, required this.newRecord, required this.accent,
    required this.primaryLabel, required this.onPrimary, this.secondaryLabel, this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: min(MediaQuery.of(context).size.width - 40, 380),
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF243A63), Color(0xFF162447)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: accent.withValues(alpha: 0.5), width: 2),
          boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.25), blurRadius: 30)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(won ? '🏆' : '💪', style: const TextStyle(fontSize: 52)),
            const SizedBox(height: 6),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 15)),
            ],
            if (stars >= 0) ...[
              const SizedBox(height: 14),
              StarRow(stars: stars),
            ],
            if (newRecord) ...[
              const SizedBox(height: 10),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 900),
                curve: Curves.elasticOut,
                builder: (_, v, child) => Transform.scale(scale: v, child: child),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(color: GameColors.gold, borderRadius: BorderRadius.circular(20)),
                  child: Text(t3('🎉 NOVO RECORDE!', '🎉 NEW RECORD!', '🎉 ¡NUEVO RÉCORD!'),
                      style: const TextStyle(color: Color(0xFF3A2A00), fontWeight: FontWeight.w900)),
                ),
              ),
            ],
            if (stats.isNotEmpty) ...[
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: stats
                    .map((s) => Column(
                          children: [
                            Text(s.emoji, style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 4),
                            Text(s.value,
                                style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
                            Text(s.label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                          ],
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 22),
            PillButton(label: primaryLabel, icon: Icons.replay_rounded, onTap: onPrimary, color: accent, expand: true),
            if (secondaryLabel != null) ...[
              const SizedBox(height: 10),
              PillButton(
                label: secondaryLabel!,
                onTap: onSecondary,
                color: Colors.white70,
                filled: false,
                expand: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Três estrelas que "pulam" uma a uma.
class StarRow extends StatefulWidget {
  final int stars;
  final double size;
  final Color emptyColor; // estrela apagada (ajuste para fundos claros)
  const StarRow({super.key, required this.stars, this.size = 44, this.emptyColor = Colors.white12});

  @override
  State<StarRow> createState() => _StarRowState();
}

class _StarRowState extends State<StarRow> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..forward();
  int _played = 0;

  @override
  void initState() {
    super.initState();
    _c.addListener(() {
      final shown = (_c.value * 3.5).floor().clamp(0, widget.stars);
      if (shown > _played) {
        _played = shown;
        AudioService().playSfx('star');
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final on = i < widget.stars;
          final local = ((_c.value * 3.5) - i).clamp(0.0, 1.0);
          final scale = on ? Curves.elasticOut.transform(local) : 1.0;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: i == 1 ? 0 : 8),
            child: Transform.scale(
              scale: on ? max(scale, 0.0001) : 1.0,
              child: Icon(
                Icons.star_rounded,
                size: i == 1 ? widget.size * 1.2 : widget.size,
                color: on ? GameColors.gold : widget.emptyColor,
                shadows: on ? [const Shadow(color: Color(0x88FFC94A), blurRadius: 16)] : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Cabeçalho de jogo para telas de configuração.
class GameHero extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color accent;
  const GameHero({super.key, required this.emoji, required this.title, required this.subtitle, this.accent = GameColors.gold});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.6, end: 1),
          duration: const Duration(milliseconds: 700),
          curve: Curves.elasticOut,
          builder: (_, v, child) => Transform.scale(scale: v, child: child),
          child: Container(
            width: 92,
            height: 92,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [accent.withValues(alpha: 0.45), accent.withValues(alpha: 0.05)]),
              border: Border.all(color: accent.withValues(alpha: 0.6), width: 2),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 46)),
          ),
        ),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60, fontSize: 14)),
      ],
    );
  }
}
