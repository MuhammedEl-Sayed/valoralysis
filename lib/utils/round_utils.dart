import 'package:flutter/material.dart';
import 'package:valoralysis/consts/round_result.dart';

class RoundUtils {
  static Widget resultToImageMap(
      bool playerTeam, String result, BuildContext context) {
    String baseUrl = 'assets/images/round_result/';
    String imageSuffix = playerTeam ? '_win.png' : '_loss.png';
    String imageName;

    switch (result) {
      case (eliminated):
        imageName = 'elimination';
        break;
      case (bombDefused):
        imageName = 'diffuse';
        break;
      case (bombDetonated):
        imageName = 'explosion';
        break;
      case (timeSinceRoundStartMillisrExpired):
        imageName = 'time';
        break;
      default:
        return SizedBox(
          width: 22.0,
          height: 22.0,
          child: Center(
            child: Container(
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
    }

    return SizedBox(
      width: 22.0,
      height: 22.0,
      child: Image.asset('$baseUrl$imageName$imageSuffix'),
    );
  }
}
