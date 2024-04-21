import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/utils/map_utils.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_icon.dart';

class HistoryTile extends StatefulWidget {
  final Map<String, dynamic> matchDetails;

  const HistoryTile({Key? key, required this.matchDetails}) : super(key: key);

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    ContentProvider contentProvider = Provider.of<ContentProvider>(context);

    return Consumer2<UserProvider, ContentProvider>(
        builder: (context, userProvider, contentProvider, child) {
      return Container(
          child: Row(children: [
        AgentIcon(
          iconUrl: HistoryUtils.getContentImageFromId(
              AgentUtils.extractAgentIconByPUUID(
                  widget.matchDetails, userProvider.user.puuid),
              contentProvider.agents),
        ),
        Column(
          children: [
            Text(MapUtils.getMapNameFromPath(
                    MapUtils.extractMapPath(widget.matchDetails),
                    contentProvider.maps) ??
                ''),
            Text(DateTime.fromMillisecondsSinceEpoch(
                    HistoryUtils.extractStartTime(widget.matchDetails))
                .toString())
          ],
        )
      ]));
    });
  }
}
