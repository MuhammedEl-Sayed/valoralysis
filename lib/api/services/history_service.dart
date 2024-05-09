import 'package:dio/dio.dart';
import 'package:valoralysis/api/services/auth_service.dart';
import 'package:valoralysis/models/match_history.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/utils/rate_limiter.dart';
import 'package:valoralysis/utils/riot_api_builder.dart';

class HistoryService {
  static final rateLimiter = RateLimiter(20, 100);

  static Future<List<MatchHistory>> getMatchListByPuuid(String puuid) async {
    return rateLimiter.run(() => _getMatchListByPuuid(puuid));
  }

  static Future<List<MatchHistory>> _getMatchListByPuuid(String puuid) async {
    Dio dio = AuthService.prepareDio(PlatformId.NA);
    var response = await dio.get('/val/match/v1/matchlists/by-puuid/$puuid');
    return (response.data['history'] as List)
        .map((match) => MatchHistory.fromJson(match))
        .toList();
  }

  static Future<Map<String, dynamic>> getMatchDetailsByMatchID(
      String matchID) async {
    return rateLimiter.run(() => _getMatchDetailsByMatchID(matchID));
  }

  static Future<Map<String, dynamic>> _getMatchDetailsByMatchID(
      String matchID) async {
    Dio dio = AuthService.prepareDio(PlatformId.NA);
    try {
      var response = await dio.get('/val/match/v1/matches/$matchID');
      return response.data;
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  static Future<List<Map<String, dynamic>>> getAllMatchDetails(
      List<MatchHistory> matchHistory) async {
    var trimmedMatches =
        HistoryUtils.extractMatchIDs(matchHistory).getRange(0, 20);
    var futures =
        trimmedMatches.map((matchID) => getMatchDetailsByMatchID(matchID));
    return await Future.wait(futures);
  }
}
