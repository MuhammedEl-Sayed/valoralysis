import 'package:flutter/material.dart';
import 'package:valoralysis/consts/round_result.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/utils/history_utils.dart';
import 'package:valoralysis/widgets/ui/agent_tag/agent_icon.dart';
import 'package:valoralysis/widgets/ui/marquee_text/marquee_text.dart';
import 'package:valoralysis/widgets/ui/weapon_silhouette_image/weapon_silhouette_image.dart';

class RoundUtils {
  static String getKilledByTime(KillDto kill) {
    int time = kill.timeSinceRoundStartMillis;
    int seconds = (time / 1000).floor();
    int minutes = (seconds / 60).floor();
    seconds = seconds % 60;
    return '$minutes:${seconds < 10 ? '0$seconds' : seconds}';
  }

  static Widget getKilledByIcon(MatchDto matchDetail, KillDto kill,
      List<ContentItem> weapons, List<ContentItem> agents, bool isGreen) {
    final killer = AgentUtils.extractAgentIdByPUUID(matchDetail, kill.killer);
    if (kill.finishingDamage.damageType == 'Bomb') {
      return resultToImageMap(isGreen, 'Bomb detonated', null);
    }
    switch (kill.finishingDamage.damageItem) {
      // This is Chamber Ult
      case '':
        return WeaponSilhouetteImage(
          imageUrl: HistoryUtils.getAbilityImageFromSlotAndId(
                  'Ultimate', killer, agents) ??
              '',
          height: 30,
          width: 60,
          isGreen: isGreen,
        );
      // This is Chamber Sheriff
      case '856D9A7E-4B06-DC37-15DC-9D809C37CB90':
        return WeaponSilhouetteImage(
          imageUrl: HistoryUtils.getAbilityImageFromSlotAndId(
                  'Ability1', killer, agents) ??
              '',
          height: 30,
          width: 60,
          isGreen: isGreen,
        );
      // This is Neon Ult
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
      bool playerTeam, String result, BuildContext? context) {
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
                color: context != null
                    ? Theme.of(context).canvasColor
                    : ThemeColors().fadedText,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
    }

    return ColorFiltered(
        colorFilter: ColorFilter.mode(
          playerTeam
              ? ThemeColors().green.withOpacity(0.9)
              : ThemeColors().red.withOpacity(0.9),
          BlendMode.modulate,
        ),
        child: SizedBox(
          width: 22.0,
          height: 22.0,
          child: Image.asset('$baseUrl$imageName$imageSuffix'),
        ));
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
                                    width: 45,
                                    height: 45),
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
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      getKilledByIcon(matchDetail, kill,
                                          weapons, agents, isKill),
                                      Text(getKilledByTime(kill),
                                          style: TextStyle(
                                              color: ThemeColors().fadedText,
                                              fontSize: 13)),
                                    ]),
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
                                    width: 45,
                                    height: 45),
                              ],
                            ))));
              }).toList(),
            ],
          ),
        ));
  }
}
