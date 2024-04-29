import 'package:flutter/material.dart';

class ScreenWrapper extends StatelessWidget {
  final Widget child;

  ScreenWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    double margin = MediaQuery.of(context).size.width * 0.05;
    return Padding(
      padding: EdgeInsets.only(left: margin, right: margin),
      child: child,
    );
  }
}
