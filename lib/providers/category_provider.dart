import 'package:flutter/material.dart';
import 'package:valoralysis/models/item.dart';

class CategoryTypeProvider with ChangeNotifier {
  Item overview = Item('Overview', 'overview');
  Item performance = Item('Performance', 'performance');
  Item gunfights = Item('Gunfights', 'gunfights');

  List<Item> queueTypes = [];

  CategoryTypeProvider() {
    queueTypes = [overview, performance, gunfights];
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
