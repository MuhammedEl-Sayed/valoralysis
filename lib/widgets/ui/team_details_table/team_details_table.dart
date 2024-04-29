import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/utils/table_utils.dart';

class TeamDetailsTable extends StatelessWidget {
  final String puuid;
  final Map<String, dynamic> matchDetail;
  final bool isUserTeam;

  TeamDetailsTable(
      {required this.puuid,
      required this.matchDetail,
      required this.isUserTeam});
//! DONT FORGET TO MAKE FORK OF MATERIAL FOR THE DATATABLE OVERRIDE
  @override
  Widget build(BuildContext context) {
    //So we need DataRows,
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);
    List<DataRow> playerDataRows = TableUtils.buildPlayerDataRows(
        matchDetail, puuid, contentProvider.ranks, contentProvider.agents);

    return Stack(children: [
      Container(
        height: 26,
        color: Theme.of(context).canvasColor,
      ),
      DataTable(
          headingRowHeight: 26,
          columns: <DataColumn>[
            DataColumn(
                label: Expanded(
              child: Text(isUserTeam ? 'Your team' : 'Enemy team'),
            )),
            const DataColumn(
                label: Expanded(
              child: Text('ACS'),
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
          rows: playerDataRows)
    ]);
  }
}
