import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/views/other_pages/book_info_display.dart';
import 'package:abulfadhwl_android/views/other_pages/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import '../../providers/get_and_post_provider.dart';
import '../components/folded_card.dart';

class BooksScreen extends StatefulWidget {
  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    final _getAndPostProvider = Provider.of<GetAndPostProvider>(context);

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
              elevation: 6,
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
                    GoogleFonts.ubuntu(fontWeight: FontWeight.normal),
                labelStyle: GoogleFonts.ubuntu(
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
                    onRefresh: _getAndPostProvider.reloadPage,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemBuilder: (BuildContext context, int index) {
                        return _getAndPostProvider.books.isEmpty
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  top: 10,
                                  right: 10,
                                ),
                                child: Card(
                                  elevation: 6,
                                  color: Colors.orange[50],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(40),
                                        bottomLeft: Radius.circular(40)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return BookInfoDisplay(
                                            bookDetails:
                                                _getAndPostProvider.books[index],
                                            tagNum: _getAndPostProvider.books[index].id,
                                          );
                                        }));
                                      },
                                      child: Column(
                                        children: [
                                          Hero(
                                            child: _getAndPostProvider.books.isEmpty
                                                ? Container(
                                                  child: Icon(Icons.image),
                                                )
                                                : Container(
                                                    height: 200,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  40),
                                                        ),
                                                        image: DecorationImage(
                                                            image: NetworkImageWithRetry(api +
                                                                'book/cover/' +
                                                                _getAndPostProvider
                                                                    .books[
                                                                        index]
                                                                    .id
                                                                    .toString()),
                                                            fit: BoxFit.fill)),
                                                  ),
                                            tag: _getAndPostProvider.books[index].id,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              "Jina la Kitabu",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              _getAndPostProvider.books[index].title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                      },
                      itemCount: _getAndPostProvider.books.length,
                    ),
                  ),
                  _getAndPostProvider.articles.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return FoldedCard(index: index);
                          },
                          itemCount: _getAndPostProvider.articles.length,
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
