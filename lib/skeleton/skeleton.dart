import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/business/ffmpeg_helper.dart";
import "package:univid_compressor/core/constants.dart";
import "package:univid_compressor/core/stores/preset_store.dart";
import "package:univid_compressor/core/stores/settings_store.dart";
import "package:univid_compressor/database/database.dart";
import "package:univid_compressor/skeleton/main_app.dart";
import "package:univid_compressor/skeleton/setup/setup_ffmpeg.dart";

class Skeleton extends StatelessWidget {
  const Skeleton({required this.database, super.key});

  final AppDatabase database;

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
                      ? MultiProvider(
                          // ignore: always_specify_types
                          providers: [
                            Provider<AppDatabase>(
                              create: (BuildContext context) => database,
                            ),
                            ChangeNotifierProvider<PresetStore>(
                              create: (BuildContext context) =>
                                  PresetStore(database: database),
                            ),
                             ChangeNotifierProvider<SettingsStore>(
                              create: (BuildContext context) =>
                                  SettingsStore(database: database),
                            ),
                          ],
                          child: const MainApp(),
                        )
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
