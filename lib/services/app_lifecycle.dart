import 'package:flutter/widgets.dart';
import 'audio_service.dart';

/// Acompanha se o app está em primeiro plano.
///
/// Ao ir para segundo plano pausa a música; ao voltar, retoma. Telas com
/// cronômetro escutam [foreground] para pausar a contagem.
class AppLifecycle with WidgetsBindingObserver {
  static final AppLifecycle _instance = AppLifecycle._internal();
  factory AppLifecycle() => _instance;
  AppLifecycle._internal();

  static final ValueNotifier<bool> foreground = ValueNotifier(true);

  void attach() => WidgetsBinding.instance.addObserver(this);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final active = state == AppLifecycleState.resumed;
    if (active == foreground.value) return;
    foreground.value = active;
    if (active) {
      AudioService().resumeBackgroundMusic();
    } else {
      AudioService().pauseBackgroundMusic();
    }
  }
}
