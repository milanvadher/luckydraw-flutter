import 'package:flutter/material.dart';
import 'package:learn/service/api_service.dart';
import './page/login.dart';
import './page/register.dart';
import './page/home.dart';

ApiService appAuth = new ApiService();

void main() async {
  // Set default home.
  Widget _defaultHome = new LoginPage();

  // Get result of the login function.
  bool _result = await appAuth.checkLoginStatus();
  if (_result) {
    _defaultHome = new HomePage();
  }

  // Run app!
  runApp(new MaterialApp(
    title: 'Demo App',
    home: _defaultHome,
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      '/home': (BuildContext context) => new HomePage(),
      '/login': (BuildContext context) => new LoginPage(),
      '/register': (BuildContext context) => new RegisterPage()
    },
  ));
}
