import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/business/ffmpeg_helper.dart";
import "package:univid_compressor/core/constants.dart";
import "package:univid_compressor/skeleton/main_app.dart";
import "package:univid_compressor/skeleton/setup/setup_ffmpeg.dart";

class Skeleton extends StatelessWidget {
  const Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: k3XLScreenWidth,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16),
              child: ChangeNotifierProvider<FFMpegController>(
                create: (BuildContext context) => FFMpegController.initialize(),
                builder: (BuildContext context, Widget? child) {
                  return context.watch<FFMpegController>().ffmpegExists
                      ? const MainApp()
                      : const SetupFFMpeg();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
