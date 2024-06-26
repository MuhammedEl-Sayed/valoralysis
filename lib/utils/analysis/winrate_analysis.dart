import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/providers/mode_provider.dart';

class WinrateAnalysis {
  static double getWR(List<MatchDto> matchDetails, String puuid) {
    int wins = 0;

    for (MatchDto match in matchDetails) {
      if (match.matchInfo.gameMode == ModeProvider().deathmatch.realValue) {
        continue;
      }
/*       print(match['teams']
          .firstWhere((team) => team['won'] == true)['teamId']
          .toString());
 */
      String winningTeam =
          match.teams.firstWhere((team) => team.won == true).teamId.toString();
      if (match.players.firstWhere((player) => player.puuid == puuid).teamId ==
          winningTeam) wins++;
    }

    print('Wins: $wins');
    print('Losses: ${matchDetails.length - wins}');
    return (wins / (matchDetails.length)).isNaN
        ? 0.0
        : wins / matchDetails.length;
  }
}
