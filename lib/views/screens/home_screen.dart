// ignore_for_file: unnecessary_import

// ignore: unused_import
import 'dart:async';
// ignore: unused_import
import 'dart:io';
import 'dart:ui';
import 'package:abulfadhwl_android/providers/data_provider.dart';
// ignore: import_of_legacy_library_into_null_safe, unused_import
import 'package:dio/dio.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:marquee_flutter/marquee_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe, unused_import
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/views/other_pages/announcements_page.dart';
import 'package:abulfadhwl_android/views/other_pages/drawer_page.dart';

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
    // List<Slide> slides = _dataObject.slides;
    return Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          iconTheme: new IconThemeData(
            color: Colors.deepPurple[800],
          ),
          title: Text(
            'Home',
            style: TextStyle(
              color: Colors.deepPurple[800],
            ),
          ),
        ),
        drawer: DrawerPage(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              return _dataObject.announcements.isEmpty
                  ? Container()
                  : Container(
                      height: 25,
                      color: Colors.orange[100],
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
                            // Expanded(
                            //   child: MarqueeWidget(
                            //     text: _dataObject.announcements[0].news,
                            //     textStyle: TextStyle(
                            //         color: Colors.deepPurple[800],
                            //         fontWeight: FontWeight.bold),
                            //   ),
                            // ),
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
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          padding: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.orange[700],
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
                          onPressed: () {
                            // return showDialog<T> (
                            //     context: context,
                            //     barrierDismissible: false,
                            //     builder: (_) {
                            //       Timer(Duration(seconds: 3), () {
                            //         Navigator.of(context).pop();
                            //       });
                            //       return AlertDialog(
                            //         content: Text(
                            //           "Tafsiri ya Qur-an bado haijakamilika. Itawekwa pindi itakapokamilika, In shaa Allah ",
                            //           style: TextStyle(
                            //               color: Colors.white, fontSize: 13),
                            //         ),
                            //         backgroundColor: Colors.grey[800],
                            //       );
                            //     });
                          },
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
                      child: Center(
                        child: Text("data"),
                      )),
                ),
              ]),
            )
          ],
        ));
  }

  // Future<void> downloadFile(slideFileUrl, slideFileName) async {
  //   Dio dio = Dio();
  //   try {
  //     Directory? downloadsDirectory = await getExternalStorageDirectory();
  //     downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

  //     await dio.download(
  //         slideFileUrl,
  //         downloadsDirectory.path +
  //             "/" +
  //             slideFileName +
  //             ".Image from Abul Fadhwl App.png",
  //         onReceiveProgress: (rec, total) {
  //       print("Rec: $rec, Total: $total");
  //       setState(() {
  //         downloading = true;
  //         progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
  //       });
  //       print(downloadsDirectory!.path);
        // return showDialog(
        //     context: context,
        //     barrierDismissible: false,
        //     builder: (_) {
        //       Timer(Duration(seconds: 3), () {
        //         Navigator.of(context).pop();
        //       });
        //       return AlertDialog(
        //         title: Row(
        //           children: <Widget>[
        //             Icon(
        //               Icons.check,
        //               color: Colors.green,
        //             ),
        //             Text(
        //               " Image saved successfully! ",
        //               style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 13,
        //               ),
        //             )
        //           ],
        //         ),
        //         content: RichText(
        //           text: TextSpan(
        //               text: "Go ",
        //               style: TextStyle(
        //                 color: Colors.white,
        //               ),
        //               children: <TextSpan>[
        //                 TextSpan(
        //                     text: "->Device Storage->Download",
        //                     style: TextStyle(
        //                         color: Colors.white,
        //                         fontWeight: FontWeight.bold,
        //                         fontStyle: FontStyle.italic))
        //               ]),
        //         ),
        //         backgroundColor: Colors.grey[800]!.withOpacity(0.5),
        //         elevation: 10,
        //       );
        //     });
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  //   setState(() {
  //     downloading = false;
  //     progressString = "Completed";
  //   });
  //   print("Download completed");
  // }
}

// ******************* METHOD FOR TAFSEER BUTTON *************************
// void _onTafseerTapped() async {
//   const url = ;
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
