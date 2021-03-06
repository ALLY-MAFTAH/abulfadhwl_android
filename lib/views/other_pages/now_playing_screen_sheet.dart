import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/views/components/controls.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../../constants/api.dart';

class NowPlayingScreenSheet extends StatefulWidget {
  final DataProvider dataProvider;

  NowPlayingScreenSheet({Key? key, required this.dataProvider})
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
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
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
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CurrentSongTitle(),
                        Text(
                          widget.dataProvider.currentSong.size.toString() +
                              ' MB',
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
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share(
                      widget.dataProvider.currentSong.file,
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
                        blurRadius: 15,
                        offset: Offset(0, 10),
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
                              "?????? ?????? ?????????? ???????? ???? ?????????? ???? ???????? ???? ??????????",
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "???????? ???????? ??????????",
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
                            children: [
                              RepeatButton(),
                              IconButton(
                                icon: Icon(Icons.download,
                                    color: Colors.orange, size: 30),
                                onPressed: () {
                                  widget.dataProvider.download(
                                    api +
                                        'song/file/' +
                                        widget.dataProvider.currentSong.id
                                            .toString(),
                                    widget.dataProvider.currentSong.file,
                                    widget.dataProvider.currentSong.title,
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 300, left: 10, right: 10),
                  child: AudioProgressBar(),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PreviousSongButton(),
                  PlayButton(),
                  NextSongButton(),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
