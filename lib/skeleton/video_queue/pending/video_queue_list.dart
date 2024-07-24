import "package:desktop_drop/desktop_drop.dart";
import "package:flutter/material.dart";
import "package:univid_compressor/core/errors/exceptions.dart";
import "package:univid_compressor/core/video_details.dart";
import "package:univid_compressor/core/widgets/snackbars.dart";
import "package:univid_compressor/skeleton/video_queue/list_container.dart";
import "package:univid_compressor/skeleton/video_queue/pending/import_videos_from_file_picker.dart";
import "package:univid_compressor/skeleton/video_queue/pending/video_container/video_preview_container.dart";

class VideoQueueList extends StatefulWidget {
  const VideoQueueList({
    super.key,
  });

  @override
  State<VideoQueueList> createState() => _VideoQueueListState();
}

class _VideoQueueListState extends State<VideoQueueList> {
  List<VideoDetails> videoList = <VideoDetails>[];

  //TODO show error indicators when file was moved/deleted/not found

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (DropDoneDetails details) async {
        final List<VideoDetails> videos =
            await VideoImport.importVideoDetailsListFromDesktopDrop(details);

        addVideos(videos);
      },
      child: Stack(
        children: <Widget>[
          ListContainer(
            child: videoList.isEmpty
                ? const Center(child: Text("No videos imported"))
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return VideoPreviewContainer(
                        removeSelf: () {
                          setState(() {
                            videoList.removeAt(index);
                          });
                        },
                        videoDetails: videoList[index],
                      );
                    },
                    itemCount: videoList.length,
                  ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPressed: importVideos,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Returns new videos that should have been added.
  int addVideos(Iterable<VideoDetails> candidateVideos) {
    final Iterable<String> alreadyImportedVideoFileUrls = videoList.map(
      (VideoDetails alreadyImportedVideo) =>
          alreadyImportedVideo.fileReference.path,
    );

    final Iterable<VideoDetails> newVideos = candidateVideos.where(
      (VideoDetails candidateVideo) => !alreadyImportedVideoFileUrls
          .contains(candidateVideo.fileReference.path),
    );

    final int videosToBeAddedLength = newVideos.length;

    setState(() {
      videoList.addAll(newVideos);
    });

    return videosToBeAddedLength;
  }

  Future<void> importVideos() async {
    try {
      final List<VideoDetails> videos =
          await VideoImport.importVideoDetailsListFromFilePicker();

      addVideos(videos);
    } on NoFilesFoundExcepetion {
      if (mounted) {
        showErrorSnackbar(
          context: context,
          message: "No files imported.",
        );
      }
    } on FileErrorException catch (fileErrorException) {
      if (mounted) {
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
