import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/mode_provider.dart';

class CategoryDropdown extends StatefulWidget {
  const CategoryDropdown({Key? key}) : super(key: key);

  @override
  _CategoryDropdownState createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  String? dropdownValue;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ModeProvider modeProvider =
          Provider.of<ModeProvider>(context, listen: false);
      if (modeProvider.modes.isNotEmpty) {
        setState(() {
          dropdownValue = modeProvider.modes[0].realValue;
          print(dropdownValue);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ModeProvider modeProvider = Provider.of<ModeProvider>(context);
    return Consumer<ModeProvider>(
      builder: (context, categoryTypeProvider, child) {
        return Container(
            width: 160,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: DropdownButton<String>(
              value: dropdownValue,
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
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 17),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              isExpanded: true,
              items: modeProvider.modes.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item.realValue,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0), // Adjust the padding as needed
                    child: Text(item.displayValue),
                  ),
                );
              }).toList(),
            ));
      },
    );
  }
}
