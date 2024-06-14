import 'package:flutter/material.dart';
import 'package:valoralysis/consts/round_result.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_icon.dart';
import 'package:valoralysis/widgets/ui/marquee_text/marquee_text.dart';
import 'package:valoralysis/widgets/ui/weapon_silhouette_image/weapon_silhouette_image.dart';

class RoundUtils {
  //make a map for these three:
  /*
  {
    "39099FB5-4293-DEF4-1E09-2E9080CE7456": "Tour De Force", // use killer agents ultimate
    "856D9A7E-4B06-DC37-15DC-9D809C37CB90": "Headhunter", // use killer agents Ability1

    "95336AE4-45D4-1032-CFAF-6BAD01910607": "Overdrive" // use killer ultimate
}*/

  static Widget getKilledByIcon(MatchDto matchDetail, KillDto kill,
      List<ContentItem> weapons, List<ContentItem> agents, bool isGreen) {
    print('kill: ${kill.finishingDamage.damageItem}');
    final killer = AgentUtils.extractAgentIdByPUUID(matchDetail, kill.killer);
    switch (kill.finishingDamage.damageItem) {
      case '39099FB5-4293-DEF4-1E09-2E9080CE7456':
        return WeaponSilhouetteImage(
          imageUrl: HistoryUtils.getAbilityImageFromSlotAndId(
                  'Ultimate', killer, agents) ??
              '',
          height: 30,
          width: 60,
          isGreen: isGreen,
        );
      case '856D9A7E-4B06-DC37-15DC-9D809C37CB90':
        return WeaponSilhouetteImage(
          imageUrl: HistoryUtils.getAbilityImageFromSlotAndId(
                  'Ability1', killer, agents) ??
              '',
          height: 30,
          width: 60,
          isGreen: isGreen,
        );
      case '95336AE4-45D4-1032-CFAF-6BAD01910607':
        return WeaponSilhouetteImage(
          imageUrl: HistoryUtils.getAbilityImageFromSlotAndId(
                  'Ultimate', killer, agents) ??
              '',
          height: 30,
          width: 60,
          isGreen: isGreen,
        );
      default:
        return kill.finishingDamage.damageType == 'Ability'
            ? WeaponSilhouetteImage(
                imageUrl: HistoryUtils.getAbilityImageFromSlotAndId(
                        kill.finishingDamage.damageItem, killer, agents) ??
                    '',
                height: 30,
                width: 60,
                isGreen: isGreen,
              )
            : WeaponSilhouetteImage(
                imageUrl: HistoryUtils.getSilhouetteImageFromId(
                        HistoryUtils.getKillGunId(kill), weapons) ??
                    '',
                height: 30,
                width: 60,
                isGreen: isGreen,
              );
    }
  }

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
      BuildContext context,
      String puuid,
      List<KillDto> kills,
      List<KillDto> deaths,
      MatchDto matchDetail,
      List<ContentItem> weapons,
      List<ContentItem> agents) {
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
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.surfaceVariant,
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    top: 10, bottom: 10), // Adjust the padding as needed
                child: Center(
                  child: Text(
                    'Kills/Deaths',
                    style:
                        TextStyle(fontSize: 17), // Adjust the style as needed
                  ),
                ),
              ),
              ...sortedKillsAndDeaths.map((event) {
                bool isKill = event['type'] == 'kill';
                KillDto kill = event['data'];
                return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AgentIcon(
                                  iconUrl: HistoryUtils.getContentImageFromId(
                                      AgentUtils.extractAgentIdByPUUID(
                                          matchDetail, puuid),
                                      agents),
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
                                getKilledByIcon(
                                    matchDetail, kill, weapons, agents, isKill),
                                const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                SizedBox(
                                  width: 70, // Set your desired width here
                                  child: MarqueeText(
                                      direction: Axis.horizontal,
                                      child: Text(
                                        HistoryUtils.extractPlayerNameByPUUID(
                                            matchDetail,
                                            isKill ? kill.victim : kill.killer),
                                        style: const TextStyle(fontSize: 13),
                                      )),
                                ),
                                AgentIcon(
                                  iconUrl: HistoryUtils.getContentImageFromId(
                                      AgentUtils.extractAgentIdByPUUID(
                                          matchDetail,
                                          isKill ? kill.victim : kill.killer),
                                      agents),
                                  small: true,
                                ),
                              ],
                            ))));
              }).toList(),
            ],
          ),
        ));
  }
}

/*
import 'package:flutter/material.dart';
import 'package:valoralysis/consts/round_result.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/match_details.dart';
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
      BuildContext context,
      String puuid,
      List<KillDto> kills,
      List<KillDto> deaths,
      MatchDto matchDetail,
      List<ContentItem> weapons,
      List<ContentItem> agents) {
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
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10), // Adjust the padding as needed
              child: Center(
                child: Text(
                  'Kills/Deaths',
                  style: TextStyle(fontSize: 17), // Adjust the style as needed
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceVariant, // Change this to your desired color
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                      children: sortedKillsAndDeaths.map((event) {
                    bool isKill = event['type'] == 'kill';
                    KillDto kill = event['data'];
                    return Padding(
                      padding: const EdgeInsets.only(top: 7, bottom: 7),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AgentIcon(
                              iconUrl: HistoryUtils.getContentImageFromId(
                                  AgentUtils.extractAgentIdByPUUID(
                                      matchDetail, puuid),
                                  agents),
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
                                      weapons) ??
                                  '',
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
                                        matchDetail,
                                        isKill ? kill.victim : kill.killer),
                                    style: const TextStyle(fontSize: 13),
                                  )),
                            ),
                            AgentIcon(
                              iconUrl: HistoryUtils.getContentImageFromId(
                                  AgentUtils.extractAgentIdByPUUID(matchDetail,
                                      isKill ? kill.victim : kill.killer),
                                  agents),
                              small: true,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList()),
                )),
          ],
        ),
      ),
    );
  }
}

*/