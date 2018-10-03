import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learn/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiService appAuth = new ApiService();

class AkGamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AkGamePageState();
  }
}

class _AkGamePageState extends State<AkGamePage> {
  double _value = 0.1;

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

  int _points;
  int _ak_questionState;
  String _contactNumber;

  bool _isGameOver = false;

  final TextEditingController _textController = new TextEditingController();
  List _userWords = [];
  List _answers = ['FIRST', 'SECOND', 'THIRD', 'FORTH'];
  bool _isTyping = false;
  int _completedPercentage = 0;

  _AkGamePageState() {
    SharedPreferences.getInstance().then((onValue) {
      Map<String, dynamic> userData =
          json.decode(onValue.getString('userData'));
      print(userData);
      setState(() {
        _points = int.parse(userData['points'].toString());
      });
      _ak_questionState = int.parse(userData['ak_ques_st'] != null
          ? userData['ak_ques_st'].toString()
          : '1');
      // _getAkQuestionDetails();
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
            title: Text('Akram Youth'),
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
                Text(_completedPercentage.toString() + ' %'),
                SizedBox(
                  width: 20.0,
                ),
                Icon(Icons.monetization_on),
                Text(_points.toString())
              ],
            ),
          ),
          body: new Container(
            child: new Column(
              children: <Widget>[
                new Flexible(
                  child: new ListView(
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          Container(
                            child: _progressIndicator(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                            child: Image.asset(
                              'assets/cover_235003.jpg',
                              width: 250.0,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: new Wrap(
                          alignment: WrapAlignment.center,
                          children: _userWords != null
                              ? _userWords
                                  .map((words) => (new Chip(
                                      label: Text(words),
                                      deleteIcon: Icon(Icons.cancel),
                                      onDeleted: () {
                                        setState(() {
                                          _userWords.removeAt(
                                              _userWords.indexOf(words));
                                        });
                                        _checkAns();
                                      })))
                                  .toList()
                              : new Container(
                                  width: 0.0,
                                  height: 0.0,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Divider(height: 1.0),
                new Container(
                  decoration:
                      new BoxDecoration(color: Theme.of(context).cardColor),
                  child: _buildTextComposer(),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _progressIndicator() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: new LinearProgressIndicator(
          value: _completedPercentage / 100,
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isTyping = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Guess the word"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.add),
                onPressed: _isTyping
                    ? () => _handleSubmitted(_textController.text)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    // For hide keyboard
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      _isTyping = false;
      _userWords.add(text.toUpperCase());
      _userWords = _userWords.toSet().toList();
    });
    _checkAns();
  }

  void _checkAns() {
    int rightAns = 0;
    print(_answers);
    for (var i = 0; i < _userWords.length; i++) {
      for (var j = 0; j < _answers.length; j++) {
        if (_answers[j].toString().toUpperCase() ==
            _userWords[i].toString().toUpperCase()) {
          print(_userWords[i]);
          rightAns = rightAns + 1;
        }
      }
    }
    print((25 * rightAns));
    setState(() {
      _completedPercentage = 25 * rightAns;
    });
  }

  _getAkQuestionDetails() async {
    if (_ak_questionState < 5) {
      _isGameOver = false;
      var data = {
        'ak_ques_st': _ak_questionState,
      };
      appAuth.getAkQuestions(json.encode(data)).then((res) {
        setState(() {
          if (res.statusCode == 200) {
            Map<String, dynamic> qustionDetails = json.decode(res.body);
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

  void _saveUserData() {
    var data = {
      'contactNumber': _contactNumber,
      'ak_ques_st': _ak_questionState,
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
        setState(() {});
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
      'ak_ques_st': _ak_questionState
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
}
