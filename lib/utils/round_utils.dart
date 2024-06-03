import 'package:flutter/material.dart';
import 'package:valoralysis/consts/round_result.dart';
import 'package:valoralysis/models/player_round_stats.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_icon.dart';
import 'package:valoralysis/widgets/ui/marquee_text/marquee_text.dart';
import 'package:valoralysis/widgets/ui/weapon_silhouette_image/weapon_silhouette_image.dart';

class RoundUtils {
  static Widget resultToImageMap(
      bool playerTeam, String result, BuildContext context) {
    String baseUrl = 'assets/images/round_result/';
    String imageSuffix = playerTeam ? '_win.png' : '_loss.png';
    String imageName;

    switch (result) {
      case (eliminated):
        imageName = 'elimination';
        break;
      case (bombDefused):
        imageName = 'diffuse';
        break;
      case (bombDetonated):
        imageName = 'explosion';
        break;
      case (timeSinceRoundStartMillisrExpired):
        imageName = 'time';
        break;
      default:
        return SizedBox(
          width: 22.0,
          height: 22.0,
          child: Center(
            child: Container(
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
    }

    return SizedBox(
      width: 22.0,
      height: 22.0,
      child: Image.asset('$baseUrl$imageName$imageSuffix'),
    );
  }

  static Widget buildRoundKillFeed(
      String puuid,
      List<KillDto> kills,
      List<KillDto> deaths,
      Map<String, dynamic> matchDetail,
      ContentProvider contentProvider) {
    //add type field to kills and deaths
    List<dynamic> sortedKillsAndDeaths = [
      ...kills.map((kill) => {'type': 'kill', 'data': kill}),
      ...deaths.map((death) => {'type': 'death', 'data': death})
    ];

    sortedKillsAndDeaths.sort((a, b) {
      int aTime = a['data'].timeSinceRoundStartMillis;
      int bTime = b['data'].timeSinceRoundStartMillis;
      return aTime.compareTo(bTime);
    });
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
            children: sortedKillsAndDeaths.map((event) {
          bool isKill = event['type'] == 'kill';
          KillDto kill = event['data'];
          return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AgentIcon(
                    iconUrl: HistoryUtils.getContentImageFromId(
                        AgentUtils.extractAgentIdByPUUID(matchDetail, puuid),
                        contentProvider.agents),
                    small: true,
                  ),
                  SizedBox(
                    width: 70, // Set your desired width here
                    child: MarqueeText(
                        direction: Axis.horizontal,
                        child: Text(
                          HistoryUtils.extractPlayerNameByPUUID(
                              matchDetail, puuid),
                          style: const TextStyle(fontSize: 13),
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      right: 5,
                    ),
                  ),
                  WeaponSilhouetteImage(
                    imageUrl: HistoryUtils.getSilhouetteImageFromId(
                        HistoryUtils.getKillGunId(kill),
                        contentProvider.weapons),
                    height: 40,
                    width: 75,
                    isGreen: isKill,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                  ),
                  SizedBox(
                    width: 70, // Set your desired width here
                    child: MarqueeText(
                        direction: Axis.horizontal,
                        child: Text(
                          HistoryUtils.extractPlayerNameByPUUID(
                              matchDetail, isKill ? kill.victim : kill.killer),
                          style: const TextStyle(fontSize: 13),
                        )),
                  ),
                  AgentIcon(
                    iconUrl: HistoryUtils.getContentImageFromId(
                        AgentUtils.extractAgentIdByPUUID(
                            matchDetail, isKill ? kill.victim : kill.killer),
                        contentProvider.agents),
                    small: true,
                  ),
                ],
              ));
        }).toList()));
  }
}
