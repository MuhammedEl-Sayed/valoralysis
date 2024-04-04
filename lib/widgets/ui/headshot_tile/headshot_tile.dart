import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valoralysis/utils/analysis/weapons_analysis.dart';
import 'package:valoralysis/widgets/ui/surface/surface.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/widgets/ui/text_underlined/text_underlined.dart';

class HeadshotTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);

    Map<String, double> headshots =
        WeaponsAnalysis.weaponsHeadshotAccuracyAnaylsis(
      contentProvider.matchDetails,
      userProvider.user.puuid,
    );
    print(headshots);
    return Surface(children: [
      const TextUnderlined(text: 'Headshot %'),
      const Padding(padding: EdgeInsets.only(bottom: 10)),
      Row(children: [
        const Text('Head', style: TextStyle(fontSize: 14)),
        const Padding(padding: EdgeInsets.only(right: 8)),
        Text(
            '${(headshots['Headshot']! * 100).toString().split('.')[0]}.${(headshots['Headshot']! * 100).toString().split('.')[1].substring(0, 1)}',
            style: const TextStyle(fontSize: 14))
      ]),
      Row(children: [
        const Text('Body', style: TextStyle(fontSize: 14)),
        const Padding(padding: EdgeInsets.only(right: 8)),
        Text(
            '${(headshots['Bodyshot']! * 100).toString().split('.')[0]}.${(headshots['Bodyshot']! * 100).toString().split('.')[1].substring(0, 1)}',
            style: const TextStyle(fontSize: 14))
      ]),
      Row(children: [
        const Text('Legs', style: TextStyle(fontSize: 14)),
        const Padding(padding: EdgeInsets.only(right: 8)),
        Text(
            '${(headshots['Legshot']! * 100).toString().split('.')[0]}.${(headshots['Legshot']! * 100).toString().split('.')[1].substring(0, 1)}',
            style: const TextStyle(fontSize: 14))
      ])
    ]);
  }
}
