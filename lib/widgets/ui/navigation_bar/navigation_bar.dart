import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        print(currIndex);
        print(index);
        if (currIndex == index) return; // Add this line
        setState(() {
          currIndex = index;
        });
        if (index == 0) {
          Navigator.of(context).pushNamed('/home');
        }
        if (index == 2) {
          Navigator.of(context).pushNamed('/settings');
        }
      },
      selectedIndex: currIndex,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stats'),
        NavigationDestination(icon: Icon(Icons.settings), label: 'Settings')
      ],
      elevation: 2,
    );
  }
}
