# 📋 INSTRUÇÕES COMPLETAS PARA RECRIAR O JW QUIZ

## 🎯 OBJETIVO
Criar um aplicativo web de quiz bíblico interativo com múltiplos modos de jogo, sistema de pontuação avançado, jogo da memória e painel administrativo completo.

---

## 📊 VISÃO GERAL DO PROJETO

### Tipo de Aplicação
- **PWA (Progressive Web App)** instalável
- **Single Page Application (SPA)** com múltiplas views
- **Vanilla JavaScript** (sem frameworks)
- **Totalmente offline-first** com Service Worker
- **Responsivo** para mobile e desktop

### Funcionalidades Principais
1. **Quiz Bíblico** com 4 modos de jogo
2. **Jogo da Memória** com versículos
3. **Sistema de Pontuação** avançado
4. **Painel Administrativo** completo
5. **Estatísticas** detalhadas do jogador
6. **Tema Claro/Escuro**
7. **Música de fundo** e efeitos sonoros
8. **Conquistas/Achievements**

---

## 🗂️ ESTRUTURA DE ARQUIVOS

```
JW-Quiz/
├── index.html                 # Página principal (SPA)
├── manifest.json              # Configuração PWA
├── sw.js                      # Service Worker
│
├── CSS/
│   ├── style.css              # Estilos principais do quiz
│   ├── welcome-modern.css     # Tela inicial moderna
│   ├── admin.css              # Painel administrativo
│   └── components-tags.css    # Componentes de tags
│
├── JS/
│   ├── main.js                # Inicialização e navegação
│   ├── quiz.js                # Lógica do quiz
│   ├── admin.js               # Painel admin
│   ├── achievements.js        # Sistema de conquistas
│   ├── pointsCalc.js          # Cálculo de pontos
│   ├── audioManager.js        # Música e sons
│   ├── themeManager.js        # Tema claro/escuro
│   └── userIdentity.js        # Identificação do usuário
│
└── DATA/
    └── perguntas.json         # Base de dados (1180+ perguntas)
```

---

## 🎨 DESIGN E UI/UX

### Paleta de Cores (Tema Escuro Padrão)
```css
--bg-primary: #1a1a2e;           /* Fundo principal */
--bg-secondary: #16213e;         /* Cards e containers */
--bg-tertiary: #0f3460;          /* Hover e destaque */
--color-primary: #3a6ea5;        /* Azul principal */
--color-primary-600: #2b5482;    /* Azul escuro */
--text-primary: #e0e0e0;         /* Texto principal */
--text-secondary: #b0b0b0;       /* Texto secundário */
--success: #4caf50;              /* Verde sucesso */
--danger: #ef5350;               /* Vermelho erro */
```

### Layout Responsivo
- **Mobile-first** com breakpoints: 380px, 600px, 768px
- **Altura fixa 100vh** sem scroll externo
- **Footer sticky** sempre visível
- **Scroll interno** apenas na área de conteúdo

### Componentes Principais
1. **Welcome View** - Tela inicial com 2 botões grandes (Quiz e Jogo da Memória)
2. **Home View** - Menu do quiz com filtros de tema e dificuldade
3. **Quiz View** - Tela do quiz com timer e opções
4. **Admin View** - Painel de gerenciamento de perguntas
5. **Stats View** - Estatísticas do jogador
6. **Memory Game View** - Jogo da memória

---

## 📝 ESTRUTURA DE DADOS

### Formato das Perguntas (JSON)
```json
{
  "id": "10001",
  "pergunta": "Quem recebeu a ordem de Deus para construir uma arca?",
  "opcoes": ["Noé", "Moisés", "Abraão", "Davi"],
  "resposta_correta": "Noé",
  "tags": ["Bíblia", "Gênesis", "Noé"],
  "dificuldade": 1,
  "referencia": "Gênesis 6:13-14",
  "texto_biblico": "(13) Depois disso Deus disse a Noé: \"Decidi pôr um fim a toda a humanidade... (14) Faça para você uma arca de madeira resinosa.\""
}
```

