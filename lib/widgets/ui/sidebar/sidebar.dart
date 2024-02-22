import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:valoralysis/widgets/ui/sidebar/sidebar_icons.dart';

class Sidebar extends StatelessWidget {
  void _logout(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.logout(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorScheme.dark().background,
      width: 75,
      child: Column(children: [
        Image.asset('assets/images/logo/Square71x71Logo.scale-100.png'),
        const SizedBox(height: 80),
        SidebarIcons(),
        Expanded(child: Container()),
        //logout
        Padding(
            padding: const EdgeInsets.only(
                bottom: 20.0), // Add your desired padding here
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
