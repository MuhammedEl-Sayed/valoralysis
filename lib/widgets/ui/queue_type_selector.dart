import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/queue_type_provider.dart';

class QueueTypeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QueueTypeProvider>(
      builder: (context, queueTypeProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: queueTypeProvider.queueTypes.map((queueType) {
            return GestureDetector(
              onTap: () => queueTypeProvider.selectQueue(queueType),
              child: Text(
                queueType,
                style: TextStyle(
                  fontWeight: queueTypeProvider.selectedQueue == queueType
                      ? FontWeight.bold
                      : FontWeight.normal,
                  decoration: queueTypeProvider.selectedQueue == queueType
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
