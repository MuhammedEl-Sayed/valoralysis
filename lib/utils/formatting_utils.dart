//ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/utils/history_utils.dart';

enum ShotType { Headshot, Bodyshot, Legshot }

class FormattingUtils {
  static String capitalizeFirstLetter(String str) {
    return '${str[0]}${str.substring(1, str.length).toLowerCase()}';
  }

  static String convertContentIdToName(List<ContentItem> content, String id) {
    return content.firstWhere((item) => item.uuid == id).name;
  }

  static String convertWeaponIdToName(List<ContentItem> content, String id) {
    return content.firstWhere((item) => item.uuid == id).name;
  }

  static String convertShotToPercentage(
      Map<String, double> shots, ShotType typeOfShot) {
    String shotKey = typeOfShot.toString().split('.').last;
    if (shots[shotKey]!.isNaN) {}
    return '${(shots[shotKey]! * 100).toString().split('.')[0]}.${(shots[shotKey]! * 100).toString().split('.')[1].substring(0, 1)}%';
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
              ? const Color(0xffE5FFE4)
              : const Color(0xffFFE4E4),
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
              ? const Color(0xffE5FFE4)
              : const Color(0xffFFE4E4),
        ),
      ),
    ]);
  }
}
