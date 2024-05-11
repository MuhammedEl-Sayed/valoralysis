import 'package:flutter/material.dart' hide DataColumn, DataRow, DataTable;
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    List<DataRow> playerDataRows = TableUtils.buildPlayerDataRows(
        matchDetail,
        puuid,
        contentProvider.ranks,
        contentProvider.agents,
        isUserTeam,
        userProvider.user.puuid);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ClipRect(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: Stack(children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Stack(children: [
                        Container(
                          width: constraints.maxWidth + 110,
                          height: 26,
                          color: Theme.of(context).canvasColor,
                        ),
                        DataTable(
                            columnSpacing: 20,
                            dataRowColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                return isUserTeam
                                    ? const Color(0xff2BD900).withOpacity(0.2)
                                    : const Color(0xff730000).withOpacity(0.2);
                              },
                            ),
                            headingRowHeight: 26,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text(isUserTeam ? '' : ''),
                              ),
                              const DataColumn(
                                  label: Expanded(
                                child: Text('KAST'),
                              )),
                              const DataColumn(
                                  label: Expanded(
                                child: Text('KD'),
                              )),
                              const DataColumn(
                                  label: Expanded(
                                child: Text('K'),
                              )),
                              const DataColumn(
                                  label: Expanded(
                                child: Text('D'),
                              )),
                              const DataColumn(
                                  label: Expanded(
                                child: Text('A'),
                              )),
                              const DataColumn(
                                  label: Expanded(
                                child: Text('ADR'),
                              )),
                              const DataColumn(
                                  label: Expanded(
                                child: Text('HS%'),
                              )),
                            ],
                            rows: playerDataRows),
                      ])),
                  Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 26,
                        color: Theme.of(context).canvasColor,
                      ),
                      SizedBox(
                        width: 150,
                        child: DataTable(
                          columnSpacing: 10,
                          dataCellPadding: const EdgeInsets.all(0),
                          dataRowColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              return isUserTeam
                                  ? const Color(0xff224015)
                                  : const Color(0xff2e1515);
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
                      ),
                    ],
                  )
                ])));
      },
    );
  }
}
