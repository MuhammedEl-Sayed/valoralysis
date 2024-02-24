import 'package:dio/dio.dart';
import 'package:valoralysis/models/auth_info.dart';

class HistoryService {
  static fetchMatchHistory(String shard, int startIndex, int endIndex,
      String queueType, AuthInfo authInfo, String puuid) async {
    var dio = Dio();
    dio.options.headers['cookie'] = authInfo.cookies;

    try {
      var response = await dio.get(
        'https://pd.$shard.a.pvp.net/match-history/v1/history/$puuid?startIndex=$startIndex&endIndex=$endIndex&queue=$queueType',
        options: Options(headers: {
          "Authorization": 'Bearer ${authInfo.accessToken}',
          "X-Riot-Entitlements-JWT": authInfo.entitlementToken
        }),
      );
      print(response);
    } catch (e) {
      print('Request error: $e');
    }
  }
}
