import 'dart:convert';

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
        body: ListView.builder(
          itemCount: _earnedCoupons.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ListTile(
                title: Text('Earned Coupons:', textScaleFactor: 1.2,),
              );
            } else {
              return Card(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        child: Icon(Icons.monetization_on),
                      ),
                    ),
                    Text(
                      _earnedCoupons[index - 1].toString(),
                      textScaleFactor: 1.5,
                    )
                  ],
                ),
              );
            }
          },
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

// ListView(
//             padding: EdgeInsets.all(10.0),
//             children: _earnedCoupons
//                 .map(
//                   (element) => new Card(
//                         child: Row(
//                           children: <Widget>[
//                             Padding(
//                               padding: EdgeInsets.all(10.0),
//                               child: CircleAvatar(
//                                 child: Icon(Icons.monetization_on),
//                               ),
//                             ),
//                             Text(
//                               element.toString(),
//                               textScaleFactor: 1.5,
//                             )
//                           ],
//                         ),
//                       ),
//                 )
//                 .toList())
