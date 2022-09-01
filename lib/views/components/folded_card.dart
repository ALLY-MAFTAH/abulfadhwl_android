import 'package:abulfadhwl_android/views/components/pdf_reader.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/api.dart';
import '../../providers/data_provider.dart';

class FoldedCard extends StatelessWidget {
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();
  final int index;

  FoldedCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        color: Colors.orange[50],
        elevation: 6,
        child: SimpleFoldingCell.create(
          key: _foldingCellKey,
          frontWidget: _buildFrontWidget(context),
          innerWidget: _buildInnerWidget(context),
          cellSize: Size(MediaQuery.of(context).size.width, 120),
          animationDuration: Duration(milliseconds: 300),
          borderRadius: 10,
          onOpen: () => print('cell opened'),
          onClose: () => print('cell closed'),
          padding: EdgeInsets.all(0),
        ),
      ),
    );
  }

  Widget _buildFrontWidget(context) {
    final _dataObject = Provider.of<DataProvider>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        color: Colors.orange[50],
      ),
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "MAKALA NAMBA: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      _dataObject.articles[index].number.toString(),
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: () => _foldingCellKey.currentState?.toggleFold(),
              child: Text(
                "FUNGUA",
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(80, 40),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInnerWidget(context) {
    final _dataObject = Provider.of<DataProvider>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        _dataObject.articles[index].description,
                         textAlign: TextAlign.justify
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Divider(
                color: Colors.black,
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 120, right: 10),
                    child: Text(
                      " • Imetolewa: " + _dataObject.articles[index].pubYear,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60, left: 8, right: 8),
                    child: Text(
                     _dataObject.articles[index].title,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 3,
                  child: TextButton(
                    onPressed: () => _foldingCellKey.currentState?.toggleFold(),
                    child: Text(
                      "FUNGA",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      elevation: 6,
                      backgroundColor: Colors.white,
                      minimumSize: Size(80, 40),
                    ),
                  ),
                ),
                Positioned(
                  right: 120,
                  left: 120,
                  bottom: 3,
                  child: TextButton(
                    onPressed: () =>  Share.share(api +
                                'article/file/' +
                                 _dataObject.articles[index].id.toString()),
                    child: Text(
                      "SAMBAZA",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      elevation: 6,
                      backgroundColor: Colors.white,
                      minimumSize: Size(80, 40),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 3,
                  child: TextButton(
                    onPressed: () {
                      String articleUrl = api +
                          'article/file/' +
                          _dataObject.articles[index].id.toString();
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return BookReader(
                            pdfTitle: _dataObject.articles[index].title,
                            pdfName: _dataObject.articles[index].file,
                            pdfUrl: articleUrl);
                      }));
                      _foldingCellKey.currentState?.toggleFold();
                    },
                    child: Text(
                      "SOMA",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      elevation: 6,
                      backgroundColor: Colors.white,
                      minimumSize: Size(80, 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
