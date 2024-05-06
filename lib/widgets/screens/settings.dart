import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:valoralysis/providers/user_data_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = Provider.of<PageController>(context, listen: false);

    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return SafeArea(
          child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SettingsList(
          darkTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).colorScheme.background,
            settingsSectionBackground: Theme.of(context).canvasColor,
          ),
          sections: [
            SettingsSection(
              tiles: <SettingsTile>[
                SettingsTile(
                  onPressed: (context) =>
                      (userProvider.logout(context, pageController)),
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign out'),
                ),
              ],
            ),
          ],
        ),
      ));
    });
  }
}
