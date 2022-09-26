import 'package:abulfadhwl_android/models/album.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/providers/get_and_post_provider.dart';
import 'package:abulfadhwl_android/services/service_locator.dart';
import 'package:abulfadhwl_android/views/components/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:abulfadhwl_android/views/other_pages/songs_list.dart';
import 'package:provider/provider.dart';

import '../../constants/more_button_constants.dart';

class AlbumCard extends StatefulWidget {
  final Album album;

  final int i;

  const AlbumCard({
    Key? key,
    required this.i,
    required this.album,
  }) : super(key: key);

  @override
  _AlbumCardState createState() => _AlbumCardState();
}

class _AlbumCardState extends State<AlbumCard> {
  @override
  void initState() {
    super.initState();
  }

  Widget _downloadDialog(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);
    double size = 0;
    for (var song in widget.album.songs) {
      size = size + song.size;
    }
    return AlertDialog(
      title: Text('Tafadhali Hakiki'),
      content: Text("Unataka Kupakua Sauti Zote, Zenye Ukubwa wa " +
          size.toStringAsFixed(1) +
          " MB"),
      actions: [
        TextButton(
            onPressed: () {
              _dataProvider.downloadAlbum(widget.album.songs);
              Navigator.of(context).pop();
            },
            child: const Text('Ndio')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Hapana'))
      ],
    );
  }

  Widget _detailsDialog(BuildContext context) {
    double size = 0;
    for (var song in widget.album.songs) {
      size = size + song.size;
    }
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      titlePadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      title: Text(
        widget.album.name,
        style: TextStyle(fontSize: 15),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(" • " + widget.album.description!,
              style: TextStyle(fontSize: 15)),
          Text(
            "\n • Jumla ya Sauti ni: " + widget.album.songs.length.toString(),
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "\n • Ukubwa Wake ni: " + size.toStringAsFixed(1) + " MB",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
      actions: [
        TextButton(
            style: ButtonStyle(),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Sawa'))
      ],
    );
  }

  void _baseDialog(String type) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: type == "Details" ? _detailsDialog(ctx) : _downloadDialog(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 600),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);
    final _getAndPostProvider = Provider.of<GetAndPostProvider>(context);

    final pageManager = getIt<PageManager>();

    return ValueListenableBuilder(
        valueListenable: pageManager.playButtonNotifier,
        builder: (_, value, __) {
          double albumSize = 0;
          for (var song in widget.album.songs) {
            albumSize = albumSize + song.size;
          }
          return InkWell(
              onTap: () {
                setState(() {
                  _dataProvider.currentAlbum = widget.album;
                  _dataProvider.searchedAudio = 0;
                });

                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return SongsList(
                    indicator: "",
                    songs: widget.album.songs,
                    dataProvider: _dataProvider,
                    categoryId: widget.album.categoryId,
                    getAndPostProvider: _getAndPostProvider,
                  );
                }));
              },
              child: Card(
                  color: _dataProvider.currentSong.albumId == widget.album.id
                      ? Colors.orange[50]
                      : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      children: <Widget>[
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Icon(
                              Icons.folder,
                              size: 60,
                              color: Colors.orange[200],
                            ),
                            Text(
                              widget.album.songs.length.toString() + "\nAudios",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontWeight:
                                      _dataProvider.currentSong.albumId ==
                                              widget.album.id
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    widget.i.toString() +
                                        '. ' +
                                        widget.album.name,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight:
                                            _dataProvider.currentSong.albumId ==
                                                    widget.album.id
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    widget.album.description ?? "",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                        fontWeight:
                                            _dataProvider.currentSong.albumId ==
                                                    widget.album.id
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 5),
                        //   child: Text(
                        //     albumSize.toStringAsFixed(1) + " MB",
                        //     style: TextStyle(
                        //         fontSize: 13,
                        //         color: Colors.grey[600],
                        //         fontWeight: _dataProvider.currentSong.albumId ==
                        //                 widget.album.id
                        //             ? FontWeight.bold
                        //             : FontWeight.normal),
                        //   ),
                        // ),
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.orange,
                          ),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onSelected: choiceAction,
                          itemBuilder: (_) {
                            return MoreButtonConstants.choices
                                .map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(
                                  choice,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                  )));
        });
  }

  void choiceAction(String choice) {
    if (choice == MoreButtonConstants.Details) {
      _baseDialog("Details");
    } else {
      _baseDialog("DownloadAudios");
    }
  }
}
