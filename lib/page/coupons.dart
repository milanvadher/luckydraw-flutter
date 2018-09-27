import 'package:flutter/material.dart';

class CouponsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _CouponsPageState();
  }
}

class _CouponsPageState extends State<CouponsPage> {
  List<int> _coupons = [1002, 1003, 1004, 1005];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Coupons'),
      ),
      body: ListView(
          padding: EdgeInsets.all(10.0),
          children: _coupons
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
                            textScaleFactor: 1.5,
                          )
                        ],
                      ),
                    ),
              )
              .toList()),
    );
  }
}