### Campos Obrigatórios
- `id`: String única (ex: "10001")
- `pergunta`: String com a pergunta
- `opcoes`: Array com 4 opções de resposta
- `resposta_correta`: String exata de uma das opções
- `tags`: Array de strings para filtros
- `dificuldade`: Number (1=Fácil, 2=Médio, 3=Difícil)
- `referencia`: String com a referência bíblica
- `texto_biblico`: String com trecho da Bíblia (TNM)

---

## 🎮 MODOS DE JOGO

### 1. Quiz Rápido
- **10 perguntas** aleatórias
- **Timer dinâmico** (8s base + 0.5s por palavra)
- **Pontuação** por velocidade, streak e dificuldade
- **Auto-next** após 10s da resposta

### 2. Modo Estudo
- **Sem timer** (tempo ilimitado)
- **Sem penalidade** por erros
- **Explicações completas** após cada resposta
- **Ideal para aprendizado**

### 3. Modo Combate (2 Jogadores)
- **20 perguntas** compartilhadas
- **Toggle de pontos** (clica no jogador que acertou)
- **Botão Próxima** só habilitado após atribuir ponto
- **Placar final** com vencedor

### 4. Quiz Personalizado
- **Filtros por tema** (tags)
- **Filtros por dificuldade** (1, 2 ou 3)
- **Quantidade customizável** de perguntas
- **Embaralhamento** de opções

---

## 🏆 SISTEMA DE PONTUAÇÃO

### Cálculo de Pontos
```javascript
// Fórmula base
pontos = 1.0 + bonusVelocidade + bonusStreak

// Bônus de velocidade (0 a 0.1)
bonusVelocidade = (tempoRestante / tempoTotal) * 0.1

// Bônus de streak (0.01 por acerto consecutivo)
bonusStreak = streak * 0.01

// Multiplicador de dificuldade
// Fácil: 1.0x
// Médio: 1.2x
// Difícil: 1.5x

// Penalidade por erro
penalidade = -0.1
```

### Exemplo
```
Acerto em 5s (de 15s) com streak de 3 em questão difícil:
= (1.0 + 0.033 + 0.03) × 1.5
= 1.595 pontos
```

---

## 🧠 JOGO DA MEMÓRIA

### Configuração
- **Temas**: Animais, Frutas, Transportes, Vida Marinha, Aves, Números, Objetos, Natureza
- **Dificuldades**: 6, 10 ou 15 pares
- **Jogadores**: 1 a 4
- **Efeitos sonoros** opcionais

### Mecânica
1. Cards virados para baixo
2. Clique em 2 cards para revelar
3. Se forem iguais, ficam virados
4. Se diferentes, viram novamente
5. Timer opcional no modo solo
6. Contador de tentativas

---

## 👨‍💼 PAINEL ADMINISTRATIVO

### Funcionalidades
1. **Lista de Perguntas** com paginação (50 por página)
2. **Busca avançada** por ID, texto ou tags
3. **Filtros** por dificuldade e tag
4. **Editor inline** de perguntas
5. **Gerenciamento de tags** com contador de uso
6. **Deleção em massa** de tags com < 10 usos
7. **Backup automático** antes de salvar
8. **Download do JSON** atualizado

### Validações
- ID único e não vazio
- Pergunta com mínimo 10 caracteres
- Exatamente 4 opções
- Resposta correta deve estar nas opções
- Tags: máximo 5, mínimo 1
- Dificuldade: 1, 2 ou 3
- Referência e texto bíblico não vazios

---

## 🔊 ÁUDIO

### Música de Fundo
- **Home**: Música ambiente suave
- **Quiz**: Música de concentração
- **Vitória**: Fanfarra de celebração
- **Controles**: Toggle e slider de volume

### Efeitos Sonoros
- **Acerto**: Arpejo ascendente suave (0.8s)
- **Erro**: Thud grave discreto (0.5s)
- **Timer**: Tick-tick crescente (últimos 5s)
- **Vitória**: Fanfarra completa
- **Derrota**: Tom descendente

---

## 🌓 TEMA CLARO/ESCURO

