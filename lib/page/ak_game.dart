import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luckydraw/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

ApiService appAuth = new ApiService();
int rightAns = 0;
final GlobalKey<AnimatedCircularChartState> _chartKey =
    new GlobalKey<AnimatedCircularChartState>();

class AkGamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AkGamePageState();
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

  int _points;
  int _akQuestionState;
  String _contactNumber;
  String _imgUrl;
  int _questionState;

  bool _isGameOver = false;

  final TextEditingController _textController = new TextEditingController();
  List _userWords = [];
  List _answers = [];
  bool _isTyping = false;
  double _completedPercentage = 0.0;
  double _perQuestionPoint = 1.0;

  _AkGamePageState() {
    SharedPreferences.getInstance().then((onValue) {
      Map<String, dynamic> userData =
          json.decode(onValue.getString('userData'));
      print(userData);
      setState(() {
        _points = int.parse(userData['points'].toString());
      });
      _contactNumber = userData['contactNumber'];
      _questionState = userData['questionState'];
      _akQuestionState =
          ((userData['ak_ques_st'] != null && userData['ak_ques_st'] != 0)
              ? userData['ak_ques_st']
              : 1);
      _getAkQuestionDetails();
      print(_points);
      _showPopup();
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
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      new Container(
                        child: _progressIndicator(),
                      ),
                      Container(
                        // color: Colors.lightBlueAccent,
                        height: 300.0,
                        width: 200.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[_wordCards()],
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

  // bool isTrue(words) {
  //   bool isAvailable = false;
  //   for (var i = 0; i < _answers.length; i++) {
  //     if (_answers[i].contains(words)) {
  //       isAvailable = true;
  //     }
  //   }
  //   return isAvailable;
  // }

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

  Widget _wordCards() {
    return Row(
      children: <Widget>[
        new Container(
          height: 300.0,
          // padding: EdgeInsets.symmetric(horizontal: 1.0),
          child: _imgUrl != null
              ? Image.network(
                  _imgUrl,
                )
              : new Container(
                  width: 0.0,
                  height: 0.0,
                ),
        ),
        Row(
          children: _userWords
              .map(
                (words) => (Card(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              words,
                              textScaleFactor: 1.2,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            CircleAvatar(
                              child: Icon(Icons.done),
                            ),
                          ],
                        ),
                      ),
                    )),
              )
              .toList(),
        )
      ],
    );
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
    // FocusScope.of(context).requestFocus(new FocusNode());
    // _updateGraph();
    setState(() {
      _isTyping = false;
      // _userWords.add(text.toUpperCase());
      _userWords = _userWords.toSet().toList();
    });
    _checkAns(text);
  }

  void _checkAns(word) {
    print(_answers);
    for (var j = 0; j < _answers.length; j++) {
      if (_answers[j].contains(word.toString().toUpperCase())) {
        rightAns = rightAns + 1;
        setState(() {
          _userWords.add(_answers[j][0].toUpperCase());
        });
        _showSuccessMsg(_answers[j][0].toUpperCase());
        _answers.remove(_answers[j]);
      }
    }
    setState(() {
      _completedPercentage = _perQuestionPoint * rightAns;
    });
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
    _perQuestionPoint = 1.0;
    _userWords = [];
    rightAns = 0;
    _updateGraph();
    if (_akQuestionState < 5) {
      _isGameOver = false;
      var data = {
        'ak_ques_st': _akQuestionState,
      };
      appAuth.getAkQuestions(json.encode(data)).then((res) {
        if (res.statusCode == 200) {
          Map<String, dynamic> qustionDetails = json.decode(res.body);
          print(qustionDetails);
          for (var i = 0; i < qustionDetails['answers'].length; i++) {
            _answers.add([]);
            for (var j = 0; j < qustionDetails['answers'][i].length; j++) {
              _answers[i].add(decodeString(qustionDetails['answers'][i][j]));
            }
          }
          print(qustionDetails['answers'].length);
          _perQuestionPoint = 100 / qustionDetails['answers'].length;
          print(qustionDetails['answers']);
          setState(() {
            _imgUrl = qustionDetails['url'];
          });
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
    } else {
      setState(() {
        _isGameOver = true;
      });
    }
  }

  _rightAns() {
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
    _points = _points + 200;
    _akQuestionState = _akQuestionState + 1;
    _getAkQuestionDetails();
    _saveUserData();
    _generateTicket();
  }

  void _saveUserData() {
    var data = {
      'contactNumber': _contactNumber,
      'ak_ques_st': _akQuestionState,
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
