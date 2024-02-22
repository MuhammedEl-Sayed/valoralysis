import 'dart:io';

class CookieUtils {
  static List<Cookie> getCookies(String cookies) {
    return cookies.split(';').map((cookie) {
      if (cookie.isEmpty) {
        return Cookie('', '');
      }
      final cookieSplit = cookie.split('=');
      print(cookieSplit[0].trim() + " " + cookieSplit[1]);
      return Cookie(cookieSplit[0].trim(), cookieSplit[1]);
    }).toList();
  }

  static void printCookies(List<Cookie> cookies) {
    for (var cookie in cookies) {
      print(cookie.name + " " + cookie.value);
    }
  }
}
