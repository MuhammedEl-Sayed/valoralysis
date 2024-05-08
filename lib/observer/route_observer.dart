import 'package:flutter/material.dart';
import 'package:valoralysis/providers/navigation_provider.dart';

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final NavigationProvider navigationProvider;

  MyRouteObserver({required this.navigationProvider});

  void _sendScreenView(PageRoute<dynamic> route) {
    var screenName = route.settings.name;
    // print('screenName $screenName');
    navigationProvider.setScreenName(screenName!);

    // do something with it, ie. send it to your analytics service collector
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    super.didPop(route as Route<dynamic>, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}
