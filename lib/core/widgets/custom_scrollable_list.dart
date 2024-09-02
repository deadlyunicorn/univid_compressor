import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/skeleton/skeleton.dart";

class CustomScrollableList<T> extends StatelessWidget {
  const CustomScrollableList({
    required this.builder,
    required this.items,
    super.key,
  });

  final Widget Function({required int index, required T item}) builder;
  final List<T> items;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEnterEvent event) {
        context.read<AppRootScrollPhysicsNotifier>().disableRootScrollPhysics();
      },
      onExit: (PointerExitEvent event) {
        context.read<AppRootScrollPhysicsNotifier>().enableRootScrollPhysics();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            ...items.asMap().entries.map((MapEntry<int, T> entry) {
              final int index = entry.key;
              final T item = entry.value;

              return builder(index: index, item: item);
            }),
          ],
        ),
      ),
    );
  }
}
