import 'dart:convert';
import 'dart:io';

Future<List<Map<String, dynamic>>> getMockData() async {
  final file = File('mock_data.json');
  String jsonString = await file.readAsString();
  Map<String, dynamic> jsonData = jsonDecode(jsonString);

  List<Map<String, dynamic>> mockData = [];

  for (int i = 0; i < 8; i++) {
    mockData.add(jsonData[i.toString()]);
  }

  return mockData;
}
