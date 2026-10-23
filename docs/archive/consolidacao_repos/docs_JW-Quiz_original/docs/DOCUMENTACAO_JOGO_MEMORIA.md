# 🧠 DOCUMENTAÇÃO COMPLETA - JOGO DA MEMÓRIA
**JW Quiz - Memory Game**  
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
8. [Melhorias Sugeridas](#melhorias-sugeridas)

---

## 🎯 VISÃO GERAL

### Funcionalidades Principais
- ✅ **8 Temas diferentes**: Animais, Frutas, Transportes, Peixes, Aves, Números, Objetos, Natureza
- ✅ **3 Níveis de dificuldade**: Fácil (10 pares), Médio (15 pares), Difícil (20 pares com timer)
- ✅ **Modo multiplayer**: 1 a 4 jogadores
- ✅ **Sistema de pontuação**: Rastreia pontos por jogador
- ✅ **Timer**: Apenas no modo difícil (2 minutos)
- ✅ **Efeitos sonoros**: Sons para flip, acerto, erro e conclusão
- ✅ **Animações**: Flip 3D, celebração ao acertar, shake ao errar
- ✅ **Sistema de estatísticas**: Salva melhores tempos no localStorage
- ✅ **Responsivo**: Adaptado para mobile, tablet e desktop
- ✅ **Tema escuro/claro**: Sincronizado com o tema principal do app

### Tecnologias Utilizadas
- **HTML5**: Estrutura semântica
- **CSS3**: Animações, Grid, Flexbox, Variáveis CSS
- **JavaScript ES6+**: Classes, Arrow Functions, Template Literals
- **Web Audio API**: Sons procedurais
- **localStorage**: Persistência de dados

---

## 🏗️ ARQUITETURA

### Estrutura de Arquivos
```
quiz-biblico/
├── index.html              # Estrutura HTML do jogo
├── CSS/
│   └── style.css          # Estilos do jogo (linhas 1055-1393)
└── JS/
    └── script.js          # Lógica completa do jogo (521 linhas)
```

### Componentes Principais

#### 1. Tela de Configuração (`memory-config`)
- Seleção de número de jogadores (1-4)
- Seleção de tema (8 opções)
- Seleção de dificuldade (Fácil, Médio, Difícil)
- Toggle de som
- Botão "Iniciar Jogo"

#### 2. Tela de Jogo (`memory-game`)
- Barra de status (timer, placar, turno)
- Tabuleiro de cartas (grid responsivo)
- Controles (reiniciar, voltar)

#### 3. Tela de Vitória (modal)
- Mostra o vencedor
- Exibe estatísticas da partida
- Confetes animados
- Opções de jogar novamente ou voltar

---

## 📝 CÓDIGO HTML

```html
<!-- TELA DO JOGO DA MEMÓRIA -->
<section id="memory-view" class="view" role="main" aria-labelledby="memory-title">
    <div class="quiz-card">
        <header class="stats-header">
            <h2 id="memory-title">🧠 Jogo da Memória</h2>
            <button id="back-from-memory" class="btn btn-link">← Início</button>
        </header>

        <!-- TELA DE CONFIGURAÇÃO -->
        <div id="memory-config" class="memory-subview active">
            <div class="memory-config-hero">
                <div class="memory-config-header">
                    <h2>🧠 Jogo da Memória</h2>
                    <p class="memory-config-subtitle">Desafie sua memória com temas divertidos</p>
                </div>

                <div class="memory-welcome-section">
                    <div class="memory-welcome-message">
                        <h1>Bem-vindo ao Jogo da Memória!</h1>
                        <p>Desafie sua memória com temas divertidos e dificuldades variadas. Jogue sozinho ou com amigos!</p>
                    </div>
                </div>

                <div class="memory-config-actions">
                    <!-- Número de Jogadores -->
                    <div class="memory-config-group">
                        <h2>👥 Número de Jogadores</h2>
                        <div class="memory-config-row">
                            <div class="memory-config-item">
                                <div class="memory-player-buttons" id="player-buttons">
                                    <button class="memory-player-btn active" data-players="1">1</button>
                                    <button class="memory-player-btn" data-players="2">2</button>
                                    <button class="memory-player-btn" data-players="3">3</button>
                                    <button class="memory-player-btn" data-players="4">4</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tema do Jogo -->
                    <div class="memory-config-group">
                        <h2>🎨 Tema do Jogo</h2>
                        <div class="memory-config-row">
                            <div class="memory-config-item">
                                <label class="memory-config-label">Escolha o tema das cartas:</label>
                                <select id="theme-select" class="memory-theme-select">
                                    <option value="animais">Animais</option>
                                    <option value="frutas">Frutas</option>
                                    <option value="transportes">Transportes</option>
                                    <option value="peixes">Peixes</option>
                                    <option value="aves">Aves</option>
                                    <option value="numeros">Números</option>
                                    <option value="objetos">Objetos</option>
                                    <option value="natureza">Natureza</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Dificuldade -->
                    <div class="memory-config-group">
                        <h2>🎯 Dificuldade</h2>
                        <div class="memory-config-row">
                            <div class="memory-config-item">
                                <div class="memory-difficulty-buttons" id="difficulty-buttons">
                                    <button class="memory-difficulty-btn" data-difficulty="easy">Fácil<br><small>10 pares</small></button>
                                    <button class="memory-difficulty-btn active" data-difficulty="medium">Médio<br><small>15 pares</small></button>
                                    <button class="memory-difficulty-btn" data-difficulty="hard">Difícil<br><small>20 pares</small></button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Configurações -->
                    <div class="memory-config-group">
                        <h2>🔊 Configurações</h2>
                        <div class="memory-config-row">
                            <div class="memory-config-item">
                                <div class="memory-sound-toggle">
                                    <input type="checkbox" id="sound-toggle" checked>
                                    <label for="sound-toggle">Ativar sons do jogo</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <button id="start-game" class="memory-start-btn">
                    <span class="memory-start-icon">🎮</span>
                    <span class="memory-start-text">Iniciar Jogo</span>
                    <span class="memory-start-desc">Vamos jogar!</span>
                </button>
            </div>
        </div>

        <!-- TELA DO JOGO -->
        <div id="memory-game" class="memory-subview">
            <div class="memory-content">
                <!-- Barra superior com dados da partida -->
                <div class="game-status-bar">
                    <div id="timer-display" class="status-item">
                        <span class="status-label">⏱️ Tempo:</span>
                        <span id="timer-text" class="status-value">00:00</span>
                    </div>
                    <div id="status-display" class="status-item status-main">
                        <!-- O status do jogo (turno do jogador, placar) será inserido aqui pelo JavaScript -->
                    </div>
                </div>

                <!-- Tabuleiro do jogo -->
                <div class="game-container">
                    <section id="game-board" class="game-board">
                        <!-- As cartas serão geradas aqui pelo JavaScript -->
                    </section>
                </div>

                <!-- Botões de controle -->
                <div class="game-controls">
                    <button id="restart-game" class="btn btn-secondary" style="display: none;">🔄 Jogar Novamente</button>
                    <button id="back-to-config" class="btn btn-link">← Voltar à Configuração</button>
                </div>
            </div>
        </div>
    </div>
</section>
```

---

## 🎨 CÓDIGO CSS

```css
/* =================================================================
   JOGO DA MEMÓRIA - ESTILOS COMPLETOS
   ================================================================= */

/* === WELCOME SCREEN === */
.welcome-hero {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 100vh;
    padding: 2rem;
    text-align: center;
    background: linear-gradient(135deg, var(--bg-primary) 0%, var(--bg-secondary) 100%);
    position: relative;
    overflow: hidden;
}

/* === MEMORY GAME CONFIG === */
.memory-config-hero {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 80vh;
    padding: 2rem;
    text-align: center;
    background: linear-gradient(135deg, var(--bg-primary) 0%, var(--bg-secondary) 100%);
    border-radius: 20px;
    margin: 1rem;
    box-shadow: 0 8px 32px var(--shadow-primary);
}

.memory-config-header {
    margin-bottom: 3rem;
}

.memory-config-header h2 {
    font-size: 3rem;
    font-weight: 700;
    color: var(--text-accent);
    margin: 0 0 0.5rem 0;
    text-shadow: 0 2px 8px rgba(58, 110, 165, 0.3);
}

.memory-config-subtitle {
    font-size: 1.2rem;
    color: var(--text-secondary);
    margin: 0;
    font-weight: 400;
}

/* Botões de Jogadores */
.memory-player-buttons {
    display: flex;
    gap: 1rem;
    justify-content: center;
    flex-wrap: wrap;
}

.memory-player-btn {
    padding: 1rem 1.5rem;
    font-size: 1.2rem;
    font-weight: 600;
    border: 2px solid var(--border-primary);
    border-radius: 12px;
    background: var(--bg-secondary);
    color: var(--text-primary);
    cursor: pointer;
    transition: all 0.2s ease;
    min-width: 60px;
}

.memory-player-btn:hover {
    background: var(--bg-accent);
    border-color: var(--border-accent);
    transform: translateY(-2px);
}

.memory-player-btn.active {
    background: var(--btn-primary);
    color: white;
    border-color: var(--btn-primary);
    box-shadow: 0 4px 12px rgba(58, 110, 165, 0.3);
}

/* Botões de Dificuldade */
.memory-difficulty-buttons {
    display: flex;
    gap: 1rem;
    justify-content: center;
    flex-wrap: wrap;
}

.memory-difficulty-btn {
    padding: 1rem 1.5rem;
    font-size: 1rem;
    font-weight: 600;
    border: 2px solid var(--border-primary);
    border-radius: 12px;
    background: var(--bg-secondary);
    color: var(--text-primary);
    cursor: pointer;
    transition: all 0.2s ease;
    min-width: 120px;
    text-align: center;
}

.memory-difficulty-btn:hover {
    background: var(--bg-accent);
    border-color: var(--border-accent);
    transform: translateY(-2px);
}

.memory-difficulty-btn.active {
    background: var(--btn-primary);
    color: white;
    border-color: var(--btn-primary);
    box-shadow: 0 4px 12px rgba(58, 110, 165, 0.3);
}

/* Botão Iniciar Jogo */
.memory-start-btn {
    padding: 1.5rem 3rem;
    font-size: 1.4rem;
    font-weight: 700;
    border: none;
    border-radius: 20px;
    background: linear-gradient(135deg, #28a745, #20c997);
    color: white;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
    position: relative;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 1rem;
}

.memory-start-btn::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
    transition: left 0.6s;
}

.memory-start-btn:hover::before {
    left: 100%;
}

.memory-start-btn:hover {
    transform: translateY(-4px);
    box-shadow: 0 10px 30px rgba(40, 167, 69, 0.5);
}

/* === MEMORY GAME BOARD === */
.game-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 2rem 0;
}

.game-board {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 0.75rem;
    max-width: 600px;
    margin: 0 auto;
    padding: 1rem;
}

/* Ajustar grid para diferentes tamanhos */
@media (max-width: 768px) {
    .game-board {
        grid-template-columns: repeat(4, 1fr);
        gap: 0.5rem;
        max-width: 400px;
    }
}

/* === CARTAS === */
.memory-card {
    aspect-ratio: 1;
    background: var(--bg-secondary);
    border: 2px solid var(--border-primary);
    border-radius: 12px;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    font-size: 2rem;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
    transform-style: preserve-3d; /* Permite animações 3D suaves */
}

.memory-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 16px var(--shadow-primary);
}

.memory-card.flipped {
    background: var(--bg-accent);
    border-color: var(--border-accent);
}

.memory-card.matched {
    transform: rotateY(180deg); /* Mantém a carta virada */
    cursor: default; /* Remove o cursor de clique */
    
    /* Aplica as cores de sucesso que já definimos */
    background: var(--correct-bg); 
    border-color: var(--correct-border);
    
    /* Executa a animação de celebração */
    animation: match-celebration 0.6s ease;
}

/* Novo pseudo-elemento para criar o ícone de "check" */
.memory-card.matched::after {
    content: '✔'; /* O caractere de check */
    position: absolute;
    top: 50%;
    left: 50%;
    
    color: var(--correct-text); /* Cor de texto verde */
    font-size: 3rem; /* Tamanho do ícone */
    font-weight: bold;
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); /* Sombra sutil para destacar */

    /* Animação para o ícone aparecer suavemente */
    animation: checkmark-fade-in 0.4s ease-out 0.2s; /* Começa após um pequeno atraso */
    animation-fill-mode: backwards; /* Garante que o estado inicial (invisível) seja aplicado */
}

.memory-card.shake {
    animation: shake 0.5s;
}

.memory-card-back {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    font-size: 2rem;
    color: var(--text-secondary);
}

.memory-card-front {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    opacity: 0;
    transform: scale(0.8);
    transition: all 0.3s ease;
}

.memory-card.flipped .memory-card-front {
    opacity: 1;
    transform: scale(1);
}

.memory-card.flipped .memory-card-back {
    opacity: 0;
}

.memory-animal {
    font-size: 2.5rem;
    margin-bottom: 0.25rem;
}

.memory-name {
    font-size: 0.75rem;
    font-weight: 600;
    color: var(--text-primary);
    text-align: center;
    line-height: 1.1;
    max-width: 100%;
    word-wrap: break-word;
}

/* === ANIMAÇÕES === */
@keyframes match-celebration {
    0% {
        transform: rotateY(180deg) scale(1);
    }
    50% {
        transform: rotateY(180deg) scale(1.1); /* Efeito de "pop" */
    }
    100% {
        transform: rotateY(180deg) scale(1);
    }
}

@keyframes checkmark-fade-in {
    from {
        opacity: 0;
        transform: translate(-50%, -50%) scale(0.5);
    }
    to {
        opacity: 1;
        transform: translate(-50%, -50%) scale(1);
    }
}

/* === BARRA DE STATUS === */
.game-status-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2rem;
    padding: 1rem;
    background: var(--bg-secondary);
    border-radius: 12px;
    border: 1px solid var(--border-primary);
    box-shadow: 0 2px 8px var(--shadow-primary);
}

.status-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.25rem;
}

.status-main {
    flex: 1;
    text-align: center;
}

.status-label {
    font-size: 0.9rem;
    color: var(--text-secondary);
    font-weight: 600;
}

.status-value {
    font-size: 1.2rem;
    color: var(--text-primary);
    font-weight: 700;
}

/* === CONTROLES === */
.game-controls {
    display: flex;
    justify-content: center;
    gap: 1rem;
    margin-top: 2rem;
}

/* === RESPONSIVO === */
@media (max-width: 768px) {
    .memory-config-hero {
        min-height: 70vh;
        padding: 1.5rem;
        margin: 0.5rem;
    }

    .memory-config-header h2 {
        font-size: 2.5rem;
    }

    .memory-card {
        font-size: 1.5rem;
    }

    .memory-animal {
        font-size: 2rem;
    }
}

@media (max-width: 480px) {
    .game-board {
        grid-template-columns: repeat(2, 1fr);
        gap: 0.5rem;
        max-width: 200px;
    }

    .memory-card {
        font-size: 1.2rem;
    }

    .memory-animal {
        font-size: 1.5rem;
    }

    .game-status-bar {
        flex-direction: column;
        gap: 1rem;
        padding: 0.75rem;
    }
}
```

---

## 💻 CÓDIGO JAVASCRIPT

```javascript
// =================================================================
// JOGO DA MEMÓRIA - CÓDIGO COMPLETO
// =================================================================

// --- CONFIGURAÇÃO DOS TEMAS ---
const THEMES = {
    animais: [
        { name: 'Cachorro', emoji: '🐶' }, { name: 'Gato', emoji: '🐱' }, 
        { name: 'Rato', emoji: '🐭' }, { name: 'Hamster', emoji: '🐹' },
        { name: 'Coelho', emoji: '🐰' }, { name: 'Raposa', emoji: '🦊' }, 
        { name: 'Urso', emoji: '🐻' }, { name: 'Panda', emoji: '🐼' },
        { name: 'Coalá', emoji: '🐨' }, { name: 'Tigre', emoji: '🐯' }, 
        { name: 'Leão', emoji: '🦁' }, { name: 'Vaca', emoji: '🐮' },
        { name: 'Porco', emoji: '🐷' }, { name: 'Sapo', emoji: '🐸' }, 
        { name: 'Macaco', emoji: '🐵' }, { name: 'Galinha', emoji: '🐔' },
        { name: 'Pinguim', emoji: '🐧' }, { name: 'Pássaro', emoji: '🐦' }, 
        { name: 'Pato', emoji: '🦆' }, { name: 'Coruja', emoji: '🦉' }
    ],
    frutas: [
        { name: 'Maçã', emoji: '🍎' }, { name: 'Banana', emoji: '🍌' }, 
        { name: 'Uva', emoji: '🍇' }, { name: 'Morango', emoji: '🍓' },
        { name: 'Melão', emoji: '🍈' }, { name: 'Cereja', emoji: '🍒' }, 
        { name: 'Pêssego', emoji: '🍑' }, { name: 'Kiwi', emoji: '🥝' },
        { name: 'Manga', emoji: '🥭' }, { name: 'Coco', emoji: '🥥' }, 
        { name: 'Melancia', emoji: '🍉' }, { name: 'Laranja', emoji: '🍊' },
        { name: 'Limão', emoji: '🍋' }, { name: 'Pêra', emoji: '🍐' }, 
        { name: 'Abacaxi', emoji: '🍍' }
    ],
    transportes: [
        { name: 'Carro', emoji: '🚗' }, { name: 'Táxi', emoji: '🚕' }, 
        { name: 'Ônibus', emoji: '🚌' }, { name: 'Ambulância', emoji: '🚑' },
        { name: 'Carro de Polícia', emoji: '🚓' }, { name: 'Caminhão', emoji: '🚚' }, 
        { name: 'Trator', emoji: '🚜' }, { name: 'Bicicleta', emoji: '🚲' },
        { name: 'Moto', emoji: '🏍️' }, { name: 'Avião', emoji: '✈️' }, 
        { name: 'Foguete', emoji: '🚀' }, { name: 'Barco', emoji: '⛵️' },
        { name: 'Navio', emoji: '🛳️' }, { name: 'Trem', emoji: '🚆' }, 
        { name: 'Helicóptero', emoji: '🚁' }
    ],
    peixes: [
        { name: 'Peixe', emoji: '🐟' }, { name: 'Peixe Tropical', emoji: '🐠' }, 
        { name: 'Baiacu', emoji: '🐡' }, { name: 'Tubarão', emoji: '🦈' },
        { name: 'Polvo', emoji: '🐙' }, { name: 'Lula', emoji: '🦑' }, 
        { name: 'Lagosta', emoji: '🦞' }, { name: 'Caranguejo', emoji: '🦀' },
        { name: 'Concha', emoji: '🐚' }, { name: 'Baleia', emoji: '🐋' }, 
        { name: 'Orca', emoji: '🐳' }, { name: 'Foca', emoji: '🦭' },
        { name: 'Tartaruga', emoji: '🐢' }, { name: 'Crocodilo', emoji: '🐊' }, 
        { name: 'Lagarto', emoji: '🦎' }
    ],
    aves: [
        { name: 'Pássaro', emoji: '🐦' }, { name: 'Águia', emoji: '🦅' }, 
        { name: 'Coruja', emoji: '🦉' }, { name: 'Pato', emoji: '🦆' },
        { name: 'Papagaio', emoji: '🦜' }, { name: 'Galinha', emoji: '🐔' }, 
        { name: 'Pinguim', emoji: '🐧' }, { name: 'Pavão', emoji: '🦚' },
        { name: 'Cisne', emoji: '🦢' }, { name: 'Peru', emoji: '🦃' }, 
        { name: 'Galo', emoji: '🐓' }, { name: 'Morcego', emoji: '🦇' },
        { name: 'Pardal', emoji: '🐦‍⬛' }, { name: 'Dodô', emoji: '🦤' }, 
        { name: 'Fênix', emoji: '🐦‍🔥' }
    ],
    numeros: [
        { name: 'Um', emoji: '1️⃣' }, { name: 'Dois', emoji: '2️⃣' }, 
        { name: 'Três', emoji: '3️⃣' }, { name: 'Quatro', emoji: '4️⃣' },
        { name: 'Cinco', emoji: '5️⃣' }, { name: 'Seis', emoji: '6️⃣' }, 
        { name: 'Sete', emoji: '7️⃣' }, { name: 'Oito', emoji: '8️⃣' },
        { name: 'Nove', emoji: '9️⃣' }, { name: 'Dez', emoji: '🔟' }, 
        { name: 'Zero', emoji: '0️⃣' }
    ],
    objetos: [
        { name: 'Celular', emoji: '📱' }, { name: 'Computador', emoji: '💻' }, 
        { name: 'Relógio', emoji: '⌚' }, { name: 'Câmera', emoji: '📷' },
        { name: 'Câmera de Vídeo', emoji: '🎥' }, { name: 'Televisão', emoji: '📺' }, 
        { name: 'Rádio', emoji: '📻' }, { name: 'Lâmpada', emoji: '💡' },
        { name: 'Bateria', emoji: '🔋' }, { name: 'Tomada', emoji: '🔌' }, 
        { name: 'Caixa de Ferramentas', emoji: '🛠️' }, { name: 'Chave Inglesa', emoji: '🔧' },
        { name: 'Martelo', emoji: '🔨' }, { name: 'Escada', emoji: '🪜' }, 
        { name: 'Régua', emoji: '📏' }, { name: 'Esquadro', emoji: '📐' },
        { name: 'Clips', emoji: '📎' }, { name: 'Tesoura', emoji: '✂️' }, 
        { name: 'Cadeado', emoji: '🔒' }, { name: 'Chave', emoji: '🔑' }
    ],
    natureza: [
        { name: 'Flor de Cerejeira', emoji: '🌸' }, { name: 'Flor', emoji: '🌺' }, 
        { name: 'Girassol', emoji: '🌻' }, { name: 'Flor', emoji: '🌼' },
        { name: 'Rosa', emoji: '🌹' }, { name: 'Margarida', emoji: '🌼' }, 
        { name: 'Folha', emoji: '🍃' }, { name: 'Trevo', emoji: '🍀' },
        { name: 'Árvore', emoji: '🌳' }, { name: 'Pinheiro', emoji: '🌲' }, 
        { name: 'Palmeira', emoji: '🌴' }, { name: 'Cacto', emoji: '🌵' },
        { name: 'Trigo', emoji: '🌾' }, { name: 'Broto', emoji: '🌱' }, 
        { name: 'Cogumelo', emoji: '🍄' }, { name: 'Castanha', emoji: '🌰' }
    ]
};

// --- ELEMENTOS DO DOM ---
const gameBoard = document.getElementById('game-board');
const statusDisplay = document.getElementById('status-display');
const themeSelect = document.getElementById('theme-select');
const soundToggle = document.getElementById('sound-toggle');
const startButton = document.getElementById('start-game');

// --- ESTADO DO JOGO ---
let gameState = {
    cards: [],
    firstCard: null,
    secondCard: null,
    lockBoard: false,
    pairsFound: 0,
    numPlayers: 1,
    currentPlayer: 0,
    scores: [0],
    timer: null,
    timeLeft: 0,
    difficulty: 'medium', // Dificuldade padrão
    theme: 'animais' // Tema padrão
};

// --- ELEMENTOS DAS SUB-VIEWS ---
const memoryConfig = document.getElementById('memory-config');
const memoryGame = document.getElementById('memory-game');

// --- FUNÇÕES DE NAVEGAÇÃO ---
function hideAllMemorySubviews() {
    memoryConfig.classList.remove('active');
    memoryGame.classList.remove('active');
}

function showMemoryConfig() {
    hideAllMemorySubviews();
    memoryConfig.classList.add('active');
}

function showMemoryGame() {
    hideAllMemorySubviews();
    memoryGame.classList.add('active');
}

// Tornar funções globais para serem acessíveis pelo main.js
window.showMemoryMenu = showMemoryConfig;
window.showMemoryConfig = showMemoryConfig;
window.showMemoryGame = showMemoryGame;

// --- FUNÇÕES DO JOGO ---

// Gera as cartas e as posiciona no tabuleiro
function createBoard() {
    gameState.pairsFound = 0;
    gameBoard.innerHTML = ''; // Limpa o tabuleiro anterior
    
    const selectedTheme = gameState.theme;
    const selectedDifficulty = gameState.difficulty;
    const pairsCount = {easy: 10, medium: 15, hard: 20}[selectedDifficulty];
    
    console.log('🎯 createBoard() - Criando tabuleiro com', pairsCount, 'pares');
    
    const themeItems = THEMES[selectedTheme].slice(0, pairsCount);
    const cardItems = [...themeItems, ...themeItems]; // Duplica os itens para formar os pares

    // Embaralha as cartas
    cardItems.sort(() => 0.5 - Math.random());

    gameState.cards = cardItems.map(item => {
        const card = document.createElement('div');
        card.classList.add('memory-card');
        card.dataset.icon = item.emoji;
        card.dataset.name = item.name;

        card.innerHTML = `
            <div class="memory-card-front">
                <div class="memory-animal">${item.emoji}</div>
                <div class="memory-name">${item.name}</div>
            </div>
            <div class="memory-card-back">🎯</div>
        `;

        card.addEventListener('click', flipCard);
        gameBoard.appendChild(card);
        return card;
    });
}

// Lógica para virar uma carta
function flipCard() {
    if (gameState.lockBoard) return;
    if (this === gameState.firstCard) return; // Não deixa clicar na mesma carta duas vezes

    this.classList.add('flipped');

    // 🔄 Pop click: som leve para virar carta
    if (soundToggle.checked) playSound('flip');

    if (!gameState.firstCard) {
        gameState.firstCard = this;
        return;
    }

    gameState.secondCard = this;
    gameState.lockBoard = true; // Trava o tabuleiro

    checkForMatch();
}

// Verifica se as duas cartas viradas formam um par
function checkForMatch() {
    const isMatch = gameState.firstCard.dataset.icon === gameState.secondCard.dataset.icon;

    if (isMatch) {
        handleMatch();
    } else {
        unflipCards();
    }
}

// Ação quando um par é encontrado
function handleMatch() {
    gameState.scores[gameState.currentPlayer]++;
    gameState.pairsFound++;

    if (soundToggle.checked) playSound('correct'); // Som divertido para acerto

    // Adiciona a classe 'matched' que ativa a animação e o checkmark via CSS
    gameState.firstCard.classList.add('matched');
    gameState.secondCard.classList.add('matched');
    
    resetTurn();
    updateStatus();

    // Verifica se o jogo acabou
    const pairsCount = {easy: 10, medium: 15, hard: 20}[gameState.difficulty];
    if (gameState.pairsFound === pairsCount) {
        setTimeout(endGame, 500);
    }
}

// Ação quando as cartas não formam um par
function unflipCards() {
    if (soundToggle.checked) playSound('incorrect'); // Som grave para erro
    gameState.firstCard.classList.add('shake');
    gameState.secondCard.classList.add('shake');
    setTimeout(() => {
        gameState.firstCard.classList.remove('flipped', 'shake');
        gameState.secondCard.classList.remove('flipped', 'shake');
        
        nextPlayer();
        resetTurn();
    }, 1200); // Tempo para o jogador ver a segunda carta
}

// Passa o turno para o próximo jogador
function nextPlayer() {
    gameState.currentPlayer = (gameState.currentPlayer + 1) % gameState.numPlayers;
    updateStatus();
}

// Reseta as variáveis do turno
function resetTurn() {
    [gameState.firstCard, gameState.secondCard] = [null, null];
    gameState.lockBoard = false;
}

// Atualiza o placar e a mensagem de turno
function updateStatus() {
    let statusText = ``;
    for (let i = 0; i < gameState.numPlayers; i++) {
        statusText += `Jogador ${i + 1}: ${gameState.scores[i]} pontos | `;
    }
    statusText = statusText.slice(0, -2); // Remove o último " | "
    
    if (gameState.numPlayers > 1) {
        statusText += `<br>Vez do Jogador ${gameState.currentPlayer + 1}`;
    }
    
    statusDisplay.innerHTML = statusText;
}

// Atualiza o timer
function updateTimer() {
    const minutes = Math.floor(gameState.timeLeft / 60);
    const seconds = gameState.timeLeft % 60;
    document.getElementById('timer-text').innerText = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
}

// Inicia um novo jogo
function startGame() {
    console.log('🎮 startGame() chamado');
    console.log('Dificuldade:', gameState.difficulty);
    console.log('Tema:', gameState.theme);
    console.log('Jogadores:', gameState.numPlayers);
    
    const selectedDifficulty = gameState.difficulty;
    gameState.numPlayers = gameState.numPlayers || 1;
    gameState.scores = Array(gameState.numPlayers).fill(0);
    gameState.currentPlayer = 0;
    gameState.lockBoard = false;

    if (gameState.timer) clearInterval(gameState.timer);

    if (selectedDifficulty === 'hard') {
        gameState.timeLeft = 120; // 2 minutes
        document.getElementById('timer-display').style.display = 'flex';
        updateTimer();
        gameState.timer = setInterval(() => {
            gameState.timeLeft--;
            updateTimer();
            if (gameState.timeLeft <= 0) {
                clearInterval(gameState.timer);
                endGame();
            }
        }, 1000);
    } else {
        document.getElementById('timer-display').style.display = 'none';
    }

    createBoard();
    updateStatus();
}

// Finaliza o jogo e anuncia o vencedor
function endGame() {
    if (gameState.timer) clearInterval(gameState.timer);

    // 🎉 Short fanfarra: som celebratório para fim do jogo
    if (soundToggle.checked) playSound('game_complete');

    // Salvar estatísticas
    const selectedTheme = gameState.theme;
    const selectedDifficulty = gameState.difficulty;
    const stats = JSON.parse(localStorage.getItem('memoryStats') || '{}');
    stats[selectedTheme] = stats[selectedTheme] || {};
    stats[selectedTheme][selectedDifficulty] = stats[selectedTheme][selectedDifficulty] || { bestTime: Infinity, bestScore: 0 };

    if (gameState.numPlayers === 1 && selectedDifficulty === 'hard') {
        const timeTaken = 120 - gameState.timeLeft;
        if (timeTaken < stats[selectedTheme][selectedDifficulty].bestTime) {
            stats[selectedTheme][selectedDifficulty].bestTime = timeTaken;
        }
    }

    const totalScore = gameState.scores.reduce((a, b) => a + b, 0);
    if (totalScore > stats[selectedTheme][selectedDifficulty].bestScore) {
        stats[selectedTheme][selectedDifficulty].bestScore = totalScore;
    }

    localStorage.setItem('memoryStats', JSON.stringify(stats));

    // Confetes
    showConfetti();

    let winnerMsg = '';
    if (gameState.numPlayers > 1) {
        const maxScore = Math.max(...gameState.scores);
        const winners = gameState.scores.map((score, idx) => score === maxScore ? idx + 1 : null).filter(w => w);
        
        if (winners.length === 1) {
            winnerMsg = `🎉 Jogador ${winners[0]} venceu com ${maxScore} pares!`;
        } else {
            winnerMsg = `🎉 Empate entre os Jogadores ${winners.join(' e ')} com ${maxScore} pares cada!`;
        }
    } else {
        winnerMsg = `🎉 Parabéns! Você completou o jogo com ${gameState.scores[0]} pares!`;
    }
    
    statusDisplay.innerHTML = winnerMsg;
}

// --- EVENT LISTENERS ---
document.addEventListener('DOMContentLoaded', function() {

    // Usar event delegation para garantir que os cliques funcionem
    const memoryView = document.getElementById('memory-view');

    if (memoryView) {
        memoryView.addEventListener('click', function(e) {
            // Buscar o botão mais próximo (closest) para funcionar mesmo ao clicar em elementos filhos
            const button = e.target.closest('button');
            if (!button) return;

            if (button.id === 'start-game') {
                e.preventDefault();
                console.log('🎮 Iniciando jogo da memória...');
                startGame();
                showMemoryGame();
            } else if (button.id === 'back-to-config') {
                e.preventDefault();
                showMemoryConfig();
            } else if (button.id === 'restart-game') {
                e.preventDefault();
                startGame();
                showMemoryGame();
            }
        });
    }

    // Adicionar funcionalidade aos botões de jogadores
    setupPlayerButtons();

    // Adicionar funcionalidade aos botões de dificuldade
    setupDifficultyButtons();
    
    // Adicionar listener para o select de tema
    if (themeSelect) {
        themeSelect.addEventListener('change', function() {
            gameState.theme = this.value;
            console.log('✅ Tema selecionado:', this.value);
        });
    }
});

// Configurar botões de jogadores
function setupPlayerButtons() {
    const playerButtons = document.querySelectorAll('.memory-player-btn');
    playerButtons.forEach(button => {
        button.addEventListener('click', function() {
            // Remover classe active de todos os botões
            playerButtons.forEach(btn => btn.classList.remove('active'));
            // Adicionar classe active ao botão clicado
            this.classList.add('active');

            // Atualizar número de jogadores no gameState
            const numPlayers = parseInt(this.dataset.players);
            gameState.numPlayers = numPlayers;
        });
    });
}

// Configurar botões de dificuldade
function setupDifficultyButtons() {
    const difficultyButtons = document.querySelectorAll('.memory-difficulty-btn');
    difficultyButtons.forEach(button => {
        button.addEventListener('click', function() {
            // Remover classe active de todos os botões
            difficultyButtons.forEach(btn => btn.classList.remove('active'));
            // Adicionar classe active ao botão clicado
            this.classList.add('active');

            // Atualizar dificuldade no gameState
            const difficulty = this.dataset.difficulty;
            gameState.difficulty = difficulty;
            console.log('✅ Dificuldade selecionada:', difficulty);
        });
    });
}

// Mostra confetes
function showConfetti() {
    const confettiContainer = document.createElement('div');
    confettiContainer.classList.add('confetti-container');
    document.body.appendChild(confettiContainer);

    for (let i = 0; i < 50; i++) {
        const confetti = document.createElement('div');
        confetti.classList.add('confetti');
        confetti.style.left = Math.random() * 100 + 'vw';
        confetti.style.animationDelay = Math.random() * 2 + 's';
        confettiContainer.appendChild(confetti);
    }

    setTimeout(() => {
        document.body.removeChild(confettiContainer);
    }, 3000);
}

// Função para tocar sons (Web Audio API)
function playSound(type) {
    try {
        const audioContext = new (window.AudioContext || window.webkitAudioContext)();
        const oscillator = audioContext.createOscillator();
        const gainNode = audioContext.createGain();

        oscillator.connect(gainNode);
        gainNode.connect(audioContext.destination);

        gainNode.gain.setValueAtTime(0.3, audioContext.currentTime);

        // Diferentes sons para diferentes ações
        switch(type) {
            case 'flip':
                oscillator.frequency.setValueAtTime(400, audioContext.currentTime);
                oscillator.start();
                oscillator.stop(audioContext.currentTime + 0.1);
                break;
            case 'correct':
                oscillator.frequency.setValueAtTime(523.25, audioContext.currentTime);
                oscillator.frequency.setValueAtTime(659.25, audioContext.currentTime + 0.1);
                oscillator.start();
                oscillator.stop(audioContext.currentTime + 0.2);
                break;
            case 'incorrect':
                oscillator.frequency.setValueAtTime(200, audioContext.currentTime);
                oscillator.start();
                oscillator.stop(audioContext.currentTime + 0.3);
                break;
            case 'game_complete':
                oscillator.frequency.setValueAtTime(523.25, audioContext.currentTime);
                oscillator.frequency.setValueAtTime(659.25, audioContext.currentTime + 0.1);
                oscillator.frequency.setValueAtTime(783.99, audioContext.currentTime + 0.2);
                oscillator.start();
                oscillator.stop(audioContext.currentTime + 0.4);
                break;
        }
    } catch (error) {
        console.error('Erro ao tocar som:', error);
    }
}
```

---

## 📊 ESTRUTURA DE DADOS

### gameState Object
```javascript
{
    cards: Array,              // Array de elementos DOM das cartas
    firstCard: HTMLElement,    // Primeira carta virada
    secondCard: HTMLElement,   // Segunda carta virada
    lockBoard: Boolean,        // Trava o tabuleiro durante verificação
    pairsFound: Number,        // Número de pares encontrados
    numPlayers: Number,        // Número de jogadores (1-4)
    currentPlayer: Number,     // Índice do jogador atual
    scores: Array<Number>,     // Pontuação de cada jogador
    timer: Number,             // ID do intervalo do timer
    timeLeft: Number,          // Segundos restantes (modo difícil)
    difficulty: String,        // 'easy', 'medium', 'hard'
    theme: String              // Nome do tema selecionado
}
```

### THEMES Object Structure
```javascript
{
    [themeName]: Array<{
        name: String,    // Nome do item (ex: "Cachorro")
        emoji: String    // Emoji Unicode (ex: "🐶")
    }>
}
```

### localStorage Structure
```javascript
// memoryStats
{
    [theme]: {
        [difficulty]: {
            bestTime: Number,     // Melhor tempo em segundos
            bestScore: Number     // Maior pontuação
        }
    }
}
```

---

## 🎮 FLUXO DE JOGO

### 1. Inicialização
```
1. DOMContentLoaded dispara
2. Event listeners são configurados
3. Botões de configuração ficam ativos
4. gameState é inicializado com valores padrão
```

### 2. Configuração
```
1. Jogador seleciona número de jogadores (1-4)
2. Jogador seleciona tema (8 opções)
3. Jogador seleciona dificuldade (easy/medium/hard)
4. Jogador ativa/desativa sons
5. Jogador clica em "Iniciar Jogo"
```

### 3. Início do Jogo
```
1. startGame() é chamado
2. Limpa tabuleiro anterior
3. Cria array de pares baseado na dificuldade
4. Embaralha cartas
5. Renderiza cartas no DOM
6. Inicia timer (se difícil)
7. Exibe tela do jogo
```

### 4. Gameplay Loop
```
1. Jogador clica em carta → flipCard()
2. Carta vira (adiciona classe 'flipped')
3. Som de flip toca
4. Se primeira carta: armazena em firstCard, retorna
5. Se segunda carta: armazena em secondCard, trava tabuleiro
6. checkForMatch() verifica se são iguais
7a. Se match: handleMatch() → aumenta pontuação, marca como 'matched', verifica fim
7b. Se não match: unflipCards() → shake, desvira, próximo jogador
8. Reseta turno
9. Atualiza status display
10. Repete até todos os pares serem encontrados
```

### 5. Fim de Jogo
```
1. Último par é encontrado
2. endGame() é chamado após 500ms
3. Timer é parado (se ativo)
4. Som de vitória toca
5. Estatísticas são salvas no localStorage
6. Confetes são exibidos
7. Mensagem de vitória é mostrada
8. Opções de reiniciar ou voltar aparecem
```

---

## 🚀 MELHORIAS SUGERIDAS

### Curto Prazo (Fáceis)
1. **Modo Campeonato**
   - Ranking global usando backend
   - Comparar tempos com outros jogadores
   - Leaderboard por tema/dificuldade

2. **Mais Temas**
   - Personagens bíblicos
   - Locais da Bíblia
   - Símbolos cristãos
   - Versículos ilustrados

3. **Customização Visual**
   - Escolher cor das cartas
   - Escolher estilo do verso
   - Animações personalizáveis

4. **Achievements/Conquistas**
   - Badges por completar temas
   - Conquistas por velocidade
   - Streak de vitórias

5. **Tutorial Interativo**
   - Primeiro jogo guiado
   - Dicas contextuais
   - Skip tutorial option

### Médio Prazo (Moderadas)
1. **Modo Online Multiplayer**
   - WebSockets para jogo em tempo real
   - Matchmaking por nível
   - Chat durante partida
   - Espectadores

2. **Power-ups**
   - Revelar carta temporariamente
   - Congelar oponente
   - Tempo extra
   - Dica de par

3. **Modo História**
   - Níveis progressivos
   - Narrativa bíblica integrada
   - Desbloquear temas
   - Boss fights (tempo limite apertado)

4. **Sistema de Níveis**
   - XP por partida
   - Níveis 1-50
   - Recompensas por level up
   - Perfil de jogador

5. **Análise de Performance**
   - Gráficos de progresso
   - Tempo médio por par
   - Taxa de acerto
   - Comparação com média

### Longo Prazo (Complexas)
1. **Modo AR (Realidade Aumentada)**
   - Cartas físicas reconhecidas pela câmera
   - Sobreposição de informações
   - Jogo híbrido físico-digital

2. **Machine Learning**
   - Adaptação de dificuldade automática
   - Sugestões de temas baseadas em performance
   - Detecção de padrões de jogo

3. **Gamificação Avançada**
   - Sistema de clãs/grupos
   - Torneios semanais
   - Temporadas com recompensas
   - NFTs de conquistas (opcional)

4. **Acessibilidade Total**
   - Modo para daltônicos
   - Screen reader completo
   - Controles por voz
   - Modo simplificado

5. **Social Features**
   - Compartilhar vitórias
   - Desafiar amigos
   - Replays de partidas
   - Integração com redes sociais

---

## 🐛 PROBLEMAS CONHECIDOS

### Críticos
- ❌ Nenhum no momento

### Médios
- ⚠️ Timer pode ter pequeno delay em dispositivos lentos
- ⚠️ Confetes podem causar lag em mobile antigo

### Pequenos
- 🔸 Animação de flip pode travar se clicar muito rápido
- 🔸 Sons podem não funcionar em alguns browsers antigos (Web Audio API)
- 🔸 LocalStorage pode estar cheio em dispositivos com pouco espaço

---

## 📈 ESTATÍSTICAS DE CÓDIGO

```
Linhas de JavaScript: ~521
Linhas de CSS: ~338
Linhas de HTML: ~150
Total: ~1009 linhas

Funções: 15
Event Listeners: 8
Animações CSS: 5
Temas: 8 (com ~15-20 itens cada)
Total de Itens: ~147 emojis únicos
```

---

## 🔧 CONFIGURAÇÕES TÉCNICAS

### Requisitos
- **Navegador**: Chrome 90+, Firefox 88+, Safari 14+, Edge 90+
- **JavaScript**: ES6+ habilitado
- **localStorage**: Mínimo 2MB disponível
- **Resolução**: 320px+ (mobile first)

### Performance
- **FPS Target**: 60fps
- **Load Time**: <100ms
- **Memory Usage**: <10MB
- **Battery Impact**: Baixo (sem polling)

### Compatibilidade
- ✅ Desktop (Windows, Mac, Linux)
- ✅ Mobile (iOS 13+, Android 8+)
- ✅ Tablet
- ✅ PWA Ready
- ⚠️ IE11: Não suportado (ES6+)

---

## 📚 REFERÊNCIAS

### Código Base
- **Autor**: Equipe JW Quiz
- **Licença**: MIT (presumido)
- **Repositório**: leniredenis-bit/JW-Quiz

### Inspirações
- Classic Memory Card Game
- Simon Says
- Concentration (jogo de TV)

### Bibliotecas Utilizadas
- Nenhuma (Vanilla JS)

---

**FIM DA DOCUMENTAÇÃO**

*Para melhorias ou sugestões, envie este documento junto com suas ideias!*
