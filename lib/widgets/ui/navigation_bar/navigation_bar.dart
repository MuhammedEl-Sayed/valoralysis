import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  final int currIndex;

  const NavBar({
    Key? key,
    this.currIndex = 0,
  }) : super(key: key);

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
    PageController pageController =
        Provider.of<PageController>(context, listen: true);
    return Builder(
      builder: (BuildContext context) {
        return (pageController.hasClients && pageController.page!.round() != 0)
            ? NavigationBar(
                onDestinationSelected: (int index) {
                  setState(() {
                    _currIndex = index;
                  });
                  pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                selectedIndex: _currIndex as int,
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                  NavigationDestination(
                      icon: Icon(Icons.bar_chart), label: 'Stats'),
                  NavigationDestination(
                      icon: Icon(Icons.settings), label: 'Settings')
                ],
                elevation: 2,
              )
            : const SizedBox.shrink();
      },
    );
  }
}
