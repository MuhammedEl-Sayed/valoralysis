import 'package:flutter/material.dart';

class Surface extends StatelessWidget {
  final List<Widget> children;

  const Surface({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          color: Theme.of(context).colorScheme.surfaceVariant),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
