import "dart:math";

import "package:flutter/material.dart";

class CustomLinearProgressIndicator extends StatefulWidget {
  const CustomLinearProgressIndicator({
    super.key,
    this.maxWidth = 80,
  });

  final int maxWidth;

  @override
  State<CustomLinearProgressIndicator> createState() =>
      _CustomLinearProgressIndicatorState();
}

class _CustomLinearProgressIndicatorState extends State<CustomLinearProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });
    animationController.repeat(
      reverse: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: min(
        widget.maxWidth.toDouble(),
        MediaQuery.sizeOf(context).width / 2,
      ),
      child: LinearProgressIndicator(
        value: animationController.value,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
