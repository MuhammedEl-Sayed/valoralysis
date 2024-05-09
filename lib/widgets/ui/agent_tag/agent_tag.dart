import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_icon.dart';

class AgentTag extends StatelessWidget {
  const AgentTag({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    String userName = userProvider.user.name;
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: true);

    return contentProvider.matchDetails.isNotEmpty
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
              child: AgentIcon(
                iconUrl: HistoryUtils.getContentImageFromId(
                    AgentUtils.extractAgentIdByPUUID(
                        contentProvider.matchDetails[0],
                        userProvider.user.puuid),
                    contentProvider.agents),
              ),
            )),
            const Padding(
              padding: EdgeInsets.only(left: 17),
            ),
            Text(
              userName,
              style: const TextStyle(fontSize: 20),
            )
          ])
        : const SizedBox.shrink();
  }
}
