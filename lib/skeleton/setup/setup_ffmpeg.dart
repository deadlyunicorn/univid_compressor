import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/business/ffmpeg_helper.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/skeleton/setup/download_ffmpeg.dart";

class SetupFFMpeg extends StatelessWidget {
  const SetupFFMpeg({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final SetupError? setupErrorMessage =
        context.select<FFMpegController, SetupError?>(
      (FFMpegController controller) => controller.setupError,
    );

    switch (setupErrorMessage) {
      //! Not implemented for Windows, MacOS etc.
      case SetupError.invalidPlatform:
        return SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Center(
            child: Text(
              "Your platform is not supported.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        );
      //* No errors - YET.
      default:
        return SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: const Center(
            child: ColumnWithSpacings(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "FFMpeg doesn't seem to exist.\n"
                  "You can install it manually and then restart the app.\n\n"
                  "If your system's architecture is x86_64\n"
                  " we can install the static binaries for you.",
                  textAlign: TextAlign.center,
                ),
                DownloadFFMpeg(),
              ],
            ),
          ),
        );
    }
  }
}
