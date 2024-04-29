import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// adapted from https://stackoverflow.com/a/54173729/67655

class ExpandableSection extends HookWidget {
  const ExpandableSection({
    Key? key,
    required this.expanded,
    this.child,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.fastOutSlowIn,
  })  : assert(expanded != null),
        assert(child != null),
        assert(animationDuration != null),
        assert(animationCurve != null),
        super(key: key);

  final bool expanded;
  final Widget? child;

  final Duration animationDuration;
  final Curve animationCurve;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: animationDuration,
      initialValue: expanded ? 1.0 : 0.0,
    );

    useEffect(() {
      if (expanded && controller.value < 1.0) {
        controller.forward();
      } else if (!expanded && controller.value > 0.0) {
        controller.reverse();
      }
      return null;
    });

    return SizeTransition(
      axisAlignment: 1.0,
      sizeFactor: CurvedAnimation(
        parent: controller,
        curve: animationCurve,
      ),
      child: child,
    );
  }
}
