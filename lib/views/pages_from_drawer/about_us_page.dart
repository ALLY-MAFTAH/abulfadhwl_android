// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:abulfadhwl_android/home_page.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:share/share.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int _currentYear = DateTime.now().year;
    return Scaffold(
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
          'Kuhusu Sisi',
          style: TextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                elevation: 9,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          'ABUL FADHWL Ni Application iliyotengenezwa na wanafunzi vijana wenye kiu ya kujifundisha, kutendea kazi waliyojifunza na kulingania wengine katika hayo. Imekusanya ndani yake faida mbalimbali za kielimu ya kisheria kutoka kwa Shekh wetu kipenzi Abul Fadhwl Kassim Mafuta Kassim Allah ﷻ amhifadhi, ambaye ni Mudiyr na mwalimu katika Markaz ya Sheikhul Islaam Ibn Taymiyyah iliyoko Pongwe Tanga Tanzania. Vilivyomo humu ni pamoja na vitabu na makala alizoandika, sauti za duruus za vitabu alivyofundisha na anavyoendelea kufundisha, khutba, mihaadhara, nasaha mbalimbali na mengineyo mengi yanayofungamana na uislam kwa ujumla. Vilevile umewekwa humu mukhtasari wa historia ya Shekh Abul Fadhwl hasa katika juhudi zake za kidawah tangu kuanza kwake kusoma hadi kuanza ulinganizi ili kuwapa muongozo wengi katika wanafunzi juu ya njia zipi wapite katika kufanikisha safari yao mubaaraka ya kutafuta elimu ya kisheria na kulingania. Pia wafahamu watu ni hatua zipi dawah ssalafiyyah imepitia hususan katika nchi ya Tanzania mpaka kufikia hivi leo twanufaika na matunda ya jitihada za waliojitolea kipindi cha mwanzo kwa hali na mali huku wakitaraji malipo kwa Allah. Twamuomba Allah ﷻ awasamehe makosa yao wote na ajaalie yote waliyoyatenda yawe katika mizani zao za khayraat baada ya uhai wao. Yaliyomo humu yamejengeka kikamilifu juu ya Qur-aan na Sunnah kwa ufahamu wa waja wema waliotangulia (Maswahabah, na wale wenye kuwafuata wao kwa wema) na kuepukana na kila aina ya ukundi, uzushi, fikra na itikiadi chafu na kila lenye kuenda kinyume na uislamu sahihi aliotuachia Mtume ﷺ. Swalah na Salaam zimwendee Mtume wetu Muhammad ﷺ, ahli zake na Maswahabah zake na kila atakayewafuata wao kwa wema hadi siku ya Mwisho. Kutokana na uwepo wa Shekh mpaka hivi leo na bado anaendelea na shughuli za kidawah, hivyo basi maudhui yaliyomo ndani ya Application hii yatakuwa yakifanyiwa mabadiliko kila baada ya muda fulani. Na mnaombwa radhi kwa kila usumbufu utakaojitokeza. Allah atulipe kila la kheri na atujaalie ni wenye kupata faida kwa yale yapatikanayo humu.  ',
                          textAlign: TextAlign.justify,
                        )),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Text(
                            '** إن الدال على الخير كفاعله **',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Mshirikishe Ndugu Yako Katika Kheri Hii ',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.orange,
                            child: IconButton(
                              color: Colors.black,
                              icon: Icon(Icons.share),
                              onPressed: () {
                                Share.share(
                                  'https://pub.dev/packages/share#-readme-tab-',
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 25,
              child: Marquee(
                text: 'Ndugu Katika Imani Usitusahau Katika Dua Zako  ',
                style: TextStyle(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        color: Colors.orange,
        child: Container(
          height: 53,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.copyright, size: 15),
                  Text(
                      _currentYear.toString() +
                          ' Markaz Shaykhil Islaam Ibn Taymiyyah',
                      style: TextStyle(fontSize: 9)),
                ],
              ),
              Text(
                'Vitu vyote katika Application hii vimehifadhiwa kwa hati miliki ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
