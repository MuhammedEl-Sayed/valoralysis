import 'package:flutter/material.dart';
import 'package:valoralysis/widgets/ui/cached_image/cached_image.dart';

class AgentIcon extends StatelessWidget {
  final String? iconUrl;
  final double? width;
  final double? height;

  const AgentIcon({super.key, this.iconUrl, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    bool isValidUrl = Uri.tryParse(iconUrl ?? '')?.hasAbsolutePath ?? false;
    if (isValidUrl) {
      return CachedImage(
        imageUrl: iconUrl!,
        width: width ?? 60,
        height: height ?? 60,
      );
    } else {
      return Container(); // return an empty container when the URL is not valid
    }
  }
}
