import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/consts/margins.dart';
import 'package:valoralysis/consts/theme.dart';
import 'package:valoralysis/models/item.dart';
import 'package:valoralysis/providers/category_provider.dart';
import 'package:valoralysis/utils/text_utils.dart';

class CategoryTypeSelector extends StatelessWidget {
  const CategoryTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    double margin = getStandardMargins(context);
    return Consumer<CategoryTypeProvider>(
      builder: (context, categoryTypeProvider, child) {
        return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: categoryTypeProvider.queueTypes.map((item) {
                bool isSelected =
                    categoryTypeProvider.selectedQueue == item.realValue;
                return GestureDetector(
                  onTap: () => categoryTypeProvider.selectQueue(item.realValue),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Padding(
                        padding: EdgeInsets.only(
                            right: margin / 3, left: margin / 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
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
            ));
      },
    );
  }

  AnimatedDefaultTextStyle buildAnimatedText(
      BuildContext context, bool isSelected, Item item) {
    return AnimatedDefaultTextStyle(
      style: TextStyle(
        fontWeight: isSelected ? FontWeight.w200 : FontWeight.w300,
        fontSize: 14,
        color: isSelected
            ? Theme.of(context).colorScheme.onSurface
            : ThemeColors().fadedText,
      ),
      duration: const Duration(milliseconds: 200),
      child: Text(item.displayValue),
    );
  }

  AnimatedContainer buildAnimatedContainer(
      BuildContext context, bool isSelected, Item item) {
    TextStyle style = TextStyle(
      fontWeight: isSelected ? FontWeight.w200 : FontWeight.w300,
      fontSize: 14,
      color: isSelected
          ? Theme.of(context).colorScheme.onSurface
          : ThemeColors().fadedText,
    );

    double textWidth = TextUtils.calculateTextWidth(item.displayValue, style);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 2,
      width: isSelected ? textWidth : 0.0,
      color: isSelected
          ? Theme.of(context).colorScheme.primary
          : Colors.transparent,
    );
  }
}
