import "dart:io";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/business/ffmpeg_entity.dart";
import "package:univid_compressor/core/business/ffmpeg_helper.dart";
import "package:univid_compressor/core/constants.dart";
import "package:univid_compressor/core/video_details.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/core/widgets/snackbars.dart";

class VideoPreviewContainer extends StatefulWidget {
  const VideoPreviewContainer({
    required VideoDetails videoDetails,
    required this.removeSelf,
    super.key,
  }) : _videoDetails = videoDetails;

  final void Function() removeSelf;
  final VideoDetails _videoDetails;

  @override
  State<VideoPreviewContainer> createState() => _VideoPreviewContainerState();
}

class _VideoPreviewContainerState extends State<VideoPreviewContainer> {
  late VideoDetails videoDetails = widget._videoDetails;

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
          child: ColumnWithSpacings(
            spacing: 8,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Thumbnail(videoDetails: videoDetails),
              ),
              Tooltip(
                message: videoDetails.name,
                child: Text(videoDetails.fileNameShort),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      color: Theme.of(context).colorScheme.error,
                      onPressed: () {
                        widget.removeSelf();
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    RowWithSpacings(
                      spacing: 4,
                      children: <Widget>[
                        TextButton(
                          onPressed: () async {
                            showNormalSnackbar(
                              context: context,
                              message: "Loading..",
                            );

                            try {
                              final newVideo = await VideoEntity(
                                initialVideo: videoDetails,
                                controller: context.read<FFMpegController>(),
                              ).changeScale(divideBy: 2);

                              setState(() {
                                videoDetails = newVideo;
                              });

                              if (context.mounted) {
                                showNormalSnackbar(
                                  context: context,
                                  message: "Finished!",
                                );
                              }
                            } catch (error) {
                              rethrow;
                              print(error);
                              if (context.mounted) {
                                showErrorSnackbar(
                                  context: context,
                                  message: "There was an error",
                                );
                              }
                            }

                            // showErrorSnackbar(
                            // context: context, message: result);
                            //? Ideas: For Linux download the binary and dependencies and execute ffmpeg commands based on it.
                            // FFmpegKit.execute(
                            //     "-i ${videoDetails.fileReference.path}");
                          },
                          child: const Text(
                            "FFMPEG",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Tooltip(
                          textAlign: TextAlign.center,
                          message:
                              "hello world", //TODO Display video details here
                          child: Icon(
                            color: Theme.of(context).colorScheme.secondary,
                            Icons.info,
                          ),
                        ),
                        Text(
                          videoDetails.sizeString,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Thumbnail extends StatelessWidget {
  const Thumbnail({
    required this.videoDetails,
    super.key,
  });

  final VideoDetails videoDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
      height: kMediumContainerWidth,
      width: kLargeContainerWidth,
      child: Image(
        image: FileImage(
          File(
            "/home/deadlyunicorn/Pictures/circle.jpg", //TODO future builder that gets the thumbnail from video using FFMPEG
          ),
        ),
        frameBuilder: (
          BuildContext context,
          Widget child,
          int? frame,
          bool wasSynchronouslyLoaded,
        ) =>
            frame != null
                ? child
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }
}
