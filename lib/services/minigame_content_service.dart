import 'language_service.dart';

/// Serviço centralizado para gerenciar todo o conteúdo multilíngue dos minigames
/// Contém palavras, temas e outros dados que mudam conforme o idioma
class MinigameContentService {
  static final MinigameContentService _instance = MinigameContentService._internal();
  factory MinigameContentService() => _instance;
  MinigameContentService._internal();

  final LanguageService _languageService = LanguageService();

  String get _currentLang => _languageService.currentLanguageCode;

  // ============================================================================
  // JOGO DA MEMÓRIA - Temas com nomes traduzidos
  // ============================================================================
  
  Map<String, List<Map<String, String>>> get memoryThemes {
    switch (_currentLang) {
      case 'en':
        return _memoryThemesEN;
      case 'es':
        return _memoryThemesES;
      default:
        return _memoryThemesPT;
    }
  }

  static const Map<String, List<Map<String, String>>> _memoryThemesPT = {
    'animais': [
      {'emoji': '🐶', 'name': 'Cachorro'},
      {'emoji': '🐱', 'name': 'Gato'},
      {'emoji': '🐭', 'name': 'Rato'},
      {'emoji': '🐹', 'name': 'Hamster'},
      {'emoji': '🐰', 'name': 'Coelho'},
      {'emoji': '🦊', 'name': 'Raposa'},
      {'emoji': '🐻', 'name': 'Urso'},
      {'emoji': '🐼', 'name': 'Panda'},
      {'emoji': '🐨', 'name': 'Coalá'},
      {'emoji': '🐯', 'name': 'Tigre'},
      {'emoji': '🦁', 'name': 'Leão'},
      {'emoji': '🐮', 'name': 'Vaca'},
      {'emoji': '🐷', 'name': 'Porco'},
      {'emoji': '🐸', 'name': 'Sapo'},
      {'emoji': '🐵', 'name': 'Macaco'},
    ],
    'frutas': [
      {'emoji': '🍎', 'name': 'Maçã'},
      {'emoji': '🍌', 'name': 'Banana'},
      {'emoji': '🍇', 'name': 'Uva'},
      {'emoji': '🍓', 'name': 'Morango'},
      {'emoji': '🍈', 'name': 'Melão'},
      {'emoji': '🍒', 'name': 'Cereja'},
      {'emoji': '🍑', 'name': 'Pêssego'},
      {'emoji': '🥝', 'name': 'Kiwi'},
      {'emoji': '🥭', 'name': 'Manga'},
      {'emoji': '🥥', 'name': 'Coco'},
      {'emoji': '🍉', 'name': 'Melancia'},
      {'emoji': '🍊', 'name': 'Laranja'},
      {'emoji': '🍋', 'name': 'Limão'},
      {'emoji': '🍐', 'name': 'Pêra'},
      {'emoji': '🍍', 'name': 'Abacaxi'},
    ],
    'transportes': [
      {'emoji': '🚗', 'name': 'Carro'},
      {'emoji': '🚕', 'name': 'Táxi'},
      {'emoji': '🚌', 'name': 'Ônibus'},
      {'emoji': '🚑', 'name': 'Ambulância'},
      {'emoji': '🚓', 'name': 'Polícia'},
      {'emoji': '🚚', 'name': 'Caminhão'},
      {'emoji': '🚜', 'name': 'Trator'},
      {'emoji': '🚲', 'name': 'Bicicleta'},
      {'emoji': '🏍️', 'name': 'Moto'},
      {'emoji': '✈️', 'name': 'Avião'},
      {'emoji': '🚀', 'name': 'Foguete'},
      {'emoji': '⛵', 'name': 'Barco'},
      {'emoji': '🚢', 'name': 'Navio'},
      {'emoji': '🚂', 'name': 'Trem'},
      {'emoji': '🚁', 'name': 'Helicóptero'},
    ],
    'vida_marinha': [
      {'emoji': '🐟', 'name': 'Peixe'},
      {'emoji': '🐠', 'name': 'Peixe Tropical'},
      {'emoji': '🐡', 'name': 'Baiacu'},
      {'emoji': '🦈', 'name': 'Tubarão'},
      {'emoji': '🐙', 'name': 'Polvo'},
      {'emoji': '🦑', 'name': 'Lula'},
      {'emoji': '🦞', 'name': 'Lagosta'},
      {'emoji': '🦀', 'name': 'Caranguejo'},
      {'emoji': '🐚', 'name': 'Concha'},
      {'emoji': '🐋', 'name': 'Baleia'},
      {'emoji': '🐳', 'name': 'Orca'},
      {'emoji': '🦭', 'name': 'Foca'},
      {'emoji': '🐢', 'name': 'Tartaruga'},
      {'emoji': '🐊', 'name': 'Crocodilo'},
      {'emoji': '🦎', 'name': 'Lagarto'},
    ],
    'aves': [
      {'emoji': '🐦', 'name': 'Pássaro'},
      {'emoji': '🦅', 'name': 'Águia'},
      {'emoji': '🦉', 'name': 'Coruja'},
      {'emoji': '🦆', 'name': 'Pato'},
      {'emoji': '🦜', 'name': 'Papagaio'},
      {'emoji': '🐔', 'name': 'Galinha'},
      {'emoji': '🐧', 'name': 'Pinguim'},
      {'emoji': '🦚', 'name': 'Pavão'},
      {'emoji': '🦢', 'name': 'Cisne'},
      {'emoji': '🦃', 'name': 'Peru'},
      {'emoji': '🐓', 'name': 'Galo'},
      {'emoji': '🦇', 'name': 'Morcego'},
      {'emoji': '🦤', 'name': 'Dodô'},
      {'emoji': '🦩', 'name': 'Flamingo'},
      {'emoji': '🕊️', 'name': 'Pombo'},
    ],
    'numeros': [
      {'emoji': '1️⃣', 'name': 'Um'},
      {'emoji': '2️⃣', 'name': 'Dois'},
      {'emoji': '3️⃣', 'name': 'Três'},
      {'emoji': '4️⃣', 'name': 'Quatro'},
      {'emoji': '5️⃣', 'name': 'Cinco'},
      {'emoji': '6️⃣', 'name': 'Seis'},
      {'emoji': '7️⃣', 'name': 'Sete'},
      {'emoji': '8️⃣', 'name': 'Oito'},
      {'emoji': '9️⃣', 'name': 'Nove'},
      {'emoji': '🔟', 'name': 'Dez'},
      {'emoji': '0️⃣', 'name': 'Zero'},
      {'emoji': '➕', 'name': 'Mais'},
      {'emoji': '➖', 'name': 'Menos'},
      {'emoji': '✖️', 'name': 'Vezes'},
      {'emoji': '➗', 'name': 'Dividir'},
    ],
    'objetos': [
      {'emoji': '📱', 'name': 'Celular'},
      {'emoji': '💻', 'name': 'Computador'},
      {'emoji': '⌚', 'name': 'Relógio'},
      {'emoji': '📷', 'name': 'Câmera'},
      {'emoji': '📹', 'name': 'Vídeo'},
      {'emoji': '📺', 'name': 'TV'},
      {'emoji': '📻', 'name': 'Rádio'},
      {'emoji': '💡', 'name': 'Lâmpada'},
      {'emoji': '🔋', 'name': 'Bateria'},
      {'emoji': '🔌', 'name': 'Tomada'},
      {'emoji': '🧰', 'name': 'Ferramentas'},
      {'emoji': '🔧', 'name': 'Chave'},
      {'emoji': '🔨', 'name': 'Martelo'},
      {'emoji': '✂️', 'name': 'Tesoura'},
      {'emoji': '🔒', 'name': 'Cadeado'},
    ],
    'natureza': [
      {'emoji': '🌸', 'name': 'Cerejeira'},
      {'emoji': '🌺', 'name': 'Flor'},
      {'emoji': '🌻', 'name': 'Girassol'},
      {'emoji': '🌼', 'name': 'Margarida'},
      {'emoji': '🌹', 'name': 'Rosa'},
      {'emoji': '🍃', 'name': 'Folha'},
      {'emoji': '☘️', 'name': 'Trevo'},
      {'emoji': '🌳', 'name': 'Árvore'},
      {'emoji': '🌲', 'name': 'Pinheiro'},
      {'emoji': '🌴', 'name': 'Palmeira'},
      {'emoji': '🌵', 'name': 'Cacto'},
      {'emoji': '🌱', 'name': 'Broto'},
      {'emoji': '🍄', 'name': 'Cogumelo'},
      {'emoji': '🌙', 'name': 'Lua'},
      {'emoji': '☀️', 'name': 'Sol'},
    ],
  };

