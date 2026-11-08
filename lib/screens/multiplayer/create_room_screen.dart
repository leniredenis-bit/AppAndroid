import 'package:flutter/material.dart';
import '../../services/multiplayer/firebase_multiplayer_service.dart';
import '../../services/multiplayer/profanity_filter.dart';
import '../../l10n/app_localizations.dart';
import 'lobby_screen.dart';
import '../../utils/i18n.dart';
import '../../theme/app_theme.dart';

/// Tela para o anfitrião criar uma nova sala multiplayer
class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _nicknameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  int _totalQuestions = 10;
  int _maxPlayers = 20; // Capacidade padrão da sala
  // Nota: roundTimeLimit não é mais usado - o tempo é calculado dinamicamente
  // baseado no tamanho da pergunta (palavras / 3) + 20 segundos
  bool _isCreating = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _createRoom() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCreating = true;
      _errorMessage = null;
    });

    try {
      // Validar nickname
      final validation = ProfanityFilter.validateNickname(_nicknameController.text.trim());
      
      if (!validation.isValid) {
        setState(() {
          _errorMessage = validation.message;
          _isCreating = false;
        });
        
        // Mostrar sugestão se houver
        if (validation.suggestedNickname != null) {
          _showSuggestionDialog(validation.suggestedNickname!);
        }
        return;
      }

      // Gerar ID único para o host
      final hostId = await FirebaseMultiplayerService().currentPlayerId();
      
      // Criar sala (roundTimeLimit será ignorado - tempo é calculado dinamicamente)
      final room = await FirebaseMultiplayerService().createRoom(
        hostId: hostId,
        hostNickname: _nicknameController.text.trim(),
        totalQuestions: _totalQuestions,
        roundTimeLimit: 20, // Valor padrão ignorado - tempo é dinâmico
        maxPlayers: _maxPlayers,
      );

      if (!mounted) return;

      // Navegar para o lobby
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LobbyScreen(
            roomCode: room.id,
            playerId: hostId,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = t3('Erro ao criar sala: $e', 'Could not create the room: $e', 'No se pudo crear la sala: $e');
        _isCreating = false;
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

  @override
  Widget build(BuildContext context) =>
      GameDarkTheme(child: Builder(builder: _buildThemed));

  Widget _buildThemed(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Color(0xFF101A2C),
      appBar: AppBar(
        title: Text(l10n.multiplayerCreateRoom, style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF162447),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ícone e título
              Icon(Icons.add_circle_outline, size: 80, color: Color(0xFF3A5A8C)),
              SizedBox(height: 16),
              Text(
                t3('Configure sua sala', 'Set up your room', 'Configura tu sala'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                t3('Você será o anfitrião da partida', 'You will host the match', 'Serás el anfitrión de la partida'),
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),

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
              SizedBox(height: 24),

              // Número de perguntas
              Text(
                t3('Número de perguntas', 'Number of questions', 'Número de preguntas'),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF23395D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline, color: Colors.white),
                      onPressed: () {
                        if (_totalQuestions > 5) {
                          setState(() => _totalQuestions -= 5);
                        }
                      },
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          t3('$_totalQuestions perguntas', '$_totalQuestions questions', '$_totalQuestions preguntas'),
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline, color: Colors.white),
                      onPressed: () {
                        if (_totalQuestions < 30) {
                          setState(() => _totalQuestions += 5);
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Capacidade da sala
              Text(
                t3('Capacidade da sala', 'Room capacity', 'Capacidad de la sala'),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF23395D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline, color: Colors.white),
                      onPressed: () {
                        if (_maxPlayers > 2) {
                          setState(() => _maxPlayers -= (_maxPlayers > 20 ? 10 : 2));
                        }
                      },
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          t3('$_maxPlayers jogadores', '$_maxPlayers players', '$_maxPlayers jugadores'),
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline, color: Colors.white),
                      onPressed: () {
                        if (_maxPlayers < 100) {
                          setState(() => _maxPlayers += (_maxPlayers >= 20 ? 10 : 2));
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // Informação sobre tempo automático
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF23395D).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF3A5A8C)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t3('O tempo de cada pergunta é calculado automaticamente baseado no tamanho do texto', 'Each question timer is calculated from the length of the text', 'El tiempo de cada pregunta se calcula según la longitud del texto'),
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
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

              // Botão criar sala
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3A5A8C),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: _isCreating ? null : _createRoom,
                child: _isCreating
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
                          Icon(Icons.add_circle, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Criar Sala',
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
