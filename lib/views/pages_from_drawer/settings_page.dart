import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  // _registerOnFirebase() {
  //   FirebaseMessaging.instance.subscribeToTopic('all');
  //   FirebaseMessaging.instance.getToken().then((token) => print(token));
  // }

  // void getMessage() {
  //   _firebaseMessaging.configure(
  //       onMessage: (Map<String, dynamic> message) async {},
  //       onResume: (Map<String, dynamic> message) async {},
  //       onLaunch: (Map<String, dynamic> message) async {});
  // }

  String? mtoken = " ";

  void getToken() async {
    print('The Token is: ' + mtoken.toString());
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
    });
    print('The Token is: ' + mtoken.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              getToken();
            },
            child: Text('Print Token')),
      ),
    );
  }
}
