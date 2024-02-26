import 'dart:convert';

import 'package:dio/dio.dart';

class WeaponsService {
  static Future<Map<String, String>> fetchWeaponData() async {
    Dio dio = Dio();

    try {
      var response = await dio.get('https://valorant-api.com/v1/weapons');
      Map<String, dynamic> jsonData = response.data;
      Map<String, String> weaponsMap = {};
      for (var weapon in jsonData['data']) {
        weaponsMap[weapon['uuid']] = weapon['displayName'];
      }
      return weaponsMap;
    } catch (e) {
      print('Weapon fetch error: $e');
      return {};
    }
  }
}
