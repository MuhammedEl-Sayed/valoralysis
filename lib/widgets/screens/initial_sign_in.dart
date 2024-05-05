import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/api/services/auth_service.dart';
import 'package:valoralysis/consts/images.dart';
import 'package:valoralysis/consts/margins.dart';
import 'package:valoralysis/models/user.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/pick_random.dart';
import 'package:valoralysis/widgets/ui/flashing_text/flashing_text.dart';

class InitialSignIn extends StatefulWidget {
  const InitialSignIn({Key? key}) : super(key: key);

  @override
  _InitialSignInState createState() => _InitialSignInState();
}

class _InitialSignInState extends State<InitialSignIn> {
  // State variables to manage the error message and visibility
  String errorMessage = '';
  bool showError = false;

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
    // We are setting this to true for now, but we will change this to false when we have RSO.
    final consentGiven = userPrefs.getBool('consentGiven') ?? true;

    // We are using -1 to say they logged out but don't want to remove their data
    if (preferredPUUID == -1) {
      userProvider.resetUser();
    } else {
      userProvider.setUser(User(
          puuid: puuids?[preferredPUUID ?? 0] ?? '',
          //  puuid:
          //    'MYpcGOQYqOY7ZJQN58_9Tz2anqwxVXbETFUEK1LqDWxZ43_VQfUFXR1RCl-u9dsF33ufL6EMgJu65w',
          consentGiven: true,
          name: "Wwew"));
    }

    // Check if the user is already signed in, then navigate to the next page
    if (userProvider.user.puuid != '' && userProvider.user.consentGiven) {
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    double margin = getStandardMargins(context) * 3;
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(fit: StackFit.expand, children: [
          Image.asset(
            HelperFunctions.pickRandom(signInBackgrounds),
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(0.2),
          ),
          Center(
            widthFactor: 2,
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
                    margin: EdgeInsets.all(margin / 4),
                    padding: EdgeInsets.all(margin / 4),
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
                  padding: EdgeInsets.only(left: margin, right: margin),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your Name#Tagline',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () async {
                    // Reset error state
                    setState(() {
                      errorMessage = '';
                      showError = false;
                    });

                    final gameNameAndTag = controller.text;
                    String puuid =
                        await AuthService.getUserPUUID(gameNameAndTag);

                    // If PUUID is empty, show error
                    if (puuid.isEmpty) {
                      setState(() {
                        errorMessage =
                            'Could not find the specified Name#Tagline. Please try again.';
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
                      ));
                      if (mounted) {
                        Navigator.of(context).pushNamed('/home');
                      }
                    }
                  },
                  child: const Text('Sign in with Riot Games'),
                ),
                // Display error container if there is an error
              ],
            ),
          ),
        ]));
  }
}
