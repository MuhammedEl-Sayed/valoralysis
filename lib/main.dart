import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/api/auth_redirect_webview.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/providers/account_data_provider.dart';
import 'package:valoralysis/widgets/screens/initialSignIn.dart';
import 'package:valoralysis/widgets/ui/titleBar/titleBar.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
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
      initialRoute: '/',
      routes: {
        '/': (context) => const PageWithBar(child: InitialSignIn()),
        '/auth': (context) => PageWithBar(child: WebViewPopup()),
      },
    );
  }
}
