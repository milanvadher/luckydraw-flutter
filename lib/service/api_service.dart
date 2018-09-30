import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final _apiUrl = 'http://luckydrawapi.dadabhagwan.org';
  // final _apiUrl = 'http://192.168.1.103:3000';
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
    http.Response res = await http.post(_apiUrl + '/questionDetails', body: data);
    return res;
  }

  // Save User Data 
  Future<http.Response> saveUserData(data) async {
    http.Response res = await http.post(_apiUrl + '/saveUserData', body: data);
    return res;
  }

  // Save User Data 
  Future<http.Response> getUserTickets(data) async {
    http.Response res = await http.post(_apiUrl + '/getUserTickets', body: data);
    return res;
  }

  // Save User Data 
  Future<http.Response> mapTickets(data) async {
    http.Response res = await http.post(_apiUrl + '/mapTicket', body: data);
    return res;
  }

  // Send OTP 
  Future<http.Response> sendOtp(data) async {
    http.Response res = await http.post(_apiUrl + '/otp', body: data);
    return res;
  }

  // Forgot Password 
  Future<http.Response> forgotPassword(data) async {
    http.Response res = await http.post(_apiUrl + '/forgotPassword', body: data);
    return res;
  }

  // Generate Ticket 
  Future<http.Response> generateTicket(data) async {
    http.Response res = await http.post(_apiUrl + '/generateTicket', body: data);
    return res;
  }

}
