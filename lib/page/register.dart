import 'package:flutter/material.dart';
// import 'package:learn/register.dart';

final _formKey = GlobalKey<FormState>();
final _contactController = TextEditingController();
// final _passwordController = TextEditingController();

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
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
                child: Text('REGISTER', textScaleFactor: 2.0),
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
                  // TextFormField(
                  //   validator: (value) {
                  //     if (value.isEmpty) {
                  //       return 'Password is required !';
                  //     }
                  //   },
                  //   controller: _passwordController,
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     labelText: 'Password',
                  //   ),
                  //   obscureText: true,
                  // ),
                  ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text('VERIFY'),
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
}
