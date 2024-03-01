import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:valoralysis/utils/riot_api_builder.dart';

class AuthService {
  static Dio prepareDio(String platform) {
    Dio dio = Dio();
    dio.options.headers['X-Riot-Token'] = dotenv.env['RIOT_API_KEY'];
    dio.options.baseUrl = RiotApiUrlBuilder.buildUrl(platform);
    return dio;
  }
}
