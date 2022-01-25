import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/views/components/pdf_reader.dart';
import 'package:abulfadhwl_android/views/other_pages/book_info_display.dart';
import 'package:abulfadhwl_android/views/other_pages/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:google_fonts/google_fonts.dart';
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
        appBar: AppBar(
          iconTheme: IconThemeData(),
          title: Text(
            'Vitabu na Makala',
            style: TextStyle(),
          ),
        ),
        drawer: DrawerPage(),
        body: Column(
          children: [
            Card(
              elevation: 10,
              color: Colors.orange[50],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: TabBar(
                indicator: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                unselectedLabelStyle:
                    GoogleFonts.gelasio(fontWeight: FontWeight.normal),
                labelStyle: GoogleFonts.gelasio(
                  fontWeight: FontWeight.bold,
                ),
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
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  RefreshIndicator(
                    onRefresh: _dataObject.reloadPage,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemBuilder: (BuildContext context, int index) {
                        return _dataObject.books.isEmpty
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                  left: 5,
                                  top: 5,
                                  right: 5,
                                ),
                                child: Card(
                                  elevation: 10,
                                  color: Colors.orange[50],
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
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (_) {
                                                return BookInfoDisplay(
                                                  bookDetails:
                                                      _dataObject.books[index],
                                                  tagNum: _dataObject
                                                      .books[index].id,
                                                );
                                              }));
                                            },
                                            child: Hero(
                                              child: Container(
                                                height: 350,
                                                decoration: BoxDecoration(
                                                    color: Colors.orange[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    image: DecorationImage(
                                                      image: NetworkImageWithRetry(
                                                          api +
                                                              'book/cover/' +
                                                              _dataObject
                                                                  .books[index]
                                                                  .id
                                                                  .toString()),
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                              tag: _dataObject.books[index].id,
                                            )),
                                        // ignore: deprecated_member_use
                                        RaisedButton(
                                          elevation: 10,
                                          color: Colors.orange,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                            'SOMA',
                                          ),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return BookReader(
                                                  bookTitle: _dataObject
                                                      .books[index].title,
                                                  pdfUrl: api +
                                                      'book/file/' +
                                                      _dataObject
                                                          .books[index].id
                                                          .toString());
                                            }));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                      },
                      itemCount: _dataObject.books.length,
                    ),
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
                                            _dataObject.articles[index].id
                                                .toString();
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return BookReader(
                                              bookTitle: _dataObject
                                                  .articles[index].title,
                                              pdfUrl: articleUrl);
                                        }));
                                      },
                                      child: Card(
                                        elevation: 9,
                                        margin: EdgeInsets.all(3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImageWithRetry(
                                                      api +
                                                          'article/cover/' +
                                                          _dataObject
                                                              .articles[index]
                                                              .id
                                                              .toString()),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                      )),
                                );
                              }, childCount: _dataObject.articles.length),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, childAspectRatio: 0.7),
                            ),
                          ],
                        )
                ],
              ),
            ),
          ],
        ),
      ),
      length: 2,
    );
  }
}
