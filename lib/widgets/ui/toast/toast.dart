import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastTypes { error, success, info }

class Toast {
  final String toastMessage;
  final ToastTypes type;
  final bool show;

  Toast({
    required this.toastMessage,
    required this.type,
    this.show = false,
  });

  void showToast() {
    if (show) {
      Color backgroundColor;
      Icon leadingIcon;
      Color textColor;

      switch (type) {
        case ToastTypes.error:
          backgroundColor = Colors.red;
          leadingIcon = const Icon(Icons.error, color: Colors.white);
          textColor = Colors.white;
          break;
        case ToastTypes.success:
          backgroundColor = Colors.green;
          leadingIcon = const Icon(Icons.check_circle, color: Colors.white);
          textColor = Colors.white;
          break;
        case ToastTypes.info:
          backgroundColor = Colors.blue;
          leadingIcon = const Icon(Icons.info, color: Colors.white);
          textColor = Colors.white;
          break;
      }

      Fluttertoast.showToast(
        msg: toastMessage,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0,
      );
    }
  }
}