  static const Map<String, List<Map<String, String>>> _memoryThemesEN = {
    'animais': [
      {'emoji': '🐶', 'name': 'Dog'},
      {'emoji': '🐱', 'name': 'Cat'},
      {'emoji': '🐭', 'name': 'Mouse'},
      {'emoji': '🐹', 'name': 'Hamster'},
      {'emoji': '🐰', 'name': 'Rabbit'},
      {'emoji': '🦊', 'name': 'Fox'},
      {'emoji': '🐻', 'name': 'Bear'},
      {'emoji': '🐼', 'name': 'Panda'},
      {'emoji': '🐨', 'name': 'Koala'},
      {'emoji': '🐯', 'name': 'Tiger'},
      {'emoji': '🦁', 'name': 'Lion'},
      {'emoji': '🐮', 'name': 'Cow'},
      {'emoji': '🐷', 'name': 'Pig'},
      {'emoji': '🐸', 'name': 'Frog'},
      {'emoji': '🐵', 'name': 'Monkey'},
    ],
    'frutas': [
      {'emoji': '🍎', 'name': 'Apple'},
      {'emoji': '🍌', 'name': 'Banana'},
      {'emoji': '🍇', 'name': 'Grape'},
      {'emoji': '🍓', 'name': 'Strawberry'},
      {'emoji': '🍈', 'name': 'Melon'},
      {'emoji': '🍒', 'name': 'Cherry'},
      {'emoji': '🍑', 'name': 'Peach'},
      {'emoji': '🥝', 'name': 'Kiwi'},
      {'emoji': '🥭', 'name': 'Mango'},
      {'emoji': '🥥', 'name': 'Coconut'},
      {'emoji': '🍉', 'name': 'Watermelon'},
      {'emoji': '🍊', 'name': 'Orange'},
      {'emoji': '🍋', 'name': 'Lemon'},
      {'emoji': '🍐', 'name': 'Pear'},
      {'emoji': '🍍', 'name': 'Pineapple'},
    ],
    'transportes': [
      {'emoji': '🚗', 'name': 'Car'},
      {'emoji': '🚕', 'name': 'Taxi'},
      {'emoji': '🚌', 'name': 'Bus'},
      {'emoji': '🚑', 'name': 'Ambulance'},
      {'emoji': '🚓', 'name': 'Police'},
      {'emoji': '🚚', 'name': 'Truck'},
      {'emoji': '🚜', 'name': 'Tractor'},
      {'emoji': '🚲', 'name': 'Bicycle'},
      {'emoji': '🏍️', 'name': 'Motorcycle'},
      {'emoji': '✈️', 'name': 'Airplane'},
      {'emoji': '🚀', 'name': 'Rocket'},
      {'emoji': '⛵', 'name': 'Boat'},
      {'emoji': '🚢', 'name': 'Ship'},
      {'emoji': '🚂', 'name': 'Train'},
      {'emoji': '🚁', 'name': 'Helicopter'},
    ],
    'vida_marinha': [
      {'emoji': '🐟', 'name': 'Fish'},
      {'emoji': '🐠', 'name': 'Tropical Fish'},
      {'emoji': '🐡', 'name': 'Pufferfish'},
      {'emoji': '🦈', 'name': 'Shark'},
      {'emoji': '🐙', 'name': 'Octopus'},
      {'emoji': '🦑', 'name': 'Squid'},
      {'emoji': '🦞', 'name': 'Lobster'},
      {'emoji': '🦀', 'name': 'Crab'},
      {'emoji': '🐚', 'name': 'Shell'},
      {'emoji': '🐋', 'name': 'Whale'},
      {'emoji': '🐳', 'name': 'Orca'},
      {'emoji': '🦭', 'name': 'Seal'},
      {'emoji': '🐢', 'name': 'Turtle'},
      {'emoji': '🐊', 'name': 'Crocodile'},
      {'emoji': '🦎', 'name': 'Lizard'},
    ],
    'aves': [
      {'emoji': '🐦', 'name': 'Bird'},
      {'emoji': '🦅', 'name': 'Eagle'},
      {'emoji': '🦉', 'name': 'Owl'},
      {'emoji': '🦆', 'name': 'Duck'},
      {'emoji': '🦜', 'name': 'Parrot'},
      {'emoji': '🐔', 'name': 'Chicken'},
      {'emoji': '🐧', 'name': 'Penguin'},
      {'emoji': '🦚', 'name': 'Peacock'},
      {'emoji': '🦢', 'name': 'Swan'},
      {'emoji': '🦃', 'name': 'Turkey'},
      {'emoji': '🐓', 'name': 'Rooster'},
      {'emoji': '🦇', 'name': 'Bat'},
      {'emoji': '🦤', 'name': 'Dodo'},
      {'emoji': '🦩', 'name': 'Flamingo'},
      {'emoji': '🕊️', 'name': 'Dove'},
    ],
    'numeros': [
      {'emoji': '1️⃣', 'name': 'One'},
      {'emoji': '2️⃣', 'name': 'Two'},
      {'emoji': '3️⃣', 'name': 'Three'},
      {'emoji': '4️⃣', 'name': 'Four'},
      {'emoji': '5️⃣', 'name': 'Five'},
      {'emoji': '6️⃣', 'name': 'Six'},
      {'emoji': '7️⃣', 'name': 'Seven'},
      {'emoji': '8️⃣', 'name': 'Eight'},
      {'emoji': '9️⃣', 'name': 'Nine'},
      {'emoji': '🔟', 'name': 'Ten'},
      {'emoji': '0️⃣', 'name': 'Zero'},
      {'emoji': '➕', 'name': 'Plus'},
      {'emoji': '➖', 'name': 'Minus'},
      {'emoji': '✖️', 'name': 'Times'},
      {'emoji': '➗', 'name': 'Divide'},
    ],
    'objetos': [
      {'emoji': '📱', 'name': 'Phone'},
      {'emoji': '💻', 'name': 'Computer'},
      {'emoji': '⌚', 'name': 'Watch'},
      {'emoji': '📷', 'name': 'Camera'},
      {'emoji': '📹', 'name': 'Video'},
      {'emoji': '📺', 'name': 'TV'},
      {'emoji': '📻', 'name': 'Radio'},
      {'emoji': '💡', 'name': 'Bulb'},
      {'emoji': '🔋', 'name': 'Battery'},
      {'emoji': '🔌', 'name': 'Plug'},
      {'emoji': '🧰', 'name': 'Tools'},
      {'emoji': '🔧', 'name': 'Wrench'},
      {'emoji': '🔨', 'name': 'Hammer'},
      {'emoji': '✂️', 'name': 'Scissors'},
      {'emoji': '🔒', 'name': 'Lock'},
    ],
    'natureza': [
      {'emoji': '🌸', 'name': 'Blossom'},
      {'emoji': '🌺', 'name': 'Flower'},
      {'emoji': '🌻', 'name': 'Sunflower'},
      {'emoji': '🌼', 'name': 'Daisy'},
      {'emoji': '🌹', 'name': 'Rose'},
      {'emoji': '🍃', 'name': 'Leaf'},
      {'emoji': '☘️', 'name': 'Clover'},
      {'emoji': '🌳', 'name': 'Tree'},
      {'emoji': '🌲', 'name': 'Pine'},
      {'emoji': '🌴', 'name': 'Palm'},
      {'emoji': '🌵', 'name': 'Cactus'},
      {'emoji': '🌱', 'name': 'Sprout'},
      {'emoji': '🍄', 'name': 'Mushroom'},
      {'emoji': '🌙', 'name': 'Moon'},
      {'emoji': '☀️', 'name': 'Sun'},
    ],
  };

