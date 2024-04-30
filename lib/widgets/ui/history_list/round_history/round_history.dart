import 'dart:math';

import 'package:flutter/material.dart';
import 'package:valoralysis/consts/round_result.dart';
import 'package:valoralysis/utils/history_utils.dart';

class RoundHistory extends StatelessWidget {
  final String puuid;
  final Map<String, dynamic> matchDetail;

  RoundHistory({required this.puuid, required this.matchDetail});

  Widget resultToImageMap(
      bool playerTeam, String result, BuildContext context) {
    String baseUrl = 'assets/images/round_result/';
    String imageSuffix = playerTeam ? '_win.png' : '_loss.png';
    String imageName;

    switch (result) {
      case (eliminated):
        imageName = 'elimination';
        break;
      case (bombDefused):
        imageName = 'diffuse';
        break;
      case (bombDetonated):
        imageName = 'explosion';
        break;
      case (roundTimerExpired):
        imageName = 'time';
        break;
      default:
        return SizedBox(
          width: 22.0,
          height: 22.0,
          child: Center(
            child: Container(
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
    }

    return Container(
      width: 22.0,
      height: 22.0,
      child: Image.asset('$baseUrl$imageName$imageSuffix'),
    );
  }

  @override
  Widget build(BuildContext context) {
    //First we'll find how many rounds were played
    Map<String, dynamic> roundResults =
        HistoryUtils.extractRoundResultPerTeam(matchDetail, puuid);
    String userTeam =
        HistoryUtils.extractTeamFromPUUID(matchDetail, puuid)['teamId'];
    int lastRound = max(
        roundResults['Your Team'].length, roundResults['Enemy Team'].length);

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
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 16),
          child: Row(children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('Your Team'), Text("Enemy Team")],
            ),
            Row(
              children: List.generate(lastRound, (i) {
                return Column(
                  children: [
                    resultToImageMap(
                        true,
                        i < roundResults['Your Team'].length
                            ? roundResults['Your Team'][i]['roundResult']
                            : null,
                        context),
                    resultToImageMap(
                        false,
                        i < roundResults['Enemy Team'].length
                            ? roundResults['Enemy Team'][i]['roundResult']
                            : null,
                        context),
                    Text((i + 1).toString()),
                  ],
                );
              }),
            ),
          ]),
        ),
      ),
    );
  }
}
