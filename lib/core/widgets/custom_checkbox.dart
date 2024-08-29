import "package:flutter/material.dart";

class CustomCheckbox extends StatelessWidget {
  final void Function(bool newValue) onChanged;
  final bool isChecked;

  const CustomCheckbox({
    required this.onChanged,
    required this.isChecked,
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
        width: 16,
        height: 16,
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
