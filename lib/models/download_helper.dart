import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_downloader/models/notification.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloaderHelper {
  YoutubeExplode youtubeExplode = YoutubeExplode();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<Map<String, dynamic>> getVideoInfo(Uri url) async {
    Video video = await youtubeExplode.videos.get(url.toString());
    var manifest =
        await youtubeExplode.videos.streamsClient.getManifest(video.id);
    ThumbnailSet image = video.thumbnails;

    return {
      "title": video.title,
      "author": video.author,
      "duration": video.duration,
      "image": image.highResUrl.toString(),
      "id": video.id,
      "mp3": manifest.audioOnly
          .withHighestBitrate()
          .size
          .totalMegaBytes
          .toStringAsFixed(3),
      "mp4": manifest.muxed
          .withHighestBitrate()
          .size
          .totalMegaBytes
          .toStringAsFixed(3),
    };
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  downloadMp3(VideoId videoId, String name) async {
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          print("Permission Granted !\n");
          var manifest =
              await youtubeExplode.videos.streamsClient.getManifest(videoId);

          var streamInfo = manifest.audioOnly;
          int count = 0;
          if (streamInfo != null) {
            var totalSize =
                manifest.audioOnly.withHighestBitrate().size.totalBytes;

            var stream = youtubeExplode.videos.streamsClient
                .get(streamInfo.withHighestBitrate());

            String directory = await createAudioDirectory();
            //Directory('/storage/emulated/0/Download');
            var file =
                File("$directory/$name-${DateTime.now().millisecond}.mp3");

            var fileStream = file.openWrite(mode: FileMode.writeOnlyAppend);

            // Pipe all the content of the stream into the file.
            // await stream.pipe(fileStream);
            await for (final data in stream) {
              count += data.length;

              var progress = ((count / totalSize) * 100).ceil();
              print("$progress%");
              fileStream.add(data);

              LocalNotificationService.showProgressNotification(
                progrss: progress,
                maxProgress: 100,
                title: "Downlaoding...",
                body: name,
              );
            }
            Future.delayed(const Duration(milliseconds: 1500));
            await LocalNotificationService.cancelAllNotifications();

            // Close the file.
            await fileStream.flush();
            await fileStream.close();
            await LocalNotificationService.showNotification(
                title: "Audio Downloaded !", body: name);
            print("Audio Downloaded");
          } else {
            throw "Stream Info is Null";
          }
        }
      }
    } catch (e) {
      print("downloadMp3 Method Error! = $e");
    }
  }

  downloadMp4(VideoId videoId, String name) async {
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          print("Permission Granted !\n");
          var manifest =
              await youtubeExplode.videos.streamsClient.getManifest(videoId);

          var streamInfo = manifest.muxed;

          if (streamInfo != null) {
            var stream = youtubeExplode.videos.streamsClient
                .get(streamInfo.withHighestBitrate());

            var directory = await createVideoDirectory();
            var file =
                File("$directory/$name-${DateTime.now().millisecond}.mp4");
            var fileStream = file.openWrite(mode: FileMode.writeOnlyAppend);
            int count = 0;
            var totalSize =
                manifest.videoOnly.withHighestBitrate().size.totalBytes;
            // Pipe all the content of the stream into the file.
            //await stream.pipe(fileStream);
            await for (final data in stream) {
              count += data.length;

              var progress = ((count / totalSize) * 100).ceil();
              print("$progress%");
              //Show Notification
              LocalNotificationService.showProgressNotification(
                progrss: progress,
                maxProgress: 100,
                title: "Downlaoding...",
                body: name,
              );
              fileStream.add(data);
            }
            Future.delayed(const Duration(milliseconds: 1500));
            await LocalNotificationService.cancelAllNotifications();

            // Close the file.
            await fileStream.flush();
            await fileStream.close();
            await LocalNotificationService.showNotification(
                title: "Video Downloaded !", body: name);
            print("Video Downloaded");
          } else {
            throw "Stream Info is Null";
          }
        }
      }
    } catch (e) {
      print("downloadMp4 Method Error! = $e");
    }
  }

  Future<String> createAppDirectory() async {
    var status = Permission.manageExternalStorage.status;
    if (await status.isDenied) {
      Permission.manageExternalStorage.request();
    }
    String name = "yt-downloader";
    final path = Directory("/storage/emulated/0/$name");
    if (await path.exists()) {
      print(path.path);
      return path.path;
    }

    path.create();
    print(path.path);

    return path.path;
  }

  Future<String> createAudioDirectory() async {
    String directory = await createAppDirectory();
    String name = "Audio";
    var status = Permission.manageExternalStorage.status;
    if (await status.isDenied) {
      Permission.manageExternalStorage.request();
    }
    final path = Directory("$directory/$name");
    if (await path.exists()) {
      return path.path;
    }

    path.create();
    return path.path;
  }

  Future<String> createVideoDirectory() async {
    String directory = await createAppDirectory();
    String name = "Video";
    var status = Permission.manageExternalStorage.status;
    if (await status.isDenied) {
      Permission.manageExternalStorage.request();
    }
    final path = Directory("$directory/$name");
    if (await path.exists()) {
      return path.path;
    }

    path.create();
    return path.path;
  }
}
