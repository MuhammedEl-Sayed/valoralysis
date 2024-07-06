import 'package:flutter/material.dart';
import 'package:valoralysis/consts/margins.dart';

enum ToastTypes { error, success, info }

class Toast extends StatefulWidget {
  final String toastMessage;
  final ToastTypes type;
  final bool show; // Added boolean to control visibility

  const Toast({
    Key? key,
    required this.toastMessage,
    required this.type,
    this.show = false,
  }) : super(key: key);

  @override
  _ToastState createState() => _ToastState();
}

class _ToastState extends State<Toast> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<Offset> offsetAnimation;
  late final Animation<double> opacityAnimation;
  bool isVisible; // Local state to manage visibility

  _ToastState() : isVisible = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    final Animation<double> curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    offsetAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(begin: Offset.zero, end: const Offset(0, 0.5))
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween<Offset>(const Offset(0, 0.5)),
        weight: 60.0,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20.0,
      ),
    ]).animate(curve);

    opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 10.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 80.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 10.0,
      ),
    ]).animate(curve);

    // Start animation if show is true
    if (widget.show) {
      isVisible = true;
      startAnimation();
    }

    // Listen to the animation status to reset isVisible
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isVisible = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(Toast oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      startAnimation();
    }
  }

  void startAnimation() {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
      controller.reset();
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox();
    }

    double margin = getStandardMargins(context);

    Color backgroundColor;
    Icon leadingIcon;
    Color textColor;
    print('widget.type: ${widget.type}');
    switch (widget.type) {
      case ToastTypes.error:
        backgroundColor = Theme.of(context).colorScheme.onError;
        leadingIcon = const Icon(Icons.error, color: Colors.white);
        textColor = Colors.white;
        break;
      case ToastTypes.success:
        backgroundColor = const Color(0xff2e5a22);
        leadingIcon = const Icon(Icons.check_circle, color: Colors.white);
        textColor = Colors.white;
        break;
      case ToastTypes.info:
        backgroundColor = Theme.of(context).colorScheme.primary;
        leadingIcon =
            Icon(Icons.info, color: Theme.of(context).colorScheme.onPrimary);
        textColor = Theme.of(context).colorScheme.onPrimary;
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeTransition(
          opacity: opacityAnimation,
          child: SlideTransition(
            position: offsetAnimation,
            child: Container(
              margin: EdgeInsets.only(
                  left: margin * 2,
                  right: margin * 2,
                  top: margin,
                  bottom: margin),
              padding: EdgeInsets.all(margin / 2),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  leadingIcon,
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(widget.toastMessage,
                          style: TextStyle(
                            fontSize: 15,
                            color: textColor,
                          ))),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
