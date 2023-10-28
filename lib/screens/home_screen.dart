import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'settings_screen.dart'; // Import the settings screen file

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  final FocusNode _textFocusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  List<Widget> chatMessages = [];

  int _voiceVolume = 10; // Default voice volume
  int _listeningDuration = 5; // Default listening duration in seconds

  @override
  void initState() {
    super.initState();
    _initializeSpeechToText();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestTextFocus();
    });
  }

  void _initializeSpeechToText() async {
    if (!_speech.isAvailable) {
      await _speech.initialize();
    }
  }

  void requestTextFocus() {
    _textFocusNode.requestFocus();
  }

  void _openSettings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );

    // Handle the result from the settings screen
    if (result != null) {
      // Apply the settings
      setState(() {
        _voiceVolume = result['voiceVolume'] ?? _voiceVolume;
        _listeningDuration = result['listeningDuration'] ?? _listeningDuration;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Talk!"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: chatMessages,
              ),
            ),
            _buildChatInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textEditingController,
              focusNode: _textFocusNode,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (String message) {
                // Handle Enter key press here
                sendMessage(message, true);
                textEditingController.clear(); // Clear the text input
                Future.delayed(Duration(milliseconds: 100), () {
                  _textFocusNode.requestFocus(); // Request focus after a short delay
                });
              },
            ),
          ),
          Tooltip(
            message: 'Start Listening',
            child: IconButton(
              icon: Icon(Icons.mic),
              onPressed: startRecording,
            ),
          ),
          Tooltip(
            message: 'Send Message',
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                String message = textEditingController.text.trim();
                sendMessage(message, true);
                textEditingController.clear(); // Clear the text input
              },
            ),
          ),
          Tooltip(
            message: 'Refresh Conversation',
            child: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                // Reset chatMessages when the refresh button is clicked
                setState(() {
                  chatMessages = [];
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void startRecording() {
    if (!_speech.isListening) {
      _speech.listen(
        onResult: (result) {
          List<Widget> updatedChatMessages = List.from(chatMessages); // Create a copy
          String message = result.recognizedWords ?? '';

          // Check if the recognition is complete
          if (result.finalResult) {
            updatedChatMessages.add(
              _buildChatBubble(message, false),
            );
            setState(() {
              chatMessages = updatedChatMessages; // Update the state with the new list
              _textFocusNode.requestFocus(); 
            });
          }
        },
        listenFor: Duration(seconds: _listeningDuration),
      );
    }
  }

  void sendMessage(String message, bool isUser) async {
    if (message.isNotEmpty) {
      List<Widget> updatedChatMessages = List.from(chatMessages); // Create a copy

      updatedChatMessages.add(
        _buildChatBubble(message, isUser),
      );
      await speakText(message);
      setState(() {
        chatMessages = updatedChatMessages; // Update the state with the new list
      });
    }
  }

  Widget _buildChatBubble(String message, bool isUser) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: 200.0,
            ),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isUser ? Colors.blue : Colors.green,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 5), // Adjust as needed for spacing between messages
        ],
      ),
    );
  }

  Future<void> speakText(String text) async {
    await flutterTts.setVolume(_voiceVolume.toDouble()); // Set the volume
    await flutterTts.speak(text);
  }
}