  static const Map<String, List<Map<String, String>>> _memoryThemesES = {
    'animais': [
      {'emoji': '🐶', 'name': 'Perro'},
      {'emoji': '🐱', 'name': 'Gato'},
      {'emoji': '🐭', 'name': 'Ratón'},
      {'emoji': '🐹', 'name': 'Hámster'},
      {'emoji': '🐰', 'name': 'Conejo'},
      {'emoji': '🦊', 'name': 'Zorro'},
      {'emoji': '🐻', 'name': 'Oso'},
      {'emoji': '🐼', 'name': 'Panda'},
      {'emoji': '🐨', 'name': 'Koala'},
      {'emoji': '🐯', 'name': 'Tigre'},
      {'emoji': '🦁', 'name': 'León'},
      {'emoji': '🐮', 'name': 'Vaca'},
      {'emoji': '🐷', 'name': 'Cerdo'},
      {'emoji': '🐸', 'name': 'Rana'},
      {'emoji': '🐵', 'name': 'Mono'},
    ],
    'frutas': [
      {'emoji': '🍎', 'name': 'Manzana'},
      {'emoji': '🍌', 'name': 'Plátano'},
      {'emoji': '🍇', 'name': 'Uva'},
      {'emoji': '🍓', 'name': 'Fresa'},
      {'emoji': '🍈', 'name': 'Melón'},
      {'emoji': '🍒', 'name': 'Cereza'},
      {'emoji': '🍑', 'name': 'Durazno'},
      {'emoji': '🥝', 'name': 'Kiwi'},
      {'emoji': '🥭', 'name': 'Mango'},
      {'emoji': '🥥', 'name': 'Coco'},
      {'emoji': '🍉', 'name': 'Sandía'},
      {'emoji': '🍊', 'name': 'Naranja'},
      {'emoji': '🍋', 'name': 'Limón'},
      {'emoji': '🍐', 'name': 'Pera'},
      {'emoji': '🍍', 'name': 'Piña'},
    ],
    'transportes': [
      {'emoji': '🚗', 'name': 'Coche'},
      {'emoji': '🚕', 'name': 'Taxi'},
      {'emoji': '🚌', 'name': 'Autobús'},
      {'emoji': '🚑', 'name': 'Ambulancia'},
      {'emoji': '🚓', 'name': 'Policía'},
      {'emoji': '🚚', 'name': 'Camión'},
      {'emoji': '🚜', 'name': 'Tractor'},
      {'emoji': '🚲', 'name': 'Bicicleta'},
      {'emoji': '🏍️', 'name': 'Moto'},
      {'emoji': '✈️', 'name': 'Avión'},
      {'emoji': '🚀', 'name': 'Cohete'},
      {'emoji': '⛵', 'name': 'Barco'},
      {'emoji': '🚢', 'name': 'Buque'},
      {'emoji': '🚂', 'name': 'Tren'},
      {'emoji': '🚁', 'name': 'Helicóptero'},
    ],
    'vida_marinha': [
      {'emoji': '🐟', 'name': 'Pez'},
      {'emoji': '🐠', 'name': 'Pez Tropical'},
      {'emoji': '🐡', 'name': 'Pez Globo'},
      {'emoji': '🦈', 'name': 'Tiburón'},
      {'emoji': '🐙', 'name': 'Pulpo'},
      {'emoji': '🦑', 'name': 'Calamar'},
      {'emoji': '🦞', 'name': 'Langosta'},
      {'emoji': '🦀', 'name': 'Cangrejo'},
      {'emoji': '🐚', 'name': 'Concha'},
      {'emoji': '🐋', 'name': 'Ballena'},
      {'emoji': '🐳', 'name': 'Orca'},
      {'emoji': '🦭', 'name': 'Foca'},
      {'emoji': '🐢', 'name': 'Tortuga'},
      {'emoji': '🐊', 'name': 'Cocodrilo'},
      {'emoji': '🦎', 'name': 'Lagarto'},
    ],
    'aves': [
      {'emoji': '🐦', 'name': 'Pájaro'},
      {'emoji': '🦅', 'name': 'Águila'},
      {'emoji': '🦉', 'name': 'Búho'},
      {'emoji': '🦆', 'name': 'Pato'},
      {'emoji': '🦜', 'name': 'Loro'},
      {'emoji': '🐔', 'name': 'Gallina'},
      {'emoji': '🐧', 'name': 'Pingüino'},
      {'emoji': '🦚', 'name': 'Pavo Real'},
      {'emoji': '🦢', 'name': 'Cisne'},
      {'emoji': '🦃', 'name': 'Pavo'},
      {'emoji': '🐓', 'name': 'Gallo'},
      {'emoji': '🦇', 'name': 'Murciélago'},
      {'emoji': '🦤', 'name': 'Dodo'},
      {'emoji': '🦩', 'name': 'Flamenco'},
      {'emoji': '🕊️', 'name': 'Paloma'},
    ],
    'numeros': [
      {'emoji': '1️⃣', 'name': 'Uno'},
      {'emoji': '2️⃣', 'name': 'Dos'},
      {'emoji': '3️⃣', 'name': 'Tres'},
      {'emoji': '4️⃣', 'name': 'Cuatro'},
      {'emoji': '5️⃣', 'name': 'Cinco'},
      {'emoji': '6️⃣', 'name': 'Seis'},
      {'emoji': '7️⃣', 'name': 'Siete'},
      {'emoji': '8️⃣', 'name': 'Ocho'},
      {'emoji': '9️⃣', 'name': 'Nueve'},
      {'emoji': '🔟', 'name': 'Diez'},
      {'emoji': '0️⃣', 'name': 'Cero'},
      {'emoji': '➕', 'name': 'Más'},
      {'emoji': '➖', 'name': 'Menos'},
      {'emoji': '✖️', 'name': 'Por'},
      {'emoji': '➗', 'name': 'Dividir'},
    ],
    'objetos': [
      {'emoji': '📱', 'name': 'Celular'},
      {'emoji': '💻', 'name': 'Computadora'},
      {'emoji': '⌚', 'name': 'Reloj'},
      {'emoji': '📷', 'name': 'Cámara'},
      {'emoji': '📹', 'name': 'Video'},
      {'emoji': '📺', 'name': 'TV'},
      {'emoji': '📻', 'name': 'Radio'},
      {'emoji': '💡', 'name': 'Bombilla'},
      {'emoji': '🔋', 'name': 'Batería'},
      {'emoji': '🔌', 'name': 'Enchufe'},
      {'emoji': '🧰', 'name': 'Herramientas'},
      {'emoji': '🔧', 'name': 'Llave'},
      {'emoji': '🔨', 'name': 'Martillo'},
      {'emoji': '✂️', 'name': 'Tijeras'},
      {'emoji': '🔒', 'name': 'Candado'},
    ],
    'natureza': [
      {'emoji': '🌸', 'name': 'Cerezo'},
      {'emoji': '🌺', 'name': 'Flor'},
      {'emoji': '🌻', 'name': 'Girasol'},
      {'emoji': '🌼', 'name': 'Margarita'},
      {'emoji': '🌹', 'name': 'Rosa'},
      {'emoji': '🍃', 'name': 'Hoja'},
      {'emoji': '☘️', 'name': 'Trébol'},
      {'emoji': '🌳', 'name': 'Árbol'},
      {'emoji': '🌲', 'name': 'Pino'},
      {'emoji': '🌴', 'name': 'Palmera'},
      {'emoji': '🌵', 'name': 'Cactus'},
      {'emoji': '🌱', 'name': 'Brote'},
      {'emoji': '🍄', 'name': 'Hongo'},
      {'emoji': '🌙', 'name': 'Luna'},
      {'emoji': '☀️', 'name': 'Sol'},
    ],
  };

