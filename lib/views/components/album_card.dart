import 'package:abulfadhwl_android/models/album.dart';
import 'package:abulfadhwl_android/models/song.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/services/service_locator.dart';
import 'package:abulfadhwl_android/views/components/page_manager.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/views/other_pages/songs_list.dart';

class AlbumCard extends StatefulWidget {
  final Album album;
  // final List<Song> songs;

  const AlbumCard({Key? key, required this.album, 
  // required this.songs
  })
      : super(key: key);

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
                        Icon(
                          Icons.folder
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
                                    widget.album.description,
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
                          child: CircleAvatar(
                              child: IconButton(
                                  onPressed: () {},
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
