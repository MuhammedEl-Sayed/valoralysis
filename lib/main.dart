import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/providers/category_provider.dart'; // Import the CategoryTypeProvider
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/mode_provider.dart';
import 'package:valoralysis/providers/navigation_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/widgets/screens/home.dart';
import 'package:valoralysis/widgets/screens/initial_sign_in.dart';
import 'package:valoralysis/widgets/screens/settings.dart';
import 'package:valoralysis/widgets/ui/navigation_bar/navigation_bar.dart';
import 'package:valoralysis/widgets/ui/title_bar/page_bar_wrappers.dart';

void main() async {
  await dotenv.load();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryTypeProvider(),
        ),
        ChangeNotifierProvider(create: (context) => ContentProvider()),
        ChangeNotifierProvider(create: (context) => ModeProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider())
      ],
      child: MyApp(),
    ),
  );
  appWindow.show();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(1200, 800),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [NavigationHistoryObserver()],
          theme: darkTheme,
          home: const InitialSignIn(),
          builder: (context, child) => Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => Scaffold(
                  bottomNavigationBar: const NavBar(),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  body: Navigator(
                    key: navigationProvider.navigatorKey,
                    initialRoute: '/',
                    onGenerateRoute: (RouteSettings settings) {
                      WidgetBuilder builder;

                      switch (settings.name) {
                        case '/':
                          builder =
                              (BuildContext context) => const InitialSignIn();
                          break;
                        case '/home':
                          builder =
                              (BuildContext context) => const HomeScreen();
                          break;
                        case '/settings':
                          builder =
                              (BuildContext context) => const SettingsScreen();
                          break;
                        default:
                          throw Exception('Invalid route: ${settings.name}');
                      }

                      // Update the current page in the navigation provider
                      navigationProvider.currentPage = settings.name;

                      // Call the callback function
                      _navigatorKey.currentState?.context
                          .findAncestorWidgetOfExactType<NavBar>()
                          ?.onRouteChanged(settings.name);

                      return MaterialPageRoute(
                        builder: builder,
                        settings: settings,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          themeMode: ThemeMode.system,
        );
      },
      child: const PageWithBar(child: InitialSignIn()),
    );
  }
}