  // ============================================================================
  // CAÇA-PALAVRAS - Palavras bíblicas por idioma
  // ============================================================================

  List<String> get wordSearchWords {
    switch (_currentLang) {
      case 'en':
        return _wordSearchWordsEN;
      case 'es':
        return _wordSearchWordsES;
      default:
        return _wordSearchWordsPT;
    }
  }

  static const List<String> _wordSearchWordsPT = [
    // Personagens do Antigo Testamento
    'ABRAAO', 'MOISÉS', 'ISAQUE', 'JACÓ', 'JOSE', 'SAMUEL', 
    'DAVI', 'SALOMAO', 'ELIAS', 'ELISEU', 'ISAIAS', 'DANIEL',
    'NOÉ', 'ADAO', 'EVA', 'CAIM', 'ABEL', 'ENOQUE', 'JOSUÉ',
    
    // Personagens do Novo Testamento
    'JESUS', 'MARIA', 'PEDRO', 'PAULO', 'JOÃO', 
    'TIAGO', 'ANDRÉ', 'FILIPE', 'MATEUS', 'LUCAS', 'MARCOS',
    'BARNABÉ', 'SILAS', 'TIMÓTEO', 'TITO',
    
    // Lugares
    'BELÉM', 'NAZARÉ', 'JERUSALÉM', 'GALILEIA', 'EGITO', 
    'SINAI', 'JORDAN', 'CANAÃ', 'BABEL', 'NÍNIVE',
    
    // Conceitos e virtudes
    'AMOR', 'FÉ', 'PAZ', 'VIDA', 'LUZ', 'REINO', 'GRAÇA',
    'PERDÃO', 'VERDADE', 'CAMINHO', 'PODER', 'GLORIA',
    'ALEGRIA', 'ESPERANÇA', 'BONDADE', 'JUSTIÇA',
    
    // Objetos e símbolos
    'ARCA', 'ESTACA', 'PÃO', 'VINHO', 'ÓLEO', 'PEDRA',
    'TABUA', 'ALTAR', 'TEMPLO', 'CORDEIRO', 'POMBA',
    
    // Livros da Bíblia
    'GENESIS', 'ÊXODO', 'SALMOS', 'JOAO', 'ATOS',
    
    // Outros
    'DEUS', 'BIBLIA', 'SALVAÇÃO', 'ALIANÇA', 'PROFETA',
    'APOSTOLO', 'DISCIPULO', 'MILAGRE', 'ORAÇÃO', 'ANJO'
  ];

