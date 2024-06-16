import 'package:flutter/material.dart';
import 'package:valoralysis/models/item.dart';

class ModeDropdown extends StatelessWidget {
  final List<Item> modes;
  final Item selectedMode;
  final Function(Item) onModeSelected;

  const ModeDropdown(
      {Key? key,
      required this.modes,
      required this.selectedMode,
      required this.onModeSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 160,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        child: DropdownButton<String>(
          value: selectedMode.realValue,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          iconSize: 24,
          elevation: 16,
          underline: Container(
            height: 0,
          ),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary, fontSize: 17),
          onChanged: (String? newValue) {
            Item newMode =
                modes.firstWhere((mode) => mode.realValue == newValue);
            onModeSelected(newMode);
          },
          isExpanded: true,
          items: modes.map((item) {
            return DropdownMenuItem<String>(
              onTap: () {},
              value: item.realValue,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0), // Adjust the padding as needed
                child: Text(item.displayValue),
              ),
            );
          }).toList(),
        ));
  }
}
