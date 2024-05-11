import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valoralysis/models/user.dart';
import 'package:valoralysis/providers/navigation_provider.dart';
import 'package:valoralysis/utils/file_utils.dart';

class UserProvider with ChangeNotifier {
  User _user = User(puuid: '', consentGiven: false, name: '', matchHistory: {});

  final SharedPreferences prefs;
  User get user => _user;

  UserProvider(this.prefs) {
    prefs.clear();
    List<String>? puuids = prefs.getStringList('puuids');
    _user.puuid = (puuids != null &&
            puuids.isNotEmpty &&
            prefs.getInt('preferredPUUIDS') != -1)
        ? puuids[prefs.getInt('preferredPUUIDS') ?? 0]
        : '';

    _user.consentGiven = prefs.getBool('consentGiven') ?? false;

    _user.name = prefs.getString('name') ?? '';
    init();
  }

  Future<void> init() async {
    _user.matchHistory = await FileUtils.readMatcHistory();
  }

  void setUser(User value) {
    _user = value;
    updatePuuids(value.puuid);
    prefs.setBool('consentGiven', value.consentGiven);
    prefs.setString('name', value.name);
    FileUtils.writeMatchHistory(value.matchHistory);
    notifyListeners();
  }

  bool isUserPUUID(String puuid) {
    return puuid == user.puuid;
  }

  void resetUser() {
    setUser(User(puuid: '', consentGiven: false, name: '', matchHistory: {}));
  }

  void updatePuuid(String puuid) {
    _user.puuid = puuid;
    updatePuuids(puuid);
    notifyListeners();
  }

  void updatePuuids(String puuid) {
    List<String> puuids = prefs.getStringList('puuids') ?? [];
    if (puuids.contains(puuid)) {
      prefs.setInt('preferredPUUIDS', puuids.indexOf(puuid));
    } else {
      puuids.add(puuid);
      prefs.setStringList('puuids', puuids);
      prefs.setInt('preferredPUUIDS', puuids.length - 1);
    }
  }

  void updateName(String name) {
    _user.name = name;
    prefs.setString('name', name);
    notifyListeners();
  }

  void updateConsentGiven(bool consentGiven) {
    _user.consentGiven = consentGiven;
    prefs.setBool('consentGiven', consentGiven);
    notifyListeners();
  }

  void updateStoredMatches(Map<String, dynamic> matchHistory) {
    //we already loaded user data in init so know we gotta merge with new
    matchHistory.forEach((key, value) {
      if (!_user.matchHistory.containsKey(key)) {
        print('Added new match!');
        _user.matchHistory.addEntries([MapEntry(key, value)]);
      }
    });
    FileUtils.writeMatchHistory(_user.matchHistory);
    notifyListeners();
  }

  void logout(BuildContext context, NavigationProvider navigationProvider) {
    _user.puuid = '';
    //update prefs so that preferredPUUIDS is -1
    prefs.setInt('preferredPUUIDS', -1);
    navigationProvider.navigateTo('/');
    resetUser();
    notifyListeners();
  }
}
