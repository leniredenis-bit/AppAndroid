# ✅ Checklist de Publicação - JW Quiz Flutter

**Use este checklist para acompanhar o progresso até a publicação!**

---

## 📋 FASE 1: Preparação (1-2 dias)

### Identidade do App
- [ ] Decidir nome comercial final
  - Nome escolhido: `_______________________`
  - Data decisão: `___/___/2025`

- [ ] Criar Application ID único
  - [ ] Android: Alterar `android/app/build.gradle.kts` linha 24
  - [ ] iOS: Alterar Bundle Identifier em Xcode
  - Application ID: `com._________.jwquiz`
  - ✅ Verificado: Não usado por outro app na Play Store

### Ícone e Splash
- [ ] Criar/encomendar ícone profissional
  - [ ] Tamanho: 1024x1024px
  - [ ] Formato: PNG com transparência
  - [ ] Tema: Bíblico + Quiz/Jogos
  - Arquivo salvo em: `assets/icon/app_icon.png`
  - Designer/Ferramenta: `_______________________`

- [ ] Configurar flutter_launcher_icons
  ```bash
  flutter pub add --dev flutter_launcher_icons
  flutter pub run flutter_launcher_icons
  ```
  - [ ] Executado com sucesso
  - [ ] Ícones gerados em todas as resoluções
  - [ ] Testado em emulador/dispositivo

- [ ] Criar splash screen (opcional)
  - [ ] Usar `flutter_native_splash` package
  - [ ] Configurado e testado

### Assinatura Android
- [ ] Criar keystore para release
  ```bash
  keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
  ```
  - Localização: `_______________________`
  - ⚠️ Senha anotada em local seguro: SIM / NÃO
  - ⚠️ Backup do keystore criado: SIM / NÃO

- [ ] Criar `android/key.properties`
  - [ ] storePassword configurado
  - [ ] keyPassword configurado
  - [ ] keyAlias = upload
  - [ ] storeFile com caminho correto

- [ ] Atualizar `android/app/build.gradle.kts`
  - [ ] signingConfigs adicionado
  - [ ] buildTypes.release atualizado
  - [ ] Testado build release

---

## 📋 FASE 2: Firebase Production (1 dia)

### Criar Projeto Firebase
- [ ] Acessar https://console.firebase.google.com/
- [ ] Criar novo projeto
  - Nome do projeto: `_______________________`
  - Project ID: `_______________________`

### Configurar Apps
- [ ] Adicionar app Android
  - [ ] Application ID correto inserido
  - [ ] Baixar `google-services.json`
  - [ ] Colocar em `android/app/`
  - [ ] Verificar build compila

- [ ] Adicionar app iOS
  - [ ] Bundle ID correto inserido
  - [ ] Baixar `GoogleService-Info.plist`
  - [ ] Colocar em `ios/Runner/`
  - [ ] Verificar build compila

### Configurar Serviços
- [ ] Ativar Realtime Database
  - [ ] Criar database
  - [ ] Configurar regras de segurança
  - [ ] Testar leitura/escrita

- [ ] Ativar Authentication
  - [ ] Ativar método Anonymous
  - [ ] Testar autenticação

### Testar Multiplayer
- [ ] Testar criação de sala
- [ ] Testar entrada em sala
- [ ] Testar partida completa
- [ ] Testar em 2 dispositivos simultâneos

---

## 📋 FASE 3: Assets da Store (1-2 dias)

### Screenshots Android
- [ ] Capturar 2-8 screenshots
  - [ ] Home screen
  - [ ] Quiz em ação
  - [ ] Minigames (2-3 melhores)
  - [ ] Conquistas
  - [ ] Multiplayer
  - Ferramenta usada: `_______________________`
  - Screenshots salvos em: `_______________________`

### Screenshots iOS
- [ ] Capturar screenshots
  - [ ] iPhone 6.7" (1290x2796)
  - [ ] iPhone 6.5" (1242x2688)
  - [ ] iPhone 5.5" (1242x2208)
  - [ ] iPad Pro (2048x2732)

### Gráficos Promocionais
- [ ] Feature Graphic (Android)
  - Tamanho: 1024x500px
  - Arquivo: `_______________________`

- [ ] Promotional Graphic (opcional)
  - Tamanho: 180x120px

### Textos
- [ ] Descrição curta (80 chars)
  ```
  _____________________________________________________________
  ```

- [ ] Descrição longa (até 4000 chars)
  - [ ] Rascunho criado
  - [ ] Revisado
  - [ ] Traduzido (EN, ES)

- [ ] Notas de versão (v1.0.0)
  ```
  _____________________________________________________________
  _____________________________________________________________
  ```

### Privacy Policy
- [ ] Criar documento de privacidade
  - Ferramenta: `_______________________`
  - URL hospedada: `_______________________`
  - [ ] Link testado e acessível

---

## 📋 FASE 4: Build e Testes (1 dia)

