# 🔥 BACKUP DO CÓDIGO FIREBASE

> **Data**: 01/12/2025  
> **Objetivo**: Guardar código Firebase para restaurar após testes no navegador

---

## 📁 main.dart — Código Original com Firebase

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'services/multiplayer/mock_multiplayer_service.dart';
import 'services/audio_service.dart';
import 'services/language_service.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase com tratamento de erro
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase inicializado com sucesso!');
  } catch (e) {
    debugPrint('Erro ao inicializar Firebase: $e');
    debugPrint('O app continuará usando o modo offline/mock.');
  }
  
  // Inicializar serviço multiplayer
  MockMultiplayerService.initialize();
  
  // Inicializar serviço de áudio
  await AudioService().initialize();
  
  // Inicializar idioma salvo
  await LanguageService().initialize();
  
  runApp(const MyApp());
}
```

---

## 📁 pubspec.yaml — Dependências Firebase

```yaml
# Firebase para multiplayer online
firebase_core: ^2.24.2
firebase_database: ^10.4.0
firebase_auth: ^4.15.3
```

---

## 📁 android/app/build.gradle.kts — Plugin Firebase

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // Firebase plugin
}
```

---

## 📁 android/settings.gradle.kts — Versão do Plugin

```kotlin
id("com.google.gms.google-services") version "4.4.0" apply false  // Firebase
```

---

## 📁 lib/services/auth_service.dart — Serviço de Autenticação

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  /// Retorna o usuário atual ou faz login anônimo
  Future<User?> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    // Verificar se já existe usuário autenticado
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      debugPrint('AuthService: Usuário já autenticado: ${_currentUser!.uid}');
      return _currentUser;
    }

    // Fazer login anônimo
    try {
      final userCredential = await _auth.signInAnonymously();
      _currentUser = userCredential.user;
      debugPrint('AuthService: Login anônimo bem-sucedido: ${_currentUser!.uid}');
      return _currentUser;
    } catch (e) {
      debugPrint('AuthService: Erro no login anônimo: $e');
      return null;
    }
  }

  /// Retorna o ID do usuário atual
  String? get userId => _currentUser?.uid ?? _auth.currentUser?.uid;

  /// Faz logout
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    debugPrint('AuthService: Logout realizado');
  }
}
```

---

## 🔄 COMO RESTAURAR

Para voltar ao modo Firebase, basta:

1. **No `main.dart`**, descomentar a inicialização do Firebase:
```dart
// DESCOMENTADO:
try {
  await Firebase.initializeApp();
  debugPrint('Firebase inicializado com sucesso!');
} catch (e) {
  debugPrint('Erro ao inicializar Firebase: $e');
  debugPrint('O app continuará usando o modo offline/mock.');
}
```

2. Garantir que o import está presente:
```dart
import 'package:firebase_core/firebase_core.dart';
```

3. Rebuild o app:
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

---

## ⚠️ IMPORTANTE

O código do `FirebaseMultiplayerService` e `AuthService` permanece intacto nos arquivos originais.
Apenas a **inicialização** no `main.dart` será comentada para testes no navegador.

O app usará automaticamente o `MockMultiplayerService` para simular partidas online.
