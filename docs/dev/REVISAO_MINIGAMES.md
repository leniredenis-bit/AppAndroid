# 🎮 Revisão Completa dos Minigames (out/2026)

Análise de cada jogo + lista de tarefas executadas. **Status: ✅ todas as tarefas abaixo foram implementadas em 21/10/2026.** Defeitos antigos vieram de
`docs/archive/status_2025/ajustesapp.md`, `MELHORIAS_EM_ANDAMENTO.md` e `dev_historico/MELHORIAS_AUDIO_PENDENTES.md`.

## Problemas gerais encontrados
| # | Problema | Impacto |
|---|---|---|
| G1 | **Nenhum efeito sonoro existia** (`assets/audio/sfx/` vazia, código desligado com `return`) | Jogos "mudos", sem feedback |
| G2 | Textos fixos em português em quase todos os jogos | Inglês/espanhol quebrados |
| G3 | `setState` após sair da tela (timers/delays sem `mounted`) | Erros/crash ao sair no meio |
| G4 | Cada jogo com visual diferente (alguns claros, outros escuros) | App parece "colcha de retalhos" |
| G5 | Conquistas: `mestre_puzzles` nunca desbloqueia (id errado), "Explorador" conta partidas e não jogos distintos, Memória e Caça-Palavras não registram conquistas | Conquistas impossíveis |
| G6 | Dois jogos de sequência quase iguais ("Rápida" e "Cristal") | Menu repetitivo |

## Por jogo

### 🧠 Memória
- ❌ Sem animação de virar (só troca de cor); "Todos" pode repetir emoji; grade difícil rola para fora da tela; textos PT fixos
- ✅ Tarefas: virada 3D, verso decorado, tremida no erro, brilho no acerto, combo, estrelas por desempenho, grade que sempre cabe, espiar no início (fácil), conquista "Memória Fotográfica" (sem erros), tradução

### ⭕ Jogo da Velha Neon
- ❌ IA "Hard" imbatível e "Easy" aleatória (sem meio-termo); sem mensagem de resultado; jogada da IA podia acontecer após reiniciar; rótulos em inglês fixos
- ✅ Tarefas: 3 níveis de IA (Fácil/Médio/Difícil), faixa de resultado animada, células vencedoras pulsando, alternância de quem começa, cancelamento seguro da IA, placar por sessão, tradução

### 🎯 Forca
- ❌ **Palavras com acento impossíveis** (ES: MOISÉS, teclado sem É); sem forca desenhada (só o boneco); só 20 palavras sem dica
- ✅ Tarefas: cena completa (forca de madeira, corda, personagem detalhado com expressões), comemoração/balanço, banco de palavras com **dica e categoria** nos 3 idiomas, acento-insensível, botão de dica (revela letra), sequência de vitórias, teclado físico

### 🔍 Caça-Palavras
- ❌ **Palavra que não coube na grade continuava na lista → jogo impossível de terminar**; letras acentuadas "denunciavam" as palavras; tema claro destoante; "JORDAN" em português
- ✅ Tarefas: posicionamento garantido, acentos normalizados, 3 dificuldades (tamanho, diagonais, invertidas), tema escuro, chips coloridos iguais à linha, dica, cronômetro, seleção por arraste **ou** toque-toque, conquistas

### 🌀 Labirinto
- ❌ Saída desenhada no lugar errado (linha/coluna trocadas); câmera recriada a cada quadro; movimento travado; nível da campanha perdido ao sair
- ✅ Tarefas: movimento suave interpolado, **deslize = corre até a próxima bifurcação**, D-pad com segurar, teclado (setas/WASD), câmera que segue suave, tocha/neblina na caverna, gemas colecionáveis (estrelas), cronômetro, progresso salvo, renderização em cache

### 💎 Sequência Cristal (fusão dos 2 jogos)
- ❌ Aleatoriedade fraca (`millis % 4`), layout estourava em telas pequenas, cristais travados aparecendo no modo fácil, textos PT
- ✅ Tarefas: **um único jogo** com cristais em círculo, **cada cristal toca uma nota musical**, modos Clássico (4), Mestre (6) e Progressivo (4→9), velocidade crescente, segunda chance, indicador de progresso, recordes por modo

### 🧩 Quebra-Cabeça (reescrito)
- ❌ Saliências cortadas (encaixe "reto × redondo"), posição correta calculada com valor fixo (peça travava fora do lugar), peças empilhadas em tamanho cheio, toque pegava a caixa e não o formato da peça
- ✅ Tarefas: geometria de encaixe clássica e simétrica, **toque preciso no formato da peça**, bandeja com peças pequenas que crescem ao pegar, encaixe magnético com animação, silhuetas no tabuleiro, espiar imagem, 4 dificuldades (9–36 peças), cronômetro, estrelas, "organizar bandeja", relevo 3D nas peças

### 🎨 Colorir (NOVO)
- Desenhos vetoriais bíblicos/natureza, balde de tinta por região, pincel livre, borracha, desfazer/refazer, paleta rica + tons, cores com brilho (gradiente), zoom com dois dedos, progresso salvo, celebração ao completar e **"transformar em quebra-cabeça"**

## Infraestrutura nova
- `lib/screens/minigames/common/`: kit visual (scaffold, HUD, overlay de resultado com estrelas e confete), textos 3 idiomas, registro de resultado + conquistas
- `scripts/generate_sfx.py`: sons sintetizados próprios (sem licença de terceiros) → `assets/audio/sfx/*.wav`
- Menu dos minigames redesenhado (recordes, selo "Novo", animação de entrada)

## Verificação
- `flutter analyze`: sem avisos
- `test/minigames_smoke_test.dart`: abre os 8 jogos + menu num celular de 360×640 e garante que não há erro nem estouro de layout
- Capturas de tela revisadas durante o desenvolvimento (desenhos, cenas e layout)

## Colorir: importar desenhos (`coloring_lineart.dart`)
1. A imagem escolhida é reduzida para no máximo 900×900, centralizada num quadrado branco e convertida em tons de cinza.
2. Pixels com luminância < 150 são "linha". As linhas são engrossadas 1px **só para separar as áreas**, o que fecha falhas pequenas e impede a tinta de vazar.
3. As áreas brancas conectadas viram regiões (preenchimento por inundação). Os pixels do engrossamento voltam para a região vizinha, para não sobrar contorno branco.
4. A pintura é uma imagem gerada a partir das cores de cada região. As linhas originais (com bordas suaves) ficam por cima.
5. O desenho é salvo como PNG em tons de cinza. Ao reabrir, o processamento é refeito e gera as mesmas regiões, por isso as cores salvas continuam no lugar.
- Imagens com mais de 350 áreas (fotos, por exemplo) geram um aviso, porque o recurso funciona melhor com páginas de livro de colorir.
- Teste automático: `test/coloring_lineart_test.dart`.

## Próximos passos sugeridos
- Testar no aparelho: sensação do toque no quebra-cabeça, velocidade do deslizar no labirinto, volume dos efeitos
- Mais desenhos para colorir (Davi e Golias, Jardim do Éden, Moisés no mar…)
- Salvar a pintura na galeria do celular (exige plugin + permissão)
