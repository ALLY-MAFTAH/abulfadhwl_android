// ignore_for_file: import_of_legacy_library_into_null_safe, deprecated_member_use

import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:animated_image_list/AnimatedImageList.dart';
import 'package:flutter/material.dart';
import 'package:marquee_flutter/marquee_flutter.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/announcements_page.dart';
import 'package:abulfadhwl_android/views/other_pages/drawer_page.dart';

class MyImage {
  final String url;
  final String name;
  const MyImage(this.url, this.name);
}

class HomeScreen extends StatefulWidget {
  final DataProvider dataProvider;

  const HomeScreen({Key? key, required this.dataProvider}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool downloading = false;
  var progressString = "";
  @override
  Widget build(BuildContext context) {
    final _dataObject = Provider.of<DataProvider>(context);
    final arr = <MyImage>[];
    for (var i = 0; i < widget.dataProvider.slides.length; i++) {
      arr.add(MyImage(
          api + 'slide/file/' + widget.dataProvider.slides[i].id.toString(),
          widget.dataProvider.slides[i].number.toString()));
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
          onRefresh: widget.dataProvider.reloadPage,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                return _dataObject.announcements.isEmpty
                    ? Container()
                    : Container(
                        height: 25,
                        color: Colors.orange[50],
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return Announcements(
                                announcementDetails: _dataObject.announcements,
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
                                child: MarqueeWidget(
                                  text: _dataObject.announcements[0].news,
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
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
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {},
                            elevation: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ******************************* IMAGE SLIDES CONTAINER *********************************
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 3 / 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          child: AnimatedImageList(
                            images: arr.map((e) => e.url).toList(),
                            builder: (context, index, progress) {
                              return Positioned.directional(
                                  textDirection: TextDirection.ltr,
                                  bottom: 15,
                                  start: 25,
                                  child: Opacity(
                                    opacity: progress > 1
                                        ? (2 - progress)
                                        : progress,
                                    child: Text(
                                      arr[index].name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500),
                                    ),
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
        ));
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
