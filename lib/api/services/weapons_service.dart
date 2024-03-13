import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:valoralysis/models/content.dart';

class WeaponsService {
  static Future<List<WeaponItem>> fetchWeaponData() async {
    Dio dio = Dio();
    try {
      var response = await dio.get('https://valorant-api.com/v1/weapons');
      Map<String, dynamic> jsonData = response.data;
      List<WeaponItem> weapons = [];
      for (var weapon in jsonData['data']) {
        weapons.add(WeaponItem.fromJson(weapon));
      }
      return weapons;
    } catch (e) {
      print('Weapon fetch error: $e');
      return [];
    }
  }
}
