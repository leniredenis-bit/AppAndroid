# 📝 DOCUMENTAÇÃO COMPLETA - QUIZ BÍBLICO
**JW Quiz - Biblical Quiz System**  
**Data:** 03/11/2025  
**Versão:** 1.0

---

## 📋 ÍNDICE
1. [Visão Geral](#visão-geral)
2. [Arquitetura](#arquitetura)
3. [Código HTML](#código-html)
4. [Código CSS](#código-css)
5. [Código JavaScript](#código-javascript)
6. [Estrutura de Dados](#estrutura-de-dados)
7. [Fluxo de Jogo](#fluxo-de-jogo)
8. [Sistema de Analytics](#sistema-de-analytics)
9. [Melhorias Sugeridas](#melhorias-sugeridas)

---

## 🎯 VISÃO GERAL

### Funcionalidades Principais
- ✅ **Base de 3593 perguntas bíblicas**: Carregadas de arquivo JSON externo
- ✅ **Múltiplos modos de jogo**:
  - Quiz Rápido (10 perguntas aleatórias)
  - Modo Estudo (sem timer, com explicações)
  - Quiz por Tema (filtrado por tags)
  - Quiz por Dificuldade (★, ★★, ★★★)
  - Partida em Grupo (multiplayer online)
- ✅ **Sistema de filtros dinâmicos**: Tags e dificuldades geradas automaticamente do JSON
- ✅ **Timer visual**: Barra de progresso animada
- ✅ **Feedback visual**: Animações para acerto/erro
- ✅ **Referências bíblicas**: Mostra versículo e texto completo (TNM)
- ✅ **Sistema de estatísticas**: LocalStorage com analytics avançado
- ✅ **Sistema de notificações Toast**: 4 tipos (success, error, warning, info)
- ✅ **Tema escuro/claro**: Persistente com CSS Variables
- ✅ **PWA Ready**: Service Worker, offline-first
- ✅ **Responsivo**: Mobile-first design
- ✅ **Acessibilidade**: ARIA labels, roles, focus management

### Tecnologias Utilizadas
- **HTML5**: Estrutura semântica, roles ARIA
- **CSS3**: Variáveis CSS, Animações, Grid, Flexbox
- **JavaScript ES6+**: Async/await, Modules, Arrow Functions
- **localStorage**: Persistência de dados (stats, analytics, preferências)
- **Fetch API**: Carregamento de perguntas JSON
- **Service Worker**: PWA, cache offline
- **Web APIs**: Intl.DateTimeFormat, Navigator

---

## 🏗️ ARQUITETURA

### Estrutura de Arquivos
```
quiz-biblico/
├── index.html              # Estrutura HTML completa (659 linhas)
├── CSS/
│   └── style.css          # Estilos completos (1393 linhas)
├── JS/
│   ├── main.js            # Controlador principal (1584 linhas)
│   └── toast.js           # Sistema de notificações (141 linhas)
├── DATA/
│   └── perguntas.json     # Base de perguntas (3593 linhas)
└── sw.js                   # Service Worker para PWA
```

### Componentes Principais

#### 1. Welcome View (Tela de Boas-vindas)
- Hero section com gradiente
- 3 botões principais: Quiz, Jogo da Memória, Estatísticas
- Toggle de tema (sol/lua)
- Animações de entrada

#### 2. Home View (Menu Principal)
- Botões de ação rápida
- Filtros por tema (tags dinâmicas)
- Filtros por dificuldade (★☆☆)
- Botões de navegação (estatísticas, legal)

#### 3. Quiz View (Tela do Quiz)
- Header com progresso e timer
- Área de pergunta
- 4 opções de resposta
- Área de referência bíblica (expansível)
- Contador de auto-avanço

#### 4. Stats View (Estatísticas)
- Total de quizzes completados
- Taxa de acerto geral
- Progresso por dificuldade
- Temas mais jogados
- Gráficos visuais

#### 5. Group View (Partida em Grupo)
- Criar partida (gera código)
- Entrar na partida (via código)
- Sala de espera
- Quiz sincronizado em tempo real
- Placar multiplayer

#### 6. Legal View (Informações Legais)
- Política de privacidade
- Termos de uso
- Créditos

---

## 📝 CÓDIGO HTML

### Estrutura Básica
```html
<!DOCTYPE html>
<html lang="pt-BR" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JW Quiz - Quiz Bíblico Interativo</title>
    <link rel="stylesheet" href="CSS/style.css">
    <link rel="manifest" href="manifest.json">
    <meta name="theme-color" content="#3a6ea5">
    <!-- PWA Meta Tags -->
</head>
<body>
    <!-- Welcome View -->
    <section id="welcome-view" class="view active">
        <div class="welcome-hero">
            <div class="welcome-content">
                <h1 class="welcome-title">JW Quiz</h1>
                <p class="welcome-subtitle">Quiz Bíblico Interativo</p>
                
                <div class="welcome-buttons">
                    <button id="welcome-quiz-btn" class="welcome-btn">
                        <span class="welcome-btn-icon">📖</span>
                        <span class="welcome-btn-text">Quiz Bíblico</span>
                        <span class="welcome-btn-desc">Teste seus conhecimentos</span>
                    </button>
                    
                    <button id="welcome-memory-btn" class="welcome-btn">
                        <span class="welcome-btn-icon">🧠</span>
                        <span class="welcome-btn-text">Jogo da Memória</span>
                        <span class="welcome-btn-desc">Desafie sua memória</span>
                    </button>
                    
                    <button id="welcome-stats-btn" class="welcome-btn">
                        <span class="welcome-btn-icon">📊</span>
                        <span class="welcome-btn-text">Minhas Estatísticas</span>
                        <span class="welcome-btn-desc">Veja seu progresso</span>
                    </button>
                </div>
                
                <button id="welcome-theme-toggle" class="theme-toggle-welcome">
                    <span class="theme-icon">🌙</span>
                </button>
            </div>
        </div>
    </section>

    <!-- Home View (Menu Principal) -->
    <section id="home-view" class="view">
        <header class="app-header">
            <button id="back-to-welcome" class="btn btn-link">🏠 Início</button>
            <h1>JW Quiz</h1>
        </header>

        <main class="menu">
            <div class="buttons-row">
                <button id="start-quick-quiz-btn" class="btn btn-primary">
                    ▶️ Iniciar Quiz Rápido
                </button>
                <button id="start-study-mode-btn" class="btn btn-secondary">
                    📚 Modo Estudo
                </button>
                <button id="start-multiplayer-btn" class="btn btn-secondary">
                    🏆 Partida em Grupo
                </button>
            </div>

            <div class="stats-row">
                <button id="show-stats-btn" class="btn btn-link">
                    📊 Minhas Estatísticas
                </button>
            </div>

            <div class="filter-section">
                <h2>Quiz por Tema</h2>
                <div id="tags-container" class="tags-container">
                    <!-- Gerado dinamicamente pelo JavaScript -->
                </div>
            </div>

            <div class="filter-section">
                <h2>Quiz por Dificuldade</h2>
                <div id="difficulty-container" class="difficulty-container">
                    <!-- Gerado dinamicamente pelo JavaScript -->
                </div>
            </div>

            <footer>
                <button id="manage-content-btn" class="btn btn-link" disabled>
                    Gerenciar Perguntas
                </button>
                <button id="legal-btn" class="btn btn-link">
                    ℹ️ Legal
                </button>
                <button id="theme-toggle" class="theme-toggle-btn">
                    🌙 modo escuro
                </button>
            </footer>
        </main>
    </section>

    <!-- Quiz View -->
    <section id="quiz-view" class="view">
        <div class="quiz-card">
            <div class="quiz-header">
                <div id="quiz-progress" class="quiz-progress">
                    Pergunta 1 de 10
                </div>
                <div id="quiz-timer" class="quiz-timer">
                    <div id="timer-bar" class="timer-bar"></div>
                    <div id="timer-text" class="timer-text">--s</div>
                </div>
            </div>

            <div id="question-area" class="question-area">
                <h2 id="question-text">Pergunta aparece aqui</h2>
            </div>

            <div id="options-container" class="options-container">
                <!-- Botões gerados dinamicamente -->
            </div>

            <div class="quiz-footer">
                <button id="next-btn" class="btn btn-primary" disabled>
                    Próxima
                </button>
                <button id="quit-btn" class="btn btn-secondary">
                    Sair
                </button>
            </div>

            <div id="reference-area" class="reference-area hidden">
                <div class="reference-title">Resposta correta:</div>
                <div id="correct-answer" class="correct-answer"></div>
                <div class="reference-title">Referência:</div>
                <div id="reference-text" class="reference-text"></div>
                <div class="reference-title">Texto Bíblico (TNM):</div>
                <div id="biblical-text" class="biblical-text"></div>
                <div id="auto-next-counter" class="auto-next-counter">
                    <span>Próxima pergunta em </span>
                    <span id="auto-next-text">10</span>
                    <span> segundos...</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Toast Container (Sistema de Notificações) -->
    <div id="toast-container" class="toast-container" aria-live="polite" aria-atomic="true"></div>

    <script src="JS/toast.js"></script>
    <script src="JS/main.js"></script>
</body>
</html>
```

---

## 🎨 CÓDIGO CSS

### Variáveis CSS (Tema Claro/Escuro)
```css
:root {
    /* Cores Primárias */
    --bg-primary: #ffffff;
    --bg-secondary: #f5f7fa;
    --bg-accent: #e8f4f8;
    --text-primary: #2c3e50;
    --text-secondary: #7f8c8d;
    --text-accent: #3a6ea5;
    
    /* Bordas e Sombras */
    --border-primary: #dfe6e9;
    --border-accent: #3a6ea5;
    --shadow-primary: rgba(0, 0, 0, 0.1);
    
    /* Botões */
    --btn-primary: #3a6ea5;
    --btn-secondary: #95a5a6;
    --btn-hover: #2c5282;
    
    /* Estados de Resposta */
    --correct-bg: #d4edda;
    --correct-border: #28a745;
    --correct-text: #155724;
    --wrong-bg: #f8d7da;
    --wrong-border: #dc3545;
    --wrong-text: #721c24;
    
    /* Transitions */
    --transition-fast: 0.2s ease;
    --transition-normal: 0.3s ease;
}

[data-theme="dark"] {
    --bg-primary: #1a1a2e;
    --bg-secondary: #16213e;
    --bg-accent: #0f3460;
    --text-primary: #eee;
    --text-secondary: #b0b0b0;
    --text-accent: #6ab5e7;
    
    --border-primary: #2c3e50;
    --border-accent: #6ab5e7;
    --shadow-primary: rgba(0, 0, 0, 0.5);
    
    --btn-primary: #6ab5e7;
    --btn-secondary: #5a6a7a;
    --btn-hover: #4a9fd8;
    
    --correct-bg: #1e4620;
    --correct-border: #4caf50;
    --correct-text: #90ee90;
    --wrong-bg: #4a1e1e;
    --wrong-border: #f44336;
    --wrong-text: #ff9999;
}
```

### Animações Principais
```css
/* Animação de Acerto */
@keyframes correct {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.05); }
}

/* Animação de Erro */
@keyframes shake {
    0%, 100% { transform: translateX(0); }
    25% { transform: translateX(-10px); }
    75% { transform: translateX(10px); }
}

/* Fade In */
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}

/* Timer Bar */
@keyframes timer-countdown {
    from { width: 100%; background: #4caf50; }
    to { width: 0%; background: #f44336; }
}
```

### Componentes Principais
```css
/* Botões de Opção */
.option-btn {
    width: 100%;
    padding: 1rem;
    margin: 0.5rem 0;
    border: 2px solid var(--border-primary);
    border-radius: 12px;
    background: var(--bg-secondary);
    color: var(--text-primary);
    font-size: 1rem;
    text-align: left;
    cursor: pointer;
    transition: all var(--transition-fast);
}

.option-btn:hover {
    background: var(--bg-accent);
    border-color: var(--border-accent);
    transform: translateX(4px);
}

.option-btn.correct {
    background: var(--correct-bg);
    border-color: var(--correct-border);
    color: var(--correct-text);
    animation: correct 0.5s ease;
}

.option-btn.wrong {
    background: var(--wrong-bg);
    border-color: var(--wrong-border);
    color: var(--wrong-text);
    animation: shake 0.5s ease;
}

/* Timer Visual */
.timer-bar {
    position: absolute;
    top: 0;
    left: 0;
    height: 100%;
    background: linear-gradient(90deg, #4caf50, #ffc107, #f44336);
    transition: width 0.1s linear;
    border-radius: 8px;
}

/* Tags de Tema */
.tag-btn {
    padding: 0.5rem 1rem;
    margin: 0.25rem;
    border: 2px solid var(--border-primary);
    border-radius: 20px;
    background: var(--bg-secondary);
    color: var(--text-primary);
    cursor: pointer;
    transition: all var(--transition-fast);
}

.tag-btn:hover {
    background: var(--btn-primary);
    color: white;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px var(--shadow-primary);
}

/* Botões de Dificuldade */
.difficulty-btn {
    padding: 0.75rem 1.5rem;
    margin: 0.5rem;
    border: 2px solid var(--border-primary);
    border-radius: 12px;
    background: var(--bg-secondary);
    font-size: 1.5rem;
    cursor: pointer;
    transition: all var(--transition-fast);
}

.difficulty-easy { color: #4caf50; }
.difficulty-medium { color: #ffc107; }
.difficulty-hard { color: #f44336; }

/* Sistema Toast */
.toast {
    min-width: 250px;
    padding: 1rem 1.5rem;
    margin-bottom: 1rem;
    border-radius: 8px;
    box-shadow: 0 4px 12px var(--shadow-primary);
    animation: slideInRight 0.3s ease;
}

.toast.success { background: var(--correct-bg); color: var(--correct-text); }
.toast.error { background: var(--wrong-bg); color: var(--wrong-text); }
.toast.warning { background: #fff3cd; color: #856404; }
.toast.info { background: var(--bg-accent); color: var(--text-primary); }
```

---

## 💻 CÓDIGO JAVASCRIPT

### Estrutura Principal (main.js)

#### 1. Inicialização
```javascript
document.addEventListener('DOMContentLoaded', function() {
    // Elementos do DOM
    const views = document.querySelectorAll('.view');
    const homeView = document.getElementById('home-view');
    const tagsContainer = document.getElementById('tags-container');
    const difficultyContainer = document.getElementById('difficulty-container');

    // Dados compartilhados
    window.allQuestions = [];

    // Função de navegação
    function showView(viewId) {
        views.forEach(view => view.classList.remove('active'));
        const el = document.getElementById(viewId);
        if (el) el.classList.add('active');
        window.scrollTo(0, 0);

        if (viewId === 'home-view' && window.allQuestions.length > 0) {
            populateFilters();
        }
    }
    window.showView = showView;

    // Carregar perguntas
    loadQuestions();
});
```

#### 2. Carregamento de Perguntas
```javascript
async function loadQuestions() {
    try {
        const res = await fetch('DATA/perguntas.json');
        if (!res.ok) throw new Error(`HTTP error ${res.status}`);
        
        const data = await res.json();
        window.allQuestions = data;
        populateFilters();
    } catch (err) {
        console.error('Erro ao carregar perguntas:', err);
        Toast.show('Erro ao carregar perguntas: ' + err.message, 'error');
        
        // Desabilitar botões
        document.getElementById('start-quick-quiz-btn').disabled = true;
        document.getElementById('start-study-mode-btn').disabled = true;
    }
}
```

#### 3. Geração Dinâmica de Filtros
```javascript
function populateFilters() {
    // Extrair tags únicas
    const tags = new Set();
    window.allQuestions.forEach(q => 
        (q.tags || []).forEach(t => tags.add(t))
    );

    const sortedTags = Array.from(tags).sort();
    const initialTags = sortedTags.slice(0, 7);
    const hasMore = sortedTags.length > 7;

    // Gerar botões de tags
    tagsContainer.innerHTML = '';
    initialTags.forEach(tag => {
        const btn = document.createElement('button');
        btn.className = 'tag-btn';
        btn.textContent = tag.charAt(0).toUpperCase() + tag.slice(1);
        btn.onclick = () => window.startQuiz({ type: 'tag', value: tag });
        tagsContainer.appendChild(btn);
    });

    // Botão "Mostrar Todas"
    if (hasMore) {
        const showMoreBtn = document.createElement('button');
        showMoreBtn.className = 'tag-btn show-more-btn';
        showMoreBtn.textContent = 'Mostrar Todas';
        showMoreBtn.onclick = () => showAllTags(sortedTags);
        tagsContainer.appendChild(showMoreBtn);
    }

    // Gerar botões de dificuldade
    const difficulties = [...new Set(
        window.allQuestions.map(q => q.dificuldade || 1)
    )].sort((a,b) => a-b);
    
    difficultyContainer.innerHTML = '';
    difficulties.forEach(d => {
        const btn = document.createElement('button');
        btn.className = 'difficulty-btn';
        if (d === 1) btn.classList.add('difficulty-easy');
        else if (d === 2) btn.classList.add('difficulty-medium');
        else if (d === 3) btn.classList.add('difficulty-hard');
        btn.innerHTML = '★'.repeat(d) + '☆'.repeat(3-d);
        btn.onclick = () => window.startQuiz({ type: 'difficulty', value: d });
        difficultyContainer.appendChild(btn);
    });
}
```

#### 4. Sistema de Quiz
```javascript
function startQuiz(options) {
    let questions = [];
    
    switch(options.type) {
        case 'random':
            questions = shuffle(window.allQuestions).slice(0, options.value);
            break;
        case 'tag':
            questions = shuffle(
                window.allQuestions.filter(q => 
                    q.tags && q.tags.includes(options.value)
                )
            ).slice(0, 10);
            break;
        case 'difficulty':
            questions = shuffle(
                window.allQuestions.filter(q => 
                    q.dificuldade === options.value
                )
            ).slice(0, 10);
            break;
        case 'study':
            questions = shuffle(window.allQuestions).slice(0, options.value);
            break;
    }

    if (questions.length === 0) {
        Toast.show('Nenhuma pergunta encontrada para este filtro!', 'warning');
        return;
    }

    window.currentQuiz = {
        questions: questions,
        currentIndex: 0,
        score: 0,
        answered: 0,
        correctAnswers: 0,
        mode: options.type,
        startTime: Date.now()
    };

    showView('quiz-view');
    showQuestion();
    
    if (options.type !== 'study') {
        startTimer();
    }
}
```

#### 5. Exibição de Pergunta
```javascript
function showQuestion() {
    const quiz = window.currentQuiz;
    const question = quiz.questions[quiz.currentIndex];
    
    // Atualizar progresso
    document.getElementById('quiz-progress').textContent = 
        `Pergunta ${quiz.currentIndex + 1} de ${quiz.questions.length}`;
    
    // Exibir pergunta
    document.getElementById('question-text').textContent = question.pergunta;
    
    // Gerar opções
    const container = document.getElementById('options-container');
    container.innerHTML = '';
    
    const shuffledOptions = shuffle([...question.opcoes]);
    shuffledOptions.forEach((option, index) => {
        const btn = document.createElement('button');
        btn.className = 'option-btn';
        btn.textContent = option;
        btn.onclick = () => selectAnswer(option, question);
        container.appendChild(btn);
    });
    
    // Ocultar área de referência
    document.getElementById('reference-area').classList.add('hidden');
    document.getElementById('next-btn').disabled = true;
}
```

#### 6. Verificação de Resposta
```javascript
function selectAnswer(selectedOption, question) {
    const quiz = window.currentQuiz;
    const isCorrect = selectedOption === question.resposta_correta;
    
    // Atualizar estatísticas
    quiz.answered++;
    if (isCorrect) {
        quiz.correctAnswers++;
        quiz.score += 10;
    }
    
    // Feedback visual
    const buttons = document.querySelectorAll('.option-btn');
    buttons.forEach(btn => {
        btn.disabled = true;
        if (btn.textContent === question.resposta_correta) {
            btn.classList.add('correct');
        } else if (btn.textContent === selectedOption && !isCorrect) {
            btn.classList.add('wrong');
        }
    });
    
    // Mostrar referência bíblica
    showReference(question, isCorrect);
    
    // Habilitar botão próxima
    document.getElementById('next-btn').disabled = false;
    
    // Parar timer
    if (quiz.mode !== 'study') {
        stopTimer();
    }
    
    // Analytics
    window.analytics.track('question_answered', {
        questionId: question.id,
        correct: isCorrect,
        timeTaken: Date.now() - quiz.questionStartTime
    });
}
```

#### 7. Exibição de Referência
```javascript
function showReference(question, isCorrect) {
    const refArea = document.getElementById('reference-area');
    refArea.classList.remove('hidden');
    
    document.getElementById('correct-answer').textContent = 
        question.resposta_correta;
    document.getElementById('correct-answer').style.color = 
        isCorrect ? 'var(--correct-text)' : 'var(--wrong-text)';
    
    document.getElementById('reference-text').textContent = 
        question.referencia || 'Referência não disponível';
    document.getElementById('biblical-text').textContent = 
        question.texto_biblico || 'Texto não disponível';
    
    // Auto-avançar (modo estudo)
    if (window.currentQuiz.mode === 'study') {
        startAutoNext();
    }
}
```

#### 8. Timer do Quiz
```javascript
let timerInterval;
let timerStartTime;
const TIMER_DURATION = 30; // segundos

function startTimer() {
    timerStartTime = Date.now();
    const timerBar = document.getElementById('timer-bar');
    const timerText = document.getElementById('timer-text');
    
    timerInterval = setInterval(() => {
        const elapsed = (Date.now() - timerStartTime) / 1000;
        const remaining = Math.max(0, TIMER_DURATION - elapsed);
        
        timerText.textContent = Math.ceil(remaining) + 's';
        timerBar.style.width = (remaining / TIMER_DURATION * 100) + '%';
        
        if (remaining <= 0) {
            stopTimer();
            timeOut();
        }
    }, 100);
}

function stopTimer() {
    if (timerInterval) {
        clearInterval(timerInterval);
        timerInterval = null;
    }
}

function timeOut() {
    Toast.show('Tempo esgotado!', 'warning');
    const quiz = window.currentQuiz;
    const question = quiz.questions[quiz.currentIndex];
    
    // Marcar como errada
    selectAnswer('__TIMEOUT__', question);
}
```

#### 9. Finalização do Quiz
```javascript
function finishQuiz() {
    const quiz = window.currentQuiz;
    const totalTime = Date.now() - quiz.startTime;
    const accuracy = (quiz.correctAnswers / quiz.questions.length * 100).toFixed(1);
    
    // Salvar estatísticas
    saveStats({
        mode: quiz.mode,
        score: quiz.score,
        correctAnswers: quiz.correctAnswers,
        totalQuestions: quiz.questions.length,
        accuracy: accuracy,
        timeTaken: totalTime,
        date: Date.now()
    });
    
    // Mostrar resultado
    Toast.show(
        `Quiz finalizado! ${quiz.correctAnswers}/${quiz.questions.length} corretas (${accuracy}%)`,
        accuracy >= 70 ? 'success' : 'warning'
    );
    
    // Analytics
    window.analytics.track('quiz_completed', {
        mode: quiz.mode,
        score: quiz.score,
        accuracy: accuracy,
        duration: totalTime
    });
    
    // Voltar ao menu
    showView('home-view');
}
```

#### 10. Sistema de Analytics
```javascript
window.analytics = {
    data: JSON.parse(localStorage.getItem('quiz_analytics') || '{}'),
    userId: localStorage.getItem('user_id') || generateUserId(),
    sessionId: generateSessionId(),
    sessionStart: Date.now(),

    track: function(event, data = {}) {
        const now = new Date();
        const dateKey = now.toISOString().split('T')[0];

        if (!this.data[dateKey]) {
            this.data[dateKey] = { events: {} };
        }

        if (!this.data[dateKey].events[event]) {
            this.data[dateKey].events[event] = [];
        }

        const eventData = {
            timestamp: now.getTime(),
            userId: this.userId,
            sessionId: this.sessionId,
            userAgent: navigator.userAgent,
            screenSize: `${window.screen.width}x${window.screen.height}`,
            timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
            ...data
        };

        this.data[dateKey].events[event].push(eventData);
        
        // Limitar tamanho (máximo 500 eventos por tipo por dia)
        if (this.data[dateKey].events[event].length > 500) {
            this.data[dateKey].events[event] = 
                this.data[dateKey].events[event].slice(-500);
        }

        this.save();
        this.cleanup();
    },

    save: function() {
        try {
            const dataStr = JSON.stringify(this.data);
            if (dataStr.length > 2 * 1024 * 1024) { // 2MB limit
                this.cleanup(true);
            }
            localStorage.setItem('quiz_analytics', dataStr);
        } catch (e) {
            console.warn('LocalStorage full, cleaning up...', e);
            this.cleanup(true);
        }
    },

    cleanup: function(aggressive = false) {
        const now = Date.now();
        const maxAge = aggressive ? 7 : 30; // dias
        
        Object.keys(this.data).forEach(dateKey => {
            const date = new Date(dateKey);
            const age = (now - date.getTime()) / (1000 * 60 * 60 * 24);
            
            if (age > maxAge) {
                delete this.data[dateKey];
            }
        });
        
        this.save();
    }
};

function generateUserId() {
    const id = 'user_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    localStorage.setItem('user_id', id);
    return id;
}

function generateSessionId() {
    return 'session_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
}
```

### Sistema Toast (toast.js)

```javascript
class Toast {
    static container = null;

    static init() {
        if (!this.container) {
            this.container = document.getElementById('toast-container');
            if (!this.container) {
                this.container = document.createElement('div');
                this.container.id = 'toast-container';
                this.container.className = 'toast-container';
                this.container.setAttribute('aria-live', 'polite');
                this.container.setAttribute('aria-atomic', 'true');
                document.body.appendChild(this.container);
            }
        }
    }

    static show(message, type = 'info', duration = 3000) {
        this.init();

        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.setAttribute('role', 'alert');
        
        const icon = this.getIcon(type);
        toast.innerHTML = `
            <span class="toast-icon">${icon}</span>
            <span class="toast-message">${message}</span>
            <button class="toast-close" aria-label="Fechar notificação">×</button>
        `;

        this.container.appendChild(toast);

        // Animação de entrada
        setTimeout(() => toast.classList.add('show'), 10);

        // Botão fechar
        const closeBtn = toast.querySelector('.toast-close');
        closeBtn.onclick = () => this.remove(toast);

        // Auto-remover
        setTimeout(() => this.remove(toast), duration);
    }

    static remove(toast) {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 300);
    }

    static getIcon(type) {
        const icons = {
            success: '✓',
            error: '✕',
            warning: '⚠',
            info: 'ℹ'
        };
        return icons[type] || icons.info;
    }
}

window.Toast = Toast;
```

---

## 📊 ESTRUTURA DE DADOS

### Objeto de Pergunta (JSON)
```json
{
    "id": "10001",
    "pergunta": "Quem recebeu a ordem de Deus para construir uma arca?",
    "opcoes": [
        "Noé",
        "Moisés",
        "Abraão",
        "Davi"
    ],
    "resposta_correta": "Noé",
    "tags": [
        "gênesis",
        "bíblia",
        "básico"
    ],
    "dificuldade": 1,
    "referencia": "Gênesis 6:13-14",
    "texto_biblico": "(13) Depois disso Deus disse a Noé: \"Decidi pôr um fim a toda a humanidade... (14) Faça para você uma arca de madeira resinosa.\""
}
```

### Objeto currentQuiz
```javascript
{
    questions: Array<Question>,     // Perguntas do quiz atual
    currentIndex: Number,           // Índice da pergunta atual
    score: Number,                  // Pontuação total
    answered: Number,               // Perguntas respondidas
    correctAnswers: Number,         // Respostas corretas
    mode: String,                   // Tipo do quiz
    startTime: Number,              // Timestamp de início
    questionStartTime: Number       // Timestamp da pergunta atual
}
```

### localStorage Structure
```javascript
// quiz_stats
{
    totalQuizzes: Number,
    totalQuestions: Number,
    correctAnswers: Number,
    accuracy: Number,
    byDifficulty: {
        easy: { played: Number, accuracy: Number },
        medium: { played: Number, accuracy: Number },
        hard: { played: Number, accuracy: Number }
    },
    byTheme: {
        [theme]: { played: Number, accuracy: Number }
    },
    history: Array<{
        mode: String,
        score: Number,
        accuracy: Number,
        date: Number
    }>
}

// quiz_analytics
{
    [date]: {
        events: {
            [eventName]: Array<{
                timestamp: Number,
                userId: String,
                sessionId: String,
                userAgent: String,
                screenSize: String,
                timezone: String,
                ...customData
            }>
        }
    }
}

// user_preferences
{
    theme: String,              // 'light' ou 'dark'
    soundEnabled: Boolean,
    autoNext: Boolean,
    timerEnabled: Boolean
}
```

---

## 🎮 FLUXO DE JOGO

### 1. Inicialização do App
```
1. DOMContentLoaded dispara
2. Carregar perguntas do JSON (fetch)
3. Gerar filtros dinâmicos (tags + dificuldades)
4. Configurar event listeners
5. Carregar preferências do localStorage
6. Aplicar tema (light/dark)
7. Inicializar analytics
8. Registrar Service Worker (PWA)
9. Exibir welcome-view
```

### 2. Seleção de Quiz
```
Usuário pode escolher:
├── Quiz Rápido → 10 perguntas aleatórias
├── Modo Estudo → Sem timer, com auto-avanço
├── Por Tema → Filtrado por tag específica
├── Por Dificuldade → Filtrado por ★, ★★, ★★★
└── Partida em Grupo → Multiplayer online

Ao clicar:
1. Validar se há perguntas disponíveis
2. Filtrar perguntas baseado no tipo
3. Embaralhar perguntas (shuffle)
4. Criar objeto currentQuiz
5. Navegar para quiz-view
6. Iniciar primeira pergunta
```

### 3. Loop de Pergunta
```
1. showQuestion() exibe pergunta atual
2. Embaralhar opções de resposta
3. Gerar botões de opção
4. Iniciar timer (se não for modo estudo)
5. Aguardar clique do usuário

Ao clicar em opção:
├── Desabilitar todos os botões
├── Verificar se resposta está correta
├── Aplicar classe CSS (correct/wrong)
├── Tocar som (se habilitado)
├── Atualizar pontuação
├── Mostrar área de referência
├── Parar timer
├── Habilitar botão "Próxima"
└── Registrar analytics

Ao clicar "Próxima":
├── currentIndex++
├── Se houver mais perguntas → showQuestion()
└── Se não → finishQuiz()
```

### 4. Finalização
```
1. Calcular estatísticas finais
   - Total de acertos
   - Taxa de acerto (%)
   - Tempo total
   - Pontuação

2. Salvar no localStorage
   - Atualizar quiz_stats
   - Adicionar ao histórico
   - Registrar analytics

3. Mostrar feedback
   - Toast com resultado
   - Oferecer jogar novamente
   - Voltar ao menu

4. Limpar estado
   - Resetar currentQuiz
   - Parar timers
   - Limpar DOM
```

---

## 📈 SISTEMA DE ANALYTICS

### Eventos Rastreados
```javascript
// Navegação
- 'view_changed': { from: String, to: String }
- 'theme_changed': { theme: String }

// Quiz
- 'quiz_started': { mode: String, questionCount: Number }
- 'question_answered': { questionId: String, correct: Boolean, timeTaken: Number }
- 'quiz_completed': { mode: String, score: Number, accuracy: Number, duration: Number }
- 'quiz_abandoned': { currentQuestion: Number, totalQuestions: Number }

// Interações
- 'filter_used': { type: String, value: String }
- 'button_clicked': { button: String, context: String }
- 'error_occurred': { type: String, message: String }
```

### Relatórios Disponíveis
```javascript
// Total de quizzes por dia
analytics.getQuizzesByDate()

// Taxa de acerto média
analytics.getAverageAccuracy()

// Temas mais jogados
analytics.getMostPlayedThemes()

// Horários de pico
analytics.getPeakHours()

// Taxa de abandono
analytics.getAbandonmentRate()

// Tempo médio por pergunta
analytics.getAverageTimePerQuestion()

// Perguntas mais difíceis
analytics.getMostDifficultQuestions()
```

---

## 🚀 MELHORIAS SUGERIDAS

### Curto Prazo (Fáceis)

1. **Modo Desafio Diário**
   - 5 perguntas novas todos os dias
   - Streak de dias consecutivos
   - Recompensas por consistência

2. **Sistema de Conquistas**
   - Badges por marcos (10, 50, 100 quizzes)
   - Conquistas por temas específicos
   - Conquistas por accuracy (90%, 95%, 100%)

3. **Compartilhamento Social**
   - Botão "Compartilhar Resultado"
   - Gerar imagem com estatísticas
   - Links para redes sociais

4. **Modo Prática**
   - Revisar perguntas erradas
   - Focar em temas específicos
   - Sem pontuação, apenas aprendizado

5. **Sons e Efeitos**
   - Som de acerto/erro
   - Som de conclusão
   - Vibração (mobile)
   - Toggle on/off

### Médio Prazo (Moderadas)

1. **Sistema de Ranking**
   - Leaderboard global
   - Comparação com amigos
   - Ranking por tema
   - Ranking semanal/mensal

2. **Modo Contra o Tempo**
   - 60 segundos para responder o máximo possível
   - Multiplicador de pontos por sequência
   - Power-ups (pausar tempo, eliminar opção)

3. **Editor de Perguntas**
   - Interface para adicionar perguntas
   - Moderação comunitária
   - Exportar/importar JSON
   - Versionamento de perguntas

4. **Análise de Desempenho**
   - Gráficos de evolução
   - Identificar pontos fracos
   - Sugestões de estudo
   - Relatórios PDF

5. **Modo Offline Avançado**
   - Download de perguntas
   - Sincronização inteligente
   - Cache de mídia
   - Modo avião completo

### Longo Prazo (Complexas)

1. **IA Adaptativa**
   - Dificuldade ajustada automaticamente
   - Perguntas personalizadas por perfil
   - Recomendações de estudo
   - Predição de desempenho

2. **Backend Completo**
   - API REST para sincronização
   - Database com PostgreSQL
   - Autenticação OAuth
   - WebSockets para multiplayer real

3. **Gamificação Completa**
   - Sistema de XP e níveis
   - Loja de itens (temas, avatares)
   - Clãs e guildas
   - Torneios mensais

4. **Acessibilidade Total**
   - Screen reader otimizado
   - Controle por voz
   - Alto contraste
   - Tamanho de fonte variável
   - Suporte a braille

5. **Plataforma Multi-Idioma**
   - Suporte a 10+ idiomas
   - Tradução automática
   - Comunidades por idioma
   - Conteúdo regional

---

## 🐛 PROBLEMAS CONHECIDOS

### Críticos
- ❌ Nenhum no momento

### Médios
- ⚠️ Timer pode dessincronizar em dispositivos lentos
- ⚠️ LocalStorage pode lotar com analytics (mitigado com cleanup)
- ⚠️ Multiplayer requer internet constante (sem fallback offline)

### Pequenos
- 🔸 Animações podem travar em mobile antigo
- 🔸 JSON de perguntas é carregado todo de uma vez (sem paginação)
- 🔸 Não há cache de perguntas já carregadas
- 🔸 Service Worker pode não atualizar imediatamente

---

## 📈 ESTATÍSTICAS DO PROJETO

```
Total de Linhas:
- HTML: 659
- CSS: 1393
- JavaScript (main.js): 1584
- JavaScript (toast.js): 141
- JSON (perguntas): 3593
TOTAL: 7370 linhas

Componentes:
- Views: 6 (welcome, home, quiz, stats, group, legal)
- Filtros dinâmicos: 2 (tags, dificuldade)
- Modos de jogo: 5 (rápido, estudo, tema, dificuldade, grupo)
- Funções JavaScript: ~40
- Event Listeners: ~25
- Animações CSS: 8
- Temas: 2 (claro, escuro)

Base de Dados:
- Total de perguntas: 3593
- Tags únicas: ~30
- Dificuldades: 3 (★, ★★, ★★★)
- Média de opções por pergunta: 4
```

---

## 🔧 CONFIGURAÇÕES TÉCNICAS

### Requisitos
- **Navegador**: Chrome 90+, Firefox 88+, Safari 14+, Edge 90+
- **JavaScript**: ES6+ habilitado
- **localStorage**: Mínimo 5MB disponível
- **Resolução**: 320px+ (mobile first)
- **Conexão**: Recomendado (offline possível após primeira visita)

### Performance
- **FPS Target**: 60fps
- **First Load**: <2s (com cache)
- **JSON Parse**: <100ms (3593 perguntas)
- **Memory Usage**: <20MB
- **Battery Impact**: Baixo

### Compatibilidade
- ✅ Desktop (Windows, Mac, Linux)
- ✅ Mobile (iOS 13+, Android 8+)
- ✅ Tablet
- ✅ PWA Ready (instalável)
- ⚠️ IE11: Não suportado (ES6+)

### SEO e PWA
```json
{
  "name": "JW Quiz - Quiz Bíblico",
  "short_name": "JW Quiz",
  "description": "Quiz bíblico interativo com 3593 perguntas",
  "start_url": "/",
  "display": "standalone",
  "theme_color": "#3a6ea5",
  "background_color": "#ffffff",
  "icons": [
    { "src": "icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

---

## 📚 REFERÊNCIAS

### Código Base
- **Autor**: Equipe JW Quiz
- **Licença**: MIT (presumido)
- **Repositório**: leniredenis-bit/JW-Quiz

### Inspirações
- Kahoot! (quiz interativo)
- Duolingo (gamificação)
- Quizlet (modo estudo)
- Trivia Crack (multiplayer)

### Bibliotecas e APIs
- **Nenhuma biblioteca externa** (Vanilla JS)
- **Fetch API** (nativa)
- **Web Storage API** (localStorage)
- **Service Worker API** (PWA)
- **Intl API** (internacionalização)

### Recursos Utilizados
- **Emojis**: Unicode 13.0+
- **Fontes**: System fonts (sans-serif)
- **Ícones**: Emojis nativos
- **Cores**: Material Design inspired

---

## 🎓 GLOSSÁRIO

**PWA**: Progressive Web App - aplicativo web instalável  
**TNM**: Tradução do Novo Mundo (versão da Bíblia)  
**Analytics**: Sistema de coleta de dados de uso  
**Toast**: Notificação temporária não-intrusiva  
**LocalStorage**: Armazenamento persistente no navegador  
**Service Worker**: Script que roda em background para PWA  
**ARIA**: Accessible Rich Internet Applications (acessibilidade)  
**Shuffle**: Embaralhar (randomizar ordem)  
**Tag**: Etiqueta/categoria de pergunta  

---

**FIM DA DOCUMENTAÇÃO**

*Para melhorias, sugestões ou dúvidas, consulte o repositório ou entre em contato com a equipe!*

🙏 **Que este quiz ajude muitos a aprofundar seu conhecimento bíblico!**
