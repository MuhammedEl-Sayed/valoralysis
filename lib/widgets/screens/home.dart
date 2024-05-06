import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:valoralysis/api/services/content_service.dart';
import 'package:valoralysis/api/services/history_service.dart';
import 'package:valoralysis/providers/category_provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/user_utils.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_tag.dart';
import 'package:valoralysis/widgets/ui/history_list/history_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  Future<void>? _loadingFuture;

  @override
  void initState() {
    super.initState();

    _loadingFuture = _loadData();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _loadData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);
    if (userProvider.user.puuid == '') {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      return;
    }
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
    super.build(context);
    return FutureBuilder(
      future: _loadingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Skeletonizer(
            child: SafeArea(
              child: Consumer2<CategoryTypeProvider, ContentProvider>(
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
                                child: const AgentTag(loading: true)),
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            HistoryList()
                          ])));
                },
              ),
            ),
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
                            HistoryList()
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
