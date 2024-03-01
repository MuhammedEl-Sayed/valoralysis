import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:valoralysis/api/services/auth_service.dart';
import 'package:valoralysis/utils/riot_api_builder.dart';

class HistoryService {
  static Future<Response> getMatchListByPuuid(String puuid) async {
    Dio dio = AuthService.prepareDio(PlatformId.NA);
    return await dio.get(
        '/val/match/v1/matchlists/by-puuid/$puuid?api_key=${dotenv.env['RIOT_API_KEY']}');
  }
}
