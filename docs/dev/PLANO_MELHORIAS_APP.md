# 🛠️ Plano de Melhorias do App (fora dos minigames)

Passo a passo aprovado em 22/10/2026. Cada etapa termina com `flutter analyze` limpo, testes passando e capturas de tela revisadas nos **dois temas** (claro e escuro) e nos **3 idiomas**.

Legenda: ✅ a fazer · ✅ feito

---

## Etapa 0 — Fundação (base para todo o resto)

### 0.1 Tema central (claro + escuro de verdade)
- ✅ Criar `lib/theme/app_theme.dart` com uma **paleta por tema** (`AppPalette`):
  fundo, superfície (cartões), superfície alternativa, borda, texto principal, texto secundário,
  destaque (azul do app), sucesso, erro, dourado.
- ✅ Regras de contraste (WCAG AA): texto principal ≥ 7:1 sobre o fundo, texto secundário ≥ 4.5:1,
  **todo cartão/botão tem borda visível** (nunca depende só da cor de fundo para aparecer).
- ✅ `ThemeService` (salvo em `darkTheme`) ligado ao `MaterialApp` (`theme`, `darkTheme`, `themeMode`).
  O interruptor das Configurações passa a mudar o app inteiro, na hora.
- ✅ Minigames: continuam com visual de "jogo" escuro em ambos os temas (decisão de design,
  é o mesmo padrão de jogos populares). O menu de minigames segue o tema do app.

### 0.2 Textos e idiomas
- ✅ Mover o helper `t3()` para `lib/utils/i18n.dart` (usado pelo app inteiro, não só minigames).
- ✅ Varredura de **todos** os textos fixos em português nas telas e traduzir (PT/EN/ES).
- ✅ `Question.getDificuldadeTexto()` traduzido.

### 0.3 Tamanhos que se adaptam à tela
- ✅ Conteúdo com **largura máxima** (~640px) e centralizado em telas largas (web, tablet).
- ✅ Ícones/emojis dos cartões **proporcionais ao tamanho do cartão** (ex.: no menu de minigames
  o emoji ocupa ~30% do cartão), em vez de tamanho fixo.
- ✅ Grades com número de colunas pela largura disponível (2 no celular, 3–4 em telas largas).

### 0.4 Áudio, segundo plano e preferências
- ✅ **Pausar música e timers quando o app vai para segundo plano** e retomar ao voltar.
- ✅ Aplicar volumes salvos ao abrir o app (hoje só aplicava ao abrir as Configurações).
- ✅ Preferências novas: **tamanho do texto** (Normal/Grande), **vibração** liga/desliga.

---

## Etapa 1 — Quiz Clássico

- ✅ **Barra de tempo animada** (verde → amarelo → vermelho só nos últimos 25%), pulsando no fim.
- ✅ Mantida a fórmula do timer (palavras ÷ 2 + 10s, entre 10 e 60s) + **+5s nas difíceis**.
- ✅ **Modo Estudo** (sem tempo), escolhido antes de começar.
- ✅ Alternativas com **letras A/B/C/D**, entrada animada, certa "pula", errada treme.
- ✅ **Sequência de acertos** (🔥 x3) com bônus de pontos e som de combo.
- ✅ Remover o ID interno ("Pergunta #10001"); mostrar dificuldade traduzida e tema.
- ✅ Texto da pergunta se ajusta à tela (perguntas longas não espremem as alternativas).
- ✅ **Tempo esgotado**: registra nas estatísticas, toca som, mostra "Tempo esgotado! A resposta era…"
  com a explicação (antes só pintava a certa de verde).
- ✅ Caixa de explicação mais rica: "✔ Você acertou / ✘ A resposta certa é…" + referência em destaque.
- ✅ **Confirmação ao sair** no meio do quiz.
- ✅ **Tela final nova**: estrelas, confete, pontuação, **revisão das perguntas erradas** (com referência),
  "Jogar de novo" e "Menu".

## Etapa 2 — Tela inicial, Pergunta do Dia e abertura

- ✅ **Cabeçalho**: saudação conforme a hora, sequência de dias jogados 🔥 e total de pontos.
- ✅ **Pergunta do Dia** (cartão na Home):
  - mesma pergunta para todos no mesmo dia (sorteio pela data);
  - arquivo `assets/data/pergunta_do_dia.json` permite **programar** a pergunta de cada data
    (para alinhar com o texto diário no futuro);
  - responde ali mesmo, mostra a referência e um botão **"Ler o texto diário"** que abre o texto
    do dia no site oficial (wol.jw.org) no idioma do app — sem copiar o conteúdo;
  - guarda se já respondeu hoje e a sequência de dias.
- ✅ **Quiz Clássico em destaque** (cartão grande) e demais modos em cartões coloridos.
- ✅ Filtros (dificuldade/tema/modo estudo) numa janela **"Personalizar"** ao iniciar o quiz
  (vale para o Clássico e o Torta na Cara).
- ✅ Engrenagem de configurações no topo (sai o botão flutuante).
- ✅ Tela de boas-vindas **só na primeira vez**; depois, abertura direta na Home.
- ✅ Juntar o código duplicado que inicia o quiz.

## Etapa 3 — Demais telas

- ✅ **Torta na Cara**: nomes dos jogadores, placar vibrante, **animação de torta** em quem errar,
  tela de campeão.
- ✅ **Estatísticas**: estado vazio amigável, **gráfico de evolução** dos últimos quizzes,
  temas fortes e fracos, cores do tema.
- ✅ **Conquistas**: "próximas conquistas" em destaque, entrada animada, cores do tema.
- ✅ **Configurações**: tema real, tamanho do texto, vibração, **zerar progresso** (com confirmação),
  versão lida do app.
- ✅ **Multiplayer** (7 telas): textos traduzidos, info "até 100 jogadores" corrigida, menu rolável em celular pequeno.
  Decisão: como os minigames, as telas de partida mantêm o visual escuro de jogo em ambos os temas
  (`GameDarkTheme`), o que garante o contraste de diálogos, botões e campos.
- ✅ **Sobre / Termos**: cores do tema.

## Etapa 4 — Qualidade

- ✅ Testes: timer/tempo esgotado do quiz, Pergunta do Dia (mesma pergunta no mesmo dia),
  abertura de todas as telas nos 2 temas sem estouro de layout.
- ✅ Revisão de contraste com capturas: claro × escuro em todas as telas.
- ✅ Atualizar `CHANGELOG.md`, `PLANO_LANCAMENTO.md` e este arquivo.

## Resultado

- Tema claro e escuro reais, com contraste verificado numericamente (texto ≥ 4.5:1) e bordas em todos os cartões.
- Defeitos encontrados e corrigidos no caminho: botões azuis antigos com contraste 3,3:1; cartões do menu de
  minigames com texto branco sobre cores claras (até 1,9:1); estrelas vazias invisíveis no fundo claro;
  Estatísticas mostrando contadores internos e códigos ("QUIZ_NORMAL"); barras de progresso das Conquistas
  sem largura; menu Online cortado em celular pequeno; textos fixos em português no Criar Sala;
  controladores de animação criados durante o fechamento (Torta na Cara e Caça-Palavras).
- Testes: `test/app_screens_test.dart` abre todas as telas do app nos 2 temas num celular de 360×640 e
  verifica Pergunta do Dia, timer (+5s nas difíceis) e tempo esgotado. Total: 45 testes passando.
