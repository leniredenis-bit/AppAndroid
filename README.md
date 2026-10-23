# 🎮 JW Splash Games

> Jogo educativo bíblico em Flutter: quiz com 1.180 perguntas, 8 minigames, conquistas, multiplayer online e 3 idiomas.

![Flutter](https://img.shields.io/badge/Flutter-3.41-blue?logo=flutter)
![Platform](https://img.shields.io/badge/plataformas-Android%20%7C%20iOS-lightgrey)
![Status](https://img.shields.io/badge/status-preparando%20lan%C3%A7amento-orange)

**👉 Status, pendências e próximos passos: [PLANO_LANCAMENTO.md](PLANO_LANCAMENTO.md)** · Documentação: [docs/](docs/README.md)

---

## ✨ O que o app tem

- 🧠 **Quiz bíblico**: 1.180 perguntas em PT, EN e ES, 3 níveis de dificuldade, explicação e link da referência bíblica
- 🎮 **8 minigames**: Memória · Quebra-Cabeça (com fotos da galeria) · 🆕 Colorir · Forca com dicas · Caça-Palavras · Labirinto (30 cavernas) · Sequência Cristal (melodias) · Jogo da Velha Neon (3 níveis de IA)
- 👥 **Multiplayer online**: salas com código de 6 dígitos, sem cadastro (Firebase)
- 🏆 **15 conquistas**, estatísticas e recordes salvos no aparelho
- 🌍 **3 idiomas** com troca na hora: Português, English, Español
- 🎵 Músicas e efeitos sonoros · 💬 chat de suporte (Crisp)

App independente feito por voluntários, sem vínculo com a organização das Testemunhas de Jeová ou com jw.org.

---

## 🚀 Rodando o projeto

Requisitos: Flutter 3.41+, Android SDK (e um Mac **ou** o Codemagic para iOS).

```bash
flutter pub get
flutter run                 # aparelho/emulador conectado
flutter run -d chrome       # web (multiplayer em modo simulado)
```

Builds Android (Windows): `.\build_apk.ps1 [quick|aab|clean]`. Detalhes em [docs/guias/BUILD_ANDROID.md](docs/guias/BUILD_ANDROID.md).
Build iOS: via Codemagic (`codemagic.yaml`), em [docs/guias/BUILD_IOS.md](docs/guias/BUILD_IOS.md).

Antes de commitar: `flutter analyze` (hoje sem nenhum aviso).

---

## 🏗️ Estrutura

```
lib/
├── main.dart                  # inicializa Firebase, Analytics, Crashlytics, áudio, idioma
├── l10n/                      # app_pt.arb (modelo), app_en.arb, app_es.arb + gerados
├── models/                    # Question, QuizService, Achievement, Stats, multiplayer/Room|Player
├── screens/
│   ├── home, quiz, pie_quiz, memory_game, stats, achievements, about, terms, welcome
│   ├── minigames/             # 8 jogos + common/ (kit visual, textos PT/EN/ES, resultados)
│   └── multiplayer/           # menu → criar/entrar → lobby → quiz → rodada → final
├── services/                  # storage, audio, language, achievement, analytics, crashlytics, chat, auth
│   └── multiplayer/           # firebase_multiplayer_service (+ mock para web)
├── utils/  widgets/
assets/
├── data/perguntas_{pt,en,es}.json
├── audio/                    # músicas Kevin MacLeod (CC BY 4.0, créditos na tela Sobre)
│   └── sfx/                   # efeitos sintetizados (scripts/generate_sfx.py)
├── images/                    # imagens do quebra-cabeça
└── icon/                      # arte do ícone/splash (ver LEIA-ME)
web/privacidade.html           # política de privacidade pública (GitHub Pages)
database.rules.json            # regras do Firebase Realtime Database
codemagic.yaml                 # CI iOS → TestFlight
scripts/                       # keystore, tradução de perguntas, utilitários
```

## 🔧 Identificadores

| | |
|---|---|
| Android / iOS | `com.jwsplashgames.quiz` |
| Firebase | `jwsplashgames-fc4a1` |
| Versão | `pubspec.yaml` → `1.0.0+2` |

## 🎨 Cores

`#101A2C` fundo · `#162447` app bar/cards · `#1F4068` destaque · `#4A90E2` botões · `#E43F5A` vermelho · `#50C878` sucesso · `#00F0FF`/`#FF00AA` neon

---

## 🤝 Contribuindo
Veja [CONTRIBUTING.md](CONTRIBUTING.md).

## 👤 Autor
**Lenire Denis** · [@leniredenis-bit](https://github.com/leniredenis-bit)

## 🙏 Créditos
Músicas: Kevin MacLeod ([incompetech.com](https://incompetech.com)), sob licença [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
Feito com Flutter e Firebase.
