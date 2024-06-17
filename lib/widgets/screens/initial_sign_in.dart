import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
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
  // State variables
  String errorMessage = '';
  bool showError = false;
  late String randomName;
  late UserProvider userProvider;
  late NavigationProvider navigationProvider;
  String userName = '';

  @override
  void initState() {
    super.initState();
    randomName = HelperFunctions.pickRandom(signInBackgrounds);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    print('rebuilt');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkIfUserLoggedIn();
    });
  }

  Future<void> _checkIfUserLoggedIn() async {
    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    print(userProvider.user.puuid);
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

    if (puuid.contains('Error:')) {
      print('error');
      setState(() {
        errorMessage =
            'Error: Problem fetching user data. Please try again. Make sure you entered the correct name and tag, in the format "name#tagline';
        showError = true;
      });
    } else {
      print('no error');
      setState(() {
        errorMessage = '';
        showError = false;
      });
      //check userProvider.users for existing user if exists, set that user as current user
      if (userProvider.users.isNotEmpty) {
        for (var user in userProvider.users) {
          if (user.puuid == puuid) {
            userProvider.setUser(user);
            navigationProvider.navigateTo('/home');
            return;
          }
        }
      }
      userProvider.setUser(User(
        name: gameNameAndTag,
        puuid: puuid,
        consentGiven: true,
        matchDetailsMap: userProvider.user.matchDetailsMap,
      ));
      print('nav');
      userProvider.updatePuuid(puuid);
      navigationProvider.navigateTo('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    double margin = getStandardMargins(context);
    final upgrader = Upgrader(
        storeController: UpgraderStoreController(
            onAndroid: () => UpgraderAppcastStore(
                appcastURL:
                    'https://raw.githubusercontent.com/MuhammedEl-Sayed/valoralysis/main/appcast.xml'),
            oniOS: () => UpgraderAppcastStore(
                appcastURL:
                    'https://raw.githubusercontent.com/MuhammedEl-Sayed/valoralysis/main/appcast.xml')));
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: UpgradeAlert(
          upgrader: upgrader,
          child: Stack(fit: StackFit.expand, children: [
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
                      padding:
                          EdgeInsets.only(left: margin * 2, right: margin * 2),
                      child: LoginSearchBar(
                        onUserNameChanged: (newUserName) {
                          setState(() {
                            userName = newUserName;
                          });
                        },
                        onSearchSubmitted: (newUserName) {
                          login(newUserName);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => login(userName),
                      child: const Text('Search for player'),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}
