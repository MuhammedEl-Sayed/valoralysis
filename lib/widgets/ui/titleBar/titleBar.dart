import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:valoralysis/widgets/ui/titleBar/windowsButtons.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Row(
        children: [Expanded(child: MoveWindow()), const WindowButtons()],
      ),
    );
  }
}

class PageWithBar extends StatelessWidget {
  final Widget child;

  const PageWithBar({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TitleBar(),
        Expanded(child: child),
      ],
    );
  }
}
