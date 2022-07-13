import 'package:abulfadhwl_android/models/album.dart';
import 'package:abulfadhwl_android/models/song.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/data_provider.dart';
import '../other_pages/songs_list.dart';

class CustomSearchDelegate extends SearchDelegate {
// first overwrite to
// clear the search text

  initState() {}
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);

    List<Song> matchQuery = [];
    for (var audio in _dataProvider.audios) {
      if (audio.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(audio);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.title),
        );
      },
    );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);

    List<Song> matchQuery = [];
    for (var audio in _dataProvider.audios) {
      if (audio.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(audio);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return Container(
          color: Color.fromARGB(255, 237, 233, 229),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromARGB(255, 243, 239, 233))),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) {
                    List<Song> selectedAlbumAudios = [];
                    for (var aud in _dataProvider.audios) {
                      if (aud.albumId == result.albumId) {
                        selectedAlbumAudios.add(aud);
                      }
                    }
                    List<Album> allAlbums = [];
                    for (var category in _dataProvider.categories) {
                      for (var alb in category.albums) {
                        allAlbums.add(alb);
                      }
                    }
                    for (var album in allAlbums) {
                      if (album.id == result.albumId) {
                        _dataProvider.currentAlbumName = album.name;
                      }
                    }
                    return SongsList(
                      songs: selectedAlbumAudios,
                      dataProvider: _dataProvider,
                    );
                  }));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    result.title,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
