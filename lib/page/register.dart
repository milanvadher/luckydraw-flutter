import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learn/page/verifyotp.dart';
import 'package:learn/service/api_service.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

final _formKey = GlobalKey<FormState>();
final _contactController = TextEditingController();
List<int> temp = new List(6);

ApiService appAuth = new ApiService();

class RegisterPage extends StatefulWidget {
  final String title;

  const RegisterPage(this.title);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _RegisterPageState(title);
  }
}

class _RegisterPageState extends State<RegisterPage> {
  String title;

  _RegisterPageState(this.title);

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
                child: Text(title, textScaleFactor: 2.0),
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
                  ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _gererateOtp();
                          }
                        },
                        color: Colors.amber,
                        child: Text('GET OTP'),
                      )
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Center(
                    child: Text('Already Register?'),
                  ),
                  SizedBox(height: 12.0),
                  Center(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      textColor: Colors.blueAccent,
                      child: Text('LOGIN NOW'),
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

  void _gererateOtp() {
    SharedPreferences.getInstance().then((onValue) {
      var otp = new Random();
      for (var i = 0; i < 6; i++) {
        temp[i] = otp.nextInt(9);
      }
      onValue.setString('otp', temp.join());
      print(temp.join());
      var data = {
        'contactNumber': _contactController.text,
        'otp': temp.join().toString()
      };
      appAuth.sendOtp(data).then((res) {
        if (res.statusCode == 200) {
          print(res.body);
          if (json.decode(res.body)['isNewUser']) {
            onValue.setString('number', _contactController.text);
            onValue.setBool('isNewUser', true);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => OtpVerifyPage()));
          } else {
            onValue.setBool('isNewUser', false);
            onValue.setString('user', res.body);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => OtpVerifyPage()));
          }
        } else {
          print('Error');
        }
      });
    });
  }
}
