# 📱 Como Criar APK para Testar no Android

**Guia completo passo a passo para gerar APK de testes**

---

## ⚠️ Problema Atual

Você tentou executar `flutter build apk` mas recebeu o erro:
```
[!] No Android SDK found. Try setting the ANDROID_HOME environment variable.
```

Isso significa que você precisa instalar o **Android SDK** primeiro.

---

## 🎯 Solução: Instalar Android Studio

### Passo 1: Download

1. Acesse: **https://developer.android.com/studio**
2. Clique em **"Download Android Studio"**
3. Aceite os termos e baixe (~1GB)

### Passo 2: Instalação

1. Execute o instalador baixado
2. Clique em **Next** em todas as telas
3. **IMPORTANTE:** Marque:
   - ✅ Android SDK
   - ✅ Android SDK Platform
   - ✅ Android Virtual Device
4. Escolha o local de instalação (padrão: `C:\Program Files\Android\Android Studio`)
5. Aguarde a instalação (5-10 minutos)

### Passo 3: Primeira Execução do Android Studio

1. Abra o Android Studio
2. Na tela inicial, clique em **"More Actions"** → **"SDK Manager"**
3. Na aba **"SDK Platforms"**, marque:
   - ✅ Android 13.0 (Tiramisu) - API Level 33
   - ✅ Android 12.0 (S) - API Level 31
4. Na aba **"SDK Tools"**, marque:
   - ✅ Android SDK Build-Tools
   - ✅ Android SDK Platform-Tools
   - ✅ Android Emulator
   - ✅ Android SDK Command-line Tools
5. Clique em **"Apply"** e aguarde o download (~2-3GB)

### Passo 4: Configurar Variáveis de Ambiente

**Opção A: Via PowerShell (Temporário - válido só na sessão atual)**

```powershell
# Configure ANDROID_HOME
$env:ANDROID_HOME = "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk"

# Adicione ao PATH
$env:Path += ";C:\Users\$env:USERNAME\AppData\Local\Android\Sdk\platform-tools"
$env:Path += ";C:\Users\$env:USERNAME\AppData\Local\Android\Sdk\tools"

# Verifique se funcionou
adb --version
```

**Opção B: Via Sistema (Permanente)**

1. Pressione **Win + R**
2. Digite `sysdm.cpl` e pressione Enter
3. Vá na aba **"Avançado"**
4. Clique em **"Variáveis de Ambiente"**
5. Em **"Variáveis do sistema"**, clique em **"Novo"**:
   - Nome: `ANDROID_HOME`
   - Valor: `C:\Users\SEU_USUARIO\AppData\Local\Android\Sdk`
6. Edite a variável **"Path"** e adicione:
   - `C:\Users\SEU_USUARIO\AppData\Local\Android\Sdk\platform-tools`
   - `C:\Users\SEU_USUARIO\AppData\Local\Android\Sdk\tools`
7. Clique em **OK** em tudo
8. **IMPORTANTE:** Feche e reabra o PowerShell

### Passo 5: Verificar Instalação

Abra um novo PowerShell e execute:

```powershell
# Verificar se Flutter detecta o Android SDK
flutter doctor
```

Você deve ver:
```
[✓] Android toolchain - develop for Android devices (Android SDK version X.X.X)
```

Se ainda aparecer **[!]**, execute:
```powershell
flutter doctor --android-licenses
```
E aceite todas as licenças digitando **"y"**.

---

## 🏗️ Criar o APK

Agora sim! Com o Android SDK configurado, execute:

### Opção 1: APK Debug (Rápido para testes)

```powershell
cd "C:\Users\NOTEBOOK 63\Desktop\Bot Benefícios\jw_quiz_flutter"
flutter build apk --debug
```

**Vantagens:**
- ✅ Build rápido (1-2 minutos)
- ✅ Não precisa de assinatura
- ✅ Ideal para testes

**APK gerado em:**
```
build\app\outputs\flutter-apk\app-debug.apk
```

### Opção 2: APK Release (Otimizado)

```powershell
flutter build apk --release
```

**Vantagens:**
- ✅ APK menor (~20-25 MB vs ~50 MB debug)
- ✅ Performance otimizada
- ✅ Experiência real da loja

**APK gerado em:**
```
build\app\outputs\flutter-apk\app-release.apk
```

