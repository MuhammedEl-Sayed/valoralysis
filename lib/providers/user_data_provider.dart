import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valoralysis/models/user.dart';
import 'package:valoralysis/providers/navigation_provider.dart';
import 'package:valoralysis/utils/file_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';

class UserProvider with ChangeNotifier {
  User _user = User(puuid: '', consentGiven: false, name: '', matchDetails: {});
  List<User> _users = [];

  User get user => _user;
  List<User> get users => _users;

  final SharedPreferences prefs;

  UserProvider(this.prefs);

  Future<void> init() async {
    int preferredPUUID = prefs.getInt('preferredPUUID') ?? -1;
    _users = await FileUtils.readUsers();

    if (preferredPUUID == -1 || _users.isEmpty) {
      setUser(User(puuid: '', consentGiven: false, name: '', matchDetails: {}));
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
    setUser(User(puuid: '', consentGiven: false, name: '', matchDetails: {}));
  }

  void updatePuuid(String puuid) {
    _user.puuid = puuid;
    saveUser();
    notifyListeners();
  }

  void updateName(String name) {
    _user.name = name;
    saveUser();
  }

  void updateConsentGiven(bool consentGiven) {
    _user.consentGiven = consentGiven;
    saveUser();
    notifyListeners();
  }

  void updateStoredMatches(Map<String, dynamic> matchHistory) {
    matchHistory.forEach((key, value) {
      if (!_user.matchDetails.containsKey(key)) {
        _user.matchDetails.addEntries([MapEntry(key, value)]);
      }
    });
    _user.matchDetails =
        HistoryUtils.sortMatchDetailsByStartTime(_user.matchDetails);
    FileUtils.writeUser(_user);
    notifyListeners();
  }

  void logout(BuildContext context, NavigationProvider navigationProvider) {
    _user.puuid = '';
    _user.consentGiven = false;
    _user.name = '';
    _user.matchDetails = {};
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
    print('users: $_users');
    return _users.map((User user) => user.name).toList();
  }
}
