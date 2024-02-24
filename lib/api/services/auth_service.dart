import 'dart:io';

import 'package:dio/dio.dart';

class AuthService {
  // Next step is to save the cookies to the user and then use them to refresh the token every time the user logs in
  static Future<String> refreshToken(List<Cookie> cookies) async {
    var dio = Dio();
    dio.options.headers['cookie'] =
        cookies.map((c) => '${c.name}=${c.value}').join('; ');
    dio.options.validateStatus = (status) {
      return status != null && status >= 200 && status < 400;
    };
    try {
      var response = await dio.get(
        'https://auth.riotgames.com/authorize?redirect_uri=https%3A%2F%2Fplayvalorant.com%2Fopt_in&client_id=play-valorant-web-prod&response_type=token%20id_token&nonce=1',
        options: Options(
          followRedirects: false,
        ),
      );

      if (response.headers.value('location')?.contains('access_token=') ??
          false) {
        print('Reauth successful');
        // access token is in the url, still needs to be parsed
        return response.headers
            .value('location')
            ?.split('access_token=')[1]
            .split('&')[0] as String;
      } else {
        print('Reauth failed');
      }
    } catch (e) {
      print('Request error: $e');
    }
    return '';
  }

  static Future<String> fetchEntitlementToken(String accessToken) async {
    var dio = Dio();
    try {
      var response = await dio.post(
        'https://entitlements.auth.riotgames.com/api/token/v1',
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );
      if (response.data != null &&
          response.data['entitlements_token'] != null) {
        return response.data['entitlements_token'];
      }
    } catch (e) {
      print('Request error: $e');
    }
    return '';
  }
}
