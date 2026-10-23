# Como Criar APK (Guia Unificado)

Guia consolidado para build Android do projeto Flutter com foco em AppAndroid.

## Pre-requisitos

- Flutter instalado
- Android SDK instalado
- Java (JDK) instalado
- Licencas Android aceitas

## Verificacao rapida

```powershell
flutter doctor
flutter doctor --android-licenses
```

Se o SDK nao for detectado, configure o caminho no Flutter:

```powershell
flutter config --android-sdk "C:\Program Files (x86)\Android\android-sdk"
```

## Build de teste (debug)

```powershell
cd C:\Users\Denis\Documents\GitHub\AppAndroid
flutter clean
flutter pub get
flutter build apk --debug
```

Saida esperada:

- build\app\outputs\flutter-apk\app-debug.apk

## Build de distribuicao (release)

```powershell
cd C:\Users\Denis\Documents\GitHub\AppAndroid
flutter clean
flutter pub get
flutter build apk --release
```

Saida esperada:

- build\app\outputs\flutter-apk\app-release.apk

## Instalacao no dispositivo

```powershell
adb devices
adb install -r build\app\outputs\flutter-apk\app-debug.apk
```

## Problemas comuns

- Android SDK nao encontrado: revisar flutter config --android-sdk
- Licencas nao aceitas: rodar flutter doctor --android-licenses
- Build Gradle falha: rodar flutter clean e tentar novamente
- Dispositivo nao aparece: reiniciar ADB com adb kill-server e adb start-server

## Decisao desta unificacao

Este guia substitui as variacoes antigas para evitar caminhos locais desatualizados e instrucoes duplicadas.
