import 'package:flutter/material.dart';

class SidebarIcons extends StatefulWidget {
  @override
  _SidebarIconsState createState() => _SidebarIconsState();
}

class _SidebarIconsState extends State<SidebarIcons> {
  String _selectedIcon = 'home';
  double _top = -0.2;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: _top - 4.3,
          left: -3.5,
          child: Icon(
            Icons.circle,
            color: Theme.of(context).colorScheme.primary.withAlpha(100),
            size: 64,
          )),
      Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        IconButton(
          icon: const Icon(Icons.home),
          iconSize: 40,
          onPressed: () {
            setState(() {
              _selectedIcon = 'home';
              _top = -0.2;
            });
          },
          color: _selectedIcon == 'home'
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        ),
        SizedBox(height: 30),
        IconButton(
          icon: Icon(Icons.map),
          iconSize: 40,
          onPressed: () {
            setState(() {
              _selectedIcon = 'settings';
              _top = 86;
            });
          },
          color: _selectedIcon == 'settings'
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        ),
        SizedBox(height: 30),
        IconButton(
          icon: const ImageIcon(
            AssetImage('assets/images/misc/Vector.png'),
            size: 38,
          ),
          color: _selectedIcon == 'logout'
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
          onPressed: () {
            setState(() {
              _selectedIcon = 'logout';
              _top = 172;
            });
          },
        ),
        SizedBox(height: 30),
      ])
    ]);
  }
}
