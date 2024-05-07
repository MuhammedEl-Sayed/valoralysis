import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valoralysis/models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User(puuid: '', consentGiven: false, name: '', matchHistory: {});

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

    _user.name = prefs.getString('name') ?? '';

    String? matchHistory = prefs.getString('matchHistory');
    _user.matchHistory = matchHistory != null ? jsonDecode(matchHistory) : {};
  }

  void setUser(User value) {
    _user = value;
    updatePuuids(value.puuid);
    prefs.setBool('consentGiven', value.consentGiven);
    prefs.setString('name', value.name);
    prefs.setString('matchHistory', jsonEncode(value.matchHistory));
    notifyListeners();
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

  void updateMatchHistory(Map<String, dynamic> matchHistory) {
    _user.matchHistory = matchHistory;
    prefs.setString('matchHistory', jsonEncode(matchHistory));
    notifyListeners();
  }

  void logout(BuildContext context, PageController pageController) {
    _user.puuid = '';
    //update prefs so that preferredPUUIDS is -1
    prefs.setInt('preferredPUUIDS', -1);
    pageController.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.slowMiddle);
    resetUser();
    notifyListeners();
  }
}
