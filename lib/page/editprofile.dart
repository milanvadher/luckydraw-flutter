import 'dart:convert';

import 'package:learn/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/material.dart';

ApiService appAuth = new ApiService();

final _formKey = GlobalKey<FormState>();
final _userNameController = TextEditingController();
final _passwordController = TextEditingController();
final _repeatPasswordController = TextEditingController();

class EditProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _EditProfilePageState();
  }
}

class _EditProfilePageState extends State<EditProfilePage> {
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
                child: Text('Profile', textScaleFactor: 2.0),
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
                      if (value.isNotEmpty && value.length < 10.0) {
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
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Password is required !';
                      }
                      if (value.isNotEmpty && value.length < 5.0) {
                        return 'Minimum 5 character required !';
                      }
                    },
                    controller: _passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 12.0),
                  // [Repeat Password]
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Retype-Password is required !';
                      }
                      if (_passwordController.text !=
                          _repeatPasswordController.text) {
                        return 'Password and Retype-password must be same.';
                      }
                    },
                    controller: _repeatPasswordController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Retype-password',
                    ),
                    obscureText: true,
                  ),
                  ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _register();
                          }
                        },
                        color: Colors.amber,
                        child: Text('Save'),
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

  Future _register() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data;
    data = {
      'username': _userNameController.text,
      'contactNumber': prefs.getString('number'),
      'password': _passwordController.text
    };
    print(data);
    appAuth.register(json.encode(data)).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        prefs.setString('userData', response.body);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed('/home');
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
