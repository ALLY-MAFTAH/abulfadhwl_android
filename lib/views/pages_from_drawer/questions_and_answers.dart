// ignore_for_file: unnecessary_null_comparison, import_of_legacy_library_into_null_safe

import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/home_page.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:sweetalert/sweetalert.dart';

class QuestionsAndAnswers extends StatefulWidget {
  @override
  _QuestionsAndAnswersState createState() => _QuestionsAndAnswersState();
}

class _QuestionsAndAnswersState extends State<QuestionsAndAnswers> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _qnsFocusNode = FocusNode();
  TextEditingController _qnsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _dataObject = Provider.of<DataProvider>(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 25,
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) {
                return Home();
              }));
            },
          ),
          title: Text(
            'Maswali na Majibu',
            style: TextStyle(),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _dataObject.reloadPage,
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate([
                  Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: Card(
                            color: Colors.orange[50],
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      focusNode: _qnsFocusNode,
                                      controller: _qnsController,
                                      validator: (questionValue) {
                                        if (questionValue!.isEmpty)
                                          return "'Afwan, hujaandika swali lolote";
                                        else
                                          return null;
                                      },
                                      maxLines: 8,
                                      decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: 'Andika Swali Hapa',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        FloatingActionButton(
                                          elevation: 8,
                                          backgroundColor: Colors.orange,
                                          child: Icon(
                                            Icons.send,
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              SweetAlert.show(context,
                                                  subtitle:
                                                      "Uko tayari kutuma hili swali?",
                                                  style:
                                                      SweetAlertStyle.confirm,
                                                  showCancelButton: true,
                                                  confirmButtonColor:
                                                      Colors.orange,
                                                  confirmButtonText: "Ndio",
                                                  cancelButtonColor:
                                                      Colors.grey,
                                                  cancelButtonText: "Hapana",
                                                  onPress: (bool isConfirm) {
                                                if (isConfirm) {
                                                  SweetAlert.show(context,
                                                      subtitle:
                                                          "Kuwa na subra swali linatumwa ...",
                                                      style: SweetAlertStyle
                                                          .loading);
                                                  new Future.delayed(
                                                      new Duration(seconds: 3),
                                                      () {
                                                    _dataObject
                                                        .addQuestion(
                                                      qn: _qnsController.text,
                                                    )
                                                        .then((value) {
                                                      if (value != "") {
                                                        SweetAlert.show(context,
                                                            confirmButtonColor:
                                                                Colors.orange,
                                                            confirmButtonText:
                                                                "Sawa",
                                                            subtitle:
                                                                "Swali limefanikiwa kutumwa",
                                                            style:
                                                                SweetAlertStyle
                                                                    .success);
                                                        _qnsController.clear();
                                                        _qnsController
                                                            .clearComposing();
                                                      } else {
                                                        SweetAlert.show(context,
                                                            confirmButtonColor:
                                                                Colors.orange,
                                                            confirmButtonText:
                                                                "Sawa",
                                                            subtitle:
                                                                "'Afwan, Swali halijafanikiwa kutumwa!",
                                                            style:
                                                                SweetAlertStyle
                                                                    .error);
                                                      }
                                                    });
                                                  });
                                                } else {
                                                  SweetAlert.show(context,
                                                      confirmButtonColor:
                                                          Colors.orange,
                                                      confirmButtonText: "Sawa",
                                                      subtitle:
                                                          "Swali halijatumwa!",
                                                      style: SweetAlertStyle
                                                          .error);
                                                }
                                                return false;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                    ],
                  )
                ])),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  int qnsNumber = 1 + index;
                  final _assetsAudioPlayer = AssetsAudioPlayer();
                  return Padding(
                      padding:
                          const EdgeInsets.only(left: 5, top: 10, right: 5),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 35, right: 5),
                              child: Card(
                                elevation: 8,
                                color: Colors.orange[50],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Swali: ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SelectableText(
                                        _dataObject.answers[index].qn,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                      ExpansionTile(
                                        title: Text(
                                          'Jibu: ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        children: <Widget>[
                                          Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              padding: EdgeInsets.all(5),
                                              child: _dataObject.answers[index]
                                                          .audioAns ==
                                                      null
                                                  ? SelectableText(
                                                      _dataObject.answers[index]
                                                          .textAns,
                                                      textAlign:
                                                          TextAlign.justify,
                                                    )
                                                  : PlayerBuilder.isPlaying(
                                                      player:
                                                          _assetsAudioPlayer,
                                                      builder:
                                                          (context, isPlaying) {
                                                        return FloatingActionButton(
                                                          child: Icon(
                                                            isPlaying
                                                                ? Icons.pause
                                                                : Icons
                                                                    .play_arrow,
                                                            size: 50,
                                                            color: Colors.black,
                                                          ),
                                                          onPressed: () async {
                                                            try {
                                                              await isPlaying
                                                                  ? _assetsAudioPlayer
                                                                      .pause()
                                                                  : _assetsAudioPlayer
                                                                      .open(
                                                                      Audio.network(api +
                                                                          'answer/audioAns/' +
                                                                          _dataObject
                                                                              .answers[index]
                                                                              .id
                                                                              .toString()),
                                                                    );
                                                            } catch (t) {}
                                                          },
                                                        );
                                                      }))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.5),
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15))),
                            ),
                          ),
                          CircleAvatar(
                            radius: 17,
                            backgroundColor: Colors.black,
                            child: Text(
                              qnsNumber.toString(),
                              style: TextStyle(
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ));
                }, childCount: _dataObject.answers.length))
              ]),
        ));
  }
}
