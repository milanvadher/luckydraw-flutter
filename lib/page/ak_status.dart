import 'dart:convert';

import 'package:luckydraw/page/ak_game.dart';
import 'package:luckydraw/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiService appAuth = new ApiService();

var _resultStats;

class AkStatusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AkStatusPage();
  }
}

class _AkStatusPage extends State<AkStatusPage> {
  _AkStatusPage() {
    SharedPreferences.getInstance().then((onValue) {
      Map<String, dynamic> userData =
          json.decode(onValue.getString('userData'));
      print(userData);
      var data = {"contactNumber": userData['contactNumber']};
      appAuth.getAKUserState(json.encode(data)).then((res) {
        if (res.statusCode == 200) {
          print('AKGAMESTATUS');
          print(res.body);
          setState(() {
            _resultStats = json.decode(res.body)['result_stats'];
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 10.0),
              Center(
                child: Text('Akram Youth Game', textScaleFactor: 2.0),
              ),
              SizedBox(height: 10.0),
              Column(
                children: <Widget>[
                  Image.asset(
                    'assets/logo.png',
                    height: 120.0,
                  ),
                  SizedBox(height: 8.0),
                  Text('LUCKY DRAW', textScaleFactor: 1.5),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          _getQuestionState(_resultStats[0]['ak_ques_st']);
                        },
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          margin: EdgeInsets.all(10.0),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  _resultStats != null &&
                                          _resultStats[0] != null
                                      ? _resultStats[0]['ak_ques_st'].toString()
                                      : "",
                                  textScaleFactor: 1.5,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  _resultStats != null &&
                                          _resultStats[0] != null
                                      ? _resultStats[0]['answered'].toString() +
                                          '/' +
                                          _resultStats[0]['total'].toString()
                                      : "",
                                  textScaleFactor: 0.8,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      new GestureDetector(
                          onTap: () {
                            _getQuestionState(_resultStats[1]['ak_ques_st']);
                          },
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            margin: EdgeInsets.all(10.0),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    _resultStats != null &&
                                            _resultStats[1] != null
                                        ? _resultStats[1]['ak_ques_st']
                                            .toString()
                                        : "",
                                    textScaleFactor: 1.5,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    _resultStats != null &&
                                            _resultStats[1] != null
                                        ? _resultStats[1]['answered']
                                                .toString() +
                                            '/' +
                                            _resultStats[1]['total'].toString()
                                        : "",
                                    textScaleFactor: 0.8,
                                  )
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          _getQuestionState(_resultStats[2]['ak_ques_st']);
                        },
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          margin: EdgeInsets.all(10.0),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  _resultStats != null &&
                                          _resultStats[2] != null
                                      ? _resultStats[2]['ak_ques_st'].toString()
                                      : "",
                                  textScaleFactor: 1.5,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  _resultStats != null &&
                                          _resultStats[2] != null
                                      ? _resultStats[2]['answered'].toString() +
                                          '/' +
                                          _resultStats[2]['total'].toString()
                                      : "",
                                  textScaleFactor: 0.8,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      new GestureDetector(
                          onTap: () {
                            _getQuestionState(_resultStats[3]['ak_ques_st']);
                          },
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            margin: EdgeInsets.all(10.0),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    _resultStats != null &&
                                            _resultStats[3] != null
                                        ? _resultStats[3]['ak_ques_st']
                                            .toString()
                                        : "",
                                    textScaleFactor: 1.5,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    _resultStats != null &&
                                            _resultStats[3] != null
                                        ? _resultStats[3]['answered']
                                                .toString() +
                                            '/' +
                                            _resultStats[3]['total'].toString()
                                        : "",
                                    textScaleFactor: 0.8,
                                  )
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          _getQuestionState(_resultStats[4]['ak_ques_st']);
                        },
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          margin: EdgeInsets.all(10.0),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  _resultStats != null &&
                                          _resultStats[4] != null
                                      ? _resultStats[4]['ak_ques_st'].toString()
                                      : "",
                                  textScaleFactor: 1.5,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  _resultStats != null &&
                                          _resultStats[4] != null
                                      ? _resultStats[4]['answered'].toString() +
                                          '/' +
                                          _resultStats[4]['total'].toString()
                                      : "",
                                  textScaleFactor: 0.8,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      new GestureDetector(
                          onTap: () {
                            _getQuestionState(_resultStats[5]['ak_ques_st']);
                          },
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            margin: EdgeInsets.all(10.0),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    _resultStats != null &&
                                            _resultStats[5] != null
                                        ? _resultStats[5]['ak_ques_st']
                                            .toString()
                                        : "",
                                    textScaleFactor: 1.5,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    _resultStats != null &&
                                            _resultStats[5] != null
                                        ? _resultStats[5]['answered']
                                                .toString() +
                                            '/' +
                                            _resultStats[5]['total'].toString()
                                        : "",
                                    textScaleFactor: 0.8,
                                  )
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          _getQuestionState(_resultStats[6]['ak_ques_st']);
                        },
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          margin: EdgeInsets.all(10.0),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  _resultStats != null &&
                                          _resultStats[6] != null
                                      ? _resultStats[6]['ak_ques_st'].toString()
                                      : "",
                                  textScaleFactor: 1.5,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  _resultStats != null &&
                                          _resultStats[6] != null
                                      ? _resultStats[6]['answered'].toString() +
                                          '/' +
                                          _resultStats[6]['total'].toString()
                                      : "",
                                  textScaleFactor: 0.8,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      new GestureDetector(
                          onTap: () {
                            _getQuestionState(_resultStats[7]['ak_ques_st']);
                          },
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            margin: EdgeInsets.all(10.0),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    _resultStats != null &&
                                            _resultStats[7] != null
                                        ? _resultStats[7]['ak_ques_st']
                                            .toString()
                                        : "",
                                    textScaleFactor: 1.5,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    _resultStats != null &&
                                            _resultStats[7] != null
                                        ? _resultStats[7]['answered']
                                                .toString() +
                                            '/' +
                                            _resultStats[7]['total'].toString()
                                        : "",
                                    textScaleFactor: 0.8,
                                  )
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          _getQuestionState(_resultStats[8]['ak_ques_st']);
                        },
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          margin: EdgeInsets.all(10.0),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  _resultStats != null &&
                                          _resultStats[8] != null
                                      ? _resultStats[8]['ak_ques_st'].toString()
                                      : "",
                                  textScaleFactor: 1.5,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  _resultStats != null &&
                                          _resultStats[8] != null
                                      ? _resultStats[8]['answered'].toString() +
                                          '/' +
                                          _resultStats[8]['total'].toString()
                                      : "",
                                  textScaleFactor: 0.8,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _getQuestionState(qst) {
    print(qst);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> AkGamePage(questionState:int.parse(qst))));
    Navigator.of(context).pushNamed('/ak_game');
  }

  void _showError() {
    showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('User not available or Wrong credentials'),
            actions: <Widget>[
              FlatButton(
                child: Text('Try Again'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
