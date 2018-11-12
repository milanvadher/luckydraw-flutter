import 'dart:convert';

import 'package:luckydraw/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/material.dart';

ApiService appAuth = new ApiService();

var _formKey = GlobalKey<FormState>();

class EditUserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _EditUserPageState();
  }
}

class _EditUserPageState extends State<EditUserPage> {
  var _userNameController = TextEditingController();

  _EditUserPageState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _userNameController = TextEditingController(
            text: json.decode(prefs.getString('userData'))['username']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: SafeArea(
        child: Center(
            child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 10.0),
              Center(
                child: Text('Edit Profile', textScaleFactor: 2.0),
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
                  // [Mobile]
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Username is required !';
                      }
                      if (value.isNotEmpty && value.length < 5.0) {
                        return 'Enter Valid username !';
                      }
                    },
                    controller: _userNameController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Username',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 12.0),
                  // [Password]
                  ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _editProfile();
                          }
                        },
                        color: Theme.of(context).primaryColor,
                        child: Text('Update'),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  Future _editProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data;
    data = {
      'contactNumber':
          json.decode(prefs.getString('userData'))['contactNumber'],
      'username': _userNameController.text
    };
    appAuth.profileUpdate(json.encode(data)).then((response) {
      if (response.statusCode == 200) {
        // Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/profile');
        prefs.setString('userData', response.body);
      } else {
        _showError();
      }
    });
  }

  void _showError() {
    showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Internal server error !'),
            actions: <Widget>[
              FlatButton(
                child: Text('Try Again'),
                onPressed: () {
                  _formKey.currentState.reset();
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
