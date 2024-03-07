import "package:flutter/material.dart";
import "package:univid_compressor/core/constants.dart";

class ListContainer extends StatelessWidget {
  const ListContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kMediumScreenWidth,
      child: Expanded(
        child: Padding(
          ///? Leave space for Stack() overlaying eleents
          padding: const EdgeInsets.all(32.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
