import 'package:flutter/material.dart';
import 'dart:async';

class BlinkingText extends StatefulWidget {
  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText>
    with TickerProviderStateMixin {
  List<String> words = [
    "Welcome to",
    "Добро пожаловать в",
    "Welkom bij",
    "Bienvenue à",
    "Willkommen bei",
    "Benvenuti a",
    "Bienvenido a",
    "Bem-vindo ao",
    "Välkommen till",
    "Hoş geldiniz",
    "환영합니다",
    "歡迎來到",
    "ようこそ",
    "欢迎来到",
    "स्वागत है",
    "ยินดีต้อนรับสู่",
    "خوش آمدید به",
    "مرحبًا بك إلا",
  ];
  int currentWordIndex = 0;
  int currentCharIndex = 0;
  bool deleting = true;
  bool pause = false;
  String displayWord = "";
  String cursor = "|";
  Duration pauseDuration = Duration(seconds: 1); // Customize this value

  @override
  void initState() {
    Timer.periodic(Duration(milliseconds: 100), (Timer t) => _animateCursor());
    super.initState();
  }

  void _animateCursor() {
    setState(() {
      cursor = cursor == "|" ? " " : "|";
    });
  }

  void _animateText() {
    if (pause) {
      Future.delayed(pauseDuration, () {
        setState(() {
          pause = false;
        });
      });
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: displayWord,
        style: TextStyle(fontSize: 47, fontFamily: 'valorant'),
        children: <TextSpan>[
          TextSpan(text: cursor, style: TextStyle(fontSize: 45)),
        ],
      ),
    );
  }
}