---

## 📲 Instalar no Android

### Método 1: Via Cabo USB

1. Conecte o celular no PC via USB
2. No celular, ative **"Depuração USB"**:
   - Configurações → Sobre o telefone
   - Toque 7x em "Número da compilação"
   - Volte → Opções do desenvolvedor
   - Ative "Depuração USB"
3. No PowerShell, execute:
   ```powershell
   adb install "build\app\outputs\flutter-apk\app-debug.apk"
   ```

### Método 2: Via Google Drive / Email

1. Copie o APK para o Google Drive ou envie por email
2. No celular, baixe o APK
3. Permita instalação de fontes desconhecidas:
   - Configurações → Segurança
   - Ative "Fontes desconhecidas"
4. Toque no APK e instale

### Método 3: Via ADB Wireless (Android 11+)

1. No celular:
   - Configurações → Opções do desenvolvedor
   - Ative "Depuração sem fio"
   - Toque em "Emparelhar usando código QR/PIN"
2. No PC:
   ```powershell
   adb pair <IP>:<PORTA>
   # Digite o código mostrado no celular
   
   adb connect <IP>:<PORTA>
   adb install "build\app\outputs\flutter-apk\app-debug.apk"
   ```

---

## 🧪 Testar no Emulador (Alternativa)

Se você não tem um celular Android, pode usar um emulador:

### 1. Criar Emulador

1. Abra Android Studio
2. Clique em **"More Actions"** → **"Virtual Device Manager"**
3. Clique em **"Create Device"**
4. Escolha um dispositivo (ex: Pixel 5)
5. Escolha uma imagem do sistema (ex: API 33 - Android 13)
6. Clique em **"Finish"**

### 2. Iniciar Emulador

1. No AVD Manager, clique no ▶️ do emulador criado
2. Aguarde o emulador carregar (1-2 minutos)

### 3. Executar o App

```powershell
cd "C:\Users\NOTEBOOK 63\Desktop\Bot Benefícios\jw_quiz_flutter"
flutter run
```

O Flutter detectará automaticamente o emulador e instalará o app!

---

## ❓ Problemas Comuns

### "No devices found"

**Solução:**
```powershell
# Verifique dispositivos conectados
adb devices

# Se vazio, reinicie o servidor ADB
adb kill-server
adb start-server
```

### "Gradle build failed"

**Solução:**
```powershell
# Limpe o cache
flutter clean
flutter pub get

# Tente novamente
flutter build apk --debug
```

### "SDK licenses not accepted"

**Solução:**
```powershell
flutter doctor --android-licenses
# Digite 'y' para aceitar todas
```

### APK muito grande (>100MB)

**Solução:** Use release ao invés de debug:
```powershell
flutter build apk --release --split-per-abi
```

Isso cria 3 APKs (arm64, armv7, x86_64) menores.

---

## 📊 Comparação: Debug vs Release

| Característica | Debug | Release |
|---|---|---|
| Tamanho | ~50-60 MB | ~20-25 MB |
| Tempo de build | 1-2 minutos | 3-5 minutos |
| Performance | Lenta | Otimizada |
| Hot reload | ✅ Sim | ❌ Não |
| Ideal para | Testes rápidos | Testes finais |
| Publicar na loja | ❌ Não | ✅ Sim* |

*Para publicar na loja, precisa de assinatura própria (não debug).

---

## 🚀 Próximos Passos

Após testar o APK no celular:

1. ✅ Verificar se todos os 11 minigames funcionam
2. ✅ Testar sistema de conquistas
3. ✅ Testar mudança de idioma
4. ✅ Testar áudio/SFX
5. ✅ Testar multiplayer (se Firebase configurado)

Se tudo funcionar bem, você está pronto para:
- Criar ícone profissional
- Configurar assinatura release
- Publicar na Play Store!

---

## 📞 Links Úteis

- **Android Studio Download:** https://developer.android.com/studio
- **Flutter Doctor:** https://docs.flutter.dev/get-started/install/windows#android-setup
- **ADB Commands:** https://developer.android.com/tools/adb
- **Play Store Guidelines:** https://developer.android.com/distribute/best-practices

---

**Última atualização:** 28/11/2025  
**Dúvidas?** Consulte a documentação completa em `PROJECT_STATUS.md`
