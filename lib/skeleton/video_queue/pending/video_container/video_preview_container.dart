import "package:flutter/material.dart";
import "package:univid_compressor/core/constants.dart";
import "package:univid_compressor/core/video_details.dart";
import "package:univid_compressor/core/widgets.dart";

class VideoPreviewContainer extends StatelessWidget {
  const VideoPreviewContainer({
    required this.videoDetails,
    required this.removeSelf,
    super.key,
  });

  final VideoDetails videoDetails;
  final void Function() removeSelf;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              ColumnWithSpacings(
                spacing: 8,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: kMediumContainerWidth,
                      width: kLargeContainerWidth,
                    ),
                  ),
                  Tooltip(
                    message: videoDetails.name,
                    child: Text(videoDetails.fileNameShort),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      videoDetails.sizeString,
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                top: 0,
                child: IconButton(
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () {
                    removeSelf();
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO Future builder that gets the thumbnail
  //TODO Video record date, length, resolution
  //TODO Maybe we can hover over thumbnail and dislpay those ( if we don't playback)
}
