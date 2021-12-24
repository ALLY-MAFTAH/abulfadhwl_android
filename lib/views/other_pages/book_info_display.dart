import 'dart:async';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_image/network.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:path_provider/path_provider.dart';
import 'package:abulfadhwl_android/api.dart';
import 'package:abulfadhwl_android/models/book.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class BookInfoDisplay extends StatefulWidget {
  final Book bookDetails;
  final int tagNum;

  const BookInfoDisplay(
      { Key? key, required this.bookDetails, required this.tagNum})
      : super(key: key);

  @override
  _BookInfoDisplayState createState() => _BookInfoDisplayState();
}

class _BookInfoDisplayState extends State<BookInfoDisplay> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool downloading = false;
  var progressString = "";

  @override
  Widget build(BuildContext context) {
    timeDilation = 1;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.orange[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 35, right: 10),
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                child: Stack(children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(right: 120),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Hero(
                            child: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: NetworkImageWithRetry(api +
                                          'book/cover/' +
                                          widget.bookDetails.id.toString()),
                                      fit: BoxFit.cover)),
                            ),
                            tag: widget.tagNum,
                            flightShuttleBuilder: (BuildContext flightContext,
                                Animation<double> animation,
                                HeroFlightDirection flightDirection,
                                BuildContext toHeroContext,
                                BuildContext fromHeroContext) {
                              final Widget toHero = toHeroContext.widget;
                              return RotationTransition(
                                turns: animation,
                                child: toHero,
                              );
                            }),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Image(
                        image: AssetImage('assets/icons/dismiss_music@3x.png'),
                        color: Colors.orange[700],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // ignore: deprecated_member_use
                        RaisedButton(
                          elevation: 10,
                          color: Colors.orange[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'OPEN',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            String bookUrl = api +
                                'book/file/' +
                                widget.bookDetails.id.toString();
                            // openBookFile(bookUrl);
                            openBookFile(bookUrl);
                          },
                        ),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          elevation: 10,
                          color: Colors.orange[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'SHARE',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Share.share(api +
                                'book/file/' +
                                widget.bookDetails.id.toString());
                          },
                        ),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          elevation: 10,
                          color: Colors.orange[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'DOWNLOAD',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            String bookUrl = api +
                                'book/file/' +
                                widget.bookDetails.id.toString();
                            downloadFile(bookUrl, widget.bookDetails.title);
                            
                          },
                        ),
                      ],
                    ),
                  )
                ]),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.book,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Jina la Kitabu:',
                              style: TextStyle(
                                  color: Colors.deepPurple[800],
                                  fontWeight: FontWeight.bold)),
                          Text(widget.bookDetails.title,
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Jina la Mtunzi:',
                              style: TextStyle(
                                  color: Colors.deepPurple[800],
                                  fontWeight: FontWeight.bold)),
                          Text(widget.bookDetails.author,
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.calendarAlt,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Mwaka wa Chapisho:',
                              style: TextStyle(
                                  color: Colors.deepPurple[800],
                                  fontWeight: FontWeight.bold)),
                          Text(widget.bookDetails.pubYear,
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.content_copy,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Nambari ya Chapa:',
                              style: TextStyle(
                                  color: Colors.deepPurple[800],
                                  fontWeight: FontWeight.bold)),
                          Text(widget.bookDetails.edition.toString(),
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.info,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Maelezo Kuhusu Kitabu:',
                              style: TextStyle(
                                  color: Colors.deepPurple[800],
                                  fontWeight: FontWeight.bold)),
                          Text(
                            widget.bookDetails.description,
                            style: TextStyle(
                              color: Colors.deepPurple,
                            ),
                            textAlign: TextAlign.justify,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openBookFile(String bookUrl) async {
    if (await canLaunch(bookUrl)) {
      await launch(bookUrl);
    } else {
      throw 'Could not launch $bookUrl';
    }
  }

  Future<void> downloadFile(bookFileUrl, bookFileName) async {
    Dio dio = Dio();
    try {
      Directory? downloadsDirectory = await getExternalStorageDirectory();
      // downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

      // await dio.download(
      //     bookFileUrl, downloadsDirectory.path + "/" + bookFileName + ".pdf",
      //     onReceiveProgress: (rec, total) {
      //   print("Rec: $rec, Total: $total");
      //   setState(() {
      //     downloading = true;
      //     progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
      //   });
      //   print(downloadsDirectory!.path);
        
      // });
      return showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                isDismissible: true,
                                context: context,
                                builder: (_) {
                                  
                                  return Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      color: Colors.black.withOpacity(0.9),
                                    ),
                                    child: Column(
                                      children: <Widget>[!downloading?CircularProgressIndicator():
                                        Text(
                                          "Downloading... $progressString",
                                          style: TextStyle(
                                            color: Colors.white,
                                            // fontSize: 13,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                });
    } catch (e) {
      print(e);
    }
    print("Download completed");
  }
}
