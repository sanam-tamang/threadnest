import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:threadnest/common/utils/app_toast.dart';

class FileDownloaderWidget extends StatefulWidget {
  final String fileUrl;
  final String? prefix;
  final Widget child;
  const FileDownloaderWidget({
    super.key,
    required this.fileUrl,
    this.prefix,
    required this.child,
  });

  @override
  State<FileDownloaderWidget> createState() => _FileDownloaderWidgetState();
}

class _FileDownloaderWidgetState extends State<FileDownloaderWidget> {
  final ReceivePort _port = ReceivePort();
  DownloadTaskStatus? dStatus;
  int progress = 0;

  @override
  void initState() {
    super.initState();

    // Register the ReceivePort with the IsolateNameServer
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');

    _port.listen((dynamic data) {
      String id = data[0];
      int status = data[1];
      progress = data[2];

      setState(() {
        dStatus = DownloadTaskStatus.values[status];
      });

      print(
          'Download task ($id) is in status ($dStatus) and progress ($progress)');
    });

    // Register the callback
    FlutterDownloader.registerCallback(downloadCallback);
  }

  // Ensure this is a top-level or static function
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  void dispose() {
    // Unregister the port when the widget is disposed
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  void _startDownload() async {
    try {
      final permissionStatus = await Permission.notification.status;
      if (!permissionStatus.isGranted) {
        await Permission.notification.request();
      }

      final directory = await getDownloadsDirectory();

      final savedDir = directory?.path;
      final taskId = await FlutterDownloader.enqueue(
        url: (widget.prefix ??
                "https://zzpafhzqyklbkmcogjvs.supabase.co/storage/v1/object/public/") +
            widget.fileUrl,
        savedDir: savedDir!,
        fileName: widget.fileUrl.split("/").last.split("+").last,
        showNotification: true,
        openFileFromNotification: true,
      );

      print('Download started with task ID: $taskId');
    } catch (e) {
      AppToast.show("Error starting download: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _startDownload();
        },
        child: widget.child);
  }
}
