import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valoralysis/api/auth_redirect_webview.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/providers/category_provider.dart'; // Import the CategoryTypeProvider
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/mode_provider.dart';
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
        ChangeNotifierProvider(create: (context) => ModeProvider())
      ],
      child: const MyApp(),
    ),
  );
  appWindow.show();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();
    return ScreenUtilInit(
      designSize: const Size(1200, 800),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: darkTheme,
          navigatorKey: navigator, // Assign the navigator key here

          builder: (context, child) => Overlay(
            initialEntries: [
              OverlayEntry(
                builder: (context) => Scaffold(
                  bottomNavigationBar: NavBar(navigator: navigator),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  body: child,
                ),
              ),
            ],
          ),
          themeMode: ThemeMode.system, // device controls theme
          initialRoute: '/', //
          routes: {
            '/': (context) => const InitialSignIn(),
            '/auth': (context) => WebViewPopup(),
            '/home': (context) => const HomeScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
        );
      },
      child: const PageWithBar(child: InitialSignIn()),
    );
  }
}
