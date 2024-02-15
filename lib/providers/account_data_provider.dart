import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valoralysis/models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User(puuid: '');
  final SharedPreferences prefs;
  User get user => _user;

  UserProvider(this.prefs) {
    List<String>? puuids = prefs.getStringList('puuids');
    _user.puuid = (puuids != null && puuids.isNotEmpty)
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
}
