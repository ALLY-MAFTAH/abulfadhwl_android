import 'package:abulfadhwl_android/models/song_category.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/views/components/album_card.dart';
import 'package:abulfadhwl_android/views/other_pages/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/custom_search_delegate.dart';
import '../components/draggable_fab.dart';

class AudiosScreen extends StatefulWidget {
  final List<SongCategory> songCategories;
  final DataProvider dataProvider;

  final GlobalKey parentKey = GlobalKey();

  AudiosScreen(
      {Key? key, required this.songCategories, required this.dataProvider})
      : super(key: key);

  @override
  _AudiosScreenState createState() => _AudiosScreenState();
}

class _AudiosScreenState extends State<AudiosScreen> {
  List<Widget> _screens = [];

  List<Tab> _tabs = [];

  @override
  void initState() {
    widget.songCategories.forEach((category) {
      _tabs.add(Tab(
        text: category.name,
      ));
      _screens.add(RefreshIndicator(
        onRefresh: widget.dataProvider.reloadPage,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (BuildContext context, int index) {
            return AlbumCard(
              album: category.albums[index],
              dataProvider: widget.dataProvider,
              i: index + 1,
            );
          },
          itemCount: category.albums.length,
          // itemCount: category.albums.length,
        ),
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.songCategories.isEmpty
        ? Scaffold(
            appBar: AppBar(
                iconTheme: new IconThemeData(),
                title: Text(
                  'Sauti',
                  style: TextStyle(),
                )),
            drawer: DrawerPage(),
            body: RefreshIndicator(
              onRefresh: widget.dataProvider.reloadPage,
              child: ListView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: [
                  Container(
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                        ],
                      ))
                ],
              ),
            ),
          )
        : Stack(
            children: [
              DefaultTabController(
                  length: widget.songCategories.length,
                  child: Scaffold(
                    appBar: AppBar(
                      iconTheme: new IconThemeData(),
                      title: Text(
                        'Sauti',
                        style: TextStyle(),
                      ),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: CustomSearchDelegate());
                          },
                        )
                      ],
                    ),
                    drawer: DrawerPage(),
                    body: Column(
                      children: [
                        Card(
                          elevation: 10,
                          color: Colors.orange[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: TabBar(
                              indicator: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              unselectedLabelStyle: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.normal),
                              labelStyle: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.bold,
                              ),
                              isScrollable: true,
                              tabs: _tabs),
                        ),
                        Expanded(child: TabBarView(children: _screens)),
                      ],
                    ),
                  )),
              DraggableFloatingActionButton(
                  child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.black),
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 60,
                      )),
                  initialOffset: Offset(MediaQuery.of(context).size.width - 70,
                      MediaQuery.of(context).size.height - 130),
                  minOffset: const Offset(11, 65),
                  maxOffset: Offset(MediaQuery.of(context).size.width - 70,
                      MediaQuery.of(context).size.height - 130),
                  parentKey: widget.parentKey,
                  onFabPressed: () {
                    print("Pressed");
                  })
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (_) => HistoryScreen()));
            ],
          );
  }
}
