import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valoralysis/models/auth_info.dart';
import 'package:valoralysis/models/user.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/utils/cookies.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
      puuid: '',
      authInfo: AuthInfo(
        cookies: '',
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

  void resetUser() {
    setUser(User(
        puuid: '',
        authInfo: AuthInfo(
          cookies: '',
          entitlementToken: '',
          accessToken: '',
        )));
  }

  void updatePuuid(String puuid) {
    _user.puuid = puuid;
    notifyListeners();
  }

  void updateCookies(String cookies) {
    if (cookies.isEmpty) throw Exception('Empty Cookies list.');
    _user.authInfo.cookies = cookies;
    prefs.setString('cookies', cookies);
    notifyListeners();
  }

  void updateEntitlementToken(String entitlementToken) {
    if (entitlementToken.isEmpty) throw Exception('Empty Entitlement token.');
    _user.authInfo.entitlementToken = entitlementToken;
    prefs.setString('entitlementToken', entitlementToken);
    notifyListeners();
  }

  void updateAccessToken(String accessToken) {
    if (accessToken.isEmpty) throw Exception('Empty Access token.');
    _user.authInfo.accessToken = accessToken;
    prefs.setString('accessToken', accessToken);
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

  bool setLoginData(
      String cookies, String accessToken, String entitlementToken) {
    try {
      final decodedToken = JwtDecoder.decode(accessToken);
      final puuid = decodedToken['sub'];

      updatePuuid(puuid);

      List<String>? puuids = prefs.getStringList('puuids') ?? [];
      puuids.add(puuid);
      prefs.setStringList('puuids', puuids);
      prefs.setInt('preferredPUUIDS', puuids.length - 1);
      updateAccessToken(accessToken);
      updateEntitlementToken(entitlementToken);
      updateCookies(cookies);
      notifyListeners();
      return true;
    } catch (e) {
      print('Login failed: $e');
      return false;
    }
  }
}
