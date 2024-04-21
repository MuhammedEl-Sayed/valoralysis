import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/content_provider.dart';
import 'package:valoralysis/widgets/ui/history_list/history_tile/history_tile.dart';

class HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);
    return Consumer<ContentProvider>(
        builder: (context, categoryTypeProvider, child) {
      return Expanded(
        child: ListView.builder(
          itemCount: contentProvider.matchDetails.length,
          itemBuilder: (context, index) {
            return HistoryTile(
                matchDetails: contentProvider.matchDetails[index]);
          },
        ),
      );
    });
  }
}
