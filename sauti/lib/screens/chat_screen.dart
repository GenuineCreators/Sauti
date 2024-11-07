import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VideoTextScreen extends StatefulWidget {
  @override
  _VideoTextScreenState createState() => _VideoTextScreenState();
}

class _VideoTextScreenState extends State<VideoTextScreen> {
  VideoPlayerController? _videoController;
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool isListening = false;
  String captionText = "Live captions will appear here";

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _speechToText.stop();
    super.dispose();
  }

  // Request microphone permission
  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
  }

  // Pick a video from the device
  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      _initializeVideoPlayer(result.files.single.path!);
    }
  }

  // Initialize video player with the selected video
  void _initializeVideoPlayer(String videoPath) {
    _videoController = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        setState(() {}); // Refresh to show video player
        _videoController!.play();
        _startCaptions(); // Start captions when video starts
      });

    // Set up listener to automatically stop/start captions
    _videoController!.addListener(() {
      if (_videoController!.value.isPlaying && !isListening) {
        _startCaptions();
      } else if (!_videoController!.value.isPlaying && isListening) {
        _stopCaptions();
      }
    });
  }

  // Start capturing voice for live captions
  void _startCaptions() async {
    bool available = await _speechToText.initialize(
      onError: (val) => setState(() {
        captionText = "Error: ${val.errorMsg}";
        isListening = false;
      }),
      onStatus: (val) => print("Status: $val"),
    );

    if (available) {
      setState(() => isListening = true);
      _speechToText.listen(
        onResult: (result) {
          setState(() {
            captionText = result.recognizedWords;
          });
        },
        listenFor: Duration(minutes: 5), // Adjust duration as needed
        onDevice: true,
        cancelOnError: true,
        partialResults: true,
      );
    } else {
      setState(() {
        captionText = "Speech recognition not available.";
      });
    }
  }

  // Stop capturing voice for live captions
  void _stopCaptions() async {
    await _speechToText.stop();
    setState(() => isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video with Live Captions"),
      ),
      body: Column(
        children: [
          // Video Player
          Expanded(
            flex: 3,
            child: _videoController != null &&
                    _videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : Center(
                    child: Text("Select a video to play"),
                  ),
          ),
          // Captions Display
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.black,
              child: Center(
                child: Text(
                  captionText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickVideo,
        child: Icon(Icons.video_library),
        tooltip: "Pick a video",
      ),
    );
  }
}



















// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// class VideoTextScreen extends StatefulWidget {
//   @override
//   _VideoTextScreenState createState() => _VideoTextScreenState();
// }

// class _VideoTextScreenState extends State<VideoTextScreen> {
//   VideoPlayerController? _videoController;
//   stt.SpeechToText _speechToText = stt.SpeechToText();
//   bool isListening = false;
//   String captionText = "Live captions will appear here";

//   @override
//   void initState() {
//     super.initState();
//     _requestPermissions();
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     _speechToText.stop();
//     super.dispose();
//   }

//   // Request microphone permission
//   Future<void> _requestPermissions() async {
//     await Permission.microphone.request();
//   }

//   // Pick a video from the device
//   Future<void> _pickVideo() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.video,
//     );

//     if (result != null) {
//       _initializeVideoPlayer(result.files.single.path!);
//     }
//   }

//   // Initialize video player with the selected video
//   void _initializeVideoPlayer(String videoPath) {
//     _videoController = VideoPlayerController.file(File(videoPath))
//       ..initialize().then((_) {
//         setState(() {}); // Refresh to show video player
//         _videoController!.play();
//       });
//   }

//   // Capture voice for live captions
//   void _captureLiveCaptions() async {
//     if (!isListening) {
//       bool available = await _speechToText.initialize(
//         onError: (val) => setState(() {
//           captionText = "Error: ${val.errorMsg}";
//           isListening = false;
//         }),
//         onStatus: (val) => print("Status: $val"),
//       );
//       if (available) {
//         setState(() => isListening = true);
//         _speechToText.listen(
//           onResult: (result) {
//             setState(() {
//               captionText = result.recognizedWords;
//             });
//           },
//           listenFor: Duration(minutes: 5), // Adjust duration as needed
//           onDevice: false,
//           cancelOnError: true,
//           partialResults: true,
//         );
//       }
//     } else {
//       await _speechToText.stop();
//       setState(() => isListening = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Video with Live Captions"),
//       ),
//       body: Column(
//         children: [
//           // Video Player
//           Expanded(
//             flex: 3,
//             child: _videoController != null &&
//                     _videoController!.value.isInitialized
//                 ? AspectRatio(
//                     aspectRatio: _videoController!.value.aspectRatio,
//                     child: VideoPlayer(_videoController!),
//                   )
//                 : Center(
//                     child: Text("Select a video to play"),
//                   ),
//           ),
//           // Captions Display
//           Expanded(
//             flex: 1,
//             child: Container(
//               padding: EdgeInsets.all(10),
//               color: Colors.black,
//               child: Center(
//                 child: Text(
//                   captionText,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             onPressed: _pickVideo,
//             child: Icon(Icons.video_library),
//             tooltip: "Pick a video",
//           ),
//           SizedBox(height: 15),
//           FloatingActionButton(
//             onPressed: _captureLiveCaptions,
//             child: Icon(isListening ? Icons.mic : Icons.mic_none),
//             backgroundColor: isListening ? Colors.red : Colors.blue,
//             tooltip: "Start/Stop Captions",
//           ),
//         ],
//       ),
//     );
//   }
// }
