# 🎨 GUIA DE DESIGN - Ícones e Screenshots

## 📱 ESPECIFICAÇÕES TÉCNICAS

### **Ícone do App**
- **Tamanho:** 1024x1024 pixels
- **Formato:** PNG com transparência (ou fundo sólido)
- **Cor de fundo:** `#1a1a2e` (azul escuro do app)
- **Espaço seguro:** 20% de margem nas bordas
- **Conteúdo:** Logo/símbolo centralizado

### **Splash Screen**
- **Tamanho:** 2732x2732 pixels
- **Formato:** PNG
- **Cor de fundo:** `#1a1a2e` (azul escuro)
- **Conteúdo:** Mesmo design do ícone, pode adicionar texto

### **Screenshots Android**
- **Tamanho:** 1080x1920 pixels (proporção 9:16)
- **Formato:** PNG ou JPG
- **Quantidade:** Mínimo 2, máximo 8, recomendado 5-6
- **Qualidade:** Alta resolução, sem desfoque

### **Screenshots iOS**
- **iPhone 6.7":** 1290x2796 pixels
- **iPhone 6.5":** 1242x2688 pixels
- **iPad Pro 12.9":** 2048x2732 pixels
- **Formato:** PNG ou JPG

---

## 🎨 SUGESTÕES DE DESIGN PARA O ÍCONE

### **Conceito 1: Bíblia + Quiz**
```
┌────────────────────┐
│                    │
│    📖 + 🎯        │   Bíblia aberta + alvo de quiz
│    ────────        │
│   JW QUIZ          │   Nome abaixo (opcional)
│                    │
└────────────────────┘
```

### **Conceito 2: Pergunta Bíblica**
```
┌────────────────────┐
│                    │
│       ❓          │   Ponto de interrogação grande
│      ────          │
│      📖           │   Bíblia embaixo
│                    │
└────────────────────┘
```

### **Conceito 3: Minimalista**
```
┌────────────────────┐
│                    │
│                    │
│       🕊️         │   Símbolo religioso simples
│       JW           │   Iniciais
│                    │
└────────────────────┘
```

### **Paleta de Cores do App**
```css
--color-bg-dark: #1a1a2e        /* Fundo principal */
--color-primary: #4a90e2        /* Azul primário */
--color-accent: #f39c12         /* Dourado/laranja */
--color-success: #2ecc71        /* Verde acertos */
--color-danger: #e74c3c         /* Vermelho erros */
--color-text-light: #ecf0f1     /* Texto claro */
```

---

## 🖼️ SCREENSHOTS - O QUE MOSTRAR

### **Screenshot 1: Tela Inicial** (OBRIGATÓRIO)
Mostre:
- Logo JW Quiz
- Botões principais (Quiz Bíblico, Jogo da Memória)
- Interface limpa e moderna
- Tema escuro ativado

**Texto sugerido:**
```
"Bem-vindo ao Quiz Bíblico JW
Mais de 1180 perguntas para testar seu conhecimento"
```

### **Screenshot 2: Quiz em Ação** (OBRIGATÓRIO)
Mostre:
- Uma pergunta bíblica
- 4 opções de resposta
- Pontuação visível
- Timer (se tiver)

**Texto sugerido:**
```
"4 Modos de Jogo Diferentes
Rápido, Estudo, Combate e Personalizado"
```

### **Screenshot 3: Modo Combate** (RECOMENDADO)
Mostre:
- Dois jogadores competindo
- Placar dividido
- Interface de batalha

**Texto sugerido:**
```
"Desafie Seus Amigos
Modo Combate para 2 jogadores"
```

### **Screenshot 4: Jogo da Memória** (RECOMENDADO)
Mostre:
- Tabuleiro de memória
- Cards com emojis
- Pontuação

**Texto sugerido:**
```
"Jogo da Memória Educativo
8 temas diferentes para todas as idades"
```

### **Screenshot 5: Estatísticas** (RECOMENDADO)
Mostre:
- Gráficos de progresso
- Conquistas desbloqueadas
- Recordes

**Texto sugerido:**
```
"Acompanhe Seu Progresso
Estatísticas detalhadas e conquistas"
```

### **Screenshot 6: Filtros Personalizados** (OPCIONAL)
Mostre:
- Seleção de tags
- Dificuldade
- Quantidade de perguntas

