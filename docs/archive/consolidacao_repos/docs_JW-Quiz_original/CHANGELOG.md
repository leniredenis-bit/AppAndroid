# Changelog - JW Quiz

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

## [1.4.0] - 2025-11-07

### 🎨 Painel Administrativo
- ✅ **Novo painel admin completo** para gerenciamento de perguntas
  - Interface moderna e responsiva com tema claro/escuro
  - Editor inline de perguntas com validação
  - Sistema de filtros por dificuldade, tags e busca em tempo real
  - Busca ativada por Enter e botão 🔍
  - Paginação de resultados (10 por página)
  - Salvamento de alterações com backup automático

### 🏷️ Sistema de Tags
- ✅ **Gerenciamento avançado de tags**
  - Contador de usos de cada tag (ex: "Bíblia (45)")
  - Seleção múltipla para deleção em massa
  - Botões "Selecionar todas" / "Desmarcar todas"
  - Função automática "Limpar tags < 10" para remover tags pouco usadas
  - Visual feedback para tags selecionadas

### 🗄️ Limpeza de Base de Dados
- ✅ **Otimização massiva da base de dados**
  - Removidas 3.531 tags com menos de 10 ocorrências
  - Mantidas apenas 30 tags relevantes (10+ usos)
  - 1.165 questões otimizadas
  - Script Python automatizado: `clean_tags_less_than_10.py`
  - Sistema de backup automático antes de alterações

### 🐛 Correções Críticas
- ✅ Corrigido carregamento do JSON (`perguntas_novo.json` → `perguntas.json`)
- ✅ Corrigido mapeamento de campos PT/EN no editor (pergunta/opcoes/resposta_correta)
- ✅ Implementado cache-busting para evitar versões antigas
- ✅ Service Worker atualizado (v1 → v2-cleaned)
- ✅ Headers `Cache-Control: no-cache` no fetch do JSON

### 🎨 Melhorias de Design
- ✅ Interface admin mais clean e profissional
- ✅ Cards de estatísticas compactos
- ✅ Tags com design neutro e bordas suaves
- ✅ Botões menores e texto sem emojis excessivos
- ✅ Sombras sutis e bordas discretas

### 🧹 Limpeza de Código
- ✅ Removidos arquivos duplicados e obsoletos:
  - `perguntas_cleaned.json`, `perguntas_novo.json` (backups)
  - `script.js.backup`
  - `check_both.py`, `debug_tags.py`, `verify_cleanup.py`
- ✅ Removidos arquivos de teste/desenvolvimento:
  - `test-debug.html`, `theme-test.html`, `clear-cache.html`
  - `debug-theme.js`, `fix-emergency.js`
  - `check_json.py`, `debug_json.py`
- ✅ Atualizado `.gitignore` para ignorar backups automáticos

### 📚 Documentação
- ✅ Criado `ADMIN_PANEL_README.md` com documentação completa
- ✅ Documentação de uso, funcionalidades e arquitetura
- ✅ Guia de troubleshooting

---

## [Não Lançado] - 2025-11-03

### 📦 Backup Criado
- **Data**: 03/11/2025 14:03
- **Local**: `quiz-biblico_backup_20251103_140316`
- **Motivo**: Backup de segurança antes de iniciar refatoração e melhorias

### 🎯 Próximas Melhorias Planejadas

#### Fase 1 - Limpeza e Otimização (Urgente)
- [x] Remover código de debug e logs desnecessários
  - ✅ Removidos debug.js e unregister-sw.js do HTML
  - ✅ Removidos 2092 caracteres de console.logs de debug
- [x] Consolidar arquivos CSS (remover duplicações)
  - ✅ Mesclado components-tags.css no style.css
  - ✅ Removido arquivo components-tags.css
- [x] Otimizar sistema de analytics
  - ✅ Implementada limpeza automática de dados > 30 dias
  - ✅ Compressão de dados (removidas redundâncias userAgent, screenSize, timezone)
  - ✅ Limite de 500 eventos por tipo/dia (antes: 2000)
  - ✅ Verificação de quota do localStorage (limite 2MB)
  - ✅ Fallback de limpeza agressiva em caso de quota excedida
- [x] Substituir alerts por sistema de notificações
  - ✅ Criado sistema Toast moderno (toast.js)
  - ✅ Estilos CSS com 4 tipos: success, error, warning, info
  - ✅ Fila de notificações com máximo de 3 visíveis
  - ✅ Animações suaves de entrada/saída
  - ✅ Acessibilidade com ARIA labels
  - ✅ Substituídos 11 alerts por Toast nas validações
  - ✅ Responsivo para mobile

#### Fase 2 - Organização (Importante)
- [ ] Modularizar JavaScript (dividir main.js)
- [ ] Implementar build process com Vite
- [ ] Adicionar testes unitários básicos
- [ ] Melhorar acessibilidade (ARIA, contraste)

#### Fase 3 - Qualidade (Desejável)
- [x] Melhorar acessibilidade
  - ✅ Adicionados ARIA labels em todos os botões (40+ labels)
  - ✅ Implementado role="radio" e aria-checked nos seletores
  - ✅ Estilos de foco melhorados (:focus-visible com outline 3px)
  - ✅ Skip link para navegação por teclado
  - ✅ Box-shadow em elementos focados para melhor visibilidade
  - ✅ Suporte completo para tema escuro nos indicadores de foco
- [ ] Refatorar estrutura de pastas
- [ ] Implementar gerenciamento de estado
- [ ] Melhorar SEO e meta tags
- [x] Documentação JSDoc nas funções principais
  - ✅ showView, updateThemeButton, populateFilters
  - ✅ generateUserId, generateSessionId, getDeviceType
  - ✅ Documentação com parâmetros e retornos tipados

### 📝 Notas
- Comentários serão mantidos para facilitar compreensão
- Foco em manter a funcionalidade atual enquanto melhora a qualidade do código
- Testes serão feitos em ambiente local antes de cada commit

---

## [1.3.0] - Outubro 2025

### Adicionado
- Jogo da Memória completo
- Tela de boas-vindas redesenhada
- Sistema de analytics avançado
- Modo estudo sem timer
- PWA funcional

### Melhorado
- UI/UX com gradientes e animações
- Responsividade mobile
- Sistema de pontuação

---

*Formato baseado em [Keep a Changelog](https://keepachangelog.com/)*
