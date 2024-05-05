import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:valoralysis/api/auth_redirect_webview.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/mode_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/providers/category_provider.dart'; // Import the CategoryTypeProvider
import 'package:valoralysis/widgets/screens/home.dart';
import 'package:valoralysis/widgets/screens/initial_sign_in.dart';
import 'package:valoralysis/widgets/screens/settings.dart';
import 'package:valoralysis/widgets/ui/title_bar/page_bar_wrappers.dart';
import 'dart:io' show Platform;

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
    return ScreenUtilInit(
      designSize: const Size(1200, 800),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: darkTheme,
          themeMode: ThemeMode.system, // device controls theme
          initialRoute: '/', //
          routes: {
            '/': (context) => const InitialSignIn(),
            '/auth': (context) => WebViewPopup(),
            '/home': (context) => HomeScreen(),
            '/settings': (context) => SettingsScreen(),
          },
        );
      },
      child: const PageWithBar(child: InitialSignIn()),
    );
  }
}
