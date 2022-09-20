import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/views/components/pdf_reader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/models/book.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class BookInfoDisplay extends StatelessWidget {
  final Book bookDetails;
  final int tagNum;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final bool downloading = false;
  BookInfoDisplay({Key? key, required this.bookDetails, required this.tagNum})
      : super(key: key);

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
                  Padding(
                    padding: const EdgeInsets.only(right: 120),
                    child: Card(
                      elevation: 6,
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
                                        bookDetails.id.toString()),
                                    fit: BoxFit.cover)),
                          ),
                          tag: tagNum,
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
                          elevation: 6,
                          color: Colors.orange,
                          child: Text('SOMA',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            String bookUrl =
                                api + 'book/file/' + bookDetails.id.toString();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return BookReader(
                                  pdfTitle: bookDetails.title,
                                  pdfName: bookDetails.file,
                                  pdfUrl: bookUrl);
                            }));
                          },
                        ),

                        // ignore: deprecated_member_use
                        RaisedButton(
                          elevation: 6,
                          color: Colors.orange,
                          child: Text('PAKUA',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            _dataProvider.download(
                              api + 'book/file/' + bookDetails.id.toString(),
                              bookDetails.file,
                              bookDetails.title,
                            );
                          },
                        ),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          elevation: 6,
                          color: Colors.orange,
                          child: Text('SAMBAZA',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Share.share(
                                api + 'book/file/' + bookDetails.id.toString());
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
              BookDetails(
                icon: FontAwesomeIcons.book,
                myKey: "Jina la Kitabu:",
                myValue: bookDetails.title,
              ),
              Divider(),
              BookDetails(
                  icon: FontAwesomeIcons.pen,
                  myKey: "Jina la Mtunzi:",
                  myValue: bookDetails.author),
              Divider(),
              BookDetails(
                  icon: FontAwesomeIcons.calendar,
                  myKey: "Mwaka wa Chapisho:",
                  myValue: bookDetails.pubYear),
              Divider(),
              BookDetails(
                  icon: FontAwesomeIcons.edit,
                  myKey: "Nambari ya Chapa:",
                  myValue: bookDetails.edition.toString()),
              Divider(),
              BookDetails(
                  icon: FontAwesomeIcons.infoCircle,
                  myKey: "Maelezo Kuhusu Kitabu:",
                  myValue: bookDetails.description),
            ],
          ),
        ),
      ),
    );
  }
}

class BookDetails extends StatelessWidget {
  final String myKey;
  final String myValue;
  final IconData icon;
  BookDetails(
      {Key? key,
      required this.myKey,
      required this.myValue,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(myKey, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(myValue, textAlign: TextAlign.justify)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
