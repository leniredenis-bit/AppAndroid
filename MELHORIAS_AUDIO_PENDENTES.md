# 🎵 Melhorias de Áudio Pendentes

## 📋 Lista de Ajustes Necessários

### 1. **Labirinto (Maze Game)**
- [ ] **Música de fundo**: Arquivo `cave_ambience.mp3` referenciado no código não existe
  - **Localização**: `maze_game.dart` - linha `initState()`
  - **Ação**: Criar/adicionar arquivo de música ambiente de caverna OU trocar por música existente
  - **Sugestões**: 
    - Usar `memory-game.mp3` temporariamente
    - Procurar música CC0 de caverna/exploração
    - Criar loop de som ambiente (gotas d'água, eco de caverna)

- [ ] **Som de passo**: Atualmente usa `playClick()` genérico
  - **Localização**: `maze_game.dart` - método `_tryMove()`
  - **Ação**: Criar som específico de passos (ex: `step.mp3`)
  - **Sugestões**:
    - Som de passos em terra/pedra
    - 2-3 variações para evitar repetição monótona

- [ ] **Som de colisão**: Atualmente usa `playWrongAnswer()` 
  - **Localização**: `maze_game.dart` - detecção de parede
  - **Ação**: Considerar som específico de "bump" na parede
  - **Sugestões**:
    - Som de impacto suave em pedra
    - Feedback mais curto e direto

### 2. **Caça-Palavras (Word Search)**
- [ ] **Som de conclusão**: Verifica se `AudioService.playSound('success')` existe
  - **Localização**: `word_search_game.dart` - método `_checkCompletion()`
  - **Ação**: Confirmar que arquivo existe ou trocar por `playVictory()`

### 3. **Outros Minigames**
- [ ] **Revisar consistência**: Verificar se todos os minigames usam sons apropriados para cada ação
  - Vitória/Derrota
  - Acertos/Erros
  - Cliques/Seleções
  - Background music apropriada ao tema

---

## 🔧 Ações Recomendadas

### **Imediato (Substituições Temporárias)**
```dart
// Em maze_game.dart, trocar:
_audioService.playBackgroundMusic('cave_ambience.mp3');
// Por:
_audioService.playBackgroundMusic('memory-game.mp3'); // ou outra música existente
```

### **Médio Prazo (Adicionar Arquivos)**
1. Procurar efeitos sonoros CC0 em:
   - [Freesound.org](https://freesound.org)
   - [OpenGameArt.org](https://opengameart.org)
   - [ZapSplat](https://zapsplat.com)

2. Adicionar na pasta `assets/audio/sfx/`:
   - `cave_ambience.mp3` (música de fundo)
   - `step.mp3` (som de passo)
   - `wall_bump.mp3` (colisão com parede)

3. Atualizar `pubspec.yaml` se necessário

### **Longo Prazo (Polimento)**
- Criar sistema de áudio contextual (músicas diferentes por nível/modo)
- Adicionar controle de volume por categoria (SFX, Music)
- Implementar crossfade entre músicas

---

## 📝 Notas
- **Data de Criação**: 27/11/2025
- **Última Atualização**: 27/11/2025
- **Status**: Documentado, aguardando implementação
- **Prioridade**: Média (não impede funcionamento, mas melhora UX)

---

## ✅ Checklist de Verificação Pré-Release
Antes de fazer release/deploy, verificar:
- [ ] Todos os arquivos de áudio referenciados existem
- [ ] Nenhum erro de "file not found" no console
- [ ] Sons estão balanceados (volume adequado)
- [ ] Músicas fazem loop corretamente
- [ ] Efeitos sonoros não se sobrepõem de forma desagradável
