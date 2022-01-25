import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/home_page.dart';

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
    final _dataObject = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
              return Home();
            }));
          },
        ),
        title: Text(
          'Darsa Mubaashara na Ratiba',
          style: TextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: _dataObject.streams.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          _dataObject.streams[0].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _dataObject.streams[0].description,
                          textAlign: TextAlign.center,
                          style: TextStyle(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 85,
                          width: 85,
                          decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(42.5)),
                          child: PlayerBuilder.isPlaying(
                              player: assetsAudioPlayer,
                              builder: (context, isPlaying) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      isPlaying
                                          ? assetsAudioPlayer.pause()
                                          : _playRadio(
                                              _dataObject.streams[0].url,
                                              _dataObject
                                                  .streams[0].description,
                                              _dataObject.streams[0].title,
                                            );
                                    });
                                  },
                                  child: Icon(
                                    isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: Colors.orange,
                                    size: 80,
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 15, right: 20),
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 3 / 11,
                        backgroundColor: Colors.orange[50],
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "RATIBA YA DARSA ZA  'AAM",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Image(
                              image: NetworkImageWithRetry(api +
                                  'stream/timetable/' +
                                  _dataObject.streams[0].id.toString())),
                        )
                      ],
                    ),
                  )
                ],
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
              artist: "Sheikh Abul Fadhwl Kassim Mafuta Kassim",
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
