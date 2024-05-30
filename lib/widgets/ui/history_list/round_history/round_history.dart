import 'package:flutter/material.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/utils/round_utils.dart';

class RoundHistory extends StatelessWidget {
  final String puuid;
  final Map<String, dynamic> matchDetail;

  const RoundHistory(
      {super.key, required this.puuid, required this.matchDetail});

  @override
  Widget build(BuildContext context) {
    //First we'll find how many rounds were played
    Map<String, dynamic> roundResults =
        HistoryUtils.extractRoundResultPerTeam(matchDetail, puuid);

    int lastRound =
        roundResults['Your Team'].length + roundResults['Enemy Team'].length;

    List<int> roundsWonPlayer = [];
    List<int> roundsWonEnemy = [];

    for (var roundResult in roundResults['Your Team']) {
      roundsWonPlayer.add(roundResult['roundNum']);
    }

    for (var roundResult in roundResults['Enemy Team']) {
      roundsWonEnemy.add(roundResult['roundNum']);
    }

    for (int i = 0; i < lastRound; i++) {
      if (!roundsWonPlayer.contains(i)) {
        roundResults['Your Team'].add({'roundNum': i, 'roundResult': 'Lost'});
      }
      if (!roundsWonEnemy.contains(i)) {
        roundResults['Enemy Team'].add({'roundNum': i, 'roundResult': 'Lost'});
      }
    }

    roundResults['Your Team']
        .sort((a, b) => (a['roundNum'] as int).compareTo(b['roundNum'] as int));
    roundResults['Enemy Team']
        .sort((a, b) => (a['roundNum'] as int).compareTo(b['roundNum'] as int));
    return SizedBox(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('Your Team'), Text("Enemy Team")],
            ),
          ),
          Row(
            children: List.generate(lastRound, (i) {
              return Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: 16,
                          left: i == 12 || i == 24 ? 5 : 0,
                          right: i == 11 || i == 23 ? 5 : 0),
                      child: Column(
                        children: [
                          RoundUtils.resultToImageMap(
                              true,
                              i < roundResults['Your Team'].length
                                  ? roundResults['Your Team'][i]['roundResult']
                                  : null,
                              context),
                          RoundUtils.resultToImageMap(
                              false,
                              i < roundResults['Enemy Team'].length
                                  ? roundResults['Enemy Team'][i]['roundResult']
                                  : null,
                              context),
                          Text((i + 1).toString()),
                        ],
                      )),
                  if ((i % 11 == 0 && i != 0) || (i % 23 == 0 && i != 0))
                    Padding(
                        padding: const EdgeInsets.only(bottom: 12, top: 12),
                        child: VerticalDivider(
                          width: 1.1,
                          color: Theme.of(context).canvasColor,
                          thickness: 3,
                        ))
                ],
              );
            }),
          ),
        ]),
      ),
    );
  }
}
