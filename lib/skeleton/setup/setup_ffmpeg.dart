import "package:flutter/material.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/skeleton/setup/download_ffmpeg.dart";

class SetupFFMpeg extends StatelessWidget {
  const SetupFFMpeg({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: const Center(
        child: ColumnWithSpacings(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("FFMpeg doesn't seem to exist "),
            DownloadFFMpeg(),
          ],
        ),
      ),
    );
  }
}
