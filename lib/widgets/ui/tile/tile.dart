import 'package:flutter/material.dart';
import 'package:valoralysis/widgets/ui/surface/surface.dart';
import 'package:valoralysis/widgets/ui/text_underlined/text_underlined.dart';

class Tile extends StatelessWidget {
  final String title;
  final List<Widget> leftColumn;
  final List<Widget> rightColumn;
  const Tile(
      {Key? key,
      required this.title,
      required this.leftColumn,
      required this.rightColumn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Surface(children: [TextUnderlined(text: title)]);
  }
}