### Implementação
```javascript
// themeManager.js
const THEME_KEY = 'jwquiz_theme';

function initTheme() {
  const saved = localStorage.getItem(THEME_KEY) || 'dark';
  document.documentElement.setAttribute('data-theme', saved);
}

function toggleTheme() {
  const current = document.documentElement.getAttribute('data-theme');
  const next = current === 'dark' ? 'light' : 'dark';
  document.documentElement.setAttribute('data-theme', next);
  localStorage.setItem(THEME_KEY, next);
}
```

### CSS Variables
```css
[data-theme="light"] {
  --bg-primary: #f0f2f5;
  --bg-secondary: #ffffff;
  --text-primary: #1a1a2e;
  /* ... */
}

[data-theme="dark"] {
  --bg-primary: #1a1a2e;
  --bg-secondary: #16213e;
  --text-primary: #e0e0e0;
  /* ... */
}
```

---

## 📊 ESTATÍSTICAS

### Dados Persistidos (LocalStorage)
```javascript
{
  "totalGames": 0,          // Total de jogos jogados
  "totalQuestions": 0,      // Total de perguntas respondidas
  "correctAnswers": 0,      // Total de acertos
  "wrongAnswers": 0,        // Total de erros
  "bestStreak": 0,          // Maior sequência
  "totalTime": 0,           // Tempo total jogado (ms)
  "fastestAnswer": 999999,  // Resposta mais rápida (ms)
  "categoryStats": {},      // Desempenho por categoria
  "difficultyStats": {      // Desempenho por dificuldade
    "1": {"correct": 0, "total": 0},
    "2": {"correct": 0, "total": 0},
    "3": {"correct": 0, "total": 0}
  }
}
```

### Exibição
- Cards com estatísticas gerais
- Gráficos de desempenho por categoria
- Barras de progresso por dificuldade
- Botões de exportar e resetar

---

## 🔄 NAVEGAÇÃO (SPA)

### Sistema de Views
```javascript
// Cada view tem class="view"
// Apenas uma view com class="active" por vez

function showView(viewId) {
  document.querySelectorAll('.view').forEach(v => {
    v.classList.remove('active');
  });
  document.getElementById(viewId).classList.add('active');
  window.scrollTo(0, 0);
}
```

### Views Principais
1. `welcome-view` - Tela inicial
2. `home-view` - Menu do quiz
3. `quiz-view` - Jogo do quiz
4. `memory-view` - Jogo da memória
5. `admin-view` - Painel admin
6. `stats-view` - Estatísticas
7. `legal-view` - Informações legais

---

## 📱 PWA (Progressive Web App)

### manifest.json
```json
{
  "name": "JW Quiz",
  "short_name": "JW Quiz",
  "description": "Quiz bíblico interativo",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#f0f2f5",
  "theme_color": "#2b6cb0",
  "orientation": "portrait",
  "icons": [
    {
      "src": "icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

### Service Worker (sw.js)
```javascript
const CACHE_NAME = 'jw-quiz-v1';
const urlsToCache = [
  '/',
  '/index.html',
  '/CSS/style.css',
  '/CSS/welcome-modern.css',
  '/JS/main.js',
  '/JS/quiz.js',
  '/DATA/perguntas.json'
];

// Install, activate, fetch handlers
```

---

## 🎯 FUNCIONALIDADES ESPECÍFICAS

### 1. Timer Dinâmico do Quiz
```javascript
// Tempo base + tempo por palavra
const BASE_TIME = 8;
const TIME_PER_WORD = 0.5;
const MAX_TIME = 30;

