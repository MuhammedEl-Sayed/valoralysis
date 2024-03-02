import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/api/services/history_service.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/models/match_history.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/analysis/weapons_analysis.dart';
import 'package:valoralysis/utils/history.dart';
import 'package:valoralysis/widgets/ui/queue_type_selector.dart';
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
            child: Column(children: [
          QueueTypeSelector(),
          FilledButton(
            onPressed: () async {
              List<MatchHistory> matchHistories =
                  await HistoryService.getMatchListByPuuid(
                      userProvider.user.puuid);

              List<Map<String, dynamic>> matchDetails =
                  await HistoryService.getAllMatchDetails(
                      HistoryUtils.extractMatchIDs(matchHistories));

              print(await WeaponsAnalysis.weaponsHeadshotAccuracyAnaylsis(
                  matchDetails, userProvider.user.puuid));
              print(await WeaponsAnalysis.weaponsKillsFrequencyAnalysis(
                  matchDetails, userProvider.user.puuid));
            },
            child: const Text('Match History'),
          )
        ]))
      ]),
    );
  }
}
