import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:luckydraw/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:photo_view/photo_view.dart';

ApiService appAuth = new ApiService();
final GlobalKey<AnimatedCircularChartState> _chartKey =
    new GlobalKey<AnimatedCircularChartState>();
final GlobalKey<AnimatedCircularChartState> _userWord0 =
    new GlobalKey<AnimatedCircularChartState>();
final GlobalKey<AnimatedCircularChartState> _userWord1 =
    new GlobalKey<AnimatedCircularChartState>();
final GlobalKey<AnimatedCircularChartState> _userWord2 =
    new GlobalKey<AnimatedCircularChartState>();
final GlobalKey<AnimatedCircularChartState> _userWord3 =
    new GlobalKey<AnimatedCircularChartState>();
final GlobalKey<AnimatedCircularChartState> _userWord4 =
    new GlobalKey<AnimatedCircularChartState>();
final GlobalKey<AnimatedCircularChartState> _userWord5 =
    new GlobalKey<AnimatedCircularChartState>();
final GlobalKey<AnimatedCircularChartState> _userWord6 =
    new GlobalKey<AnimatedCircularChartState>();
final GlobalKey<AnimatedCircularChartState> _userWord7 =
    new GlobalKey<AnimatedCircularChartState>();
final GlobalKey<AnimatedCircularChartState> _userWord8 =
    new GlobalKey<AnimatedCircularChartState>();
final GlobalKey<AnimatedCircularChartState> _userWord9 =
    new GlobalKey<AnimatedCircularChartState>();

int _points;
int _akQuestionState;
String _contactNumber;
String _imgUrl;
int _qst;

class AkGamePage extends StatefulWidget {
  final int questionState;
  AkGamePage({this.questionState}) {
    _akQuestionState = questionState;
  }
  @override
  State<StatefulWidget> createState() {
    return new _AkGamePageState(questionState);
  }
}

class _AkGamePageState extends State<AkGamePage> {
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

  final TextEditingController _textController = new TextEditingController();
  List _userWords = ["", "", "", "", "", "", "", "", "", ""];
  List _answers = [];
  List _checkedAnswer = [];
  List _weight = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  bool _isTyping = false;
  double _completedPercentage = 0.0;

