// ignore_for_file: import_of_legacy_library_into_null_safe, deprecated_member_use

import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/providers/get_and_post_provider.dart';
import 'package:animated_image_list/AnimatedImageList.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/announcements_page.dart';
import 'package:abulfadhwl_android/views/other_pages/drawer_page.dart';
import 'package:provider/provider.dart';

class MyImage {
  final String url;
  final String name;
  final String title;
  const MyImage(this.url, this.name, this.title);
}

class HomeScreen extends StatefulWidget {
  final DataProvider dataProvider = DataProvider();
  // final GetAndPostProvider getAndPostProvider = GetAndPostProvider();

  HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool downloading = false;
  var progressString = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _getAndPostProvider = Provider.of<GetAndPostProvider>(context);

    final arr = <MyImage>[];
    for (var i = 0; i < _getAndPostProvider.slides.length; i++) {
      arr.add(MyImage(
        api + 'slide/file/' + _getAndPostProvider.slides[i].id.toString(),
        _getAndPostProvider.slides[i].file,
        "Picha namba: " + _getAndPostProvider.slides[i].number.toString(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(),
        title: Text(
          'Mwanzo',
          style: TextStyle(),
        ),
      ),
      drawer: DrawerPage(),
      body: RefreshIndicator(
        onRefresh: _getAndPostProvider.reloadPage,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return _getAndPostProvider.announcements.isEmpty
                  ? Container()
                  : Container(
                      height: 25,
                      color: Colors.orange[50],
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return Announcements(
                              announcementDetails:
                                  _getAndPostProvider.announcements,
                            );
                          }));
                        },
                        child: Row(
                          children: <Widget>[
                            Image(
                              width: 40,
                              height: 20,
                              image: AssetImage("assets/icons/new.png"),
                              fit: BoxFit.fill,
                            ),
                            Expanded(
                              child: Marquee(
                                pauseAfterRound: Duration(seconds: 2),
                                blankSpace: 50,
                                text: _getAndPostProvider.announcements[0].news,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            }, childCount: 1)),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 10, right: 15, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.orange,
                          child: Text(
                            'تفسير القران الكريم',
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {},
                          elevation: 6,
                        ),
                      ),
                    ],
                  ),
                ),

                // ******************************* IMAGE SLIDES CONTAINER *********************************
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                      margin: const EdgeInsets.all(15),
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // color: Colors.orange[100]
                      ),
                      child: Container(
                        child: AnimatedImageList(
                          images: arr.map((e) => e.url).toList(),
                          builder: (context, index, progress) {
                            return Positioned.directional(
                                textDirection: TextDirection.ltr,
                                bottom: 15,
                                start: 25,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.orange[100]),
                                  child: Icon(Icons.download),
                                  onPressed: () {
                                    widget.dataProvider.download(arr[index].url,
                                        arr[index].name, arr[index].title, 0);
                                    print(arr[index].url);
                                  },
                                ));
                          },
                          scrollDirection: Axis.vertical,
                          itemExtent: 150,
                          maxExtent: 400,
                        ),
                      )),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

// ******************* METHOD FOR TAFSEER BUTTON *************************
// void _onTafseerTapped() async {
//   const url = ;
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
