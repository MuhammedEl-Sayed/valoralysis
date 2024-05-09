import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/navigation_provider.dart';

class NavBar extends HookWidget {
  final int startIndex;

  const NavBar({Key? key, this.startIndex = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final currIndex = useState<int>(startIndex);

    useEffect(() {
      listener() {
        currIndex.value = navigationProvider.pageName == '/home'
            ? 0
            : navigationProvider.pageName == '/settings'
                ? 2
                : currIndex.value;
      }

      navigationProvider.addListener(listener);
      return () => navigationProvider.removeListener(listener);
    }, [navigationProvider]);

    return navigationProvider.pageName != '/'
        ? NavigationBar(
            onDestinationSelected: (int index) {
              currIndex.value = index;
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
            selectedIndex: currIndex.value,
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
