import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/utils/table_utils.dart';

class CustomDataColumnLabel extends StatelessWidget {
  final String label;
  final double width;

  CustomDataColumnLabel({required this.label, this.width = 25});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 30, maxWidth: 50),
      child: Text(label),
    );
  }
}

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
                child: DataTable(
                    dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      return isUserTeam
                          ? const Color(0xff2BD900).withOpacity(0.2)
                          : const Color(0xff730000)
                              .withOpacity(0.2); // Use the default value.
                    }),
                    headingRowHeight: 26,
                    columns: <DataColumn>[
                      DataColumn(
                        label: CustomDataColumnLabel(
                            label: isUserTeam ? 'Your team' : 'Enemy team'),
                      ),
                      DataColumn(
                        label: CustomDataColumnLabel(label: 'ACS'),
                      ),
                      DataColumn(
                        label: CustomDataColumnLabel(label: 'KD'),
                      ),
                      DataColumn(
                        label: CustomDataColumnLabel(label: 'K'),
                      ),
                      DataColumn(
                        label: CustomDataColumnLabel(label: 'D'),
                      ),
                      DataColumn(
                        label: CustomDataColumnLabel(label: 'A'),
                      ),
                      DataColumn(
                        label: CustomDataColumnLabel(label: 'ADR'),
                      ),
                      DataColumn(
                        label: CustomDataColumnLabel(label: 'HS%'),
                      ),
                    ],
                    rows: playerDataRows),
              ),
            ),
          ),
        ]);
      },
    );
  }
}
