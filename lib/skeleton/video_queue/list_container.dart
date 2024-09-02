import "package:flutter/material.dart";
import "package:univid_compressor/core/constants.dart";
import "package:univid_compressor/core/widgets/custom_container.dart";

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
