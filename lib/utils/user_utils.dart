class UserUtils {
  static String getUsername(Map<String, dynamic> matchDetails, String puuid) {
    return matchDetails['players']
            .firstWhere((player) => player['puuid'] == puuid)['gameName'] +
        '#' +
        matchDetails['players']
            .firstWhere((player) => player['puuid'] == puuid)['tagLine'];
  }
}
