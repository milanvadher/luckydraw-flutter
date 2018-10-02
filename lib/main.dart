import 'package:flutter/material.dart';
import 'package:learn/page/ak_game.dart';
import 'package:learn/page/coupons.dart';
import 'package:learn/page/editprofile.dart';
import 'package:learn/page/editusername.dart';
import 'package:learn/page/profile.dart';
import 'package:learn/page/resetPassword.dart';
import 'package:learn/page/start.dart';
import 'package:learn/page/verifyotp.dart';
import 'package:learn/page/winners.dart';
import 'package:learn/service/api_service.dart';
import './page/login.dart';
import './page/register.dart';
import './page/home.dart';

ApiService appAuth = new ApiService();
bool _theme = false;
void setTheme(value) {
  _theme = value;
  main();
}

void main() async {
  // Set default home.
  Widget _defaultHome = new LoginPage();

  // Get result of the login function.
  bool _result = await appAuth.checkLoginStatus();
  _theme = await appAuth.checkTheme();
  if (_result) {
    _defaultHome = new HomePage();
  }

  // Run app!
  runApp(new MaterialApp(
    title: 'Demo App',
    home: _defaultHome,
    theme: _theme
        ? ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.cyan,
            fontFamily: 'GoogleSans')
        : ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.orangeAccent,
            fontFamily: 'GoogleSans'),
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      '/home': (BuildContext context) => new HomePage(),
      '/start': (BuildContext context) => new StartPage(),
      '/login': (BuildContext context) => new LoginPage(),
      '/register': (BuildContext context) => new RegisterPage('Register'),
      '/coupons': (BuildContext context) => new CouponsPage(),
      '/profile': (BuildContext context) => new ProfilePage(),
      '/winners': (BuildContext context) => new WinnerPage(),
      '/otp': (BuildContext context) => new OtpVerifyPage(),
      '/editprofile': (BuildContext context) => new EditProfilePage(),
      '/resetPassword': (BuildContext context) => new ResetPasswordPage(),
      '/editusername': (BuildContext context) => new EditUserPage(),
      '/ak_game': (BuildContext context) => new AkGamePage(),
    },
  ));
}
