import 'package:dio/dio.dart';
import 'package:valoralysis/api/services/agent_service.dart';
import 'package:valoralysis/api/services/auth_service.dart';
import 'package:valoralysis/api/services/rank_service.dart';
import 'package:valoralysis/api/services/weapons_service.dart';
import 'package:valoralysis/models/agent.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/rank.dart';
import 'package:valoralysis/utils/riot_api_builder.dart';

class ContentService {
  static Future<Content> fetchContent() async {
    try {
      Dio dio = AuthService.prepareDio(PlatformId.NA);
      var response = await dio.get('/val/content/v1/contents?locale=en-US');
      List<AgentIconMap> agentIcons = await getAgentIcons();
      List<Rank> ranks = await getRanks();
      List<WeaponItem> weapons = await WeaponsService.fetchWeaponData();
      return await Content.fromJson(response.data,
          agentIcons: agentIcons, ranks: ranks, weapons: weapons);
    } catch (e) {
      print('Error fetching content: $e');
      rethrow;
    }
  }
  static Future<List<AgentIconMap>> getAgentIcons() async {
    Dio dio = Dio();
    try {
      var response = await dio.get('https://valorant-api.com/v1/agents');
      List<AgentIconMap> agentIcons = [];
      for (var agent in response.data['data']) {
        agentIcons.add(AgentIconMap(agent['uuid'], agent['displayIcon']));
      }
      return agentIcons;
    } catch (e) {
      return [];
    }
  }

    static Future<List<Rank>> getRanks() async {
    Dio dio = Dio();
    try {
      var response =
          await dio.get('https://valorant-api.com/v1/competitivetiers');
      List<Rank> ranks = [];
      for (var data in response.data['data']) {
        for (var tier in data['tiers']) {
          if (tier['smallIcon'] != null && tier['largeIcon'] != null) {
            ranks.add(Rank.fromJson(tier));
          }
        }
      }
      return ranks;
    } catch (e) {
      return [];
    }
  }

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

  static Future<File> fetchContentFile() async {
    try{

    }
  }
}
