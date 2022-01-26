// ignore_for_file: deprecated_member_use

import 'package:abulfadhwl_android/models/link.dart';
import 'package:abulfadhwl_android/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:provider/provider.dart';
import 'package:abulfadhwl_android/constants/api.dart';
import 'package:abulfadhwl_android/home_page.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  final DataProvider dataProvider;

  const ContactUs({Key? key, required this.dataProvider}) : super(key: key);
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
  List<Link> ourLinks = [];
  List<Link> othersLinks = [];

  @override
  void initState() {
    ourLinks = [];
    othersLinks = [];

    for (var i = 0; i < widget.dataProvider.links.length; i++) {
      if (widget.dataProvider.links[i].type == "Ours") {
        ourLinks.add(widget.dataProvider.links[i]);
      } else {
        othersLinks.add(widget.dataProvider.links[i]);
      }
    }
    print(ourLinks);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _dataObject = Provider.of<DataProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
              return Home();
            }));
          },
        ),
        title: Text(
          'Wasiliana Nasi',
          style: TextStyle(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _dataObject.reloadPage,
        child: Card(
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Ukamilifu ni wa Allah ﷻ pekee, nasi ni wadhaifu mno, wingi wa kukosea, tuliojawa na kila aina ya mapungufu. Kwa lolote katika makosa na mapungufu yaliyopatikana katika Application hii, ukiwa kama mpenda kheri na mwenye kutaka kuisukuma da\'wah hii mbele, basi usisite kutukosoa na kutuelekeza pale penye na mapungufu kwa lengo la kurekebisha.\n\nUngana nasi kupitia mitandao ya kijamii kwa link hizi:',
                        style: TextStyle(),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  ]),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return ourLinks.isEmpty
                      ? Container()
                      : Row(
                          children: [
                            Card(
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.orange[50],
                                      alignment: Alignment.centerLeft),
                                  icon: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImageWithRetry(
                                          api +
                                              'link/icon/' +
                                              ourLinks[index].id.toString()),
                                    ),
                                  ),
                                  label: Text(ourLinks[index].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  onPressed: () {
                                    String linkUrl = ourLinks[index].url;
                                    _launchURL(linkUrl);
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                }, childCount: ourLinks.length)),
                SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                          "Vilevile unaweza kututumia ujumbe wa maandishi kupitia fomu hii:\nNB: Hii si sehemu kwa ajili ya maswali ya kielimu.",
                          style: TextStyle()),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
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
                                  else if (!RegExp(
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
                                    backgroundColor: Colors.orange,
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        SweetAlert.show(context,
                                            subtitle:
                                                "Uko tayari kutuma ujumbe huu?",
                                            style: SweetAlertStyle.confirm,
                                            showCancelButton: true,
                                            confirmButtonColor: Colors.orange,
                                            confirmButtonText: "Ndio",
                                            cancelButtonColor: Colors.grey,
                                            cancelButtonText: "Hapana",
                                            onPress: (bool isConfirm) {
                                          if (isConfirm) {
                                            SweetAlert.show(context,
                                                subtitle:
                                                    "Kuwa na subra ujumbe unatumwa ...",
                                                style: SweetAlertStyle.loading);
                                            new Future.delayed(
                                                new Duration(seconds: 2), () {
                                              _dataObject
                                                  .postComment(
                                                      fullName:
                                                          _fullNameController
                                                              .text,
                                                      email:
                                                          _emailController.text,
                                                      message:
                                                          _messageController
                                                              .text)
                                                  .then((value) {
                                                if (value != "") {
                                                  SweetAlert.show(context,
                                                      confirmButtonColor:
                                                          Colors.orange,
                                                      confirmButtonText: "Sawa",
                                                      subtitle:
                                                          "Ahsante! Ujumbe wako wako tumeupokea",
                                                      style: SweetAlertStyle
                                                          .success);
                                                  _fullNameController.clear();
                                                  _messageController.clear();
                                                  _emailController.clear();
                                                }
                                              });
                                            });
                                          } else {
                                            SweetAlert.show(context,
                                                confirmButtonColor:
                                                    Colors.orange,
                                                confirmButtonText: "Sawa",
                                                subtitle: "Ujumbe haujatumwa!",
                                                style: SweetAlertStyle.error);
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Kwa faida mbalimbali za kielimu, pia unaweza kutembelea kurasa na applications zetu nyingine kupitia links hizi:",
                        style: TextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 1 / 9,
                    child: LayoutBuilder(
                        builder: (context, constraints) => ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int i) {
                                return othersLinks.isEmpty
                                    ? Container()
                                    : Container(
                                        constraints: BoxConstraints(
                                          minWidth: constraints.minWidth /
                                              othersLinks.length,
                                        ),
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                FloatingActionButton(
                                                  child: CircleAvatar(
                                                      radius: 27,
                                                      backgroundImage:
                                                          NetworkImageWithRetry(
                                                              api +
                                                                  'link/icon/' +
                                                                  othersLinks[i]
                                                                      .id
                                                                      .toString())),
                                                  onPressed: () {
                                                    String linkUrl =
                                                        othersLinks[i].url;
                                                    _launchURL(linkUrl);
                                                  },
                                                ),
                                                Text(othersLinks[i].title)
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                              },
                              itemCount: othersLinks.length,
                            )),
                  ),
                ),
              ]),
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
