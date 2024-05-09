import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:valoralysis/utils/rate_limiter.dart';
import 'package:valoralysis/utils/riot_api_builder.dart';

class AuthService {
  static final rateLimiter = RateLimiter(20, 100);

  static Dio prepareDio(String platform) {
    Dio dio = Dio();
    dio.options.headers['X-Riot-Token'] = dotenv.env['RIOT_API_KEY'];
    dio.options.baseUrl = RiotApiUrlBuilder.buildUrl(platform);
    return dio;
  }

  static Future<String> _getUserPUUID(String gameNameAndTag) async {
    Dio dio = prepareDio(PlatformId.AMERICAS);
    try {
      String gameName = gameNameAndTag.split('#')[0];
      String tagLine = gameNameAndTag.split('#')[1];

      var response = await dio.get(
        '/riot/account/v1/accounts/by-riot-id/$gameName/$tagLine',
        options: Options(
          headers: {
            'gameName': gameName,
            'tagLine': tagLine,
          },
        ),
      );
      return response.data['puuid'].length > 0 ? response.data['puuid'] : '';
    } catch (e) {
      return 'Error: $e';
    }
  }

  static Future<String> getUserPUUID(String gameNameAndTag) async {
    return rateLimiter.run(() => _getUserPUUID(gameNameAndTag));
  }
}
