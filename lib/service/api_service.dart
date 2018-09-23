import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final _apiUrl = 'http://luckydrawapi.dadabhagwan.org';
  // Login
  Future<http.Response> login(data) async {
    http.Response res = await http.post(_apiUrl + '/login', body: data);
    return res;
  }

  // Logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // go to login
  }

  // Check Login Status
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userData') != null) {
      return true;
    } else {
      return false;
    }
  }

  // Get Qustion Details 
  Future<http.Response> qustionDetails(data) async {
    http.Response res = await http.post(_apiUrl + '/getUserTickets', body: data);
    return res;
  }
}
