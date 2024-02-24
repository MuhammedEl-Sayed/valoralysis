import 'dart:io';

class CookieUtils {
  static void printCookies(List<Cookie> cookies) {
    for (var cookie in cookies) {
      print(cookie.name + " " + cookie.value);
    }
  }

  static String getStringFromCookies(List<Cookie> cookies) {
    return cookies.map((c) => '${c.name}=${c.value}').join('; ');
  }
}
