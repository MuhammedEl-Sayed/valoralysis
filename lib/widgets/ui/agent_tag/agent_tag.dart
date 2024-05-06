import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/utils/analysis/agent_analysis.dart';

class AgentTag extends StatefulWidget {
  final bool loading;
  const AgentTag({Key? key, this.loading = false}) : super(key: key);
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

    return Row(children: [
      const Padding(
        padding: EdgeInsets.only(left: 17),
      ),
      Text(
        userName,
        style: const TextStyle(fontSize: 20),
      )
    ]);
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
