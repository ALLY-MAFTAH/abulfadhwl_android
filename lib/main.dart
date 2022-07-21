import 'dart:convert';

import 'package:abulfadhwl_android/views/components/page_manager.dart';
import 'package:abulfadhwl_android/services/service_locator.dart';
import 'package:abulfadhwl_android/views/initial_pages/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

const debug = true;

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
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    getIt<PageManager>().init();
    super.initState();
    _initPackageInfo();

    _dataProvider.getAllCategories();
    _dataProvider.getAllBooks();
    _dataProvider.getAllHistories();
    _dataProvider.getAllSlides();
    _dataProvider.getAllArticles();
    _dataProvider.getAllAnnouncements();
    _dataProvider.getAllStreams();
    _dataProvider.getAllLinks();
    _dataProvider.getAllAnswers();
    _dataProvider.getAllSongs();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // AndroidInitializationSettings('app_icon');
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            macOS: initializationSettingsMacOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    super.initState();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void selectNotification(String? json) async {
    final obj = jsonDecode(json!);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      print("Eraaaaaaaaa");
    }
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
        )
      ],
      child: MaterialApp(
        title: _packageInfo.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: GoogleFonts.gelasioTextTheme(),
            primarySwatch: Colors.orange),
        home: AnimatedSplashScreen(),
      ),
    );
  }
}
