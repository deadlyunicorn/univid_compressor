import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/stores/preparation_videos_store.dart";
import "package:univid_compressor/core/stores/preset_store.dart";
import "package:univid_compressor/core/stores/processing_videos_store.dart";
import "package:univid_compressor/core/stores/types/preparation_video.dart";
import "package:univid_compressor/core/stores/types/processing_video.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/core/widgets/animated_appearance.dart";
import "package:univid_compressor/core/widgets/custom_scrollable_list.dart";
import "package:univid_compressor/core/widgets/error_button.dart";
import "package:univid_compressor/core/widgets/snackbars.dart";
import "package:univid_compressor/database/database.dart";
import "package:univid_compressor/skeleton/video_queue/list_container.dart";
import "package:univid_compressor/skeleton/video_queue/preparation/video_container/video_preview_container.dart";

class ProcessingList extends StatelessWidget {
  const ProcessingList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isEmpty = true;
    final List<ProcessingVideo> processingVideoList =
        context.watch<ProcessingVideosStore>().processingVideoList;

    final List<ProcessingVideo> selectedVideos = processingVideoList
        .where((ProcessingVideo video) => video.isSelected)
        .toList();

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: RowWithSpacings(
            spacing: 8,
            children: <Widget>[
              AnimatedAppearance(
                visibleIf: processingVideoList.isNotEmpty,
                child: TextButton(
                  onPressed: context.read<ProcessingVideosStore>().selectAll,
                  child: const Text("Select all"),
                ),
              ),
              AnimatedAppearance(
                visibleIf: selectedVideos.isNotEmpty,
                child: ErrorButton(
                  onPressed: context.read<ProcessingVideosStore>().unselectAll,
                  child: const Text("Unselect all"),
                ),
              ),
            ],
          ),
        ),
        processingVideoList.isEmpty
            ? const Center(child: Text("No videos to convert"))
            : ListContainer(
                child: processingVideoList.isEmpty
                    ? const Center(child: Text("No videos imported"))
                    : CustomScrollableList<ProcessingVideo>(
                        items: processingVideoList,
                        builder: ({
                          required int index,
                          required ProcessingVideo item,
                        }) =>
                            VideoPreviewContainer<ProcessingVideo>(
                          video: item,
                          updateVideo: (ProcessingVideo processingVideo) {
                            context.read<ProcessingVideosStore>().updateVideo(
                                  newVideo: processingVideo,
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
              //TODO
              print("DOes nothing");
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
                  onPressed: () {
                    context.read<PreparationVideosStore>().addVideos(
                          context
                              .read<ProcessingVideosStore>()
                              .moveWhereSelected()
                              .map(
                                (ProcessingVideo processingVideo) =>
                                    PreparationVideo(
                                  videoDetails: processingVideo.videoDetails,
                                  preset: processingVideo.preset,
                                ),
                              ),
                        );
                  },
                  child: const Text("Reconfigure selected"),
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
                              .read<ProcessingVideosStore>()
                              .setPresetForSelected(
                                preset: selectedPreset,
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
    );
  }
}
