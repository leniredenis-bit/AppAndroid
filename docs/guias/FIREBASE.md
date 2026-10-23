# 🔥 Firebase – Configuração e Operação

Projeto: **`jwsplashgames-fc4a1`** (produção) · Console: https://console.firebase.google.com

O app usa 4 serviços do Firebase:

| Serviço | Para quê | Código |
|---|---|---|
| Analytics | Estatísticas de uso anônimas | `lib/services/analytics_service.dart` |
| Crashlytics | Relatórios de falhas | `lib/services/crashlytics_service.dart` |
| Authentication (Anônimo) | Identidade do jogador no multiplayer | `lib/services/auth_service.dart` |
| Realtime Database | Salas do multiplayer | `lib/services/multiplayer/firebase_multiplayer_service.dart` |

Arquivos de configuração (já no repositório, são chaves públicas de cliente):
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist` (registrado no projeto Xcode)
- Web: sem Firebase. O multiplayer roda em modo simulado (`mock_multiplayer_service.dart`).

> O repositório é **público**, então qualquer pessoa vê essas chaves. Quem protege os dados são as **regras do banco**, por isso o passo 2 abaixo é obrigatório.

---

## ✅ Checklist do console (fazer uma vez)

### 1. Ativar login anônimo
Authentication → Sign-in method → **Anônimo** → Ativar → Salvar.
Sem isso o multiplayer mostra "Não foi possível conectar ao modo online".

### 2. Publicar as regras do Realtime Database
Opção A (console): Realtime Database → **Regras** → colar o conteúdo de [`database.rules.json`](../../database.rules.json) → Publicar.

Opção B (CLI):
```bash
npm install -g firebase-tools
firebase login
firebase deploy --only database --project jwsplashgames-fc4a1
```

O que as regras garantem:
- só usuários autenticados (login anônimo) leem e escrevem;
- só o **anfitrião** cria, controla (iniciar, próxima pergunta, reiniciar) e apaga a sala;
- cada jogador só altera os **próprios** dados (resposta e pontuação);
- qualquer jogador da sala pode marcar "fim da rodada" quando todos responderam;
- apelido com até 20 caracteres, código de sala com 6 dígitos.

> Se o banco foi criado em "modo de teste", as regras antigas **expiram em 30 dias** e deixam o banco aberto ou bloqueado. Publique as novas antes de testar.

### 3. Crashlytics
Crashlytics → Ativar. O primeiro relatório aparece depois que o app release roda e é reaberto.
Para testar: chame `FirebaseCrashlytics.instance.crash()` num build de teste (não comitar).

### 4. Analytics
Já vem ativo com o projeto. Eventos aparecem em ~24h (ou na hora em DebugView: `adb shell setprop debug.firebase.analytics.app com.jwsplashgames.quiz`).
O app **não coleta o ID de publicidade** (desativado no `AndroidManifest.xml`).

---

## 🗄️ Estrutura do banco

```
rooms/
  {codigo 6 dígitos}/
    id, hostId, status (waiting|starting|playing|roundEnd|finished|closed)
    currentQuestionIndex, totalQuestions, questionIds[], roundTimeLimit
    createdAt, lastActivity, roundStartTime, maxPlayers
    players/
      {uid}/ id, nickname, avatar, score, isHost, hasAnswered, lastAnswer, lastAnswerCorrect, joinedAt
```

Fluxo de status: `waiting` → (host inicia) `starting` → 3s → `playing` → (todos responderam, ou o tempo esgotou + 5s pelo host) `roundEnd` → (host: próxima) `playing` … → `finished` → (host: reiniciar) `waiting`.
Quando o anfitrião sai ou encerra, a sala vai para `closed` e é apagada 5s depois.

Detalhes técnicos: [docs/dev/MULTIPLAYER.md](../dev/MULTIPLAYER.md)

---

## 💬 Chat de suporte (Crisp)
Não é Firebase, mas faz parte da mesma infraestrutura:
- Conta criada; website ID configurado em `lib/services/chat_service.dart`.
- 👤 Pendente: Dashboard → Settings → Chatbox → idiomas PT, EN, ES.
- O botão "Ajuda e Suporte" fica nas Configurações do app e envia versão, aparelho, idioma e tela atual.

---

## 💰 Custos
Plano gratuito (Spark) cobre com folga: Realtime Database tem 1 GB armazenado e 10 GB/mês de download, com 100 conexões simultâneas. Uma sala ocupa poucos KB. Se passar de ~100 jogadores online ao mesmo tempo, migre para o plano Blaze (pago por uso).

## 🐛 Problemas comuns
| Sintoma | Causa provável |
|---|---|
| "Não foi possível conectar ao modo online" | Login anônimo desativado ou sem internet |
| `permission-denied` no log | Regras não publicadas, ou jogador tentando ação de anfitrião |
| "Sala não encontrada" | Código errado ou sala já encerrada |
| Firebase não inicia no iPhone | `GoogleService-Info.plist` fora do target Runner (já corrigido; confira se alguém recriou o projeto) |
