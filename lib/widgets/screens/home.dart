import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/api/services/history_service.dart';
import 'package:valoralysis/api/services/weapons_service.dart';
import 'package:valoralysis/consts/queue_types.dart';
import 'package:valoralysis/consts/shards.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/analysis/weapons_analysis.dart';
import 'package:valoralysis/utils/history.dart';
import 'package:valoralysis/widgets/ui/sidebar/sidebar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const ColorScheme.dark().background,
      body: Row(children: [
        Sidebar(),
        Expanded(
            child: Center(
                child: FilledButton(
          onPressed: () async {
            await WeaponsService.fetchWeaponData();
            final matchHistory =
                await HistoryService.fetchMatchHistoryInIncrements(
                    ShardsHelper.getValue(Shards.NA),
                    0,
                    25,
                    QueueTypesHelper.getValue(QueueTypes.COMPETITIVE),
                    userProvider.user.authInfo,
                    userProvider.user.puuid);
            final matchDetails = await HistoryService.fetchAllMatchDetails(
                ShardsHelper.getValue(Shards.NA),
                HistoryUtils.extractMatchIDs(matchHistory),
                userProvider.user.authInfo);
            print('Length match details: + ${matchDetails.length}');

            final headshotAccuracyAnalysis =
                await WeaponsAnalysis.weaponsHeadshotAccuracyAnaylsis(
                    matchDetails, userProvider.user.puuid);

            print('Headshot accuracy: $headshotAccuracyAnalysis');

            final weaponsKillsFrequencyAnalysis =
                await WeaponsAnalysis.weaponsKillsFrequencyAnalysis(
                    matchDetails, userProvider.user.puuid);
            print('Weapon frequency: $weaponsKillsFrequencyAnalysis');
          },
          child: const Text('Match History'),
        )))
      ]),
    );
  }
}
