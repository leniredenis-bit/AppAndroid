# 🍎 iOS – Build sem Mac (Codemagic) e App Store

> **Não existe "cópia" do projeto para iOS.** O mesmo código Flutter gera Android e iOS; a pasta `ios/` já está configurada.
> O que muda é *onde* compila: o iOS exige macOS + Xcode, então usamos o **Codemagic** (Mac na nuvem, plano gratuito com 500 min/mês).

## O que já está pronto no repositório
- Bundle ID `com.jwsplashgames.quiz` (igual ao Firebase)
- Nome exibido: **JW Splash Games**; idiomas PT-BR, EN, ES
- Somente iPhone (`TARGETED_DEVICE_FAMILY = 1`), sem exigir screenshots de iPad
- `GoogleService-Info.plist` incluído no target Runner
- `ios/Podfile` com iOS 13.0 mínimo (exigência do Firebase)
- Textos de permissão: galeria (quebra-cabeça), e câmera/microfone/salvar fotos (anexos do chat Crisp, exigidos pelo SDK)
- `ITSAppUsesNonExemptEncryption = false` (não pergunta sobre criptografia a cada envio)
- `codemagic.yaml` com o workflow **iOS → TestFlight**

---

## Passo a passo

### 1. Apple Developer Program
https://developer.apple.com/programs/enroll/ · US$ 99/ano
- Pessoa física: usa seu Apple ID com autenticação de dois fatores. O nome que aparece na loja é o seu nome.
- Pessoa jurídica: precisa de número D-U-N-S (gratuito, leva dias).

### 2. Criar o app no App Store Connect
https://appstoreconnect.apple.com → Apps → **+** → Novo app
- Plataforma iOS · Nome: **JW Splash Games** · Idioma principal: Português (Brasil)
- Bundle ID: `com.jwsplashgames.quiz` (se não aparecer na lista, registre antes em developer.apple.com → Identifiers)
- SKU: `jwsplashgames-quiz`
- Depois de criado, copie o **Apple ID** numérico (Informações do app) para `APP_STORE_APPLE_ID` no `codemagic.yaml`.

### 3. Chave da App Store Connect API
App Store Connect → Usuários e acesso → **Integrações** → App Store Connect API → Gerar chave
- Acesso: **App Manager**
- Baixe o `.p8` (só dá para baixar uma vez) e anote o **Issuer ID** e o **Key ID**.

### 4. Codemagic
1. https://codemagic.io → entrar com o GitHub → adicionar o repositório `leniredenis-bit/AppAndroid`.
2. Team settings → Integrations → **Developer Portal** → Connect → nome **`JW Splash Games ASC`** (o mesmo do `codemagic.yaml`) + Issuer ID, Key ID e `.p8`.
3. Code signing identities → iOS certificates → **Generate certificate** (tipo Apple Distribution). O Codemagic cria e guarda o certificado e o perfil de provisionamento.
4. O app detecta o `codemagic.yaml` automaticamente.

### 5. Gerar o build
```bash
git tag v1.0.0
git push origin v1.0.0
```
Ou, no painel do Codemagic: Start new build → workflow `ios-testflight`.
O build leva de 15 a 25 min e o IPA vai direto para o **TestFlight**. O número de build é calculado sozinho (último + 1).

### 6. TestFlight
App Store Connect → TestFlight → adicionar testadores internos (até 100, sem revisão) → instalar pelo app TestFlight no iPhone.
Testar principalmente: multiplayer (iPhone × Android), troca de idioma, quebra-cabeça com foto, chat de suporte.

### 7. Ficha e envio para revisão
- Textos, palavras-chave e categoria: [FICHA_DA_LOJA.md](../loja/FICHA_DA_LOJA.md)
- Screenshots obrigatórios: **iPhone 6,9"** (1320×2868). O 6,5" (1284×2778) é recomendado.
  Dá para gerar no simulador do Codemagic ou capturar no TestFlight.
- **Privacidade do app** (formulário "nutrition label"): respostas em [FICHA_DA_LOJA.md](../loja/FICHA_DA_LOJA.md#app-store--privacidade-do-app)
- Classificação etária: questionário → resultado esperado **4+**
- URL de suporte: pode ser a página de privacidade, ou uma página simples com o contato
- Selecionar o build do TestFlight → **Enviar para revisão**

### Dicas para passar na revisão
- Na "Nota para o revisor", explique: *"Multiplayer: crie uma sala em um aparelho e entre com o código de 6 dígitos em outro. Não exige login. App educativo independente, sem vínculo com organizações religiosas."*
- Diretriz 4.2 (funcionalidade mínima): o app tem quiz, 8 minigames e multiplayer, então está ok.
- Diretriz 5.2.1 (propriedade intelectual, nome "JW"): o app declara ser independente nos Termos. Se questionarem, responda pela Central de Resoluções citando o aviso.

---

## Rodando localmente (se um dia tiver Mac)
```bash
flutter pub get
cd ios && pod install && cd ..
open ios/Runner.xcworkspace   # Signing & Capabilities → selecionar seu Team
flutter build ipa --release
```

## Pendências futuras
- Upload de dSYM para o Crashlytics (deixa os relatórios de crash do iOS legíveis): adicionar a fase "Run Script" do Crashlytics no Xcode.
- Notificações push do Crisp (opcional; exige configurar APNs).
