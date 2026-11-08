# Publicar o JW Splash Games na Google Play — passo a passo

Este guia parte do zero no computador, mas **o aplicativo já está montado**: o
projeto Flutter e os arquivos do app estão nesta pasta:

```text
C:\Users\Denis\Documents\GitHub\AppAndroid
```

Você não precisa criar outro projeto nem copiar o código para uma pasta do
Android Studio. O que falta é preparar o ambiente Android, configurar a chave
de upload, gerar o pacote `.aab` e preencher/revisar a Play Console.

> **Atenção ao estado atual:** há várias alterações locais no projeto que ainda
> não foram revisadas ou enviadas ao Git. O AAB incluirá o conteúdo que estiver
> salvo na pasta quando o build for feito. Revise e teste essas alterações antes
> de publicar.

## 1. Entenda as pastas e o que vai em cada lugar

Abra o **Explorador de Arquivos** e navegue até
`C:\Users\Denis\Documents\GitHub\AppAndroid`. Essa é a raiz do projeto. Ela deve
conter, entre outros:

| Pasta/arquivo | Para que serve | Você precisa colocar algo? |
|---|---|---|
| `lib\` | Código Dart das telas, regras e serviços do app | Não; o app já está implementado |
| `assets\data\` | Perguntas e dados usados pelo app | Não; os dados atuais já estão no projeto |
| `assets\audio\` e `assets\images\` | Sons e imagens do app | Não para gerar o pacote atual |
| `assets\icon\` | Arte-fonte do ícone e da tela de abertura | Já contém `app_icon.png`, `app_icon_foreground.png` e `splash_logo.png`, sem cruz |
| `android\` | Configuração nativa Android, Gradle e Firebase | Não copie o projeto para cá |
| `android\app\google-services.json` | Configuração Firebase do Android | Já está no projeto; não substitua por arquivo de outro app |
| `android\key.properties` | Caminhos e senhas da chave de upload | Será criado pelo script; não compartilhe nem envie |
| `%USERPROFILE%\keystores\` | Local seguro fora do projeto para a chave `.jks` | O script cria a chave aqui |
| `build\app\outputs\bundle\release\` | Pacote AAB produzido pelo Flutter | O `.aab` aparecerá aqui após o build |

**Não coloque o `.aab`, a keystore ou senhas dentro de `lib\`, `assets\` ou
`android\app\src\main\res\`.** Os arquivos de arte já foram transformados nos
recursos nativos para Android, iOS e web.

## 2. Abra o projeto no Android Studio

1. Inicie o Android Studio.
2. Na tela inicial, escolha **Open**.
3. Selecione a pasta inteira:
   `C:\Users\Denis\Documents\GitHub\AppAndroid`
   (não selecione apenas a pasta `android`).
4. Se o Android Studio solicitar confiança no projeto, confirme somente se
   reconhece a origem dos arquivos.
5. Se o Flutter não estiver configurado, instale o plugin **Flutter** em
   **File → Settings → Plugins**. Ele também instalará ou solicitará o plugin
   Dart. Configure o caminho do Flutter SDK quando solicitado.
6. Aguarde o carregamento do projeto. Não use **New Project** e não crie outro
   aplicativo.

Os comandos abaixo podem ser executados na aba **Terminal** do Android Studio.
Confira que o terminal está na raiz e que o caminho termina em `AppAndroid`.
Se não estiver, execute:

```powershell
cd C:\Users\Denis\Documents\GitHub\AppAndroid
```

## 3. Prepare o Android SDK e aceite as licenças

O erro que apareceu no seu build informa que a licença do NDK
`28.2.13676358` não foi aceita. Faça esta etapa antes de tentar gerar o AAB:

1. No Android Studio, abra **Tools → SDK Manager**.
2. Em **Android SDK Location**, confirme o caminho indicado no erro:
   `C:\Program Files (x86)\Android\android-sdk`
3. Abra a aba **SDK Tools**.
4. Marque **Show Package Details**.
5. Expanda **NDK (Side by side)** e localize a versão exata
   `28.2.13676358`.
6. Se ela não estiver instalada, marque-a para instalação. Clique em **Apply**
   e confirme os termos/licenças apresentados.
7. Volte ao terminal do Android Studio, na raiz do projeto, e execute:

   ```powershell
   flutter doctor --android-licenses
   ```

8. Leia e aceite as licenças apresentadas. No fim, execute:

   ```powershell
   flutter doctor
   ```

   Confira que a seção **Android toolchain** não mostra erro de licença.

Se `flutter doctor --android-licenses` não abrir ou disser que não encontra o
SDK Manager, não tente instalar uma versão diferente do NDK às cegas. Confira
se o Android Studio e o Flutter estão usando o mesmo caminho de SDK e resolva
primeiro qualquer erro indicado pelo `flutter doctor`.

## 4. Revise e teste o app antes da publicação

Na raiz do projeto, execute:

```powershell
flutter pub get
flutter analyze
flutter test
```

Corrija qualquer falha antes de publicar. Depois teste o app em um celular
Android real, incluindo inicialização, quiz, minigames, áudio, troca de idioma,
seleção de imagem e multiplayer. O roteiro está em
[COMO_TESTAR.md](COMO_TESTAR.md).

Confira também antes de seguir:

- A arte do ícone e splash é a desejada: livro aberto com brilhos, **sem cruz**.
- Você revisou as alterações de código e os textos que serão publicados.
- O texto sobre o uso da Tradução do Novo Mundo não afirma uma permissão que
  você não tenha. Veja o alerta em [PLANO_LANCAMENTO.md](../../PLANO_LANCAMENTO.md).
- O nome do app e os elementos de marca foram revisados para evitar sugerir
  vínculo oficial com uma organização ou site.

## 5. Confira o identificador e a versão do app

O identificador Android já configurado é:

```text
com.jwsplashgames.quiz
```

Ele identifica permanentemente o app na Play Store. **Não o altere** se o app
já tiver sido criado na Play Console.

Abra `pubspec.yaml` e confira a linha `version`. Neste projeto ela está como:

```yaml
version: 1.0.0+2
```

`1.0.0` é a versão que aparece para as pessoas; `2` é o código interno do
build. Se já foi enviado algum pacote com esse código à Play Console, aumente o
número depois de `+` antes de gerar o próximo AAB. Cada upload precisa de um
código maior que os anteriores. Não aumente sem necessidade se este ainda for
o primeiro upload.

## 6. Configure a chave de upload

A Play Store não aceita um AAB assinado com a chave de debug. Este projeto ainda
precisa de uma chave de upload configurada.

### Se este app ainda nunca foi enviado à Play Console

No terminal, a partir da raiz do projeto, execute uma única vez:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\criar_keystore.ps1
```

