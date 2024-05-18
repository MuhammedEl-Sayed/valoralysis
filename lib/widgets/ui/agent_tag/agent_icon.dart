import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AgentIcon extends StatelessWidget {
  final String? iconUrl;
  final bool? small;

  const AgentIcon({super.key, this.iconUrl, this.small});

  @override
  Widget build(BuildContext context) {
    bool isValidUrl = Uri.tryParse(iconUrl ?? '')?.hasAbsolutePath ?? false;
    double size = small == true ? 45 : 60;
    if (isValidUrl) {
      return CachedNetworkImage(
        imageUrl: iconUrl!,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        width: size,
        height: size,
      );
    } else {
      return Container(); // return an empty container when the URL is not valid
    }
  }
}
