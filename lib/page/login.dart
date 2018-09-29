import 'package:learn/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import './register.dart';

ApiService appAuth = new ApiService();

final _formKey = GlobalKey<FormState>();
final _contactController = TextEditingController();
final _passwordController = TextEditingController();

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
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
                child: Text('LOGIN', textScaleFactor: 2.0),
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
                        return 'Contact number is required !';
                      }
                      if (value.isNotEmpty && value.length < 10.0) {
                        return 'Enter Valid Contact number !';
                      }
                    },
                    controller: _contactController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Contact Number',
                    ),
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12.0),
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
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      RegisterPage('FORGOT PASSWORD'),
                                  fullscreenDialog: true));
                        },
                        textColor: Colors.blueAccent,
                        child: Text('Forgot Password ?'),
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _login();
                          }
                        },
                        color: Colors.amber,
                        child: Text('LOGIN'),
                      )
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Center(
                    child: Text('Not Account yet?'),
                  ),
                  SizedBox(height: 12.0),
                  Center(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    RegisterPage('REGISTER'),
                                fullscreenDialog: true));
                      },
                      textColor: Colors.blueAccent,
                      child: Text('REGISTER NOW'),
                    ),
                  )
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  Future _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data;
    data = {
      'contactNumber': _contactController.text,
      'password': _passwordController.text
    };
    appAuth.login(data).then((response) {
      if (response.statusCode == 200) {
        prefs.setString('userData', response.body);
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
            content: Text('User not available or wrong credentials'),
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
