import 'package:flutter/material.dart'
    hide DataColumn, DataCell, DataRow, DataTable;
import 'package:table_sticky_headers/table_sticky_headers.dart';
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
import 'package:valoralysis/widgets/ui/team_details_table/team_table_cell.dart';

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
      Widget profile = buildPlayerProfileCell(matchDetail, player, ranks,
          agents, playerPUUID == userPUUID, isUserTeam);
      PlayerStats stats =
          HistoryUtils.extractPlayerStat(matchDetail, playerPUUID);
      String hs = FormattingUtils.convertShotToPercentage(
          WeaponsUtils.weaponsHeadshotAccuracyAnaylsis(
              [matchDetail], playerPUUID),
          ShotType.Headshot);
      String kast = MatchAnalysis.findKAST(matchDetail, playerPUUID);
      int adr = MatchAnalysis.findADR(matchDetail, playerPUUID);
      int numTrades = stats.trades.values
          .fold(0, (previousValue, element) => previousValue + element.length);
      Widget wrapWithTeamTableCellContent(Widget child) {
        return TeamTableCell.content(
          backgroundColor:
              isUserTeam ? const Color(0xff224015) : const Color(0xff2e1515),
          child,
        );
      }

      List<Widget> row = [
        profile,
        wrapWithTeamTableCellContent(Text('$kast%')),
        wrapWithTeamTableCellContent(Text(stats.kd.toString())),
        wrapWithTeamTableCellContent(Text(stats.kills.toString())),
        wrapWithTeamTableCellContent(Text(stats.deaths.toString())),
        wrapWithTeamTableCellContent(Text(stats.assists.toString())),
        wrapWithTeamTableCellContent(Text(numTrades.toString())),
        wrapWithTeamTableCellContent(Text(adr.toString())),
        wrapWithTeamTableCellContent(Text(hs)),
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
      bool isUser,
      bool isUserTeam) {
    String puuid = player['puuid'];
    String playerName =
        HistoryUtils.extractPlayerNameByPUUID(matchDetail, puuid);
    ContentItem playerRank = RankUtils.getPlayerRank(matchDetail, ranks, puuid);

    return TeamTableCell.content(
        intermediateWidget: Positioned(
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
        backgroundColor:
            isUserTeam ? const Color(0xff224015) : const Color(0xff2e1515),
        cellDimensions: const CellDimensions.fixed(
            contentCellWidth: 150,
            contentCellHeight: 45,
            stickyLegendWidth: 150,
            stickyLegendHeight: 45),
        Stack(children: <Widget>[
          // Inside buildPlayerProfileCell method
          Padding(
            padding: const EdgeInsets.only(top: 7, bottom: 7, left: 7),
            child: Row(
              children: [
                CachedImage(
                  imageUrl:
                      AgentUtils.getImageFromId(matchDetail, puuid, agents) ??
                          '',
                  width: 25,
                  height: 25,
                ),
                ClipRect(
                  child: SizedBox(
                    width: 80, // Set your desired width here
                    child: MarqueeText(
                        direction: Axis.horizontal,
                        child: Text(
                          playerName,
                          style: const TextStyle(fontSize: 13),
                        )),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: CachedImage(
              imageUrl: playerRank.iconUrl ?? '',
              width: 30,
              height: 30,
            ),
          )
        ]));
  }
}
