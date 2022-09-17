import 'dart:convert';
import 'package:abulfadhwl_android/models/album.dart';
import 'package:abulfadhwl_android/models/song.dart';
import 'package:abulfadhwl_android/models/song_category.dart';
import 'package:flutter/material.dart';
import 'package:abulfadhwl_android/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:abulfadhwl_android/models/announcement.dart';
import 'package:abulfadhwl_android/models/answered_question.dart';
import 'package:abulfadhwl_android/models/question.dart';
import 'package:abulfadhwl_android/models/article.dart';
import 'package:abulfadhwl_android/models/book.dart';
import 'package:abulfadhwl_android/models/comment.dart';
import 'package:abulfadhwl_android/models/history.dart';
import 'package:abulfadhwl_android/models/link.dart';
import 'package:abulfadhwl_android/models/slide.dart';
import 'package:abulfadhwl_android/models/stream.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

typedef void OnError(Exception exception);

class DataProvider extends ChangeNotifier {
  List<SongCategory> _categories = [];
  int currentSongIndex = 0;
  Album currentAlbum = Album(id: 0, name: "", description: "", categoryId: 0, songs: []);
  // String currentAlbumName = "";
  List<Song> songs = [];
  List<Song> _audios = [];
  int searchedAudio = 0;

  Song currentSong =
      Song(id: 0, albumId: 0, title: "", size: 0, duration: "", file: "");

  final Dio _dio = Dio();

