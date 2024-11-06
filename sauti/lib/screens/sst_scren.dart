import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class STTScreen extends StatefulWidget {
  @override
  _STTScreenState createState() => _STTScreenState();
}

class _STTScreenState extends State<STTScreen> {
  bool isListening = false;
  late stt.SpeechToText _speechToText;
  String text = "Press the button and start speaking";
  double confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speech To Text"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: Colors.blue,
        duration: Duration(milliseconds: 1000),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _captureVoice,
          backgroundColor: Colors.blue,
          child: Icon(
            isListening ? Icons.mic : Icons.mic_none,
            size: 45,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Successfully copied Text"),
                      ),
                    );
                  },
                  child: Text(
                    "Copy",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _captureVoice() async {
    if (!isListening) {
      bool available = await _speechToText.initialize(
        onError: (val) => setState(() {
          text = "Speech recognition error: ${val.errorMsg}";
          isListening = false;
        }),
        onStatus: (val) => print("Status: $val"),
      );
      if (available) {
        setState(() => isListening = true);
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              text = result.recognizedWords;
              if (result.hasConfidenceRating && result.confidence > 0) {
                confidence = result.confidence;
              }
            });
          },
          listenFor: Duration(seconds: 5),
          onDevice: false, // Set to true for on-device recognition
          cancelOnError: true,
          partialResults: false,
        );
      } else {
        setState(() {
          text = "Speech recognition not available.";
          isListening = false;
        });
      }
    } else {
      await _speechToText.stop();
      setState(() => isListening = false);
    }
  }
}















// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// class STTScreen extends StatefulWidget {
//   @override
//   _STTScreenState createState() => _STTScreenState();
// }

// class _STTScreenState extends State<STTScreen> {
//   bool isListening = false;
//   late stt.SpeechToText _speechToText;
//   String text = "Press the button and start Speaking";
//   double confidence = 1.0;
//   @override
//   void initState() {
//     _speechToText = stt.SpeechToText();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Speech To Text",
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: AvatarGlow(
//         animate: isListening,
//         glowColor: Colors.blue,
//         duration: Duration(milliseconds: 1000),
//         repeat: true,
//         child: FloatingActionButton(
//           onPressed: _captureVoice,
//           backgroundColor: Colors.blue,
//           child: Icon(
//             isListening ? Icons.mic : Icons.mic_none,
//             size: 45,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         reverse: true,
//         child: Container(
//           padding: EdgeInsets.all(30),
//           child: Column(
//             children: [
//               Text(
//                 text,
//                 style: TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Center(
//                 child: ElevatedButton(
//                     style:
//                         ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                     onPressed: () {
//                       Clipboard.setData(ClipboardData(text: text));
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text("Successfully copied Text"),
//                       ));
//                     },
//                     child: Text(
//                       "Copy",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     )),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _captureVoice() async {
//     if (!isListening) {
//       bool listen = await _speechToText.initialize();
//       if (listen) {
//         setState(() => isListening = true);
//         _speechToText.listen(
//           onResult: (result) => setState(
//             () {
//               text = result.recognizedWords;
//               if (result.hasConfidenceRating && result.confidence > 0) {
//                 confidence = result.confidence;
//               }
//             },
//           ),
//         );
//       } else {
//         setState(() {
//           _speechToText.stop();
//         });
//       }
//     }
//   }
// }
