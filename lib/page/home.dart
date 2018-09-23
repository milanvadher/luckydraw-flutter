import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:learn/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiService appAuth = new ApiService();

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HomePageState();
  }
}

class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(url, forceWebView: true);
              });
}

class _HomePageState extends State<HomePage> {
  List _answer = ['A', 'N', 'S', 'W', 'E', 'R', 'A', 'N', 'S', 'W', 'E', 'R'];
  List _imagesRow1 = [1, 2];
  List _imagesRow2 = [1, 2];

  List choise = [
    [Icons.monetization_on, 'Coupons'],
    [Icons.flag, 'Winners'],
    [Icons.person, 'Profile'],
    [Icons.details, 'About us'],
    [Icons.share, 'Share']
  ];

  _HomePageState() {
    // _getQuestionDetails();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Lucky Draw JJ-111'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: _actionChoise,
            itemBuilder: (BuildContext context) {
              return choise.map((item) {
                return PopupMenuItem(
                  value: item[1],
                  child: Row(
                    children: <Widget>[
                      Icon(
                        item[0],
                      ),
                      Text('  ' + item[1], textAlign: TextAlign.end)
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: _imagesRow1
                  .map(
                    (image) => Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/demo.JPG',
                            ),
                          ),
                        ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: _imagesRow2
                  .map(
                    (image) => Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/demo.JPG',
                            ),
                          ),
                        ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 15.0),
          Wrap(
            spacing: 0.0,
            alignment: WrapAlignment.center,
            children: _answer
                .map((element) => new MaterialButton(
                      onPressed: () {},
                      padding: EdgeInsets.all(0.0),
                      minWidth: 40.0,
                      height: 40.0,
                      color: Colors.blueGrey,
                      child: Text(element),
                    ))
                .toList(),
          ),
          SizedBox(height: 15.0),
          RaisedButton(
            onPressed: () {
              _logOut();
            },
            child: Text('LogOut'),
          )
        ],
      ),
    );
  }

  Future _getQuestionDetails() async {
    print('In quesion details');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userData = json.decode(prefs.getString('userData'));
    print(userData['questionState']);
    var data = {
      // 'questionState': 75,
      'contactNumber': userData['contactNumber']
    };
    appAuth.qustionDetails(data).then((res) {
      print(res.body);
      if (res.statusCode == 200) {
        print(res.body);
      } else {
        // _showError();
      }
    });
  }

  void _logOut() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((onValue) {
      onValue.remove('userData');
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  void _actionChoise(choise) {
    if (choise == 'Coupons') {
      Navigator.pushNamed(context, '/coupons');
    }
    if (choise == 'Winners') {
      Navigator.pushNamed(context, '/winners');
    }
    if (choise == 'Profile') {
      Navigator.pushNamed(context, '/profile');
    }
    if (choise == 'About us') {
      _aboutDialog(context);
    }
    if (choise == 'Share') {
      _shareApp();
    }
  }

  void _aboutDialog(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.body2;
    final TextStyle linkStyle =
        themeData.textTheme.body2.copyWith(color: themeData.accentColor);

    return showAboutDialog(
      context: context,
      applicationName: 'Lucky Draw',
      applicationVersion: 'Win coupons for JJ-111',
      applicationIcon: Image.asset(
        'assets/logo.png',
        height: 50.0,
      ),
      applicationLegalese: '© 2018 GNC Bhaio.',
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    style: aboutTextStyle,
                    text:
                        'Dadashri\'s JanmaJayanti Celebrations are happening from 15th Nov to 25th November 2018 @ Adalaj Trimandir. To know more about our event visit '),
                _LinkTextSpan(
                    style: linkStyle,
                    url: 'http://jjd.dadabhagwan.org/',
                    // text: 'Jova Jevi Duniya.'
                    ),
                TextSpan(
                  style: aboutTextStyle,
                  text:
                      '\n\nThere will be 3 Lucky Draws everyday during this period.',
                ),
                TextSpan(
                  style: aboutTextStyle,
                  text:
                      '\nWin Lucky Draw Coupons by answering the puzzles. Once you win the coupons, assign them to the draws.',
                ),
                TextSpan(
                  style: aboutTextStyle,
                  text:
                      '\nAll the best to you\'ll. May the best Puzzelier win.',
                ),
                TextSpan(
                  style: aboutTextStyle,
                  text: '\n\nRegards,\nLucky Draw Team',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _shareApp() {}
}
