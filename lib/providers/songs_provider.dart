import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:abulfadhwl_android/api.dart';
import 'package:abulfadhwl_android/models/song.dart';
import 'package:abulfadhwl_android/models/song_category.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:dio/dio.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';

// ignore: import_of_legacy_library_into_null_safe
// import 'package:audioplayer/audioplayer.dart';
// ignore: import_of_legacy_library_into_null_safe

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
// import 'package:media_notification/media_notification.dart';
import 'package:path_provider/path_provider.dart';

typedef void OnError(Exception exception);

// enum AudioPlayerState { STOPPED, PLAYING, PAUSED }

class SongsProvider extends ChangeNotifier {
  List<SongCategory> _categories = [];
  List<Song> playlist = [];
  bool changeShuffleIcon = false;
  int repeatMode = 0;
  int currentSongIndex = 0;
  int currentSongId = 0;
  String currentSongFile = "";
  String currentSongTitle = "";
  String currentSongDescription = "";
  bool downloading = false;
  var progressString = "";
  Duration duration = Duration();
  Duration position = Duration();

  // int changeIndex = 0;
  // int songIndex = 0;

  late AudioPlayer audioPlayer;

  AudioPlayerState playerState = AudioPlayerState.STOPPED;

  get durationText => duration.toString().split('.').first;

  get positionText => position.toString().split('.').first;
  notifyListeners();

  // ignore: cancel_subscriptions
  late StreamSubscription positionSubscription;
  // ignore: cancel_subscriptions
  late StreamSubscription audioPlayerStateSubscription;
  @override
  void dispose() {
    positionSubscription.cancel();
    audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    positionSubscription =
        audioPlayer.onAudioPositionChanged.listen((p) => position = p);
    notifyListeners();
    audioPlayerStateSubscription = audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        duration = audioPlayer.duration;
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();

        notifyListeners();
        position = duration;
        notifyListeners();
      }
    }, onError: (msg) {
      playerState = AudioPlayerState.STOPPED;
      duration = Duration(seconds: 0);
      position = Duration(seconds: 0);
    });
    notifyListeners();
  }

  Future play() async {
    await audioPlayer.play(currentSongFile);
    playerState = AudioPlayerState.PLAYING;
    MediaNotification.showNotification(
        title: currentSongTitle,
        author: 'Sheikh Abul Fadhwl Kassim Mafuta Kassim');

    notifyListeners();
    print(durationText);
    print('durationText');
    print(durationText);
  }

  Future pause() async {
    audioPlayer.pause();
    playerState = AudioPlayerState.PAUSED;
    notifyListeners();
  }

  Future stop() async {
    await audioPlayer.stop();
    playerState = AudioPlayerState.STOPPED;
    position = Duration();
    notifyListeners();
  }

  Future next() async {
    if (repeatMode == 0) {
      return null;
    } else if (repeatMode == 1) {
      stop();
      play();
    } else if (repeatMode == 2) {
      if (currentSongIndex == playlist.length - 1) {
        currentSongIndex = 0;
        currentSongFile =
            api + 'song/file/' + playlist[currentSongIndex].id.toString();
        currentSongId = playlist[currentSongIndex].id;
        currentSongTitle = playlist[currentSongIndex].title;
        currentSongDescription = playlist[currentSongIndex].description;
        stop();
        play();
      } else {
        currentSongIndex++;
        currentSongFile =
            api + 'song/file/' + playlist[currentSongIndex].id.toString();
        currentSongId = playlist[currentSongIndex].id;
        currentSongTitle = playlist[currentSongIndex].title;
        currentSongDescription = playlist[currentSongIndex].description;
        stop();
        play();
      }
    } else
      return null;
    notifyListeners();
  }

  Future previous() async {
    if (repeatMode == 0) {
      return null;
    } else if (repeatMode == 1) {
      stop();
      play();
    } else if (repeatMode == 2) {
      if (currentSongIndex == 0) {
        currentSongIndex = playlist.length - 1;
        currentSongFile =
            api + 'song/file/' + playlist[currentSongIndex].id.toString();
        currentSongId = playlist[currentSongIndex].id;
        currentSongTitle = playlist[currentSongIndex].title;
        currentSongDescription = playlist[currentSongIndex].description;
        stop();
        play();
      } else {
        currentSongIndex--;
        currentSongFile =
            api + 'song/file/' + playlist[currentSongIndex].id.toString();
        currentSongId = playlist[currentSongIndex].id;
        currentSongTitle = playlist[currentSongIndex].title;
        currentSongDescription = playlist[currentSongIndex].description;
        stop();
        play();
      }
    } else
      return null;
    notifyListeners();
  }

  void onComplete() {
    playerState = AudioPlayerState.STOPPED;
    // repeatMode == 0
    //     ? stop()
    //     : repeatMode == 1
    //         ? play()
    //         : next();
    notifyListeners();
  }

  // late StreamSubscription _positionSubscription;
  // late StreamSubscription _audioPlayerStateSubscription;

  // @override
  // void dispose() {
  //   _positionSubscription.cancel();
  //   _audioPlayerStateSubscription.cancel();
  //   super.dispose();
  // }

  Future<void> downloadFile(_songUrl, _songFileName) async {
    Dio dio = Dio();
    try {
      Directory? downloadsDirectory = await getExternalStorageDirectory();
      // downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

      // await dio.download(
      //     _songUrl, downloadsDirectory.path + "/" + _songFileName + ".mp3",
      //     onReceiveProgress: (rec, total) {
      //   print("Rec: $rec, Total: $total");
      //   downloading = true;
      //   progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
      //   print(downloadsDirectory!.path);
      // });
    } catch (e) {
      print(e);
    }
    print("Download completed");
  }

  // getter
  List<SongCategory> get categories => _categories;

  Future<void> getAllCategories() async {
    List<SongCategory> _fetchedCategories = [];
    try {
      final response = await http.get(Uri.parse(api + 'categories/'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data['categories'].forEach(($category) {
          final dataSet = SongCategory.fromMap($category);
          _fetchedCategories.add(dataSet);
        });

        _categories = _fetchedCategories;
        print(_categories);
        print(_categories.length);
      }
    } catch (e) {
      print('Mambo yamejitindinganya');
      print(e);
    }
  }
}
