// Don't forget to make the changes mentioned in
// https://github.com/bitsdojo/bitsdojo_window#getting-started

import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/widgets/ui/titleBar/titleBar.dart';

void main() {
  appWindow.size = const Size(600, 450);
  runApp(const MyApp());
  appWindow.show();
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(600, 450);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Custom window with Flutter";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: Scaffold(
        body: Column(children: [
          const TitleBar(),
          TextButton(
              onPressed: () => print("Clicked!"),
              child: const Text("Sign in with Riot Games"))
        ]),
      ),
    );
  }
}
