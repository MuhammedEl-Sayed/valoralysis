import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/consts/margins.dart';
import 'package:valoralysis/consts/mock_data.dart';
import 'package:valoralysis/models/item.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/providers/mode_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/utils/time.dart';
import 'package:valoralysis/widgets/ui/history_list/history_section_title/history_section_title.dart';
import 'package:valoralysis/widgets/ui/history_list/history_tile/history_tile.dart';
import 'package:valoralysis/widgets/ui/mode_dropdown/mode_dropdown.dart';

class HistoryList extends StatefulWidget {
  final bool fake;

  const HistoryList({Key? key, this.fake = false}) : super(key: key);
  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  Item? selectedMode;

  @override
  void initState() {
    super.initState();
    ModeProvider modeProvider =
        Provider.of<ModeProvider>(context, listen: false);
    selectedMode = modeProvider.modes.first;
  }

  @override
  Widget build(BuildContext context) {
    ModeProvider modeProvider =
        Provider.of<ModeProvider>(context, listen: true);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.fake ? getMockData() : null,
      builder: (context, snapshot) {
        List<MatchDto> relevantMatches = [];
        List<MatchDto> filterMatches() {
          return userProvider.user.matchDetailsMap.values
              .where((matchDetail) =>
                  HistoryUtils.extractGamemode(matchDetail, modeProvider.modes)
                      .realValue ==
                  selectedMode!.realValue)
              .toList();
        }

        if (snapshot.connectionState == ConnectionState.waiting &&
            userProvider.user.matchDetailsMap.isNotEmpty) {
          filterMatches();
        } else if (snapshot.hasData &&
            widget.fake &&
            userProvider.user.matchDetailsMap.isEmpty) {
          relevantMatches = (snapshot.data as List)
              .map((item) => MatchDto.fromJson(item))
              .toList();
        } else {
          relevantMatches = filterMatches();
        }

        Map<String, List<MatchDto>> matchesByDay =
            TimeUtils.buildMatchesByDayMap(relevantMatches);

        double margin = getStandardMargins(context);

        if (matchesByDay.isEmpty) {
          return Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: margin / 2),
                child: ModeDropdown(
                  key: UniqueKey(),
                  selectedMode: selectedMode as Item,
                  onModeSelected: (Item mode) {
                    setState(() {
                      selectedMode = mode;
                    });
                  },
                  modes: modeProvider.modes,
                ),
              ));
        } else {
          return Expanded(
            child: ListView.builder(
              itemCount: matchesByDay.length,
              itemBuilder: (context, index) {
                String key = matchesByDay.keys.elementAt(index);
                return Column(children: [
                  HistorySectionTitle(
                      key: UniqueKey(),
                      numOfMatches: matchesByDay[key]!.length,
                      dateTitle: key,
                      hasDropdown: index == 0 ? true : false,
                      selectedMode: selectedMode as Item,
                      onModeSelected: (Item mode) {
                        setState(() {
                          selectedMode = mode;
                        });
                      }),
                  Column(
                    children: matchesByDay[key]!
                        .map<Widget>((matchDetail) => HistoryTile(
                            matchDetail: matchDetail, fake: widget.fake))
                        .toList(),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                  )
                ]);
              },
            ),
          );
        }
      },
    );
  }
}
