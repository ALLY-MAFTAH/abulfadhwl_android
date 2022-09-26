// ignore_for_file: deprecated_member_use, unnecessary_null_comparison
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookReader extends StatefulWidget {
  final String pdfTitle;
  final String pdfName;
  final String pdfUrl;

  const BookReader(
      {Key? key,
      required this.pdfName,
      required this.pdfTitle,
      required this.pdfUrl})
      : super(key: key);

  @override
  _BookReaderState createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  late PdfViewerController _pdfViewerController;
  final _searchController = TextEditingController();

  OverlayEntry? _overlayEntry;
  PdfTextSearchResult? _searchResult;
  bool _showSearchBar = false;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState? _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion?.bottomLeft.dx,
        child: RaisedButton(
          child: Text('Copy', style: TextStyle(fontSize: 17)),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: details.selectedText));
            _pdfViewerController.clearSelection();
          },
          color: Colors.white,
          elevation: 10,
        ),
      ),
    );
    _overlayState?.insert(_overlayEntry!);
  }

  FocusNode _textSearchFocusNode = FocusNode();

  TextEditingController _textSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
              });
            },
          ),
          Visibility(
            visible: _searchResult?.hasResult ?? false,
            child: IconButton(
              icon: Icon(
                Icons.clear,
              ),
              onPressed: () {
                setState(() {
                  _searchResult!.clear();
                  _showSearchBar = false;
                  _textSearchController.clear();
                  _textSearchController.clearComposing();
                });
              },
            ),
          ),
          Visibility(
            visible: _searchResult?.hasResult ?? false,
            child: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_up,
              ),
              onPressed: () {
                _searchResult?.previousInstance();
              },
            ),
          ),
          Visibility(
            visible: _searchResult?.hasResult ?? false,
            child: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
              ),
              onPressed: () {
                _searchResult?.nextInstance();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _showSearchBar
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    focusNode: _textSearchFocusNode,
                    controller: _textSearchController,
                    validator: (searchValue) {
                      if (searchValue!.isEmpty)
                        return "Tafadhali andika unachokitafuta";
                      else
                        return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Tafuta',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    onChanged: (value) async {
                      _searchResult = await _pdfViewerController.searchText(
                        value,
                      );
                      setState(() {});
                    },
                  ),
                )
              : Container(),
          Expanded(
            child: Container(
                child: SfPdfViewer.network(
              widget.pdfUrl,
              onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                if (details.selectedText == null) {
                  _overlayEntry!.remove();
                  _overlayEntry = null;
                } else if (details.selectedText != null &&
                    _overlayEntry == null) {
                  _showContextMenu(context, details);
                }
              },
              controller: _pdfViewerController,
            )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download),
        onPressed: () {
          _dataProvider.download(
              widget.pdfUrl, widget.pdfName, widget.pdfTitle);
        },
      ),
    );
  }
}
