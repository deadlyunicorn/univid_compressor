import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/business/ffmpeg_entity.dart";
import "package:univid_compressor/core/business/ffmpeg_helper.dart";
import "package:univid_compressor/core/stores/types/video_in_list.dart";
import "package:univid_compressor/core/video_details.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/core/widgets/custom_checkbox.dart";
import "package:univid_compressor/core/widgets/snackbars.dart";
import "package:univid_compressor/skeleton/video_queue/preparation/video_container/thumbnail.dart";

class VideoPreviewContainer<T extends VideoInList> extends StatelessWidget {
  const VideoPreviewContainer({
    required this.video,
    required this.updateVideo,
    super.key,
  });

  final T video;
  final void Function(T video) updateVideo;

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
                child: Thumbnail(videoDetails: video.videoDetails),
              ),
              Tooltip(
                message: video.videoDetails.name,
                child: Text(video.videoDetails.fileNameShort),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CustomCheckbox(
                      //TODO Looks misaligned..
                      isChecked: video.isSelected,
                      onChanged: (bool? isSelected) {
                        updateVideo(
                          video..isSelected = isSelected == true,
                        );
                      },
                    ),
                    RowWithSpacings(
                      spacing: 4,
                      children: <Widget>[
                        TemporaryCoolFfmpegButton(
                          videoDetails: video.videoDetails,
                        ),
                        Tooltip(
                          textAlign: TextAlign.center,
                          message:
                              // ignore: lines_longer_than_80_chars
                              "Selected Preset: ${video.preset?.title ?? "No preset found"}${video.preset != null ? "" : ""}", //TODO Display video details here
                          child: Icon(
                            color: video.preset != null
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.error,
                            video.preset != null
                                ? Icons.domain_verification_rounded
                                : Icons.pending_actions_rounded,
                          ),
                        ),
                        Text(
                          video.videoDetails.sizeString,
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

//TODO Future builder that gets the thumbnail
//TODO Video record date, length, resolution
//TODO Maybe we can hover over thumbnail and dislpay those ( if we don't playback)

class TemporaryCoolFfmpegButton extends StatefulWidget {
  const TemporaryCoolFfmpegButton({
    required this.videoDetails,
    super.key,
  });

  final VideoDetails videoDetails;

  @override
  State<TemporaryCoolFfmpegButton> createState() =>
      _TemporaryCoolFfmpegButtonState();
}

class _TemporaryCoolFfmpegButtonState extends State<TemporaryCoolFfmpegButton> {
  late final VideoEntity videoEntity = VideoEntity(
    initialVideo: widget.videoDetails,
    controller: context.read<FFMpegController>(),
  );
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        showNormalSnackbar(
          context: context,
          message: "Loading..",
        );

        try {
          final Future<VideoDetails> newVideo =
              videoEntity.changeScale(divideBy: 2);

          if (context.mounted) {
            showNormalSnackbar(
              context: context,
              message: "Finished!",
            );
          }
        } catch (error) {
          if (context.mounted) {
            showErrorSnackbar(
              context: context,
              message: error.toString(),
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
    );
  }
}
