import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/utils/table_utils.dart';
import 'package:valoralysis/widgets/ui/team_details_table/team_table_cell.dart';

class Gunfights extends StatelessWidget {
  final String puuid;
  final MatchDto matchDetail;

  const Gunfights({Key? key, required this.puuid, required this.matchDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);
    List<List<Widget>> playerDataRows = TableUtils.buildGunfightDataRows(
        matchDetail, puuid, contentProvider.content);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return ClipRect(
        child: StickyHeadersTable(
          showHorizontalScrollbar: false,
          showVerticalScrollbar: false,
          columnsLength: 2,
          rowsLength: 5,
          legendCell: TeamTableCell.legend(
              backgroundColor: Theme.of(context).canvasColor,
              const Text('Gunfights')),
          columnsTitleBuilder: (int index) {
            String title;
            switch (index) {
              case 0:
                title = 'K-D';
                break;
              default:
                title = '';
            }
            return TeamTableCell.stickyColumn(
                hasBorder: false,
                backgroundColor: Theme.of(context).canvasColor,
                Text(title));
          },
          rowsTitleBuilder: (int index) {
            return playerDataRows[index][0];
          },
          contentCellBuilder: (int columnIndex, int rowIndex) {
            return playerDataRows[rowIndex].sublist(1)[columnIndex];
          },
        ),
      );
    });
  }
}
