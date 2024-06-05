import 'package:valoralysis/models/match_details.dart';

class UserUtils {
  static String getUsername(MatchDto matchDetail, String puuid) {
    return '${matchDetail.players.firstWhere((player) => player.puuid == puuid).gameName}#${matchDetail.players.firstWhere((player) => player.partyId == puuid).tagLine}';
  }
}
