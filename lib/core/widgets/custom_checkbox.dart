import "package:flutter/material.dart";

class CustomCheckbox extends StatelessWidget {
  final void Function(bool newValue) onChanged;
  final bool isChecked;
  final double size;

  const CustomCheckbox({
    required this.onChanged,
    required this.isChecked,
    this.size = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color color = isChecked
        ? Theme.of(context).colorScheme.secondary
        : Colors.transparent;
    return InkWell(
      onTap: () {
        onChanged(!isChecked);
      },
      child: AnimatedContainer(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(36),
          color: color,
        ),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
