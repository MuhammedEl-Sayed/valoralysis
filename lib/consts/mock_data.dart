import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

Future<List<Map<String, dynamic>>> getMockData() async {
  String jsonString = await rootBundle.loadString('assets/data/mock_data.json');

  Map<String, dynamic> jsonData = jsonDecode(jsonString);

  List<Map<String, dynamic>> mockData = [];

  for (int i = 0; i < 8; i++) {
    mockData.add(jsonData);
  }
  return mockData;
}
