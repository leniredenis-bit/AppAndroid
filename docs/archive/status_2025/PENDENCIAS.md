# Pendências — Projeto JW Quiz (AppAndroid + variantes)

> Gerado em 06/08/2026 a partir de análise dos arquivos do projeto (ajustesapp.md, PROJECT_STATUS.md, NEXT_STEPS.md, MELHORIAS_FUTURAS.md) e da estrutura de pastas.

## ⚠️ Duplicação entre projetos

- **AppAndroid** e **JWQuizFlutter** são o mesmo projeto duplicado (código idêntico em `lib/`, mesmo README "JW Splash Games").
  - `AppAndroid` está mais avançado: `applicationId` configurado (`com.jwsplashgames.quiz`), `google-services.json` presente, plugin Crashlytics adicionado. **É o app de testes atual.**
  - `JWQuizFlutter` ainda usa o `applicationId` de exemplo (`com.example.jw_quiz_flutter`) — parece ser a versão anterior, não usada mais.
  - **Decisão pendente:** manter os dois em paralelo ou aposentar o JWQuizFlutter?
- **JWQuizAndroid** é um repositório vazio (só contém README, sem código).
- **JW-Quiz** é o projeto original em HTML/JS/PWA (web, 1181 perguntas) — parece ter sido a base para o app Flutter.

---

## 🔧 Ajustes pedidos pelo usuário (ajustesapp.md)

- [ ] **Sequência Cristal**: trocar ícones circulares pelo símbolo de cristal (usado na capa do jogo)
- [ ] **Labirinto**: jogabilidade travada — o direcional anda 2-3 casas e para; implementar movimento contínuo enquanto o direcional é mantido pressionado
- [ ] **Quebra-cabeça**: bug ao arrastar peças — às vezes o toque não pega a peça certa e arrasta outra já encaixada
- [ ] **Quebra-cabeça**: encaixe de peças incorreto (parte reta encaixando com parte redonda)
- [ ] **Quebra-cabeça**: peças não fixam no lugar certo — ficam "rodopiando" após encaixar
- [ ] Remover o **quebra-cabeça antigo** (versão obsoleta)
- [ ] Remover o **caça-palavras antigo** (versão obsoleta)
- [ ] **Forca**: boneco muito simples — criar versão mais elaborada (já existe `hangman_game_enhanced.dart` não integrado ao menu)
- [ ] Remover o **jogo da velha antigo**
- [ ] **Multilíngue**: várias palavras/textos ainda não traduzidos na estrutura do jogo (EN/ES)

---

## 📦 Pendências de publicação (PROJECT_STATUS.md / NEXT_STEPS.md)

### Crítico (bloqueia publicação nas lojas)
- [ ] Ícone profissional personalizado (atual: ícone padrão do Flutter)
- [ ] Splash screen customizado
- [ ] Keystore de assinatura release do Android (hoje assinado com debug key)
- [ ] Nome comercial final do app (pubspec ainda usa `jw_splash_games`)
- [ ] Privacy Policy criada e hospedada (obrigatório para Play Store)
- [ ] Screenshots e Feature Graphic para as lojas
- [ ] Descrições curta/longa para a loja

### Importante
- [ ] Testar build release em dispositivo real (`flutter build apk --release`)
- [ ] Confirmar se o Firebase atual (`jwsplashgames-fc4a1`) é produção ou apenas teste
- [ ] Rodar `flutter analyze` e corrigir warnings
- [ ] Testar multiplayer com Firebase real
- [ ] Ativar Firebase Analytics (Crashlytics já está no gradle)

### Opcional / Futuro
- [ ] Integrar `hangman_game_enhanced.dart` e `jigsaw_puzzle_game_v2.dart` (versões alternativas prontas mas não usadas no menu)
- [ ] Adicionar mais idiomas (FR, DE, IT)
- [ ] Sistema de personalização de avatar

---

## 💻 Ambiente de desenvolvimento (máquina local)

- [x] Flutter 3.41.2 instalado
- [x] Android SDK encontrado (`C:\Program Files (x86)\Android\android-sdk`)
- [x] JDK 21 encontrado (`C:\Program Files\Android\openjdk\jdk-21.0.8`)
- [x] Visual Studio com VC++ instalado
- [ ] Rodar `flutter doctor` numa sessão nova de terminal/VS Code para confirmar que tudo foi reconhecido (variáveis `JAVA_HOME`/`ANDROID_HOME` já configuradas, mas precisam de terminal novo pra valer)
- [ ] Rodar `flutter pub get` no AppAndroid (e no JWQuizFlutter, se for mantido)

---

## 🌐 Web (JW-Quiz)

- [ ] Dois arquivos de perguntas quase idênticos: `DATA/perguntas.json` e `DATA/perguntas_atualizado.json` — confirmar qual é o atual e remover o obsoleto
- [ ] Roadmap extenso em `MELHORIAS_FUTURAS.md` (performance, migração TypeScript, testes automatizados, mais idiomas) — baixa prioridade, não bloqueia uso atual
