import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';

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
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: Colors.deepPurple[800],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Maswali na Majibu',
            style: TextStyle(
              color: Colors.deepPurple[800],
            ),
          ),
        ),
        body: CustomScrollView(physics: BouncingScrollPhysics(), slivers: <
            Widget>[
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(5),
                      ),
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
                                    return "Tafadhali andika swali lako";
                                  else
                                    return null;
                                },
                                maxLines: 8,
                                decoration: InputDecoration(
                                    labelText: 'Andika Swali Hapa',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
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
                                    backgroundColor: Colors.orange[700],
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _dataObject
                                            .addQuestion(
                                          qn: _qnsController.text,
                                        )
                                            .then((value) {
                                          if (value != "") {
                                            _scaffoldKey.currentState!
                                                // ignore: deprecated_member_use
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Swali lako limefanikiwa kutumwa"),
                                            ));
                                            _qnsController.clear();
                                            _qnsController.clearComposing();
                                          }
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
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text('MASWALI YALIYOJIBIWA',
                    style: TextStyle(
                      color: Colors.deepPurple[800],
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    )),
              ),
            ),
          ])),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            int qnsNumber = 1 + index;
            return Padding(
                padding: const EdgeInsets.only(left: 5, top: 10, right: 5),
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 35, right: 5),
                        child: Card(
                          elevation: 8,
                          color: Colors.orange[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Swali: ',
                                  style: TextStyle(
                                      color: Colors.deepPurple[800],
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SelectableText(
                                  _dataObject.answers[index].qn,
                                  style: TextStyle(
                                    color: Colors.deepPurple[800],
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                ExpansionTile(
                                  title: Text(
                                    'Jibu: ',
                                    style: TextStyle(
                                        color: Colors.deepPurple[800],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange[100],
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: EdgeInsets.all(5),
                                        child: SelectableText(
                                          _dataObject.answers[index].ans,
                                          textAlign: TextAlign.justify,
                                        ))
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
                            color: Colors.orange[300],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15))),
                      ),
                    ),
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.orange[300],
                      child: Text(
                        qnsNumber.toString(),
                        style: TextStyle(
                            fontSize: 10, color: Colors.deepPurple[800]),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ));
          }, childCount: _dataObject.answers.length))
        ]));
  }
}
