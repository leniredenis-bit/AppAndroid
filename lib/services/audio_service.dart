import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';

/// Serviço centralizado para gerenciar música de fundo e efeitos sonoros
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  // Player de música + pool de players de efeitos (permite sons sobrepostos)
  final AudioPlayer _musicPlayer = AudioPlayer();
  static const int _sfxPoolSize = 5;
  final List<AudioPlayer> _sfxPool = List.generate(_sfxPoolSize, (_) => AudioPlayer());
  int _nextSfx = 0;
  double _sfxVolume = 0.7;

  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;
  bool _isInitialized = false;
  String? _currentMusic;

  // Músicas disponíveis por tela
  static const Map<String, List<String>> _backgroundMusic = {
    'home': ['assets/audio/home.mp3', 'assets/audio/Life of Riley.mp3'],
    'quiz': ['assets/audio/quiz.mp3', 'assets/audio/quiz-home.mp3'],
    'memory': ['assets/audio/memory-game.mp3', 'assets/audio/memory-home.mp3'],
    'pie': ['assets/audio/Pixel Peeker Polka - faster.mp3'],
  };

  // Efeitos sonoros: assets/audio/sfx/{nome}.wav, gerados por scripts/generate_sfx.py
  // click, pop, whoosh, card_flip, match, mismatch, correct, wrong, star, combo,
  // victory, game_over, snap, pickup, step, bump, gem, paint, erase, note_0..note_8

  /// Inicializa o serviço de áudio
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Configura o player de música para loop
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setVolume(0.4); // Volume mais baixo para música de fundo
    
    // Configura o pool de efeitos sonoros
    for (final player in _sfxPool) {
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setVolume(_sfxVolume);
    }
    
    _isInitialized = true;
  }

  /// Toca música de fundo para uma tela específica (escolhe aleatoriamente)
  /// IMPORTANTE: No Flutter Web, só funciona após interação do usuário
  Future<void> playBackgroundMusic(String screen) async {
    if (!_isMusicEnabled || !_isInitialized) return;

    final musicList = _backgroundMusic[screen];
    if (musicList == null || musicList.isEmpty) return;

    // Escolhe música aleatória da lista
    final randomMusic = musicList[Random().nextInt(musicList.length)];
    
    // Se já está tocando a mesma música, não reinicia
    if (_currentMusic == randomMusic) return;

    _currentMusic = randomMusic;
    
    try {
      await _musicPlayer.stop();
      await _musicPlayer.play(AssetSource(randomMusic.replaceFirst('assets/', '')));
    } catch (e) {
      // No Flutter Web, autoplay pode ser bloqueado pelo navegador
      // Isso é esperado - o áudio só tocará após primeira interação
      debugPrint('Aviso: Música de fundo requer interação do usuário primeiro (Web)');
    }
  }

  /// Para a música de fundo
  Future<void> stopBackgroundMusic() async {
    await _musicPlayer.stop();
    _currentMusic = null;
  }

  /// Pausa a música de fundo
  Future<void> pauseBackgroundMusic() async {
    await _musicPlayer.pause();
  }

  /// Retoma a música de fundo
  Future<void> resumeBackgroundMusic() async {
    if (!_isMusicEnabled) return;
    await _musicPlayer.resume();
  }

  // ==================== EFEITOS SONOROS ====================

  /// Toca um efeito sonoro pelo nome (ex.: 'snap', 'note_3').
  /// Usa o próximo player do pool para que sons rápidos não se cortem.
  Future<void> playSfx(String name, {double volume = 1.0}) async {
    if (!_isSfxEnabled) return;
    final player = _sfxPool[_nextSfx];
    _nextSfx = (_nextSfx + 1) % _sfxPoolSize;
    try {
      await player.stop();
      await player.setVolume((_sfxVolume * volume).clamp(0.0, 1.0));
      await player.play(AssetSource('audio/sfx/$name.wav'));
    } catch (e) {
      debugPrint('SFX indisponível: $name ($e)');
    }
  }

  /// Nota musical dos cristais (0 a 8, escala pentatônica)
  Future<void> playNote(int index) => playSfx('note_${index.clamp(0, 8)}');

  Future<void> playCardFlip() => playSfx('card_flip');
  Future<void> playMatch() => playSfx('match');
  Future<void> playMismatch() => playSfx('mismatch');
  Future<void> playCorrectAnswer() => playSfx('correct');
  Future<void> playWrongAnswer() => playSfx('wrong');
  Future<void> playClick() => playSfx('click', volume: 0.6);
  Future<void> playGameOver() => playSfx('game_over');
  Future<void> playVictory() => playSfx('victory');

  // ==================== CONTROLES ====================

  /// Ativa/desativa música de fundo
  void setMusicEnabled(bool enabled) {
    _isMusicEnabled = enabled;
    if (!enabled) {
      stopBackgroundMusic();
    }
  }

  /// Ativa/desativa efeitos sonoros
  void setSfxEnabled(bool enabled) {
    _isSfxEnabled = enabled;
  }

  /// Verifica se música está habilitada
  bool get isMusicEnabled => _isMusicEnabled;

  /// Verifica se efeitos sonoros estão habilitados
  bool get isSfxEnabled => _isSfxEnabled;

  /// Ajusta volume da música (0.0 a 1.0)
  Future<void> setMusicVolume(double volume) async {
    await _musicPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Ajusta volume dos efeitos sonoros (0.0 a 1.0)
  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    for (final player in _sfxPool) {
      await player.setVolume(_sfxVolume);
    }
  }

  /// Libera recursos
  Future<void> dispose() async {
    await _musicPlayer.dispose();
    for (final player in _sfxPool) {
      await player.dispose();
    }
  }
}
