import 'package:flutter/material.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/rank.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/utils/rank_utils.dart';

class TableUtils {
  static List<DataRow> buildPlayerDataRows(Map<String, dynamic> matchDetail,
      String puuid, List<Rank> ranks, List<ContentItem> agents) {
    List<Map<String, dynamic>> players = [];
    /**
     * Matches have players.
     * Players is a List of Player
     * Player has a bunch of properties, the Map<String, dynamic> p
     */
    print(matchDetail['players'][1]);
    for (Map<String, dynamic> player in matchDetail['players']) {
      players.add(player);
    }

    List<DataRow> rows = [];

    for (Map<String, dynamic> player in players) {
      DataCell profile =
          buildPlayerProfileDataCell(matchDetail, player, ranks, agents);
      rows.add(DataRow(cells: [
        profile, // Profile under the team name column
        DataCell(Text('0')), // ACS
        DataCell(Text('0')), // KD
        DataCell(Text('0')), // K
        DataCell(Text('0')), // D
        DataCell(Text('0')), // A
        DataCell(Text('0')), // ADR
        DataCell(Text('0')), // HS%
      ]));
    }
    return rows;
  }

  static List<DataCell> buildPlayerProfileDataCells(
      Map<String, dynamic> matchDetail,
      List<Map<String, dynamic>> players,
      List<Rank> ranks,
      List<ContentItem> agents) {
    List<DataCell> profiles = [];
    for (Map<String, dynamic> player in players) {
      profiles
          .add(buildPlayerProfileDataCell(matchDetail, player, ranks, agents));
    }
    return profiles;
  }

  static DataCell buildPlayerProfileDataCell(Map<String, dynamic> matchDetail,
      Map<String, dynamic> player, List<Rank> ranks, List<ContentItem> agents) {
    String puuid = player['puuid'];
    String iconUrl = AgentUtils.extractAgentIdByPUUID(matchDetail, puuid);
    String playerName =
        HistoryUtils.extractPlayerNameByPUUID(matchDetail, puuid);
    Rank playerRank = RankUtils.getPlayerRank([matchDetail], ranks, puuid);

    return DataCell(Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Image(
              image: NetworkImage(
                  AgentUtils.getImageFromId(matchDetail, puuid, agents) ?? ''),
              width: 25,
              height: 25,
            ),
            Container(
                height: 23,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      playerName,
                      style: TextStyle(fontSize: 13, height: 1),
                    ),
                    Row(
                      children: [
                        Image(
                          image: NetworkImage(playerRank.rankIcons.smallIcon),
                          width: 10,
                          height: 10,
                        ),
                        Text(playerRank.tierName,
                            style: TextStyle(fontSize: 9, height: 1))
                      ],
                    )
                  ],
                ))
          ],
        )));
  }
}
