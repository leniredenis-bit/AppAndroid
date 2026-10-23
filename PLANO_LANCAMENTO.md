# 🚀 Plano de Lançamento – JW Splash Games

> **Documento central do projeto.** Substitui `NEXT_STEPS`, `PROJECT_STATUS`, `PUBLICATION_CHECKLIST`,
> `EXECUTIVE_SUMMARY`, `PENDENCIAS`, `MELHORIAS_EM_ANDAMENTO` e `ajustesapp` (arquivados em `docs/archive/`).
>
> Atualizado em **21/10/2026** · Versão do app: **1.0.0+2**
> Legenda: 👤 = ação sua (contas, consoles, arte, testes) · 🤖 = posso fazer no código

---

## 📍 Onde estamos

| Área | Status |
|---|---|
| Código Flutter | ✅ `flutter analyze` sem problemas; 8 minigames, quiz, conquistas, 3 idiomas |
| Android | ✅ ID `com.jwsplashgames.quiz`, assinatura de release configurada (falta criar a chave), permissões enxutas |
| iOS | ✅ Bundle ID corrigido, Firebase registrado no Xcode, Podfile, Codemagic configurado (falta conta Apple) |
| Multiplayer online | ✅ Firebase real restaurado (estava em modo simulado). Falta ativar login anônimo + publicar regras |
| Privacidade | ✅ Política pública em `web/privacidade.html` e texto do app corrigido (antes dizia que nada saía do aparelho) |
| Minigames | ✅ Revisão completa + novo jogo **Colorir** ([detalhes](docs/dev/REVISAO_MINIGAMES.md)) |
| Ícone / splash | ⏳ Configurados; **falta a arte** (ainda é o ícone padrão do Flutter) |
| Lojas | ⏳ Contas, fichas, screenshots |

### Feito em 21/10/2026
- **Multiplayer**: o "online" era um *mock* local (só funcionava num aparelho). Restaurado o serviço Firebase com login anônimo, código de sala aleatório de 6 dígitos, fim de rodada automático (antes o jogo travava após todos responderem), fallback do anfitrião quando alguém desconecta e proteção contra navegação duplicada. Web continua em modo simulado.
- **Regras de segurança** do Realtime Database: `database.rules.json` (só membros da sala alteram dados; só o anfitrião controla a partida).
- **Android**: assinatura de release via `android/key.properties` + script `scripts/criar_keystore.ps1`; `build_apk.ps1 aab` gera o pacote da Play Store; removidas permissões de câmera/galeria (o seletor de fotos do sistema dispensa) e o ID de publicidade.
- **iOS**: bundle `com.jwsplashgames.quiz` (antes `com.example...`, incompatível com o Firebase); `GoogleService-Info.plist` adicionado ao projeto Xcode (não estava, o Firebase não iniciaria no iPhone); nome "JW Splash Games"; só iPhone; idiomas PT/EN/ES; textos de permissão exigidos pelo chat Crisp; isenção de criptografia; `Podfile` (iOS 13+); `codemagic.yaml` para compilar sem Mac.
- **Conformidade**: política de privacidade real (Firebase, Crashlytics, Crisp, LGPD) no app e na web; aviso de app independente sem vínculo com jw.org; créditos obrigatórios das músicas (Kevin MacLeod, CC BY 4.0); removidos da tela "Sobre" o aviso "será atualizada em breve" e o botão do GitHub que não fazia nada (motivos comuns de rejeição na Apple).
- **Correções**: 5 minigames estavam sem música de fundo (chave errada); removida dependência não usada (`permission_handler`) e arquivos vazios/obsoletos.
- **Docs** reorganizadas (ver [docs/README.md](docs/README.md)). Backup completo da pasta em `../AppAndroid_backup_2026-10-21`.

---

## ⚠️ Pontos de atenção

1. **Nome "JW"**: decisão tomada de manter. Para reduzir risco na revisão: o app e a ficha da loja declaram ser independentes e sem vínculo com jw.org. Se a Apple ou o Google questionarem (diretriz 5.2.1 / política de falsificação de identidade), responda pelo canal da revisão citando o aviso. Ter um nome alternativo de reserva evita ficar parado.
2. **Texto sobre a Tradução do Novo Mundo**: os Termos dizem que a TNM é "usada com permissão para fins educacionais". **Só mantenha isso se houver permissão de fato.** Caso contrário, troque por algo como "referências bíblicas com links para consulta no site público jw.org" (chave `copyrightBibleDesc` nos arquivos `lib/l10n/app_*.arb`). Vale também conferir se as perguntas copiam trechos longos de publicações.
3. **Público-alvo**: declarar **"Todos / 4+" sem marcar "feito para crianças"**. Entrar no programa Families (Google) ou na categoria Kids (Apple) traz restrições ao Analytics e ao chat Crisp.

---

## 🗺️ Fases

### Fase 0 – Contas e decisões (esta semana)
- [ ] 👤 Criar conta **Google Play Console** (US$ 25, única vez). Conta pessoal nova exige verificação de identidade.
- [ ] 👤 Criar conta **Apple Developer** (US$ 99/ano). Pessoa física: aprovação leva de 1 a 3 dias.
- [ ] 👤 Criar conta no **Codemagic** (gratuita) e conectar o repositório.
- [ ] 👤 Decidir o texto sobre a TNM (item 2 acima).
- [ ] 👤 Definir um **e-mail de contato** público para as lojas (obrigatório nas duas fichas).
- [ ] 👤 Aposentar o repositório duplicado **JWQuizFlutter** (arquivar no GitHub).

