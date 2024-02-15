import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:valoralysis/widgets/ui/title_bar/windowsButtons.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context)
          .scaffoldBackgroundColor, // Set the background color here
      child: WindowTitleBarBox(
        child: Row(
          children: [
            Expanded(
                child: MoveWindow(
                    child: Container(
                        child: Image.asset(
                            'assets/images/logo/Square44x44Logo.targetsize-32.png'),
                        padding: const EdgeInsets.only(left: 10, top: 10)))),
            const WindowButtons()
          ],
        ),
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
        Expanded(
            child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: child,
        ))
      ],
    );
  }
}
