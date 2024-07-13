import 'package:flutter/material.dart'
    hide DataColumn, DataCell, DataRow, DataTable;
import 'package:table_sticky_headers/table_sticky_headers.dart';
import 'package:tuple/tuple.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/models/player_round_stats.dart';
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
  static List<List<Widget>> buildGunfightDataRows(
      MatchDto matchDto, String puuid, Content content) {
    // To do this. We get enemy team. We put themin a table. Icon + name in one column. alternate background color. K/D vs that player. make it clickable but do nothing for now.
    // We need to get player stats for all rounds, and do the same for the rest. then we can keep count of how many times they killed each other.
    /*  HistoryUtils.extractEnemyTeamPUUIDs(matchDetail, puuid)
            .map((enemy) =>
                HistoryUtils.extractPlayerRoundStats(matchDetail, enemy))
            .toList();*/
    //us that to get the stats, map it to the string
    Map<String, List<PlayerRoundStats>> enemies = HistoryUtils
            .extractEnemyTeamPUUIDs(matchDto, puuid)
        .map((enemy) => HistoryUtils.extractPlayerRoundStats(matchDto, enemy))
        .toList()
        .fold({}, (Map<String, List<PlayerRoundStats>> previousValue, element) {
      previousValue[element[0].puuid] = element;
      return previousValue;
    });

    Map<int, List<KillDto>> playerDeaths =
        HistoryUtils.extractRoundDeathsByPUUID(matchDto, puuid);
    Map<int, List<KillDto>> playerKills =
        HistoryUtils.extractPlayerKills(matchDto, puuid);
    List<List<Widget>> rows = [];
    //Map<String, to a tuple>
    Map<String, Tuple2<int, int>> playerGunfights = {};
    //Go through kills and use index to check deaths and kills each round, stack up the puuids in the map
    for (int i = 0; i < playerKills.length; i++) {
      List<KillDto> kills = playerKills[i] ?? [];
      List<KillDto> deaths = playerDeaths[i] ?? [];
      for (KillDto kill in kills) {
        String killedPUUID = kill.victim;
        if (playerGunfights.containsKey(killedPUUID)) {
          Tuple2<int, int> killsDeaths = playerGunfights[killedPUUID]!;
          playerGunfights[killedPUUID] =
              Tuple2(killsDeaths.item1 + 1, killsDeaths.item2);
        } else {
          playerGunfights[killedPUUID] = const Tuple2(1, 0);
        }
      }
      for (KillDto death in deaths) {
        String killerPUUID = death.killer;
        if (playerGunfights.containsKey(killerPUUID)) {
          Tuple2<int, int> killsDeaths = playerGunfights[killerPUUID]!;
          playerGunfights[killerPUUID] =
              Tuple2(killsDeaths.item1, killsDeaths.item2 + 1);
        } else {
          playerGunfights[killerPUUID] = const Tuple2(0, 1);
        }
      }
    }

    //Now we have the data, we can sort it by kills
    List<MapEntry<String, Tuple2<int, int>>> sortedGunfights =
        playerGunfights.entries.toList();
    sortedGunfights.sort((a, b) {
      return b.value.item1.compareTo(a.value.item1);
    });

    //NOW we can build the rows, get icon and name for one, and then put the kills and deaths in the other
    for (var entry in sortedGunfights) {
      String puuid = entry.key;
      Tuple2<int, int> killsDeaths = entry.value;
      String playerName =
          HistoryUtils.extractPlayerNameByPUUID(matchDto, puuid);
      ContentItem playerRank =
          RankUtils.getPlayerRank(matchDto, content.ranks, puuid);
      rows.add([
        TeamTableCell.content(
          backgroundColor: const Color(0xff2e1515),
          Column(
            children: //player agent Icon and then their name
                [
              CachedImage(
                imageUrl: AgentUtils.getImageFromId(
                        matchDto, puuid, content.agents) ??
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
        //trhen put k-d with k green and d red, make backgroudn more red if more deaths than kills
        TeamTableCell.content(
          backgroundColor: const Color(0xff2e1515),
          Row(
            children: [
              Text(
                '${killsDeaths.item1}',
                style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
              const Text(
                '-',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
              Text(
                '${killsDeaths.item2}',
                style: TextStyle(
                    color: killsDeaths.item2 > killsDeaths.item1
                        ? Colors.red
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ],
          ),
        ),
      ]);
    }

    return rows;
  }

  static List<List<Widget>> buildPlayerDataRows(MatchDto matchDetail,
      String puuid, Content content, bool isUserTeam, String userPUUID) {
    List<PlayerDto> players = [];
    List<ContentItem> ranks = content.ranks;
    List<ContentItem> agents = content.agents;

    String userTeam =
        HistoryUtils.extractTeamFromPUUID(matchDetail, puuid).teamId;
    for (PlayerDto player in matchDetail.players) {
      String playerTeam =
          HistoryUtils.extractTeamFromPUUID(matchDetail, player.puuid).teamId;
      if (isUserTeam && playerTeam == userTeam) {
        players.add(player);
      } else if (!isUserTeam && playerTeam != userTeam) {
        players.add(player);
      }
    }

    // Create a list of tuples (player, kast)
    List<Map<String, dynamic>> playerKastList = players.map((player) {
      String kast = MatchAnalysis.findKAST(matchDetail, player.puuid);
      return {
        'player': player,
        'kast': kast,
      };
    }).toList();

    // Sort the players by their KAST
    playerKastList.sort((a, b) {
      return double.parse(b['kast']).compareTo(double.parse(a['kast']));
    });

    List<List<Widget>> rows = [];

    for (var entry in playerKastList) {
      PlayerDto player = entry['player'];
      String kast = entry['kast'];
      String playerPUUID = player.puuid;
      Widget profile = buildPlayerProfileCell(matchDetail, player, ranks,
          agents, playerPUUID == userPUUID, isUserTeam);
      PlayerStats stats =
          HistoryUtils.extractPlayerStat(matchDetail, playerPUUID);
      String hs = FormattingUtils.convertShotToPercentage(
          WeaponsUtils.weaponsHeadshotAccuracyAnaylsis(
              [matchDetail], playerPUUID),
          ShotType.Headshot);
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
      MatchDto matchDetail,
      PlayerDto player,
      List<ContentItem> ranks,
      List<ContentItem> agents,
      bool isUser,
      bool isUserTeam) {
    String puuid = player.puuid;
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