  _AkGamePageState(qst) {
    SharedPreferences.getInstance().then((onValue) {
      Map<String, dynamic> userData =
          json.decode(onValue.getString('userData'));
      print(userData);
      setState(() {
        _points = int.parse(userData['points'].toString());
      });
      _contactNumber = userData['contactNumber'];
      _qst = userData['questionState'];
      _getAkQuestionDetails();
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
          title: Row(
            children: <Widget>[
              Expanded(
                child: Text(''),
              ),
              _circularProgress(),
              SizedBox(
                width: 20.0,
              ),
              Icon(Icons.monetization_on),
              Text(_points.toString())
            ],
          ),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 290.0,
                    child: _wordCards(),
                  ),
                  Column(
                    children: <Widget>[
                      new Divider(height: 1.0),
                      new Container(
                        decoration: new BoxDecoration(
                            color: Theme.of(context).cardColor),
                        child: _completedPercentage == 100
                            ? new Container(
                                width: 0.0,
                                height: 0.0,
                              )
                            : _buildTextComposer(),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _circularProgress() {
    return new AnimatedCircularChart(
      key: _chartKey,
      size: const Size(50.0, 50.0),
      initialChartData: <CircularStackEntry>[
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(
              _completedPercentage.roundToDouble(),
              Colors.black,
              rankKey: 'completed',
            ),
            new CircularSegmentEntry(
              100 - _completedPercentage.roundToDouble(),
              Colors.blueGrey[600],
              rankKey: 'remaining',
            ),
          ],
          rankKey: 'progress',
        ),
      ],
      chartType: CircularChartType.Radial,
      holeLabel: _completedPercentage.toStringAsFixed(0),
      labelStyle: new TextStyle(fontSize: 20.0, color: Colors.black),
      edgeStyle: SegmentEdgeStyle.round,
      percentageValues: true,
    );
  }

  Widget _userWordProgress(key, completedValue) {
    return new AnimatedCircularChart(
      key: key,
      size: const Size(50.0, 50.0),
      initialChartData: <CircularStackEntry>[
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(
              completedValue.roundToDouble(),
              Colors.blue[900],
              rankKey: 'completed',
            ),
            new CircularSegmentEntry(
              100 - completedValue.roundToDouble(),
              Colors.blue[100],
              rankKey: 'remaining',
            ),
          ],
          rankKey: 'progress',
        ),
      ],
      chartType: CircularChartType.Radial,
      holeLabel: completedValue.toStringAsFixed(0),
      labelStyle:
          new TextStyle(fontSize: 20.0, color: Theme.of(context).accentColor),
      edgeStyle: SegmentEdgeStyle.round,
      percentageValues: true,
    );
  }

  void _updateGraph() {
    List<CircularStackEntry> nextData = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(
            double.parse(_completedPercentage.toStringAsFixed(2)),
            Colors.black,
            rankKey: 'completed',
          ),
          new CircularSegmentEntry(
            100 - double.parse(_completedPercentage.toStringAsFixed(2)),
            Colors.blueGrey[600],
            rankKey: 'remaining',
          ),
        ],
        rankKey: 'Quarterly Profits',
      ),
    ];
    setState(() {
      _chartKey.currentState.updateData(nextData);
    });
  }

  Widget _imgWidget() {
    return Row(children: <Widget>[
      new Container(
        height: 290.0,
        padding: EdgeInsets.symmetric(horizontal: 1.0),
        child: _imgUrl != null
            ? GestureDetector(
                onTap: () {
                  _photoView(_imgUrl);
                },
                child: Image.network(
                  _imgUrl,
                ),
              )
            : new Container(
                width: 0.0,
                height: 0.0,
              ),
      ),
    ]);
  }

  Widget _wordCards() {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Column(
          children: <Widget>[_imgWidget()],
        ),
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _userWords.length != 0 && _userWords[0] != null
                            ? Text(
                                _userWords[0],
                                textScaleFactor: 1.1,
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _userWordProgress(_userWord0, _weight[0])
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _userWords.length >= 2 && _userWords[1] != null
                            ? Text(
                                _userWords[1],
                                textScaleFactor: 1.1,
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _userWordProgress(_userWord1, _weight[1])
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _userWords.length >= 3 && _userWords[2] != null
                            ? Text(
                                _userWords[2],
                                textScaleFactor: 1.1,
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _userWordProgress(_userWord2, _weight[2])
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _userWords.length >= 4 && _userWords[3] != null
                            ? Text(
                                _userWords[3],
                                textScaleFactor: 1.1,
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _userWordProgress(_userWord3, _weight[3])
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _userWords.length >= 5 && _userWords[4] != null
                            ? Text(
                                _userWords[4],
                                textScaleFactor: 1.1,
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _userWordProgress(_userWord4, _weight[4])
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _userWords.length >= 6 && _userWords[5] != null
                            ? Text(
                                _userWords[5],
                                textScaleFactor: 1.1,
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _userWordProgress(_userWord5, _weight[5])
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _userWords.length >= 7 && _userWords[6] != null
                            ? Text(
                                _userWords[6],
                                textScaleFactor: 1.1,
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _userWordProgress(_userWord6, _weight[6])
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _userWords.length >= 8 && _userWords[7] != null
                            ? Text(
                                _userWords[7],
                                textScaleFactor: 1.1,
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _userWordProgress(_userWord7, _weight[7])
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _userWords.length >= 9 && _userWords[8] != null
                            ? Text(
                                _userWords[8],
                                textScaleFactor: 1.1,
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _userWordProgress(_userWord8, _weight[8])
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _userWords.length >= 10 && _userWords[9] != null
                            ? Text(
                                _userWords[9],
                                textScaleFactor: 1.1,
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _userWordProgress(_userWord9, _weight[9])
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.help_outline, color: Colors.blue),
                onPressed: () => _getHint(),
              ),
            ),
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
    setState(() {
      _isTyping = false;
    });
    _checkAns(text);
  }

  void _getHint() {
    showDialog(
      context: context,
      builder: (BuildContext build) {
        return AlertDialog(
          title: Text(
            'Are you sure ???',
            textScaleFactor: 1.2,
          ),
          content: Text(
              'You will have to pay 50\$ to only view some character of the answer !!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
                _showHint();
              },
            )
          ],
        );
      },
    );
  }

  void _showHint() {
    if (_points < 50) {
      showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: Text(
              'Warning',
              textScaleFactor: 1.2,
            ),
            content: Text('You don\'t have sufficient balance.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                  _showHint();
                },
              )
            ],
          );
        },
      );
      return;
    }
    setState(() {
      _points -= 50;
    });
    _saveUserData();
    List tempAns = [];
    for (var i = 0; i < _checkedAnswer.length; i++) {
      if (_checkedAnswer[i] == false) {
        tempAns.add(_answers[i][0]);
      }
    }
    var randomNumber = new Random().nextInt(tempAns.length);
    String answer = tempAns[randomNumber];
    print(answer);
    showDialog(
      context: context,
      builder: (BuildContext build) {
        return AlertDialog(
          title: Text(
            'Hint!',
            textScaleFactor: 1.2,
          ),
          content: Text('* Answer will disappear after you press okay.\n\n' +
              answer[0] +
              '_ ' * (answer.length - 2) +
              answer[answer.length - 1] +
              '. (' +
              answer.length.toString() +
              ' letter word)'),
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
  }

  void _checkAns(word) {
    print(_answers);
    for (var j = 0; j < _answers.length; j++) {
      if (_checkedAnswer[j] == false) {
        if (_answers[j].contains(word.toString().toUpperCase())) {
          print(_answers[j]);
          print(_weight[_answers.indexOf(_answers[j])]);
          if (_userWords[_answers.indexOf(_answers[j])] == "") {
            setState(() {
              _userWords[_answers.indexOf(_answers[j])] =
                  _answers[j][0].toUpperCase();
              _completedPercentage += _weight[_answers.indexOf(_answers[j])];
            });
          }
          _showSuccessMsg(_answers[j][0].toUpperCase());
          _points += 10;
          _saveUserData();
          _checkedAnswer[_answers.indexOf(_answers[j])] = true;
          int count = 0;
          for (var i = 0; i < _checkedAnswer.length; i++) {
            if (_checkedAnswer[i] == true) {
              count += 1;
            }
          }
          if (count == 5) {
            _generateTicket();
          }
          _saveUserWord();
        }
      }
    }
    _updateGraph();
    print(_completedPercentage.toStringAsFixed(2));
    print(100.00.toString());
    if (_completedPercentage.toStringAsFixed(1) == 100.0.toString()) {
      _rightAns();
    }
  }

  _getAkQuestionDetails() async {
    _imgUrl = null;
    _answers = [];
    _completedPercentage = 0.0;
    _userWords = ["", "", "", "", "", "", "", "", "", ""];
    _checkedAnswer = [];
    _updateGraph();
    var data = {
      'ak_ques_st': _akQuestionState,
      'contactNumber': _contactNumber
    };
    appAuth.getAkQuestions(json.encode(data)).then((res) {
      if (res.statusCode == 200) {
        Map<String, dynamic> qustionDetails = json.decode(res.body);
        print(qustionDetails);
        for (var i = 0; i < qustionDetails['answers'].length; i++) {
          _answers.add([]);
          _checkedAnswer.add(false);
          for (var j = 0; j < qustionDetails['answers'][i].length; j++) {
            _answers[i].add(decodeString(qustionDetails['answers'][i][j]));
          }
        }
        print(_weight);
        print(qustionDetails['answers'].length);
        // _perQuestionPoint = 100 / qustionDetails['answers'].length;
        print(qustionDetails['answers']);
        setState(() {
          _imgUrl = qustionDetails['url'];
          _weight = qustionDetails['weight'];
        });
        _updateUserWordGraph(_userWord0, _weight[0]);
        _updateUserWordGraph(_userWord1, _weight[1]);
        _updateUserWordGraph(_userWord2, _weight[2]);
        _updateUserWordGraph(_userWord3, _weight[3]);
        _updateUserWordGraph(_userWord4, _weight[4]);
        _updateUserWordGraph(_userWord5, _weight[5]);
        _updateUserWordGraph(_userWord5, _weight[5]);
        _updateUserWordGraph(_userWord6, _weight[6]);
        _updateUserWordGraph(_userWord7, _weight[7]);
        _updateUserWordGraph(_userWord8, _weight[8]);
        _updateUserWordGraph(_userWord9, _weight[9]);
        for (var i = 0; i < qustionDetails['answered'].length; i++) {
          for (var j = 0; j < _answers.length; j++) {
            if (_checkedAnswer[j] == false) {
              if (_answers[j]
                  .contains(qustionDetails['answered'][i].toString())) {
                print(_answers[j]);
                print(_weight[_answers.indexOf(_answers[j])]);
                if (_userWords[_answers.indexOf(_answers[j])] == "") {
                  setState(() {
                    _userWords[_answers.indexOf(_answers[j])] =
                        _answers[j][0].toUpperCase();
                    _completedPercentage +=
                        _weight[_answers.indexOf(_answers[j])];
                  });
                }
                _checkedAnswer[_answers.indexOf(_answers[j])] = true;
              }
            }
          }
        }
        _updateGraph();
        if (_completedPercentage != 100) {
          _showPopup();
        }
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

  _rightAns() {
    _points = _points + 200;
    _saveUserData();
    _generateTicket();
    showDialog(
      context: context,
      builder: (BuildContext build) {
        return AlertDialog(
          title: Text('Congo'),
          content: Text('Your answer is correct.'),
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
  }

  void _saveUserData() {
    var data = {
      'contactNumber': _contactNumber,
      'points': _points,
      'questionState': _qst,
    };
    appAuth.saveUserData(json.encode(data)).then((res) {
      if (res.statusCode == 200) {
        print('saveUserData');
        print(res.body);
        SharedPreferences.getInstance().then((onValue) {
          onValue.setString('userData', res.body);
        });
      } else {
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

  _saveUserWord() {
    List temp = _userWords.toSet().toList();
    temp.remove("");
    print(temp);
    var data = {
      "contactNumber": _contactNumber,
      "ak_ques_st": _akQuestionState,
      "answer": temp
    };
    appAuth.saveAKUserWords(json.encode(data)).then((res) {
      if (res.statusCode == 200) {
        print('success user word save');
        print(res.body);
      } else {
        print('error user word save');
        print(res.body);
      }
    });
  }

  _showPopup() {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('What words come to your mind when you see this Picture.'),
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _showSuccessMsg(text) {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Correct',
                textScaleFactor: 1.5,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(text.toString().toUpperCase()),
              SizedBox(
                height: 20.0,
              ),
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  decodeString(word) {
    Base64Decoder b = new Base64Decoder();
    Utf8Decoder u = new Utf8Decoder();
    print(u.convert(b.convert(word)));
    return u.convert(b.convert(word)).toUpperCase();
  }

  void _generateTicket() {
    print('Yehhh');
    var data = {
      'contactNumber': _contactNumber,
      'ak_ques_st': _akQuestionState
    };
    appAuth.generateTicketForAK(json.encode(data)).then((res) {
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
        print(res.body);
      }
    });
  }

  _photoView(img) {
    showDialog(
        context: context,
        builder: (BuildContext build) {
          return Container(
            child: PhotoView(
              imageProvider: NetworkImage(img),
            ),
          );
        });
    print(img);
  }

  void _updateUserWordGraph(key, value) {
    List<CircularStackEntry> nextData = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(
            value.roundToDouble(),
            Colors.blue[900],
            rankKey: 'completed',
          ),
          new CircularSegmentEntry(
            100 - value.roundToDouble(),
            Colors.blue[100],
            rankKey: 'remaining',
          ),
        ],
        rankKey: 'progress',
      ),
    ];
    setState(() {
      key.currentState.updateData(nextData);
    });
  }
}