O script pedirá uma senha duas vezes e criará:

- A keystore em `%USERPROFILE%\keystores\jwsplashgames-upload.jks`.
- A configuração em `android\key.properties`.

Guarde a senha em um gerenciador de senhas e faça **backup seguro da keystore**.
Não envie esses dois itens por e-mail/chat, não os coloque no Git e não os
apague: serão necessários para futuras atualizações do app.

Se o script disser que `keytool` não foi encontrado, configure o JDK no Android
Studio em **File → Settings → Build, Execution, Deployment → Build Tools →
Gradle → Gradle JDK**. Depois abra um terminal novo e confira se `keytool` está
disponível antes de repetir o script.

### Se este app já foi enviado ou publicado anteriormente

**Não crie uma chave nova antes de verificar a chave usada no upload anterior.**
A Play Console precisa reconhecer a chave de upload cadastrada para este app.
Localize a cópia da keystore e a senha usadas anteriormente. Se foram perdidas,
verifique o certificado de upload e o procedimento de redefinição na Play
Console antes de gerar um pacote.

Na primeira configuração da Play Console, siga a opção **Play App Signing**.
Em geral, o Google protege a chave de assinatura do app e você usa sua chave de
upload para enviar novas versões. Siga as instruções exibidas para a conta.

## 7. Gere o AAB de release

