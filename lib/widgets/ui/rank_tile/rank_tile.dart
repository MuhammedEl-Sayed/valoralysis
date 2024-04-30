import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/models/rank.dart';
import 'package:valoralysis/utils/formatting_utils.dart';
import 'package:valoralysis/widgets/ui/surface/surface.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/utils/rank_utils.dart';
import 'package:valoralysis/widgets/ui/text_underlined/text_underlined.dart';

class RankTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);

    Rank playerRank = RankUtils.getPlayerRank(
      contentProvider.matchDetails[0],
      contentProvider.ranks,
      userProvider.user.puuid,
    );

    return Surface(children: [
      const TextUnderlined(text: 'Current Rating'),
      const Padding(padding: EdgeInsets.only(bottom: 10)),
      Row(children: [
        Image(
          image: NetworkImage(playerRank.rankIcons.largeIcon),
          width: 60,
          height: 60,
        ),
        const Padding(padding: EdgeInsets.only(right: 8)),
        Text(FormattingUtils.capitalizeFirstLetter(playerRank.tierName),
            style: TextStyle(fontSize: 14, color: ThemeColors().fadedText))
      ])
    ]);
  }
}
