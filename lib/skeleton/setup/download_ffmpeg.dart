import "dart:async";
import "dart:io";
import "dart:typed_data";

import "package:crypto/crypto.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:provider/provider.dart";
import "package:univid_compressor/core/business/ffmpeg_helper.dart";
import "package:univid_compressor/core/business/file_size_to_text.dart";
import "package:univid_compressor/core/business/univid_filesystem.dart";
import "package:univid_compressor/core/errors/exceptions.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/core/widgets/custom_linear_progress_indicator.dart";
import "package:univid_compressor/core/widgets/remove_static_binaries_button.dart";
import "package:univid_compressor/core/widgets/snackbars.dart";

class DownloadFFMpeg extends StatefulWidget {
  const DownloadFFMpeg({
    super.key,
  });

  @override
  State<DownloadFFMpeg> createState() => _DownloadFFMpegState();
}

class _DownloadFFMpegState extends State<DownloadFFMpeg> {
  String helperMessage = "";
  bool isDownloading = false;
  int totalFileSizeBytes = 0;
  int downloadedFileSizeBytes = 0;

  @override
  Widget build(BuildContext context) {
    return ColumnWithSpacings(
      spacing: 16,
      children: <Widget>[
        isDownloading
            ? const Column(
                children: <Widget>[
                  CustomLinearProgressIndicator(),
                ],
              )
            : Column(
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      try {
                        await handleDownloadButton();
                        await extractCompressedFile();

                        if (context.mounted) {
                          await context
                              .read<FFMpegController>()
                              .checkForStaticBinaries();
                        }
                      } on MD5CheckFailedException {
                        if (context.mounted) {
                          showErrorSnackbar(
                            context: context,
                            message: "MD5SUM doesn't match"
                                ". Retrying download..",
                          );
                        }
                        setHelperMessage("MD5sum check failed.. Try again.");
                      }
                    },
                    child: const Text("Download/Install static binaries"),
                  ),
                  const RemoveStaticBinariesButton(),
                ],
              ),
        Column(
          children: <Widget>[
            if (totalFileSizeBytes > 0)
              Text("Total: ${fileSizeToText(totalFileSizeBytes)}"),
            if (downloadedFileSizeBytes > 0)
              Text(
                "Downloaded: ${fileSizeToText(downloadedFileSizeBytes)}",
              ),
          ],
        ),
        Text(
          helperMessage,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> handleDownloadButton() async {
    try {
      final String md5sumFromWeb;

      final File ffmpegCompressedFile = File(
        "${(await UnividFilesystem.directory).path}/ffmpeg-git-amd64-static.tar.xz",
      );

      setState(() {
        isDownloading = true;
        totalFileSizeBytes = 0;
        downloadedFileSizeBytes = 0;
      });

      {
        //* Get the md5sum
        md5sumFromWeb = await http
            .get(
              Uri.parse(
                "https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz.md5",
              ),
            )
            .then((http.Response res) => res.body.split(" ")[0]);
      }

      {
        final bool fileExists = ffmpegCompressedFile.existsSync();
        final bool fileIsValid = fileExists
            ? await ffmpegCompressedFile.readAsBytes().then(
                  (Uint8List bytes) =>
                      md5.convert(bytes).toString() == md5sumFromWeb,
                )
            : false;
        if (!fileExists || !fileIsValid //?CHECKsum doesnt match
            ) {
          if (fileExists) await ffmpegCompressedFile.delete();
          final Directory ffmpegDir = (await UnividFilesystem.ffmpegDir);
          if (ffmpegDir.existsSync()) ffmpegDir.deleteSync(recursive: true);

          {
            //* Get total File size
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
          }

          final http.StreamedResponse res = await http.Request(
            "GET",
            Uri.parse(
              "https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz",
            ),
          ).send();

          //?Make it .asFuture() and await it, else the rest will execute
          //? That might have been the reason the file corrupted.
          await res.stream
              .timeout(
                const Duration(seconds: 6),
                onTimeout: (EventSink<List<int>> sink) {
                  sink.close();
                  showErrorSnackbar(
                    context: context,
                    message: "Connection timed out.",
                  );
                },
              )
              .listen(
                (List<int> chunk) async {
                  //!MUST BE SYNC. ELSE WILL CORRUPT.

                  ffmpegCompressedFile.writeAsBytesSync(
                    chunk,
                    mode: FileMode.writeOnlyAppend,
                  );
                  setState(() {
                    downloadedFileSizeBytes += chunk.length;
                  });
                },
                cancelOnError: true,
                onDone: () async {
                  setState(() {
                    isDownloading = false;
                  });
                  final String compressedFileMD5sum = md5
                      .convert(await ffmpegCompressedFile.readAsBytes())
                      .toString();

                  // print(compressedFileMD5sum);
                  // print(md5sumFromWeb);

                  if (compressedFileMD5sum != md5sumFromWeb) {
                    throw MD5CheckFailedException();
                  }
                  //? If md5sum is invalid it will redownload
                  //? Else it will proceed with the extraction
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
              )
              .asFuture();
        }
        setState(() {
          isDownloading = false;
        });
      }
    } on http.ClientException {
      if (mounted) {
        showErrorSnackbar(
          context: context,
          message: "Network error.",
        );
      }
      setState(() {
        isDownloading = false;
      });
    }
  }

  Future<void> extractCompressedFile() async {
    final File ffmpegCompressedFile = File(
      "${(await UnividFilesystem.directory).path}/ffmpeg-git-amd64-static.tar.xz",
    );
    final Directory workingDir = await UnividFilesystem.directory;
    final Directory ffmpegDir = Directory("${workingDir.path}/ffmpeg_static");
    if (ffmpegDir.existsSync() && ffmpegDir.listSync().isNotEmpty) {
      setHelperMessage(
        "FFmpeg static is installed: ${ffmpegDir.path}.\n"
        "Install might have been corrupted.\n"
        "Press remove.",
      );
    } else {
      setHelperMessage("Archive does exist.\n" "Checking ffmpeg..");
      await Process.run(
        "tar",
        <String>[
          "-xf",
          ffmpegCompressedFile.path,
          "--directory=${workingDir.path}",
        ],
        runInShell: true,
      ).then((ProcessResult value) async {
        await workingDir
            .listSync()
            .where(
              (FileSystemEntity element) => (FileSystemEntity.isDirectorySync(
                    element.path,
                  ) &&
                  element.path.contains("ffmpeg-git")),
            )
            .firstOrNull
            ?.rename(ffmpegDir.path);
      });
    }
  }

  void setHelperMessage(String text) {
    setState(() {
      helperMessage = text;
    });
  }
}
