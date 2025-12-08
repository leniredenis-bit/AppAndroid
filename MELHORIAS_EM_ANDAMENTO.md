# Lista de Melhorias em Andamento

Este documento acompanha o progresso das melhorias solicitadas para o app.

---

## Status Geral

| # | Tarefa | Status |
|---|--------|--------|
| 1 | Sequência Cristal: trocar círculos por cristais | ✅ Concluído |
| 2 | Labirinto: melhorar movimento contínuo | ✅ Concluído |
| 3 | Jigsaw: corrigir seleção de peças | ✅ Concluído |
| 4 | Jigsaw: padronizar recorte das peças | ✅ Já OK |
| 5 | Jigsaw: fixar peças quando encaixam | ✅ Já OK |
| 6 | Excluir quebra-cabeça antigo | ✅ Concluído |
| 7 | Excluir caça-palavras antigo | ✅ Concluído |
| 8 | Excluir jogo da velha antigo | ✅ Concluído |
| 9 | Forca: melhorar desenho do boneco | ✅ Concluído |
| 10 | Aprimorar traduções multilingue | ✅ Já OK |

---

## Detalhes das Tarefas

### 1. Sequência Cristal: trocar círculos por cristais
**Arquivo:** `lib/screens/minigames/sequence_game_crystal.dart`
**Descrição:** Substituir os ícones redondos por formas de cristal/diamante, como na capa do jogo.
**Status:** ✅ Concluído
**Alterações:**
- Criada classe `CrystalPainter` que desenha formas hexagonais de cristal com gradientes
- Botões agora usam `CustomPaint` com facetas internas e efeitos de brilho
- Efeito glow quando o cristal está aceso

---

### 2. Labirinto: melhorar movimento contínuo
**Arquivo:** `lib/screens/minigames/maze_game.dart`
**Descrição:** O personagem deve andar continuamente enquanto o jogador segura o direcional (joystick), não apenas 2-3 casas e parar.
**Status:** ✅ Concluído
**Alterações:**
- Implementado sistema de `Timer.periodic` para movimento contínuo
- Personagem agora se move a cada 150ms enquanto joystick está pressionado
- Direção é atualizada instantaneamente quando o jogador muda de direção
- Timer é cancelado automaticamente ao soltar o joystick ou colidir

---

### 3. Jigsaw: corrigir seleção de peças
**Arquivo:** `lib/screens/minigames/jigsaw_puzzle_game.dart`
**Descrição:** Evitar que peças já encaixadas sejam arrastadas quando o jogador tenta pegar peças do estoque. Peças locked não devem ser movíveis.
**Status:** ⏳ Pendente

---

### 4. Jigsaw: padronizar recorte das peças
**Arquivo:** `lib/screens/minigames/jigsaw_puzzle_game.dart`
**Descrição:** Todas as peças devem ter encaixes arredondados consistentes (não misturar borda reta com redonda).
**Status:** ⏳ Pendente

---

### 5. Jigsaw: fixar peças quando encaixam
**Arquivo:** `lib/screens/minigames/jigsaw_puzzle_game.dart`
**Descrição:** Quando uma peça é encaixada corretamente, ela deve ficar travada/fixa no lugar, sem poder ser movida ou rodopiar.
**Status:** ⏳ Pendente

---

### 6. Excluir quebra-cabeça antigo
**Arquivo:** `lib/screens/minigames/puzzle_game.dart`
**Descrição:** Remover o jogo antigo do menu de minigames e excluir o arquivo.
**Status:** ⏳ Pendente

---

### 7. Excluir caça-palavras antigo
**Arquivo:** `lib/screens/minigames/word_search_game.dart`
**Descrição:** Remover o jogo antigo do menu de minigames e excluir o arquivo.
**Status:** ⏳ Pendente

---

### 8. Excluir jogo da velha antigo
**Arquivo:** `lib/screens/minigames/tic_tac_toe_game.dart`
**Descrição:** Remover o jogo antigo do menu de minigames e excluir o arquivo.
**Status:** ⏳ Pendente

---

### 9. Forca: melhorar desenho do boneco
**Arquivo:** `lib/screens/minigames/hangman_game.dart`
**Descrição:** Criar um boneco mais elaborado com mais detalhes visuais (cabelo, roupas, expressão, etc).
**Status:** ⏳ Pendente

---

### 10. Aprimorar traduções multilingue
**Arquivos:** `lib/l10n/app_*.arb`, telas dos minigames
**Descrição:** Identificar e traduzir palavras hardcoded que ainda não estão no sistema i18n.
**Status:** ⏳ Pendente

---

## Histórico de Alterações

| Data | Tarefa | Alteração |
|------|--------|-----------|
| - | - | - |