  static const List<String> _wordSearchWordsEN = [
    // Old Testament Characters
    'ABRAHAM', 'MOSES', 'ISAAC', 'JACOB', 'JOSEPH', 'SAMUEL', 
    'DAVID', 'SOLOMON', 'ELIJAH', 'ELISHA', 'ISAIAH', 'DANIEL',
    'NOAH', 'ADAM', 'EVE', 'CAIN', 'ABEL', 'ENOCH', 'JOSHUA',
    
    // New Testament Characters
    'JESUS', 'MARY', 'PETER', 'PAUL', 'JOHN', 
    'JAMES', 'ANDREW', 'PHILIP', 'MATTHEW', 'LUKE', 'MARK',
    'BARNABAS', 'SILAS', 'TIMOTHY', 'TITUS',
    
    // Places
    'BETHLEHEM', 'NAZARETH', 'JERUSALEM', 'GALILEE', 'EGYPT', 
    'SINAI', 'JORDAN', 'CANAAN', 'BABEL', 'NINEVEH',
    
    // Concepts and Virtues
    'LOVE', 'FAITH', 'PEACE', 'LIFE', 'LIGHT', 'KINGDOM', 'GRACE',
    'FORGIVENESS', 'TRUTH', 'WAY', 'POWER', 'GLORY',
    'JOY', 'HOPE', 'GOODNESS', 'JUSTICE',
    
    // Objects and Symbols
    'ARK', 'STAKE', 'BREAD', 'WINE', 'OIL', 'STONE',
    'TABLET', 'ALTAR', 'TEMPLE', 'LAMB', 'DOVE',
    
    // Bible Books
    'GENESIS', 'EXODUS', 'PSALMS', 'ACTS',
    
    // Others
    'GOD', 'BIBLE', 'SALVATION', 'COVENANT', 'PROPHET',
    'APOSTLE', 'DISCIPLE', 'MIRACLE', 'PRAYER', 'ANGEL'
  ];

