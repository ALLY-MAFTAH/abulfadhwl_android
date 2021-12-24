
import 'package:abulfadhwl_android/views/other_pages/oval_right_border_cliper.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/about_us_page.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/contact_us_page.dart';
import 'package:abulfadhwl_android/views/pages_from_drawer/questions_and_answers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.orange[50],
              boxShadow: [BoxShadow(color: Colors.orange)]),
          width: 320,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/icons/bismillah.png')),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "قاسم ابن مفوتا بن قاسم",
                    style: TextStyle(color: Colors.deepPurple, fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " حفـظه اللـه ورعـاه ووفقـه وبارك فيه وفي علمه",
                    style: TextStyle(color: Colors.deepPurple, fontSize: 13.0),
                  ),
                  SizedBox(height: 25.0),
                  Divider(),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.broadcastTower,
                          color: Colors.orange[600],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Live Duruus",
                          style: TextStyle(color: Colors.deepPurple[700]),
                        ),
                      ],
                    ),
                    // onTap: () {
                    //   Navigator.push(context, MaterialPageRoute(builder: (_) {
                    //     return LiveDuruusAndTimetablePage();
                    //   }));
                    // },
                  ),
                  Divider(),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.live_help,
                          color: Colors.orange[600],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Maswali & Majibu",
                          style: TextStyle(color: Colors.deepPurple[700]),
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
                          Icons.info,
                          color: Colors.orange[600],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "About Us",
                          style: TextStyle(color: Colors.deepPurple[700]),
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
                          color: Colors.orange[600],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Contact Us",
                          style: TextStyle(color: Colors.deepPurple[700]),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return ContactUs();
                      }));
                    },
                  ),
                  Divider(),
                  // ListTile(
                  //   title: Row(
                  //     children: <Widget>[
                  //       Icon(
                  //         Icons.settings,
                  //         color: Colors.orange[600],
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text(
                  //         "Settings",
                  //         style: TextStyle(color: Colors.deepPurple[700]),
                  //       ),
                  //     ],
                  //   ),
                  //   onTap: () {
                  //     Navigator.push(context, MaterialPageRoute(builder: (_) {
                  //       return Settings();
                  //     }));
                  //   },
                  // ),
                  // Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
