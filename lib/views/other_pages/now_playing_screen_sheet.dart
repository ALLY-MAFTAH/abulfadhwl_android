import 'package:abulfadhwl_android/models/song.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayer/audioplayer.dart';
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
    setState(() {
      widget.songProvider.initAudioPlayer();
    });
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
              color: Colors.orange[50],
              height: 60,
              child: Row(children: <Widget>[
                Container(
                  height: 40,
                  width: 25,
                  child: Icon(
                    Icons.music_note,
                    color: Colors.orange,
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
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _songObject.currentSongDescription,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 12, fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  color: Colors.orange,
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
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                        offset: Offset(0, 10), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "شيخ أبو الفضل قاسم بن مفوتا بن قاسم بن عثمان",
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "حفظه الله ورعاه",
                              style: TextStyle(),
                            ),
                            CircleAvatar(
                              radius: 100,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        'assets/images/ALLY W  008.png'),
                                    colorBlendMode: BlendMode.darken,
                                  ),
                                  Center(
                                    child: CircleAvatar(
                                      radius: 120,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.7),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 244, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: _songObject.changeShuffleIcon
                                    ? IconButton(
                                        iconSize: 30,
                                        icon: Icon(
                                          Icons.shuffle,
                                          color: Colors.orange,
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
                                              color: Colors.orange,
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
                                              color: Colors.orange,
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
                ),
                // ignore: unnecessary_null_comparison
                if (_songObject.duration != null)
                  Padding(
                      padding: EdgeInsets.only(top: 300, left: 10, right: 10),
                      child: ProgressBar(
                        timeLabelType: TimeLabelType.totalTime,
                        progress: _songObject.position,
                        timeLabelTextStyle: TextStyle(color: Colors.black),
                        total: _songObject.duration,
                        // onSeek: _songObject.audioPlayer(8),
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
                        color: Colors.orange,
                      ),
                      onPressed: () {
                        _songObject.previous();
                      },
                    ),
                  ),
                  Container(
                    child: _songObject.playerState == AudioPlayerState.PLAYING
                        ? IconButton(
                            iconSize: 50,
                            icon: Icon(
                              FontAwesomeIcons.pause,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              setState(() {
                                _songObject.pause();
                              });
                            })
                        : IconButton(
                            iconSize: 50,
                            icon: Icon(
                              FontAwesomeIcons.play,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              setState(() {
                                _songObject.play();
                              });
                            }),
                  ),
                  Expanded(
                    child: IconButton(
                        iconSize: 50,
                        icon: Icon(
                          Icons.skip_next,
                          color: Colors.orange,
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
                            _songObject.next();
                            _songObject.stop();
                            _songObject.play();
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
              color: Colors.orange,
              icon: Icon(
                FontAwesomeIcons.download,
                size: 17,
                color: Colors.white
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
