import 'dart:convert';

import 'package:learn/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

ApiService appAuth = new ApiService();

final _formKey = GlobalKey<FormState>();
final _passwordController = TextEditingController();
final _repeatPasswordController = TextEditingController();

class ResetPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ResetPasswordPageState();
  }
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
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
                child: Text('Reset Password', textScaleFactor: 2.0),
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
                  // [Password]
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Password is required !';
                      }
                      if (value.isNotEmpty && value.length < 4.0) {
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
                            _forgotPassword();
                          }
                        },
                        color: Colors.amber,
                        child: Text('UPDATE'),
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

  void _forgotPassword() {
    SharedPreferences.getInstance().then((prefs) {
      var data;
      data = {
        'contactNumber': json.decode(prefs.getString('user'))['contactNumber'].toString(),
        'password': _passwordController.text.toString()
      };
      print(data);
      appAuth.forgotPassword(data).then((response) {
        if (response.statusCode == 200) {
          prefs.setString('userData', response.body);
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          _showError();
        }
      });
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