**Texto sugerido:**
```
"Personalize Sua Experiência
Escolha temas, dificuldade e quantidade"
```

---

## 🛠️ FERRAMENTAS GRATUITAS

### **Para Criar Ícones:**

**1. Canva (Recomendado)**
- Site: https://www.canva.com/
- Gratuito com templates prontos
- Fácil de usar
- Exporta em alta qualidade

**Como usar:**
1. Criar conta gratuita
2. Pesquisar "app icon" ou "mobile app logo"
3. Escolher template
4. Personalizar cores (#1a1a2e de fundo)
5. Adicionar símbolos: 📖 🎯 ❓ 🕊️
6. Baixar como PNG 1024x1024

**2. Figma**
- Site: https://www.figma.com/
- Gratuito para uso pessoal
- Mais profissional
- Curva de aprendizado média

**3. GIMP**
- Site: https://www.gimp.org/
- Gratuito e open source
- Alternativa ao Photoshop
- Mais complexo

### **Para Tirar Screenshots:**

**1. No Navegador (Mais Fácil)**
1. Abra o app no Chrome
2. Pressione F12 (DevTools)
3. Click no ícone de celular 📱
4. Escolha "Responsive" e configure 1080x1920
5. Capture: Ctrl + Shift + P → "Capture screenshot"

**2. Emulador Android**
1. Android Studio → AVD Manager
2. Inicie emulador Pixel 5
3. Abra o app
4. Capture: Ctrl + S (ou botão na lateral)

**3. LightShot**
- Site: https://prnt.sc/
- Ferramenta de screenshot leve
- Atalho: Print Screen
- Edição rápida

### **Para Editar Screenshots:**

**1. Adicionar Texto/Destaques:**
- Canva: Adicione frames de celular e textos
- Figma: Crie mockups profissionais
- Snagit: Ferramenta paga (trial gratuito)

**2. Criar Mockups:**
- Mockuphone.com (gratuito)
- Smartmockups.com (templates prontos)
- Placeit.net (mockups profissionais)

**Template de mockup:**
```
┌─────────────────────────────────┐
│  ┌───────────────────────┐      │
│  │                       │      │  [Texto descritivo ao lado]
│  │   [Screenshot aqui]   │  ◄───┤  "Mais de 1180 perguntas
│  │                       │      │   para testar seu
│  └───────────────────────┘      │   conhecimento bíblico!"
│                                 │
└─────────────────────────────────┘
```

---

## 📋 CHECKLIST DE DESIGN

### **Ícone:**
- [ ] Tamanho correto (1024x1024)
- [ ] Fundo #1a1a2e ou transparente
- [ ] Símbolo centralizado e claro
- [ ] Visível mesmo pequeno (48x48)
- [ ] Sem texto muito pequeno
- [ ] Contraste adequado
- [ ] Exportado em PNG de alta qualidade

### **Splash Screen:**
- [ ] Tamanho correto (2732x2732)
- [ ] Fundo #1a1a2e
- [ ] Logo/símbolo centralizado
- [ ] Nome do app (opcional)
- [ ] Versão simples (carrega rápido)
- [ ] Exportado em PNG

### **Screenshots:**
- [ ] Mínimo 2, recomendado 5-6
- [ ] Resolução correta (1080x1920 Android)
- [ ] Mostram funcionalidades principais
- [ ] Texto legível e claro
- [ ] Sem informações pessoais
- [ ] Ordem lógica (Início → Uso → Features)
- [ ] Qualidade alta (sem blur)

---

## 💡 DICAS PROFISSIONAIS

### **Ícone:**
✅ **FAÇA:**
- Use cores do tema do app (#1a1a2e, #4a90e2)
- Mantenha design simples e reconhecível
- Teste em tamanhos pequenos (48x48, 72x72)
- Use símbolos universais (📖 bíblia, 🎯 quiz)
- Evite gradientes complexos

❌ **EVITE:**
- Texto muito pequeno
- Muitos detalhes (não ficam visíveis)
- Fotos realistas (ficam confusas)
- Bordas muito finas
- Cores muito similares (baixo contraste)

### **Screenshots:**
✅ **FAÇA:**
- Mostre o app em USO (não menus vazios)
- Use dados reais (perguntas bíblicas)
- Adicione textos descritivos
- Destaque diferenciais (1180 perguntas, 4 modos)
- Use mesma fonte em todos os screenshots

❌ **EVITE:**
- Screenshots muito escuras
- Textos muito longos
- Informações confusas
- Screenshots repetitivas
- Erros de português

### **Descrição Visual:**
- Primeira impressão em < 3 segundos
- Screenshots contam uma história
- Ordem: Problema → Solução → Benefícios
- Exemplo: Inicial → Quiz → Estatísticas

---

## 🎯 INSPIRAÇÃO - Exemplos de Texto

### **Para Screenshots:**

**Screenshot 1:**
```
📖 QUIZ BÍBLICO COMPLETO
Mais de 1180 perguntas cuidadosamente selecionadas
```

**Screenshot 2:**
```
🎯 4 MODOS DE JOGO
Rápido • Estudo • Combate • Personalizado
```

**Screenshot 3:**
```
⚔️ DESAFIE AMIGOS
Modo combate para 2 jogadores
```

**Screenshot 4:**
```
🧠 JOGO DA MEMÓRIA
8 temas educativos diferentes
```

**Screenshot 5:**
```
📊 ACOMPANHE SEU PROGRESSO
Estatísticas e conquistas detalhadas
```

---

## 🖼️ EXEMPLOS VISUAIS ASCII

### **Ícone - Layout Sugerido:**
```
╔════════════════════════════╗
║                            ║
║         ┌─────────┐        ║
║         │  📖  🎯 │        ║
║         │  ─────  │        ║
║         │   JW    │        ║
║         └─────────┘        ║
║                            ║
╚════════════════════════════╝
Fundo: #1a1a2e (azul escuro)
Símbolos: Brancos ou dourados
```

### **Splash Screen - Layout:**
```
╔═══════════════════════════════╗
║                               ║
║                               ║
║          📖 + 🎯            ║
║          ─────────            ║
║         JW Quiz               ║
║    Quiz Bíblico Interativo    ║
║                               ║
║         v1.0.0                ║
║                               ║
╚═══════════════════════════════╝
Animação: Fade in 2 segundos
```

---

## 📱 GERADOR AUTOMÁTICO DE ÍCONES

Depois de criar o ícone 1024x1024, use:

```powershell
# Instalar ferramenta
npm install -g cordova-res

# Criar pasta
mkdir resources

# Colocar icon.png (1024x1024) na pasta resources/

# Gerar todos os tamanhos automaticamente
cordova-res android --skip-config --copy
```

Isso gera:
- mipmap-hdpi (72x72)
- mipmap-mdpi (48x48)
- mipmap-xhdpi (96x96)
- mipmap-xxhdpi (144x144)
- mipmap-xxxhdpi (192x192)

---

## 🎨 TEMPLATE PRONTO

Baixe templates prontos:

**Canva:**
- Template 1: "Mobile App Icon - Bible Quiz"
- Template 2: "Religious App Logo"
- Template 3: "Educational Game Icon"

**Figma Community:**
- Pesquise: "bible app icon"
- Pesquise: "quiz app design"
- Pesquise: "mobile app mockup"

---

## ✅ APROVAÇÃO NAS LOJAS

### **Google Play - Requisitos:**
- Ícone claro e profissional
- Screenshots mostrando o app real
- Sem enganação (o que mostra = o que entrega)
- Sem conteúdo sensível sem avisos

### **Apple Store - Requisitos:** (mais rigoroso)
- Screenshots DEVEM corresponder exatamente ao app
- Ícone sem bordas arredondadas (iOS adiciona automaticamente)
- Textos nos screenshots devem estar corretos
- Sem informações enganosas

---

## 🆘 AJUDA

**Não sabe fazer design?**
1. Use templates do Canva (gratuito)
2. Copie estilo de apps similares (não o logo!)
3. Mantenha simples e profissional
4. Peça feedback antes de publicar

**Precisa de ajuda profissional?**
- Fiverr: US$5-30 para ícone + splash
- 99designs: Concurso de design (vários designers)
- Freelancer.br: Designers brasileiros

---

**Pronto para criar?** Abra o Canva e comece agora! 🎨
