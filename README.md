# 🎮 JW SPLASH GAMES

> Jogo educativo bíblico interativo desenvolvido em Flutter com quiz, 7 minigames divertidos, sistema de conquistas e suporte multilíngue!

![Flutter](https://img.shields.io/badge/Flutter-3.35.3-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)

## 🎯 Sobre o Projeto

**JW SPLASH GAMES** é um aplicativo educativo que combina aprendizado bíblico com diversão! O app oferece quiz interativo, 7 minigames únicos, sistema completo de conquistas e estatísticas, tudo em uma interface moderna e colorida. Principais recursos:

- 🧠 **Quiz Clássico** com sistema de pontuação e timer dinâmico
- 🎮 **7 Minigames** educativos (Quebra-cabeça, Forca, Memória, Labirinto, etc.)
- 🏆 **15 Conquistas** desbloqueáveis com animações especiais
- 📊 **Sistema de Estatísticas** completo com histórico e streaks
- 🌍 **3 Idiomas** (Português, English, Español)
- 🎵 **Músicas de fundo** e efeitos sonoros imersivos
- 🎨 **Interface moderna** com animações fluidas

---

## ✨ Funcionalidades Principais

### 📚 Quiz Clássico
- **Banco de perguntas** extenso com referências bíblicas
- **Filtros** por dificuldade (Fácil, Médio, Difícil) e categorias (Gênesis, Êxodo, Profetas, etc.)
- **Timer dinâmico** que se ajusta ao tamanho da pergunta
- **Sistema de pontuação** com bônus por tempo
- **Feedback visual** imediato (verde = correto, vermelho = errado)
- **Salvamento automático** de resultados e histórico

### 🎮 7 Minigames Divertidos

1. **🧩 Quebra-Cabeça**
   - Puzzle deslizante 3x3 (8 peças)
   - Embaralhamento válido garantido
   - Sistema de pontuação baseado em movimentos

2. **🔤 Forca**
   - 20+ palavras bíblicas
   - Teclado A-Z interativo
   - Visual do boneco progressivo

3. **🔍 Caça-Palavras**
   - Grade 12x12 com 10 palavras bíblicas
   - Seleção por arrastar
   - Múltiplas direções (horizontal, vertical, diagonal)

4. **🌀 Labirinto**
   - Navegação com controles ou teclado
   - Grade 20x20 desafiadora
   - Contador de movimentos com pontuação

5. **🎵 Sequência** (Simon Says)
   - Memorize padrões de cores
   - 20 níveis progressivos
   - Tracking de recorde pessoal

6. **⭕ Jogo da Velha**
   - 2 jogadores ou vs IA
   - IA com algoritmo Minimax (impossível de vencer!)
   - Sistema de pontuação persistente

7. **🧠 Jogo da Memória**
   - Pares de cartas com temas bíblicos
   - Animações de flip suaves
   - Timer e sistema de estrelas

### 🏆 Sistema de Conquistas

**15 conquistas desbloqueáveis** em 4 categorias:

**Quiz (6 conquistas)**
- 🎓 Primeiro Passo: Complete seu primeiro quiz
- 📚 Estudioso: Complete 10 quizzes
- 💯 Perfeccionista: Acerte todas as perguntas de um quiz
- ⚡ Velocista: Complete um quiz em menos de 2 minutos
- 🔥 Sequência Perfeita: Mantenha 5 quizzes seguidos com 80%+ de acerto
- 📖 Mestre Bíblico: Complete 50 quizzes

**Minigames (5 conquistas)**
- 🎮 Explorador: Jogue todos os 7 minigames
- 🧩 Mestre dos Puzzles: Complete o quebra-cabeça em menos de 2 minutos
- 🧠 Memória Fotográfica: Complete o jogo da memória sem erros
- 🎯 Atirador de Elite: Vença 10 partidas no jogo da velha
- 🏆 Campeão dos Minigames: Vença 50 partidas em minigames

**Social (2 conquistas)**
- 👥 Social: Participe de uma partida multiplayer
- 🌟 Competidor: Fique no pódio em uma partida multiplayer

**Master (2 conquistas)**
- 💎 Colecionador: Desbloqueie 10 conquistas
- 👑 Lenda: Desbloqueie todas as 15 conquistas

**Recursos:**
- Diálogo animado de desbloqueio com confetti
- Progresso visual em cada conquista
- Filtros por categoria na tela de conquistas
- Persistência automática de progresso

### 📊 Sistema de Estatísticas e Persistência

**GlobalStats:**
- Total de quizzes realizados
- Taxa de acerto geral e por dificuldade
- Pontuação mais alta (high score)
- Streak atual e recorde de sequência
- Desempenho por categoria bíblica

**Histórico Completo:**
- Últimos 50 quizzes salvos com detalhes
- Timestamp, modo, pontuação, acurácia
- Tempo gasto e perguntas respondidas
- Filtros e busca no histórico

**Recordes de Minigames:**
- High score individual por jogo
- Total de partidas jogadas e vencidas
- Taxa de vitória (win rate)
- Melhor tempo registrado

### 🌍 Internacionalização

**3 idiomas suportados:**
- 🇧🇷 Português (Brasil)
- 🇺🇸 English (United States)
- 🇪🇸 Español (España)

**Recursos:**
- 180+ strings traduzidas por idioma
- Troca de idioma sem restart do app
- Seletor visual com bandeiras
- Preferência salva localmente

### 🎵 Sistema de Áudio
- **Músicas de fundo** aleatórias por tela (Home, Quiz, Memory Game, etc.)
- **Efeitos sonoros** para interações (acertos, erros, cliques, vitórias)
- **Controles de volume** e liga/desliga global

---

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK 3.35.3 ou superior
- Dart SDK 3.x
- Editor de código (VS Code, Android Studio, etc.)

### Instalação

1. **Clone o repositório**
```bash
git clone https://github.com/leniredenis-bit/JWQuizFlutter.git
cd jw_quiz_flutter
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute o app**
```bash
flutter run
```

---

## 📦 Dependências Principais

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.3.3  # Persistência local
  google_fonts: ^6.3.2        # Fontes personalizadas
  audioplayers: ^6.5.1        # Sistema de áudio
  uuid: ^4.5.1                # Geração de IDs únicos
  flutter_localizations:
    sdk: flutter              # Suporte a i18n
```

---

## 🏗️ Arquitetura do Projeto

```
lib/
├── main.dart                    # Entry point
├── models/                      # Modelos de dados
│   ├── achievement.dart         # 15 conquistas
│   ├── stats_data.dart          # GlobalStats, QuizHistory, etc.
│   ├── question.dart            # Modelo de pergunta
│   └── quiz_service.dart        # Serviço de quiz
├── screens/                     # Telas do app
│   ├── home_screen.dart         # Tela inicial
│   ├── quiz_screen.dart         # Quiz clássico
│   ├── achievements_screen.dart # Lista de conquistas
│   ├── stats_screen.dart        # Estatísticas detalhadas
│   └── minigames/               # 7 minigames
│       ├── puzzle_game.dart
│       ├── hangman_game.dart
│       ├── word_search_game.dart
│       ├── maze_game.dart
│       ├── sequence_game.dart
│       ├── tic_tac_toe_game.dart
│       └── memory_game.dart
├── services/                    # Serviços singleton
│   ├── storage_service.dart     # Persistência centralizada
│   ├── achievement_service.dart # Gerenciamento de conquistas
│   ├── language_service.dart    # Internacionalização
│   └── audio_service.dart       # Sistema de áudio
├── widgets/                     # Widgets reutilizáveis
│   ├── achievement_unlock_dialog.dart
│   ├── settings_dialog.dart
│   └── emoji_text.dart
└── l10n/                        # Arquivos de tradução
    ├── app_pt.arb               # Português
    ├── app_en.arb               # English
    └── app_es.arb               # Español
```

---

## 🎨 Paleta de Cores

```dart
Color(0xFF101A2C)  // Background escuro
Color(0xFF162447)  // Cards e AppBar
Color(0xFF1F4068)  // Accent
Color(0xFFE43F5A)  // Destaque vermelho
Colors.amber        // Pontuação/estrelas
Colors.green        // Acertos
Colors.red          // Erros
```

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Faça um Fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/NovaFeature`)
3. Commit suas mudanças (`git commit -m 'feat: Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/NovaFeature`)
5. Abra um Pull Request

---

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👨‍💻 Autor

**Lenire Denis**
- GitHub: [@leniredenis-bit](https://github.com/leniredenis-bit)
- Repositório: [JWQuizFlutter](https://github.com/leniredenis-bit/JWQuizFlutter)

---

## 🙏 Agradecimentos

- Comunidade Flutter
- Biblioteca de perguntas bíblicas
- Contribuidores do projeto

---

**JW SPLASH GAMES** - Aprenda, jogue e divirta-se! 🎮📖✨
