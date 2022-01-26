import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:abulfadhwl_android/views/other_pages/oval_right_border_cliper.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/about_us_page.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/announcements_page.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/contact_us_page.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/live_duruus_and_timetable_page.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/questions_and_answers.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _dataProvider = Provider.of<DataProvider>(context);
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
                    "قاسم ابن مفوتا بن قاسم",
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
                          announcementDetails: _dataProvider.announcements,
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
                        return ContactUs(
                          dataProvider: _dataProvider,
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