function calculateTime(question) {
  const wordCount = question.split(' ').length;
  return Math.min(BASE_TIME + (wordCount * TIME_PER_WORD), MAX_TIME);
}
```

### 2. Embaralhamento de Opções
```javascript
function shuffleArray(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}
```

### 3. Sistema de Tags Populares
```javascript
// Mostra 8 tags mais comuns
const popularTags = [
  'biblia', 'criancas', 'historias biblicas', 
  'jesus', 'profetas', 'apostolos', 
  'milagres', 'parabolas'
];
```

### 4. Modal de Confirmação (Quit Quiz)
```javascript
// Modal "Deseja voltar ao início?"
// Com checkbox "Não perguntar novamente"
// Persiste preferência no localStorage
```

### 5. Auto-Next com Countdown
```javascript
// Após responder, aguarda 10s e avança automaticamente
// Mostra contador regressivo
// Pode ser cancelado clicando em "Próxima"
```

---

## 🔐 ARMAZENAMENTO LOCAL

### LocalStorage Keys
```javascript
'jwquiz_theme'           // 'dark' ou 'light'
'jwquiz_stats'           // Objeto com estatísticas
'jwquiz_progress'        // Perguntas já respondidas
'jwquiz_music_enabled'   // Boolean
'jwquiz_music_volume'    // 0.0 a 1.0
'jwquiz_dont_ask_quit'   // Boolean
'jwquiz_achievements'    // Array de conquistas
```

---

## 🎨 COMPONENTES CSS REUTILIZÁVEIS

### Botões
```css
.btn {
  padding: 0.625rem 1rem;
  border-radius: 12px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-primary {
  background: linear-gradient(135deg, var(--color-primary), var(--color-primary-600));
  color: #fff;
}

.btn-secondary {
  background: var(--bg-tertiary);
  color: var(--text-primary);
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
```

### Cards
```css
.quiz-card {
  background: var(--bg-secondary);
  border-radius: 16px;
  padding: 1.5rem;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
}
```

### Modais
```css
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}

.modal-overlay.hidden {
  display: none;
}
```

---

## 📐 RESPONSIVIDADE

### Breakpoints
```css
/* Tablets */
@media (max-width: 768px) {
  /* Reduz fontes e espaçamentos */
}

/* Mobile */
@media (max-width: 600px) {
  /* Layout compacto */
}

/* Small Mobile */
@media (max-width: 380px) {
  /* Mínimos absolutos */
}
```

### Layout Flexbox
```css
#home-view {
  height: 100vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

#home-view .menu {
  flex: 1;
  overflow-y: auto;
  min-height: 0;
}

#home-view footer {
  flex-shrink: 0;
}
```

---

## 🚀 PERFORMANCE

### Otimizações
1. **Lazy loading** de imagens (se houver)
2. **Debounce** em busca do admin
3. **Paginação** de 50 perguntas por vez
4. **Cache** de perguntas no `window.allQuestions`
5. **Service Worker** para offline
6. **Minificação** de CSS/JS (opcional)

### Boas Práticas
- Evitar `innerHTML` desnecessários
- Usar `DocumentFragment` para múltiplas inserções
- Event delegation quando possível
- `requestAnimationFrame` para animações

---

## 🐛 TRATAMENTO DE ERROS

### Validações Frontend
```javascript
// Exemplo: validar pergunta antes de salvar
function validateQuestion(q) {
  if (!q.id || q.id.trim() === '') {
    throw new Error('ID não pode ser vazio');
  }
  if (!q.pergunta || q.pergunta.length < 10) {
    throw new Error('Pergunta muito curta (mín. 10 chars)');
  }
  if (!Array.isArray(q.opcoes) || q.opcoes.length !== 4) {
    throw new Error('Deve ter exatamente 4 opções');
  }
  if (!q.opcoes.includes(q.resposta_correta)) {
    throw new Error('Resposta correta não está nas opções');
  }
  // ... mais validações
  return true;
}
```

### Feedback Visual
- **Toast notifications** para ações rápidas
- **Modais de confirmação** para ações destrutivas
- **Loading overlays** para operações lentas
- **Estados de erro** com mensagens claras

---

## 📚 DEPENDÊNCIAS EXTERNAS

### Apenas Font Awesome (opcional)
```html
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
```

### Caso contrário: Vanilla JS puro
- Sem jQuery
- Sem React/Vue/Angular
- Sem bibliotecas de UI
- Apenas CSS e JS nativos

---

## 🔄 FLUXO PRINCIPAL DO APP

### 1. Inicialização (main.js)
```
DOMContentLoaded
  ↓
