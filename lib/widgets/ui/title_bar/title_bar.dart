import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:valoralysis/widgets/ui/sidebar/sidebar.dart';
import 'package:valoralysis/widgets/ui/title_bar/windows_buttons.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: WindowTitleBarBox(
        child: Row(
          children: [Expanded(child: MoveWindow()), const WindowButtons()],
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
          child: child,
        ))
      ],
    );
  }
}

class PageWithSidebar extends StatelessWidget {
  final Widget child;

  const PageWithSidebar({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          child: Expanded(
              child: Container(
            child: child,
          )),
          padding: EdgeInsets.only(left: 75),
        ),
        const TitleBar(),
        Sidebar(),
      ],
    );
  }
}

class Page