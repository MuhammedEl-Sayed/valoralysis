import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';

class LoginSearchBar extends StatefulWidget {
  final ValueChanged<String> onUserNameChanged;
  //and another for submitting the search
  final ValueChanged<String> onSearchSubmitted;
  const LoginSearchBar(
      {super.key,
      required this.onUserNameChanged,
      required this.onSearchSubmitted})
      : super();

  @override
  State<LoginSearchBar> createState() => _LoginSearchBarState();
}

class _LoginSearchBarState extends State<LoginSearchBar> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    List<String> names = userProvider.getNameHistory();
    return SearchAnchor(viewOnChanged: (value) {
      widget.onUserNameChanged(value);
    }, viewOnSubmitted: (value) {
      widget.onSearchSubmitted(value);
    }, builder: (BuildContext context, SearchController controller) {
      return SearchBar(
        hintText: 'Search for a player i.e Player#1243',
        controller: controller,
        padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0)),
        onTap: () {
          controller.openView();
        },
        leading: const Icon(Icons.search),
      );
    }, suggestionsBuilder: (BuildContext context, SearchController controller) {
      return List<ListTile>.generate(names.length, (int index) {
        final String item = names[index];
        return ListTile(
          title: Text(item),
          onTap: () {
            setState(() {
              widget.onUserNameChanged(item);
              controller.closeView(item);
            });
          },
        );
      });
    });
  }
}
