# 📘 Guia de Edição do CSS - JW Quiz

Este arquivo explica como o CSS está organizado e como editar cada página individualmente.

## 📑 Estrutura do Arquivo `style.css`

O arquivo CSS está organizado em **seções bem definidas** com marcadores visuais para facilitar a navegação.

### 🔍 Como Navegar no Arquivo

Use **Ctrl+F** (ou Cmd+F no Mac) para buscar os seguintes marcadores:

```
[VARIÁVEIS]        - Temas claro/escuro, cores, sombras
[RESET]            - Reset básico e estilos globais
[SISTEMA DE VIEWS] - Sistema de controle de páginas
[COMPONENTES GLOBAIS] - Botões, inputs, cards compartilhados
```

### 📄 Páginas Principais

Cada página tem seu próprio bloco no CSS:

| Marcador | Descrição | ID HTML |
|----------|-----------|---------|
| **[PÁGINA: WELCOME]** | Tela inicial de boas-vindas | `#welcome-view` |
| **[PÁGINA: HOME]** | Menu do Quiz (temas/dificuldades) | `#home-view` |
| **[PÁGINA: QUIZ]** | Tela de perguntas e respostas | `#quiz-view` |
| **[PÁGINA: MEMORY]** | Jogo da memória | `#memory-view` |
| **[PÁGINA: STATS]** | Estatísticas do usuário | `#stats-view` |
| **[PÁGINA: ADMIN]** | Gerenciamento de questões | `#admin-view` |
| **[PÁGINA: GROUP]** | Partida em grupo | `#group-view` |
| **[PÁGINA: LEGAL]** | Informações legais | `#legal-view` |

### 📱 Responsividade

| Marcador | Descrição | Breakpoint |
|----------|-----------|------------|
| **[MEDIA: TABLET]** | Ajustes para tablets | `max-width: 768px` |
| **[MEDIA: MOBILE]** | Ajustes para smartphones | `max-width: 480px` |

---

## 🎯 Como Editar Uma Página Específica

### Exemplo 1: Editar a Página de Boas-Vindas

1. Abra `style.css`
2. Pressione **Ctrl+F**
3. Busque por: `[PÁGINA: WELCOME]`
4. Você encontrará todos os estilos da tela inicial

```css
/* ╔═══════════════════════════════════════════════════════════════╗
   ║  [PÁGINA: WELCOME] - TELA INICIAL DE BOAS-VINDAS             ║
   ╚═══════════════════════════════════════════════════════════════╝ */

.welcome-hero {
    /* Seus estilos aqui */
}
```

### Exemplo 2: Editar o Menu do Quiz

1. Busque por: `[PÁGINA: HOME]`
2. Edite os estilos de `#home-view`

```css
/* ╔═══════════════════════════════════════════════════════════════╗
   ║  [PÁGINA: HOME] - MENU PRINCIPAL DO QUIZ                     ║
   ╚═══════════════════════════════════════════════════════════════╝ */

#home-view {
    /* Seus estilos aqui */
}
```

---

## ⚠️ IMPORTANTE: Sistema de Views

### Como Funciona

O sistema de **views** (páginas) funciona assim:

- Cada `<section class="view">` é uma página completa
- **Apenas UMA view** pode ter a classe `.active` por vez
- Views inativas têm `display: none !important` (ficam completamente ocultas)
- View ativa tem `display: block !important` (fica visível)

### Regras de Ouro

✅ **FAÇA:**
- Use seletores específicos para cada página (ex: `#home-view .btn`)
- Use `position: relative` para posicionamento dentro da view
- Mantenha cada view autocontida e independente

❌ **NÃO FAÇA:**
- Não use `position: fixed` em elementos da view (apenas em modais globais)
- Não use `position: absolute` que ultrapasse os limites da view
- Não crie estilos globais que afetem todas as páginas sem querer

### Exemplo de Estrutura Correta

```css
/* Correto: escopo específico para a página */
#home-view {
    position: relative;  /* ✅ OK */
    min-height: 100vh;
}

#home-view .btn {
    /* Estilos apenas para botões da home */
}

/* Errado: pode causar sobreposição */
.view {
    position: fixed;  /* ❌ NÃO! */
    top: 0;
    left: 0;
}
```

