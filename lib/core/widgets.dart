import "package:flutter/material.dart";

class ColumnWithSpacings extends StatelessWidget {
  const ColumnWithSpacings({
    required this.children,
    required this.spacing,
    super.key,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final List<Widget> children;
  final int spacing;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: List<Widget>.generate(
        children.length * 2 - 1,
        (int index) => index % 2 == 0
            ? children[index ~/ 2]
            : SizedBox.square(
                dimension: spacing.toDouble(),
              ),
      ),
    );
  }
}

class RowWithSpacings extends StatelessWidget {
  const RowWithSpacings({
    required this.children,
    required this.spacing,
    super.key,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final List<Widget> children;
  final int spacing;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: List<Widget>.generate(
        children.length * 2 - 1,
        (int index) => index % 2 == 0
            ? children[index ~/ 2]
            : SizedBox.square(
                dimension: spacing.toDouble(),
              ),
      ),
    );
  }
}