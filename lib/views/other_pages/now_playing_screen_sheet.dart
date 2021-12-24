
import 'package:abulfadhwl_android/models/song.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/providers/songs_provider.dart';
import 'package:share/share.dart';

class NowPlayingScreenSheet extends StatefulWidget {
  final List<Song> songs;
  final SongsProvider songProvider;

  const NowPlayingScreenSheet(
      {Key? key, required this.songs, required this.songProvider})
      : super(key: key);

  @override
  _NowPlayingScreenSheetState createState() => _NowPlayingScreenSheetState();
}

class _NowPlayingScreenSheetState extends State<NowPlayingScreenSheet> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool downloading = false;
  var progressString = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _songObject = Provider.of<SongsProvider>(context);
    return Container(
      key: _scaffoldKey,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: 60,
              child: Row(children: <Widget>[
                Container(
                  height: 40,
                  width: 25,
                  child: Icon(
                    Icons.music_note,
                    color: Colors.orange[700],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _songObject.currentSongTitle,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.deepPurple[800],
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _songObject.currentSongDescription,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 12,
                              fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  color: Colors.orange[700],
                  icon: Icon(FontAwesomeIcons.share),
                  onPressed: () {
                    Share.share(
                      _songObject.currentSongFile,
                    );
                  },
                ),
              ]),
            ),
            Stack(
              children: <Widget>[
                Card(
                  elevation: 10,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "شيخ أبو الفضل قاسم مفوتا قاسم",
                            style: TextStyle(
                                color: Colors.deepPurple[800],
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            "حفظه الله ورعاه",
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                          CircleAvatar(
                            radius: 140,
                            backgroundColor:
                                Colors.orange[50]!.withOpacity(0.5),
                            child: Icon(
                              FontAwesomeIcons.music,
                              size: 110,
                              color: Colors.orange[100]!.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 300, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: _songObject.changeShuffleIcon
                                  ? IconButton(
                                      iconSize: 30,
                                      icon: Icon(
                                        Icons.shuffle,
                                        color: Colors.orange[700],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _songObject.changeShuffleIcon =
                                              !_songObject.changeShuffleIcon;
                                        });
                                      },
                                    )
                                  : IconButton(
                                      iconSize: 30,
                                      icon: Icon(
                                        Icons.shuffle,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _songObject.changeShuffleIcon =
                                              !_songObject.changeShuffleIcon;
                                        });
                                      },
                                    ),
                            ),
                            Container(
                              child: _songObject.repeatMode == 0
                                  ? IconButton(
                                      iconSize: 30,
                                      icon: Icon(
                                        Icons.repeat,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          print(_songObject.repeatMode);
                                          _songObject.repeatMode++;
                                        });
                                      },
                                    )
                                  : _songObject.repeatMode == 1
                                      ? IconButton(
                                          iconSize: 30,
                                          icon: Icon(
                                            Icons.repeat_one,
                                            color: Colors.orange[700],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              print(_songObject.repeatMode);
                                              _songObject.repeatMode++;
                                            });
                                          },
                                        )
                                      : IconButton(
                                          iconSize: 30,
                                          icon: Icon(
                                            Icons.repeat,
                                            color: Colors.orange[700],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              print(_songObject.repeatMode);
                                              _songObject.repeatMode =
                                                  _songObject.repeatMode - 2;
                                            });
                                          },
                                        ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // ignore: unnecessary_null_comparison
                if (_songObject.duration != null)
                  Padding(
                      padding: EdgeInsets.only(top: 360, left: 10, right: 10),
                      child: ProgressBar(
                        timeLabelType: TimeLabelType.totalTime,
                        progress: _songObject.position,
                        // buffered: _songObject.buffered,
                        total: _songObject.duration,
                        timeLabelTextStyle:
                            TextStyle(color: Colors.deepPurple[800]),
                        // onSeek: _songObject.audioPlayer.seek(9),
                      ))
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: IconButton(
                      iconSize: 50,
                      icon: Icon(
                        Icons.skip_previous,
                        color: Colors.orange[700],
                      ),
                      onPressed: () {                        
                        // _songObject.previous();
                                              },
                    ),
                  ),
                  Container(
                    child: _songObject.isPlaying
                        ? IconButton(
                            iconSize: 50,
                            icon: Icon(
                              FontAwesomeIcons.pause,
                              color: Colors.orange[700],
                            ),
                            onPressed: () {
                              setState(() {
                                // _songObject.pause();
                              });
                            })
                        : IconButton(
                            iconSize: 50,
                            icon: Icon(
                              FontAwesomeIcons.play,
                              color: Colors.orange[700],
                            ),
                            onPressed: () {
                              setState(() {
                                // _songObject.play();
                              });
                            }),
                  ),
                  Expanded(
                    child: IconButton(
                        iconSize: 50,
                        icon: Icon(
                          Icons.skip_next,
                          color: Colors.orange[700],
                        ),
                        onPressed: () {
                          setState(() {
                            //   if (_songObject.currentSongIndex ==
                            //       widget.songs.length - 1) {
                            //     _songObject.currentSongIndex = 0;
                            //   } else {
                            //     ++_songObject.currentSongIndex;
                            //     _songObject.currentSongFile = api +
                            //         'song/file/' +
                            //         widget.songs[_songObject.currentSongIndex].id
                            //             .toString();
                            //     _songObject.currentSongId =
                            //         widget.songs[_songObject.currentSongIndex].id;
                            //     _songObject.currentSongTitle = widget
                            //         .songs[_songObject.currentSongIndex].title;
                            //     _songObject.currentSongDescription = widget
                            //         .songs[_songObject.currentSongIndex]
                            //         .description;
                            //   }
                          //  //  _songObject.next();
                            //   // Play audio
                            //   _songObject.stop();
                            //   _songObject.play();
                          });
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // ignore: deprecated_member_use
            RaisedButton.icon(
              elevation: 5,
              color: Colors.orange[700],
              icon: Icon(
                FontAwesomeIcons.download,
                color: Colors.deepPurple[800],
                size: 17,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              label: Text(
                'PAKUA',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                _songObject.downloadFile("", "");
                // ignore: deprecated_member_use
                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                    content: Row(
                      children: <Widget>[
                        Text(
                          "Downloading... $progressString",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    action: progressString == "100%"
                        ? SnackBarAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            label: "Close",
                          )
                        : null));
              },
            ),
           
          ],
        ),
      ),
    );
  }
}
