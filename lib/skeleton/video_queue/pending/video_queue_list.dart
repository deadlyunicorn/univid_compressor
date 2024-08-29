import "package:desktop_drop/desktop_drop.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/errors/exceptions.dart";
import "package:univid_compressor/core/stores/preset_store.dart";
import "package:univid_compressor/core/video_details.dart";
import "package:univid_compressor/core/widgets/snackbars.dart";
import "package:univid_compressor/skeleton/video_queue/list_container.dart";
import "package:univid_compressor/skeleton/video_queue/pending/import_videos_from_file_picker.dart";
import "package:univid_compressor/skeleton/video_queue/pending/queued_video.dart";
import "package:univid_compressor/skeleton/video_queue/pending/video_container/video_preview_container.dart";

class VideoQueueList extends StatefulWidget {
  const VideoQueueList({
    super.key,
  });

  @override
  State<VideoQueueList> createState() => _VideoQueueListState();
}

class _VideoQueueListState extends State<VideoQueueList> {
  List<QueuedVideo> videoList = <QueuedVideo>[];

  //TODO show error indicators when file was moved/deleted/not found

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (DropDoneDetails details) async {
        final Iterable<QueuedVideo> videos =
            (await VideoImport.importVideoDetailsListFromDesktopDrop(details))
                .map(
          (VideoDetails videoDetails) =>
              QueuedVideo(videoDetails: videoDetails),
        );

        addVideos(
          videos,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          const Positioned(
            top: 0,
            child: Text("TODO, Select all if 1 selected button or dismiss"),
          ),
          ListContainer(
            child: videoList.isEmpty
                ? const Center(child: Text("No videos imported"))
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return VideoPreviewContainer(
                        queuedVideo: videoList[index],
                        updateVideo: (QueuedVideo queuedVideo) {
                          setState(() {
                            videoList[index] = queuedVideo;
                          });
                        },
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
  int addVideos(Iterable<QueuedVideo> candidateVideos) {
    final Iterable<String> alreadyImportedVideoFileUrls = videoList.map(
      (QueuedVideo alreadyImportedVideo) =>
          alreadyImportedVideo.videoDetails.fileReference.path,
    );

    final Iterable<QueuedVideo> newVideos = candidateVideos.where(
      (QueuedVideo candidateVideo) => !alreadyImportedVideoFileUrls
          .contains(candidateVideo.videoDetails.fileReference.path),
    );

    final int videosToBeAddedLength = newVideos.length;

    setState(() {
      videoList.addAll(newVideos);
    });

    return videosToBeAddedLength;
  }

  Future<void> importVideos() async {
    try {
      final Iterable<QueuedVideo> videos =
          ( await VideoImport.importVideoDetailsListFromFilePicker()).map(
          (VideoDetails videoDetails) =>
              QueuedVideo(videoDetails: videoDetails),
        );

      addVideos(
        videos,
      );
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
