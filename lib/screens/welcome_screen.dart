import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onStartConversation;
  final BuildContext context;

  WelcomeScreen({
    required this.onStartConversation,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to Mute Communication App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to Mute Communication App",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onStartConversation();
              },
              child: Text("Start Conversation"),
            ),
          ],
        ),
      ),
    );
  }
}

