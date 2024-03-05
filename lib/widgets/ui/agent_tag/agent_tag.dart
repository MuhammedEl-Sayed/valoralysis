import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/analysis/agent_analysis.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_icon.dart';

class AgentTag extends StatefulWidget {
  const AgentTag({Key? key}) : super(key: key);

  @override
  _AgentTagState createState() => _AgentTagState();
}

class _AgentTagState extends State<AgentTag> {
  Future<String?>? _iconUrlFuture;

  @override
  void initState() {
    super.initState();

    _iconUrlFuture = _getIconUrl(context);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    String userName = userProvider.user.name;

    return FutureBuilder(
      future: _iconUrlFuture,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Row(children: [
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
                iconUrl: snapshot.data,
              ),
            )),
            Text(userName)
          ]);
        }
      },
    );
  }

  Future<String?> _getIconUrl(BuildContext context) async {
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final topAgent = AgentAnalysis.findTopAgent(contentProvider.matchDetails,
        userProvider.user.puuid, contentProvider.agents);

    try {
      final agent =
          contentProvider.agents.firstWhere((agent) => agent.name == topAgent);
      return agent.iconUrl;
    } catch (e) {
      // Handle the case where no matching agent is found
      return null;
    }
  }
}
