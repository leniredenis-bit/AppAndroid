# 🧩 Jigsaw Puzzle Game - Documentação Completa

## ✅ Status: **PRONTO PARA TESTAR**

### 📝 Resumo das Melhorias Aplicadas

O arquivo original `puzz2` foi **completamente revisado e melhorado**, resultando em `jigsaw_puzzle_game.dart`:

---

## 🎯 Melhorias Implementadas

### 1. **Integração com Sistema Existente**
- ✅ `AudioService` integrado (sons de encaixe, vitória, cliques)
- ✅ `StorageService` para salvar recordes
- ✅ `AchievementService` para conquistas
- ✅ Sistema de pontuação baseado em movimentos e dificuldade

### 2. **Sistema de Dificuldade**
- ✅ **Fácil**: 3x3 (9 peças)
- ✅ **Médio**: 4x4 (16 peças)
- ✅ **Difícil**: 5x5 (25 peças)
- ✅ Seletor visual com `SegmentedButton`

### 3. **UX/UI Aprimorada**
- ✅ HUD com contadores (movimentos, peças encaixadas)
- ✅ Peças spawnam **fora do tabuleiro** (não mais sobrepostas)
- ✅ Grade de referência visual quando preview está ativo
- ✅ Z-index dinâmico (peça que você toca vem para frente)
- ✅ Feedback visual: peças travadas ficam com borda verde
- ✅ Sombras apenas em peças não travadas

### 4. **Sistema de Imagens**
- ✅ Upload da galeria via `image_picker`
- ✅ Galeria do sistema com assets locais (não URLs externas)
- ✅ Tratamento de erros e permissões
- ✅ Documentação em `assets/images/README.md`

### 5. **Geometria e Renderização**
- ✅ Curvas Bézier perfeitas para abas (tabs)
- ✅ Sistema in/out complementar (peças encaixam certinho)
- ✅ `ClipPath` personalizado para recortar imagem
- ✅ `CustomPaint` para sombras e bordas
- ✅ Transformação de matriz para posicionar imagem dentro da peça

### 6. **Lógica de Jogo**
- ✅ Snap inteligente (40px de sensibilidade)
- ✅ Lock automático quando peça encaixa
- ✅ Detecção de vitória
- ✅ Contador de movimentos
- ✅ Timer de sessão
- ✅ Cálculo de pontuação (menos movimentos = mais pontos)

---

## 📦 Dependências Adicionadas

```yaml
# Em pubspec.yaml
dependencies:
  image_picker: ^1.1.2  # Seleção de imagens da galeria

# Em assets
flutter:
  assets:
    - assets/images/  # Pasta para imagens do quebra-cabeça
```

---

## 🖼️ Assets Necessários

### Imagens (Opcional - usar galeria funciona sem isso)
```
assets/images/
  ├── puzzle1.jpg  (500x500px, natureza/paisagem)
  ├── puzzle2.jpg  (500x500px, animais/flores)
  ├── puzzle3.jpg  (500x500px, arte religiosa)
  └── puzzle4.jpg  (500x500px, cena bíblica)
```

**Fontes recomendadas**: Unsplash, Pixabay, Pexels (todas CC0)

### Áudio (Já existente ou adicionar)
```
assets/audio/
  └── puzzle-theme.mp3  (música de fundo relaxante)
```

**Sugestão temporária**: Usar `memory-game.mp3` ou outra música existente

---

## 🎮 Como Usar

### No Menu Principal
1. Escolher dificuldade (3x3, 4x4, 5x5)
2. **Opção 1**: Carregar imagem da galeria do dispositivo
3. **Opção 2**: Selecionar uma das 4 imagens do sistema

### Durante o Jogo
- **Arrastar peças**: Toque e arraste para mover
- **Encaixar**: Solte perto da posição correta (snap automático)
- **Ver gabarito**: Botão de olho no topo (toggle preview)
- **Reiniciar**: Botão de refresh no topo

### Vitória
- Tela de celebração com estatísticas
- Conquistas desbloqueadas (se aplicável)
- Opção de nova partida

---

## 🔧 Integração com o Projeto

### 1. Adicionar ao Menu de Minigames

No arquivo de navegação/menu principal, adicione:

