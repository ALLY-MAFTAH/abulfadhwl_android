import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/providers/get_and_post_provider.dart';
import 'package:abulfadhwl_android/views/screens/audios_screen.dart';
import 'package:abulfadhwl_android/views/screens/books_screen.dart';
import 'package:abulfadhwl_android/views/screens/history_screen.dart';
import 'package:abulfadhwl_android/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LayoutPage extends StatefulWidget {
  final GetAndPostProvider getAndPostProvider = GetAndPostProvider();

  @override
  _LayoutPageState createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _getAndPostProvider = Provider.of<GetAndPostProvider>(context);
    final _dataProvider = Provider.of<DataProvider>(context);

    final List<Widget> _screens = [
      HomeScreen(),
      AudiosScreen(
        songCategories: _getAndPostProvider.categories,
      ),
      BooksScreen(),
      HistoryScreen()
    ];
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit this App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
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
            selectedItemColor: _dataProvider.btnColor,
            unselectedItemColor: Colors.grey[600],
            onTap: tappedTab,
            currentIndex: _currentIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.house), label: 'Mwanzo'),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.microphone ), label: 'Sauti'),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.book), label: 'Vitabu na Makala'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Historia')
            ],
          ),
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
