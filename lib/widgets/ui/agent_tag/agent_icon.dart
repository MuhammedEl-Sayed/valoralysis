import 'package:flutter/material.dart';

class AgentIcon extends StatelessWidget {
  final String? iconUrl;

  const AgentIcon({this.iconUrl});

  @override
  Widget build(BuildContext context) {
    bool isValidUrl = Uri.tryParse(iconUrl ?? '')?.hasAbsolutePath ?? false;
    print('isValuidUrl: $isValidUrl');
    if (isValidUrl) {
      print('iconUrl: $iconUrl');
      return Image(
        image: NetworkImage(iconUrl!),
        width: 60,
        height: 60,
      );
    } else {
      return Container(); // return an empty container when the URL is not valid
    }
  }
}
