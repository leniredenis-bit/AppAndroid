# 🤝 Guia de Contribuição - JW Quiz

Obrigado por considerar contribuir para o JW Quiz! Este documento fornece diretrizes para contribuições.

## 📋 Índice

- [Como Contribuir](#como-contribuir)
- [Padrões de Código](#padrões-de-código)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Processo de Pull Request](#processo-de-pull-request)
- [Reportar Bugs](#reportar-bugs)
- [Sugerir Funcionalidades](#sugerir-funcionalidades)

---

## 🚀 Como Contribuir

### 1. Fork e Clone

```bash
# Fork no GitHub, depois clone seu fork
git clone https://github.com/SEU-USUARIO/JW-Quiz.git
cd JW-Quiz
```

### 2. Crie uma Branch

```bash
# Use nomes descritivos
git checkout -b feature/nova-funcionalidade
git checkout -b fix/correcao-bug
git checkout -b docs/melhoria-documentacao
```

### 3. Faça suas Mudanças

- Siga os padrões de código
- Teste localmente antes de commitar
- Mantenha commits pequenos e focados

### 4. Commit

```bash
# Use mensagens claras e padronizadas
git commit -m "feat: adiciona filtro de busca avançada"
git commit -m "fix: corrige erro no cálculo de pontos"
git commit -m "docs: atualiza README com novas features"
```

### 5. Push e Pull Request

```bash
git push origin feature/nova-funcionalidade
```

Depois abra um Pull Request no GitHub!

---

## 📝 Padrões de Código

### JavaScript

```javascript
// ✅ BOM - Use camelCase para variáveis e funções
function calculateScore(time, difficulty) {
    const baseScore = 1.0;
    const timeBonus = Math.max(0, time / 10) * 0.1;
    return baseScore + timeBonus;
}

// ✅ BOM - Comentários claros
/**
 * Filtra perguntas por dificuldade
 * @param {Array} questions - Array de perguntas
 * @param {number} difficulty - Nível (1=fácil, 2=médio, 3=difícil)
 * @returns {Array} Perguntas filtradas
 */
function filterByDifficulty(questions, difficulty) {
    return questions.filter(q => q.dificuldade === difficulty);
}

// ❌ RUIM - Sem comentários, nomes confusos
function f(q, d) {
    return q.filter(x => x.d === d);
}
```

### HTML

```html
<!-- ✅ BOM - Semântico e acessível -->
<button 
    class="btn btn-primary" 
    aria-label="Iniciar quiz"
    onclick="startQuiz()"
>
    Começar
</button>

<!-- ❌ RUIM - Sem acessibilidade -->
<div onclick="startQuiz()">Começar</div>
```

### CSS

```css
/* ✅ BOM - BEM naming convention */
.quiz-card {
    padding: 1rem;
}

.quiz-card__title {
    font-size: 1.5rem;
}

.quiz-card--highlighted {
    background: #f0f0f0;
}

/* ❌ RUIM - Nomes genéricos */
.card {
    padding: 1rem;
}
```

---

## 🏗️ Estrutura do Projeto

### Organização de Arquivos

```
JS/
├── main.js              # Core: UI, navegação, inicialização
├── quiz.js              # Lógica do quiz (perguntas, respostas, timer)
├── admin.js             # Painel administrativo
├── pointsCalc.js        # Cálculo de pontuação
├── achievements.js      # Sistema de conquistas
├── tagsWidget.js        # Componente de tags
└── userIdentity.js      # Gestão de usuário e sessão
```

### Convenções de Nomenclatura

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| **Arquivos JS** | camelCase.js | `userIdentity.js` |
| **Arquivos CSS** | kebab-case.css | `admin-panel.css` |
| **Variáveis** | camelCase | `currentQuestion` |
| **Constantes** | UPPER_SNAKE_CASE | `MAX_QUESTIONS` |
| **Funções** | camelCase | `calculateScore()` |
| **Classes CSS** | kebab-case | `quiz-container` |

---

## 🔄 Processo de Pull Request

### Checklist Antes de Enviar

- [ ] Código testado localmente
- [ ] Sem erros no console (F12)
- [ ] Funciona em Chrome, Firefox e Edge
- [ ] Responsivo (testado em mobile)
- [ ] Comentários adicionados onde necessário
- [ ] Documentação atualizada (se aplicável)
- [ ] Commit messages seguem o padrão

### Template de PR

```markdown
## 📝 Descrição
Breve descrição das mudanças

## 🎯 Motivação
Por que essas mudanças são necessárias?

## 🧪 Como Testar
1. Passo a passo para reproduzir
2. Resultado esperado

## 📸 Screenshots (se aplicável)
Antes | Depois

## ✅ Checklist
- [ ] Testado localmente
- [ ] Sem erros no console
- [ ] Cross-browser testado
- [ ] Mobile-friendly
```

---

## 🐛 Reportar Bugs

### Como Reportar

Use o template abaixo no GitHub Issues:

```markdown
**Descrição do Bug**
Descrição clara e concisa

**Passos para Reproduzir**
1. Vá para '...'
2. Clique em '...'
3. Veja o erro

**Comportamento Esperado**
O que deveria acontecer

**Screenshots**
Se aplicável

**Ambiente**
- Navegador: [Chrome 118]
- OS: [Windows 11]
- Versão: [1.4.0]
```

---

## 💡 Sugerir Funcionalidades

### Template de Feature Request

```markdown
**Funcionalidade Desejada**
Descrição clara

**Problema que Resolve**
Que problema isso resolve?

**Alternativas Consideradas**
Outras soluções pensadas

**Contexto Adicional**
Screenshots, mockups, etc.
```

---

## 📚 Recursos Úteis

### Documentação do Projeto
- [README Principal](../README.md)
- [Documentação do Quiz](DOCUMENTACAO_QUIZ.md)
- [Documentação do Painel Admin](ADMIN_PANEL_README.md)
- [CHANGELOG](../CHANGELOG.md)

### Links Externos
- [Conventional Commits](https://www.conventionalcommits.org/)
- [BEM CSS](http://getbem.com/)
- [JavaScript Style Guide](https://github.com/airbnb/javascript)
- [MDN Web Docs](https://developer.mozilla.org/)

---

## ⚙️ Configuração do Ambiente

### Desenvolvimento

```bash
# Servidor local
python -m http.server 8000

# Ou use o script
./start-server.bat  # Windows
```

### Estrutura de Pastas Recomendada

```
JW-Quiz/
├── 📂 docs/           # Documentação técnica
├── 📂 CSS/            # Estilos (modulares)
├── 📂 JS/             # JavaScript (modular)
├── 📂 DATA/           # Dados (JSON)
├── 📂 scripts/        # Scripts Python auxiliares
└── 📂 audio/          # Arquivos de áudio
```

---

## 🎨 Padrões de Design

### Cores

```css
:root {
    --primary: #2b6cb0;
    --success: #218838;
    --danger: #c82333;
    --text: #0b1220;
}
```

### Espaçamento

Use múltiplos de 0.25rem (4px):
- `0.25rem` = 4px
- `0.5rem` = 8px
- `1rem` = 16px
- `1.5rem` = 24px

---

## 🙏 Código de Conduta

- Seja respeitoso e inclusivo
- Aceite feedback construtivo
- Foque no que é melhor para a comunidade
- Mostre empatia com outros membros

---

## 📞 Contato

Dúvidas? Entre em contato:
- **Issues**: [GitHub Issues](https://github.com/leniredenis-bit/JW-Quiz/issues)
- **Discussões**: [GitHub Discussions](https://github.com/leniredenis-bit/JW-Quiz/discussions)

---

**Obrigado por contribuir! 🎉**
