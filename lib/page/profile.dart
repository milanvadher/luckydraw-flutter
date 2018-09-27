import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  int _questionState;
  var _contactNumber;
  int _points;

  var _userName;

  _ProfilePageState() {
    SharedPreferences.getInstance().then((onValue) {
      Map<String, dynamic> userData =
          json.decode(onValue.getString('userData'));
      print(userData);
      _userName = userData['username'];
      _questionState = int.parse(userData['questionState']);
      _points = int.parse(userData['points']);
      _contactNumber = userData['contactNumber'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    child: Text(_userName.toString()[0].toUpperCase()),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _userName,
                      textScaleFactor: 1.2,
                    ),
                    Text(_contactNumber)
                  ],
                )
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.all(10.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Text('Question solved: '),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: Text((_questionState-1).toString(), textScaleFactor: 1.2,),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(10.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Text('Total Points: '),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: Text((_points).toString(), textScaleFactor: 1.2,),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
