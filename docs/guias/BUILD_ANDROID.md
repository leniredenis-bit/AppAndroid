# 🤖 Android – Build, Assinatura e Google Play

## Ambiente (Windows)
- Flutter 3.41.2 (`flutter doctor` deve mostrar Android toolchain ✅)
- Android SDK + JDK 17/21 (`JAVA_HOME` configurado)
- Primeira vez: `flutter doctor --android-licenses` e aceitar tudo

## Builds do dia a dia
Use o script da raiz (ou `BUILD_APK.bat` com duplo clique):

| Comando | Resultado | Uso |
|---|---|---|
| `.\build_apk.ps1 quick` | APK debug, sem limpar | Teste rápido no celular |
| `.\build_apk.ps1` | APK release | Teste da versão final / enviar para amigos |
| `.\build_apk.ps1 aab` | **App Bundle** release | **Upload na Play Console** |
| `.\build_apk.ps1 clean` | `flutter clean` | Quando o build fica estranho |

Saídas:
- APK: `build\app\outputs\flutter-apk\app-release.apk`
- AAB: `build\app\outputs\bundle\release\app-release.aab`

Instalar APK no celular: cabo USB + `flutter install`, ou mandar o arquivo (Drive/WhatsApp) e permitir "fontes desconhecidas".

## 📦 O que é o AAB e onde encontrá-lo

`.aab` significa **Android App Bundle**: é o pacote de publicação que se envia
à Play Console. Não é o projeto nem um instalador para o celular (para instalar
manualmente, use um APK).

Antes do primeiro build nesta máquina, aceite as licenças do Android SDK:

```powershell
flutter doctor --android-licenses
```

Confirme as solicitações e, na raiz do projeto, gere o bundle:

```powershell
flutter build appbundle --release
```

O arquivo será criado em:

```text
build\app\outputs\bundle\release\app-release.aab
```

Para anexá-lo nesta conversa, abra essa pasta no Explorador de Arquivos e
arraste `app-release.aab` para o chat (ou use o botão de anexar). Para publicar,
envie o mesmo arquivo na faixa de teste da Play Console.

**Importante:** o AAB só pode ser enviado à Play Console se estiver assinado com
a chave de upload válida deste app. Sem `android\key.properties`, o projeto usa
a assinatura debug, que serve apenas para validar o build e será recusada pela
Play Store. Configure a chave de upload antes de enviar o bundle.

## 🔐 Assinatura de release (uma vez só)

```powershell
powershell -ExecutionPolicy Bypass -File scripts\criar_keystore.ps1
```

O script:
1. cria `%USERPROFILE%\keystores\jwsplashgames-upload.jks` (fora do repositório);
2. cria `android\key.properties` (ignorado pelo git);
3. o `android/app/build.gradle.kts` passa a assinar o release com essa chave.

Sem `key.properties`, o release é assinado com a chave debug: funciona para testar, mas **a Play Store recusa**. O script de build avisa quando isso acontece.

> ⚠️ **Faça backup da `.jks` e da senha** (gerenciador de senhas + nuvem privada). Com o Play App Signing, a chave que assina para os usuários fica com o Google; esta é só a chave de *upload*. Se você perdê-la, dá para pedir uma nova ao suporte, mas isso leva dias.

## 🔢 Versão
`pubspec.yaml` → `version: 1.0.0+2`
- `1.0.0` = versão exibida (versionName / CFBundleShortVersionString)
- `+2` = número do build (versionCode). **Precisa aumentar a cada upload** na Play Console.

## 🏪 Google Play Console – passo a passo
1. Criar conta: https://play.google.com/console (US$ 25, verificação de identidade).
2. **Criar app**: nome "JW Splash Games", idioma padrão Português (Brasil), Jogo, Gratuito.
3. **Configurar o app** (painel "Configure seu app"):
   - Política de privacidade: `https://leniredenis-bit.github.io/AppAndroid/privacidade.html`
   - Acesso ao app: todas as funções disponíveis sem login
   - Anúncios: **Não**
   - Classificação de conteúdo: questionário IARC (respostas em [FICHA_DA_LOJA.md](../loja/FICHA_DA_LOJA.md#classificação-de-conteúdo))
   - Público-alvo: **13+** (não marque faixas infantis, para não entrar no programa Families)
   - Segurança dos dados: respostas em [FICHA_DA_LOJA.md](../loja/FICHA_DA_LOJA.md#google-play--segurança-dos-dados)
   - Categoria: Jogos → Educativo (ou Curiosidades/Trivia)
4. **Ficha da loja**: textos e imagens da [FICHA_DA_LOJA.md](../loja/FICHA_DA_LOJA.md).
5. **Teste fechado** (obrigatório para contas pessoais criadas após nov/2023):
   - Testes → Teste fechado → criar faixa → enviar o `.aab`
   - Adicionar **pelo menos 12 testadores** (lista de e-mails Google)
   - Eles precisam **aceitar o convite e manter o app instalado por 14 dias seguidos**
   - Depois: Painel → "Solicitar acesso à produção" (responder perguntas sobre o teste)
6. **Produção**: enviar o `.aab` (versionCode maior), lançamento escalonado 20% → 50% → 100%.

## 📋 Requisitos técnicos atendidos
- [x] applicationId próprio: `com.jwsplashgames.quiz`
- [x] targetSdk = padrão do Flutter 3.41 (atende à exigência anual do Google)
- [x] Sem `READ_MEDIA_IMAGES`/`CAMERA` (o seletor de fotos do sistema não exige permissão; o Google Play restringe READ_MEDIA_IMAGES)
- [x] `AD_ID` removido (app sem anúncios)
- [x] App Bundle (.aab)
- [x] Ícone próprio e splash (arte e recursos nativos gerados: `assets/icon/`)

## 🐛 Problemas comuns
| Erro | Solução |
|---|---|
| `No devices found` | `adb kill-server; adb start-server`; ativar Depuração USB |
| `Gradle build failed` | `.\build_apk.ps1 clean` e tentar de novo |
| `SDK licenses not accepted` | `flutter doctor --android-licenses` |
| "Version code já usado" na Play Console | Aumentar o `+N` no `pubspec.yaml` |
| "App assinado no modo de depuração" | Falta `android\key.properties` (rodar `criar_keystore.ps1`) |
