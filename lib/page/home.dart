import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List _answer = ['A', 'N', 'S', 'W', 'E', 'R'];
  List _imagesRow1 = [1, 2];
  List _imagesRow2 = [1, 2];

  @override
  void initState() {
    // TODO: implement initState
    _getQuestionDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Lucky Draw JJ-111'),
      ),
      body: Column(
        children: [
          Row(
            children: _imagesRow1
                .map(
                  (image) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            'assets/demo.JPG',
                          ),
                        ),
                      ),
                )
                .toList(),
          ),
          Row(
            children: _imagesRow2
                .map(
                  (image) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            'assets/demo.JPG',
                          ),
                        ),
                      ),
                )
                .toList(),
          ),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _answer
                .map((element) => new MaterialButton(
                      onPressed: () {},
                      minWidth: 40.0,
                      height: 40.0,
                      color: Colors.blueGrey,
                      child: Text(element),
                    ))
                .toList(),
          ),
          SizedBox(height: 15.0),
          RaisedButton(
            onPressed: () {
              _logOut();
            },
            child: Text('LogOut'),
          )
        ],
      ),
    );
  }

  Future _getQuestionDetails() async {
    print('In quesion details');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userData'));
    var data;
    data = {
      'questionState': '75',
    };
    http.Response res =
        await http.post('http://luckydrawapi.dadabhagwan.org/questionDetails',
            // 'http://api.excellar.io:3000/questionDetails',
            body: data);

    print(res.body);
    if (res.statusCode == 200) {
      print(res.body.toString());
      _showError(res.body.toString());
    } else {
      // _showError();
    }
  }

  void _showError(data) {
    showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(data),
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

  void _logOut() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((onValue) {
      onValue.clear();
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }
}
