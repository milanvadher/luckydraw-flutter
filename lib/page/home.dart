import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:learn/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiService appAuth = new ApiService();

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  int _earnedCoupons;
  int _usedCoupons;

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit an App'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    textColor: Colors.red,
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  _HomePageState() {
    SharedPreferences.getInstance().then((onValue) {
      Map<String, dynamic> userData =
          json.decode(onValue.getString('userData'));
      print(userData);
      var data = {"contactNumber": userData['contactNumber']};
      appAuth.getUserTickets(json.encode(data)).then((res) {
        if (res.statusCode == 200) {
          setState(() {
            print(res.body);
            _earnedCoupons = json.decode(res.body)['earnedTickets'].length;
            _usedCoupons = json.decode(res.body)['ticketMapping'].length;
          });
        } else {
          print('Error Not connect to get user tickets');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lucky Draw'),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/logo.png',
                    height: 200.0,
                  ),
                  SizedBox(height: 8.0),
                  Text('LUCKY DRAW', textScaleFactor: 2.0),
                  SizedBox(height: 30.0),
                  MaterialButton(
                    color: Colors.amber,
                    onPressed: () {
                      Navigator.pushNamed(context, '/start');
                    },
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          child: Icon(Icons.play_arrow),
                        ),
                        Text(
                          'Start Game',
                          textScaleFactor: 1.5,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Text('Your Coupons Details:', textScaleFactor: 1.2,),
                      SizedBox(height: 30.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Used Coupons :'),
                          ),
                          Text(_usedCoupons != null ? _usedCoupons.toString() : '0')
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Unused Coupons :'),
                          ),
                          Text(_earnedCoupons != null ? _earnedCoupons.toString() : '0')
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Total Coupons :', textScaleFactor: 1.1,),
                          ),
                          Text(_usedCoupons != null ? (_earnedCoupons + _usedCoupons).toString() : '0', textScaleFactor: 1.1,)
                        ],
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
