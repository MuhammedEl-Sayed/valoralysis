import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/models/user.dart';
import 'package:valoralysis/providers/navigation_provider.dart';
import 'package:valoralysis/utils/file_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';

class UserProvider with ChangeNotifier {
  User _user =
      User(puuid: '', consentGiven: false, name: '', matchDetailsMap: {});
  List<User> _users = [];

  User get user => _user;
  List<User> get users => _users;

  final SharedPreferences prefs;

  UserProvider(this.prefs);

  Future<void> init() async {
    int preferredPUUID = prefs.getInt('preferredPUUID') ?? -1;
    _users = await FileUtils.readUsers();

    if (preferredPUUID == -1 || _users.isEmpty) {
      setUser(
          User(puuid: '', consentGiven: false, name: '', matchDetailsMap: {}));
      return;
    }
    setUser(_users[preferredPUUID]);
  }

  void setUser(User value) {
    _user = value;

    saveUser();
    notifyListeners();
  }

  bool isUserPUUID(String puuid) {
    return puuid == user.puuid;
  }

  void resetUser() {
    setUser(
        User(puuid: '', consentGiven: false, name: '', matchDetailsMap: {}));
  }

  void updatePuuid(String puuid) {
    _user.puuid = puuid;
    saveUser();
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    _user.name = name;
    await saveUser();
  }

  void updateConsentGiven(bool consentGiven) {
    _user.consentGiven = consentGiven;
    saveUser();
    notifyListeners();
  }

  Future<void> updateStoredMatches(Map<String, MatchDto> matchHistory) async {
    print('pre pdated map: ${json.encode(matchHistory)}');

    matchHistory.forEach((key, value) {
      if (!_user.matchDetailsMap.containsKey(key)) {
        _user.matchDetailsMap.addEntries([MapEntry(key, value)]);
      }
    });
    try {
      _user.matchDetailsMap =
          HistoryUtils.sortMatchDetailsByStartTime(_user.matchDetailsMap);
      print('updated map: ${json.encode(_user.matchDetailsMap)}');
    } catch (e) {
      print('Exception in updateStoredMatches: $e');
    }
    await saveUser();
    notifyListeners();
  }

  void logout(BuildContext context, NavigationProvider navigationProvider) {
    _user.puuid = '';
    _user.consentGiven = false;
    _user.name = '';
    _user.matchDetailsMap = {};
    prefs.setInt('preferredPUUID', -1);
    navigationProvider.navigateTo('/');
    notifyListeners();
  }

  Future<void> saveUser() async {
    prefs.setInt('preferredPUUID', await FileUtils.writeUser(_user));
    // update the users list
    _users = await FileUtils.readUsers();
  }

  List<String> getNameHistory() {
    return _users.map((User user) => user.name).toList();
  }
}
