import 'dart:io';

class AuthInfo {
  List<Cookie> cookies;
  String accessToken;
  String entitlementToken;

  AuthInfo(
      {required this.cookies,
      required this.accessToken,
      required this.entitlementToken});
}
