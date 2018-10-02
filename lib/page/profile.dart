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
  int _points;
  String _userName;
  String _contactNumber;

  _ProfilePageState() {
    SharedPreferences.getInstance().then((onValue) {
      Map<String, dynamic> userData =
          json.decode(onValue.getString('userData'));
      print(userData);
      setState(() {
        _questionState = int.parse(userData['questionState'].toString());
        _points = int.parse(userData['points'].toString());
        _contactNumber = userData['contactNumber'];
        _userName = userData['username'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/editusername');
            },
          )
        ],
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
                    child: Text(_userName != null
                        ? _userName.toString()[0].toUpperCase()
                        : 'Loading ...'),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _userName != null ? _userName.toString() : 'Loading ...',
                      textScaleFactor: 1.2,
                    ),
                    Text(
                        _contactNumber != null ? _contactNumber : 'Loading ...')
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
                    child: Text(
                      _questionState != null
                          ? (_questionState == 0 ? 0 : _questionState - 1)
                              .toString()
                          : 'Loading ...',
                      textScaleFactor: 1.2,
                    ),
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
                    child: Text(
                      _points != null ? _points.toString() : 'Loading ...',
                      textScaleFactor: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
