import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/constants/more_button_constants.dart';
import 'package:abulfadhwl_android/models/song.dart';
import 'package:abulfadhwl_android/notifiers/play_button_notifier.dart';
import 'package:abulfadhwl_android/views/components/page_manager.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/services/playlist_repository.dart';
import 'package:abulfadhwl_android/services/service_locator.dart';
import 'package:audio_service/audio_service.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

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

  int newIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();

    return Padding(
        padding: const EdgeInsets.only(left: 5, top: 1.5, right: 5),
        child: ValueListenableBuilder<ButtonState>(
            valueListenable: pageManager.playButtonNotifier,
            builder: (_, value, __) {
              return InkWell(
                onTap: () async {
                  widget.dataProvider.currentSong = widget.songs[widget.index];
                  widget.dataProvider.songs = widget.songs;
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

                  _audioHandler.addQueueItems(mediaItems);
                  _audioHandler.skipToQueueItem(widget.index);
                },
                child: Card(
                  color: widget.dataProvider.currentSong.id ==
                          widget.songs[widget.index].id
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
                                        widget.dataProvider.currentSong.id ==
                                                widget.songs[widget.index].id
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.songs[widget.index].description,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight:
                                        widget.dataProvider.currentSong.id ==
                                                widget.songs[widget.index].id
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: widget.dataProvider.currentSong.id ==
                              widget.songs[widget.index].id
                          ? Padding(
                              padding: EdgeInsets.only(right: 12, left: 5),
                              child: Icon(
                                FontAwesomeIcons.playCircle,
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
      setState(() {
        newIndex = widget.dataProvider.currentSongIndex;
        widget.dataProvider.currentSong =
            widget.songs[widget.dataProvider.currentSongIndex];

        // widget.dataProvider.playingItem = widget
        //     .dataProvider.audioPlaylist[widget.dataProvider.currentSongIndex];

        // widget.onSelected(playingItem);
      });
    } else if (choice == MoreButtonConstants.ShareAudio) {
      Share.share(api +
          'song/file/' +
          widget.songs[widget.dataProvider.currentSongIndex].id.toString());
    } else {
      widget.dataProvider.download(
          api +
              'song/file/' +
              widget.songs[widget.dataProvider.currentSongIndex].id.toString(),
           widget.songs[widget.dataProvider.currentSongIndex].file,
           widget.songs[widget.dataProvider.currentSongIndex].title,
           );
    }
  }
}
