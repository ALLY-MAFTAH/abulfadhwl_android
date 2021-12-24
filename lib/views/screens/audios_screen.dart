import 'package:abulfadhwl_android/models/song_category.dart';
import 'package:abulfadhwl_android/views/components/album_card.dart';
import 'package:abulfadhwl_android/views/other_pages/drawer_page.dart';
import 'package:flutter/material.dart';

class AudiosScreen extends StatefulWidget {
  final List<SongCategory> songCategories;

  const AudiosScreen({Key? key, required this.songCategories})
      : super(key: key);

  @override
  _AudiosScreenState createState() => _AudiosScreenState();
}

class _AudiosScreenState extends State<AudiosScreen> {
  List<Widget> _screens = [];

  List<Tab> _tabs = [];

  @override
  void initState() {

    print(widget.songCategories);
    widget.songCategories.forEach((category) {
      _tabs.add(Tab(
        text: category.name,
      ));
      print("objectiiiiiii");
      _screens.add(ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return AlbumCard(
            album: category.albums[index],
            songs: category.albums[index].songs,
          );
        },
        itemCount: category.albums.length,
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.songCategories.isEmpty
        ? Scaffold(
            backgroundColor: Colors.orange[50],
            appBar: AppBar(
                iconTheme: new IconThemeData(
                  color: Colors.deepPurple[800],
                ),
                title: Text(
                  'Audios',
                  style: TextStyle(
                    color: Colors.deepPurple[800],
                  ),
                )),
            drawer: DrawerPage(),
            body: Center(child: CircularProgressIndicator(),),
          )
        : DefaultTabController(
            length: widget.songCategories.length,
            child: Scaffold(
              backgroundColor: Colors.orange[50],
              appBar: AppBar(
                iconTheme: new IconThemeData(
                  color: Colors.deepPurple[800],
                ),
                title: Text(
                  'Audios',
                  style: TextStyle(
                    color: Colors.deepPurple[800],
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  )
                ],
                bottom: TabBar(
                    unselectedLabelColor: Colors.deepPurple,
                    indicatorColor: Colors.deepPurple,
                    indicatorWeight: 3,
                    unselectedLabelStyle:
                        TextStyle(fontWeight: FontWeight.normal),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    labelColor: Colors.deepPurple[800],
                    isScrollable: true,
                    tabs: _tabs),
              ),
              drawer: DrawerPage(),
              
              body: TabBarView(children: _screens),
            ),
          );
  }
}
