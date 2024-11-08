import 'package:flutter/material.dart';
import 'package:sauti/screens/chat_screen.dart';
import 'package:sauti/screens/sst_scren.dart';
import 'package:sauti/screens/tts_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SAUTI',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Adding a space between the rows
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildContainer(context, 'assets/video.png', 'Video Caption',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoTextScreen()),
                    );
                  }),
                  buildContainer(
                      context, 'assets/sign_language.jpg', 'Sign Language', () {
                    print('Sign Language clicked!');
                  }),
                ],
              ),
              SizedBox(height: 16), // Space between rows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildContainer(
                      context, 'assets/text_to_speech.jpg', 'Text To Speech',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TTSScreen()),
                    );
                  }),
                  buildContainer(
                      context, 'assets/speech_to_text.jpg', 'Speech to Text',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => STTScreen()),
                    );
                  }),
                ],
              ),
              SizedBox(height: 16), // Space between rows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildContainer(context, 'assets/video_call.jpg', 'Video Call',
                      () {
                    print('Video Call clicked!');
                  }),
                  buildContainer(context, 'assets/emergency_assistance.jpg',
                      'Emergency Assistance', () {
                    print('Emergency Assistance clicked!');
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContainer(
      BuildContext context, String imagePath, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the container
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Shadow color
              offset: Offset(0, 2), // Shadow position
              blurRadius: 8, // How blurred the shadow will be
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover, // Ensure the image covers the container
              ),
            ),
            SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