### Build Android
- [ ] Limpar projeto
  ```bash
  flutter clean
  flutter pub get
  ```

- [ ] Build APK release
  ```bash
  flutter build apk --release
  ```
  - [ ] Sem erros
  - Tamanho: ______ MB
  - Local: `build/app/outputs/flutter-apk/app-release.apk`

- [ ] Build AAB release (Play Store)
  ```bash
  flutter build appbundle --release
  ```
  - [ ] Sem erros
  - Tamanho: ______ MB
  - Local: `build/app/outputs/bundle/release/app-release.aab`

### Build iOS (requer macOS)
- [ ] Build iOS release
  ```bash
  flutter build ios --release
  ```

- [ ] Build IPA
  ```bash
  flutter build ipa
  ```
  - [ ] Sem erros
  - Tamanho: ______ MB

### Testes Finais
- [ ] Instalar APK em dispositivo real
- [ ] Testar TODAS as funcionalidades:
  - [ ] Quiz (todos os modos)
  - [ ] Todos os 11 minigames
  - [ ] Sistema de conquistas
  - [ ] Mudança de idioma
  - [ ] Sistema de áudio
  - [ ] Multiplayer (se Firebase ok)
  - [ ] Estatísticas e rankings
- [ ] Não encontrados bugs críticos

---

## 📋 FASE 5: Upload e Publicação

### Google Play Store
- [ ] Criar conta Play Console ($25 taxa única)
  - Email da conta: `_______________________`
  - [ ] Verificação de identidade completa

- [ ] Criar novo app no console
  - Nome do app: `_______________________`
  - [ ] Categoria selecionada: Educação
  - [ ] Classificação etária: Livre

- [ ] Preencher ficha da loja
  - [ ] Título do app
  - [ ] Descrição curta
  - [ ] Descrição completa
  - [ ] Screenshots carregados
  - [ ] Feature graphic carregado
  - [ ] Ícone 512x512px
  - [ ] Privacy Policy URL
  - [ ] Categoria e tags

- [ ] Configurar preço e distribuição
  - [ ] Gratuito
  - [ ] Países de distribuição selecionados

- [ ] Upload AAB
  - [ ] AAB carregado em "Produção"
  - [ ] Notas de versão adicionadas
  - [ ] Release name: v1.0.0

- [ ] Questionário de conteúdo
  - [ ] Preenchido completamente
  - [ ] Classificação indicativa obtida

- [ ] Enviar para revisão
  - Data de envio: `___/___/2025`
  - Status: `_______________________`

### Apple App Store
- [ ] Criar Apple Developer Account ($99/ano)
  - Email da conta: `_______________________`

- [ ] Criar certificados
  - [ ] Development certificate
  - [ ] Distribution certificate
  - [ ] Push notification certificate (se usar)

- [ ] Criar Provisioning Profiles
  - [ ] Development profile
  - [ ] Distribution profile

- [ ] Criar app no App Store Connect
  - Nome do app: `_______________________`
  - Bundle ID: `_______________________`
  - SKU: `_______________________`

- [ ] Preencher informações
  - [ ] Nome
  - [ ] Subtítulo
  - [ ] Descrição
  - [ ] Keywords
  - [ ] Screenshots (todos os tamanhos)
  - [ ] Privacy Policy URL
  - [ ] Categoria

- [ ] Upload IPA
  - Via: Xcode / Transporter
  - Build number: `_______`
  - [ ] Upload bem-sucedido
  - [ ] Build aparece no App Store Connect

- [ ] Configurar versão
  - [ ] Screenshots adicionados
  - [ ] Notas de versão
  - [ ] Informações de contato
  - [ ] Questionário de classificação

- [ ] Enviar para revisão
  - Data de envio: `___/___/2025`
  - Status: `_______________________`

---

## 📋 PÓS-PUBLICAÇÃO

### Monitoramento
- [ ] Configurar Firebase Analytics
- [ ] Configurar Firebase Crashlytics
- [ ] Monitorar reviews e ratings
- [ ] Responder comentários dos usuários

### Marketing
- [ ] Criar página/site do app
- [ ] Compartilhar em redes sociais
- [ ] Enviar para comunidades relevantes
- [ ] Criar material promocional (vídeo, banners)

### Manutenção
- [ ] Corrigir bugs reportados
- [ ] Planejar próxima versão (v1.1)
- [ ] Coletar feedback dos usuários
- [ ] Adicionar novas features baseadas no feedback

---

## 🎯 Status Geral

**Progresso Total:** ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ 0%

### Por Fase
- Fase 1 (Preparação): ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ 0%
- Fase 2 (Firebase): ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ 0%
- Fase 3 (Assets): ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ 0%
- Fase 4 (Build): ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ 0%
- Fase 5 (Upload): ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ 0%

---

## 📝 Notas e Observações

```
Data: ___/___/2025
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________
```

---

**🎉 BOA SORTE COM A PUBLICAÇÃO!**

Imprima este checklist e marque cada item conforme completa!