### Fase 1 – Acabamento do app (1 semana)
- [ ] 👤 **Arte do ícone e splash** → `assets/icon/` (especificações em [assets/icon/LEIA-ME.md](assets/icon/LEIA-ME.md)), depois:
      `dart run flutter_launcher_icons` e `dart run flutter_native_splash:create`
- [ ] 👤 **Firebase Console** ([guia](docs/guias/FIREBASE.md)):
  - [x] Authentication → ativar provedor **Anônimo** (já estava ativo, conferido em 21/10/2026)
  - [ ] Realtime Database → publicar `database.rules.json`
  - [ ] Crashlytics → ativar
- [ ] 👤 **Testar no aparelho** ([roteiro](docs/guias/COMO_TESTAR.md)), principalmente:
  - [ ] Multiplayer em **2 celulares** (criar sala, entrar, jogar até o fim, reiniciar, sair)
  - [ ] Minigames reescritos: Quebra-Cabeça, Labirinto, Sequência Cristal, Forca, Caça-Palavras, Memória, Velha
  - [ ] Novo jogo Colorir (inclui "virar quebra-cabeça")
  - [ ] Volume e sensação dos novos efeitos sonoros
  - [ ] Troca de idioma PT/EN/ES em todas as telas
- [ ] 🤖 Corrigir o que aparecer nos testes
- [ ] 🤖 Traduzir textos ainda fixos em português nas telas do multiplayer (diálogos de sair/remover/erros)

### Fase 2 – Google Play (2 a 3 semanas, a maior parte em espera)
- [ ] 👤 Gerar a chave: `powershell -ExecutionPolicy Bypass -File scripts\criar_keystore.ps1` → **backup da .jks + senha**
- [ ] 👤 Gerar o pacote: `.\build_apk.ps1 aab` → `build\app\outputs\bundle\release\app-release.aab`
- [ ] 👤 Criar o app na Play Console e ativar **Play App Signing**
- [ ] 👤 Preencher a ficha com os textos de [docs/loja/FICHA_DA_LOJA.md](docs/loja/FICHA_DA_LOJA.md)
- [ ] 👤 Screenshots (mín. 2, recomendado 4–8, celular) + Feature Graphic 1024×500
- [ ] 👤 Formulários: Segurança dos dados, Classificação de conteúdo, Público-alvo, Anúncios (= não), Política de privacidade (URL)
- [ ] 👤 **Teste fechado: 12 testadores por 14 dias seguidos** (obrigatório para contas pessoais novas antes da produção). Comece o quanto antes; convide pelo e-mail Google de cada um.
- [ ] 👤 Solicitar acesso à produção → lançamento escalonado (20% → 50% → 100%)

### Fase 3 – App Store (em paralelo com a Fase 2, ~2 semanas)
Guia completo: [docs/guias/BUILD_IOS.md](docs/guias/BUILD_IOS.md)
- [ ] 👤 App Store Connect → criar app com bundle `com.jwsplashgames.quiz`
- [ ] 👤 Criar chave da **App Store Connect API** e cadastrar no Codemagic
- [ ] 👤 Preencher `APP_STORE_APPLE_ID` em `codemagic.yaml`
- [ ] 👤 Disparar o build: `git tag v1.0.0 && git push origin v1.0.0` → chega no TestFlight
- [ ] 👤 Testar pelo TestFlight num iPhone (multiplayer iPhone × Android também)
- [ ] 👤 Ficha: textos, screenshots iPhone 6,9" (1320×2868) e 6,5" (1284×2778), **Privacidade do app** (respostas na ficha), classificação etária
- [ ] 👤 Enviar para revisão (geralmente 24–48h)

### Fase 4 – Lançamento e pós-lançamento
- [ ] 👤 Acompanhar Crashlytics e avaliações na primeira semana
- [ ] 🤖 Versão 1.0.1 com correções
- [ ] Divulgação

---

## 📦 Backlog (depois do lançamento)
- Sons específicos no Labirinto (passo, colisão, vitória) e revisão de volumes
- Upload de dSYM do Crashlytics no iOS (relatórios de crash legíveis)
- Mais idiomas (FR, DE, IT)
- Avatar personalizável
- Limpeza automática de salas antigas no Firebase (Cloud Function ou rotina)
- Ideias completas: [docs/dev/IDEIAS_FUTURAS.md](docs/dev/IDEIAS_FUTURAS.md)

---

## 🔑 Informações de referência

| Item | Valor |
|---|---|
| Android applicationId / iOS bundle | `com.jwsplashgames.quiz` |
| Firebase | projeto `jwsplashgames-fc4a1` (produção) |
| Realtime Database | `https://jwsplashgames-fc4a1-default-rtdb.firebaseio.com` |
| Crisp (chat) | website ID em `lib/services/chat_service.dart` |
| Política de privacidade | `https://leniredenis-bit.github.io/AppAndroid/privacidade.html` (publicada pelo GitHub Pages a cada push na `main`) |
| Keystore | `%USERPROFILE%\keystores\jwsplashgames-upload.jks` (fora do git) |
| Backup pré-reorganização | `../AppAndroid_backup_2026-10-21` |
