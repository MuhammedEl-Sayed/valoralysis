import 'package:flutter/material.dart';

class TextUnderlined extends StatelessWidget {
  final String text;

  const TextUnderlined({Key? key, required this.text}) : super(key: key);

  double calculateTextWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size.width;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      fontSize: 18,
      color: Theme.of(context).colorScheme.onPrimary,
    );

    double textWidth = calculateTextWidth(text, style);

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
