# 🧪 Como Testar o JW Splash Games

## 📋 Índice

- [Pré-requisitos](#pré-requisitos)
- [Método 1: Chrome (Web)](#método-1-chrome-web)
- [Método 2: Android Emulador](#método-2-android-emulador)
- [Método 3: Build para Web](#método-3-build-para-web)
- [Testes por Funcionalidade](#testes-por-funcionalidade)
- [Problemas Comuns](#problemas-comuns)

---

## Pré-requisitos

Certifique-se de ter o Flutter configurado no PATH:

```powershell
# PowerShell (Windows)
$env:Path += ";C:\tools\flutter\bin"
flutter --version
```

**Instalação de Dependências:**
```powershell
cd "C:\Users\Denis\Documents\GitHub\AppAndroid"
flutter pub get
```

---

## Método 1: Chrome (Web) - Mais Rápido ⚡

```powershell
# Executar no Chrome
flutter run -d chrome
```

**Vantagens:**
- ✅ Inicia rápido (~10s)
- ✅ Hot reload funciona bem
- ✅ DevTools disponível (F12)
- ✅ Ideal para desenvolvimento

---

## Método 2: Android Emulador 📱

### Pré-requisitos:
1. Android Studio instalado
2. Emulador Android configurado

### Comandos:
```powershell
# Listar dispositivos
flutter devices

# Executar no emulador
flutter run -d emulator-5554
```

---

## Método 3: Build para Web 🌐

```powershell
# Build otimizado para produção
flutter build web

# Servir localmente
cd build/web
python -m http.server 8000

# Acessar: http://localhost:8000
```

---

## 🎮 Testes por Funcionalidade

### 1. **Tela Welcome**
- [ ] Título "JW Quiz" e emoji 📖 aparecem
- [ ] Botão "Começar" funciona
- [ ] Navega para Home Screen
- [ ] Botão "Estatísticas" abre tela de stats

---

### 2. **Home Screen - Filtros**
- [ ] **Filtros de Dificuldade**: Clique em Fácil/Médio/Difícil
  - Deve destacar o selecionado (cor diferente)
  - Clicar novamente desmarca
  - Pode selecionar múltiplos
- [ ] **Filtros de Tags**: Clique em categorias (Gênesis, Êxodo, etc.)
  - Deve destacar o selecionado
  - Clicar novamente desmarca
  - "Ver mais" expande lista completa de tags
  - "Ver menos" recolhe para 7 principais

---

### 3. **Home Screen - Botões de Modo**

#### **🧠 Quiz Clássico**
- [ ] Botão clicável
- [ ] Inicia quiz com filtros aplicados
- [ ] Sem filtros = 10 perguntas aleatórias
- [ ] Com filtros = perguntas filtradas

#### **🌐 Partida Online**
- [ ] Abre menu multiplayer
- [ ] Opções: "Criar Sala" e "Entrar em Sala"

#### **🕹️ Jogo da Memória**
- [ ] Abre jogo da memória
- [ ] 12 cartas (6 pares)
- [ ] Virar cartas funciona
- [ ] Pareamento correto = cartas permanecem viradas
- [ ] Pareamento errado = cartas viram de volta

#### **📊 Estatísticas**
- [ ] Mostra total de quizzes
- [ ] Pontuação total
- [ ] Taxa de acertos
- [ ] Melhor pontuação

#### **🎮 Outros Minigames**
- [ ] Abre tela de seleção com 6 jogos
- [ ] Todos os 6 botões funcionam

---

### 4. **Quiz Clássico - Gameplay**

#### **Timer**
- [ ] Inicia contagem regressiva
- [ ] Tempo ajusta ao tamanho da pergunta
- [ ] Fica vermelho quando ≤5s
- [ ] Ao zerar, avança automaticamente

#### **Pergunta e Alternativas**
- [ ] Pergunta é exibida claramente
- [ ] 4 alternativas (A, B, C, D)
- [ ] Alternativas são clicáveis
- [ ] Apenas 1 seleção por vez

#### **Feedback Visual**
- [ ] Resposta correta = botão verde
- [ ] Resposta errada = botão vermelho + mostra correto em verde
- [ ] Avança automaticamente após 2s

#### **Pontuação**
- [ ] Pontos aumentam ao acertar
- [ ] Fácil: 10 pts + bônus tempo
- [ ] Médio: 15 pts + bônus tempo
- [ ] Difícil: 20 pts + bônus tempo
- [ ] Bônus maior quanto mais tempo sobra

#### **Finalização**
- [ ] 10 perguntas no total
- [ ] Dialog de resultado aparece
- [ ] Mostra pontuação final
- [ ] Mostra acertos/total (ex: 8/10)
- [ ] Botão "Voltar" retorna ao Home

---

### 5. **Modo Multiplayer 🌐**

> **Precisa de 2 aparelhos** (Android e/ou iPhone pelo TestFlight) com internet, e do Firebase configurado
> (login anônimo + regras: [FIREBASE.md](FIREBASE.md)). No Chrome/web o multiplayer é só simulado.

#### **5.1 Criar Sala**
- [ ] Campo "Apelido" valida 3-20 caracteres
- [ ] Detecta profanidade e sugere alternativas
- [ ] Botões -/+ de perguntas (5, 10, 15, 20, 25, 30)
- [ ] Botões -/+ de capacidade (8 a 100, padrão 20)
- [ ] Botão "Criar Sala" gera código de 6 dígitos
- [ ] Navega para Lobby automaticamente

#### **5.2 Entrar em Sala**
- [ ] Campo "Código" aceita apenas 6 dígitos
- [ ] Campo "Apelido" valida profanidade
- [ ] Botão "Entrar" valida código
- [ ] Erro se sala não existe
- [ ] Erro se sala está cheia
- [ ] Sucesso = navega para Lobby

#### **5.3 Lobby - Anfitrião**
- [ ] Badge "ANFITRIÃO" aparece
- [ ] Lista de jogadores atualiza em tempo real
- [ ] Botão "Copiar Código" funciona (clipboard)
- [ ] Botão "Compartilhar" mostra mensagem
- [ ] Botão "Remover Jogador" aparece ao lado de cada player
  - [ ] Confirmação ao remover
  - [ ] Player é removido da sala
- [ ] Botão "Iniciar Partida":
  - [ ] Desabilitado se < 2 jogadores
  - [ ] Habilitado se ≥ 2 jogadores
  - [ ] Inicia quiz para todos
- [ ] Botão "Encerrar Sala":
  - [ ] Confirmação aparece
  - [ ] Fecha sala para todos

#### **5.4 Lobby - Não-Anfitrião**
- [ ] Badge "VOCÊ" aparece no seu nome
- [ ] Não vê botão "Iniciar Partida"
- [ ] Não vê botão "Remover Jogador"
- [ ] Aguarda anfitrião iniciar
- [ ] Auto-navega para quiz quando anfitrião inicia

#### **5.5 Quiz Multiplayer**
- [ ] Timer dinâmico (15s a 90s conforme pergunta)
- [ ] Todas as alternativas clicáveis
- [ ] Feedback visual após submeter
- [ ] Não pode mudar resposta após submeter
- [ ] Timer congela ao responder

- [ ] Quando **todos** respondem, a rodada fecha sozinha e todos vão para o resultado
- [ ] Se um jogador fechar o app no meio, a rodada fecha ~5s após o tempo acabar (pelo anfitrião)

#### **5.6 Resultado da Rodada**
- [ ] Mostra resposta correta
- [ ] Ranking ordenado por pontos
- [ ] Destaque para quem acertou (verde)
- [ ] Anfitrião vê "Próxima Pergunta"
- [ ] Não-anfitrião aguarda

#### **5.7 Resultado Final**
- [ ] Pódio com 🥇🥈🥉
- [ ] Animação de confete para vencedor
- [ ] Ranking completo de todos
- [ ] Botão "Jogar Novamente" (apenas anfitrião)
- [ ] Botão "Encerrar Sala" (apenas anfitrião)
- [ ] "Jogar Novamente" leva **todos** de volta ao Lobby com placar zerado

#### **5.8 Saídas e erros**
- [ ] Anfitrião sai do Lobby → os outros veem "sala encerrada"
- [ ] Jogador sai do Lobby → some da lista do anfitrião
- [ ] Código inexistente → "Sala não encontrada"
- [ ] Sala já em andamento → não deixa entrar
- [ ] Sem internet → mensagem de erro (sem travar)
- [ ] Jogadores com idiomas diferentes na mesma sala → cada um vê a pergunta no seu idioma

---

### 6. **Minigames 🎮**

#### **6.1 Jogo da Velha**
- [ ] Opções: 2 Jogadores ou vs IA
- [ ] IA tem dificuldade Fácil e Impossível
- [ ] Placar persiste durante sessão
- [ ] Detecção de vitória (linha/coluna/diagonal)
- [ ] Detecção de empate
- [ ] Botão "Reiniciar" funciona

#### **6.2 Jogo da Forca**
- [ ] 20 palavras bíblicas diferentes
- [ ] Teclado A-Z clicável
- [ ] Letras desabilitam após clicar
- [ ] Visual do boneco atualiza (0 a 6 erros)
- [ ] Vitória = palavra completa
- [ ] Derrota = 6 erros
- [ ] Botão "Nova Palavra" funciona

#### **6.3 Sequência Rápida**
- [ ] Mostra sequência de cores
- [ ] Jogador deve repetir
- [ ] Aumenta dificuldade (adiciona 1 cor)
- [ ] Erro = game over
- [ ] Tracking de recorde
- [ ] Botão "Jogar Novamente"

#### **6.4 Labirinto**
- [ ] Setas do teclado funcionam (↑↓←→)
- [ ] Botões na tela funcionam (mobile)
- [ ] **Segurar o direcional anda sem parar** (não só 2–3 casas)
- [ ] Trocar de direção sem soltar responde na hora
- [ ] Colisão com paredes detectada
- [ ] Contador de movimentos
- [ ] Vitória ao chegar no fim
- [ ] Botão "Reiniciar" funciona

#### **6.5 Caça-Palavras**
- [ ] Grade 12x12 gerada corretamente
- [ ] 10 palavras escondidas
- [ ] Drag-to-select funciona
- [ ] Palavras encontradas ficam tachadas
- [ ] Som ao encontrar palavra
- [ ] Vitória ao encontrar todas
- [ ] Botão "Novo Jogo" gera novo grid

#### **6.6 Quebra-Cabeça (Jigsaw)**
- [ ] Escolha de dificuldade funciona
- [ ] Imagens prontas (puzzle1–4) e **foto da galeria** (seletor do sistema, sem pedir permissão)
- [ ] Tocar numa peça do estoque pega **essa** peça (não uma já encaixada)
- [ ] Encaixes das peças combinam (saliência ↔ reentrância, sem reta com redonda)
- [ ] Peça encaixada **fica fixa** (não gira nem pode ser arrastada)
- [ ] Vitória ao completar

#### **6.7 Sequência Rápida / Sequência Cristal**
- [ ] Cristal: botões em formato de **cristal** (não círculos), com brilho ao acender
- [ ] Sequência cresce a cada acerto; erro = fim de jogo
- [ ] Música de fundo toca

#### **6.8 Forca**
- [ ] Palavras e dicas no idioma escolhido
- [ ] Boneco desenhado parte a parte a cada erro

---

### 7. **Sistema de Áudio 🎵**

#### **Músicas de Fundo**
- [ ] Home Screen toca música aleatória
- [ ] Quiz toca música diferente
- [ ] Memory Game toca música diferente
- [ ] Música para ao mudar de tela
- [ ] Loop automático funciona

#### **Efeitos Sonoros** (se arquivos existirem)
- [ ] Som ao acertar resposta
- [ ] Som ao errar resposta
- [ ] Som ao clicar botões
- [ ] Som ao virar carta (memory)
- [ ] Som ao fazer par (memory)
- [ ] Som de vitória

---

## � Checklist Geral de Qualidade

### **Performance**
- [ ] Navegação fluida (sem lag)
- [ ] Timer preciso (1s real = 1s app)
- [ ] Transições suaves
- [ ] Hot reload funciona

### **Responsividade**
- [ ] Desktop (Chrome maximizado)
- [ ] Tablet (emulador ou resize)
- [ ] Mobile (emulador)
- [ ] Resize da janela mantém layout

### **UI/UX**
- [ ] Cores consistentes
- [ ] Botões têm padding adequado
- [ ] Texto legível
- [ ] Emojis aparecem corretamente
- [ ] Cards com bordas arredondadas
- [ ] Espaçamento consistente

### **Erros e Edge Cases**
- [ ] Sem filtro = perguntas aleatórias
- [ ] Filtro sem perguntas = mensagem de erro
- [ ] Voltar durante quiz = confirmação
- [ ] Sair do lobby = confirmação
- [ ] Sala multiplayer com 1 player = não inicia
- [ ] Timeout de sala (1h) funciona

---

## 🐛 Problemas Comuns

### 1. "flutter não reconhecido"
```powershell
# Solução:
$env:Path += ";C:\tools\flutter\bin"
flutter --version
```

### 2. "Nenhuma pergunta encontrada"
- Verifique `assets/data/perguntas_atualizado.json`
- Verifique `pubspec.yaml`:
  ```yaml
  flutter:
    assets:
      - assets/audio/
      - assets/data/
  ```
- Execute: `flutter pub get`

### 3. Chrome não abre
```powershell
flutter doctor
flutter run -d edge  # Tente Edge
```

### 4. Áudio não toca
- Arquivos MP3 estão em `assets/audio/`?
- `audioplayers` no `pubspec.yaml`?
- Volume do sistema está ligado?

### 5. Erro no multiplayer
- Apenas 1 instância aberta? (Abra 2 janelas Chrome)
- Teste em modo anônimo também
- Verifique console (F12) para erros

---

## 🎯 Resultado Esperado

Após concluir todos os testes:
- ✅ App roda sem crashes
- ✅ Navegação fluída
- ✅ Quiz funcional
- ✅ Multiplayer sincronizado
- ✅ 7 minigames funcionando
- ✅ Áudio tocando
- ✅ Performance adequada

---

## 📝 Reportar Bugs

Se encontrar problemas:
1. Abra uma [Issue](https://github.com/leniredenis-bit/AppAndroid/issues)
2. Descreva o problema
3. Inclua prints/vídeos
4. Informe: device, OS, Flutter version

---

**Bons testes! 🚀**
