import "package:flutter/material.dart";
import "package:univid_compressor/core/business/univid_filesystem.dart";

class RemoveStaticBinariesButton extends StatelessWidget {
  const RemoveStaticBinariesButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(primary: Theme.of(context).colorScheme.error),
      ),
      child: TextButton(
        onPressed: () async {
          await (await UnividFilesystem.directory).delete(
            recursive: true,
          );
        },
        child: Text(
          "Remove static binaries",
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
