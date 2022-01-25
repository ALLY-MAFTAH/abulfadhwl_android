import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/models/song.dart';

abstract class PlaylistRepository {
  Future<List<Map<String, String>>> fetchInitialPlaylist(
      List<Song> songs, String currentAlbumName);
}

class DemoPlaylist extends PlaylistRepository {
  DemoPlaylist();
  @override
  Future<List<Map<String, String>>> fetchInitialPlaylist(
      List<Song> songs, String currentAlbumName) async {
    return List.generate(
        songs.length, (index) => _nextSong(songs, currentAlbumName, index));
  }

  Map<String, String> _nextSong(
      List<Song> songs, String currentAlbumName, int i) {
    return {
      'id': songs[i].id.toString(),
      'title': songs[i].title,
      'album': currentAlbumName,
      'url': api + 'song/file/' + songs[i].id.toString(),
    };
  }
}
