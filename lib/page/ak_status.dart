import 'dart:convert';
import 'package:luckydraw/page/ak_game.dart';
import 'package:luckydraw/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiService appAuth = new ApiService();

var _resultStats;

class AkStatusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AkStatusPage();
  }
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class _AkStatusPage extends State<AkStatusPage> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _initData();
  }

  _initData() {
    SharedPreferences.getInstance().then((onValue) {
      Map<String, dynamic> userData =
          json.decode(onValue.getString('userData'));
      print(userData);
      var data = {"contactNumber": userData['contactNumber']};
      appAuth.getAKUserState(json.encode(data)).then((res) {
        if (res.statusCode == 200) {
          print('AKGAMESTATUS');
          print(res.body);
          setState(() {
            _resultStats = json.decode(res.body)['result_stats'];
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Akram Youth Game'),
      ),
      body: _resultStats != null
          ? _cardGridView()
          : new Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _cardGridView() {
    return GridView.count(
      childAspectRatio: (2 / 1),
      shrinkWrap: true,
      crossAxisCount: 2,
      children: List.generate(_resultStats.length, (index) {
        return new GestureDetector(
          onTap: () {
            _getQuestionState(_resultStats[index]['ak_ques_st']);
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Card(
              color: Theme.of(context).primaryColor,
              margin: EdgeInsets.all(10.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _resultStats != null && _resultStats[index] != null
                          ? _resultStats[index]['ak_ques_st'].toString()
                          : "",
                      textScaleFactor: 2.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      _resultStats != null && _resultStats[index] != null
                          ? _resultStats[index]['answered'].toString() +
                              '/' +
                              _resultStats[index]['total'].toString()
                          : "",
                      textScaleFactor: 1.5,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _getQuestionState(qst) {
    print(qst.runtimeType);
    if (qst.runtimeType != int) {
      qst = int.parse(qst);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AkGamePage(questionState: qst)));
  }
}
