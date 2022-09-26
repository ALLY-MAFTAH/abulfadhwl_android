import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/models/song.dart';
import 'package:abulfadhwl_android/views/components/page_manager.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/services/playlist_repository.dart';
import 'package:abulfadhwl_android/services/service_locator.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';


class AudioCard extends StatefulWidget {

  final DataProvider dataProvider;

  final int index;
  final List<Song> songs;

  AudioCard({
    Key? key,
    required this.index,
    required this.songs,
    required this.dataProvider,
  }) : super(key: key);

  @override
  _AudioCardState createState() => _AudioCardState();
}

class _AudioCardState extends State<AudioCard> {
  final _audioHandler = getIt<AudioHandler>();
  final pageManager = getIt<PageManager>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, top: 1.5, right: 5),
        child: ValueListenableBuilder(
            valueListenable: pageManager.currentSongTitleNotifier,
            builder: (_, title, __) {
              return InkWell(
                onTap: () {
                  setState(() async {
                    widget.dataProvider.searchedAudio = 0;
                    widget.dataProvider.songs = widget.songs;
                    widget.dataProvider.currentSongIndex = widget.index;
                    widget.dataProvider.currentSong =
                        widget.dataProvider.songs[widget.index];

                    pageManager.remove();
                    final songRepository = getIt<DemoPlaylist>();
                    final playlist = await songRepository.fetchInitialPlaylist(
                        widget.dataProvider.songs,
                        widget.dataProvider.currentAlbum.name);
                    final mediaItems = playlist
                        .map((song) => MediaItem(
                              id: song['id'] ?? '',
                              album: song['album'] ?? '',
                              title: song['title'] ?? '',
                              extras: {'url': song['url']},
                              artist: "Sheikh Abul Fadhwl Qassim Mafuta Qassim",
                            ))
                        .toList();

                    await _audioHandler.addQueueItems(mediaItems);
                    await _audioHandler.skipToQueueItem(widget.index);
                  });
                },
                child: Card(
                    color: _audioHandler.mediaItem.value?.title ==
                            widget.songs[widget.index].title
                        ? Colors.orange[50]
                        : Colors.white,
                    child: Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) => _shareAudio(),
                              backgroundColor:
                                  Color.fromARGB(255, 216, 214, 211),
                              foregroundColor: Colors.orange,
                              icon: Icons.share,
                            ),
                            SlidableAction(
                              onPressed: (context) => _downloadAudio(),
                              backgroundColor:
                                  Color.fromARGB(255, 229, 227, 224),
                              foregroundColor: Colors.orange,
                              icon: Icons.download,
                            ),
                            SlidableAction(
                                onPressed: (context) => _playAudio(),
                                backgroundColor:
                                    Color.fromARGB(255, 244, 241, 237),
                                foregroundColor: Colors.orange,
                                icon: FontAwesomeIcons.play),
                          ],
                        ),
                        child: Row(children: <Widget>[
                          Container(
                            color: Colors.orange,
                            height: 60,
                            width: 5,
                          ),
                          Icon(
                            Icons.music_note,
                          ),
                          Expanded(
                            child: Container(
                              padding:
                                  EdgeInsets.only(left: 5, top: 10, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      widget.songs[widget.index].title,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: _audioHandler
                                                      .mediaItem.value?.title ==
                                                  widget
                                                      .songs[widget.index].title
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color:
                                              widget.songs[widget.index].id ==
                                                      widget.dataProvider
                                                          .searchedAudio
                                                  ? Colors.orange
                                                  : Colors.black),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      widget.songs[widget.index].size
                                              .toString() +
                                          ' MB',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              widget.songs[widget.index].id ==
                                                      widget.dataProvider
                                                          .searchedAudio
                                                  ? Colors.orange
                                                  : Colors.grey[600],
                                          fontWeight: _audioHandler
                                                      .mediaItem.value?.title ==
                                                  widget
                                                      .songs[widget.index].title
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              widget.songs[widget.index].duration,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: widget.songs[widget.index].id ==
                                          widget.dataProvider.searchedAudio
                                      ? Colors.orange
                                      : Colors.black,
                                  fontWeight:
                                      _audioHandler.mediaItem.value?.title ==
                                              widget.songs[widget.index].title
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                            ),
                          ),
                          Container(
                              child: _audioHandler.mediaItem.value?.title ==
                                      widget.songs[widget.index].title
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(right: 10, left: 10),
                                      child: Icon(FontAwesomeIcons.playCircle,
                                          color: Colors.orange),
                                    )
                                  : Container())
                        ]))),
              );
            }));
  }

  _playAudio() {
    setState(() async {
      widget.dataProvider.searchedAudio = 0;
      widget.dataProvider.currentSongIndex = widget.index;
      widget.dataProvider.songs = widget.songs;
      widget.dataProvider.currentSong = widget.dataProvider.songs[widget.index];
      print(widget.dataProvider.songs);
      print(widget.dataProvider.songs.length);

      pageManager.remove();
      final songRepository = getIt<DemoPlaylist>();
      final playlist = await songRepository.fetchInitialPlaylist(
          widget.dataProvider.songs, widget.dataProvider.currentAlbum.name);
      final mediaItems = playlist
          .map((song) => MediaItem(
                id: song['id'] ?? '',
                album: song['album'] ?? '',
                title: song['title'] ?? '',
                extras: {'url': song['url']},
                artist: "Sheikh Abul Fadhwl Qassim Mafuta Qassim",
              ))
          .toList();
      await _audioHandler.addQueueItems(mediaItems);
      await _audioHandler.skipToQueueItem(widget.index);
    });
  }

  _downloadAudio() {
    widget.dataProvider.searchedAudio = 0;
    widget.dataProvider.songs = widget.songs;
    widget.dataProvider.download(
      api +
          'song/file/' +
          widget.dataProvider.songs[widget.index].id.toString(),
      widget.dataProvider.songs[widget.index].file,
      widget.dataProvider.songs[widget.index].title,
    );
  }

  _shareAudio() {
    widget.dataProvider.searchedAudio = 0;
    widget.dataProvider.songs = widget.songs;
    Share.share(api +
        'song/file/' +
        widget.dataProvider.songs[widget.index].id.toString());
  }
}
