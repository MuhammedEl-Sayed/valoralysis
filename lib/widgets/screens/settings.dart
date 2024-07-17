import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:valoralysis/providers/navigation_provider.dart';
import 'package:valoralysis/providers/user_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return 'Version: ${packageInfo.version} (Build: ${packageInfo.buildNumber})';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      final navigationProvider = Provider.of<NavigationProvider>(context);
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
                      (userProvider.logout(context, navigationProvider)),
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign out'),
                ),
                SettingsTile(
                  title: FutureBuilder<String>(
                    future: _getAppVersion(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading...');
                      } else if (snapshot.hasError) {
                        return const Text('Error loading version');
                      } else {
                        return Text(snapshot.data!);
                      }
                    },
                  ),
                  enabled: false,
                ),
              ],
            ),
          ],
        ),
      ));
    });
  }
}
