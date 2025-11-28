# 🎮 JW SPLASH GAMES

> Jogo educativo bíblico interativo desenvolvido em Flutter com quiz, 11 minigames divertidos, sistema de conquistas, multiplayer online e suporte multilíngue!

![Flutter](https://img.shields.io/badge/Flutter-3.5.0+-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.5.0+-blue?logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey)

---

## 📋 Documentação

- 📊 **[Status do Projeto](PROJECT_STATUS.md)** - Análise completa e checklist de publicação
- 🚀 **[Próximos Passos](NEXT_STEPS.md)** - Guia passo a passo para publicar o app
- 📚 **[Guias](docs/guides/)** - Como testar, configurar Firebase, multiplayer
- 🔧 **[Desenvolvimento](docs/dev/)** - Documentação técnica e melhorias
- ✅ **[Checklists](docs/checklists/)** - Checklist final e ícones

---

## 🎯 Sobre o Projeto

**JW SPLASH GAMES** é um aplicativo educativo que combina aprendizado bíblico com diversão! O app oferece quiz interativo com 1181 perguntas em 3 idiomas, 11 minigames únicos, sistema completo de conquistas, multiplayer online e muito mais. Tudo em uma interface moderna e colorida.

### ✨ Destaques
- 🧠 **1181 Perguntas** traduzidas (PT, EN, ES)
- 🎮 **11 Minigames** educativos e divertidos
- 🏆 **50+ Conquistas** desbloqueáveis
- 👥 **Multiplayer Online** com Firebase
- 📊 **Estatísticas** completas e rankings
- 🌍 **3 Idiomas** (Português, English, Español)
- 🎵 **Sistema de Áudio** com músicas e SFX
- 🎨 **Interface Moderna** com animações

### 📱 Plataformas Suportadas
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

---

## 🎮 Minigames (11 Totais)

1. **🧠 Jogo da Memória** - Encontre pares bíblicos
2. **⭕ Jogo da Velha** - 2 jogadores ou vs IA com Minimax
3. **🌟 Jogo da Velha Neon** - Versão com animações neon
4. **🎯 Forca** - Adivinhe palavras bíblicas
5. **🔍 Caça-Palavras** - Encontre palavras escondidas
6. **🎨 Caça-Palavras Enhanced** - Com linhas coloridas e drag
7. **🌀 Labirinto** - Navegue até a saída
8. **🎵 Sequência Rápida** - Memorize padrões de cores
9. **💠 Sequência Cristal** - Versão com efeitos visuais brilhantes
10. **🧩 Quebra-Cabeça Jigsaw** - Arraste e monte
11. **🖼️ Quebra-Cabeça Foto** - Monte imagens da galeria

---

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK 3.5.0 ou superior
- Dart SDK 3.5.0+
- Editor de código (VS Code, Android Studio)

### Instalação Rápida

```bash
# 1. Clone o repositório
git clone https://github.com/leniredenis-bit/JWQuizFlutter.git
cd jw_quiz_flutter

# 2. Instale as dependências
flutter pub get

# 3. Execute o app
flutter run

# Ou escolha uma plataforma específica:
flutter run -d chrome        # Web
flutter run -d windows       # Windows
flutter run -d android       # Android
flutter run -d ios           # iOS
```

### Build Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS (requer macOS)
flutter build ios --release
flutter build ipa

# Web
flutter build web --release
```

---

## 📦 Dependências Principais

```yaml
dependencies:
  shared_preferences: ^2.3.3    # Persistência local
  google_fonts: ^6.3.2          # Fontes personalizadas
  audioplayers: ^6.5.1          # Sistema de áudio
  uuid: ^4.5.1                  # IDs únicos
  url_launcher: ^6.3.1          # Links externos
  flutter_custom_tabs: ^2.1.0   # Preview de links
  intl: ^0.20.2                 # i18n e formatação
  image_picker: ^1.1.2          # Galeria de fotos
  
  # Firebase (multiplayer)
  firebase_core: ^2.24.2
  firebase_database: ^10.4.0
  firebase_auth: ^4.15.3
```

---

## 🏗️ Estrutura do Projeto

```
jw_quiz_flutter/
├── lib/
│   ├── main.dart
│   ├── models/               # Achievement, QuizQuestion, Stats
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── quiz_screen.dart
│   │   ├── achievements_screen.dart
│   │   ├── stats_screen.dart
│   │   ├── minigames/        # 12 arquivos de minigames
│   │   └── multiplayer/      # Lobby, room, match screens
│   ├── services/             # Storage, Audio, Achievement, etc.
│   ├── widgets/              # Componentes reutilizáveis
│   └── l10n/                 # Traduções (pt, en, es)
├── assets/
│   ├── audio/                # 7 músicas + sfx/
│   ├── data/                 # perguntas_pt/en/es.json
│   └── images/               # 4 imagens puzzle
├── docs/
│   ├── guides/               # Guias de uso
│   ├── dev/                  # Documentação técnica
│   └── checklists/           # Checklists de conclusão
├── scripts/                  # Ferramentas Python
└── [android, ios, web, etc.] # Código nativo
```

---

## 🎨 Paleta de Cores

```dart
Color(0xFF101A2C)  // Background escuro
Color(0xFF162447)  // AppBar e cards
Color(0xFF1F4068)  // Accent
Color(0xFF4A90E2)  // Botões principais
Color(0xFFE43F5A)  // Destaque vermelho
Color(0xFF50C878)  // Verde sucesso
Color(0xFF9B59B6)  // Roxo (sequência)
Color(0xFF00F0FF)  // Neon azul
Color(0xFFFF00AA)  // Neon rosa
```

---

## 🏆 Sistema de Conquistas

50+ conquistas em categorias:
- 📚 **Quiz** - Complete quizzes, acerte tudo, seja rápido
- 🎮 **Minigames** - Domine todos os 11 jogos
- 👥 **Social** - Jogue multiplayer, vença competições
- 💎 **Master** - Desbloqueie tudo e seja uma lenda

Cada conquista tem:
- Ícone emoji único
- Descrição e requisitos
- Barra de progresso
- Animação de desbloqueio com confetti

---

## 👥 Multiplayer Online

Sistema completo com Firebase:
- **Criar Sala** - Gere código de 6 dígitos
- **Entrar em Sala** - Digite o código e participe
- **Lobby** - Veja jogadores em tempo real
- **Partidas Sincronizadas** - Perguntas simultâneas
- **Ranking Live** - Veja pontuações em tempo real

⚠️ **Nota:** Requer configuração do Firebase. Veja [docs/guides/FIREBASE_SETUP.md](docs/guides/FIREBASE_SETUP.md)

---

## 🌍 Internacionalização

Sistema completo de i18n com Flutter:
- 🇧🇷 **Português** - 1181 perguntas, UI completa
- 🇺🇸 **English** - Tradução automática + revisão
- 🇪🇸 **Español** - Tradução automática + revisão

Troca de idioma sem restart, persistência automática.

---

## 📊 Status do Projeto

**Versão Atual:** 1.0.0+1  
**Status:** 🟡 90% Completo - Preparação para Publicação

### ✅ Implementado
- [x] Sistema de quiz com 1181 perguntas
- [x] 11 minigames funcionais
- [x] Sistema de conquistas (50+)
- [x] Multiplayer online com Firebase
- [x] Internacionalização (3 idiomas)
- [x] Sistema de áudio completo
- [x] Estatísticas e rankings
- [x] Persistência local

### 🚧 Pendente para Publicação
- [ ] Application ID único (atualmente: `com.example.jw_quiz_flutter`)
- [ ] Ícone profissional personalizado
- [ ] Splash screen customizado
- [ ] Assinatura release (Android keystore)
- [ ] Firebase production configurado
- [ ] Screenshots para lojas
- [ ] Privacy policy hospedada
- [ ] Descrições das lojas (curta/longa)

**Veja detalhes completos em [PROJECT_STATUS.md](PROJECT_STATUS.md)**

---

## 🤝 Contribuindo

Contribuições são bem-vindas! 

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/NovaFeature`)
3. Commit suas mudanças (`git commit -m 'feat: Adiciona NovaFeature'`)
4. Push para a branch (`git push origin feature/NovaFeature`)
5. Abra um Pull Request

Por favor, siga os padrões de código e adicione testes quando apropriado.

---

## 📝 Licença

Este projeto está sob a licença MIT. Veja [LICENSE](LICENSE) para detalhes.

---

## 👨‍💻 Autor

**Lenire Denis**
- GitHub: [@leniredenis-bit](https://github.com/leniredenis-bit)
- Repositório: [JWQuizFlutter](https://github.com/leniredenis-bit/JWQuizFlutter)

---

## 🙏 Agradecimentos

- Comunidade Flutter pelo framework incrível
- Firebase pela infraestrutura de backend
- Google Fonts pelas fontes
- Todos os contribuidores e testadores

---

## 📞 Suporte

Encontrou um bug? Tem uma sugestão?
- 🐛 [Reporte Issues](https://github.com/leniredenis-bit/JWQuizFlutter/issues)
- 💡 [Sugestões](https://github.com/leniredenis-bit/JWQuizFlutter/discussions)

---

**JW SPLASH GAMES** - Aprenda, jogue e divirta-se! 🎮📖✨

*Desenvolvido com ❤️ usando Flutter*

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
