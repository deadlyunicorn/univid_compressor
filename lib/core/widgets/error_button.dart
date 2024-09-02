import "dart:math";
import "package:flutter/material.dart";

class ErrorButton extends StatelessWidget {
  const ErrorButton({
    required this.onPressed,
    required this.child,
    super.key,
  });

  final void Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll<Color>(
          Theme.of(context).colorScheme.error,
        ),
        overlayColor: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return Theme.of(context)
                  .colorScheme
                  .error
                  .withAlpha(pow(2, 4).toInt());
            } else if (states.contains(WidgetState.pressed)) {
              return Theme.of(context)
                  .colorScheme
                  .error
                  .withAlpha(pow(2, 5).toInt());
            }
            return Colors.transparent;
          },
        ),
      ),
      child: child,
    );
  }
}
