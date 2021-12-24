import 'package:abulfadhwl_android/models/album.dart';
import 'package:abulfadhwl_android/models/song.dart';
import 'package:abulfadhwl_android/providers/songs_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/views/other_pages/songs_list.dart';

class AlbumCard extends StatefulWidget {
  final Album album;
  final List<Song> songs;

  const AlbumCard({Key? key, required this.album, required this.songs})
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
    final _songObject = Provider.of<SongsProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return SongsList(
              songs: widget.album.songs,
              title: widget.album.name,
              songProvider: _songObject,
            );
          }));
          print(widget.album.songs);
          setState(() {
            _songObject.playlist = widget.album.songs;
          });
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.orange[200],
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: <Widget>[
              Icon(
                FontAwesomeIcons.folderMinus,
                color: Colors.orange[800],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 5, top: 10, bottom: 10),
                  child: Text(
                    widget.album.name,
                    style: TextStyle(
                        color: Colors.deepPurple[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}