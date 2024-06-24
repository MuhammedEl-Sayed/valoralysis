import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:valoralysis/api/services/history_service.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/models/match_history.dart';
import 'package:valoralysis/providers/category_provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_tag.dart';
import 'package:valoralysis/widgets/ui/history_list/history_list.dart';
import 'package:valoralysis/widgets/ui/toast/toast.dart';

const pageSize = 30;

class HomeScreen extends StatefulWidget with RouteAware {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void>? _loadingFuture;
  bool _isLoadingMore = false;
  int _currentBatch = 1;
  List<MatchHistory> matchList = [];
  bool showToast = false;
  String toastMessage = '';
  ToastTypes toastType = ToastTypes.info;

  @override
  void initState() {
    super.initState();
    _loadingFuture = _loadData();
  }

  Future<void> _fetchAndUpdateMatches(UserProvider userProvider,
      List<MatchHistory> matchList, int start, int end) async {
    if (start >= end || matchList.isEmpty) return;
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
    print('Loading data...');
    try {
      matchList =
          await HistoryService.getMatchListByPuuid(userProvider.user.puuid);
      if (userProvider.user.matchDetailsMap.isNotEmpty) {
        matchList.removeWhere((match) =>
            userProvider.user.matchDetailsMap.containsKey(match.matchID));
      }
      print('Loaded ${matchList.length} new matches.');
      int end = min(pageSize, matchList.length);
      await _fetchAndUpdateMatches(
        userProvider,
        matchList,
        0,
        end,
      );
      print('Updating user name...');
      await userProvider.updateName(HistoryUtils.extractPlayerNameByPUUID(
          userProvider.user.matchDetailsMap.values.first,
          userProvider.user.puuid));

      setState(() {
        showToast = true;
        toastMessage = 'Added $end new matches to your history.';
        toastType = ToastTypes.success;
      });
      print('Loaded $end new matches to history.');
      Timer(const Duration(seconds: 2), () {
        setState(() {
          showToast = false;
        });
      });
    } catch (e) {
      setState(() {
        showToast = true;
        toastMessage =
            'Unable to load matches. Either you have no matches or there was an error. Try again later.';
        toastType = ToastTypes.error;
      });
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
      Timer(const Duration(seconds: 4), () {
        setState(() {
          showToast = false;
        });
      });
      List<MatchHistory> newMatchList =
          await HistoryService.getMatchListByPuuid(userProvider.user.puuid);
      print('_currentBatch: $_currentBatch');
      int start = _currentBatch * pageSize;
      // Adjust end to be the minimum between start+20 and the list's length
      int end = min(
          start + pageSize, newMatchList.length); // Import 'dart:math' for min
      if (userProvider.user.matchDetailsMap.isNotEmpty) {
        newMatchList.removeWhere((match) =>
            userProvider.user.matchDetailsMap.containsKey(match.matchID));
      }
      if (start >= end || newMatchList.isEmpty) {
        setState(() {
          _isLoadingMore = false;
          showToast = true;
          toastMessage = 'No more matches to load.';
          toastType = ToastTypes.info;
        });
        return;
      }

      await _fetchAndUpdateMatches(userProvider, newMatchList, start, end);
      setState(() {
        _currentBatch++;
        showToast = true;
        toastMessage =
            'Added ${newMatchList.length} new matches to your history.';
        toastType = ToastTypes.success;
      });
    } catch (e) {
      print(e);
      setState(() {
        showToast = true;
        toastMessage =
            'Unable to find new matches. Either you have no new matches or there was an error. Try again later.';
        toastType = ToastTypes.error;
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
                              onRefresh: _loadData,
                            ),
                          ],
                        ),
                        Toast(
                          toastMessage: toastMessage,
                          show: showToast,
                          type: toastType,
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
