import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/multiplayer/firebase_multiplayer_service.dart';
import '../../services/multiplayer/profanity_filter.dart';
import '../../l10n/app_localizations.dart';
import 'lobby_screen.dart';
import '../../utils/i18n.dart';
import '../../theme/app_theme.dart';

/// Tela para jogador entrar em uma sala existente
class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final _codeController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isJoining = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _joinRoom() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isJoining = true;
      _errorMessage = null;
    });

    try {
      // Validar nickname
      final validation = ProfanityFilter.validateNickname(_nicknameController.text.trim());
      
      if (!validation.isValid) {
        setState(() {
          _errorMessage = validation.message;
          _isJoining = false;
        });
        
        // Mostrar sugestão se houver
        if (validation.suggestedNickname != null) {
          _showSuggestionDialog(validation.suggestedNickname!);
        }
        return;
      }

      // Gerar ID único para o jogador
      final playerId = await FirebaseMultiplayerService().currentPlayerId();
      
      // Entrar na sala
      await FirebaseMultiplayerService().joinRoom(
        roomCode: _codeController.text.trim(),
        playerId: playerId,
        nickname: _nicknameController.text.trim(),
      );

      if (!mounted) return;

      // Navegar para o lobby
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LobbyScreen(
            roomCode: _codeController.text.trim(),
            playerId: playerId,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isJoining = false;
      });
    }
  }

  void _showSuggestionDialog(String suggestion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF162447),
        title: Text(
          t3('⚠️ Apelido não permitido', '⚠️ Nickname not allowed', '⚠️ Apodo no permitido'),
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t3('Este apelido contém palavras não permitidas.', 'This nickname contains words that are not allowed.', 'Este apodo contiene palabras no permitidas.'),
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16),
            Text(
              t3('Que tal usar:', 'How about:', '¿Qué tal usar:'),
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF23395D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                suggestion,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nicknameController.text = suggestion;
            },
            child: Text(AppLocalizations.of(context)!.multiplayerUseSuggestion, style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.multiplayerChooseAnother, style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF162447),
        title: Row(
          children: [
            Icon(Icons.help_outline, color: Color(0xFF3A5A8C)),
            SizedBox(width: 8),
            Text(l10n.multiplayerHowItWorks, style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t3('1️⃣ Peça o código da sala para o anfitrião', '1️⃣ Ask the host for the room code', '1️⃣ Pide el código de la sala al anfitrión'),
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 12),
            Text(
              t3('2️⃣ Digite o código de 6 dígitos', '2️⃣ Type the 6-digit code', '2️⃣ Escribe el código de 6 dígitos'),
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 12),
            Text(
              t3('3️⃣ Escolha seu apelido', '3️⃣ Choose your nickname', '3️⃣ Elige tu apodo'),
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 12),
            Text(
              t3('4️⃣ Aguarde no lobby até o anfitrião iniciar!', '4️⃣ Wait in the lobby until the host starts!', '4️⃣ ¡Espera en el lobby hasta que el anfitrión empiece!'),
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.multiplayerUnderstood, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) =>
      GameDarkTheme(child: Builder(builder: _buildThemed));

  Widget _buildThemed(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Color(0xFF101A2C),
      appBar: AppBar(
        title: Text(l10n.multiplayerJoinRoom, style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF162447),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
            tooltip: 'Ajuda',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ícone e título
              Icon(Icons.meeting_room, size: 80, color: Color(0xFF3A5A8C)),
              SizedBox(height: 16),
              Text(
                t3('Entre na partida', 'Join the match', 'Únete a la partida'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                t3('Informe o código fornecido pelo anfitrião', 'Enter the code from the host', 'Ingresa el código del anfitrión'),
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),

              // Campo de código da sala
              Text(
                t3('Código da sala', 'Room code', 'Código de la sala'),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _codeController,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '000000',
                  hintStyle: TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: Color(0xFF23395D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.tag, color: Colors.white70),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return t3('Digite o código da sala', 'Type the room code', 'Escribe el código de la sala');
                  }
                  if (value.trim().length != 6) {
                    return t3('O código deve ter 6 dígitos', 'The code must have 6 digits', 'El código debe tener 6 dígitos');
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Campo de apelido
              Text(
                t3('Seu apelido', 'Your nickname', 'Tu apodo'),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _nicknameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: t3('Digite seu apelido', 'Type your nickname', 'Escribe tu apodo'),
                  hintStyle: TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Color(0xFF23395D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.white70),
                ),
                maxLength: 20,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return t3('Digite um apelido', 'Type a nickname', 'Escribe un apodo');
                  }
                  if (value.trim().length < 3) {
                    return t3('Mínimo 3 caracteres', 'At least 3 characters', 'Mínimo 3 caracteres');
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),

              // Mensagem de erro
              if (_errorMessage != null)
                Container(
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade900.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade700),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade300),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade300),
                        ),
                      ),
                    ],
                  ),
                ),

              // Botão entrar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: _isJoining ? null : _joinRoom,
                child: _isJoining
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, size: 24),
                          SizedBox(width: 8),
                          Text(
                            t3('Entrar na Sala', 'Join Room', 'Entrar a la Sala'),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
