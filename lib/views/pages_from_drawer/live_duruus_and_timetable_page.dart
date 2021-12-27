import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/api.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/views/other_pages/home_page.dart';
import 'package:radio_player/radio_player.dart';

class LiveDuruusAndTimetablePage extends StatefulWidget {
  @override
  _LiveDuruusAndTimetablePageState createState() =>
      _LiveDuruusAndTimetablePageState();
}

class _LiveDuruusAndTimetablePageState
    extends State<LiveDuruusAndTimetablePage> {
  RadioPlayer _radioPlayer = RadioPlayer();
  bool isPlaying = false;
  List<String>? metadata;
  @override
  void initState() {
    initRadioPlayer();

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

            // FlutterRadio.stop();
          },
        ),
        title: Text(
          'Live Duruus na Ratiba',
          style: TextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                  _dataObject.streams[0].title.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : Text(
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
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _radioPlayer.setMediaItem(
                              _dataObject.streams[0].title,
                              _dataObject.streams[0].url,
                              api +
                                  'stream/timetable/' +
                                  _dataObject.streams[0].id.toString());
                          isPlaying
                              ? _radioPlayer.pause()
                              : _radioPlayer.play();
                        });
                      },
                      child: Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.orange,
                        size: 80,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 3 / 11,
                  backgroundColor: Colors.orange[50],
                  child: Image(
                    image: AssetImage("assets/icons/live.png"),
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "RATIBA YA DARSA ZA  'AAM",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child: Image(
                    image: NetworkImageWithRetry(api +
                        'stream/timetable/' +
                        _dataObject.streams[0].id.toString())),
              ),
            )
          ],
        ),
      ),
    );
  }

  void initRadioPlayer() {
    _radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });
    _radioPlayer.metadataStream.listen((value) {
      setState(() {
        metadata = value;
      });
    });
  }
}