  String progress = "0";
  String downloadedFile = "";

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }

    return await getApplicationDocumentsDirectory();
  }

  void _onReceiveProgress(int received, int total) async {
    if (total != -1) {
      notifyListeners();
      progress = (received / total * 100).toStringAsFixed(0) + "%";
      await _showProgressNotification(received, total);

      notifyListeners();
      print('$progress');
    }
  }

  Future<void> _startDownload(
      String url, String fileName, String fileTitle, String savePath) async {
    downloadedFile = fileTitle;
    notifyListeners();
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(url, savePath,
          onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
      notifyListeners();
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> _startAlbumDownload(
    String url,
    String fileName,
    String fileTitle,
    String savePath,
  ) async {
    downloadedFile = fileTitle;
    notifyListeners();
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };
    try {
      final response = await _dio.download(url, savePath,
          onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
      notifyListeners();
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> _showProgressNotification(int rec, int tot) async {
    notifyListeners();

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_notification_channel_id',
      'Download Notification',
      channelDescription: 'Download Notification Description',
      channelShowBadge: true,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
      enableVibration: false,
      showProgress: true,
      maxProgress: tot,
      progress: rec,
      color: Colors.orange,
    );
    notifyListeners();
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, downloadedFile, '$progress', platformChannelSpecifics,
        payload: 'none');

    notifyListeners();
  }

  Future<void> download(String url, String fileName, String fileTitle) async {
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await requestPermission();

    if (isPermissionStatusGranted) {
      final savePath = path.join(dir!.path, fileName);
      await _startDownload(url, fileName, fileTitle, savePath);
    } else {
      null;
    }
  }

  Future<void> downloadAlbum(List<Song> albumSongs) async {
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await requestPermission();

    if (isPermissionStatusGranted) {
      for (var albumSong in albumSongs) {
        final savePath = path.join(
          dir!.path,
          albumSong.file,
        );
        await _startAlbumDownload(api + 'song/file/' + albumSong.id.toString(),
            albumSong.file, albumSong.title, savePath);
      }
    } else {
      null;
    }
  }

  requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    return true;
  }

//
//
// ********** ANNOUNCEMENTS DATA ***********
  List<Announcement> _announcements = [];

  List<Announcement> get announcements =>
      List<Announcement>.from(_announcements.reversed);
  set setAnnouncements(List emptyAnnouncements) => _announcements = [];

  Future<void> getAllAnnouncements() async {
    List<Announcement> _fetchedAnnouncements = [];
    try {
      final response = await http.get(Uri.parse(api + 'announcements/'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data['announcements'].forEach(($announcement) {
          final announcementDataSet = Announcement.fromMap($announcement);
          _fetchedAnnouncements.add(announcementDataSet);
        });
        _announcements = _fetchedAnnouncements;
        print(_fetchedAnnouncements);
        print(_fetchedAnnouncements.length);
      }
    } catch (e) {
      print(e);
      print("Mambo yameenda fyongo");
    }
  }
  //
  //
  //

  // ********** QUESTIONS DATA ***********
  Future<String> addQuestion({@required qn}) async {
    String status = "";

    final Question question = Question(qn: qn);

    Map<String, dynamic> data = Question.toMap(question);
    final jsonData = json.encode(data);

    try {
      http.Response response = await http.post(Uri.parse(api + 'question'),
          body: jsonData, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        status = "Question Sent";
      } else {
        print(response.body); // for debbuging response from the post api

        status = "Something went wrong";
      }
    } catch (e) {
      print("something went wrong");
      print(e);
    }

    return status;
  }

  //
  //
  //

  // ********** ANSWERS DATA ***********
  List<Answer> _answers = [];
  // Its getter
  List<Answer> get answers => _answers;
  set setAnswers(List emptyAnswers) => _answers = [];

  Future<void> getAllAnswers() async {
    List<Answer> _fetchedAnswers = [];
    try {
      final response = await http.get(Uri.parse(api + 'answeredQuestions/'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        data['answeredQuestions'].forEach(($answeredQuestion) {
          final dataSet = Answer.fromMap($answeredQuestion);
          _fetchedAnswers.add(dataSet);
        });

        _answers = _fetchedAnswers;
        print(_fetchedAnswers);
        print(_fetchedAnswers.length);
      }
    } catch (e) {
      print('Maswali yaliyojibiwa hayajaja');
      print(e);
    }
  }

  //
  //
  //

  // ********** ARTICLES DATA ***********
  List<Article> _articles = [];
  // Its getter
  List<Article> get articles => _articles;
  set setArticles(List emptyArticles) => _articles = [];

  Future<void> getAllArticles() async {
    List<Article> _fetchedArticles = [];
    try {
      final response = await http.get(Uri.parse(api + 'articles/'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        data['articles'].forEach(($article) {
          final dataSet = Article.fromMap($article);
          _fetchedArticles.add(dataSet);
        });

        _articles = _fetchedArticles;
        print(_fetchedArticles);
        print(_fetchedArticles.length);
      }
    } catch (e) {
      print('Mambo yamejitindinganya');
      print(e);
    }
  }

  //
  //
  //

  // ********** BOOKS DATA ***********
  List<Book> _books = [];

  List<Book> get books => _books;
  set setBooks(List emptyBooks) => _books = [];

  Future<void> getAllBooks() async {
    List<Book> _fetchedBooks = [];
    try {
      final response = await http.get(Uri.parse(api + 'books/'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        data['books'].forEach(($book) {
          final dataSet = Book.fromMap($book);
          _fetchedBooks.add(dataSet);
        });

        _books = _fetchedBooks;
        print(_fetchedBooks);
        print(_fetchedBooks.length);
      }
    } catch (e) {
      print('Mambo yamejitindinganya');
      print(e);
    }
  }

  //
  //
  //

  // ********** HISTORIES DATA ***********
  List<History> _histories = [];
  List<History> get histories => _histories;
  set setHistories(List emptyHistories) => _histories = [];

  Future<void> getAllHistories() async {
    List<History> _fetchedHistories = [];
    try {
      final response = await http.get(Uri.parse(api + 'histories/'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data['histories'].forEach(($history) {
          final historyDataSet = History.fromMap($history);
          _fetchedHistories.add(historyDataSet);
        });
        _histories = _fetchedHistories;
        print(_fetchedHistories);
        print(_fetchedHistories.length);
      }
    } catch (e) {
      print(e);
      print("Histories hazijaja");
    }
  }

  //
  //
  //

  // ********** LINKS DATA ***********
  List<Link> _links = [];

  List<Link> get links => _links;
  set setLInks(List emptyLInks) => _links = [];

  Future<void> getAllLinks() async {
    List<Link> _fetchedLinks = [];
    try {
      final response = await http.get(Uri.parse(api + 'links/'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data['links'].forEach(($link) {
          final linkDataSet = Link.fromMap($link);
          _fetchedLinks.add(linkDataSet);
        });
        _links = _fetchedLinks;
        print(_fetchedLinks);
        print(_fetchedLinks.length);
      }
    } catch (e) {
      print(e);
      print("Mambo yameenda fyongo");
    }
  }

  //
  //
  //

  // ********** SLIDES DATA ***********
  List<Slide> _slides = [];

  List<Slide> get slides => _slides;
  set setSlides(List emptySlides) => _slides = [];

  Future<void> getAllSlides() async {
    List<Slide> _fetchedSlides = [];
    try {
      final response = await http.get(Uri.parse(api + 'slides/'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data['slides'].forEach(($slide) {
          final slideDataSet = Slide.fromMap($slide);
          _fetchedSlides.add(slideDataSet);
        });
        _slides = _fetchedSlides;
        print(_fetchedSlides);
        print(_fetchedSlides.length);
      }
    } catch (e) {
      print(e);
      print("Slides zimegomaaaaaaaaa");
    }
  }

  //
  //
  //

  // ********** STREAMS DATA ***********
  List<Stream> _streams = [];

  List<Stream> get streams => _streams;
  set setStreams(List emptyStreams) => _streams = [];

  Future<void> getAllStreams() async {
    List<Stream> _fetchedStreams = [];
    try {
      final response = await http.get(Uri.parse(api + 'streams/'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data['streams'].forEach(($stream) {
          final streamDataSet = Stream.fromMap($stream);
          _fetchedStreams.add(streamDataSet);
        });
        _streams = _fetchedStreams;
        print(_fetchedStreams);
        print(_fetchedStreams.length);
      }
    } catch (e) {
      print(e);
      print("Mambo yameenda fyongo");
    }
  }

  //
  //
  //

  // ********** COMMENTS DATA ***********
  Future<String> postComment(
      {@required fullName, @required phone, @required message}) async {
    String status = "";

    final Comment comment =
        Comment(phone: phone, fullName: fullName, message: message);

    Map<String, dynamic> data = Comment.toMap(comment);
    final jsonData = json.encode(data);

    try {
      // http.Response response = await http.post(api + 'comment',
      http.Response response = await http.post(Uri.parse(api + 'comment'),
          body: jsonData, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        status = "Comment Sent";
      } else {
        print(response.body); // for debbuging response from the post api

        status = "Something went wrong";
      }
    } catch (e) {
      print("something went wrong");
      print(e);
    }

    return status;
  }
  //
  //
  //

  // ********** AUDIOS DATA ***********
  List<SongCategory> get categories => _categories;
  set setCategories(List emptycategories) => _categories = [];

  Future<void> getAllCategories() async {
    List<SongCategory> _fetchedCategories = [];
    try {
      final response = await http.get(Uri.parse(api + 'categories/'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data['categories'].forEach(($category) {
          final dataSet = SongCategory.fromMap($category);
          _fetchedCategories.add(dataSet);
        });

        _categories = _fetchedCategories;
        print(_categories);
        print(_categories.length);
      }
    } catch (e) {
      print('Mambo yamejitindinganya');
      print(e);
    }
  }

  List<Song> get audios => _audios;
  set setAudios(List emptyaudios) => _audios = [];

  Future<void> getAllSongs() async {
    List<Song> _fetchedAudios = [];
    try {
      final response = await http.get(Uri.parse(api + 'songs/'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data['songs'].forEach(($audio) {
          final dataSet = Song.fromMap($audio);
          _fetchedAudios.add(dataSet);
        });

        _audios = _fetchedAudios;
        print(_audios);
        print(_audios.length);
      }
    } catch (e) {
      print('Mambo yamejitindinganya');
      print(e);
    }
  }

// var request = await HttpClient().getUrl(Uri.parse('https://shop.esys.eu/media/image/6f/8f/af/amlog_transport-berwachung.jpg'));
// var response = await request.close();
// Uint8List bytes = await consolidateHttpClientResponseBytes(response);
// await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');

  //
  // ************** PAGE RELOAD
  Future<void> reloadPage() async {
    getAllAnnouncements();
    getAllAnswers();
    getAllArticles();
    getAllBooks();
    getAllHistories();
    getAllLinks();
    getAllSlides();
    getAllStreams();
    getAllCategories();
    getAllSongs();
    notifyListeners();
  }
}
