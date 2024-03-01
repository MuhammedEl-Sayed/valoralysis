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
            print(await HistoryService.getMatchListByPuuid(
                userProvider.user.puuid));
          },
          child: const Text('Match History'),
        )))
      ]),
    );
  }
}
