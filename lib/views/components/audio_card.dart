import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/constants/more_button_constants.dart';
import 'package:abulfadhwl_android/models/song.dart';
import 'package:abulfadhwl_android/views/components/page_manager.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/services/playlist_repository.dart';
import 'package:abulfadhwl_android/services/service_locator.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

class AudioCard extends StatefulWidget {
  final int index;
  final List<Song> songs;
  final DataProvider dataProvider;
  const AudioCard(
      {Key? key,
      required this.index,
      required this.songs,
      required this.dataProvider})
      : super(key: key);

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
                    widget.dataProvider.songs = widget.songs;
                    widget.dataProvider.currentSongIndex = widget.index;
                    widget.dataProvider.currentSong =
                        widget.dataProvider.songs[widget.index];
                    print(widget.dataProvider.songs);
                    print(widget.dataProvider.songs.length);

                    pageManager.remove();
                    final songRepository = getIt<DemoPlaylist>();
                    final playlist = await songRepository.fetchInitialPlaylist(
                        widget.dataProvider.songs,
                        widget.dataProvider.currentAlbumName);
                    final mediaItems = playlist
                        .map((song) => MediaItem(
                              id: song['id'] ?? '',
                              album: song['album'] ?? '',
                              title: song['title'] ?? '',
                              extras: {'url': song['url']},
                              artist: "Abul Fadhwl Kassim Mafuta Kassim",
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
                  child: Row(children: <Widget>[
                    Icon(
                      Icons.music_note,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 5, top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.songs[widget.index].title,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        _audioHandler.mediaItem.value?.title ==
                                                widget.songs[widget.index].title
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.songs[widget.index].size.toString() +
                                    ' MB',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight:
                                        _audioHandler.mediaItem.value?.title ==
                                                widget.songs[widget.index].title
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
                            color: Colors.black,
                            fontWeight: _audioHandler.mediaItem.value?.title ==
                                    widget.songs[widget.index].title
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                    Container(
                      child: _audioHandler.mediaItem.value?.title ==
                              widget.songs[widget.index].title
                          ? Padding(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              child: Icon(
                                FontAwesomeIcons.circlePlay,
                              ),
                            )
                          : PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.orange,
                              ),
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              onSelected: choiceAction,
                              itemBuilder: (_) {
                                widget.dataProvider.currentSongIndex =
                                    widget.index;
                                return MoreButtonConstants.choices
                                    .map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(
                                      choice,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                    )
                  ]),
                ),
              );
            }));
  }

  void choiceAction(String choice) {
    if (choice == MoreButtonConstants.PlayAudio) {
      setState(() async {
        widget.dataProvider.currentSongIndex = widget.index;
        widget.dataProvider.songs = widget.songs;
        widget.dataProvider.currentSong =
            widget.dataProvider.songs[widget.index];
        print(widget.dataProvider.songs);
        print(widget.dataProvider.songs.length);

        pageManager.remove();
        final songRepository = getIt<DemoPlaylist>();
        final playlist = await songRepository.fetchInitialPlaylist(
            widget.dataProvider.songs, widget.dataProvider.currentAlbumName);
        final mediaItems = playlist
            .map((song) => MediaItem(
                  id: song['id'] ?? '',
                  album: song['album'] ?? '',
                  title: song['title'] ?? '',
                  extras: {'url': song['url']},
                  artist: "Abul Fadhwl Kassim Mafuta Kassim",
                ))
            .toList();
        await _audioHandler.addQueueItems(mediaItems);
        await _audioHandler.skipToQueueItem(widget.index);
      });
    } else if (choice == MoreButtonConstants.ShareAudio) {
      Share.share(api +
          'song/file/' +
          widget.dataProvider.songs[widget.dataProvider.currentSongIndex].id
              .toString());
    } else {
      widget.dataProvider.download(
        api +
            'song/file/' +
            widget.dataProvider.songs[widget.dataProvider.currentSongIndex].id
                .toString(),
        widget.dataProvider.songs[widget.dataProvider.currentSongIndex].file,
        widget.dataProvider.songs[widget.dataProvider.currentSongIndex].title,
      );
    }
  }
}
