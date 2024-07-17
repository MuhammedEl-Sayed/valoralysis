import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/user_provider.dart';
import 'package:valoralysis/widgets/ui/sidebar/sidebar_icons.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  void _logout(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      width: 75,
      child: Column(children: [
        const Padding(padding: EdgeInsets.only(top: 10)),
        Image.asset('assets/images/logo/StoreLogo.scale-300.png'),
        const SizedBox(height: 80),
        SidebarIcons(),
        const SizedBox(height: 80),

        //logout
        Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.grey,
              ),
              onPressed: () {
                _logout(context);
              },
              iconSize: 35,
            )),
      ]),
    );
  }
}
