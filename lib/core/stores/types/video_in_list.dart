import "package:flutter/material.dart";
import "package:univid_compressor/core/video_details.dart";
import "package:univid_compressor/database/database.dart";

abstract class VideoInList {

  VideoInList({
    required this.videoDetails,
    Preset? preset,
  });

  VideoDetails videoDetails;

  /// We will get the preset properties when the the video
  /// is about to get converted - so as to get the latest change.
  @protected
  Preset? preset_;
  bool isSelected = false;

  Preset? get preset => preset_;
  void setPreset(Preset preset);
}