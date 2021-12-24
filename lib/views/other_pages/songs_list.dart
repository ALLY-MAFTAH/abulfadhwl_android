import 'dart:io';
import 'package:abulfadhwl_android/constants/more_button_constants.dart';
import 'package:dio/dio.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:abulfadhwl_android/api.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:path_provider/path_provider.dart';
import 'package:abulfadhwl_android/models/song.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:abulfadhwl_android/providers/songs_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:abulfadhwl_android/views/other_pages/now_playing_screen_sheet.dart';

typedef BottomSheetCallback = void Function();

class SongsList extends StatefulWidget {
  final List<Song> songs;
  final String title;
  final SongsProvider songProvider;

  const SongsList({
    Key? key,
    required this.songs,
    required this.title,
    required this.songProvider,
  }) : super(key: key);

  @override
  _SongsListState createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool downloading = false;
  var progressString = "";
  late BottomSheetCallback? _showMyBottomSheetCallBack;
  late Song playingSong;
  late int newIndex = 0;

  @override
  void initState() {
    _showMyBottomSheetCallBack = _showBottomSheet;
    // widget.songProvider.initAudioPlayer();
    // MediaNotification.setListener('play', () {
    //   setState(() {
    //     widget.songProvider.isPlaying
    //         ? widget.songProvider.pause()
    //         : widget.songProvider.play();
    //   });
    // });
    // MediaNotification.setListener('pause', () {
    //   setState(() {
    //      widget.songProvider.isPlaying
    //         ? widget.songProvider.pause():
    //     widget.songProvider.play();
    //   });
    // });
    // MediaNotification.setListener('next', () {
    //   setState(() {
    //     widget.songProvider.next();
    //   });
    // });
    // MediaNotification.setListener('prev', () {
    //   setState(() {
    //     widget.songProvider.previous();
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.deepPurple[800],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.deepPurple[800]),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: widget.songs.isEmpty
                ? Center(
                    child: Text("Audio bado hazijawekwa"),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 5, top: 1.5, right: 5),
                          child: InkWell(
                            focusColor: Colors.blue,
                            onTap: () {
                              setState(() {
                                widget.songProvider.currentSongIndex = index;
                                widget.songProvider.currentSongFile = api +
                                    'song/file/' +
                                    widget.songs[index].id.toString();
                                widget.songProvider.currentSongId =
                                    widget.songs[index].id;
                                widget.songProvider.currentSongTitle =
                                    widget.songs[index].title;
                                widget.songProvider.currentSongDescription =
                                    widget.songs[index].description;

                                // widget.songProvider.stop();
                                // widget.songProvider.play();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: widget.songProvider.currentSongId ==
                                        widget.songs[index].id
                                    ? Colors.orange[200]
                                    : Colors.orange[100],
                              ),
                              child: Row(children: <Widget>[
                                Icon(
                                  Icons.music_note,
                                  color: Colors.orange[700],
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 5, top: 10, bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          widget.songs[index].title,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.deepPurple[800],
                                              fontWeight: FontWeight.bold,
                                              fontStyle: widget.songProvider
                                                          .currentSongId ==
                                                      widget.songs[index].id
                                                  ? FontStyle.italic
                                                  : FontStyle.normal),
                                        ),
                                        Text(
                                          widget.songs[index].description,
                                          style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontSize: 12,
                                              fontStyle: widget.songProvider
                                                          .currentSongId ==
                                                      widget.songs[index].id
                                                  ? FontStyle.italic
                                                  : FontStyle.normal),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: widget.songProvider.currentSongId ==
                                          widget.songs[index].id
                                      ? Icon(
                                          FontAwesomeIcons.play,
                                          color: Colors.orange[700],
                                        )
                                      : PopupMenuButton<String>(
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.orange[700],
                                          ),
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          color: Colors.orange[50],
                                          onSelected: choiceAction,
                                          itemBuilder: (_) {
                                            widget.songProvider
                                                .currentSongIndex = index;
                                            return MoreButtonConstants.choices
                                                .map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(
                                                  choice,
                                                  style: TextStyle(
                                                      color: Colors
                                                          .deepPurple[800],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              );
                                            }).toList();
                                          },
                                        ),
                                )
                              ]),
                            ),
                          ),
                        );
                      },
                      itemCount: widget.songs.length,
                    )),
          ),
          widget.songs.isEmpty
              ? Container()
              : widget.songProvider.currentSongFile.isEmpty
                  ? Container()
                  : InkWell(
                      onTap: () {
                        _showMyBottomSheetCallBack!();
                      },
                      child: Container(
                        color: Colors.white,
                        height: 60,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 35,
                                child: Image(
                                  color: Colors.orange[700],
                                  image: AssetImage("assets/icons/music.png"),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 10, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.songProvider.currentSongTitle,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.deepPurple[800],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.songProvider
                                            .currentSongDescription,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: widget.songProvider.isPlaying
                                    ? IconButton(
                                        iconSize: 30,
                                        icon: Icon(
                                          FontAwesomeIcons.pause,
                                          color: Colors.orange[700],
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // widget.songProvider.pause();
                                          });
                                        })
                                    : IconButton(
                                        iconSize: 30,
                                        icon: Icon(
                                          FontAwesomeIcons.play,
                                          color: Colors.orange[700],
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // widget.songProvider.play();
                                          });
                                        }),
                              ),
                            ]),
                      ),
                    )
        ],
      ),
    );
  }

  void _showBottomSheet() {
    setState(() {
      _showMyBottomSheetCallBack = null;
    });
    _scaffoldKey.currentState!
        .showBottomSheet((context) {
          return NowPlayingScreenSheet(
            key: null,
            songs: widget.songs,
            songProvider: widget.songProvider,
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showMyBottomSheetCallBack = _showBottomSheet;
            });
          }
        });
  }

  void choiceAction(String choice) {
    if (choice == MoreButtonConstants.PlayAudio) {
      setState(() {
        newIndex = widget.songProvider.currentSongIndex;
        widget.songProvider.currentSongFile = api +
            'song/file/' +
            widget.songs[widget.songProvider.currentSongIndex].id.toString();
        widget.songProvider.currentSongId =
            widget.songs[widget.songProvider.currentSongIndex].id;
        widget.songProvider.currentSongTitle =
            widget.songs[widget.songProvider.currentSongIndex].title;
        widget.songProvider.currentSongDescription =
            widget.songs[widget.songProvider.currentSongIndex].description;
        // Play audio

        // widget.songProvider.stop();
        // widget.songProvider.play();
      });
    } else if (choice == MoreButtonConstants.ShareAudio) {
      Share.share(api +
          'song/file/' +
          widget.songs[widget.songProvider.currentSongIndex].id.toString());
    } else
      downloadFile(
          api +
              'song/file/' +
              widget.songs[widget.songProvider.currentSongIndex].id.toString(),
          widget.songs[widget.songProvider.currentSongIndex].title);
  }

  Future<void> downloadFile(songUrl, songFileName) async {
    Dio dio = Dio();
    try {
      Directory? downloadsDirectory = await getExternalStorageDirectory();
      // downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

      // await dio.download(
      //     songUrl, downloadsDirectory.path + "/" + songFileName + ".mp3",
      //     onReceiveProgress: (rec, total) {
      //   print("Rec: $rec, Total: $total");
      //   setState(() {
      //     downloading = true;
      //     progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
      //   });
      //   print(downloadsDirectory!.path);

      //   // ignore: deprecated_member_use
      //   _scaffoldKey.currentState!.showSnackBar(SnackBar(
      //       content: Row(
      //         children: <Widget>[
      //           Text(
      //             "Downloading... $progressString",
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 13,
      //             ),
      //             textAlign: TextAlign.center,
      //           ),
      //         ],
      //       ),
      //       action: progressString == "100%"
      //           ? SnackBarAction(
      //               onPressed: () {
      //                 Navigator.pop(context);
      //               },
      //               label: "Close",
      //             )
      //           : null));
      // });
    } catch (e) {
      print(e);
    }
    print("Download completed");
  }
}
