import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _formKey = GlobalKey<FormState>();
final _otpController = TextEditingController();

class OtpVerifyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _OtpVerifyPageState();
  }
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
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
                child: Text('Verify OTP', textScaleFactor: 2.0),
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
                        return 'OTP is required !';
                      }
                      if (value.isNotEmpty && value.length < 6.0) {
                        return 'Enter Valid OTP !';
                      }
                    },
                    controller: _otpController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'OTP',
                    ),
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12.0),
                  ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _checkOtp();
                          }
                        },
                        color: Colors.amber,
                        child: Text('Verify'),
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

  void _checkOtp() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString('otp').toString() == _otpController.text.toString()) {
        if (prefs.getBool('isNewUser')) {
          Navigator.of(context).pushNamed('/editprofile');
          _otpController.clear();
          _showDialog('Success', 'Otp is verified.');
        } else {
          Navigator.of(context).pushNamed('/resetPassword');
          _otpController.clear();
          _showDialog('Success', 'Otp is verified.');
        }
      } else {
        _showDialog('Error', 'Oops!! Wrong OTP.');
      }
    });
  }

  void _showDialog(
    title,
    text,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text(title == 'Error' ? 'Try Again' : 'Okay'),
                onPressed: () {
                  if (title == 'Error') {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        });
  }
}
