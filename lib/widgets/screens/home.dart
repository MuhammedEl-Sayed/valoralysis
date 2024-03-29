import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/api/services/content_service.dart';
import 'package:valoralysis/api/services/history_service.dart';
import 'package:valoralysis/api/services/rank_service.dart';

import 'package:valoralysis/providers/category_provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/rank_utils.dart';
import 'package:valoralysis/utils/user_utils.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_tag.dart';

import 'package:valoralysis/widgets/ui/category_selector/category_selector.dart';
import 'package:valoralysis/widgets/ui/mode_selector/mode_selector.dart';
import 'package:valoralysis/widgets/ui/rank_tile/rank_tile.dart';
import 'package:valoralysis/widgets/ui/sidebar/sidebar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void>? _loadingFuture;

  @override
  void initState() {
    super.initState();
    _loadingFuture = _loadData();
  }

  Future<void> _loadData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);

    contentProvider.updateContent(await ContentService.fetchContent());

    contentProvider.updateMatchHistory(
        await HistoryService.getMatchListByPuuid(userProvider.user.puuid));

    List<Map<String, dynamic>> matchDetails =
        await HistoryService.getAllMatchDetails(contentProvider.matchHistory);

    contentProvider.updateMatchDetails(matchDetails);

    userProvider.updateName(
        UserUtils.getUsername(matchDetails[0], userProvider.user.puuid));
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);
    return FutureBuilder(
      future: _loadingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Consumer2<CategoryTypeProvider, ContentProvider>(
              builder: (context, categoryTypeProvider, contentProvider, child) {
                return Row(children: [
                  Sidebar(),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(children: [
                            const Padding(padding: EdgeInsets.only(top: 40)),
                            const AgentTag(),
                            const Padding(padding: EdgeInsets.only(top: 40)),
                            CategoryTypeSelector(),
                            const Padding(padding: EdgeInsets.only(top: 35)),
                            ModeSelector(),
                            const Padding(padding: EdgeInsets.only(top: 35)),
                            RankTile(),
                            const Padding(padding: EdgeInsets.only(top: 300)),
                            FilledButton(
                              onPressed: () async {},
                              child: const Text('Match History'),
                            )
                          ])))
                ]);
              },
            ),
          );
        }
      },
    );
  }
}
