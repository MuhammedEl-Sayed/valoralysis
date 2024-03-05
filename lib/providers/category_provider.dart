import 'package:flutter/material.dart';
import 'package:valoralysis/models/item.dart';

class CategoryTypeProvider with ChangeNotifier {
  Item overview = Item('Overview', 'overview');
  Item matches = Item('Matches', 'matches');
  Item agents = Item('Agents', 'agents');
  Item maps = Item('Maps', 'maps');
  Item weapons = Item('Weapons', 'weapons');

  List<Item> queueTypes = [];

  CategoryTypeProvider() {
    queueTypes = [overview, matches, agents, maps, weapons];
  }

  String _selectedQueue = 'overview';

  String get selectedQueue => _selectedQueue;

  void selectQueue(String queueType) {
    if (queueTypes.any((item) => item.realValue == queueType)) {
      _selectedQueue = queueType;
      notifyListeners();
    } else {
      throw Exception('$queueType is not a valid queue type');
    }
  }
}
