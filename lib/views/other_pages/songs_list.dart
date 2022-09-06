import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/services/service_locator.dart';
import 'package:abulfadhwl_android/views/components/audio_card.dart';
import 'package:abulfadhwl_android/views/components/controls.dart';
import 'package:abulfadhwl_android/views/components/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:abulfadhwl_android/models/song.dart';
import 'package:abulfadhwl_android/views/other_pages/now_playing_screen_sheet.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

typedef BottomSheetCallback = void Function();

class SongsList extends StatefulWidget {
  final List<Song> songs;
  final DataProvider dataProvider;
  final String indicator;
  final int categoryId;

  const SongsList({
    Key? key,
    required this.songs,
    required this.dataProvider,
    required this.indicator,
    required this.categoryId,
  }) : super(key: key);

  @override
  _SongsListState createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  final ItemScrollController _scrollController = ItemScrollController();
  int _scrollTo = 0;
  List<int> songIds = [];
  String categoryName = "";

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late BottomSheetCallback? _showMyBottomSheetCallBack;

  @override
  void initState() {
    for (var category in widget.dataProvider.categories) {
      if (category.id == widget.categoryId) {
        categoryName = category.name;
      }
    }
    _showMyBottomSheetCallBack = _showBottomSheet;
    if (widget.dataProvider.searchedAudio != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.scrollTo(
            index: _scrollTo, duration: Duration(seconds: 1));
      });
    }

    if (widget.indicator == "Aisha") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.scrollTo(
            index: widget.dataProvider.currentSongIndex,
            duration: Duration(seconds: 1));
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.dataProvider.currentAlbum.name,
              ),
            ),
            Text(
              categoryName,
              style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 78, 76, 76)
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: widget.songs.isEmpty
                ? Center(
                    child: Text("Audio bado hazijawekwa"),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: ScrollablePositionedList.builder(
                      itemScrollController: _scrollController,
                      itemCount: widget.songs.length,
                      itemBuilder: (context, i) {
                        for (var element in widget.songs) {
                          songIds.add(element.id);
                        }
                        _scrollTo =
                            songIds.indexOf(widget.dataProvider.searchedAudio);
                        return AudioCard(
                          dataProvider: widget.dataProvider,
                          songs: widget.songs,
                          index: i,
                        );
                      },
                    )),
          ),
          widget.songs.isEmpty
              ? Container()
              : ValueListenableBuilder(
                  valueListenable: pageManager.currentSongTitleNotifier,
                  builder: (_, title, __) {
                    if (title != "") {
                      return InkWell(
                        onTap: () {
                          _showMyBottomSheetCallBack!();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 10,
                                offset: Offset(2.0, 2.0),
                              )
                            ],
                            color: Colors.orange[50],
                          ),
                          height: 60,
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  width: 35,
                                  child: Icon(
                                    Icons.music_note,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, top: 5, bottom: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CurrentSongTitle(),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            "Sheikh Abul Fadhwl Qassim Mafuta Qassim",
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: PlayButton(),
                                ),
                              ]),
                        ),
                      );
                    } else
                      return Container();
                  })
        ],
      ),
    );
  }

  void _showBottomSheet() {
    setState(() {
      _showMyBottomSheetCallBack = null;
    });
    _scaffoldKey.currentState!
        .showBottomSheet((_) => NowPlayingScreenSheet(
              // songs: widget.songs,
              dataProvider: widget.dataProvider,
            ))
        .closed
        .whenComplete(() {
      if (mounted) {
        setState(() {
          _showMyBottomSheetCallBack = _showBottomSheet;
        });
      }
    });
  }
}
