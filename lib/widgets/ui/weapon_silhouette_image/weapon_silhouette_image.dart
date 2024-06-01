import 'package:flutter/material.dart';
import 'package:valoralysis/widgets/ui/cached_image/cached_image.dart';

class WeaponSilhouetteImage extends StatelessWidget {
  final String imageUrl;
  final bool isGreen;
  final double width;
  final double height;

  const WeaponSilhouetteImage({
    super.key,
    required this.imageUrl,
    this.isGreen = true,
    this.width = 40,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        isGreen ? Colors.green : Colors.red,
        BlendMode.modulate,
      ),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(isGreen ? 3.14 : 0),
        child: CachedImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
