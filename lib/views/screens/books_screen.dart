import 'package:abulfadhwl_android/api.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/views/other_pages/book_info_display.dart';
import 'package:abulfadhwl_android/views/other_pages/drawer_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BooksScreen extends StatefulWidget {
  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  @override
  Widget build(BuildContext context) {
    final _dataObject = Provider.of<DataProvider>(context);

    return DefaultTabController(
      child: Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.deepPurple[800],
          ),
          title: Text(
            'Books',
            style: TextStyle(
              color: Colors.deepPurple[800],
            ),
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.deepPurple,
            indicatorColor: Colors.deepPurple,
            indicatorWeight: 3,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            labelColor: Colors.deepPurple[800],
            tabs: <Widget>[
              Tab(
                text: "VITABU",
              ),
              Tab(
                text: "MAKALA",
              )
            ],
          ),
        ),
        drawer: DrawerPage(),
        body: TabBarView(
          children: <Widget>[
            _dataObject.books.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                            top: 5,
                            right: 5,
                          ),
                          child: Card(
                            elevation: 10,
                            color: Colors.orange[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    _dataObject.books[index].title,
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return BookInfoDisplay(
                                            bookDetails:
                                                _dataObject.books[index],
                                            tagNum: _dataObject.books[index].id,
                                          );
                                        }));
                                      },
                                      child: Hero(
                                        child: Container(
                                          height: 350,
                                          decoration: BoxDecoration(
                                              color: Colors.orange[200],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              image: DecorationImage(
                                                image: NetworkImageWithRetry(
                                                    api +
                                                        'book/cover/' +
                                                        _dataObject
                                                            .books[index].id
                                                            .toString()),
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        tag: _dataObject.books[index].id,
                                      )),
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                    elevation: 10,
                                    color: Colors.orange[700],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text('SOMA',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      var bookUrl = api +
                                          'book/file/' +
                                          _dataObject.books[index].id
                                              .toString();
                                      OpenFile.open(bookUrl);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                    itemCount: _dataObject.books.length,
                  ),
            _dataObject.articles.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: <Widget>[
                      SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return Padding(
                            padding: index.isEven
                                ? const EdgeInsets.only(
                                    left: 5, top: 5, right: 0)
                                : const EdgeInsets.only(
                                    left: 5, top: 5, right: 5),
                            child: InkWell(
                                onTap: () {
                                  String articleUrl = api +
                                      'article/file/' +
                                      _dataObject.books[index].id.toString();
                                  openArticleFile(articleUrl);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.orange[200]),
                                  padding: EdgeInsets.all(3),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImageWithRetry(api +
                                                'article/cover/' +
                                                _dataObject.articles[index].id
                                                    .toString()),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Container(
                                      color:
                                          Colors.orange[200]!.withOpacity(0.7),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "MAKALA NAMBA",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.deepPurple[800],
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "0" +
                                                _dataObject
                                                    .articles[index].title,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.deepPurple[800],
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          );
                        }, childCount: _dataObject.articles.length),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.7),
                      ),
                    ],
                  )
          ],
        ),
      ),
      length: 2,
    );
  }

  void openBookFile(var bookUrl) async {
    var _openResult = 'Unknown';

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      bookUrl = result.files.single.path;
    } else {
      // User canceled the picker
    }
    final _result = await OpenFile.open(bookUrl);
    print(_result.message);

    setState(() {
      _openResult = "type=${_result.type}  message=${_result.message}";
    });
  }

  void openArticleFile(String articleUrl) async {
    if (await canLaunch(articleUrl)) {
      await launch(articleUrl);
    } else {
      throw 'Could not launch $articleUrl';
    }
  }
}
