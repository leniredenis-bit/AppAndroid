# JW Splash Games — o que falta para publicar na Google Play

Este guia foi reduzido para acompanhar as etapas que ainda faltam. O projeto
Flutter já está pronto e fica em:

```text
C:\Users\Denis\Documents\GitHub\AppAndroid
```

Não crie outro projeto e não copie arquivos para outra pasta.

## Status confirmado

- [x] Projeto Flutter, ícone e splash preparados.
- [x] `flutter analyze` sem problemas.
- [x] 45 testes automatizados passaram.
- [x] SDK configurado em `C:\Android\Sdk` e NDK `28.2.13676358` instalado.
- [x] APK de teste debug gerado.
- [ ] Instalar e testar esse APK em um celular Android real.
- [ ] Confirmar/configurar a chave de upload válida.
- [ ] Gerar e validar o AAB de release.
- [ ] Completar a ficha e os formulários da Play Console.
- [ ] Enviar para a faixa de teste exigida pela Play Console.

O último `flutter doctor` ainda mostrou o estado das licenças como desconhecido,
mas o Gradle aceitou as licenças dos componentes que precisava e concluiu o
build debug. **Não repita a instalação/mudança do SDK agora.** Se um novo build
for bloqueado por licença, trate o erro específico que aparecer.

> Há alterações locais do app. O APK/AAB é criado a partir dos arquivos salvos
> na pasta do projeto. Revise e teste o conteúdo que será publicado.

## 1. Teste o APK no celular

O APK de teste está em:

```text
C:\Users\Denis\Documents\GitHub\AppAndroid\build\app\outputs\flutter-apk\app-debug.apk
```

Para abrir a pasta no Windows, pressione **Win + R**, cole o caminho abaixo e
pressione **Enter**:

```text
C:\Users\Denis\Documents\GitHub\AppAndroid\build\app\outputs\flutter-apk
```

Copie `app-debug.apk` para o celular por cabo USB, Drive ou outro meio confiável.
No aparelho, abra o arquivo e, se solicitado, autorize temporariamente a
instalação de apps da origem usada. Depois da instalação, teste pelo menos:

- abertura, navegação e aparência geral;
- quiz, resultado, estatísticas e configurações;
- minigames, áudio e troca de idioma;
- selecionar foto no quebra-cabeça;
- multiplayer em dois celulares, se possível.

Esse APK tem cerca de 207 MB por ser de depuração; **não é o pacote para a loja**
e não representa o tamanho do download publicado.

Se o Android disser que o app não pode ser instalado por conflito com uma
versão já instalada, não desinstale sem antes considerar que isso pode apagar
os dados locais dessa instalação. Avise qual mensagem apareceu para avaliarmos
o próximo passo.

## 2. Resolva a chave de upload

O AAB da Play Store precisa ser assinado com a chave de upload correta. Ainda
não há `android\key.properties` configurado neste projeto.

Primeiro, confirme se este app, com o identificador `com.jwsplashgames.quiz`,
já teve algum AAB enviado à Play Console:

- **Nunca foi enviado:** na raiz do projeto, execute uma única vez:

  ```powershell
  powershell -ExecutionPolicy Bypass -File scripts\criar_keystore.ps1
  ```

  O script pede uma senha e cria a chave em
  `%USERPROFILE%\keystores\jwsplashgames-upload.jks` e a configuração local em
  `android\key.properties`.

- **Já foi enviado antes:** não crie uma chave nova. Localize a chave de upload
  usada anteriormente. Se ela foi perdida, confira na Play Console a opção de
  redefinir a chave de upload antes de tentar enviar uma nova versão.

Guarde a `.jks` e a senha em local seguro e faça backup. **Não envie a chave ou
`key.properties` pelo chat, não os coloque no Git e não os apague.** A conta de
desenvolvedor já existe; ao criar/configurar o app na Play Console, siga também
as instruções para ativar o Play App Signing.

## 3. Confira a versão e gere o AAB

O identificador do app é:

```text
com.jwsplashgames.quiz
```

Não o altere se o app já foi criado na Play Console. A versão atual em
`pubspec.yaml` é `1.0.0+2`: `1.0.0` é o nome visível e `2` é o código interno do
build. Se a Play Console já recebeu o código `2`, aumente o número após `+`
antes do próximo upload. Todo upload precisa de um código ainda não utilizado.

Com a chave correta configurada, abra o terminal na raiz do projeto e execute:

```powershell
cd C:\Users\Denis\Documents\GitHub\AppAndroid
flutter build appbundle --release
```

O AAB será criado em:

```text
C:\Users\Denis\Documents\GitHub\AppAndroid\build\app\outputs\bundle\release\app-release.aab
```

`.aab` significa **Android App Bundle**: é o pacote que se envia à Play Console.
Não é um instalador para abrir diretamente no celular. Se o build informar que
está usando assinatura debug ou que falta a chave, não envie esse AAB à loja;
volte à etapa 2.

## 4. Complete a Play Console e envie para teste

Entre na [Google Play Console](https://play.google.com/console) com sua conta
de desenvolvedor:

1. Abra o app existente, se já o criou. Caso ainda não exista, crie **JW Splash
   Games**, como jogo gratuito, somente se essa continuar sendo sua decisão.
2. Preencha os dados de contato, incluindo um e-mail de suporte público.
3. Use os textos da [ficha da loja](../loja/FICHA_DA_LOJA.md) e prepare
   capturas de tela reais do app e os materiais pedidos pela Console.
4. Informe a política de privacidade:
   `https://leniredenis-bit.github.io/AppAndroid/privacidade.html`
5. Preencha classificação de conteúdo, público-alvo, anúncios e **Segurança
   dos dados** com informações verdadeiras. O app usa Firebase Analytics,
   Crashlytics, Firebase para multiplayer e chat Crisp; confira as declarações
   na [ficha da loja](../loja/FICHA_DA_LOJA.md).
6. Siga a configuração do Play App Signing.
7. Crie ou selecione a faixa de teste indicada pela Console e envie
   `app-release.aab`.
8. Complete quaisquer requisitos de teste fechado que a Console mostrar antes
   de solicitar acesso à produção. Quantidade de testadores e duração dependem
   dos requisitos aplicados à conta.

## Quando pedir ajuda

Depois de instalar e testar o APK, relate qualquer problema observado. Para
continuar com a publicação, diga também se o app já foi enviado à Play Console
alguma vez; isso determina se devemos usar uma chave existente ou criar a
primeira chave de upload.

## Referências do projeto

- [Textos da ficha e respostas dos formulários](../loja/FICHA_DA_LOJA.md)
- [Roteiro detalhado de testes](COMO_TESTAR.md)
- [Build Android e assinatura](BUILD_ANDROID.md)
- [Plano de lançamento](../../PLANO_LANCAMENTO.md)
