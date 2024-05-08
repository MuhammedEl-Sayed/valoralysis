import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/navigation_provider.dart';

class NavBar extends StatefulWidget {
  final int currIndex;
  final ValueChanged<String> onRouteChanged;

  const NavBar({Key? key, this.currIndex = 0, required this.onRouteChanged}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int? _currIndex;
  String? pageName;

  @override
  void initState() {
    super.initState();
    _currIndex = widget.currIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        pageName = ModalRoute.of(context)?.settings.name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String pageName =
    return pageName != '/'
        ? NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                _currIndex = index;
              });
              switch (index) {
                case 0:
                  navigationProvider.navigateTo('/home');
                  break;
                case 1:
                  navigationProvider.navigateTo('/home');
                  break;
                case 2:
                  navigationProvider.navigateTo('/settings');
                  break;
              }
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
  }
}
