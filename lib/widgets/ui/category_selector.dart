import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/models/item.dart';
import 'package:valoralysis/providers/category_provider.dart';

class CategoryTypeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryTypeProvider>(
      builder: (context, categoryTypeProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: categoryTypeProvider.queueTypes.map((item) {
            bool isSelected =
                categoryTypeProvider.selectedQueue == item.realValue;
            return GestureDetector(
              onTap: () => categoryTypeProvider.selectQueue(item.realValue),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Column(
                      children: [
                        buildAnimatedText(context, isSelected, item),
                        const SizedBox(height: 4),
                        buildAnimatedContainer(context, isSelected, item),
                      ],
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  AnimatedDefaultTextStyle buildAnimatedText(
      BuildContext context, bool isSelected, Item item) {
    return AnimatedDefaultTextStyle(
      style: TextStyle(
        fontWeight: isSelected ? FontWeight.w200 : FontWeight.w300,
        fontSize: 20,
        color: isSelected
            ? Theme.of(context).colorScheme.onSurface
            : Theme.of(context).colorScheme.onSurface.withAlpha(120),
      ),
      duration: const Duration(milliseconds: 200),
      child: Text(item.displayValue),
    );
  }

  AnimatedContainer buildAnimatedContainer(
      BuildContext context, bool isSelected, Item item) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 2,
      width: isSelected ? item.displayValue.length.toDouble() * 9 : 0.0,
      color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
    );
  }
}
