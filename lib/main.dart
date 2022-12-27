import 'dart:convert';

import 'package:abulfadhwl_android/providers/get_and_post_provider.dart';
import 'package:abulfadhwl_android/views/components/page_manager.dart';
import 'package:abulfadhwl_android/services/service_locator.dart';
import 'package:abulfadhwl_android/views/initial_pages/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

const debug = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
  final GetAndPostProvider _getAndPostProvider = GetAndPostProvider();
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

    _getAndPostProvider.getAllCategories();
    _getAndPostProvider.getAllBooks();
    _getAndPostProvider.getAllHistories();
    _getAndPostProvider.getAllSlides();
    _getAndPostProvider.getAllArticles();
    _getAndPostProvider.getAllAnnouncements();
    _getAndPostProvider.getAllStreams();
    _getAndPostProvider.getAllLinks();
    _getAndPostProvider.getAllAnswers();
    _getAndPostProvider.getAllSongs();
    _getAndPostProvider.getAllAlbums();
    _dataProvider.getAllAlbums();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            macOS: initializationSettingsMacOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    FirebaseMessaging.instance.subscribeToTopic('all');
    FirebaseMessaging.instance.getToken().then((token) => print(token));

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
    );
    FlutterLocalNotificationsPlugin flutterLocNotiPlug =
        FlutterLocalNotificationsPlugin();

    flutterLocNotiPlug
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'foreground_notification_channel_id',
                'Foreground Notifications',
                channelDescription: 'Foreground Notifications Description',
                channelShowBadge: true,
                importance: Importance.max,
                priority: Priority.high,
                onlyAlertOnce: true,
                enableVibration: true,
                enableLights: true,
              ),
            ));
      }
    });

    super.initState();
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
        ),
        ChangeNotifierProvider.value(
          value: _getAndPostProvider,
        )
      ],
      child: GetMaterialApp(
        title: _packageInfo.appName,
        debugShowCheckedModeBanner: false,
        theme: Theme.of(context).copyWith(
          textTheme: GoogleFonts.ubuntuTextTheme(),
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Color.fromARGB(255, 96, 49, 3),
              ),
        ),
        home: AnimatedSplashScreen(),
      ),
    );
  }
}
