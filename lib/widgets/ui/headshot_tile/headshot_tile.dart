import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:valoralysis/utils/analysis/weapons_analysis.dart';
import 'package:valoralysis/widgets/ui/surface/surface.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/providers/content_provider.dart';

class HeadshotTile extends StatefulWidget {
  @override
  _HeadshotTileState createState() => _HeadshotTileState();
}

class _HeadshotTileState extends State<HeadshotTile> {
  Future<void>? _loadingFuture;
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);

    return FutureBuilder(
      future: _loadingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, double> headshots =
              WeaponsAnalysis.weaponsHeadshotAccuracyAnaylsis(
            contentProvider.matchDetails,
            userProvider.user.puuid,
          );
          print(headshots);
          return Surface(children: [
            const Text(
              'Headshot Percentage',
              style: TextStyle(fontSize: 18),
            ),
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
      },
    );
  }
}
