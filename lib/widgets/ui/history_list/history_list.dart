import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/consts/margins.dart';
import 'package:valoralysis/consts/mock_data.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/providers/mode_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/utils/time.dart';
import 'package:valoralysis/widgets/ui/history_list/history_section_title/history_section_title.dart';
import 'package:valoralysis/widgets/ui/history_list/history_tile/history_tile.dart';
import 'package:valoralysis/widgets/ui/mode_dropdown/mode_dropdown.dart';

class HistoryList extends StatelessWidget {
  final bool fake;

  const HistoryList({Key? key, this.fake = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ModeProvider modeProvider =
        Provider.of<ModeProvider>(context, listen: true);

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fake ? getMockData() : null,
      builder: (context, snapshot) {
        List<MatchDto> relevantMatches = [];

        List<MatchDto> filterMatches() {
          return userProvider.user.matchDetailsMap.values
              .where((matchDetail) =>
                  HistoryUtils.extractGamemode(matchDetail, modeProvider.modes)
                      .realValue ==
                  modeProvider.selectedMode)
              .toList();
        }

        if (snapshot.connectionState == ConnectionState.waiting &&
            userProvider.user.matchDetailsMap.isNotEmpty) {
          filterMatches();
        } else if (snapshot.hasData &&
            fake &&
            userProvider.user.matchDetailsMap.isEmpty) {
          relevantMatches = snapshot.data! as List<MatchDto>;
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
                child: const ModeDropdown(),
              ));
        } else {
          return Expanded(
            child: ListView.builder(
              itemCount: matchesByDay.length,
              itemBuilder: (context, index) {
                String key = matchesByDay.keys.elementAt(index);
                return Column(children: [
                  HistorySectionTitle(
                      numOfMatches: matchesByDay[key]!.length,
                      dateTitle: key,
                      hasDropdown: index == 0 ? true : false),
                  Column(
                    children: matchesByDay[key]!
                        .map<Widget>((matchDetail) =>
                            HistoryTile(matchDetail: matchDetail, fake: fake))
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
