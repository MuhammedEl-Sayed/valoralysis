import 'package:flutter/material.dart';
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

  // Declare the TextEditingController here
  late TextEditingController controller;
  late String randomName;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    randomName = HelperFunctions.pickRandom(signInBackgrounds);
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
    final pageController = Provider.of<PageController>(context, listen: false);

    // We are using -1 to say they logged out but don't want to remove their data
    if (preferredPUUID == -1) {
      userProvider.resetUser();
    } else {
      userProvider.setUser(User(
          puuid: puuids?[preferredPUUID ?? 0] ?? '',
          //  puuid:
          //    'MYpcGOQYqOY7ZJQN58_9Tz2anqwxVXbETFUEK1LqDWxZ43_VQfUFXR1RCl-u9dsF33ufL6EMgJu65w',
          consentGiven: true,
          name: "Wwew",
          matchHistory: {}));
    }

    // Check if the user is already signed in, then navigate to the next page
    if (userProvider.user.puuid != '' && userProvider.user.consentGiven) {
      pageController.animateToPage(2,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    double margin = getStandardMargins(context);
    final userProvider = Provider.of<UserProvider>(context);
    final pageController = Provider.of<PageController>(context, listen: true);
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
                      padding:
                          EdgeInsets.only(left: margin * 2, right: margin * 2),
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
                                'Could not find the specified user. Please try again.';
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
                            pageController.animateToPage(2,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          }
                        }
                      },
                      child: const Text('Sign in with Riot Games'),
                    ),
                    // Display error container if there is an error
                  ],
                ),
              )),
        ]));
  }
}
