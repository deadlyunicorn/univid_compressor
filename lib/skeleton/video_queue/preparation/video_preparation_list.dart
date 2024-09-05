import "package:desktop_drop/desktop_drop.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/errors/exceptions.dart";
import "package:univid_compressor/core/stores/preparation_videos_store.dart";
import "package:univid_compressor/core/stores/preset_store.dart";
import "package:univid_compressor/core/stores/processing_videos_store.dart";
import "package:univid_compressor/core/stores/types/preparation_video.dart";
import "package:univid_compressor/core/stores/types/processing_video.dart";
import "package:univid_compressor/core/video_details.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/core/widgets/animated_appearance.dart";
import "package:univid_compressor/core/widgets/custom_scrollable_list.dart";
import "package:univid_compressor/core/widgets/error_button.dart";
import "package:univid_compressor/core/widgets/snackbars.dart";
import "package:univid_compressor/database/database.dart";
import "package:univid_compressor/skeleton/video_queue/list_container.dart";
import "package:univid_compressor/skeleton/video_queue/preparation/import_videos_from_file_picker.dart";
import "package:univid_compressor/skeleton/video_queue/preparation/video_container/video_preview_container.dart";

class VideoPreparationList extends StatelessWidget {
  const VideoPreparationList({
    super.key,
  });

  //TODO show error indicators when file was moved/deleted/not found
  @override
  Widget build(BuildContext context) {
    final List<PreparationVideo> preparationVideoList =
        context.watch<PreparationVideosStore>().preparationVideoList;

    final Iterable<PreparationVideo> selectedVideos =
        preparationVideoList.where(
      (PreparationVideo element) => element.isSelected,
    );

    return DropTarget(
      onDragDone: (DropDoneDetails details) async {
        final Iterable<PreparationVideo> videos =
            (await VideoImport.importVideoDetailsListFromDesktopDrop(details))
                .map(
          (VideoDetails videoDetails) =>
              PreparationVideo(videoDetails: videoDetails),
        );

        if (context.mounted) {
          context.read<PreparationVideosStore>().addVideos(
                videos,
              );
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: RowWithSpacings(
              spacing: 8,
              children: <Widget>[
                AnimatedAppearance(
                  visibleIf: preparationVideoList.isNotEmpty,
                  child: TextButton(
                    onPressed: context.read<PreparationVideosStore>().selectAll,
                    child: const Text("Select all"),
                  ),
                ),
                AnimatedAppearance(
                  visibleIf: selectedVideos.isNotEmpty,
                  child: ErrorButton(
                    onPressed:
                        context.read<PreparationVideosStore>().unselectAll,
                    child: const Text("Unselect all"),
                  ),
                ),
              ],
            ),
          ),
          ListContainer(
            child: preparationVideoList.isEmpty
                ? const Center(child: Text("No videos imported"))
                : CustomScrollableList<PreparationVideo>(
                    items: preparationVideoList,
                    builder: ({
                      required int index,
                      required PreparationVideo item,
                    }) =>
                        VideoPreviewContainer<PreparationVideo>(
                      video: item,
                      updateVideo: (PreparationVideo preparationVideo) {
                        context.read<PreparationVideosStore>().updateVideo(
                              newVideo: preparationVideo,
                              index: index,
                            );
                      },
                    ),
                  ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                importVideos(context: context);
              },
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: AnimatedAppearance(
              visibleIf: selectedVideos.isNotEmpty,
              child: Row(
                children: <Widget>[
                  ErrorButton(
                    onPressed:
                        context.read<PreparationVideosStore>().removeSelected,
                    child: const Text("Remove selected"),
                  ),
                  if (context.watch<PresetStore>().selectedPreset != null)
                    SizedBox(
                      width: 200,
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            final Preset? selectedPreset =
                                context.read<PresetStore>().selectedPreset;
                            if (selectedPreset == null) {
                              return showErrorSnackbar(
                                context: context,
                                message: "Please create and select a Preset",
                              );
                            }
                            context
                                .read<PreparationVideosStore>()
                                .setPresetForSelected(preset: selectedPreset);

                            final Iterable<PreparationVideo>
                                validPreparationVideos = context
                                    .read<PreparationVideosStore>()
                                    .moveWhereSelected();

                            if (validPreparationVideos.isEmpty) {
                              return showErrorSnackbar(
                                context: context,
                                message: "No videos available to process.",
                              );
                            }
                            context.read<ProcessingVideosStore>().addVideos(
                                  validPreparationVideos.map(
                                    (PreparationVideo preparationVideo) =>
                                        ProcessingVideo(
                                      videoDetails:
                                          preparationVideo.videoDetails,
                                      preset: preparationVideo.preset!,
                                    ),
                                  ),
                                );
                          },
                          child: Text(
                            // ignore: lines_longer_than_80_chars
                            "Apply preset: `${context.watch<PresetStore>().selectedPreset!.title}`",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> importVideos({
    required BuildContext context,
  }) async {
    try {
      final Iterable<PreparationVideo> videos =
          (await VideoImport.importVideoDetailsListFromFilePicker()).map(
        (VideoDetails videoDetails) =>
            PreparationVideo(videoDetails: videoDetails),
      );

      if (context.mounted) {
        context.read<PreparationVideosStore>().addVideos(videos);
      }
    } on NoFilesFoundExcepetion {
      if (context.mounted) {
        showErrorSnackbar(
          context: context,
          message: "No files imported.",
        );
      }
    } on FileErrorException catch (fileErrorException) {
      if (context.mounted) {
        showErrorSnackbar(
          context: context,
          message:
              // ignore: lines_longer_than_80_chars
              "There was an issue importing ${fileErrorException.fileName}. Try again excluding it.",
        );
      }
    }
  }
}
