import 'package:abulfadhwl_android/models/song_category.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/views/components/album_card.dart';
import 'package:abulfadhwl_android/views/other_pages/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/get_and_post_provider.dart';
import '../../services/service_locator.dart';
import '../components/custom_search_delegate.dart';
import '../components/draggable_fab.dart';
import '../components/page_manager.dart';
import '../other_pages/songs_list.dart';

class AudiosScreen extends StatefulWidget {
  final List<SongCategory> songCategories;
  final GetAndPostProvider getAndPostProvider = GetAndPostProvider();

  final GlobalKey parentKey = GlobalKey();

  AudiosScreen({Key? key, required this.songCategories}) : super(key: key);

  @override
  _AudiosScreenState createState() => _AudiosScreenState();
}

class _AudiosScreenState extends State<AudiosScreen>
    with TickerProviderStateMixin {
  final pageManager = getIt<PageManager>();
  List<Widget> _screens = [];
  List<Tab> _tabs = [];
  late TabController _tabController;

  @override
  void initState() {
    setState(() {
      widget.songCategories.forEach((category) {
        _tabs.add(Tab(
          text: category.name,
        ));
        _screens.add(RefreshIndicator(
          onRefresh: widget.getAndPostProvider.reloadPage,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (BuildContext context, int index) {
              return AlbumCard(
                album: category.albums[index],
                i: index + 1,
              );
            },
            itemCount: category.albums.length,
          ),
        ));
      });
    });
    _tabController = TabController(
      vsync: this,
      length: _tabs.length,
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _getAndPostProvider = Provider.of<GetAndPostProvider>(context);
    final _dataProvider = Provider.of<DataProvider>(context);

    return widget.songCategories.isEmpty
        ? Scaffold(
            appBar: AppBar(
              iconTheme: new IconThemeData(color: Colors.white),
              title: Text(
                'Sauti',
                style: TextStyle(),
              ),
            ),
            drawer: DrawerPage(),
            body: RefreshIndicator(
              onRefresh: _getAndPostProvider.reloadPage,
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
                  initialIndex: _tabController.index,
                  length: widget.songCategories.length,
                  child: Scaffold(
                      appBar: AppBar(
                        iconTheme: new IconThemeData(color: Colors.white),
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
                          ),
                        ],
                      ),
                      drawer: DrawerPage(),
                      body: Column(
                        children: [
                          Card(
                            elevation: 10,
                            color: _dataProvider.btnColorLight,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: TabBar(
                                controller: _tabController,
                                isScrollable: true,
                                indicator: BoxDecoration(
                                    color: _dataProvider.btnColor,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                unselectedLabelColor: _dataProvider.btnColor,
                                unselectedLabelStyle: GoogleFonts.ubuntu(
                                    fontWeight: FontWeight.normal),
                                labelStyle: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold,
                                ),
                                tabs: _tabs),
                          ),
                          Expanded(
                              child: TabBarView(
                                  controller: _tabController,
                                  children: _screens))
                        ],
                      ))),
              ValueListenableBuilder(
                  valueListenable: pageManager.currentSongTitleNotifier,
                  builder: (_, title, __) {
                    return title == ""
                        ? Container()
                        : DraggableFloatingActionButton(
                            child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _dataProvider.btnColorLight ,
                                  border: Border.all(color:_dataProvider.btnColor??Color.fromARGB(255, 112, 45, 2))
                                ),
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  color: _dataProvider.btnColor,
                                  size: 60,
                                )),
                            initialOffset: Offset(
                                MediaQuery.of(context).size.width - 170,
                                MediaQuery.of(context).size.height - 530),
                            minOffset: const Offset(11, 65),
                            maxOffset: Offset(
                                MediaQuery.of(context).size.width - 70,
                                MediaQuery.of(context).size.height - 130),
                            parentKey: widget.parentKey,
                            onFabPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SongsList(
                                            indicator: "Aisha",
                                            dataProvider: _dataProvider,
                                            songs: _dataProvider.songs,
                                            categoryId: _dataProvider
                                                .currentAlbum.categoryId,
                                            getAndPostProvider:
                                                _getAndPostProvider,
                                          )));
                            });
                  })
            ],
          );
  }
}
