
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
    final _dataProvider = Provider.of<DataProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 15, right: 8),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.orange,
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              color: Colors.orange[50],
              elevation: 6,
              child: SimpleFoldingCell.create(
                key: _foldingCellKey,
                frontWidget: _buildFrontWidget(context),
                innerWidget: _buildInnerWidget(context),
                cellSize: Size(MediaQuery.of(context).size.width, 120),
                animationDuration: Duration(milliseconds: 600),
                borderRadius: 10,
                onOpen: () => print('cell opened'),
                onClose: () => print('cell closed'),
                padding: EdgeInsets.all(0),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 209,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 8.0,
                      width: 5.0,
                      child: CustomPaint(
                        painter: TrianglePainter(),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      width: 200,
                      height: 35,
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "MAKALA NAMBA: ",
                            style: TextStyle(fontSize: 17),
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Text(
                              _dataProvider.articles[index].number.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildFrontWidget(context) {
    final _dataProvider = Provider.of<DataProvider>(context);
    return InkWell(
      onTap: () => _foldingCellKey.currentState?.toggleFold(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.orange[50],
        ),
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jina: ",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey),
                    ),
                    Expanded(
                      child: Text(
                        _dataProvider.articles[index].title,
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerWidget(context) {
    final _dataProvider = Provider.of<DataProvider>(context);
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
                  padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
                  child: Column(
                    children: [
                      Text(_dataProvider.articles[index].description,
                          textAlign: TextAlign.justify),
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
                      " • Imetolewa: " + _dataProvider.articles[index].pubYear,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60, left: 8, right: 8),
                    child: Text(
                      _dataProvider.articles[index].title,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => _foldingCellKey.currentState?.toggleFold(),
                    child: Icon(
                      Icons.close,
                      size: 28,
                      color: Colors.red,
                    ),
                    style: TextButton.styleFrom(
                      elevation: 6,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 3,
                  child: IconButton(
                    onPressed: () => Share.share(api +
                        'article/file/' +
                        _dataProvider.articles[index].id.toString()),
                    icon: Icon(
                      Icons.share,
                      size: 33,
                      color: Colors.orange,
                    ),
                  ),
                ),
                Positioned(
                  left: 60,
                  bottom: 3,
                  child: IconButton(
                    onPressed: () => _dataProvider.download(
                        api +
                            'article/file/' +
                            _dataProvider.articles[index].id.toString(),
                        _dataProvider.articles[index].file,
                        _dataProvider.articles[index].title),
                    icon: Icon(
                      Icons.download,
                      size: 35,
                      color: Colors.orange,
                    ),
                  ),
                ),
                Positioned(
                  left: 120,
                  bottom: 3,
                  child: IconButton(
                    onPressed: () {
                      String articleUrl = api +
                          'article/file/' +
                          _dataProvider.articles[index].id.toString();
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return BookReader(
                            pdfTitle: _dataProvider.articles[index].title,
                            pdfName: _dataProvider.articles[index].file,
                            pdfUrl: articleUrl);
                      }));
                      _foldingCellKey.currentState?.toggleFold();
                    },
                    icon: Icon(
                      Icons.menu_book_rounded,
                      size: 35,
                      color: Colors.orange,
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

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0;
    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
