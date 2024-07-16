import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/providers/user_provider.dart';
import 'package:valoralysis/utils/formatting_utils.dart';
import 'package:valoralysis/utils/weapons_utils.dart';
import 'package:valoralysis/widgets/ui/surface/surface.dart';
import 'package:valoralysis/widgets/ui/text_underlined/text_underlined.dart';

class HeadshotTile extends StatelessWidget {
  const HeadshotTile({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);

    Map<String, double> shots = WeaponsUtils.weaponsHeadshotAccuracyAnaylsis(
      contentProvider.matchDetails,
      userProvider.user.puuid,
    );

    return Surface(children: [
      const TextUnderlined(text: 'Headshot %'),
      const Padding(padding: EdgeInsets.only(bottom: 10)),
      Row(children: [
        const Text('Head', style: TextStyle(fontSize: 14)),
        const Padding(padding: EdgeInsets.only(right: 8)),
        Text(FormattingUtils.convertShotToPercentage(shots, ShotType.Headshot),
            style: const TextStyle(fontSize: 14))
      ]),
      Row(children: [
        const Text('Body', style: TextStyle(fontSize: 14)),
        const Padding(padding: EdgeInsets.only(right: 8)),
        Text(FormattingUtils.convertShotToPercentage(shots, ShotType.Bodyshot),
            style: const TextStyle(fontSize: 14))
      ]),
      Row(children: [
        const Text('Legs', style: TextStyle(fontSize: 14)),
        const Padding(padding: EdgeInsets.only(right: 8)),
        Text(FormattingUtils.convertShotToPercentage(shots, ShotType.Legshot),
            style: const TextStyle(fontSize: 14))
      ])
    ]);
  }
}
