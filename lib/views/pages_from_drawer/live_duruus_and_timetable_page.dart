// import 'package:flutter/material.dart';
// import 'package:flutter_image/network.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:abulfadhwl/api.dart';
// import 'package:abulfadhwl/providers/data_provider.dart';
// import 'package:abulfadhwl/views/other_pages/home_page.dart';
// import 'package:radio_player/radio_player.dart';

// class LiveDuruusAndTimetablePage extends StatefulWidget {
//   @override
//   _LiveDuruusAndTimetablePageState createState() =>
//       _LiveDuruusAndTimetablePageState();
// }

// class _LiveDuruusAndTimetablePageState
//     extends State<LiveDuruusAndTimetablePage> {
//   RadioPlayer _radioPlayer = RadioPlayer();
//   bool isPlaying = false;
//   List<String>? metadata;
//   @override
//   void initState() {
//     initRadioPlayer();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _dataObject = Provider.of<DataProvider>(context);

//     return Scaffold(
//       backgroundColor: Colors.orange[50],
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.deepPurple[800],
//           ),
//           onPressed: () {
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
//               return Home();
//             }));

//             // FlutterRadio.stop();
//           },
//         ),
//         title: Text(
//           'Live Duruus na Ratiba',
//           style: TextStyle(color: Colors.deepPurple[800]),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               height: 10,
//             ),
//             Container(
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(
//                     height: 20,
//                   ),
//                   _dataObject.streams[0].title.isEmpty
//                       ? Center(child: CircularProgressIndicator())
//                       : Text(
//                           _dataObject.streams[0].title,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               color: Colors.deepPurple[800],
//                               fontWeight: FontWeight.bold),
//                         ),
//                   Text(
//                     _dataObject.streams[0].description,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.deepPurple[800],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     height: 85,
//                     width: 85,
//                     decoration: BoxDecoration(
//                         color: Colors.orange[100],
//                         borderRadius: BorderRadius.circular(42.5)),
//                     child: InkWell(
//                       onTap: () {
//                         setState(() {
//                           _radioPlayer.setMediaItem(
//                               _dataObject.streams[0].title,
//                               _dataObject.streams[0].url,
//                               api +
//                                   'stream/timetable/' +
//                                   _dataObject.streams[0].id.toString());
//                           isPlaying
//                               ? _radioPlayer.pause()
//                               : _radioPlayer.play();
//                         });
//                       },
//                       child: Icon(
//                         isPlaying
//                             ? Icons.pause_rounded
//                             : Icons.play_arrow_rounded,
//                         color: Colors.orange[800],
//                         size: 80,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 30, top: 15, right: 30),
//                 child: CircleAvatar(
//                   radius: MediaQuery.of(context).size.width * 3 / 8,
//                   backgroundColor: Colors.orange[100]!.withOpacity(0.5),
//                   child: Image(
//                     image: AssetImage("assets/icons/live.png"),
//                     color: Colors.orange,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Text(
//               "RATIBA YA DARSA ZA  'AAM",
//               style: TextStyle(
//                   color: Colors.deepPurple[800],
//                   fontWeight: FontWeight.bold,
//                   decoration: TextDecoration.underline),
//               textAlign: TextAlign.center,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: Container(
//                 child: Image(
//                     image: NetworkImageWithRetry(api +
//                         'stream/timetable/' +
//                         _dataObject.streams[0].id.toString())),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void initRadioPlayer() {
//     _radioPlayer.stateStream.listen((value) {
//       setState(() {
//         isPlaying = value;
//       });
//     });
//     _radioPlayer.metadataStream.listen((value) {
//       setState(() {
//         metadata = value;
//       });
//     });
//   }
// }
