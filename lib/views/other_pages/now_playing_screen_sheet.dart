import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/views/components/controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/api.dart';

class NowPlayingScreenSheet extends StatefulWidget {
  NowPlayingScreenSheet({Key? key}) : super(key: key);

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
    final _dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: _dataProvider.btnColorLight,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CurrentSongTitle(),
                        Text(
                          _dataProvider.currentSong.size.toString() + ' MB',
                          maxLines: 1,
                          style: TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  color: _dataProvider.btnColor,
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share(api +
                        'song/file/' +
                        _dataProvider.currentSong.id.toString());
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
                              "الشيخ أبو الفضل قاسم بن مفوتا بن قاسم بن عثمان",
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "حفظه الله ورعاه",
                              style: TextStyle(),
                            ),
                            CircleAvatar(
                              radius: 100,
                              backgroundColor: _dataProvider.btnColorLight,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        'assets/images/ALLY W  008.png',),
                                    color: _dataProvider.btnColor,
                                  ),
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
                                icon: Icon(
                                  Icons.download,
                                  color: _dataProvider.btnColor,
                                ),
                                iconSize: 30,
                                onPressed: () {
                                  _dataProvider.download(
                                    api +
                                        'song/file/' +
                                        _dataProvider.currentSong.id.toString(),
                                    _dataProvider.currentSong.file,
                                    _dataProvider.currentSong.title,
                                    _dataProvider.currentSong.albumId,
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
              padding: const EdgeInsets.only(left: 40, top: 40, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PreviousSongButton(),
                  LargePlayButton(),
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