```dart
import 'package:jw_splash_games/screens/minigames/jigsaw_puzzle_game.dart';

// No GridView ou ListView de minigames:
MinigameCard(
  title: '🧩 Quebra-Cabeça',
  icon: Icons.extension,
  description: 'Monte a imagem completa',
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const JigsawPuzzleGame()),
  ),
),
```

### 2. Configurar Permissões (Para Upload de Imagens)

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" 
                 android:maxSdkVersion="32"/>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Precisamos acessar suas fotos para você escolher imagens para o quebra-cabeça</string>
```

---

## 🐛 Troubleshooting

### Erro: "Target of URI doesn't exist: package:image_picker"
**Solução**: Executar `flutter pub get`

### Imagens não aparecem
**Solução**: 
1. Verificar se `assets/images/` existe
2. Adicionar imagens com os nomes corretos
3. Executar `flutter pub get`
4. Reiniciar o app

### Galeria não abre
**Solução**: Verificar permissões no AndroidManifest.xml e Info.plist

### Peças não encaixam
**Solução**: Ajustar `SNAP_SENSITIVITY` (linha 13) - aumentar para facilitar, diminuir para dificultar

---

## 📊 Diferenças do Arquivo Original (`puzz2`)

| Aspecto | Original (`puzz2`) | Novo (`jigsaw_puzzle_game.dart`) |
|---------|-------------------|-----------------------------------|
| **Nome** | `puzz2` (sem extensão) | `jigsaw_puzzle_game.dart` |
| **Imagens** | URLs do Picsum (online) | Assets locais + galeria |
| **Áudio** | Sem integração | AudioService completo |
| **Recordes** | Sem salvamento | StorageService integrado |
| **Conquistas** | Não | AchievementService |
| **Dificuldade** | Fixo 3x3 | Selecionável (3x3, 4x4, 5x5) |
| **HUD** | Apenas título | Movimentos + peças encaixadas |
| **Spawn** | Aleatório (pode sobrepor tabuleiro) | Fora do tabuleiro |
| **Feedback** | Básico | Som + visual (borda verde) |
| **Grid** | Não | Grade de referência visual |

---

## 🎯 Próximos Passos Opcionais

1. **Adicionar imagens aos assets** (4 imagens de 500x500px)
2. **Testar em dispositivo real** (emulador pode ter performance ruim)
3. **Adicionar modo contra o tempo** (opcional)
4. **Salvar imagem completa** ao finalizar (opcional)
5. **Multiplayer**: Dois jogadores montando o mesmo quebra-cabeça (desafio)

---

## ✅ Checklist de Teste

- [ ] Executar `flutter pub get`
- [ ] Adicionar permissões no AndroidManifest.xml e Info.plist
- [ ] Testar seleção de dificuldade
- [ ] Testar upload de imagem da galeria
- [ ] (Opcional) Adicionar 4 imagens aos assets e testar seleção
- [ ] Arrastar peças e verificar encaixe
- [ ] Verificar sons (encaixe, vitória, cliques)
- [ ] Completar quebra-cabeça e verificar tela de vitória
- [ ] Verificar salvamento de recordes
- [ ] Testar botão de preview (mostrar/esconder gabarito)
- [ ] Testar botão de reiniciar

---

## 📝 Notas do Desenvolvedor

### Algoritmo de Geração das Abas

O sistema usa uma matriz de conexões aleatórias:
- **Vertical tabs**: Define se a aba direita de cada peça é `in (-1)` ou `out (1)`
- **Horizontal tabs**: Define se a aba inferior é `in` ou `out`
- **Peças vizinhas**: Sempre têm abas complementares (se A tem `out`, B tem `in`)
- **Bordas**: Sempre retas (`0`)

### Cálculo de Posição da Imagem

Cada peça usa `OverflowBox` + `Matrix4.translationValues` para:
1. Desenhar a imagem inteira
2. Transladar negativamente para mostrar apenas a "janela" correta
3. Recortar com `ClipPath` na forma do quebra-cabeça

### Performance

- **3x3**: ~9 peças, roda suave em qualquer dispositivo
- **4x4**: ~16 peças, bom em dispositivos médios
- **5x5**: ~25 peças, requer dispositivo razoável

---

**Arquivo original preservado**: `lib/screens/minigames/puzz2` (pode ser deletado após teste)

**Arquivo de produção**: `lib/screens/minigames/jigsaw_puzzle_game.dart`

---

🎉 **Jogo pronto para integração e teste!**
