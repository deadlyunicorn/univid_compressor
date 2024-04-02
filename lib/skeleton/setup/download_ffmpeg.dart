import "dart:async";
import "dart:io";

import "package:flutter/material.dart";
import "package:univid_compressor/core/business/file_size_to_text.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/core/widgets/custom_linear_progress_indicator.dart";
import "package:http/http.dart" as http;
import "package:univid_compressor/core/widgets/snackbars.dart";

class DownloadFFMpeg extends StatefulWidget {
  const DownloadFFMpeg({
    super.key,
  });

  @override
  State<DownloadFFMpeg> createState() => _DownloadFFMpegState();
}

class _DownloadFFMpegState extends State<DownloadFFMpeg> {
  bool isDownloading = false;
  int totalFileSizeBytes = 0;
  int downloadedFileSizeBytes = 0;

  @override
  Widget build(BuildContext context) {
    return ColumnWithSpacings(
      spacing: 16,
      children: <Widget>[
        isDownloading
            ? Column(
                children: <Widget>[
                  CustomLinearProgressIndicator(),
                ],
              )
            : Column(
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          isDownloading = true;
                          totalFileSizeBytes = 0;
                          downloadedFileSizeBytes = 0;
                        });
                        final http.Response ffmpegHead = await http.head(
                          Uri.parse(
                            "https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz",
                          ),
                        );

                        setState(() {
                          totalFileSizeBytes = int.tryParse(
                                ffmpegHead.headers["content-length"] ?? "0",
                              ) ??
                              0;
                        });

                        final http.StreamedResponse res = await http.Request(
                          "GET",
                          Uri.parse(
                            "https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz",
                          ),
                        ).send();

                        res.stream.timeout(
                          const Duration(seconds: 6),
                          onTimeout: (EventSink<List<int>> sink) {
                            sink.close();
                            showErrorSnackbar(
                              context: context,
                              message: "Connection timed out.",
                            );
                          },
                        ).listen(
                          (List<int> chunk) {
                            //TODO Save to file.
                            setState(() {
                              downloadedFileSizeBytes += chunk.length;
                            });
                          },
                          cancelOnError: true,
                          onDone: () {
                            setState(() {
                              isDownloading = false;
                            });
                            //TODO extract the file.
                          },
                          onError: (Object error) {
                            showErrorSnackbar(
                              context: context,
                              message: "Download failed.",
                            );
                            setState(() {
                              isDownloading = false;
                            });
                          },
                        );
                      } on http.ClientException {
                        if (context.mounted) {
                          showErrorSnackbar(
                            context: context,
                            message: "Network error.",
                          );
                        }
                        setState(() {
                          isDownloading = false;
                        });
                      }
                    },
                    child: Text("Install Static Binaries"),
                  ),
                ],
              ),
        Column(
          children: <Widget>[
            if (totalFileSizeBytes > 0)
              Text("Total: ${fileSizeToText(totalFileSizeBytes)}"),
            if (downloadedFileSizeBytes > 0)
              Text("Downloaded: ${fileSizeToText(downloadedFileSizeBytes)}"),
          ],
        ),
      ],
    );
  }
}
