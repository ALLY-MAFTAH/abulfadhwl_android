import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/views/other_pages/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _dataObject = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(),
        title: Text(
          'Historia',
          style: TextStyle(),
        ),
      ),
      drawer: DrawerPage(),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          child: RefreshIndicator(
            onRefresh: _dataObject.reloadPage,
            child:  ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemBuilder: (BuildContext context, int index) {
                      return _dataObject.histories.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                              offset: Offset(
                                  0, 10), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            ExpansionTile(
                              title: Text(
                                _dataObject.histories[index].section
                                        .toString() +
                                    ". " +
                                    _dataObject.histories[index].heading,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal),
                              ),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SelectableText(
                                        _dataObject.histories[index].content,
                                        style: TextStyle(),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: _dataObject.histories.length,
                  ),
          ),
        ),
      ),
    );
  }
}
