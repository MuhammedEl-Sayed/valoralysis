import 'package:flutter/material.dart';

class QueueTypeProvider with ChangeNotifier {
  List<String> queueTypes = [
    'competitive',
    'unrated',
    'deathmatch',
    'team deathmatch',
    'custom'
  ];

  String _selectedQueue = 'competitive';

  String get selectedQueue => _selectedQueue;

  void selectQueue(String queueType) {
    if (queueTypes.contains(queueType)) {
      _selectedQueue = queueType;
      notifyListeners();
    } else {
      throw Exception('$queueType is not a valid queue type');
    }
  }
}
