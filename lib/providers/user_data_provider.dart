import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valoralysis/models/user.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {
  User _user = User(puuid: '', consentGiven: false);
  final SharedPreferences prefs;
  User get user => _user;

  UserProvider(this.prefs) {
    List<String>? puuids = prefs.getStringList('puuids');
    _user.puuid = (puuids != null &&
            puuids.isNotEmpty &&
            prefs.getInt('preferredPUUIDS') != -1)
        ? puuids[prefs.getInt('preferredPUUIDS') ?? 0]
        : '';
    _user.consentGiven = prefs.getBool('consentGiven') ?? false;
  }

  void setUser(User value) {
    _user = value;
    notifyListeners();
  }

  void resetUser() {
    setUser(User(puuid: '', consentGiven: false));
  }

  void updatePuuid(String puuid) {
    _user.puuid = puuid;
    notifyListeners();
  }

  void updateConsentGiven(bool consentGiven) {
    _user.consentGiven = consentGiven;
    prefs.setBool('consentGiven', consentGiven);
    notifyListeners();
  }

  void logout(BuildContext context) {
    _user.puuid = '';
    //update prefs so that preferredPUUIDS is -1
    prefs.setInt('preferredPUUIDS', -1);
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    resetUser();
    notifyListeners();
  }
}
