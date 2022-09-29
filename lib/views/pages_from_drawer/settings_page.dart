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
import 'dart:io';

import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/api.dart';
import '../../providers/data_provider.dart';
import 'package:path/path.dart' as path;

class Settings extends StatefulWidget {
  final DataProvider dataProvider;

  const Settings({Key? key, required this.dataProvider}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String filePath = "";
  // "/storage/emulated/0/11. Dhimma ya Wazazi Juu ya Malezi ya Watoto - 11.mp3";
  final newArtwork = "assets/icons/app_icon.png";
  late Widget result;
  Audiotagger tagger = new Audiotagger();

  @override
  void initState() {
    reaaaad();
    setState(() {
      result = Text("Ready..");
    });
    super.initState();
  }

  Future<void> reaaaad() async {
    final dir = await _getDownloadDirectory();
    // final isPermissionStatusGranted = await _checkPermissions();

    // if (isPermissionStatusGranted) {
    filePath = path.join(dir!.path, widget.dataProvider.currentSong.file);
    // await _startDownload(url, fileName, fileTitle, savePath);
    // } else {
    //   null;
    // }
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }

    return await getApplicationDocumentsDirectory();
  }


  Future writeTags() async {
    Tag tags = Tag(
      title: "تلاص هبتنيب نتيب نتىبيب ",
      trackNumber: "",
      artist: "Sheikh Abul Fadhwl Qassim Mafuta Qassim حفظه الله",
      album: "A fake album",
      year: "2020",
      // artwork: newArtwork,
    );

    final output = await tagger.writeTags(
      path: filePath,
      tag: tags,
    );

    setState(() {
      result = Text(output.toString());
    });
  }

  Future readTags() async {
    print(11);
    print(22);
    print(23);
    print(filePath);
    print("widget.dataProvider.currentSong.file");
    print(api + 'song/file/' + widget.dataProvider.currentSong.id.toString());
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
                  await readTags();
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
                  await writeTags();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
