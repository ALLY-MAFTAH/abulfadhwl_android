// ignore: unused_import
import 'package:abulfadhwl_android/api.dart';
import 'package:abulfadhwl_android/views/initial_pages/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:abulfadhwl_android/providers/songs_provider.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Abulfadhwl());
}

class Abulfadhwl extends StatefulWidget {
  const Abulfadhwl({Key? key}) : super(key: key);

  @override
  State<Abulfadhwl> createState() => _AbulfadhwlState();
}

class _AbulfadhwlState extends State<Abulfadhwl> {
 final DataProvider _dataProvider = DataProvider();

  final SongsProvider _songsProvider = SongsProvider();

  @override
  void initState() {
    super.initState();

    _songsProvider.getAllCategories();
    _dataProvider.getAllBooks();
    _dataProvider.getAllHistories();
    _dataProvider.getAllSlides();
    _dataProvider.getAllArticles();
    _dataProvider.getAllAnnouncements();
    _dataProvider.getAllStreams();
    _dataProvider.getAllLinks();
    _dataProvider.getAllAnswers();

  }

  @override
  void dispose() {
    _songsProvider.dispose();
    super.dispose();
  }  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: _songsProvider,
        ),
        ChangeNotifierProvider.value(
          value: _dataProvider,
        ),
      ],
      child: MaterialApp(
        title: 'Abul Fadhwl App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: AnimatedSplashScreen(),
      ),
    );
  }}
