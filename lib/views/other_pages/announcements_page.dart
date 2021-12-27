import 'package:abulfadhwl_android/models/announcement.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Announcements extends StatelessWidget {
  final List<Announcement> announcementDetails;

  const Announcements({Key? key, required this.announcementDetails})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Matangazo na Matukio',
            style: TextStyle(),
          ),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(10),
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
                                      "${announcementDetails[index].date.day}/${announcementDetails[index].date.month}/${announcementDetails[index].date.year}",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Imetolewa: " +
                                      "${announcementDetails[index].date.day}/${announcementDetails[index].date.month}/${announcementDetails[index].date.year}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                    ),
                    Text(
                      announcementDetails[index].news,
                      style: index == 0
                          ? TextStyle(fontWeight: FontWeight.bold)
                          : TextStyle(),
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
