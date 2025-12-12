import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Serviço singleton para inicialização do Firebase
/// 
/// Responsável por:
/// - Inicializar Firebase Core
/// - Verificar se Firebase está disponível
/// - Gerenciar estado de inicialização
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool _isInitialized = false;
  bool _initializationFailed = false;
  String? _initializationError;

  /// Verifica se o Firebase foi inicializado com sucesso
  bool get isInitialized => _isInitialized;
  
  /// Verifica se a inicialização falhou
  bool get initializationFailed => _initializationFailed;
  
  /// Mensagem de erro da inicialização (se houver)
  String? get initializationError => _initializationError;

  /// Inicializa o Firebase
  /// 
  /// Deve ser chamado antes de qualquer outro serviço Firebase.
  /// Retorna true se inicializado com sucesso, false caso contrário.
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('🔥 FirebaseService: Já inicializado');
      return true;
    }

    if (_initializationFailed) {
      debugPrint('🔥 FirebaseService: Inicialização já falhou anteriormente');
      return false;
    }

    try {
      debugPrint('🔥 FirebaseService: Iniciando inicialização...');
      
      await Firebase.initializeApp();
      
      _isInitialized = true;
      debugPrint('✅ FirebaseService: Inicializado com sucesso!');
      return true;
    } catch (e, stackTrace) {
      _initializationFailed = true;
      _initializationError = e.toString();
      
      debugPrint('❌ FirebaseService: Falha na inicialização');
      debugPrint('   Erro: $e');
      debugPrint('   StackTrace: $stackTrace');
      
      return false;
    }
  }

  /// Reseta o estado de inicialização (útil para testes)
  @visibleForTesting
  void reset() {
    _isInitialized = false;
    _initializationFailed = false;
    _initializationError = null;
  }
}
