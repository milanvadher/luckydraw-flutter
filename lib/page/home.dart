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
  
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit an App'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    textColor: Colors.red,
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  // bool _twoWords;
  // List _secondWord = [];
  List _answer = [];
  String _checkAnswer;
  int _points;
  int _questionState;
  String _contactNumber;

  List _randomString = [];
  List _imagesRow1 = [];
  List _imagesRow2 = [];

  List choise = [
    [Icons.monetization_on, 'Coupons'],
    [Icons.flag, 'Winners'],
    [Icons.person, 'Profile'],
    [Icons.details, 'About us'],
    [Icons.share, 'Share'],
    [Icons.exit_to_app, 'Logout']
  ];

  _HomePageState() {
    SharedPreferences.getInstance().then((onValue) {
      Map<String, dynamic> userData =
          json.decode(onValue.getString('userData'));
      print(userData);
      _questionState = int.parse(userData['questionState'].toString());
      _points = int.parse(userData['points'].toString());
      _contactNumber = userData['contactNumber'];
      this._getQuestionDetails();
      print(_points);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
          body: ListView(
            children: <Widget>[
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: _imagesRow1
                          .map(
                            (image) => Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(4.0),
                                    child: Image.network(
                                      image,
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
                                    child: Image.network(
                                      image,
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
                              onPressed: () {
                                _backToAns(element);
                              },
                              textColor: Colors.white,
                              padding: EdgeInsets.all(0.0),
                              minWidth: 40.0,
                              height: 40.0,
                              color: Colors.blueGrey,
                              child: Text(element.toString().toUpperCase()),
                            ))
                        .toList(),
                  ),
                  // Wrap(
                  //   spacing: 0.0,
                  //   alignment: WrapAlignment.center,
                  //   children: _secondWord
                  //       .map((element) => new MaterialButton(
                  //             onPressed: () {},
                  //             padding: EdgeInsets.all(0.0),
                  //             minWidth: 40.0,
                  //             height: 40.0,
                  //             color: Colors.blueGrey,
                  //             child: Text(element.toString().toUpperCase()),
                  //           ))
                  //       .toList(),
                  // ),
                  SizedBox(height: 15.0),
                  Wrap(
                    spacing: 0.0,
                    alignment: WrapAlignment.center,
                    children: _randomString
                        .map((element) => new MaterialButton(
                              onPressed: () {
                                _pushToAns(element.toString());
                              },
                              padding: EdgeInsets.all(0.0),
                              minWidth: 40.0,
                              height: 40.0,
                              color: Colors.amber,
                              child: Text(element.toString().toUpperCase()),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  _getQuestionDetails() async {
    var data = {
      'questionState': _questionState.toString(),
    };
    appAuth.qustionDetails(data).then((res) {
      setState(() {
        if (res.statusCode == 200) {
          Map<String, dynamic> qustionDetails = json.decode(res.body);
          _imagesRow1.add(qustionDetails['imageList'][0]);
          _imagesRow1.add(qustionDetails['imageList'][1]);
          _imagesRow2.add(qustionDetails['imageList'][2]);
          _imagesRow2.add(qustionDetails['imageList'][3]);
          _checkAnswer = qustionDetails['answer'];
          for (var i = 0; i < qustionDetails['answer'].toString().length; i++) {
            if (qustionDetails['answer'][i] == ' ') {
              // _twoWords = true;
              // secondWord(qustionDetails['answer'].toString());
              break;
            } else {
              _answer.add(' ');
            }
          }
          for (var i = 0;
              i < qustionDetails['randomString'].toString().length;
              i++) {
            _randomString.add(qustionDetails['randomString'][i]);
          }
          print(qustionDetails);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext build) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Check your Internet connection'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        }
      });
    });
  }

  void _pushToAns(rchar) {
    setState(() {
      for (var i = 0; i < _answer.length; i++) {
        if (_answer[i] == ' ') {
          _answer[i] = rchar;
          print(i.toString() + ' ' + _answer.length.toString());
          if (_answer.length - 1 == i) {
            _checkAns();
          }
          break;
        }
      }
    });
  }

  void _backToAns(rchar) {
    // setState(() {
    //   for (var i = 0; i < count; i++) {

    //   }
    // });
  }

  void _checkAns() {
    print(_answer.join() + ' ' + _checkAnswer.split(' ')[0]);
    if (_checkAnswer.split(' ')[0].toLowerCase() ==
        _answer.join().toLowerCase()) {
      print('Correct');
      if (_questionState % 5 == 0) {
        _generateTicket();
      }
      _questionState = _questionState + 1;
      _points = _points + 100;
      _answer = [];
      _randomString = [];
      _imagesRow1 = [];
      _imagesRow2 = [];
      _getQuestionDetails();
      showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: Text('Correct'),
            content: Text('Congo! Your Answer is correct.\nYou got 100 coins.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
      var data = {
        'contactNumber': _contactNumber.toString(),
        'questionState': _questionState.toString(),
        'points': _points.toString()
      };
      appAuth.saveUserData(data).then((res) {
        if (res.statusCode == 200) {
          print('****************************************');
          print(res.body);
          SharedPreferences.getInstance().then((onValue) {
            onValue.setString('userData', res.body);
          });
        } else {
          setState(() {
            _answer = [];
            for (var i = 0; i < _checkAnswer.length; i++) {
              if (_checkAnswer[i] == ' ') {
                // _twoWords = true;
                // secondWord(qustionDetails['answer'].toString());
                break;
              } else {
                _answer.add(' ');
              }
            }
          });
          showDialog(
            context: context,
            builder: (BuildContext build) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Your Internet is not working.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('okay'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        }
      });
    } else {
      setState(() {
        _answer = [];
        for (var i = 0; i < _checkAnswer.length; i++) {
          if (_checkAnswer[i] == ' ') {
            // _twoWords = true;
            // secondWord(qustionDetails['answer'].toString());
            break;
          } else {
            _answer.add(' ');
          }
        }
      });
      print('Incorrect');
      showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: Text('Oops'),
            content: Text('Your Answer is Incorrect.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Try Again'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
  }

  // void secondWord(word) {
  //   var d = word.split(' ');
  //   for (var i = 0; i < d[2].length; i++) {
  //     _secondWord.add(d[2][i]);
  //   }
  // }

  void _generateTicket() {
    var data = {
      'contactNumber': _contactNumber,
      'questionState': _questionState.toString()
    };
    appAuth.generateTicket(data).then((res) {
      if (res.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext build) {
            return AlertDialog(
              title: Text('Congratulation'),
              content: Text('You got one Lucky draw Coupon.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext build) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Check your Internet connection'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
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
      // Navigator.push(context, MaterialPageRoute(
      //   builder: (context) => ProfilePage(_questionState, _points, _userName, _contactNumber)
      // ));
      Navigator.pushNamed(context, '/profile');
    }
    if (choise == 'About us') {
      _aboutDialog(context);
    }
    if (choise == 'Share') {
      _shareApp();
    }
    if (choise == 'Logout') {
      _logOut();
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
