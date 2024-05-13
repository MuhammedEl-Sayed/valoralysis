import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_fps/show_fps.dart';
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
  UserProvider userProvider = UserProvider(prefs);
  await userProvider.init();
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
      child: const MyApp(),
    ),
  );
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(1200, 800),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: <RouteObserver<ModalRoute<void>>>[routeObserver],
          theme: darkTheme,
          home: const InitialSignIn(),
          builder: (context, child) => Overlay(
            initialEntries: [
              OverlayEntry(
                  builder: (context) => ShowFPS(
                        child: Scaffold(
                          bottomNavigationBar: const NavBar(),
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          body: Navigator(
                            key: navigationProvider.navigatorKey,
                            initialRoute: '/',
                            onGenerateRoute: (RouteSettings settings) {
                              WidgetBuilder builder;

                              switch (settings.name) {
                                case '/':
                                  builder = (BuildContext context) =>
                                      const RouteAwareWidget(
                                        name: '/',
                                        child: InitialSignIn(),
                                      );
                                  break;
                                case '/home':
                                  builder = (BuildContext context) =>
                                      const RouteAwareWidget(
                                        name: '/home',
                                        child: HomeScreen(),
                                      );
                                  break;
                                case '/settings':
                                  builder = (BuildContext context) =>
                                      const RouteAwareWidget(
                                        name: '/settings',
                                        child: SettingsScreen(),
                                      );
                                  break;
                                default:
                                  throw Exception(
                                      'Invalid route: ${settings.name}');
                              }

                              return MaterialPageRoute(
                                builder: builder,
                                settings: settings,
                              );
                            },
                          ),
                        ),
                      ))
            ],
          ),
          themeMode: ThemeMode.system,
        );
      },
      child: const PageWithBar(child: InitialSignIn()),
    );
  }
}

class RouteAwareWidget extends StatefulWidget {
  final String name;
  final Widget child;

  const RouteAwareWidget({required this.name, super.key, required this.child});

  @override
  State<RouteAwareWidget> createState() => RouteAwareWidgetState();
}

class RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  NavigationProvider? navigationProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
    navigationProvider = Provider.of<NavigationProvider>(context);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  // Called when the current route has been pushed.
  void didPush() {
    navigationProvider?.pageName = widget.name;
  }

  @override
  // Called when the top route has been popped off, and the current route shows up.
  void didPopNext() {}

  @override
  Widget build(BuildContext context) => widget.child;
}
