import 'package:flutter/material.dart';
import 'package:valoralysis/widgets/ui/sidebar/sidebar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorScheme.dark().background,
      body: Row(children: [
        Sidebar(),
      ]),
    );
  }
}