`.aab` é o **Android App Bundle**: o pacote de distribuição que se envia à Play
Console. Não é o projeto Flutter e não é o instalador para instalar o app
manualmente no celular.

Com SDK/licenças e chave configurados, execute na raiz do projeto:

```powershell
flutter build appbundle --release
```

Se o build terminar com `Built ... app-release.aab`, o arquivo estará em:

```text
C:\Users\Denis\Documents\GitHub\AppAndroid\build\app\outputs\bundle\release\app-release.aab
```

Se aparecer novamente `License ... NDK ... not accepted`, volte à etapa 3 e
confirme que a versão `28.2.13676358` foi instalada e que as licenças foram
aceitas no mesmo SDK usado pelo Flutter.

Se aparecer aviso de assinatura debug ou falta de `android\key.properties`,
**não envie esse pacote à Play Console**. Volte à etapa 6. O projeto pode
construir um bundle de validação com a chave debug, mas ele não serve para
publicação.

## 8. Crie ou configure o app na Play Console

Entre na [Google Play Console](https://play.google.com/console) com a conta de
desenvolvedor que você já possui.

1. Se ainda não há uma ficha para o JW Splash Games, escolha **Criar app**:
   nome **JW Splash Games**, idioma padrão Português (Brasil), tipo **Jogo** e
   gratuito, se essa ainda for sua decisão. Se o app já existe, abra a ficha
   existente; não crie outra.
2. Complete os dados de contato exigidos pela Play Console, incluindo um e-mail
   público de suporte.
3. Preencha a ficha da loja usando os textos em
   [FICHA_DA_LOJA.md](../loja/FICHA_DA_LOJA.md). A pasta `assets\icon\` contém a
   arte do app; prepare também capturas de tela reais do app e os demais
   materiais que a Console pedir.
4. Informe a política de privacidade:
   `https://leniredenis-bit.github.io/AppAndroid/privacidade.html`
5. Preencha classificação de conteúdo, público-alvo, anúncios e **Segurança
   dos dados** com respostas verdadeiras e consistentes com os serviços usados
   pelo app. Consulte a seção Google Play da
   [ficha da loja](../loja/FICHA_DA_LOJA.md). Não declare que o app não coleta
   dados sem conferir Analytics, Crashlytics, Firebase e o chat de suporte.
6. Em **Acesso ao app**, explique que as telas comuns não exigem conta e informe
   como revisar recursos que dependam de mais de um jogador, se a Console
   solicitar instruções para a equipe de análise.
7. Ative **Play App Signing** quando solicitado e siga as etapas da Console.
8. Escolha uma faixa de teste apropriada e envie o arquivo
   `app-release.aab` da etapa 7. Revise os avisos que a Console mostrar e salve/
   envie a versão para análise.

Os requisitos de teste para liberar a produção dependem do tipo e da data de
criação da conta de desenvolvedor. Se a Console exigir um teste fechado,
complete exatamente o período e a quantidade de participantes indicados nela
antes de solicitar acesso à produção.

## 9. Checklist final

- [ ] Estou trabalhando em `C:\Users\Denis\Documents\GitHub\AppAndroid`.
- [ ] Revisei as alterações locais e testei o app.
- [ ] O `flutter doctor` não aponta erro de licenças Android.
- [ ] NDK `28.2.13676358` está instalado e licenciado no SDK correto.
- [ ] Sei se este é o primeiro upload e configurei a chave de upload correta.
- [ ] Fiz backup seguro da keystore e da senha.
- [ ] O código de versão é maior que o último enviado, se já houve upload.
- [ ] `flutter build appbundle --release` gerou o AAB sem assinatura debug.
- [ ] Completei ficha da loja, privacidade, classificação e Segurança dos dados.
- [ ] Enviei o AAB à faixa de teste indicada pela Play Console.

## Documentos úteis deste projeto

- [Build Android, assinatura e SDK](BUILD_ANDROID.md)
- [Textos da ficha e formulários da loja](../loja/FICHA_DA_LOJA.md)
- [Roteiro de testes manuais](COMO_TESTAR.md)
- [Plano e pendências de lançamento](../../PLANO_LANCAMENTO.md)
