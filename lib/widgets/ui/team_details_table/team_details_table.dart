import 'package:flutter/material.dart' hide DataColumn, DataRow, DataTable;
import 'package:provider/provider.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/table_utils.dart';
import 'package:valoralysis/widgets/ui/team_details_table/team_table_cell.dart';

class TeamDetailsTable extends StatelessWidget {
  final String puuid;
  final Map<String, dynamic> matchDetail;
  final bool isUserTeam;

  const TeamDetailsTable(
      {super.key,
      required this.puuid,
      required this.matchDetail,
      required this.isUserTeam});
  //! DONT FORGET TO MAKE FORK OF MATERIAL FOR THE DATATABLE OVERRIDE
  @override
  Widget build(BuildContext context) {
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    List<List<Widget>> playerDataRows = TableUtils.buildPlayerDataRows(
        matchDetail,
        puuid,
        contentProvider.content,
        isUserTeam,
        userProvider.user.puuid);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ClipRect(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth, maxHeight: 45 * 5.0 + 26.0),
                child: StickyHeadersTable(
                  showHorizontalScrollbar: false,
                  showVerticalScrollbar: false,
                  columnsLength: 8,
                  cellAlignments: const CellAlignments.fixed(
                      contentCellAlignment: Alignment.center,
                      stickyColumnAlignment: Alignment.centerLeft,
                      stickyRowAlignment: Alignment.center,
                      stickyLegendAlignment: Alignment.center),
                  cellDimensions: const CellDimensions.variableRowHeight(
                    contentCellWidth: 50.0,
                    rowHeights: [45.0, 45.0, 45.0, 45.0, 45.0],
                    stickyLegendWidth: 150.0,
                    stickyLegendHeight: 26.0,
                  ),
                  rowsLength: 5,
                  legendCell: TeamTableCell.stickyColumn(
                      hasBorder: false,
                      backgroundColor: Theme.of(context).canvasColor,
                      Text(isUserTeam ? 'Your team' : 'Enemy team')),
                  columnsTitleBuilder: (int index) {
                    String title;
                    switch (index) {
                      case 0:
                        title = 'KAST';
                        break;
                      case 1:
                        title = 'KD';
                        break;
                      case 2:
                        title = 'K';
                        break;
                      case 3:
                        title = 'D';
                        break;
                      case 4:
                        title = 'A';
                        break;
                      case 5:
                        title = 'T';
                        break;
                      case 6:
                        title = 'ADR';
                        break;
                      case 7:
                        title = 'HS%';
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
                )));
      },
    );
  }
}
