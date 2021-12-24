import 'package:abulfadhwl_android/models/announcement.dart';
import 'package:flutter/material.dart';

class Announcements extends StatelessWidget {
  final List<Announcement> announcementDetails;

  const Announcements({ Key? key, required this.announcementDetails})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.deepPurple[800],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Matangazo na Matukio',
            style: TextStyle(color: Colors.deepPurple[800]),
          ),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: index == 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image(
                                  width: 30,
                                  height: 15,
                                  image: AssetImage("assets/icons/new.png"),
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  "Imetolewa: " +
                                      announcementDetails[index].date,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                )
                              ],
                            )
                          : Container(),
                    ),
                    Text(
                      announcementDetails[index].news,
                      style: index == 0
                          ? TextStyle(
                              color: Colors.deepPurple[800],
                              fontWeight: FontWeight.bold)
                          : TextStyle(color: Colors.deepPurple[900]),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: announcementDetails.length,
        ));
  }
}
