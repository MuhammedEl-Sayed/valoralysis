import 'package:flutter/material.dart'
    hide DataColumn, DataCell, DataRow, DataTable;
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/player_stats.dart';
import 'package:valoralysis/models/rank.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/utils/formatting_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/utils/rank_utils.dart';
import 'package:valoralysis/utils/weapons_utils.dart';
import 'package:valoralysis/widgets/ui/data_table/data_table.dart';
import 'package:valoralysis/widgets/ui/marquee_text/marquee_text.dart';

class TableUtils {
  static List<DataRow> buildPlayerDataRows(
      Map<String, dynamic> matchDetail,
      String puuid,
      List<Rank> ranks,
      List<ContentItem> agents,
      bool isUserTeam,
      String userPUUID) {
    List<Map<String, dynamic>> players = [];

    String userTeam =
        HistoryUtils.extractTeamFromPUUID(matchDetail, puuid)['teamId'];
    for (Map<String, dynamic> player in matchDetail['players']) {
      String playerTeam = HistoryUtils.extractTeamFromPUUID(
          matchDetail, player['puuid'])['teamId'];
      if (isUserTeam && playerTeam == userTeam) {
        players.add(player);
      } else if (!isUserTeam && playerTeam != userTeam) {
        players.add(player);
      }
    }

    List<DataRow> rows = [];
    List<PlayerStats> playerStatsList = [];

    for (Map<String, dynamic> player in players) {
      String playerPUUID = player['puuid'];
      DataCell profile = buildPlayerProfileDataCell(
          matchDetail, player, ranks, agents, playerPUUID == userPUUID);
      PlayerStats stats =
          HistoryUtils.extractPlayerStat(matchDetail, playerPUUID);
      playerStatsList.add(stats);
      String hs = FormattingUtils.convertShotToPercentage(
          WeaponsUtils.weaponsHeadshotAccuracyAnaylsis(
              [matchDetail], playerPUUID),
          ShotType.Headshot);
      rows.add(DataRow(cells: [
        profile, // Profile under the team name column
        const DataCell(Text('0')), // ACS
        DataCell(Text(stats.kd.toString())), // KD
        DataCell(Text(stats.kills.toString())), // K
        DataCell(Text(stats.deaths.toString())), // D
        DataCell(Text(stats.assists.toString())), // A
        const DataCell(Text('0')), // ADR
        DataCell(Text(hs)), // HS%
      ]));
    }
    rows.sort((a, b) {
      int aIndex = rows.indexOf(a);
      int bIndex = rows.indexOf(b);
      if (aIndex == -1 || bIndex == -1) {
        return 0; // or handle this situation differently
      }
      double aStats = playerStatsList[aIndex].kills.toDouble();
      double bStats = playerStatsList[bIndex].kills.toDouble();
      return bStats.compareTo(aStats);
    });
    // Now we make sure to sort the rows by KD

    return rows;
  }

  static DataCell buildPlayerProfileDataCell(
      Map<String, dynamic> matchDetail,
      Map<String, dynamic> player,
      List<Rank> ranks,
      List<ContentItem> agents,
      bool isUser) {
    String puuid = player['puuid'];
    String playerName =
        HistoryUtils.extractPlayerNameByPUUID(matchDetail, puuid);
    Rank playerRank = RankUtils.getPlayerRank(matchDetail, ranks, puuid);

    return DataCell(Stack(children: <Widget>[
      Positioned(
        left: 0,
        top: 0,
        bottom: 0,
        child: isUser
            ? Container(
                width: 75, // adjust the width as needed
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xffff897d).withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
      ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 120),
          child: Padding(
              padding: const EdgeInsets.only(top: 7, bottom: 7, left: 7),
              child: Row(
                children: [
                  Image(
                    image: NetworkImage(
                        AgentUtils.getImageFromId(matchDetail, puuid, agents) ??
                            ''),
                    width: 25,
                    height: 25,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MarqueeText(
                            direction: Axis.horizontal,
                            child: Text(
                              playerName,
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            )),
                        Row(
                          children: [
                            Image(
                              image:
                                  NetworkImage(playerRank.rankIcons.smallIcon),
                              width: 10,
                              height: 10,
                            ),
                            Flexible(
                              child: Text(playerRank.tierName,
                                  style:
                                      const TextStyle(fontSize: 9, height: 1),
                                  overflow: TextOverflow.ellipsis),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )))
    ]));
  }
}
