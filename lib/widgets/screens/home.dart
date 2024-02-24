import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/api/services/history_service.dart';
import 'package:valoralysis/consts/queue_types.dart';
import 'package:valoralysis/consts/shards.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/widgets/ui/sidebar/sidebar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: ColorScheme.dark().background,
      body: Row(children: [
        Sidebar(),
        Expanded(
            child: Center(
                child: FilledButton(
          onPressed: () async {
            HistoryService.fetchMatchHistory(
                ShardsHelper.getValue(Shards.NA),
                0,
                200000000,
                QueueTypesHelper.getValue(QueueTypes.COMPETITIVE),
                userProvider.user.authInfo,
                userProvider.user.puuid);
          },
          child: const Text('Match History'),
        )))
      ]),
    );
  }
}
