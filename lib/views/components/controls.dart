import 'package:abulfadhwl_android/models/song.dart';
import 'package:abulfadhwl_android/notifiers/play_button_notifier.dart';
import 'package:abulfadhwl_android/notifiers/progress_notifier.dart';
import 'package:abulfadhwl_android/notifiers/repeat_button_notifier.dart';
import 'package:abulfadhwl_android/views/components/page_manager.dart';
import 'package:abulfadhwl_android/services/service_locator.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import '../../providers/data_provider.dart';

class CurrentSongTitle extends StatelessWidget {
  const CurrentSongTitle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<String>(
      valueListenable: pageManager.currentSongTitleNotifier,
      builder: (_, title, __) {
        return Expanded(
          child: Marquee(
              text: title,
              pauseAfterRound: Duration(seconds: 2),
              blankSpace: 200,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        );
      },
    );
  }
}

class Playlist extends StatelessWidget {
  const Playlist({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return Expanded(
      child: ValueListenableBuilder<List<String>>(
        valueListenable: pageManager.playlistNotifier,
        builder: (context, playlistTitles, _) {
          return ListView.builder(
            itemCount: playlistTitles.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${playlistTitles[index]}'),
              );
            },
          );
        },
      ),
    );
  }
}

class AddRemoveSongButtons extends StatelessWidget {
  const AddRemoveSongButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // FloatingActionButton(
          //   onPressed: pageManager.add,
          //   child: Icon(Icons.add),
          // ),
          FloatingActionButton(
            onPressed: pageManager.remove,
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class AudioProgressBar extends StatefulWidget {
  const AudioProgressBar({Key? key}) : super(key: key);

  @override
  State<AudioProgressBar> createState() => _AudioProgressBarState();
}

class _AudioProgressBarState extends State<AudioProgressBar> {
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: pageManager.seek,
        );
      },
    );
  }
}

class AudioControlButtons extends StatelessWidget {
  final List<Song> songs;
  const AudioControlButtons({Key? key, required this.songs}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RepeatButton(),
          PreviousSongButton(),
          PlayButton(),
          NextSongButton(),
          ShuffleButton(),
        ],
      ),
    );
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);

    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<RepeatState>(
      valueListenable: pageManager.repeatButtonNotifier,
      builder: (context, value, child) {
        Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = Icon(
              Icons.repeat,
              color: Colors.grey,
            );
            break;
          case RepeatState.repeatSong:
            icon = Icon(
              Icons.repeat_one,
              color: _dataProvider.btnColor,
            );
            break;
          case RepeatState.repeatPlaylist:
            icon = Icon(
              Icons.repeat,
              color: _dataProvider.btnColor,
            );
            break;
        }
        return IconButton(
          icon: icon,
          iconSize: 30,
          onPressed: pageManager.repeat,
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);

    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isFirstSongNotifier,
      builder: (_, isFirst, __) {
        return IconButton(
          icon: Icon(
            Icons.skip_previous,
          ),
          iconSize: 50,
          color: _dataProvider.btnColor,
          onPressed: (isFirst) ? null : pageManager.previous,
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);

    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
            );
          case ButtonState.paused:
            return IconButton(
              icon: Icon(FontAwesomeIcons.play),
              iconSize: 30,
              color: _dataProvider.btnColor,
              onPressed: pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: Icon(FontAwesomeIcons.pause),
              iconSize: 30,
              color: _dataProvider.btnColor,
              onPressed: pageManager.pause,
            );
        }
      },
    );
  }
}

class LargePlayButton extends StatelessWidget {
  const LargePlayButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);

    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
            );
          case ButtonState.paused:
            return IconButton(
              icon: Icon(
                FontAwesomeIcons.play,
              ),
              iconSize: 50,
              color: _dataProvider.btnColor,
              onPressed: pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: Icon(
                FontAwesomeIcons.pause,
              ),
              iconSize: 50,
              color: _dataProvider.btnColor,
              onPressed: pageManager.pause,
            );
        }
      },
    );
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);

    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          icon: Icon(
            Icons.skip_next,
          ),
          iconSize: 50,
          color: _dataProvider.btnColor,
          onPressed: (isLast) ? null : pageManager.next,
        );
      },
    );
  }
}

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);

    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isShuffleModeEnabledNotifier,
      builder: (context, isEnabled, child) {
        return IconButton(
          icon: (isEnabled)
              ? Icon(Icons.shuffle, color: _dataProvider.btnColor, size: 30)
              : Icon(Icons.shuffle, color: Colors.grey, size: 30),
          onPressed: pageManager.shuffle,
        );
      },
    );
  }
}
