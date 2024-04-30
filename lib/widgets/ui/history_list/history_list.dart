import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/mode_provider.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/utils/time.dart';
import 'package:valoralysis/widgets/ui/history_list/history_section_title/history_section_title.dart';
import 'package:valoralysis/widgets/ui/history_list/history_tile/history_tile.dart';

class HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ModeProvider modeProvider =
        Provider.of<ModeProvider>(context, listen: true);
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: true);

    List<Map<String, dynamic>> relevantMatches = contentProvider.matchDetails
        .where((matchDetail) =>
            HistoryUtils.extractGamemode(matchDetail, modeProvider.modes)
                .realValue ==
            modeProvider.selectedMode)
        .toList();

    Map<String, dynamic> matchesByDay =
        TimeUtils.buildMatchesByDayMap(relevantMatches);

    return Expanded(
      child: ListView.builder(
        itemCount: matchesByDay.length,
        itemBuilder: (context, index) {
          String key = matchesByDay.keys.elementAt(index);
          return Column(children: [
            HistorySectionTitle(
                numOfMatches: matchesByDay[key].length,
                dateTitle: key,
                hasDropdown: index == 0 ? true : false),
            Column(
              children: matchesByDay[key]
                  .map<Widget>(
                      (matchDetail) => HistoryTile(matchDetail: matchDetail))
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
}
