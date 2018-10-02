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

  bool _isGameOver = true;

  _AkGamePageState() {
    SharedPreferences.getInstance().then((onValue) {
      Map<String, dynamic> userData =
          json.decode(onValue.getString('userData'));
      print(userData);
      _points = int.parse(userData['points'].toString());
      _ak_questionState = int.parse(userData['ak_ques_st'] != null ? userData['ak_ques_st'].toString() : '1');
      this._getAkQuestionDetails();
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
                        children: <Widget>[],
                      ),
                    ),
                    SizedBox(height: 15.0),
                  ],
                ),
              ],
            )),
      );
    }
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
        setState(() {
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