Carregar tema salvo
  ↓
Inicializar música
  ↓
Fetch perguntas.json
  ↓
Popular filtros (tags e dificuldade)
  ↓
Aguardar interação do usuário
```

### 2. Iniciar Quiz (quiz.js)
```
Usuário clica em "Iniciar Quiz"
  ↓
Filtrar perguntas (por tags/dificuldade se aplicável)
  ↓
Embaralhar perguntas
  ↓
Pegar N perguntas aleatórias
  ↓
Embaralhar opções de cada pergunta
  ↓
Mostrar primeira pergunta
  ↓
Iniciar timer
  ↓
Aguardar resposta
  ↓
[Loop] Próxima pergunta
  ↓
Mostrar resultado final
  ↓
Salvar estatísticas
```

### 3. Painel Admin (admin.js)
```
Usuário clica em "Admin"
  ↓
Carregar perguntas do window.allQuestions
  ↓
Popular tags no select
  ↓
Renderizar lista paginada
  ↓
Aguardar ações:
  - Busca
  - Filtro
  - Edição
  - Deleção de tags
  ↓
Salvar → Gerar JSON → Download
```

---

## 🎯 PONTOS DE ATENÇÃO

### 1. Modo Combate - Toggle de Pontos
```javascript
// Cada pergunta tem `pointAwarded: null | 1 | 2`
// Clicar no jogador 1: marca ponto para ele
// Clicar novamente: remove ponto
// Clicar no jogador 2: troca ponto para ele
// Botão Próxima só habilita se tiver ponto atribuído
```

### 2. Embaralhamento de Opções
```javascript
// SEMPRE embaralhar opcoes antes de renderizar
// Caso contrário, resposta correta sempre na mesma posição
question.opcoes = shuffleArray([...question.opcoes]);
```

### 3. Timer e Streak
```javascript
// Timer para cada pergunta individualmente
// Streak zera ao errar
// Streak persiste entre perguntas certas
// Bonus de streak é aditivo (0.01 por acerto)
```

### 4. LocalStorage e Backup
```javascript
// Antes de salvar, sempre fazer backup
const backup = localStorage.getItem('key');
// ... operação
// Se falhar, restaurar backup
```

### 5. Service Worker
```javascript
// Atualizar CACHE_NAME ao mudar arquivos
// Fazer cleanup de caches antigos no activate
// Usar network-first para perguntas.json
```

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### Fase 1: Estrutura Base
- [ ] Criar estrutura de pastas
- [ ] index.html com todas as views
- [ ] manifest.json e ícones
- [ ] Service Worker básico
- [ ] CSS base com variáveis de tema

### Fase 2: Quiz Básico
- [ ] Carregamento de perguntas (fetch)
- [ ] Sistema de navegação entre views
- [ ] Renderização de pergunta
- [ ] Sistema de timer
- [ ] Validação de resposta
- [ ] Cálculo de pontos
- [ ] Tela de resultado

### Fase 3: Modos de Jogo
- [ ] Quiz Rápido (10 perguntas)
- [ ] Modo Estudo (sem timer)
- [ ] Modo Combate (2 jogadores)
- [ ] Filtros por tag e dificuldade

### Fase 4: Jogo da Memória
- [ ] Geração de cards
- [ ] Lógica de matching
- [ ] Timer e contador de tentativas
- [ ] Suporte multi-jogador

### Fase 5: Painel Admin
- [ ] Lista paginada de perguntas
- [ ] Busca e filtros
- [ ] Editor inline
- [ ] Validações
- [ ] Gerenciamento de tags
- [ ] Download de JSON

### Fase 6: Features Avançadas
- [ ] Sistema de estatísticas
- [ ] Conquistas/Achievements
- [ ] Música e efeitos sonoros
- [ ] Tema claro/escuro
- [ ] PWA instalável

### Fase 7: Polimento
- [ ] Responsividade completa
- [ ] Animações e transições
- [ ] Acessibilidade (ARIA)
- [ ] Tratamento de erros
- [ ] Testes em dispositivos reais

---

## 🎨 SUGESTÕES DE MELHORIA

### UX
- Adicionar confetes na tela de vitória
- Animações de entrada/saída nas views
- Feedback tátil (vibração em mobile)
- Tutorial interativo na primeira vez

### Features
- Ranking global (com backend)
- Compartilhar resultado nas redes sociais
- Modo multiplayer online
- Perguntas do dia (daily challenge)
- Sistema de badges/medalhas

### Técnico
- Migrate para TypeScript
- Testes unitários (Jest)
- CI/CD com GitHub Actions
- Analytics de uso
- A/B testing de features

---

## 📞 CONSIDERAÇÕES FINAIS

### Pontos Fortes do Projeto
✅ Totalmente offline-first  
✅ Zero dependências (além de Font Awesome)  
✅ Performance otimizada  
✅ Acessível (ARIA labels)  
✅ Responsivo mobile-first  
✅ Código bem documentado  
✅ Fácil de manter e expandir  

### Desafios Conhecidos
⚠️ Gerenciamento manual do JSON (sem backend)  
⚠️ Sem sincronização entre dispositivos  
⚠️ Limite de 5-10MB no LocalStorage  
⚠️ Service Worker pode causar cache issues  

### Próximos Passos
1. Migrar dados para backend (Firebase/Supabase)
2. Adicionar autenticação de usuários
3. Implementar ranking global
4. Criar API REST para perguntas
5. Adicionar modo multiplayer real-time

---

## 🔧 COMANDOS ÚTEIS

### Desenvolvimento Local
```bash
# Python 3
python -m http.server 8000