  static const List<String> _wordSearchWordsES = [
    // Personajes del Antiguo Testamento
    'ABRAHAM', 'MOISÉS', 'ISAAC', 'JACOB', 'JOSÉ', 'SAMUEL', 
    'DAVID', 'SALOMÓN', 'ELÍAS', 'ELISEO', 'ISAÍAS', 'DANIEL',
    'NOÉ', 'ADÁN', 'EVA', 'CAÍN', 'ABEL', 'ENOC', 'JOSUÉ',
    
    // Personajes del Nuevo Testamento
    'JESÚS', 'MARÍA', 'PEDRO', 'PABLO', 'JUAN', 
    'SANTIAGO', 'ANDRÉS', 'FELIPE', 'MATEO', 'LUCAS', 'MARCOS',
    'BERNABÉ', 'SILAS', 'TIMOTEO', 'TITO',
    
    // Lugares
    'BELÉN', 'NAZARET', 'JERUSALÉN', 'GALILEA', 'EGIPTO', 
    'SINAÍ', 'JORDÁN', 'CANAÁN', 'BABEL', 'NÍNIVE',
    
    // Conceptos y Virtudes
    'AMOR', 'FE', 'PAZ', 'VIDA', 'LUZ', 'REINO', 'GRACIA',
    'PERDÓN', 'VERDAD', 'CAMINO', 'PODER', 'GLORIA',
    'ALEGRÍA', 'ESPERANZA', 'BONDAD', 'JUSTICIA',
    
    // Objetos y Símbolos
    'ARCA', 'ESTACA', 'PAN', 'VINO', 'ACEITE', 'PIEDRA',
    'TABLA', 'ALTAR', 'TEMPLO', 'CORDERO', 'PALOMA',
    
    // Libros de la Biblia
    'GÉNESIS', 'ÉXODO', 'SALMOS', 'HECHOS',
    
    // Otros
    'DIOS', 'BIBLIA', 'SALVACIÓN', 'ALIANZA', 'PROFETA',
    'APÓSTOL', 'DISCÍPULO', 'MILAGRO', 'ORACIÓN', 'ÁNGEL'
  ];

