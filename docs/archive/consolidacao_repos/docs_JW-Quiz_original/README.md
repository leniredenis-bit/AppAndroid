# 📖 JW Quiz

[![Version](https://img.shields.io/badge/version-1.4.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Made with Love](https://img.shields.io/badge/made%20with-❤️-red.svg)](https://github.com/leniredenis-bit/JW-Quiz)

Um quiz interativo sobre conhecimentos bíblicos com **mais de 1.100 perguntas**, sistema de pontuação avançado, jogo da memória e painel administrativo completo.

🌐 **[Jogar Online](https://leniredenis-bit.github.io/JW-Quiz/)**

---

## ✨ Funcionalidades

### 🎮 Para Jogadores
- **📚 1.181 Perguntas**: Base de dados completa com perguntas de diversos temas bíblicos
- **🎯 Quiz Personalizado**: Filtre por tema, dificuldade e personalize a experiência
- **🧠 Jogo da Memória**: Teste sua memória com versículos e personagens bíblicos
- **⚡ Sistema de Pontos**: Bônus por velocidade, streak e dificuldade
- **📊 Estatísticas**: Acompanhe seu desempenho e progresso
- **🌓 Tema Claro/Escuro**: Interface adaptável às suas preferências
- **� PWA**: Instale como app e jogue offline

### 👨‍💼 Para Administradores
- **🎛️ Painel Admin**: Interface completa para gerenciar perguntas
- **🏷️ Sistema de Tags**: Organize com tags e contadores de uso
- **✏️ Editor Inline**: Edite perguntas diretamente na interface
- **🔍 Busca Avançada**: Filtre por ID, texto, tags ou dificuldade
- **🗑️ Limpeza Automática**: Remova tags pouco usadas em massa
- **💾 Backup Automático**: Segurança nas alterações

---

## � Começando

### Online (Recomendado)
Acesse diretamente: **https://leniredenis-bit.github.io/JW-Quiz/**

### Desenvolvimento Local

```bash
# 1. Clone o repositório
git clone https://github.com/leniredenis-bit/JW-Quiz.git

# 2. Entre na pasta
cd JW-Quiz

# 3. Inicie o servidor local
python -m http.server 8000
# Ou use start-server.bat no Windows

# 4. Abra no navegador
http://localhost:8000
```

> ⚠️ **Importante**: Não abra o arquivo HTML diretamente (file://), sempre use um servidor HTTP para evitar erros de CORS.

---

## 📁 Estrutura do Projeto

```
JW-Quiz/
├── 📄 index.html              # Página principal
├── 📄 pontos.html             # Sistema de pontuação
├── 📱 manifest.json           # Configuração PWA
├── ⚙️ sw.js                   # Service Worker
│
├── 📂 CSS/
│   ├── style.css              # Estilos principais
│   ├── admin.css              # Estilos do painel admin
│   └── components-tags.css    # Componentes de tags
│
├── 📂 JS/
│   ├── main.js                # Lógica principal e UI
│   ├── quiz.js                # Motor do quiz
│   ├── admin.js               # Painel administrativo
│   ├── achievements.js        # Sistema de conquistas
│   ├── pointsCalc.js          # Cálculo de pontuação
│   └── ...                    # Outros módulos
│
├── 📂 DATA/
│   └── perguntas.json         # Base de 1.181 perguntas
│
├── 📂 docs/                   # Documentação técnica
│   ├── ADMIN_PANEL_README.md
│   ├── DOCUMENTACAO_QUIZ.md
│   └── ...
│
└── 📂 scripts/                # Scripts Python auxiliares
    └── clean_tags_less_than_10.py
```

---

## 🎮 Como Jogar

### Quiz
1. **Escolha um modo**: Rápido, Por Tema ou Personalizado
2. **Responda as perguntas** dentro do tempo limite
3. **Ganhe pontos** por acertos, velocidade e streak
4. **Veja seu resultado** e compare com outros

### Jogo da Memória
1. **Selecione a dificuldade**: Fácil (8 cards), Médio (16 cards) ou Difícil (20 cards)
2. **Encontre os pares**: Combine versículos com referências
3. **Complete no menor tempo** possível

---

## 🎯 Sistema de Pontuação

| Critério | Pontos |
|----------|--------|
| **Acerto Base** | +1.0 |
| **Bônus de Velocidade** | +0.0 a +0.1 (baseado no tempo restante) |
| **Streak** | +0.01 por acerto consecutivo |
| **Dificuldade** | Multiplicador baseado no nível |
| **Erro** | -0.1 |

**Exemplo**: Acertar em 5s com streak de 3 em questão difícil = **1.53 pontos**

---

## 👨‍💼 Painel Administrativo

Acesse através do menu "👤 Admin" na página inicial.

### Funcionalidades
- ✏️ Editar perguntas existentes
- 🔍 Buscar por ID, texto ou tags
- 🏷️ Gerenciar tags (com contador de usos)
- ☑️ Seleção múltipla para deletar tags
- 🗑️ Remover automaticamente tags com < 10 usos
- 💾 Salvar alterações com backup

📚 **[Documentação Completa do Painel Admin](docs/ADMIN_PANEL_README.md)**

---

## 📱 Instalar como App (PWA)

1. Abra no **Chrome** ou **Edge**
2. Clique no ícone **⊕ Instalar** na barra de endereço
3. Ou vá em **Menu → Instalar JW Quiz**
4. Pronto! Agora funciona offline 🎉

---

## 🛠️ Tecnologias

- **HTML5/CSS3**: Interface moderna e responsiva
- **JavaScript (Vanilla)**: Sem frameworks, puro JS
- **PWA**: Service Worker para funcionamento offline
- **LocalStorage**: Persistência de dados local
- **Web Audio API**: Efeitos sonoros
- **Python**: Scripts auxiliares de manutenção

---

## 📚 Documentação

- **[Painel Admin](docs/ADMIN_PANEL_README.md)** - Guia completo do painel administrativo
- **[Quiz](docs/DOCUMENTACAO_QUIZ.md)** - Documentação técnica do quiz
- **[Jogo da Memória](docs/DOCUMENTACAO_JOGO_MEMORIA.md)** - Como funciona o jogo
- **[Design](docs/DESIGN_SUGESTOES.md)** - Sugestões de design e UI/UX
- **[CHANGELOG](CHANGELOG.md)** - Histórico de versões
- **[Melhorias Futuras](MELHORIAS_FUTURAS.md)** - Roadmap do projeto

---

## 🤝 Contribuindo

Contribuições são bem-vindas! 

1. **Fork** o projeto
2. **Crie uma branch**: `git checkout -b feature/MinhaFeature`
3. **Commit** suas mudanças: `git commit -m 'feat: Minha nova feature'`
4. **Push** para a branch: `git push origin feature/MinhaFeature`
5. **Abra um Pull Request**

### Padrões de Commit
- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Mudanças na documentação
- `style:` Formatação, espaçamento (não altera código)
- `refactor:` Refatoração de código
- `test:` Adição ou correção de testes
- `chore:` Tarefas de manutenção

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👨‍💻 Autor

**Lenire Denis**
- GitHub: [@leniredenis-bit](https://github.com/leniredenis-bit)
- Repositório: [JW-Quiz](https://github.com/leniredenis-bit/JW-Quiz)

---

## ⭐ Apoie o Projeto

Se este projeto te ajudou, considere dar uma ⭐ no GitHub!

**Desenvolvido com ❤️ para compartilhar conhecimentos bíblicos**
