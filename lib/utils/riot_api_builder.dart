// ignore_for_file: constant_identifier_names

class PlatformId {
  static const String NA = "NA";
  static const String BR = "BR";
  static const String AP = "AP";
  static const String ESPORTS = "ESPORTS";
  static const String EU = "EU";
  static const String KR = "KR";
  static const String LATAM = "LATAM";
  static const String AMERICAS = "AMERICAS";
  static const String ASIA = "ASIA";
  static const String EUROPE = "EUROPE";
}

class RiotApiUrlBuilder {
  static const String _BASE_URL = "https://.api.riotgames.com";

  static String buildUrl(String platformId) {
    return _BASE_URL.replaceFirst('.', '$platformId.');
  }
}
