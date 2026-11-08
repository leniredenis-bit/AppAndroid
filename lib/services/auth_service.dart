import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'firebase_service.dart';
import '../utils/i18n.dart';

/// Identidade do jogador para o multiplayer.
///
/// - Com Firebase disponível (Android/iOS): login anônimo do Firebase Auth.
///   O UID é usado como playerId e validado pelas regras do Realtime Database.
/// - Sem Firebase (web/testes): gera um ID local (modo mock).
///
/// Requer o provedor "Anônimo" ativo no Firebase Console
/// (Authentication > Sign-in method > Anonymous).
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _localUserId;

  bool get _useFirebase => FirebaseService().isInitialized;

  /// ID do usuário atual (null se ainda não autenticado)
  String? get userId =>
      _useFirebase ? FirebaseAuth.instance.currentUser?.uid : _localUserId;

  /// Garante que existe um usuário autenticado e retorna seu ID.
  Future<String> ensureSignedIn() async {
    if (!_useFirebase) {
      return _localUserId ??= const Uuid().v4();
    }

    final auth = FirebaseAuth.instance;
    if (auth.currentUser != null) return auth.currentUser!.uid;

    try {
      final credential = await auth.signInAnonymously();
      debugPrint('AuthService: login anônimo ${credential.user!.uid}');
      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      debugPrint('AuthService: falha no login anônimo: ${e.code}');
      throw Exception(
        t3('Não foi possível conectar ao modo online. Verifique sua internet e tente novamente.', 'Could not connect to online mode. Check your internet and try again.', 'No se pudo conectar al modo en línea. Revisa tu internet e inténtalo de nuevo.'),
      );
    }
  }

  Future<void> signOut() async {
    _localUserId = null;
    if (_useFirebase) await FirebaseAuth.instance.signOut();
  }
}
