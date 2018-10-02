import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:learn/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';

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
  bool _comeFromHint = false;

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
  bool _isGameOver = true;

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
    if (_isGameOver) {
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
          body: Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.done_all,
                      color: Colors.green,
                      size: 60.0,
                    ),
                    Text(
                      'Congratulations! \n',
                      textScaleFactor: 2.0,
                    ),
                    Text(
                        'You Solved all the questons.\nWait for Next Update.\n'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Lucky Draw JJ-111'),
                  ),
                  Icon(Icons.monetization_on),
                  Text(_points.toString())
                ],
              ),
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
                                child:
                                    Text(element[0].toString().toUpperCase()),
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
                                onPressed: element[1] == true
                                    ? null
                                    : () {
                                        _pushToAns(element);
                                      },
                                padding: EdgeInsets.all(0.0),
                                minWidth: 40.0,
                                height: 40.0,
                                color: Colors.amber,
                                child:
                                    Text(element[0].toString().toUpperCase()),
                              ))
                          .toList(),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
                        child: Row(
                          children: <Widget>[
                            MaterialButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              height: 50.0,
                              minWidth: 50.0,
                              onPressed: () {
                                _getOneHint();
                              },
                              child: Icon(Icons.help),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            MaterialButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              height: 50.0,
                              minWidth: 50.0,
                              onPressed: () {
                                _getFullHint();
                              },
                              child: Icon(Icons.done_all),
                            )
                          ],
                        )),
                  ],
                ),
              ],
            )),
      );
    }
  }

  _getOneHint() {
    if (_points < 50) {
      showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: Text('Oops'),
            content: Text('You do not have enough poins.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
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
            title: Text('Are you sure?'),
            content: Text('Do you wat to spend 50 \$ ?'),
            actions: <Widget>[
              FlatButton(
                textColor: Colors.red,
                child: Text('Yes'),
                onPressed: () {
                  var leftIndices = [];
                  for (var i = 0; i < _answer.length; i++) {
                    if (_answer[i] == ' ') {
                      leftIndices.add(i);
                    }
                  }
                  if (leftIndices.length != 0) {
                    var no = new Random().nextInt(leftIndices.length);
                    setState(() {
                      _answer[leftIndices[no]] = _checkAnswer[leftIndices[no]];
                    });
                    _points = _points - 50;
                    _saveUserData();
                    if (leftIndices.length == 1) {
                      Future.delayed(Duration(seconds: 1), () {
                        _comeFromHint = true;
                        _checkAns();
                      });
                    }
                  }
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('No'),
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

  _getFullHint() {
    if (_points < 200) {
      showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: Text('Oops'),
            content: Text('You do not have enough poins.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
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
            title: Text('Are you sure?'),
            content: Text('Do you wat to spend 200 \$ ?'),
            actions: <Widget>[
              FlatButton(
                textColor: Colors.red,
                child: Text('Yes'),
                onPressed: () {
                  setState(() {
                    for (var i = 0; i < _answer.length; i++) {
                      _answer[i] = _checkAnswer[i];
                    }
                  });
                  _points = _points - 200;
                  _saveUserData();
                  Future.delayed(Duration(seconds: 2), () {
                    _comeFromHint = true;
                    _checkAns();
                  });
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('No'),
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

  _getQuestionDetails() async {
    if (_questionState < 100) {
      _isGameOver = false;
      var data = {
        'questionState': _questionState,
      };
      appAuth.qustionDetails(json.encode(data)).then((res) {
        setState(() {
          if (res.statusCode == 200) {
            Map<String, dynamic> qustionDetails = json.decode(res.body);
            _imagesRow1.add(qustionDetails['imageList'][0]);
            _imagesRow1.add(qustionDetails['imageList'][1]);
            _imagesRow2.add(qustionDetails['imageList'][2]);
            _imagesRow2.add(qustionDetails['imageList'][3]);
            _checkAnswer = qustionDetails['answer'];
            for (var i = 0;
                i < qustionDetails['answer'].toString().length;
                i++) {
              if (qustionDetails['answer'][i] == ' ') {
                // _twoWords = true;
                // secondWord(qustionDetails['answer'].toString());
                break;
              } else {
                _answer.add([' ', i]);
              }
            }
            for (var i = 0;
                i < qustionDetails['randomString'].toString().length;
                i++) {
              _randomString.add([qustionDetails['randomString'][i], false, i]);
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
    } else {
      setState(() {
        _isGameOver = true;
      });
    }
  }

  void _pushToAns(rchar) {
    setState(() {
      _randomString[rchar[2]] = [rchar[0], true, rchar[2]];
      for (var i = 0; i < _answer.length; i++) {
        if (_answer[i][0] == ' ') {
          _answer[i] = [rchar[0], i];
          if (_answer.length - 1 == i) {
            _checkAns();
          }
          // if (_answer[i][0].indexOf(' ') == -1) {
          //   _checkAns();
          // }
          break;
        }
      }
    });
  }

  void _backToAns(rchar) {
    print(rchar);
    setState(() {
      print(_answer[rchar[1]]);
      for (var i = 0; i < _randomString.length; i++) {
        print(_answer[rchar[1]][0] + '==' + _randomString[i][0]);
        if (_answer[rchar[1]][0] == _randomString[i][0] && _randomString[i][1]) {
          print(_randomString[i][1]);
          _randomString[i][1] = false;
          break;
        }
      }
      _answer[rchar[1]][0] = ' ';
    });
  }

  void _checkAns() {
    print(_answer.join() + ' ' + _checkAnswer.split(' ')[0]);
    if (_checkAnswer.split(' ')[0].toLowerCase() ==
        _answer.join().toLowerCase()) {
      print('Correct');
      if (_questionState % 5 == 0 && _questionState != 0) {
        _generateTicket();
      }
      _questionState = _questionState + 1;
      _points = _points + 100;
      _answer = [];
      _randomString = [];
      _imagesRow1 = [];
      _imagesRow2 = [];
      _getQuestionDetails();
      _saveUserData();
      if (_comeFromHint) {
        _comeFromHint = false;
        showDialog(
          context: context,
          builder: (BuildContext build) {
            return AlertDialog(
              title: Text('LoL'),
              content: Text('You can\'t get point. Bcz you use Hint.'),
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
              title: Text('Correct'),
              content:
                  Text('Congo! Your Answer is correct.\nYou got 100 coins.'),
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
    } else {
      setState(() {
        _answer = [];
        for (var i = 0; i < _checkAnswer.length; i++) {
          if (_checkAnswer[i] == ' ') {
            // _twoWords = true;
            // secondWord(qustionDetails['answer'].toString());
            break;
          } else {
            _answer.add([' ', i]);
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

  void _saveUserData() {
    var data = {
      'contactNumber': _contactNumber,
      'questionState': _questionState,
      'points': _points
    };
    appAuth.saveUserData(json.encode(data)).then((res) {
      if (res.statusCode == 200) {
        print('saveUserData');
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
              _answer.add([' ', i]);
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
  }

  void _generateTicket() {
    var data = {
      'contactNumber': _contactNumber,
      'questionState': _questionState
    };
    appAuth.generateTicket(json.encode(data)).then((res) {
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

  void _shareApp() {
    String messege =
        'Congratulations ! Today is your LUCKY DAY, Go check out this Amazing App and WIN Lucky Draw Coupon and WIN prices in JJ-111 ! https://goo.gl/XTjjnn';
    final RenderBox box = context.findRenderObject();
    Share.share(messege,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
