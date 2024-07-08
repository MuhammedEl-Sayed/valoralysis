import 'package:flutter/material.dart';
import 'package:valoralysis/consts/round_result.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/models/content.dart';
import 'package:valoralysis/models/match_details.dart';
import 'package:valoralysis/utils/agent_utils.dart';
import 'package:valoralysis/utils/economy_utils.dart';
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
    final damageType = kill.finishingDamage.damageType;
    final damageItem = kill.finishingDamage.damageItem;

    String damageItemId = kill.finishingDamage.damageItem;

    if (damageType == 'Bomb') {
      return resultToImageMap(isGreen, 'Bomb detonated', null);
    }

    if (damageType == 'Ability') {
      return _buildAbilityIcon(damageItem, killer, agents, isGreen);
    }

    if (damageType == 'Fall') {
      //'assets/images/misc/fall_death.png',
      return _buildResultIcon(
          false, 'assets/images/misc/', 'fall_death', '.png');
    }
    String abilitySlot = '';
    switch (damageItemId) {
      case '':
        abilitySlot = 'Ultimate'; // Chamber Ult
        break;
      case '856D9A7E-4B06-DC37-15DC-9D809C37CB90':
        abilitySlot = 'Ability1'; // Chamber Sheriff
        break;
      case '95336AE4-45D4-1032-CFAF-6BAD01910607':
        abilitySlot = 'Ultimate'; // Neon Ult
        break;
    }
    if (abilitySlot.isNotEmpty) {
      return _buildAbilityIcon(abilitySlot, killer, agents, isGreen);
    }
    return _buildWeaponIcon(damageItem, kill, weapons, agents, isGreen);
  }

  static Widget _buildAbilityIcon(String damageItem, String killer,
      List<ContentItem> agents, bool isGreen) {
    final imageUrl =
        HistoryUtils.getAbilityImageFromSlotAndId(damageItem, killer, agents) ??
            '';
    return WeaponSilhouetteImage(
      imageUrl: imageUrl,
      height: 30,
      width: 60,
      isGreen: isGreen,
    );
  }

  static Widget _buildWeaponIcon(String damageItem, KillDto kill,
      List<ContentItem> weapons, List<ContentItem> agents, bool isGreen) {
    final imageUrl = HistoryUtils.getSilhouetteImageFromId(
            HistoryUtils.getKillGunId(kill), weapons) ??
        '';
    return WeaponSilhouetteImage(
      imageUrl: imageUrl,
      height: 30,
      width: 60,
      isGreen: isGreen,
    );
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
        return _buildDefaultIcon(context);
    }

    return _buildResultIcon(playerTeam, baseUrl, imageName, imageSuffix);
  }

  static Widget _buildDefaultIcon(BuildContext? context) {
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

  static Widget _buildResultIcon(
      bool playerTeam, String baseUrl, String imageName, String imageSuffix) {
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
      ),
    );
  }

  static Widget buildRoundKillFeed(
      BuildContext context,
      String puuid,
      List<KillDto> kills,
      List<KillDto> deaths,
      MatchDto matchDetail,
      List<ContentItem> weapons,
      List<ContentItem> agents,
      int roundIndex) {
    List<dynamic> sortedKillsAndDeaths =
        _getSortedKillsAndDeaths(kills, deaths);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: _buildContainerDecoration(context, false),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text(
                  'Kills/Deaths',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
            ...sortedKillsAndDeaths.map((event) {
              return _buildKillDeathRow(context, puuid, event, matchDetail,
                  weapons, agents, roundIndex);
            }).toList(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  static List<dynamic> _getSortedKillsAndDeaths(
      List<KillDto> kills, List<KillDto> deaths) {
    List<dynamic> sortedKillsAndDeaths = [
      ...kills.map((kill) => {'type': 'kill', 'data': kill}),
      ...deaths.map((death) => {'type': 'death', 'data': death})
    ];

    sortedKillsAndDeaths.sort((a, b) {
      int aTime = a['data'].timeSinceRoundStartMillis;
      int bTime = b['data'].timeSinceRoundStartMillis;
      return aTime.compareTo(bTime);
    });

    return sortedKillsAndDeaths;
  }

  static BoxDecoration _buildContainerDecoration(
      BuildContext context, bool isTile) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.surfaceVariant,
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
      color: isTile
          ? Theme.of(context).canvasColor
          : Theme.of(context).colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(5),
    );
  }

  static Widget _buildKillDeathRow(
      BuildContext context,
      String puuid,
      Map<String, dynamic> event,
      MatchDto matchDetail,
      List<ContentItem> weapons,
      List<ContentItem> agents,
      int roundIndex) {
    bool isKill = event['type'] == 'kill';
    KillDto kill = event['data'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
      child: Container(
        decoration: _buildContainerDecoration(context, true),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAgentIcon(matchDetail, puuid, agents),
              _buildPlayerColumn(context, matchDetail, puuid, roundIndex),
              const Padding(padding: EdgeInsets.only(right: 5)),
              _buildKillDeathColumn(
                  context, matchDetail, kill, weapons, agents, isKill),
              const Padding(padding: EdgeInsets.only(left: 5)),
              _buildOpponentColumn(
                  context, matchDetail, kill, isKill, roundIndex),
              _buildAgentIcon(
                  matchDetail, isKill ? kill.victim : kill.killer, agents),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildAgentIcon(
      MatchDto matchDetail, String puuid, List<ContentItem> agents) {
    return AgentIcon(
      iconUrl: HistoryUtils.getContentImageFromId(
          AgentUtils.extractAgentIdByPUUID(matchDetail, puuid), agents),
      width: 35,
      height: 35,
    );
  }

  static Widget _buildPlayerColumn(BuildContext context, MatchDto matchDetail,
      String puuid, int roundIndex) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 70,
          child: MarqueeText(
            direction: Axis.horizontal,
            child: Text(
              HistoryUtils.extractPlayerNameByPUUID(matchDetail, puuid),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child:
              EconomyUtils.getBuyIconFromRound(matchDetail, puuid, roundIndex),
        ),
      ],
    );
  }

  static Widget _buildKillDeathColumn(
      BuildContext context,
      MatchDto matchDetail,
      KillDto kill,
      List<ContentItem> weapons,
      List<ContentItem> agents,
      bool isKill) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        getKilledByIcon(matchDetail, kill, weapons, agents, isKill),
        Text(
          getKilledByTime(kill),
          style: TextStyle(color: ThemeColors().fadedText, fontSize: 13),
        ),
      ],
    );
  }

  static Widget _buildOpponentColumn(BuildContext context, MatchDto matchDetail,
      KillDto kill, bool isKill, int roundIndex) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 70,
          child: MarqueeText(
            direction: Axis.horizontal,
            child: Text(
              HistoryUtils.extractPlayerNameByPUUID(
                  matchDetail, isKill ? kill.victim : kill.killer),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: EconomyUtils.getBuyIconFromRound(
              matchDetail, isKill ? kill.victim : kill.killer, roundIndex),
        ),
      ],
    );
  }
}
