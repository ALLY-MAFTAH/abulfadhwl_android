// import 'package:flutter/material.dart';

// class Settings extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return DecoratedBox(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Image.network(
//         'https://flutter.github.io/assets-for-api-docs/assets/widgets/falcon.jpg',
//         loadingBuilder: (BuildContext context, Widget child,
//             ImageChunkEvent? loadingProgress) {
//           if (loadingProgress == null) {
//             return child;
//           }
//           return Center(
//             child: CircularProgressIndicator(
//               value: loadingProgress.expectedTotalBytes != null
//                   ? loadingProgress.cumulativeBytesLoaded /
//                       loadingProgress.expectedTotalBytes!
//                   : null,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final filePath =
      "/storage/emulated/0/11. Dhimma ya Wazazi Juu ya Malezi ya Watoto - 11.mp3";
  // final artwork = "/sdcard/cover.jpg";
  late Widget result;
  Audiotagger tagger = new Audiotagger();

  @override
  void initState() {
     setState(() {
      result =  Text("Ready..");
    });
   
    super.initState();
    _checkPermissions();
  }

  Future _checkPermissions() async {
    if (!await Permission.storage.request().isGranted) {
      await _checkPermissions();
    }
  }

  Future _writeTags() async {
    Tag tags = Tag(
      title: "Title of the song",
      artist: "A fake artist",
      album: "A fake album",
      year: "2020",
      // artwork: artwork,
    );

    final output = await tagger.writeTags(
      path: filePath,
      tag: tags,
    );

    setState(() {
      result = Text(output.toString());
    });
  }

  Future _readTags() async {
    final output = await tagger.readTagsAsMap(
      path: filePath,
    );
    setState(() {
      result = Text(jsonEncode(output));
    });
  }

  Future _readArtwork() async {
    final output = await tagger.readArtwork(
      path: filePath,
    );
    setState(() {
      result = output != null ? Image.memory(output) : Text("No artwork found");
    });
  }

  Future _readAudioFile() async {
    final output = await tagger.readAudioFileAsMap(
      path: filePath,
    );
    final json = jsonEncode(output);
    Clipboard.setData(new ClipboardData(text: json));
    setState(() {
      result = Text(json);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Audiotagger example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              result,
              ElevatedButton(
                child: Text("Read tags"),
                onPressed: () async {
                  await _readTags();
                },
              ),
              ElevatedButton(
                child: Text("Read artwork"),
                onPressed: () async {
                  await _readArtwork();
                },
              ),
              ElevatedButton(
                child: Text("Read audio file"),
                onPressed: () async {
                  await _readAudioFile();
                },
              ),
              ElevatedButton(
                child: Text("Write tags"),
                onPressed: () async {
                  await _writeTags();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
