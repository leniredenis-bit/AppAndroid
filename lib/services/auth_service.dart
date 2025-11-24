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
