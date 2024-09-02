import "package:flutter/material.dart";

class AnimatedAppearance extends StatefulWidget {
  const AnimatedAppearance({
    required this.child,
    required bool visibleIf,
    super.key,
  }) : visible = visibleIf;

  final Widget child;
  final bool visible;

  @override
  State<AnimatedAppearance> createState() => _AnimatedAppearanceState();
  static const Duration animationDuration = Duration(milliseconds: 240);
}

class _AnimatedAppearanceState extends State<AnimatedAppearance>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: AnimatedAppearance.animationDuration,
  )
    ..drive(
      CurveTween(curve: Curves.elasticOut),
    )
    ..addListener(() {
      setState(() {});
    });

  bool isRendered = true;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedAppearance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible == widget.visible) {
    } else if (widget.visible) {
      animationController.forward(from: 0);
      setState(() {
        isRendered = true;
      });
    } else {
      animationController.reverse(from: 1);
      Future<void>.delayed(AnimatedAppearance.animationDuration).then((_) {
        setState(() {
          isRendered = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isRendered
        ? AnimatedRotation(
            duration: AnimatedAppearance.animationDuration,
            turns: widget.visible
                ? 1 - animationController.value
                : 0.2 * animationController.value,
            child: AnimatedScale(
              alignment: Alignment.bottomLeft,
              scale: widget.visible ? 1 * animationController.value : 0,
              duration: AnimatedAppearance.animationDuration,
              child: widget.child,
            ),
          )
        : const SizedBox.shrink();
  }
}
