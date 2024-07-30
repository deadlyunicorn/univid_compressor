import "dart:io";
import "package:flutter/material.dart";
import "package:univid_compressor/core/constants.dart";
import "package:univid_compressor/core/video_details.dart";

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
