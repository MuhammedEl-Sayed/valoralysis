import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final int currIndex;
  final PageController pageController;

  const NavBar({Key? key, this.currIndex = 0, required this.pageController})
      : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int? _currIndex;
  @override
  void initState() {
    super.initState();
    _currIndex = widget.currIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              _currIndex = index;
            });
            widget.pageController.jumpToPage(index);
          },
          selectedIndex: _currIndex as int,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stats'),
            NavigationDestination(icon: Icon(Icons.settings), label: 'Settings')
          ],
          elevation: 2,
        );
      },
    );
  }
}
