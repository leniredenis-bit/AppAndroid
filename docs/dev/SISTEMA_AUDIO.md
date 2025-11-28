# 🎵 Sistema de Áudio - JW Quiz Flutter

## ✅ O QUE JÁ ESTÁ FUNCIONANDO

### 🎼 Músicas de Fundo (Background Music)
Todas as telas têm música de fundo em loop! As músicas são escolhidas **aleatoriamente** de uma lista:

- **🏠 Home Screen:** `home.mp3` ou `Life of Riley.mp3`
- **🧠 Quiz Clássico:** `quiz.mp3` ou `quiz-home.mp3`
- **🕹️ Jogo da Memória:** `memory-game.mp3` ou `memory-home.mp3`
- **🥧 Quiz Torta na Cara:** `Pixel Peeker Polka - faster.mp3`

A música para automaticamente ao sair da tela e reinicia quando você volta!

---

## 🔊 EFEITOS SONOROS (SFX) - OPCIONAL

Os efeitos sonoros estão programados, mas você precisa adicionar os arquivos MP3.

### 📁 Onde colocar os arquivos:
```
assets/audio/sfx/
```

### 🎮 Arquivos necessários:

#### Jogo da Memória:
- **`card_flip.mp3`** - Som ao virar carta (tipo "flip" curto)
- **`match.mp3`** - Som ao acertar par (som alegre/positivo)
- **`mismatch.mp3`** - Som ao errar par (som negativo suave)
- **`victory.mp3`** - Som de vitória ao completar (fanfarra curta)

#### Quiz:
- **`correct.mp3`** - Som ao acertar resposta (ding/sino)
- **`wrong.mp3`** - Som ao errar resposta (buzina/negativo)

#### Geral:
- **`click.mp3`** - Som ao clicar em botões (clique sutil)

---

## 🌐 ONDE BAIXAR SONS GRATUITOS (Royalty-Free)

1. **Freesound.org** - https://freesound.org/
   - Crie conta grátis
   - Busque por: "card flip", "correct answer", "wrong buzzer", "click button"
   - Filtre por: Creative Commons 0 (CC0) ou CC-BY

2. **Mixkit** - https://mixkit.co/free-sound-effects/
   - Não precisa de conta
   - Seção "Game" tem muitos sons prontos

3. **Zapsplat** - https://www.zapsplat.com/
   - Conta grátis
   - Muitos efeitos de jogos

4. **Pixabay** - https://pixabay.com/sound-effects/
   - CC0 (domínio público)
   - Busque por: "click", "correct", "wrong", "flip"

---

## 💡 SUGESTÕES DE BUSCA

- **card_flip.mp3:** "card flip", "card shuffle", "paper flip"
- **match.mp3:** "success", "win", "positive beep", "ding"
- **mismatch.mp3:** "wrong", "negative", "error beep"
- **correct.mp3:** "correct answer", "right", "bell ding"
- **wrong.mp3:** "wrong answer", "buzzer", "error sound"
- **click.mp3:** "button click", "ui click", "soft click"
- **victory.mp3:** "victory", "win", "success fanfare" (max 2-3 segundos)

---

## ⚙️ COMO ADICIONAR OS SONS

1. Baixe os arquivos MP3
2. Renomeie exatamente como listado acima
3. Coloque em: `assets/audio/sfx/`
4. **Pronto!** Não precisa mudar código, o app detecta automaticamente

---

## 🎚️ CONTROLES DE VOLUME (Futuro)

O código já suporta ajuste de volume! Você pode adicionar na tela de configurações:

```dart
// Música de fundo (0.0 a 1.0)
AudioService().setMusicVolume(0.5);

// Efeitos sonoros (0.0 a 1.0)
AudioService().setSfxVolume(0.7);

// Desligar música
AudioService().setMusicEnabled(false);

// Desligar efeitos
AudioService().setSfxEnabled(false);
```

---

## 🚀 O APP FUNCIONA SEM OS ARQUIVOS SFX!

Se você não adicionar os arquivos de efeitos sonoros, o app continua funcionando normalmente, apenas sem os sons. A música de fundo já funciona com os arquivos que você tem!

---

## 📝 NOTAS IMPORTANTES

- Todos os arquivos devem ser **MP3**
- Tamanho ideal: 50-200KB por arquivo
- Duração ideal: 0.5-2 segundos (exceto victory: até 3s)
- Qualidade: 128kbps é suficiente

**Dica:** Efeitos sonoros curtos e sutis funcionam melhor em jogos!

---

Criado em: $(date)
Versão: 1.0.0
