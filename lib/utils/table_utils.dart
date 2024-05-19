import 'package:flutter/material.dart'
    hide DataColumn, DataCell, DataRow, DataTable;
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/player_stats.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/utils/analysis/match_analysis.dart';
import 'package:valoralysis/utils/formatting_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/utils/rank_utils.dart';
import 'package:valoralysis/utils/weapons_utils.dart';
import 'package:valoralysis/widgets/ui/data_table/data_table.dart';
import 'package:valoralysis/widgets/ui/marquee_text/marquee_text.dart';

class TableUtils {
  static List<DataRow> buildPlayerDataRows(Map<String, dynamic> matchDetail,
      String puuid, Content content, bool isUserTeam, String userPUUID) {
    List<Map<String, dynamic>> players = [];
    List<ContentItem> ranks = content.ranks;
    List<ContentItem> agents = content.agents;

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

    // Now we sort the players by their kills
    for (Map<String, dynamic> player in players) {
      player['kast'] = MatchAnalysis.findKAST(matchDetail, player['puuid']);
    }

// Now we sort the players by their KAST
    players.sort((a, b) {
      return double.parse(b['kast']).compareTo(double.parse(a['kast']));
    });

    List<DataRow> rows = [];

    for (Map<String, dynamic> player in players) {
      String playerPUUID = player['puuid'];
      DataCell profile = buildPlayerProfileDataCell(
          matchDetail, player, ranks, agents, playerPUUID == userPUUID);
      PlayerStats stats =
          HistoryUtils.extractPlayerStat(matchDetail, playerPUUID);
      String hs = FormattingUtils.convertShotToPercentage(
          WeaponsUtils.weaponsHeadshotAccuracyAnaylsis(
              [matchDetail], playerPUUID),
          ShotType.Headshot);
      String kast = MatchAnalysis.findKAST(matchDetail, playerPUUID);
      int numTrades = stats.trades.values
          .fold(0, (previousValue, element) => previousValue + element.length);
      rows.add(DataRow(cells: [
        profile, // Profile under the team name column
        DataCell(Text('$kast%')), // ACS
        DataCell(Text(stats.kd.toString())), // KD
        DataCell(Text(stats.kills.toString())), // K
        DataCell(Text(stats.deaths.toString())), // D
        DataCell(Text(stats.assists.toString())), // A
        DataCell(Text(numTrades.toString())),
        const DataCell(Text('0')), // ADR
        DataCell(Text(hs)), // HS%
      ]));
    }

    // Now we make sure to sort

    return rows;
  }

  static DataCell buildPlayerProfileDataCell(
      Map<String, dynamic> matchDetail,
      Map<String, dynamic> player,
      List<ContentItem> ranks,
      List<ContentItem> agents,
      bool isUser) {
    String puuid = player['puuid'];
    String playerName =
        HistoryUtils.extractPlayerNameByPUUID(matchDetail, puuid);
    ContentItem playerRank = RankUtils.getPlayerRank(matchDetail, ranks, puuid);

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
                  CachedNetworkImage(
                    imageUrl:
                        AgentUtils.getImageFromId(matchDetail, puuid, agents) ??
                            '',
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
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
                            CachedNetworkImage(
                              imageUrl: playerRank.rankIcons.smallIcon ?? '',
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
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
