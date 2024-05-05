import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:valoralysis/api/services/auth_service.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/widgets/ui/navigation_bar/navigation_bar.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return SafeArea(
          child: Scaffold(
        bottomNavigationBar: const NavBar(),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SettingsList(
          sections: [
            SettingsSection(
              tiles: <SettingsTile>[
                SettingsTile(
                  onPressed: (context) => (userProvider.logout(context)),
                  leading: Icon(Icons.logout),
                  title: Text('Sign out'),
                ),
              ],
            ),
          ],
        ),
      ));
    });
  }
}
