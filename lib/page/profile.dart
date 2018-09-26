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
      body: SafeArea(
        child: new Row(
          children: <Widget>[
            Center(
              child: CircleAvatar(
                child: new Text(_userName.toString()[0].toUpperCase())),
            ),
            Center(
              child: Center(
                child: new Text(_userName, style: Theme.of(context).textTheme.subhead),
              ),
            ),
            // Column(
            //   children: <Widget>[
                
            //     new Text(_contactNumber),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
