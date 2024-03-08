import 'package:dio/dio.dart';
import 'package:valoralysis/models/agent.dart';
import 'package:valoralysis/models/rank.dart';

class RankService {
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
      print(ranks);
      return ranks;
    } catch (e) {
      return [];
    }
  }
}
