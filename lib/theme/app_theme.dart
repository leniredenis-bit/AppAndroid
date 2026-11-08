import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cores do app por tema.
///
/// Regras de contraste (WCAG AA): [text] ≥ 7:1 e [textMuted] ≥ 4.5:1 sobre
/// [background] e [surface]. Cartões e botões sempre têm [border] visível,
/// para nunca "sumirem" quando a cor do cartão é parecida com o fundo.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color background;
  final Color backgroundTop;
  final Color surface; // cartões
  final Color surfaceAlt; // botões neutros, chips, campos
  final Color border;
  final Color appBar; // barra superior (escura nos dois temas, com texto branco)
  final Color text;
  final Color textMuted;
  final Color accent; // azul do app, legível como texto sobre o fundo
  final Color onAccent;
  final Color primary; // preenchimento de botões principais (texto branco ≥ 4.5:1)
  final Color success;
  final Color danger;
  final Color gold; // para preenchimentos (estrelas, selos)
  final Color goldText; // dourado legível como texto
  final bool isDark;

  const AppPalette({
    required this.background,
    required this.backgroundTop,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.appBar,
    required this.text,
    required this.textMuted,
    required this.accent,
    required this.onAccent,
    required this.primary,
    required this.success,
    required this.danger,
    required this.gold,
    required this.goldText,
    required this.isDark,
  });

  static const dark = AppPalette(
    background: Color(0xFF101A2C),
    backgroundTop: Color(0xFF16233B),
    surface: Color(0xFF1B2A45),
    surfaceAlt: Color(0xFF23395D),
    border: Color(0x40FFFFFF),
    appBar: Color(0xFF162447),
    text: Color(0xFFFFFFFF),
    textMuted: Color(0xFFB8C2D6),
    accent: Color(0xFF6AA8F0),
    onAccent: Color(0xFFFFFFFF),
    primary: Color(0xFF2563EB),
    success: Color(0xFF22C55E),
    danger: Color(0xFFF87171),
    gold: Color(0xFFFFC94A),
    goldText: Color(0xFFFFD66B),
    isDark: true,
  );

  static const light = AppPalette(
    background: Color(0xFFF2F5FB),
    backgroundTop: Color(0xFFE4EBF7),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFE8EEF8),
    border: Color(0xFFB9C6DA),
    appBar: Color(0xFF162447),
    text: Color(0xFF14213D),
    textMuted: Color(0xFF475571),
    accent: Color(0xFF1D5FD1),
    onAccent: Color(0xFFFFFFFF),
    primary: Color(0xFF2563EB),
    success: Color(0xFF15803D),
    danger: Color(0xFFC62828),
    gold: Color(0xFFFFC94A),
    goldText: Color(0xFF9A6200),
    isDark: false,
  );

  /// Cor de texto legível sobre um fundo qualquer (botões coloridos etc.).
  /// Escolhe entre branco e azul-escuro o que tiver maior contraste (WCAG).
  static Color onColor(Color background) {
    const dark = Color(0xFF14213D);
    final l = background.computeLuminance();
    final withWhite = 1.05 / (l + 0.05);
    final withDark = (l + 0.05) / (dark.computeLuminance() + 0.05);
    return withWhite >= withDark ? Colors.white : dark;
  }

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      background: l(background, other.background),
      backgroundTop: l(backgroundTop, other.backgroundTop),
      surface: l(surface, other.surface),
      surfaceAlt: l(surfaceAlt, other.surfaceAlt),
      border: l(border, other.border),
      appBar: l(appBar, other.appBar),
      text: l(text, other.text),
      textMuted: l(textMuted, other.textMuted),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      primary: l(primary, other.primary),
      success: l(success, other.success),
      danger: l(danger, other.danger),
      gold: l(gold, other.gold),
      goldText: l(goldText, other.goldText),
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>() ?? AppPalette.dark;
}

/// Monta o ThemeData do app a partir da paleta.
ThemeData buildAppTheme(AppPalette p) {
  final base = ThemeData(
    useMaterial3: true,
    brightness: p.isDark ? Brightness.dark : Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4A90E2),
      brightness: p.isDark ? Brightness.dark : Brightness.light,
    ).copyWith(
      primary: p.accent,
      onPrimary: p.onAccent,
      surface: p.surface,
      onSurface: p.text,
      error: p.danger,
      outline: p.border,
    ),
    scaffoldBackgroundColor: p.background,
  );
  return base.copyWith(
    extensions: [p],
    textTheme: base.textTheme.apply(
      fontFamily: 'Roboto',
      bodyColor: p.text,
      displayColor: p.text,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: p.appBar,
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: p.surface,
      titleTextStyle: TextStyle(color: p.text, fontSize: 20, fontWeight: FontWeight.w800),
      contentTextStyle: TextStyle(color: p.textMuted, fontSize: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: p.border),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: p.isDark ? const Color(0xFF2B3E66) : const Color(0xFF14213D),
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
    dividerTheme: DividerThemeData(color: p.border),
    sliderTheme: SliderThemeData(activeTrackColor: p.accent, thumbColor: p.accent, inactiveTrackColor: p.border),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Colors.white : p.textMuted),
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? p.accent : p.surfaceAlt),
      trackOutlineColor: WidgetStatePropertyAll(p.border),
    ),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: p.accent)),
    popupMenuTheme: PopupMenuThemeData(
      color: p.surface,
      textStyle: TextStyle(color: p.text),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: p.border)),
    ),
  );
}

/// Tema escuro usado pelas telas de jogo (minigames, multiplayer, Torta na Cara),
/// que têm visual próprio escuro: garante que diálogos, botões de texto e campos
/// usem cores pensadas para fundo escuro mesmo com o app no tema claro.
final ThemeData darkGameTheme = buildAppTheme(AppPalette.dark);

/// Envolve uma tela de jogo no [darkGameTheme].
class GameDarkTheme extends StatelessWidget {
  final Widget child;
  const GameDarkTheme({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Theme(data: darkGameTheme, child: child);
}

/// Preferências visuais: tema, tamanho do texto e vibração.
class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  bool _dark = true;
  bool _largeText = false;
  bool _haptics = true;

  bool get isDark => _dark;
  bool get largeText => _largeText;
  bool get haptics => _haptics;
  double get textScale => _largeText ? 1.18 : 1.0;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _dark = prefs.getBool('darkTheme') ?? true;
    _largeText = prefs.getBool('largeText') ?? false;
    _haptics = prefs.getBool('haptics') ?? true;
  }

  Future<void> setDark(bool v) => _set('darkTheme', v, () => _dark = v);
  Future<void> setLargeText(bool v) => _set('largeText', v, () => _largeText = v);
  Future<void> setHaptics(bool v) => _set('haptics', v, () => _haptics = v);

  Future<void> _set(String key, bool value, VoidCallback apply) async {
    apply();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}

/// Vibração que respeita a preferência do usuário.
class Haptics {
  static bool get _on => ThemeService().haptics;
  static void selection() {
    if (_on) HapticFeedback.selectionClick();
  }

  static void light() {
    if (_on) HapticFeedback.lightImpact();
  }

  static void medium() {
    if (_on) HapticFeedback.mediumImpact();
  }

  static void heavy() {
    if (_on) HapticFeedback.heavyImpact();
  }
}

/// Centraliza o conteúdo com largura máxima (telas largas: web, tablet).
class MaxWidth extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const MaxWidth({super.key, required this.child, this.maxWidth = 640});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(constraints: BoxConstraints(maxWidth: maxWidth), child: child),
    );
  }
}
