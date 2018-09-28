import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:learn/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiService appAuth = new ApiService();

class CouponsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _CouponsPageState();
  }
}

class _CouponsPageState extends State<CouponsPage> {
  String _contactNumber;

  List _earnedCoupons;
  List _usedCoupons;

  _CouponsPageState() {
    SharedPreferences.getInstance().then((onValue) {
      Map<String, dynamic> userData =
          json.decode(onValue.getString('userData'));
      print(userData);
      _contactNumber = userData['contactNumber'];
      var data = {"contactNumber": _contactNumber};
      appAuth.getUserTickets(data).then((res) {
        if (res.statusCode == 200) {
          setState(() {
            print(res.body);
            _earnedCoupons = json.decode(res.body)['earnedTickets'];
            _usedCoupons = json.decode(res.body)['ticketMapping'];
            print(_earnedCoupons);
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
    if (_earnedCoupons != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Your Coupons'),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Your Earned Coupons:',
                textScaleFactor: 1.5,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Column(
              children: _earnedCoupons
                  .map(
                    (element) => new Card(
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: CircleAvatar(
                                  child: Icon(Icons.monetization_on),
                                ),
                              ),
                              Text(
                                element.toString(),
                                textScaleFactor: 1.3,
                              )
                            ],
                          ),
                        ),
                  )
                  .toList(),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Your Used Coupons:',
                textScaleFactor: 1.5,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Column(
              children: _usedCoupons
                  .map(
                    (element) => new Card(
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: CircleAvatar(
                                  child: Icon(Icons.monetization_on),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(element['ticketNo'].toString(), textScaleFactor: 1.3,),
                                  Text(DateFormat.yMd().add_jm().format(DateTime.parse(element['assignDate']))),
                                ],
                              )
                            ],
                          ),
                        ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Your Coupons'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
