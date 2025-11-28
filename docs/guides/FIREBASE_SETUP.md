# Firebase Multiplayer - Guia de Configuração

## ✅ Status Atual

Firebase está configurado e pronto para uso!

### O que foi implementado:

1. **Firebase Core** ✅
   - Inicializado em `lib/main.dart`
   - `google-services.json` configurado

2. **AuthService** ✅
   - Autenticação anônima automática
   - Gerencia IDs únicos dos jogadores
   - Localização: `lib/services/auth_service.dart`

3. **FirebaseMultiplayerService** ✅
   - Interface compatível com MockMultiplayerService
   - Realtime Database para sincronização
   - Localização: `lib/services/multiplayer/firebase_multiplayer_service.dart`

---

## 🔀 Como Alternar entre Mock e Firebase

### Opção 1: Usar Mock (simulação local - padrão atual)
Ideal para testes sem internet ou desenvolvimento local.

Nenhuma alteração necessária - o app já usa Mock por padrão.

### Opção 2: Usar Firebase (multiplayer real)
Para testar com dispositivos reais conectados:

#### Passo 1: Trocar o serviço nas telas multiplayer

Encontre e substitua nas seguintes telas:
- `lib/screens/multiplayer/create_room_screen.dart`
- `lib/screens/multiplayer/join_room_screen.dart`
- `lib/screens/multiplayer/lobby_screen.dart`
- `lib/screens/multiplayer/multiplayer_quiz_screen.dart`
- `lib/screens/multiplayer/round_result_screen.dart`
- `lib/screens/multiplayer/final_result_screen.dart`

**De:**
```dart
import '../../services/multiplayer/mock_multiplayer_service.dart';
```

**Para:**
```dart
import '../../services/multiplayer/firebase_multiplayer_service.dart';
```

**E substitua todas as chamadas:**
```dart
MockMultiplayerService.createRoom(...)
```

**Por:**
```dart
FirebaseMultiplayerService().createRoom(...)
```

> **NOTA:** FirebaseMultiplayerService usa instância singleton com `()`, enquanto Mock usa métodos estáticos.

---

## 🎮 Como Testar Multiplayer Real

### 1. Pré-requisitos
- ✅ Firebase Console com Realtime Database habilitado
- ✅ Regras de segurança configuradas (leitura/escrita abertas para teste)
- ✅ google-services.json no local correto
- ✅ 2+ dispositivos ou emuladores

### 2. Regras de Segurança (Firebase Console)
No Firebase Console → Realtime Database → Regras, use:

```json
{
  "rules": {
    "rooms": {
      ".read": true,
      ".write": true,
      "$roomId": {
        ".indexOn": ["hostId", "status"]
      }
    }
  }
}
```

⚠️ **IMPORTANTE:** Essas regras são para TESTES. Em produção, adicione validação de autenticação!

### 3. Testar no Android

```powershell
flutter run
```

### 4. Fluxo de Teste

**Dispositivo 1 (Host):**
1. Abrir app → Multiplayer → Criar Sala
2. Escolher configurações (10 perguntas, 15s por rodada)
3. Anotar código da sala (ex: ABC123)
4. Aguardar jogadores

**Dispositivo 2+ (Convidados):**
1. Abrir app → Multiplayer → Entrar em Sala
2. Digitar código: ABC123
3. Entrar na sala

**Iniciar Jogo:**
1. Host clica em "Iniciar Jogo"
2. Todos veem contagem regressiva
3. Perguntas sincronizadas em tempo real
4. Placar atualizado ao vivo

---

## 🐛 Solução de Problemas

### Erro: "Sala não encontrada"
- Verifique se Firebase Realtime Database está ativado
- Confirme que as regras de segurança estão configuradas
- Teste a conexão com internet

### Erro: "Usuário não autenticado"
- Verifique se Firebase Authentication está habilitado
- Confirme que "Método de login anônimo" está ativado

### Perguntas não aparecem
- Verifique o arquivo `assets/data/perguntas_atualizado.json`
- Confirme que `assets/` está listado em `pubspec.yaml`

### Sincronização lenta
- Normal em primeira execução (carrega perguntas)
- Verifique velocidade da internet
- Firebase Realtime Database tem latência ~100-500ms

---

## 📊 Monitoramento no Firebase Console

1. Acesse: https://console.firebase.google.com
2. Selecione seu projeto
3. Vá em **Realtime Database**
4. Veja dados em tempo real:
   ```
   /rooms
     /ABC123
       /id: "ABC123"
       /hostId: "xyz..."
       /players
         /xyz...
           /nickname: "Jogador1"
           /score: 5
       /status: "playing"
       /currentQuestionIndex: 3
   ```

---

## 🚀 Próximos Passos (Opcionais)

### Melhorias de Segurança
- [ ] Adicionar regras de validação no Firebase
- [ ] Limitar criação de salas por usuário
- [ ] Implementar sistema de denúncias

### Funcionalidades Extras
- [ ] Chat em tempo real na sala
- [ ] Sistema de rankings global
- [ ] Replay de partidas
- [ ] Conquistas multiplayer

### Performance
- [ ] Cache local de perguntas
- [ ] Pré-carregamento de dados
- [ ] Compressão de dados transmitidos

---

## 📝 Estrutura do Banco (Firebase Realtime Database)

```
/rooms
  /{roomCode}
    /id: string
    /hostId: string
    /status: "waiting" | "starting" | "playing" | "finished"
    /totalQuestions: number
    /questionIds: string[]
    /currentQuestionIndex: number
    /roundTimeLimit: number
    /maxPlayers: number
    /createdAt: ISO8601
    /lastActivity: ISO8601
    /players
      /{playerId}
        /id: string
        /nickname: string
        /avatar: emoji
        /score: number
        /isHost: boolean
        /hasAnswered: boolean
        /lastAnswer: number?
        /lastAnswerCorrect: boolean
```

---

## ℹ️ Informações Técnicas

- **Firebase Core:** v2.32.0
- **Firebase Database:** v10.5.7  
- **Firebase Auth:** v4.16.0
- **Flutter:** ^3.5.0
- **Dart:** ^3.5.0

**Criado em:** 2025-01-20  
**Desenvolvido para:** JW Quiz Flutter  
**Documentação Firebase:** https://firebase.google.com/docs/flutter/setup
