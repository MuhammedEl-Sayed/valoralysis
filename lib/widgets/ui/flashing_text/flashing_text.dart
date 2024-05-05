import 'package:flutter/material.dart';
import 'dart:async';

class BlinkingText extends StatefulWidget {
  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText>
    with TickerProviderStateMixin {
  List<String> words = ["Welcome", "Bienvenue", "Willkommen", "أهلا بك"];
  int currentWordIndex = 0;
  int currentCharIndex = 0;
  bool deleting = true;
  bool pause = false;
  String displayWord = "";
  String cursor = "|";
  Timer? cursorTimer;
  Timer? textTimer;

  @override
  void initState() {
    cursorTimer = Timer.periodic(
        const Duration(milliseconds: 100), (Timer t) => _animateCursor());
    textTimer = Timer.periodic(
        const Duration(milliseconds: 150), (Timer t) => _animateText());
    super.initState();
  }

  @override
  void dispose() {
    cursorTimer?.cancel();
    textTimer?.cancel();
    super.dispose();
  }

  void _animateCursor() {
    if (mounted) {
      setState(() {
        cursor = cursor == "|" ? " " : "|";
      });
    }
  }

  void _animateText() {
    if (pause) {
      pause = false;
      return;
    }

    if (mounted) {
      setState(() {
        String currentWord = words[currentWordIndex];
        if (currentCharIndex < 0) {
          displayWord = "";
        } else if (currentCharIndex >= currentWord.length) {
          displayWord = currentWord;
          pause = true;
        } else {
          displayWord = currentWord.substring(0, currentCharIndex);
        }

        if (deleting) {
          currentCharIndex--;
          if (currentCharIndex < 0) {
            deleting = false;
            currentWordIndex = (currentWordIndex + 1) % words.length;
          }
        } else {
          currentCharIndex++;
          if (currentCharIndex > currentWord.length) {
            deleting = true;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: displayWord,
        style: TextStyle(fontSize: 45, fontFamily: 'valorant'),
        children: <TextSpan>[
          TextSpan(text: cursor, style: const TextStyle(fontSize: 45)),
        ],
      ),
    );
  }
}
