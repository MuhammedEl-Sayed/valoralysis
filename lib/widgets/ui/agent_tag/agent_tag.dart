import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_icon.dart';

class AgentTag extends StatelessWidget {
  final bool fake;
  const AgentTag({super.key, this.fake = false});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    String userName = userProvider.user.name;
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: true);

    return (contentProvider.matchDetails.isNotEmpty || fake)
        ? Row(children: [
            ClipOval(
                child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              child: fake
                  ? AgentIcon(
                      iconUrl: HistoryUtils.getContentImageFromId(
                          AgentUtils.extractAgentIdByPUUID(
                              contentProvider.matchDetails[0],
                              userProvider.user.puuid),
                          contentProvider.agents),
                    )
                  : const SizedBox.shrink(),
            )),
            const Padding(
              padding: EdgeInsets.only(left: 17),
            ),
            fake
                ? Text(
                    userName,
                    style: const TextStyle(fontSize: 20),
                  )
                : const Text('Fake User', style: TextStyle(fontSize: 20)),
          ])
        : const SizedBox.shrink();
  }
}
