# ⚡ COMANDOS RÁPIDOS - Quiz Bíblico Mobile

**Cole e execute estes comandos na ordem para configurar o app mobile**

---

## 📋 PRÉ-REQUISITOS

✅ Node.js instalado (execute primeiro):
```powershell
node --version
npm --version
npx --version
```

Se algum comando falhar, **instale o Node.js primeiro!**
👉 https://nodejs.org/ (versão LTS)

---

## 🚀 SETUP INICIAL

### 1. Navegar para pasta do projeto
```powershell
cd "c:\Users\NOTEBOOK 63\Desktop\Bot Benefícios\quiz-biblico"
```

### 2. Instalar Capacitor
```powershell
npm install @capacitor/core @capacitor/cli
```

### 3. Inicializar Capacitor
```powershell
npx cap init "Quiz Bíblico JW" com.jwquiz.app
```

### 4. Instalar plataformas
```powershell
npm install @capacitor/android @capacitor/ios
```

### 5. Adicionar plataforma Android
```powershell
npx cap add android
```

### 6. (Opcional) Adicionar iOS
```powershell
npx cap add ios
```

---

## 📱 SINCRONIZAR CÓDIGO

Sempre que mudar arquivos web, execute:

```powershell
npx cap sync
```

Ou apenas Android:

```powershell
npx cap sync android
```

---

## 🔧 ABRIR PROJETOS NATIVOS

### Android Studio
```powershell
npx cap open android
```

### Xcode (só no Mac)
```powershell
npx cap open ios
```

---

## 🔑 CRIAR KEYSTORE (ANDROID)

### Gerar keystore de assinatura
```powershell
keytool -genkey -v -keystore quiz-biblico.keystore -alias jwquiz -keyalg RSA -keysize 2048 -validity 10000
```

**IMPORTANTE:**
- Escolha uma senha forte
- Anote a senha (NUNCA perca!)
- Guarde o arquivo `.keystore` em local seguro

---

## 🏗️ BUILD ANDROID

### Via Gradle (Linha de comando)

**Build AAB (Google Play):**
```powershell
cd android
.\gradlew bundleRelease
cd ..
```

**Build APK (Teste):**
```powershell
cd android
.\gradlew assembleRelease
cd ..
```

### Limpar builds antigos
```powershell
cd android
.\gradlew clean
cd ..
```

---

## 📦 LOCALIZAÇÃO DOS ARQUIVOS

### AAB (Google Play):
```
android\app\build\outputs\bundle\release\app-release.aab
```

### APK (Teste):
```
android\app\build\outputs\apk\release\app-release.apk
```

---

## 🔍 TESTAR APK NO CELULAR

### 1. Ativar "Modo Desenvolvedor" no Android:
- Configurações → Sobre o telefone
- Toque 7x em "Número da versão"
- Volte → Opções do desenvolvedor
- Ative "Depuração USB"

### 2. Conectar celular no PC via USB

### 3. Verificar conexão:
```powershell
adb devices
```

### 4. Instalar APK:
```powershell
adb install android\app\build\outputs\apk\release\app-release.apk
```

---

## 🎨 GERAR ÍCONES AUTOMATICAMENTE

### 1. Instalar ferramenta
```powershell
npm install -g cordova-res
```

### 2. Criar pasta resources
```powershell
mkdir resources
```

### 3. Adicionar imagens:
- Coloque `icon.png` (1024x1024) em `resources/`
- Coloque `splash.png` (2732x2732) em `resources/`

### 4. Gerar ícones
```powershell
cordova-res android --skip-config --copy
cordova-res ios --skip-config --copy
```

---

## 🐛 TROUBLESHOOTING

### Limpar tudo e recomeçar
```powershell
# Remover node_modules
Remove-Item -Recurse -Force node_modules

# Remover plataformas
Remove-Item -Recurse -Force android
Remove-Item -Recurse -Force ios

# Reinstalar
npm install
npx cap add android
npx cap sync
```

### Problemas com Gradle
```powershell
cd android
.\gradlew clean
.\gradlew --stop
cd ..
npx cap sync android
```

### App não abre
1. Verifique se `<script type="module" src="capacitor.js"></script>` está no `index.html`
2. Sincronize novamente: `npx cap sync`
3. Rebuild: `cd android; .\gradlew clean; .\gradlew bundleRelease`

---

## 📊 VERIFICAR TAMANHO DO APP

```powershell
# Verificar tamanho do AAB
dir android\app\build\outputs\bundle\release\app-release.aab

# Verificar tamanho do APK
dir android\app\build\outputs\apk\release\app-release.apk
```

---

## 🔄 ATUALIZAR VERSÃO

### 1. Editar `android/app/build.gradle`:
```gradle
defaultConfig {
    versionCode 2          // Incrementar (1, 2, 3, ...)
    versionName "1.0.1"    // Versão visível (1.0.0, 1.0.1, ...)
}
```

### 2. Rebuild
```powershell
cd android
.\gradlew clean
.\gradlew bundleRelease
cd ..
```

---

## 📱 EMULADOR ANDROID

### Listar emuladores
```powershell
emulator -list-avds
```

### Iniciar emulador
```powershell
emulator -avd Pixel_5_API_33
```

### Instalar no emulador
```powershell
adb -e install android\app\build\outputs\apk\release\app-release.apk
```

---

## 🍎 BUILD iOS (Se tiver Mac)

### Abrir Xcode
```bash
npx cap open ios
```

### Ou via linha de comando (requer configuração)
```bash
cd ios/App
xcodebuild archive -scheme App -archivePath ./build/App.xcarchive
xcodebuild -exportArchive -archivePath ./build/App.xcarchive -exportPath ./build -exportOptionsPlist ExportOptions.plist
```

---

## 🌐 BUILD iOS SEM MAC (Ionic Appflow)

### 1. Instalar Ionic CLI
```powershell
npm install -g @ionic/cli
```

### 2. Login
```powershell
ionic login
```

### 3. Conectar app
```powershell
ionic link
```

### 4. Build na nuvem
```powershell
ionic package build ios --release
```

---

## 📋 CHECKLIST PRÉ-PUBLICAÇÃO

Execute antes de enviar para as lojas:

```powershell
# 1. Limpar projeto
cd android; .\gradlew clean; cd ..

# 2. Sincronizar código
npx cap sync

# 3. Build release
cd android; .\gradlew bundleRelease; cd ..

# 4. Verificar arquivo gerado
dir android\app\build\outputs\bundle\release\app-release.aab

# 5. Verificar tamanho (deve ser < 150MB)
# Se maior que 150MB, otimize imagens e assets
```

---

## 🎯 SEQUÊNCIA COMPLETA (COPIE TUDO)

```powershell
# Navegar para projeto
cd "c:\Users\NOTEBOOK 63\Desktop\Bot Benefícios\quiz-biblico"

# Instalar Capacitor
npm install @capacitor/core @capacitor/cli @capacitor/android

# Inicializar (responda perguntas)
npx cap init

# Adicionar Android
npx cap add android

# Sincronizar código
npx cap sync

# Abrir Android Studio
npx cap open android
```

Após isso:
1. Configure o keystore no Android Studio
2. Build → Generate Signed Bundle (AAB)
3. Faça upload no Google Play Console

---

## 📞 SUPORTE

Erro em algum comando? Me avise e eu ajudo! 🚀

**Links úteis:**
- Capacitor Docs: https://capacitorjs.com/docs
- Android Developers: https://developer.android.com/
- Ionic Appflow: https://ionic.io/appflow

---

**Última atualização:** Novembro 2025
