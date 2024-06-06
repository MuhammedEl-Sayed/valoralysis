import 'package:dio/dio.dart';
import 'package:valoralysis/api/services/auth_service.dart';
import 'package:valoralysis/models/match_details.dart';
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

  static Future<MatchDto> getMatchDetailsByMatchID(String matchID) async {
    return rateLimiter.run(() => _getMatchDetailsByMatchID(matchID));
  }

  static Future<MatchDto> _getMatchDetailsByMatchID(String matchID) async {
    Dio dio = AuthService.prepareDio(PlatformId.NA);
    try {
      var response = await dio.get('/val/match/v1/matches/$matchID');
      MatchDto match = MatchDto.fromJson(response.data);
      print('call: ${match.players[0].gameName}');
      return match;
    } catch (e) {
      // print('call: ${e.toString()}');
      return MatchDto.empty();
    }
  }

  static Future<List<MatchDto>> getAllMatchDetails(
      List<MatchHistory> matchHistory) async {
    var trimmedMatches =
        HistoryUtils.extractMatchIDs(matchHistory).getRange(0, 20);
    var futures =
        trimmedMatches.map((matchID) => getMatchDetailsByMatchID(matchID));
    return await Future.wait(futures);
  }
}
