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
import 'package:valoralysis/widgets/ui/cached_image/cached_image.dart';
import 'package:valoralysis/widgets/ui/marquee_text/marquee_text.dart';

class TableUtils {
  static List<List<Widget>> buildPlayerDataRows(
      Map<String, dynamic> matchDetail,
      String puuid,
      Content content,
      bool isUserTeam,
      String userPUUID) {
    List<Map<String, dynamic>> players = [];
    List<ContentItem> ranks = content.ranks;
    List<ContentItem> agents = content.agents;
    print('content: ${content.agents.length}');

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

    List<List<Widget>> rows = [];

    for (Map<String, dynamic> player in players) {
      String playerPUUID = player['puuid'];
      Widget profile = buildPlayerProfileCell(
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

      List<Widget> row = [
        profile,
        Text('$kast%'),
        Text(stats.kd.toString()),
        Text(stats.kills.toString()),
        Text(stats.deaths.toString()),
        Text(stats.assists.toString()),
        Text(numTrades.toString()),
        const Text('0'),
        Text(hs),
      ];
      rows.add(row);
    }

    // Now we make sure to sort

    return rows;
  }

  static Widget buildPlayerProfileCell(
      Map<String, dynamic> matchDetail,
      Map<String, dynamic> player,
      List<ContentItem> ranks,
      List<ContentItem> agents,
      bool isUser) {
    String puuid = player['puuid'];
    String playerName =
        HistoryUtils.extractPlayerNameByPUUID(matchDetail, puuid);
    ContentItem playerRank = RankUtils.getPlayerRank(matchDetail, ranks, puuid);

    return Stack(children: <Widget>[
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
      Padding(
        padding: const EdgeInsets.only(top: 7, bottom: 7, left: 7),
        child: Row(
          children: [
            CachedImage(
              imageUrl:
                  AgentUtils.getImageFromId(matchDetail, puuid, agents) ?? '',
              width: 25,
              height: 25,
            ),
            MarqueeText(
                direction: Axis.horizontal,
                child: Text(
                  playerName,
                  style: const TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
      ),
    ]);
  }
}
