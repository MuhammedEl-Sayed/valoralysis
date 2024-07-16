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
      Color textColor;

      switch (type) {
        case ToastTypes.error:
          backgroundColor = Colors.red;
          textColor = Colors.white;
          break;
        case ToastTypes.success:
          backgroundColor = Colors.green;
          textColor = Colors.white;
          break;
        case ToastTypes.info:
          backgroundColor = Colors.blue;
          textColor = Colors.white;
          break;
      }

      Fluttertoast.showToast(
        msg: toastMessage,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 4,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0,
      );
    }
  }
}
