import 'package:flutter/material.dart';
import '../../components/atoms/text.dart' as dk;
import '../../components/atoms/text_button.dart' as dk;

class TextTestScreen extends StatelessWidget {
  const TextTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const dk.Text(
              text: "Welcome to HDFC Bank",
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 243, 117, 33),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            dk.TextButton(
              text: "Continue",
              color: Colors.red,
              onPressed: () {
                debugPrint("Text Button Clicked");
              },
            ),
          ],
        ),
      ),
    );
  }
}
