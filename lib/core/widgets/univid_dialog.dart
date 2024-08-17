import "package:flutter/material.dart";
import "package:univid_compressor/core/constants.dart";

class UnividDialog<T> extends AlertDialog {
  UnividDialog({
    required super.title,
    required super.content,
    Future<T> Function()? onConfirm,
    super.actions,
    super.key,
  }) : _onConfirm = onConfirm ??
            (() {
              return null;
            });

  final Future<T>? Function() _onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: title,
      content: Container(
        constraints: BoxConstraints.loose(
          const Size(kLargeScreenWidth, double.infinity),
        ),
        child: content,
      ),
      actions: actions ??
          <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final T? value = await _onConfirm();
                if (context.mounted) Navigator.pop(context, value);
              },
              child: const Text("Confirm"),
            ),
          ],
    );
  }
}
