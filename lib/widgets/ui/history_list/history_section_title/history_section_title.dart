import 'package:flutter/material.dart';
import 'package:valoralysis/consts/margins.dart';
import 'package:valoralysis/widgets/ui/mode_dropdown/mode_dropdown.dart';

class HistorySectionTitle extends StatelessWidget {
  final int numOfMatches;
  final String dateTitle;
  final bool hasDropdown;
  const HistorySectionTitle(
      {super.key,
      required this.numOfMatches,
      required this.dateTitle,
      required this.hasDropdown});

  @override
  Widget build(BuildContext context) {
    double margin = getStandardMargins(context);
    return Padding(
        padding:
            EdgeInsets.only(left: margin, right: margin, bottom: margin / 2),
        child: Row(
          children: [
            Text(
              dateTitle,
              style: const TextStyle(fontSize: 17),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 20, minHeight: 16),
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.all(Radius.circular(2))),
              child: Center(
                  child: Text(
                numOfMatches.toString(),
                style: const TextStyle(fontSize: 15),
              )),
            ),
            const Spacer(),
            hasDropdown ? const ModeDropdown() : const SizedBox.shrink()
          ],
        ));
  }
}
