import 'package:flutter/material.dart';
import 'package:valoralysis/widgets/ui/cached_image/cached_image.dart';

class AgentIcon extends StatelessWidget {
  final String? iconUrl;
  final bool? small;

  const AgentIcon({super.key, this.iconUrl, this.small});

  @override
  Widget build(BuildContext context) {
    bool isValidUrl = Uri.tryParse(iconUrl ?? '')?.hasAbsolutePath ?? false;
    double size = small == true ? 45 : 60;
    if (isValidUrl) {
      return CachedImage(
        imageUrl: iconUrl!,
        width: size,
        height: size,
      );
    } else {
      return Container(); // return an empty container when the URL is not valid
    }
  }
}
