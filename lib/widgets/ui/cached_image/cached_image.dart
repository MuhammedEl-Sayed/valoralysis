import 'dart:io';

import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  const CachedImage(
      {super.key, required this.imageUrl, this.width = 40, this.height = 40});

  @override
  Widget build(BuildContext context) {
    bool isLocal = Uri.parse(imageUrl).host.isEmpty;

    return isLocal
        ? Image.file(
            File(imageUrl),
            width: width,
            height: height,
          )
        : Image.network(
            imageUrl,
            width: width,
            height: height,
          );
  }
}
