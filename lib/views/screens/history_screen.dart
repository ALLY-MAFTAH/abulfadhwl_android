import 'package:abulfadhwl_android/providers/get_and_post_provider.dart';
import 'package:abulfadhwl_android/views/other_pages/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _getAndPostObject = Provider.of<GetAndPostProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text(
          'Historia',
          style: TextStyle(),
        ),
      ),
      drawer: DrawerPage(),
      body: RefreshIndicator(
        onRefresh: _getAndPostObject.reloadPage,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: _getAndPostObject.histories.isEmpty
              ? Container(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  ))
              : Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: RefreshIndicator(
                      onRefresh: _getAndPostObject.reloadPage,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemBuilder: (BuildContext context, int index) {
                          return _getAndPostObject.histories.isEmpty
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Card(
                                  elevation: 8,
                                  child: ExpansionTile(
                                    title: SizedBox(
                                      height: 70,
                                      child: Text(
                                        _getAndPostObject
                                                .histories[index].section
                                                .toString() +
                                            ". " +
                                            _getAndPostObject
                                                .histories[index].heading,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal),
                                      ),
                                    ),
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              // borderRadius: BorderRadius.circular(5),
                                              border: Border(
                                                top: BorderSide(
                                                    width: 3,
                                                    color: Color.fromARGB(
                                                        255, 237, 229, 220)),
                                                right: BorderSide(
                                                    width: 3,
                                                    color: Color.fromARGB(
                                                        255, 237, 229, 220)),
                                                left: BorderSide(
                                                    width: 3,
                                                    color: Color.fromARGB(
                                                        255, 237, 229, 220)),
                                                bottom: BorderSide(
                                                    width: 3,
                                                    color: Color.fromARGB(
                                                        255, 237, 229, 220)),
                                              )),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: SelectableText(
                                              _getAndPostObject
                                                  .histories[index].content,
                                              style: TextStyle(),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        },
                        itemCount: _getAndPostObject.histories.length,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
