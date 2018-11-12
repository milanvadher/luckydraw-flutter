import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luckydraw/service/api_service.dart';

ApiService appAuth = new ApiService();
List _winners;

class WinnerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _WinnerPageState();
  }
}

class _WinnerPageState extends State<WinnerPage> {
  _WinnerPageState() {
    appAuth.getWinnerList().then((res) {
      if (res.statusCode == 200) {
        setState(() {
          _winners = json.decode(res.body)['result'];
        });
      } else {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Winner List'),
      ),
      body: _winners == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : new ListView(
              children: _winners
                  .map(
                    (element) => Column(
                          children: <Widget>[
                            new Divider(),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                DateFormat.yMMMd().add_jm().format(
                                    DateTime.parse(element['date']).add(
                                        new Duration(hours: 5, minutes: 30))),
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                            new Divider(),
                            element['winner'].length != 0
                                ? Column(
                                    children: element['winner']
                                        .map<Widget>(
                                          (item) => ListTile(
                                                leading: CircleAvatar(
                                                  child: Text(
                                                      item['prize'].toString()),
                                                ),
                                                title:
                                                    Text(item['contactNumber']),
                                                subtitle: Text(
                                                    item['ticket'].toString()),
                                              ),
                                        )
                                        .toList(),
                                  )
                                : new Text('Will be announced soon ...')
                          ],
                        ),
                  )
                  .toList(),
            ),
    );
  }
}
