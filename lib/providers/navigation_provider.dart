import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String _pageName = '/';

  String get pageName => _pageName;

  set pageName(String name) {
    _pageName = name;
    notifyListeners();
  }

  Future<void> navigateTo(String routeName) {
    pageName = routeName;
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
