import 'package:flutter/material.dart';
import '../../services/audio_service.dart';

class SequenceGame extends StatelessWidget {
  const SequenceGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101A2C),
      appBar: AppBar(
        title: const Text("Sequência Rápida", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF162447),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("🎨", style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text("Sequência Rápida", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Em desenvolvimento...", style: TextStyle(fontSize: 16, color: Colors.white70)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                AudioService().playClick();
                Navigator.pop(context);
              },
              child: Text("Voltar"),
            ),
          ],
        ),
      ),
    );
  }
}
