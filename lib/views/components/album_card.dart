import 'package:abulfadhwl_android/models/album.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/services/service_locator.dart';
import 'package:abulfadhwl_android/views/components/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/views/other_pages/songs_list.dart';
// import 'package:vector_math/vector_math.dart' as math;

class AlbumCard extends StatefulWidget {
  final Album album;
  final DataProvider dataProvider;
  final int i;

  const AlbumCard({
    Key? key,
    required this.i,
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

  Widget _dialog(BuildContext context) {
    return AlertDialog(
      title: Text('Tafadhali Hakiki'),
      content:
          Text("Unataka Kupakua Sauti Zote Kwenye " + widget.album.name + "?"),
      actions: [
        TextButton(
            onPressed: () {
              widget.dataProvider.downloadAlbum(widget.album.songs);
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

  void _scaleDialog() {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 600),
    );
  }
  // void _rotateDialog() {
  //   showGeneralDialog(
  //     context: context,
  //     pageBuilder: (ctx, a1, a2) {
  //       return Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(60)
  //         ),
  //       );
  //     },
  //     transitionBuilder: (ctx, a1, a2, child) {
  //       return Transform.rotate(
  //         angle: math.radians(a1.value * 360),
  //         child: _dialog(ctx),
  //       );
  //     },
  //     transitionDuration: const Duration(milliseconds: 1500),
  //   );
  // }

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
                  widget.dataProvider.searchedAudio = 0;
                });
                Navigator.push(context, MaterialPageRoute(builder: (_) {

                  return SongsList(
                    songs: widget.album.songs,
                    dataProvider: _dataProvider,
                  );
                }));
              },
              child: Card(
                  color: _dataProvider.currentSong.albumId == widget.album.id
                      ? Colors.orange[50]
                      : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
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
                                    // _rotateDialog();
                                    _scaleDialog();
                                  },
                                  icon: Icon(
                                    Icons.download,
                                    color: Colors.orange,
                                  ))),
                        )
                      ],
                    ),
                  )));
        });
  }
}
