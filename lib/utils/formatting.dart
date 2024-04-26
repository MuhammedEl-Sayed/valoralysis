import 'package:flutter/material.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/utils/history_utils.dart';

class FormattingUtils {
  static String capitalizeFirstLetter(String str) {
    return '${str[0]}${str.substring(1, str.length).toLowerCase()}';
  }

  static String convertContentIdToName(List<ContentItem> content, String id) {
    print(content.firstWhere((item) => item.id == id));
    return content.firstWhere((item) => item.id == id).name;
  }

  static String convertWeaponIdToName(List<WeaponItem> content, String id) {
    return content.firstWhere((item) => item.uuid == id).name;
  }

  // Need puuid to figure out which team to show on the right
  static Widget convertTeamWinMapToString(
      Map<String, dynamic> matchDetail, String puuid) {
    String playerTeam =
        HistoryUtils.extractTeamFromPUUID(matchDetail, puuid)['teamId'];
    Map<String, int> winsPerTeam =
        HistoryUtils.extractRoundWinsPerTeam(matchDetail);

    // Check if the values are not null before converting to string
    String playerTeamWins = winsPerTeam[playerTeam]?.toString() ?? '0';
    String opponentTeamWins =
        winsPerTeam[winsPerTeam.keys.firstWhere((team) => team != playerTeam)]
                ?.toString() ??
            '0';

    return Row(children: [
      Text(
        playerTeamWins,
        style: TextStyle(
          fontSize: 17,
          color: int.parse(playerTeamWins) > int.parse(opponentTeamWins)
              ? Color(0xffE5FFE4)
              : Color(0xffFFE4E4),
        ),
      ),
      const Text(
        ':',
        style: TextStyle(
          fontSize: 17,
          color: Color(0xffffffff),
        ),
      ),
      Text(
        opponentTeamWins,
        style: TextStyle(
          fontSize: 17,
          color: int.parse(opponentTeamWins) > int.parse(playerTeamWins)
              ? Color(0xffE5FFE4)
              : Color(0xffFFE4E4),
        ),
      ),
    ]);
  }
}
