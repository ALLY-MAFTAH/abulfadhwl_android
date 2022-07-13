
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/views/components/pdf_reader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/models/book.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class BookInfoDisplay extends StatefulWidget {
  final Book bookDetails;
  final int tagNum;

  const BookInfoDisplay(
      {Key? key, required this.bookDetails, required this.tagNum})
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
    final _dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
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
                        color: Colors.orange,
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
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'SOMA',
                          ),
                          onPressed: () {
                            String bookUrl = api +
                                'book/file/' +
                                widget.bookDetails.id.toString();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return BookReader(
                                  pdfTitle: widget.bookDetails.title,
                                  pdfName: widget.bookDetails.file,
                                  pdfUrl: bookUrl);
                            }));
                          },
                        ),

                        // ignore: deprecated_member_use
                        RaisedButton(
                          elevation: 10,
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'PAKUA',
                          ),
                          onPressed: () async {
                            _dataProvider.download(
                                api +
                                    'book/file/' +
                                    widget.bookDetails.id.toString(),
                                widget.bookDetails.file,
                                widget.bookDetails.title,
                                );
                          },
                        ),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          elevation: 10,
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'SAMBAZA',
                          ),
                          onPressed: () {
                            Share.share(api +
                                'book/file/' +
                                widget.bookDetails.id.toString());
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
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Jina la Kitabu:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(widget.bookDetails.title, style: TextStyle())
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
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Jina la Mtunzi:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(widget.bookDetails.author, style: TextStyle())
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
                      FontAwesomeIcons.calendarDays,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Mwaka wa Chapisho:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(widget.bookDetails.pubYear, style: TextStyle())
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
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Nambari ya Chapa:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(widget.bookDetails.edition.toString(),
                              style: TextStyle())
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
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Maelezo Kuhusu Kitabu:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            widget.bookDetails.description,
                            style: TextStyle(),
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
}
