import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:valoralysis/api/services/history_service.dart';
import 'package:valoralysis/models/match_history.dart';
import 'package:valoralysis/providers/category_provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/user_utils.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_tag.dart';
import 'package:valoralysis/widgets/ui/history_list/history_list.dart';

class HomeScreen extends StatefulWidget with RouteAware {
  const HomeScreen({super.key});

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

    if (userProvider.user.puuid == '') {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      return;
    }

    List<MatchHistory> matchList =
        await HistoryService.getMatchListByPuuid(userProvider.user.puuid);
    // This chunk should be its own function
    var futures = matchList.map((match) async {
      var details =
          await HistoryService.getMatchDetailsByMatchID(match.matchID);
      return MapEntry(match.matchID, details);
    });
    var entries = await Future.wait(futures);

    Map<String, dynamic> matchHistoryDetailsMap = Map.fromEntries(entries);

    userProvider.updateStoredMatches(matchHistoryDetailsMap);

    userProvider.updateName(UserUtils.getUsername(
        userProvider.user.matchDetails.values.toList()[0],
        userProvider.user.puuid));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadingFuture,
      builder: (context, snapshot) {
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        bool showSkeleton = userProvider.user.matchDetails.isEmpty;

        if (snapshot.connectionState == ConnectionState.waiting &&
            showSkeleton) {
          return Skeletonizer(
            child: SafeArea(
                child: SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height),
                        child: Column(children: [
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.05),
                              child: const AgentTag(fake: true)),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          const HistoryList(fake: true)
                        ])))),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              body: Consumer2<CategoryTypeProvider, ContentProvider>(
                builder:
                    (context, categoryTypeProvider, contentProvider, child) {
                  return SingleChildScrollView(
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height),
                          child: Column(children: [
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05),
                                child: const AgentTag()),
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            const HistoryList(),
                            const Padding(
                                padding: EdgeInsets.only(bottom: 130)),
                          ])));
                },
              ),
            ),
          );
        }
      },
    );
  }
}
