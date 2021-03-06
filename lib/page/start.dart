import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:luckydraw/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiService appAuth = new ApiService();

class StartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _StartPageState();
  }
}

class _StartPageState extends State<StartPage> {
  bool _comeFromHint = false;

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit the Game'),
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

  _StartPageState() {
    SharedPreferences.getInstance().then((onValue) {
      Map<String, dynamic> userData =
          json.decode(onValue.getString('userData'));
      print(userData);
      _questionState = int.parse(userData['questionState'].toString()) != null
          ? int.parse(userData['questionState'].toString())
          : 0;
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
                  child: Text(''),
                ),
                Icon(Icons.monetization_on),
                Text(_points.toString())
              ],
            ),
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
                              child: Text(element[0].toString().toUpperCase()),
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
                              color: Theme.of(context).primaryColor,
                              child: Text(element[0].toString().toUpperCase()),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: 80.0,
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: Row(
            children: <Widget>[
              SizedBox(
                width: 30.0,
              ),
              FloatingActionButton(
                child: Icon(Icons.help),
                onPressed: () {
                  _getOneHint();
                },
              ),
              Expanded(
                child: Text(''),
              ),
              FloatingActionButton(
                child: Icon(Icons.done_all),
                onPressed: () {
                  _getFullHint();
                },
              )
            ],
          ),
        ),
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
                    if (_answer[i][0] == ' ') {
                      leftIndices.add(i);
                    }
                  }
                  if (leftIndices.length != 0) {
                    var no = new Random().nextInt(leftIndices.length);
                    setState(() {
                      _answer[leftIndices[no]][0] =
                          _checkAnswer[leftIndices[no]];
                    });
                    for (var i = 0; i < _randomString.length; i++) {
                      if (_randomString[i][0]
                          .contains(_checkAnswer[leftIndices[no]])) {
                        if (_randomString[i][1] != true) {
                          setState(() {
                            _randomString[i][1] = true;
                          });
                          break;
                        }
                      }
                    }
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
    if (_points < 500) {
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
            content: Text('Do you wat to spend 500 \$ ?'),
            actions: <Widget>[
              FlatButton(
                textColor: Colors.red,
                child: Text('Yes'),
                onPressed: () {
                  setState(() {
                    for (var i = 0; i < _answer.length; i++) {
                      _answer[i][0] = _checkAnswer[i];
                    }
                  });
                  _points = _points - 500;
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
    print(_questionState);
    if (_questionState < 100) {
      _isGameOver = false;
      var data = {
        'questionState': _questionState,
      };
      appAuth.qustionDetails(json.encode(data)).then((res) {
        print(res.body);
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
    int temp = 0;
    setState(() {
      _randomString[rchar[2]] = [rchar[0], true, rchar[2]];
    });
    for (var i = 0; i < _answer.length; i++) {
      if (_answer[i][0] == ' ') {
        setState(() {
          _answer[i] = [rchar[0], i];
        });
        break;
      }
    }
    for (var i = 0; i < _answer.length; i++) {
      if (_answer[i][0] == ' ') {
      } else {
        temp = temp + 1;
      }
    }
    if (temp == _answer.length) {
      _checkAns();
    }
  }

  void _backToAns(rchar) {
    print(rchar);
    setState(() {
      print(_answer[rchar[1]]);
      for (var i = 0; i < _randomString.length; i++) {
        print(_answer[rchar[1]][0] + '==' + _randomString[i][0]);
        if (_answer[rchar[1]][0] == _randomString[i][0] &&
            _randomString[i][1]) {
          print(_randomString[i][1]);
          _randomString[i][1] = false;
          break;
        }
      }
      _answer[rchar[1]][0] = ' ';
    });
  }

  void _checkAns() {
    var temp = [];
    for (var i = 0; i < _answer.length; i++) {
      temp.add(_answer[i][0]);
    }
    print(temp.join() + ' ' + _checkAnswer.split(' ')[0]);
    if (_checkAnswer.split(' ')[0].toLowerCase() == temp.join().toLowerCase()) {
      print('Correct');
      if (!_comeFromHint) {
        _points = _points + 100;
      }
      _answer = [];
      _randomString = [];
      _imagesRow1 = [];
      _imagesRow2 = [];
      _questionState = _questionState + 1;
      _getQuestionDetails();
      var data = {
        'contactNumber': _contactNumber,
        'points': _points,
        'questionState': _questionState,
      };
      appAuth.saveUserData(json.encode(data)).then((res) {
        if (res.statusCode == 200) {
          print('saveUserData');
          print(res.body);
          SharedPreferences.getInstance().then((onValue) {
            onValue.setString('userData', res.body);
          });
          if (_questionState % 5 == 0 && _questionState != 0) {
            _generateTicket();
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
            break;
          } else {
            _answer.add([' ', i]);
          }
        }
        var abc = _randomString;
        _randomString = [];
        for (var i = 0; i < abc.length; i++) {
          _randomString.add([abc[i][0], false, i]);
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

  void _saveUserData() {
    var data = {
      'contactNumber': _contactNumber,
      'points': _points,
      'questionState': _questionState,
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
      print(res.body);
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
}
