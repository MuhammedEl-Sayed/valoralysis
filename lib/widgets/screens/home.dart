import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:valoralysis/api/services/history_service.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/models/match_history.dart';
import 'package:valoralysis/providers/category_provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_provider.dart';
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

  void _showToast(String message, ToastTypes type) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case ToastTypes.error:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
      case ToastTypes.success:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      case ToastTypes.info:
        backgroundColor = Colors.blue;
        textColor = Colors.white;
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
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
      _showToast('Added $end new matches to your history.', ToastTypes.success);
    } catch (e) {
      _showToast(
          'Unable to load matches. Either you have no matches or there was an error. Try again later.',
          ToastTypes.error);
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
      var timeoutDuration =
          const Duration(seconds: 8); // Adjust timeout duration as needed
      await Future.any([
        HistoryService.getMatchListByPuuid(userProvider.user.puuid),
        Future.delayed(timeoutDuration).then((_) {
          throw TimeoutException('Loading more data took too long');
        }),
      ]).then((results) async {
        List<MatchHistory> newMatchList = results;

        if (userProvider.user.matchDetailsMap.isNotEmpty) {
          newMatchList.removeWhere((match) =>
              userProvider.user.matchDetailsMap.containsKey(match.matchID));
        }

        int start = 0;
        int end = min(start + pageSize, newMatchList.length);
        print('_currentBatch: $_currentBatch');
        print('start: $start');
        print('end: $end');
        print('newMatchList.length: ${newMatchList.length}');

        if (start >= end || newMatchList.isEmpty) {
          setState(() {
            _isLoadingMore = false;
          });
          _showToast('No more matches to load.', ToastTypes.info);
          return;
        }

        await _fetchAndUpdateMatches(userProvider, newMatchList, start, end);
        setState(() {
          _currentBatch++;
        });
        _showToast(
            'Added $end new matches to your history.', ToastTypes.success);
      });
    } on TimeoutException catch (e) {
      _showToast('Timeout: Unable to load more matches. Try again later.',
          ToastTypes.error);
      print('Timeout: Unable to load more matches. Try again later.');
    } catch (e) {
      print(e);
      _showToast(
          'Unable to load more matches. Try again later.', ToastTypes.error);
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
                          child: Column(
                            children: [
                              const Padding(padding: EdgeInsets.only(top: 20)),
                              Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.05,
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
                          )));
                },
              ),
            );
          }
        },
      ),
    );
  }
}
