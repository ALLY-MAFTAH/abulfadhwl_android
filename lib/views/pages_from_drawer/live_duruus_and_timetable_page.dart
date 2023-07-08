import 'package:abulfadhwl_android/providers/get_and_post_provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/layout_page.dart';

import '../../providers/data_provider.dart';

class LiveDuruusAndTimetablePage extends StatefulWidget {
  @override
  _LiveDuruusAndTimetablePageState createState() =>
      _LiveDuruusAndTimetablePageState();
}

class _LiveDuruusAndTimetablePageState
    extends State<LiveDuruusAndTimetablePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _getAndPostProvider = Provider.of<GetAndPostProvider>(context);
    final _dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
              return LayoutPage();
            }));
          },
        ),
        title: Text(
          'Darsa Mubaashara na Ratiba',
          style: TextStyle(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _getAndPostProvider.reloadPage,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: _getAndPostProvider.streams.isEmpty
              ? Container(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  ))
              : Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    _getAndPostProvider.streams[0].status == 1
                        ? Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  _getAndPostProvider.streams[0].title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  _getAndPostProvider.streams[0].description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 85,
                                  width: 85,
                                  decoration: BoxDecoration(
                                      color: _dataProvider.btnColorLight,
                                      borderRadius:
                                          BorderRadius.circular(42.5)),
                                  child: PlayerBuilder.isPlaying(
                                      player: assetsAudioPlayer,
                                      builder: (context, isPlaying) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              isPlaying
                                                  ? assetsAudioPlayer.pause()
                                                  : _playRadio(
                                                      _getAndPostProvider
                                                          .streams[0].url,
                                                      _getAndPostProvider
                                                          .streams[0].title,
                                                      _getAndPostProvider
                                                          .streams[0]
                                                          .description,
                                                    );
                                            });
                                          },
                                          child: Icon(
                                            isPlaying
                                                ? Icons.pause_rounded
                                                : Icons.play_arrow_rounded,
                                            color: _dataProvider.btnColor,
                                            size: 80,
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: 200,
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.warning_amber_rounded,
                                    color: Colors.red),
                                Text(
                                  "'Afwan, Hakuna Darsa Inayoendelea Hivi Sasa",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                          ),
                    Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 15, right: 20),
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 3 / 11,
                          backgroundColor: _dataProvider.btnColorLight,
                          child: Image(
                            image: AssetImage("assets/icons/live.png"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Image(
                                image: NetworkImageWithRetry(api +
                                    'stream/timetable/' +
                                    _getAndPostProvider.streams[0].id
                                        .toString())),
                          )
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  void _playRadio(String url, String title, String album) async {
    try {
      await assetsAudioPlayer.open(
          Audio.liveStream(
            url,
            metas: Metas(
              title: title,
              artist: "Sheikh Abul Fadhwl Qassim Mafuta Qassim",
              album: album,
              image: MetasImage.asset("assets/icons/app_icon.png"),
            ),
          ),
          showNotification: true,
          notificationSettings:
              NotificationSettings(nextEnabled: false, prevEnabled: false));
    } catch (t) {
      print(t.toString());
      print("stream unreachable");
    }
  }
}
