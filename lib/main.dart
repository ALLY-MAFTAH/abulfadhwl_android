// ignore: unused_import
import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/views/components/page_manager.dart';
import 'package:abulfadhwl_android/services/service_locator.dart';
import 'package:abulfadhwl_android/views/initial_pages/animated_splash_screen.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


void main() async {
  await setupServiceLocator();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
    ),
  );

  runApp(const Abulfadhwl());
}

class Abulfadhwl extends StatefulWidget {
  const Abulfadhwl({Key? key}) : super(key: key);

  @override
  State<Abulfadhwl> createState() => _AbulfadhwlState();
}

class _AbulfadhwlState extends State<Abulfadhwl> {
  
  final DataProvider _dataProvider = DataProvider();

  @override
  void initState() {
    getIt<PageManager>().init();
    super.initState();

    _dataProvider.getAllCategories();
    _dataProvider.getAllBooks();
    _dataProvider.getAllHistories();
    _dataProvider.getAllSlides();
    _dataProvider.getAllArticles();
    _dataProvider.getAllAnnouncements();
    _dataProvider.getAllStreams();
    _dataProvider.getAllLinks();
    _dataProvider.getAllAnswers();
  

    // AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    //   return true;
    // });
  }

  @override
  void dispose() {
        getIt<PageManager>().dispose();

    _dataProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: _dataProvider,
        ),
        ChangeNotifierProvider.value(
          value: _dataProvider,
        ),
      ],
      child: MaterialApp(
        title: 'Abul Fadhwl App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: GoogleFonts.gelasioTextTheme(),
            primarySwatch: Colors.orange),
        home: AnimatedSplashScreen(),
      ),
    );
  }
}
