// settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SettingsForm(),
    );
  }
}

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  int _voiceVolume = 10; // Default voice volume
  int _listeningDuration = 5; // Default listening duration in seconds

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Slider(
            label: 'Voice Volume',
            value: _voiceVolume.toDouble(),
            min:1,
            max: 100,
            onChanged: (value) {
              setState(() {
                _voiceVolume = value.toInt();
              });
            },
          ),
          Text('Voice Volume: $_voiceVolume'),
          SizedBox(height: 20),
          Slider(
            label: 'Listening Duration',
            value: _listeningDuration.toDouble(),
            min: 1,
            max: 20,
            onChanged: (value) {
              setState(() {
                _listeningDuration = value.toInt();
              });
            },
          ),
          Text('Listening Duration: $_listeningDuration seconds'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Save settings and pop the settings screen
              Navigator.pop(context, {
                'voiceVolume': _voiceVolume,
                'listeningDuration': _listeningDuration,
              });
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
