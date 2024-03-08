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
      // height: double.infinity,
      width: MediaQuery.sizeOf(context).width / 2 < kMediumScreenWidth
          ? kSmallScreenWidth
          : kMediumScreenWidth,
      child: Padding(
        ///? Leave space for Stack() overlaying eleents
        padding: const EdgeInsets.all(32.0),
        child: CustomContainer(child: child),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: child,
      ),
    );
  }
}