  // ============================================================================
  // FORCA (HANGMAN) - Palavras bíblicas por idioma
  // ============================================================================

  List<String> get hangmanWords {
    switch (_currentLang) {
      case 'en':
        return _hangmanWordsEN;
      case 'es':
        return _hangmanWordsES;
      default:
        return _hangmanWordsPT;
    }
  }

  static const List<String> _hangmanWordsPT = [
    "MOISES", "DANIEL", "JESUS", "RUTE", "ESTER", "ISAIAS",
    "AMOR", "FE", "SALMO", "JOSE", "PAZ", "ABRAAO", "ORACAO",
    "DAVI", "MARIA", "PEDRO", "PAULO", "JOAO", "ATOS", "GENESIS"
  ];

  static const List<String> _hangmanWordsEN = [
    "MOSES", "DANIEL", "JESUS", "RUTH", "ESTHER", "ISAIAH",
    "LOVE", "FAITH", "PSALM", "JOSEPH", "PEACE", "ABRAHAM", "PRAYER",
    "DAVID", "MARY", "PETER", "PAUL", "JOHN", "ACTS", "GENESIS"
  ];

  static const List<String> _hangmanWordsES = [
    "MOISÉS", "DANIEL", "JESÚS", "RUT", "ESTER", "ISAÍAS",
    "AMOR", "FE", "SALMO", "JOSÉ", "PAZ", "ABRAHAM", "ORACIÓN",
    "DAVID", "MARÍA", "PEDRO", "PABLO", "JUAN", "HECHOS", "GÉNESIS"
  ];
}
