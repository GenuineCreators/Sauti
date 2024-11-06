import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final double volume;
  final double pitch;
  final double rate;

  SettingsPage({
    required this.volume,
    required this.pitch,
    required this.rate,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double _volume;
  late double _pitch;
  late double _rate;

  @override
  void initState() {
    super.initState();
    _volume = widget.volume;
    _pitch = widget.pitch;
    _rate = widget.rate;
  }

  void _saveSettings() {
    Navigator.pop(context, {
      'volume': _volume,
      'pitch': _pitch,
      'rate': _rate,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Volume",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _volume,
              onChanged: (value) {
                setState(() {
                  _volume = value;
                });
              },
              min: 0.0,
              max: 1.0,
            ),
            SizedBox(height: 20),
            Text(
              "Pitch",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _pitch,
              onChanged: (value) {
                setState(() {
                  _pitch = value;
                });
              },
              min: 0.5,
              max: 2.0,
            ),
            SizedBox(height: 20),
            Text(
              "Speech Rate",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _rate,
              onChanged: (value) {
                setState(() {
                  _rate = value;
                });
              },
              min: 0.1,
              max: 1.0,
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Save Settings",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
