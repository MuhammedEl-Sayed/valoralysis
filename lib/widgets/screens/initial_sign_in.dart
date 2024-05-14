import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/api/services/auth_service.dart';
import 'package:valoralysis/consts/images.dart';
import 'package:valoralysis/consts/margins.dart';
import 'package:valoralysis/models/user.dart';
import 'package:valoralysis/providers/navigation_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/pick_random.dart';
import 'package:valoralysis/widgets/ui/flashing_text/flashing_text.dart';
import 'package:valoralysis/widgets/ui/login_search_bar/login_search_bar.dart';

class InitialSignIn extends StatefulWidget {
  const InitialSignIn({Key? key}) : super(key: key);

  @override
  _InitialSignInState createState() => _InitialSignInState();
}

class _InitialSignInState extends State<InitialSignIn> with RouteAware {
  // State variables to manage the error message and visibility
  String errorMessage = '';
  bool showError = false;

  late String randomName;
  late UserProvider userProvider;
  late NavigationProvider navigationProvider;
  // Current user name
  String userName = '';

  @override
  void initState() {
    super.initState();
    randomName = HelperFunctions.pickRandom(signInBackgrounds);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initUserState();
    });
  }

  void _initUserState() async {
    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    await userProvider.init();

    // Check if the user is already signed in, then navigate to the next page
    //TODO: add consent check
    if (userProvider.user.puuid != '') {
      navigationProvider.navigateTo('/home');
    }
  }

  void login(String name) async {
    setState(() {
      errorMessage = '';
      showError = false;
    });

    final gameNameAndTag = userName;
    print(gameNameAndTag);
    String puuid = await AuthService.getUserPUUID(gameNameAndTag);

    // If PUUID is empty, show error
    if (puuid.contains('Error:')) {
      setState(() {
        errorMessage = puuid;
        showError = true;
      });
    } else {
      setState(() {
        errorMessage = '';
        showError = false;
      });
      userProvider.setUser(User(
        name: gameNameAndTag,
        puuid: puuid,
        consentGiven: true,
        matchHistory: userProvider.user.matchHistory,
      ));
      if (mounted) {
        userProvider.updatePuuid(puuid);
        navigationProvider.navigateTo('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double margin = getStandardMargins(context);

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(fit: StackFit.expand, children: [
          Image.asset(
            randomName,
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(0.2),
          ),
          Center(
              widthFactor: 2,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: margin * 2),
                    Image.asset(
                      'assets/images/valoralysis_transparent.png',
                      width: 200,
                    ),
                    BlinkingText(),
                    const Text('Valoralysis', style: TextStyle(fontSize: 45)),
                    const SizedBox(height: 20),
                    if (showError)
                      Container(
                        margin: EdgeInsets.only(
                            left: margin * 2,
                            right: margin * 2,
                            top: margin,
                            bottom: margin),
                        padding: EdgeInsets.all(margin / 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onError,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error,
                                color: Theme.of(context).colorScheme.error),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(errorMessage),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: margin * 2, right: margin * 2),
                        child: LoginSearchBar(
                          onUserNameChanged: (newUserName) {
                            setState(() {
                              userName = newUserName;
                            });
                          },
                          onSearchSubmitted: (newUserName) {
                            login(newUserName);
                          },
                        )),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => login(userName),
                      child: const Text('Sign in with Riot Games'),
                    ),
                    // Display error container if there is an error
                  ],
                ),
              )),
        ]));
  }
}
