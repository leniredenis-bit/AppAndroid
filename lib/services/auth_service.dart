// ============================================================
// VERSÃO MOCK TEMPORÁRIA - Firebase desabilitado para teste web
// Ver docs/FIREBASE_BACKUP.md para código original
// ============================================================

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _mockUserId;

  /// Retorna o usuário atual (mock)
  Future<dynamic> getCurrentUser() async {
    if (_mockUserId == null) {
      _mockUserId = const Uuid().v4();
      debugPrint('AuthService (MOCK): Usuário criado: $_mockUserId');
    }
    return _mockUserId;
  }

  /// Retorna o ID do usuário atual
  String? get userId => _mockUserId;

  /// Faz logout (mock)
  Future<void> signOut() async {
    _mockUserId = null;
    debugPrint('AuthService (MOCK): Logout realizado');
  }
}
