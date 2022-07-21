import 'package:abulfadhwl_android/models/album.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/services/service_locator.dart';
import 'package:abulfadhwl_android/views/components/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/views/other_pages/songs_list.dart';

class AlbumCard extends StatefulWidget {
  final Album album;
  final DataProvider dataProvider;

  const AlbumCard({
    Key? key,
    required this.album,
    required this.dataProvider,
  }) : super(key: key);

  @override
  _AlbumCardState createState() => _AlbumCardState();
}

class _AlbumCardState extends State<AlbumCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);
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
                  _dataProvider.currentAlbumName = widget.album.name;
                });
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return SongsList(
                    songs: widget.album.songs,
                    dataProvider: _dataProvider,
                  );
                }));
                print(widget.album.songs);
              },
              child: Card(
                  color: _dataProvider.currentSong.albumId == widget.album.id
                      ? Colors.orange[50]
                      : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.folder),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
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
                                    widget.album.description??"",
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
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            albumSize.toStringAsFixed(1) + " MB",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: _dataProvider.currentSong.albumId ==
                                        widget.album.id
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: CircleAvatar(
                              child: IconButton(
                                  onPressed: () {
                                    widget.dataProvider.downloadAlbum(widget.album.songs);
                                  },
                                  icon: Icon(
                                    Icons.download,
                                    color: Colors.orange,
                                  ))),
                        )
                      ],
                    ),
                  ))
              // }),
              );
        });
  }

}
