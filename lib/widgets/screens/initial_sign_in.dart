import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/api/services/auth_service.dart';
import 'package:valoralysis/consts/images.dart';
import 'package:valoralysis/models/auth_info.dart';
import 'package:valoralysis/models/user.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/cookies.dart';
import 'package:valoralysis/utils/pick_random.dart';
import 'package:valoralysis/widgets/ui/flashing_text/flashing_text.dart';
import 'package:valoralysis/widgets/ui/sidebar/sidebar.dart';

class InitialSignIn extends StatefulWidget {
  const InitialSignIn({Key? key}) : super(key: key);

  @override
  _InitialSignInState createState() => _InitialSignInState();
}

class _InitialSignInState extends State<InitialSignIn> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initUserState();
    });
  }

  void _initUserState() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userPrefs = userProvider.prefs;
    final puuids = userPrefs.getStringList('puuids');
    final preferredPUUID = userPrefs.getInt('preferredPUUIDS');
    String accessToken = userPrefs.getString('accessToken') ?? '';
    String entitlementToken = userPrefs.getString('entitlementToken') ?? '';
    final cookies =
        CookieUtils.getCookiesFromString(userPrefs.getString('cookies') ?? '');
    // We are using -1 to say they logged out but don't want to remove their data
    if (preferredPUUID == -1) {
      userProvider.resetUser();
    }

    userProvider.setUser(User(
        puuid: puuids?[preferredPUUID ?? 0] ?? '',
        authInfo: AuthInfo(
            cookies: cookies,
            accessToken: accessToken ?? '',
            entitlementToken: entitlementToken ?? '')));
    // Now I want to see if their tokens are expired and update them if so.
    // The way im doing this should refetch them if they didn't have them for whatever reason
    // as well.
    print(entitlementToken);
    final accessTokenExpired = JwtDecoder.isExpired(accessToken ?? '');

    if (accessTokenExpired && cookies.isNotEmpty) {
      accessToken = await AuthService.refreshToken(cookies);
      entitlementToken = await AuthService.fetchEntitlementToken(accessToken);
      userProvider.updateAccessToken(accessToken ?? '');
      userProvider.updateEntitlementToken(entitlementToken ?? '');
    }

    // Check if the user is already signed in, then nav to the next page
    if (userProvider.user.puuid != '' &&
        accessToken.isNotEmpty &&
        entitlementToken.isNotEmpty) {
      Navigator.pushNamed(context, '/home');
    }
    print(userProvider.user.puuid);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(fit: StackFit.expand, children: [
          Image.asset(
            HelperFunctions.pickRandom(signInBackgrounds),
            fit: BoxFit.cover,
            // Animation<double>?
            opacity: const AlwaysStoppedAnimation(0.2),
          ),
          Center(
            widthFactor: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/valoralysis_transparent.png',
                  width: 200,
                ),
                BlinkingText(),
                const Text('Valoralysis', style: TextStyle(fontSize: 45)),
                const SizedBox(
                  height: 20,
                ),
                FilledButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/auth');
                    // Perform action when you come back to this page
                    // For example, you can call initUserState() again
                    _initUserState();
                  },
                  child: const Text('Sign in with Riot Games'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    userProvider.prefs.clear();
                    userProvider.setUser(User(
                        puuid: '',
                        authInfo: AuthInfo(
                          cookies: [],
                          entitlementToken: '',
                          accessToken: '',
                        )));
                  },
                  child: const Text('Delete User Data'),
                ),
              ],
            ),
          ),
        ]));
  }
}
