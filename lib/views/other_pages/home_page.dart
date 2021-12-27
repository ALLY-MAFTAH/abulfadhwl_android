import 'package:abulfadhwl_android/views/screens/audios_screen.dart';
import 'package:abulfadhwl_android/views/screens/books_screen.dart';
import 'package:abulfadhwl_android/views/screens/history_screen.dart';
import 'package:abulfadhwl_android/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/providers/songs_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final songCategoryProvider = Provider.of<SongsProvider>(context);
    final _dataProvider = Provider.of<DataProvider>(context);
    final List<Widget> _screens = [
      HomeScreen(
        dataProvider: _dataProvider,
      ),
      BooksScreen(),
      AudiosScreen(
        songCategories: songCategoryProvider.categories,
      ),
      HistoryScreen()
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
        ),
        child: BottomNavigationBar(
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey[600],
          onTap: tappedTab,
          currentIndex: _currentIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.book), label: 'Books'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.microphone), label: 'Audios'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'History')
          ],
        ),
      ),
    );
  }

  void tappedTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
