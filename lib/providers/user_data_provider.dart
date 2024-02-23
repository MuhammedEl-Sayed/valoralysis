import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valoralysis/models/auth_info.dart';
import 'package:valoralysis/models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
      puuid: '',
      authInfo: AuthInfo(
        cookies: [],
        entitlementToken: '',
        accessToken: '',
      ));
  final SharedPreferences prefs;
  User get user => _user;

  UserProvider(this.prefs) {
    List<String>? puuids = prefs.getStringList('puuids');
    _user.puuid = (puuids != null &&
            puuids.isNotEmpty &&
            prefs.getInt('preferredPUUIDS') != -1)
        ? puuids[prefs.getInt('preferredPUUIDS') ?? 0]
        : '';
  }

  void setUser(User value) {
    _user = value;
    notifyListeners();
  }

  void updateUserPUUID(String newPUUID) {
    _user.puuid = newPUUID;
    notifyListeners();
  }

  void logout(BuildContext context) {
    _user.puuid = '';
    //update prefs so that preferredPUUIDS is -1
    prefs.setInt('preferredPUUIDS', -1);
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    setUser(User(puuid: ''));
  }

  void login(BuildContext context, List<Cookie> cookies, String acessToken,
      String entitlementToken) {}
}
