import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valoralysis/api/auth_redirect_webview.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/widgets/screens/home.dart';
import 'package:valoralysis/widgets/screens/initial_sign_in.dart';
import 'package:valoralysis/widgets/ui/title_bar/title_bar.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that you have bindings for your app.

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          UserProvider(prefs), // Pass the prefs to your provider.
      child: const MyApp(),
    ),
  );
  appWindow.show();
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1200, 800);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Valoralysis";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // device controls theme
      initialRoute: '/',
      routes: {
        '/': (context) => const PageWithBar(child: InitialSignIn()),
        '/auth': (context) => PageWithBar(child: WebViewPopup()),
        '/home': (context) => PageWithBar(child: HomeScreen()),
      },
    );
  }
}
