import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_icon.dart';

class AgentCarouselSelector extends StatefulWidget {
  final Map<String, String> playerTeamPUUIDToAgentUUID;
  final Map<String, String> enemyTeamPUUIDToAgentUUID;
  final Function(String) onPUUIDSelected;
  final String puuid;

  const AgentCarouselSelector({
    Key? key,
    required this.playerTeamPUUIDToAgentUUID,
    required this.enemyTeamPUUIDToAgentUUID,
    required this.onPUUIDSelected,
    required this.puuid,
  }) : super(key: key);

  @override
  _AgentCarouselSelectorState createState() => _AgentCarouselSelectorState();
}

class _AgentCarouselSelectorState extends State<AgentCarouselSelector> {
  @override
  Widget build(BuildContext context) {
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);

    return Container(
      color: Theme.of(context).canvasColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: [
              _buildAgentRow(
                context,
                widget.playerTeamPUUIDToAgentUUID,
                contentProvider,
                ThemeColors().green.withOpacity(0.4),
              ),
              const SizedBox(height: 10), // Spacing between the rows
              _buildAgentRow(
                context,
                widget.enemyTeamPUUIDToAgentUUID,
                contentProvider,
                ThemeColors().red.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgentRow(
    BuildContext context,
    Map<String, String> teamPUUIDToAgentUUID,
    ContentProvider contentProvider,
    Color gradientColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [gradientColor, Colors.transparent],
        ),
      ),
      child: Row(
        children: teamPUUIDToAgentUUID.entries.map((entry) {
          return GestureDetector(
            onTap: () {
              widget.onPUUIDSelected(entry.key);
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: AgentIcon(
                    width: 30,
                    height: 30,
                    iconUrl: AgentUtils.getImageFromAgentId(
                        entry.value, contentProvider.agents),
                  ),
                ),
                Visibility(
                  visible: entry.key == widget.puuid,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                          Colors.transparent
                        ],
                      ),
                    ),
                    child: const SizedBox(width: 30, height: 30),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
