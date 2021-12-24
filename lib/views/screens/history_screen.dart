import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/views/other_pages/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _dataObject = Provider.of<DataProvider>(context);
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        iconTheme: new IconThemeData(
          color: Colors.deepPurple[800],
        ),
        title: Text(
          'History',
          style: TextStyle(
            color: Colors.deepPurple[800],
          ),
        ),
      ),
      drawer: DrawerPage(),

// ************************* THE HISTORY BODY *************************

      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.orange[200],
              borderRadius: BorderRadius.circular(5)),
          child: _dataObject.histories.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.orange[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: <Widget>[
                          ExpansionTile(
                            title: Text(
                              _dataObject.histories[index].section.toString() +". "+ _dataObject.histories[index].heading,
                              style: TextStyle(
                                  color: Colors.deepPurple[800],
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.orange[100],
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SelectableText(
                                      _dataObject
                                          .histories[index].content,
                                      style: TextStyle(
                                          color: Colors.deepPurple[800]),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                  itemCount: _dataObject.histories.length,
                ),
        ),
      ),
    );
  }
}