---

## 🐛 Problemas Comuns

### Problema: "Vejo duas páginas ao mesmo tempo"

**Causa:** Algum elemento está usando `position: fixed` ou `absolute` incorretamente.

**Solução:**
1. Busque por `position: fixed` no CSS
2. Verifique se está dentro de um marcador `[PÁGINA: X]`
3. Se estiver, troque para `position: relative` ou remova

### Problema: "Uma página não aparece"

**Causa:** A classe `.active` não está sendo adicionada corretamente.

**Solução:**
1. Verifique no JavaScript se a view está recebendo a classe `.active`
2. Verifique se não há CSS conflitante com `display: none` mais específico

### Problema: "Estilos de uma página aparecem em outra"

**Causa:** Seletores CSS muito genéricos afetando múltiplas páginas.

**Solução:**
1. Use seletores específicos: `#home-view .btn` em vez de apenas `.btn`
2. Verifique a seção `[COMPONENTES GLOBAIS]` - pode ser estilo compartilhado

---

## 📝 Convenções de Código

### Nomenclatura

- Use **kebab-case** para classes: `.memory-config-hero`
- Use **IDs com #** para páginas: `#home-view`
- Prefixe componentes de uma página: `.memory-*`, `.quiz-*`, `.stats-*`

### Organização

Dentro de cada seção de página, organize assim:

1. Container principal da página
2. Headers e títulos
3. Conteúdo principal
4. Botões e controles
5. Footer da página
6. Estados (hover, active, disabled)

### Exemplo

```css
/* [PÁGINA: EXEMPLO] */

/* 1. Container */
#exemplo-view {
    /* ... */
}

/* 2. Header */
#exemplo-view .header {
    /* ... */
}

/* 3. Conteúdo */
#exemplo-view .content {
    /* ... */
}

/* 4. Botões */
#exemplo-view .btn {
    /* ... */
}

/* 5. Footer */
#exemplo-view .footer {
    /* ... */
}

/* 6. Estados */
#exemplo-view .btn:hover {
    /* ... */
}
```

---

## 🎨 Variáveis CSS

Todas as cores e estilos globais estão na seção `[VARIÁVEIS]`:

```css
:root {
    --bg-primary: #f0f2f5;
    --text-primary: #1c1e21;
    --btn-primary: #3a6ea5;
    /* ... */
}
```

**Para mudar cores:** Edite apenas as variáveis, não os valores diretos.

---

## 🚀 Dicas de Produtividade

1. **Use o índice no topo do arquivo** - há uma lista completa de todas as seções
2. **Ctrl+F é seu amigo** - busque pelos marcadores `[PÁGINA: X]`
3. **Edite apenas a seção relevante** - não mexa em outras páginas
4. **Teste em modo responsivo** - use DevTools (F12) para simular mobile
5. **Comente suas mudanças** - deixe comentários explicando o que fez

---

## 📚 Recursos Adicionais

- **VSCode Extension:** Instale "CSS Navigation" para pular entre seletores
- **DevTools:** Use F12 > Elements > Styles para ver CSS aplicado em tempo real
- **Validação:** Use o W3C CSS Validator para verificar erros

---

## 💡 Exemplos Práticos

### Mudar cor de fundo do Quiz

```css
/* Busque por: [PÁGINA: QUIZ] */
.quiz-card {
    background: var(--bg-secondary);  /* ← Mude para outra cor */
}
```

### Aumentar tamanho dos botões da Home

```css
/* Busque por: [PÁGINA: HOME] */
#home-view .buttons-row .btn {
    padding: 1rem 1.5rem;  /* ← Aumente o padding */
    font-size: 1.2rem;     /* ← Aumente o font-size */
}
```

### Ajustar layout mobile

```css
/* Busque por: [MEDIA: MOBILE] */
@media (max-width: 480px) {
    #home-view .menu {
        padding: 0.5rem;  /* ← Reduza padding em mobile */
    }
}
```

---

**Última atualização:** Novembro 2025  
**Versão do CSS:** 2.0 (Reorganizado e Documentado)
