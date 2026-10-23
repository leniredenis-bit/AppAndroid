# 📊 Sistema de Feedback e Suporte Global

> **Objetivo:** Implementar Firebase Analytics, Crashlytics e Chat de Suporte in-app para fase de testes com usuários reais.

**Data de início:** 11/12/2025  
**Status:** ✅ Implementação Base Concluída - Aguardando ações do usuário

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### FASE 1: FIREBASE ANALYTICS & CRASHLYTICS

#### 1.1 - Firebase Core (Base)
- [x] Verificar estrutura existente (google-services.json, build.gradle)
- [x] Atualizar `firebase_core` no pubspec.yaml
- [x] Criar `FirebaseService` (singleton para inicialização)

#### 1.2 - Firebase Analytics
- [x] Adicionar `firebase_analytics` ao pubspec.yaml
- [x] Criar `AnalyticsService` (singleton com métodos de tracking)
- [x] Implementar `setUserId()` (usar UUID existente ou gerar novo)
- [x] Implementar eventos principais:
  - [x] `game_start` - Ao iniciar qualquer minigame/quiz
  - [x] `level_complete` - Com parâmetros (level, score, time)
  - [x] `game_over` - Com resultado (win/lose/score)
  - [x] `screen_view` - Para Home, Settings, Stats, etc.
- [ ] Integrar tracking nas telas existentes (opcional - fazer sob demanda)

#### 1.3 - Firebase Crashlytics
- [x] Adicionar `firebase_crashlytics` ao pubspec.yaml
- [ ] ⚠️ **[USUÁRIO]** Habilitar Crashlytics no Console Firebase
- [x] Criar `CrashlyticsService` (logs e chaves personalizadas)
- [x] Configurar captura global de erros no `main.dart`
- [x] Definir chaves personalizadas:
  - [x] `current_screen`
  - [x] `current_game`
  - [x] `user_language`
  - [x] `last_action`

---

### FASE 2: SISTEMA DE CHAT/FEEDBACK

#### 2.1 - Escolha da Plataforma

| Opção | Prós | Contras | Custo |
|-------|------|---------|-------|
| **Crisp** ✅ | SDK Flutter oficial, tradução automática, fácil setup | Limite 2 operadores no free | Grátis até 2 operadores |

**➡️ Decisão: Crisp** - SDK Flutter oficial (`crisp_chat`), tradução automática, grátis para começar.

#### 2.2 - Integração do Chat (Crisp)
- [ ] ⚠️ **[USUÁRIO]** Criar conta no Crisp (https://crisp.chat)
- [ ] ⚠️ **[USUÁRIO]** Obter Website ID
- [x] Adicionar `crisp_chat` ao pubspec.yaml (v2.4.1)
- [x] Criar `ChatService` (inicialização e métodos)
- [x] Adicionar `device_info_plus` ao pubspec.yaml
- [x] Adicionar `package_info_plus` ao pubspec.yaml

#### 2.3 - UI do Botão de Suporte
- [x] Adicionar botão "💬 Ajuda e Suporte" na tela de Configurações
- [x] Criar função `openSupportChat()`
- [x] Enviar metadados ao abrir:
  - [x] App Version
  - [x] Device Model + OS Version
  - [x] Current Screen
  - [x] User Language
  - [x] Firebase Enabled status
- [x] Adicionar traduções i18n (PT, EN, ES)

---

### FASE 3: TESTES E VALIDAÇÃO

- [ ] Testar inicialização do Firebase sem crash
- [ ] ⚠️ **[USUÁRIO]** Verificar eventos no Console do Firebase Analytics
- [ ] Simular crash e verificar no Crashlytics
- [ ] ⚠️ **[USUÁRIO]** Testar chat em 3 idiomas (PT, EN, ES)
- [ ] ⚠️ **[USUÁRIO]** Verificar se metadados aparecem no painel Crisp

---

## 🔴 AÇÕES DO USUÁRIO (Lenire)

### 1. Firebase Console
- [ ] Acessar https://console.firebase.google.com
- [ ] Projeto: `jwsplashgames-fc4a1`
- [ ] Ir em **Crashlytics** > **Ativar Crashlytics**
- [ ] Verificar se **Analytics** está ativo

### 2. Criar conta Crisp
- [x] Acessar https://crisp.chat
- [x] Criar conta gratuita
- [x] Criar um "Website" para o app
- [x] Copiar o **Website ID**: `b4dfbc25-cbae-48cc-a9fb-67047334ae2e`
- [x] **CONFIGURADO:** `lib/services/chat_service.dart` atualizado com o Website ID

### 3. Configurar tradução no Crisp
- [ ] Dashboard > Settings > Chatbox > Locale
- [ ] Adicionar: PT, EN, ES

---

## 📁 ARQUIVOS CRIADOS/MODIFICADOS

### Novos Arquivos:
| Arquivo | Descrição | Status |
|---------|-----------|--------|
| `lib/services/firebase_service.dart` | Inicialização do Firebase | ✅ Criado |
| `lib/services/analytics_service.dart` | Eventos de tracking | ✅ Criado |
| `lib/services/crashlytics_service.dart` | Logs e chaves | ✅ Criado |
| `lib/services/chat_service.dart` | Integração Crisp | ✅ Criado |

### Arquivos Modificados:
| Arquivo | Modificação | Status |
|---------|-------------|--------|
| `pubspec.yaml` | Novas dependências Firebase + Crisp | ✅ Atualizado |
| `lib/main.dart` | Inicialização Firebase + captura erros | ✅ Atualizado |
| `lib/widgets/settings_dialog.dart` | Botão de suporte "💬 Ajuda e Suporte" | ✅ Atualizado |
| `lib/l10n/app_pt.arb` | Traduções suporte (PT) | ✅ Atualizado |
| `lib/l10n/app_en.arb` | Traduções suporte (EN) | ✅ Atualizado |
| `lib/l10n/app_es.arb` | Traduções suporte (ES) | ✅ Atualizado |

---

## 📦 DEPENDÊNCIAS ADICIONADAS

```yaml
# Firebase (já instalado)
firebase_core: ^3.15.2
firebase_analytics: ^11.6.0
firebase_crashlytics: ^4.3.10

# Chat Support
crisp_chat: ^2.4.1

# Device Info
device_info_plus: ^11.5.0
package_info_plus: ^8.3.1
```

---

## 📝 NOTAS E OBSERVAÇÕES

- O projeto já tinha `google-services.json` configurado
- O plugin Google Services já estava no `build.gradle.kts`
- Usamos `crisp_chat` (pacote mais popular com 4250 downloads) em vez de `crisp_sdk`
- O botão de suporte aparece na tela de Configurações abaixo do botão "Sobre"
- O chat envia automaticamente: versão do app, modelo do dispositivo, idioma, tela atual

---

## 🔄 LOG DE PROGRESSO

| Data | Ação | Responsável |
|------|------|-------------|
| 11/12/2025 | Criação do plano de implementação | Claude |
| 11/12/2025 | Análise da estrutura existente | Claude |
| 11/12/2025 | Criação do FirebaseService, AnalyticsService, CrashlyticsService | Claude |
| 11/12/2025 | Atualização do main.dart com captura de erros | Claude |
| 11/12/2025 | Criação do ChatService com Crisp SDK | Claude |
| 11/12/2025 | Adição do botão de suporte em Settings | Claude |
| 11/12/2025 | Adição de traduções i18n (PT, EN, ES) | Claude |
| 11/12/2025 | ✅ **Implementação base concluída** | Claude |

