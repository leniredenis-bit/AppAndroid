# 👥 Multiplayer – Arquitetura

Quiz ao vivo: o anfitrião cria uma sala, os outros entram com o código de 6 dígitos e todos respondem às mesmas perguntas, com placar a cada rodada.

## Arquivos

| Arquivo | Papel |
|---|---|
| `lib/services/multiplayer/firebase_multiplayer_service.dart` | API única usada pelas telas. Usa o Firebase Realtime Database; sem Firebase (web), delega ao mock |
| `lib/services/multiplayer/mock_multiplayer_service.dart` | Simulação em memória (um aparelho só), usada na web e em testes |
| `lib/services/auth_service.dart` | `ensureSignedIn()`: login anônimo do Firebase (UID = playerId) ou ID local no mock |
| `lib/services/multiplayer/profanity_filter.dart` | Validação de apelidos |
| `lib/models/multiplayer/room.dart`, `player.dart` | Modelos + `toMap`/`fromMap` |
| `lib/screens/multiplayer/*` | Menu → Criar/Entrar → Lobby → Quiz → Resultado da rodada → Resultado final |
| `database.rules.json` | Regras de segurança (ver [guia Firebase](../guias/FIREBASE.md)) |

## Fluxo

```
Criar sala (host)            Entrar (jogador)
   │ status: waiting             │ players/{uid} = Player
   ▼                              ▼
Lobby ── host: Iniciar ──► starting ──3s──► playing (pergunta 0)
                                              │ cada um: submitAnswer → players/{uid}.hasAnswered
                                              │ último a responder → roundEnd
                                              │ (ou host, 5s após o tempo acabar → roundEnd)
                                              ▼
                                         Resultado da rodada ── host: Próxima ──► playing (i+1)
                                              │ última pergunta
                                              ▼
                                          finished → Resultado final ── host: Reiniciar ──► waiting (Lobby)
Host sai/encerra a qualquer momento → closed (todos veem aviso) → sala apagada após 5s
```

Cada tela escuta `roomStream(code)` e navega quando o `status` muda. A flag `_leaving` evita navegações ou diálogos repetidos, porque o stream emite a cada alteração de qualquer jogador.

## Decisões
- **Identidade**: login anônimo do Firebase. Sem cadastro, e as regras conseguem validar quem escreve (`auth.uid`).
- **Perguntas**: o host sorteia os IDs ao criar (ou reiniciar) a sala; cada aparelho carrega o JSON local no idioma do jogador e busca pelo ID. Os IDs são os mesmos nos 3 idiomas, então jogadores com idiomas diferentes jogam juntos.
- **Pontuação**: calculada no aparelho do jogador (base pela dificuldade + bônus de tempo). Dá para trapacear editando o app, mas o risco é aceitável para um jogo casual.
- **Saída do host**: encerra a sala (não transfere o papel de anfitrião), o que mantém as regras simples.
- **Web**: sem Firebase. O multiplayer funciona só no modo simulado.

## Limitações conhecidas / próximos passos
- Salas abandonadas (app fechado à força) ficam no banco. Fazer uma limpeza periódica por `lastActivity` (Cloud Function agendada).
- Alguns textos das telas multiplayer ainda estão fixos em português (diálogos de sair, remover e erros).
- Quando um jogador sai no meio da partida, a rodada só fecha pelo timeout do host.

## Testar
Dois aparelhos com o app release ou debug (Android + Android, ou Android + iPhone pelo TestFlight). O roteiro está em [COMO_TESTAR.md](../guias/COMO_TESTAR.md#5-modo-multiplayer-).
