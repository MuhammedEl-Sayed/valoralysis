import 'package:flutter/material.dart';
import 'package:valoralysis/utils/text_utils.dart';

class TextUnderlined extends StatelessWidget {
  final String text;

  const TextUnderlined({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      fontSize: 18,
      color: Theme.of(context).colorScheme.onPrimary,
    );

    double textWidth = TextUtils.calculateTextWidth(text, style);

    return Column(
      children: [
        Text(
          text,
          style: style,
        ),
        const SizedBox(height: 4),
        Container(
          height: 2,
          width: textWidth,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
