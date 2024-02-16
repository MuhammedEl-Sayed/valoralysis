import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/consts/images.dart';
import 'package:valoralysis/models/user.dart';
import 'package:valoralysis/providers/account_data_provider.dart';
import 'package:valoralysis/utils/pick_random.dart';
import 'package:valoralysis/widgets/ui/flashing_text/flashing_text.dart';

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
      initUserState();
    });
  }

  void initUserState() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final puuids = userProvider.prefs.getStringList('puuids');
    final preferredPUUID = userProvider.prefs.getInt('preferredPUUIDS');
    userProvider.setUser(User(puuid: puuids?[preferredPUUID ?? 0] ?? ''));
    //check if the user is already signed in, then nav to the next page
    print(userProvider.user.puuid);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            HelperFunctions.pickRandom(signInBackgrounds),
            fit: BoxFit.cover,
            // Animation<double>?
            opacity: const AlwaysStoppedAnimation(0.2),
          ),
          Center(
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
                    initUserState();
                  },
                  child: const Text('Sign in with Riot Games'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    userProvider.prefs.clear();
                    userProvider.setUser(User(puuid: ''));
                  },
                  child: const Text('Delete User Data'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
