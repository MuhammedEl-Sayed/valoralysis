import 'package:flutter/material.dart';
import 'package:valoralysis/models/item.dart';

class ModeProvider with ChangeNotifier {
  Item competitive = Item('Competitive', 'competitive');
  Item unrated = Item('Unrated', 'unrated');
  Item deathmatch = Item('Deathmatch', 'deathmatch');
  Item spikeRush = Item('Spike Rush', 'spikerush');

  List<Item> modes = [];

  ModeProvider() {
    modes = [competitive, unrated, deathmatch, spikeRush];
  }

  String _selectedMode = 'overview';

  String get selectedMode => _selectedMode;

  void selectMode(String mode) {
    if (modes.any((item) => item.realValue == mode)) {
      _selectedMode = mode;
      notifyListeners();
    } else {
      throw Exception('$mode is not a valid category type');
    }
  }
}