# Node.js
npx http-server -p 8000

# PHP
php -S localhost:8000
```

### Git
```bash
git add .
git commit -m "feat: descrição da feature"
git push origin main
```

### Deploy GitHub Pages
```bash
# Já está configurado para branch main
# Apenas push e aguarde build automático
```

---

## 📄 LICENÇA E CRÉDITOS

- **Licença**: MIT
- **Autor Original**: Lenire Denis
- **Repositório**: https://github.com/leniredenis-bit/JW-Quiz
- **Textos Bíblicos**: Tradução do Novo Mundo (TNM)

---

## 🎯 PROMPT RESUMIDO PARA OUTRA IA

```
Crie um Progressive Web App de quiz bíblico com as seguintes especificações:

TECNOLOGIAS:
- HTML5, CSS3, JavaScript vanilla (sem frameworks)
- PWA com Service Worker
- LocalStorage para persistência
- Responsivo mobile-first

ESTRUTURA:
- Single Page Application com 7 views
- Arquivo JSON com 1180+ perguntas bíblicas
- Sistema de navegação entre views

FUNCIONALIDADES PRINCIPAIS:
1. Quiz com 4 modos (Rápido, Estudo, Combate, Personalizado)
2. Jogo da Memória com versículos
3. Sistema de pontuação avançado (velocidade + streak + dificuldade)
4. Painel administrativo completo para gerenciar perguntas
5. Estatísticas detalhadas do jogador
6. Tema claro/escuro
7. Música de fundo e efeitos sonoros
8. Sistema de conquistas/achievements

DESIGN:
- Tema escuro padrão com gradientes azuis
- Botões grandes e amigáveis para mobile
- Animações suaves e feedback visual
- Layout 100vh sem scroll externo
- Footer sticky sempre visível

FORMATO DE DADOS:
Cada pergunta tem: id, pergunta, opcoes (array de 4), resposta_correta, tags (array), dificuldade (1-3), referencia, texto_biblico

CARACTERÍSTICAS ESPECIAIS:
- Timer dinâmico baseado em tamanho da pergunta
- Embaralhamento de opções a cada renderização
- Toggle de pontos no modo combate
- Auto-next com countdown de 10s
- Backup automático antes de salvar no admin
- Validações completas de dados

Use o documento INSTRUCOES_PARA_IA.md como referência completa.
```

---

**FIM DO DOCUMENTO**

*Última atualização: 08/11/2025*
*Versão: 1.0*
