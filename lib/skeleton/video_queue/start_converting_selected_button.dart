import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/stores/preparation_videos_store.dart";
import "package:univid_compressor/core/widgets/snackbars.dart";

class StartConvertingSelectedButton extends StatelessWidget {
  const StartConvertingSelectedButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      waitDuration: const Duration(milliseconds: 640),
      textAlign: TextAlign.center,
      message:
          // ignore: lines_longer_than_80_chars
          "${"Convert queued videos\nwhere there is a preset set\n${context.watch<PreparationVideosStore>().preparationVideoList.length}"} video(s))",
      child: TextButton(
        onPressed: () async {
          showNormalSnackbar(context: context, message: "helloWorld!");
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Start Conversions"),
              Icon(
                Icons.keyboard_double_arrow_right_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
