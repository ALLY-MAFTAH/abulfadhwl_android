import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/api.dart';
import 'package:abulfadhwl_android/views/other_pages/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  FocusNode _fullNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _messageFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
            color: Colors.deepPurple[800],
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return Home();
            }));
          },
        ),
        title: Text(
          'Wasiliana Nasi',
          style: TextStyle(color: Colors.deepPurple[800]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(10)),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Ukamilifu ni wa Allah ﷻ pekee, nasi ni wadhaifu mno, wingi wa kukosea, tuliojawa na kila aina ya mapungufu. Kwa lolote katika makosa na mapungufu yaliyopatikana katika Application hii, ukiwa kama mpenda kheri na mwenye kutaka kuisukuma da\'wah hii mbele, basi usisite kutukosoa na kutuelekeza pale penye na mapungufu kwa lengo la kurekebisha.\n\nUngana nasi kupitia mitandao ya kijamii kwa link hizi:',
                      style: TextStyle(color: Colors.deepPurple[800]),
                      textAlign: TextAlign.justify,
                    ),
                  )
                ]),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                return _dataObject.links.isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: InkWell(
                          child: Row(
                            children: <Widget>[
                              Card(
                                elevation: 8,
                                color: Colors.orange,
                                margin: EdgeInsets.all(3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImageWithRetry(api +
                                        'link/icon/' +
                                        _dataObject.links[index].id
                                            .toString()),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(_dataObject.links[index].title,
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                            ],
                          ),
                          onTap: () {
                            String linkUrl = _dataObject.links[index].url;
                            _launchURL(linkUrl);
                          },
                        ),
                      );
              }, childCount: _dataObject.links.length)),
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Text(
                              "Vilevile unaweza kututumia ujumbe wa maandishi kupitia fomu hii:\nNB: Hii si sehemu kwa ajili ya maswali ya kielimu.",
                              style: TextStyle(color: Colors.deepPurple[800])),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            focusNode: _fullNameFocusNode,
                            controller: _fullNameController,
                            validator: (fullNameValue) {
                              if (fullNameValue!.isEmpty)
                                return "Tafadhali andika jina lako kamili";
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Jina kamili',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            focusNode: _emailFocusNode,
                            controller: _emailController,
                            validator: (emailValue) {
                              if (emailValue!.isEmpty)
                                return "Tafadhali ingiza barua pepe yako";
                              else
                              if (!RegExp(
                                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(emailValue)) {
                                return 'Hii barua pepe si sahihi';
                              } else
                                return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Barua pepe',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            maxLines: 5,
                            maxLength: 500,
                            focusNode: _messageFocusNode,
                            controller: _messageController,
                            validator: (messageValue) {
                              if (messageValue!.isEmpty)
                                return "Tafadhali ingiza ujumbe wako";
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Andika ujumbe wako hapa',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FloatingActionButton(
                                elevation: 10,
                                backgroundColor: Colors.orange[700],
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _dataObject
                                        .postComment(
                                            fullName: _fullNameController.text,
                                            email: _emailController.text,
                                            message: _messageController.text)
                                        .then((value) {
                                      if (value != "") {
                                        _scaffoldKey.currentState!
                                            // ignore: deprecated_member_use
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Ujumbe wako umefanikiwa kutumwa"),
                                        ));
                                        _fullNameController.clear();
                                        _messageController.clear();
                                        _emailController.clear();
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
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            "Kwa faida mbalimbali za kielimu, pia unaweza kutembelea kurasa na applications zetu nyingine kupitia links hizi:",
                            style: TextStyle(color: Colors.deepPurple),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Divider(),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                        //   child: _dataObject.links.isEmpty
                        //       ? Container()
                        //       : Row(
                        //           children: <Widget>[
                        //             Expanded(
                        //               child: FlatButton(
                        //                 child: Column(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.center,
                        //                   children: <Widget>[
                        //                     CircleAvatar(
                        //                       backgroundImage:
                        //                           NetworkImageWithRetry(
                        //                               api + 'link/icon/1'),
                        //                     ),
                        //                     Text(
                        //                       _dataObject.links[1].title,
                        //                       style: TextStyle(
                        //                           color: Colors.deepPurple[800],
                        //                           fontSize: 8),
                        //                       textAlign: TextAlign.center,
                        //                     )
                        //                   ],
                        //                 ),
                        //                 onPressed: () {
                        //                   String linkUrl =
                        //                       _dataObject.links[1].url;
                        //                   _launchURL(linkUrl);
                        //                 },
                        //               ),
                        //             ),
                        //             Expanded(
                        //               child: FlatButton(
                        //                 child: Column(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.center,
                        //                   children: <Widget>[
                        //                     CircleAvatar(
                        //                       backgroundImage:
                        //                           NetworkImageWithRetry(
                        //                               api + 'link/icon/1'),
                        //                     ),
                        //                     Text(
                        //                       _dataObject.links[1].title,
                        //                       style: TextStyle(
                        //                           color: Colors.deepPurple[800],
                        //                           fontSize: 8),
                        //                       textAlign: TextAlign.center,
                        //                     )
                        //                   ],
                        //                 ),
                        //                 onPressed: () {
                        //                   String linkUrl =
                        //                       _dataObject.links[1].url;
                        //                   _launchURL(linkUrl);
                        //                 },
                        //               ),
                        //             ),
                        //             Expanded(
                        //               child: FlatButton(
                        //                 child: Column(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.center,
                        //                   children: <Widget>[
                        //                     CircleAvatar(
                        //                       backgroundImage:
                        //                           NetworkImageWithRetry(
                        //                               api + 'link/icon/1'),
                        //                     ),
                        //                     Text(
                        //                       _dataObject.links[1].title,
                        //                       style: TextStyle(
                        //                           color: Colors.deepPurple[800],
                        //                           fontSize: 8),
                        //                       textAlign: TextAlign.center,
                        //                     )
                        //                   ],
                        //                 ),
                        //                 onPressed: () {
                        //                   String linkUrl =
                        //                       _dataObject.links[1].url;
                        //                   _launchURL(linkUrl);
                        //                 },
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        // ),
                      ],
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ******************** Methods for Linking buttons to Social Networks  *********************************

  _launchURL(linkUrl) async {
    // const url = linkUrl;
    if (await canLaunch(linkUrl)) {
      await launch(linkUrl);
    } else {
      throw 'Could not launch $linkUrl';
    }
  }
}
