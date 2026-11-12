import 'package:flutter/material.dart';

/// Aparência de um labirinto (chão, paredes e enfeites sobre as paredes).
class MazeTheme {
  final Color floor, floorDot, wallBase, wallTop;
  final List<Color> background;
  final List<String> decor; // emojis espalhados sobre algumas paredes
  const MazeTheme({
    required this.floor,
    required this.floorDot,
    required this.wallBase,
    required this.wallTop,
    required this.background,
    this.decor = const [],
  });

  static const cave = MazeTheme(
    floor: Color(0xFFC9A57A),
    floorDot: Color(0x22000000),
    wallBase: Color(0xFF4A3426),
    wallTop: Color(0xFF6E4E38),
    background: [Color(0xFF2B1D14), Color(0xFF140D08)],
  );
}

/// Fase do modo Arca de Noé: um habitat com dois pares de animais.
class ArkStage {
  final String emoji, namePt, nameEn, nameEs;
  final List<String> animals; // 2 espécies; cada uma tem um par no labirinto
  final List<String> animalsPt, animalsEn, animalsEs; // nomes no plural
  final MazeTheme theme;
  final bool dark;
  final int size; // células na altura

  const ArkStage({
    required this.emoji,
    required this.namePt,
    required this.nameEn,
    required this.nameEs,
    required this.animals,
    required this.animalsPt,
    required this.animalsEn,
    required this.animalsEs,
    required this.theme,
    required this.size,
    this.dark = false,
  });
}

const arkStages = [
  ArkStage(
    emoji: '🌲',
    namePt: 'Floresta',
    nameEn: 'Forest',
    nameEs: 'Bosque',
    animals: ['🦌', '🐿️'],
    animalsPt: ['cervos', 'esquilos'],
    animalsEn: ['deer', 'squirrels'],
    animalsEs: ['ciervos', 'ardillas'],
    size: 6,
    theme: MazeTheme(
      floor: Color(0xFFC8D89A),
      floorDot: Color(0x2233691E),
      wallBase: Color(0xFF1F4D2B),
      wallTop: Color(0xFF3F7D3A),
      background: [Color(0xFF16301C), Color(0xFF0A170D)],
      decor: ['🌲', '🌳', '🍄'],
    ),
  ),
  ArkStage(
    emoji: '🏖️',
    namePt: 'Praia',
    nameEn: 'Beach',
    nameEs: 'Playa',
    animals: ['🐢', '🦀'],
    animalsPt: ['tartarugas', 'caranguejos'],
    animalsEn: ['turtles', 'crabs'],
    animalsEs: ['tortugas', 'cangrejos'],
    size: 7,
    theme: MazeTheme(
      floor: Color(0xFFF3DFA8),
      floorDot: Color(0x22A0742A),
      wallBase: Color(0xFF1C7FA6),
      wallTop: Color(0xFF45B3D6),
      background: [Color(0xFF0E3B52), Color(0xFF071C28)],
      decor: ['🌴', '🐚', '🌊'],
    ),
  ),
  ArkStage(
    emoji: '🌾',
    namePt: 'Savana',
    nameEn: 'Savanna',
    nameEs: 'Sabana',
    animals: ['🦒', '🦁'],
    animalsPt: ['girafas', 'leões'],
    animalsEn: ['giraffes', 'lions'],
    animalsEs: ['jirafas', 'leones'],
    size: 8,
    theme: MazeTheme(
      floor: Color(0xFFEBC985),
      floorDot: Color(0x228A5A1E),
      wallBase: Color(0xFF7A5A26),
      wallTop: Color(0xFFA9823F),
      background: [Color(0xFF3A2A12), Color(0xFF1C1408)],
      decor: ['🌳', '🌾'],
    ),
  ),
  ArkStage(
    emoji: '🦇',
    namePt: 'Caverna',
    nameEn: 'Cave',
    nameEs: 'Cueva',
    animals: ['🦇', '🐻'],
    animalsPt: ['morcegos', 'ursos'],
    animalsEn: ['bats', 'bears'],
    animalsEs: ['murciélagos', 'osos'],
    size: 9,
    dark: true,
    theme: MazeTheme.cave,
  ),
  ArkStage(
    emoji: '🏔️',
    namePt: 'Montanha',
    nameEn: 'Mountain',
    nameEs: 'Montaña',
    animals: ['🐐', '🦅'],
    animalsPt: ['cabras', 'águias'],
    animalsEn: ['goats', 'eagles'],
    animalsEs: ['cabras', 'águilas'],
    size: 10,
    theme: MazeTheme(
      floor: Color(0xFFE7EEF5),
      floorDot: Color(0x225B7083),
      wallBase: Color(0xFF55657A),
      wallTop: Color(0xFF8B9BB0),
      background: [Color(0xFF243246), Color(0xFF111923)],
      decor: ['🌲', '🪨'],
    ),
  ),
];
