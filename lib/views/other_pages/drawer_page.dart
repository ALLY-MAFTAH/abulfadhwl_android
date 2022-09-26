import 'package:abulfadhwl_android/providers/get_and_post_provider.dart';
import 'package:abulfadhwl_android/views/other_pages/oval_right_border_cliper.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/about_us_page.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/announcements_page.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/contact_us_page.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/live_duruus_and_timetable_page.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/questions_and_answers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages_from_drawer/settings_page.dart';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _getAndPostProvider = Provider.of<GetAndPostProvider>(context);
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.orange)]),
          width: 320,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 170,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/images/ALLY W  008.png')),
                    ),
                  ),
                  Text(
                    " الشيخ قاسم ابن مفوتا بن قاسم",
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " حفـظه اللـه ورعـاه ووفقـه وبارك فيه وفي علمه",
                    style: TextStyle(fontSize: 13.0),
                  ),
                  SizedBox(height: 25.0),
                  Divider(),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.radio,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Darsa Mubaashara",
                          style: TextStyle(),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return LiveDuruusAndTimetablePage();
                      }));
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.live_help,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Maswali & Majibu",
                          style: TextStyle(),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return QuestionsAndAnswers();
                      }));
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.announcement,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Matangazo na Matukio",
                          style: TextStyle(),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return Announcements(
                          announcementDetails: _getAndPostProvider.announcements,
                        );
                      }));
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.info,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Kuhusu Sisi",
                          style: TextStyle(),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return AboutUs();
                      }));
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.contacts,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Wasiliana Nasi",
                          style: TextStyle(),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return ContactUs(getAndPostProvider: _getAndPostProvider,
                        );
                      }));
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.settings,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Mipangilio",
                          style: TextStyle(),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return Settings();
                      }));
                    },
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
