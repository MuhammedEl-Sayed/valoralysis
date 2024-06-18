import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:valoralysis/api/services/history_service.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/models/match_history.dart';
import 'package:valoralysis/providers/category_provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/user_utils.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_tag.dart';
import 'package:valoralysis/widgets/ui/history_list/history_list.dart';
import 'package:valoralysis/widgets/ui/toast/toast.dart';

class HomeScreen extends StatefulWidget with RouteAware {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void>? _loadingFuture;
  bool _isLoadingMore = false;
  int _currentBatch = 0;
  List<MatchHistory> matchList = [];
  bool showToast = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadingFuture = _loadData();
  }

  Future<void> _fetchAndUpdateMatches(UserProvider userProvider,
      List<MatchHistory> matchList, int start, int end) async {
    var futures = matchList.sublist(start, end).map((match) async {
      var details =
          await HistoryService.getMatchDetailsByMatchID(match.matchID);
      return MapEntry(match.matchID, details);
    });
    var entries = await Future.wait(futures);
    Map<String, MatchDto> matchHistoryDetailsMap = Map.fromEntries(entries);
    await userProvider.updateStoredMatches(matchHistoryDetailsMap);
  }

  Future<void> _loadData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user.puuid == '') {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      return;
    }
    try {
      matchList =
          await HistoryService.getMatchListByPuuid(userProvider.user.puuid);
      if (userProvider.user.matchDetailsMap.isNotEmpty) {
        matchList.removeWhere((match) =>
            userProvider.user.matchDetailsMap.containsKey(match.matchID));
      }
      await _fetchAndUpdateMatches(userProvider, matchList, 0, 20);
      await userProvider.updateName(UserUtils.getUsername(
          userProvider.user.matchDetailsMap.values.toList()[0],
          userProvider.user.puuid));
      _currentBatch = 1;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore) return;
    setState(() {
      _isLoadingMore = true;
    });

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    try {
      List<MatchHistory> newMatchList =
          await HistoryService.getMatchListByPuuid(userProvider.user.puuid);
      int start = _currentBatch * 20;
      int end = start + 20;

      if (start >= newMatchList.length) {
        setState(() {
          _isLoadingMore = false;
          showToast = true;
          errorMessage = 'No more matches to load.';
        });

        Timer(const Duration(seconds: 4), () {
          setState(() {
            showToast = false;
          });
        });
        return;
      }

      await _fetchAndUpdateMatches(userProvider, newMatchList, start, end);
      setState(() {
        _currentBatch++;
      });
    } catch (e) {
      print(e);
      setState(() {
        showToast = true;
        errorMessage =
            'Unable to find new matches. Either you have no new matches or there was an error. Try again later.';
      });

      Timer(const Duration(seconds: 4), () {
        setState(() {
          showToast = false;
        });
      });
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _loadingFuture,
        builder: (context, snapshot) {
          UserProvider userProvider =
              Provider.of<UserProvider>(context, listen: false);
          bool showSkeleton = userProvider.user.matchDetailsMap.isEmpty;

          if (snapshot.connectionState == ConnectionState.waiting &&
              showSkeleton) {
            return Skeletonizer(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: const AgentTag(fake: true),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        const HistoryList(fake: true),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return SafeArea(
              child: Consumer2<CategoryTypeProvider, ContentProvider>(
                builder:
                    (context, categoryTypeProvider, contentProvider, child) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height,
                      ),
                      child: Stack(children: [
                        Column(
                          children: [
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.05,
                              ),
                              child: const AgentTag(),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            HistoryList(
                              onScroll: _loadMoreData,
                              isLoadingMore: _isLoadingMore,
                            ),
                          ],
                        ),
                        Toast(
                          errorMessage: errorMessage,
                          show: showToast,
                          type: ToastTypes.info,
                        ),
                      ]),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
