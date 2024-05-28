import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_fps/show_fps.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/providers/category_provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/mode_provider.dart';
import 'package:valoralysis/providers/navigation_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/widgets/screens/home.dart';
import 'package:valoralysis/widgets/screens/initial_sign_in.dart';
import 'package:valoralysis/widgets/screens/settings.dart';
import 'package:valoralysis/widgets/ui/navigation_bar/navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final userProvider = UserProvider(prefs);
  final contentProvider = ContentProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => userProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryTypeProvider(),
        ),
        ChangeNotifierProvider(create: (context) => contentProvider),
        ChangeNotifierProvider(create: (context) => ModeProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider())
      ],
      child: const MyApp(),
    ),
  );
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _initProvidersFuture;

  @override
  void initState() {
    super.initState();
    _initProvidersFuture = _initProviders(context);
  }

  Future<void> _initProviders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final contentProvider =
        Provider.of<ContentProvider>(context, listen: false);

    await userProvider.init();
    await contentProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) {
        return FutureBuilder(
          future: _initProvidersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MaterialApp(
                theme: darkTheme,
                home: const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            } else {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorObservers: <RouteObserver<ModalRoute<void>>>[
                  routeObserver
                ],
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
                            key: Provider.of<NavigationProvider>(context,
                                    listen: false)
                                .navigatorKey,
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
                      ),
                    )
                  ],
                ),
                themeMode: ThemeMode.system,
              );
            }
          },
        );
      },
      child: const InitialSignIn(),
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
  void didPush() {
    navigationProvider?.pageName = widget.name;
  }

  @override
  void didPopNext() {}

  @override
  Widget build(BuildContext context) => widget.child;
}
