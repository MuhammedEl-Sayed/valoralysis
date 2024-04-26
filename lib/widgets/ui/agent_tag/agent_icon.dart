import 'package:flutter/material.dart';

class AgentIcon extends StatelessWidget {
  final String? iconUrl;
  final bool? small;

  const AgentIcon({this.iconUrl, this.small});

  @override
  Widget build(BuildContext context) {
    bool isValidUrl = Uri.tryParse(iconUrl ?? '')?.hasAbsolutePath ?? false;
    double size = small == true ? 45 : 60;
    if (isValidUrl) {
      return Image(
        image: NetworkImage(iconUrl!),
        width: size,
        height: size,
      );
    } else {
      return Container(); // return an empty container when the URL is not valid
    }
  }
}
