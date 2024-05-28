import 'package:flutter/material.dart';
import 'package:valoralysis/models/item.dart';

class ModeProvider with ChangeNotifier {
  Item competitive = Item('Competitive', 'competitive');
  Item premier = Item('Premier', 'premier');
  Item unrated = Item('Unrated', 'unrated');
  Item deathmatch = Item('Deathmatch', 'deathmatch');
  Item spikeRush = Item('Spike Rush', 'spikerush');

  List<Item> modes = [];

  ModeProvider() {
    modes = [competitive, premier, unrated, deathmatch, spikeRush];
  }

  String _selectedMode = 'competitive';

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
