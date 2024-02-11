import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User(token: '');

  User get user => _user;

  void setUser(User value) {
    _user = value;
    notifyListeners();
  }

  void updateUserToken(String newToken) {
    _user.token = newToken;
    notifyListeners();
  }
}
