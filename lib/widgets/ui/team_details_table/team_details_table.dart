import 'package:flutter/material.dart' hide DataColumn, DataRow, DataTable;
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/utils/table_utils.dart';
import 'package:valoralysis/widgets/ui/data_table/data_table.dart';

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
    //So we need DataRows,
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);
    List<DataRow> playerDataRows = TableUtils.buildPlayerDataRows(matchDetail,
        puuid, contentProvider.ranks, contentProvider.agents, isUserTeam);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(children: [
          Container(
            width: constraints.maxWidth,
            height: 26,
            color: Theme.of(context).canvasColor,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ClipRect(
                child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Row(children: [
                      DataTable(
                        columnSpacing: 10,
                        dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            return isUserTeam
                                ? const Color(0xff2BD900).withOpacity(0.2)
                                : const Color(0xff730000).withOpacity(0.2);
                          },
                        ),
                        headingRowHeight: 26,
                        columns: <DataColumn>[
                          DataColumn(
                            label:
                                Text(isUserTeam ? 'Your team' : 'Enemy team'),
                          ),
                        ],
                        rows: playerDataRows
                            .map((row) => DataRow(cells: [row.cells[0]]))
                            .toList(),
                      ),
                      DataTable(
                        columnSpacing: 10,
                        dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            return isUserTeam
                                ? const Color(0xff2BD900).withOpacity(0.2)
                                : const Color(0xff730000).withOpacity(0.2);
                          },
                        ),
                        headingRowHeight: 26,
                        dataRowMaxHeight: double.infinity,
                        columns: const <DataColumn>[
                          DataColumn(
                              label: Expanded(
                            child: Text('KAST'),
                          )),
                          DataColumn(
                              label: Expanded(
                            child: Text('KD'),
                          )),
                          DataColumn(
                              label: Expanded(
                            child: Text('K'),
                          )),
                          DataColumn(
                              label: Expanded(
                            child: Text('D'),
                          )),
                          DataColumn(
                              label: Expanded(
                            child: Text('A'),
                          )),
                          DataColumn(
                              label: Expanded(
                            child: Text('ADR'),
                          )),
                          DataColumn(
                              label: Expanded(
                            child: Text('HS%'),
                          )),
                        ],
                        rows: playerDataRows
                            .map((row) => DataRow(cells: row.cells.sublist(1)))
                            .toList(),
                      ),
                    ]))),
          ),
        ]);
      },
    );
  }
}
