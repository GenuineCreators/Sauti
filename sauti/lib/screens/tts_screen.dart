import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sauti/extraPages/setting_screen.dart';

class TTSScreen extends StatefulWidget {
  @override
  _TTSScreenState createState() => _TTSScreenState();
}

class _TTSScreenState extends State<TTSScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textController = TextEditingController();

  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  Future<void> _speak() async {
    if (textController.text.isNotEmpty) {
      await flutterTts.setVolume(volume);
      await flutterTts.setPitch(pitch);
      await flutterTts.setSpeechRate(rate);
      await flutterTts.speak(textController.text);
    }
  }

  void _openSettings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          volume: volume,
          pitch: pitch,
          rate: rate,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        volume = result['volume'];
        pitch = result['pitch'];
        rate = result['rate'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text To Speech"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              minLines: 4,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Enter text to convert to speech...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _speak,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Convert to Speech",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
