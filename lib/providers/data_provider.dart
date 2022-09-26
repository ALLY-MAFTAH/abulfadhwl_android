

// ignore_for_file: argument_type_not_assignable_to_error_handler

import 'package:abulfadhwl_android/models/album.dart';
import 'package:abulfadhwl_android/models/song.dart';
import 'package:flutter/material.dart';
import 'package:abulfadhwl_android/constants/api.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

typedef void OnError(Exception exception);

class DataProvider extends ChangeNotifier {
  int currentSongIndex = 0;
  Album currentAlbum =
      Album(id: 0, name: "", description: "", categoryId: 0, songs: []);

  List<Song> songs = [];

  int searchedAudio = 0;

  Song currentSong =
      Song(id: 0, albumId: 0, title: "", size: 0, duration: "", file: "");

  final Dio _dio = Dio();

  String progress = "0";
  String downloadedFile = "";

  CancelToken cancelToken1 = CancelToken();
  CancelToken cancelToken2 = CancelToken();
  CancelToken token = CancelToken();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }

    return await getApplicationDocumentsDirectory();
  }

  void _onReceiveProgress(int received, int total) async {
    if (total != -1) {
      notifyListeners();
      progress = (received / total * 100).toStringAsFixed(0) + "%";
      await _showProgressNotification(received, total);

      notifyListeners();
      print('$progress');
    }
  }

  Future<void> _startDownload(
      String url, String fileName, String fileTitle, String savePath) async {
    downloadedFile = fileTitle;
    notifyListeners();
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio
          .download(
        url,
        savePath,
        cancelToken: token,
        onReceiveProgress: _onReceiveProgress,
      )
          .catchError((DioError err) {
        if (CancelToken.isCancel(err)) {
          print('Request canceled! ' + err.message);
        } else {
          print('Failed to cancel');
          token.cancel('cancelled');
        }
      });
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
      notifyListeners();
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> _startAlbumDownload(
    String url,
    String fileName,
    String fileTitle,
    String savePath,
  ) async {
    downloadedFile = fileTitle;
    notifyListeners();
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };
    try {
      final response = await _dio.download(url, savePath,
          cancelToken: cancelToken2, onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
      notifyListeners();
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> _showProgressNotification(int rec, int tot) async {
    notifyListeners();

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_notification_channel_id',
      'Download Notification',
      channelDescription: 'Download Notification Description',
      channelShowBadge: true,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
      enableVibration: false,
      showProgress: true,
      maxProgress: tot,
      progress: rec,
      color: Colors.orange,
    );
    notifyListeners();
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, downloadedFile, '$progress', platformChannelSpecifics,
        payload: 'none');

    notifyListeners();
  }

  Future<void> download(String url, String fileName, String fileTitle) async {
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await requestPermission();

    if (isPermissionStatusGranted) {
      final savePath = path.join(dir!.path, fileName);
      await _startDownload(url, fileName, fileTitle, savePath);
    } else {
      null;
    }
  }

  Future<void> downloadAlbum(List<Song> albumSongs) async {
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await requestPermission();

    if (isPermissionStatusGranted) {
      for (var albumSong in albumSongs) {
        final savePath = path.join(
          dir!.path,
          albumSong.file,
        );
        await _startAlbumDownload(api + 'song/file/' + albumSong.id.toString(),
            albumSong.file, albumSong.title, savePath);
      }
    } else {
      null;
    }
  }

  requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    return true;
  }

  void cancelDownload() {
    print("Cancel Download Now!!!!!!");
    token.cancel('cancelled');
    // cancelToken.cancel();
  }
}
