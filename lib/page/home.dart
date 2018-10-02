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
    return new _BackdropPageState();
  }
}

class _BackdropPageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static const _PANEL_HEADER_HEIGHT = 32.0;
  AnimationController _controller;

  int _earnedCoupons;
  int _usedCoupons;

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - _PANEL_HEADER_HEIGHT;
    final double bottom = -_PANEL_HEADER_HEIGHT;
    return new RelativeRectTween(
      begin: new RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(new CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

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

  _BackdropPageState() {
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
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 100), value: 1.0, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          title: new Text("Lucky Draw"),
          leading: new IconButton(
            onPressed: () {
              _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
            },
            icon: new AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              progress: _controller.view,
            ),
          ),
        ),
        body: new LayoutBuilder(
          builder: _buildStack,
        ));
  }

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    final ThemeData theme = Theme.of(context);
    return new Container(
      color: theme.primaryColor,
      child: new Stack(
        children: <Widget>[
          new Center(
            child: new Text("base"),
          ),
          new PositionedTransition(
            rect: animation,
            child: new Material(
              borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(16.0),
                  topRight: const Radius.circular(16.0)),
              elevation: 12.0,
              child: new Column(children: <Widget>[
                new Expanded(
                  child: WillPopScope(
                    onWillPop: _onWillPop,
                    child: ListView(
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
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 0.0, 10.0, 0.0),
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
                                  Text(
                                    'Your Coupons Details:',
                                    textScaleFactor: 1.2,
                                  ),
                                  SizedBox(height: 30.0),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text('Used Coupons :'),
                                      ),
                                      Text(_usedCoupons != null
                                          ? _usedCoupons.toString()
                                          : '0')
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text('Unused Coupons :'),
                                      ),
                                      Text(_earnedCoupons != null
                                          ? _earnedCoupons.toString()
                                          : '0')
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          'Total Coupons :',
                                          textScaleFactor: 1.1,
                                        ),
                                      ),
                                      Text(
                                        _usedCoupons != null
                                            ? (_earnedCoupons + _usedCoupons)
                                                .toString()
                                            : '0',
                                        textScaleFactor: 1.1,
                                      )
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
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// class _HomePageState extends State<HomePage> {
//   int _earnedCoupons;
//   int _usedCoupons;

//   Future<bool> _onWillPop() {
//     return showDialog(
//           context: context,
//           builder: (context) => new AlertDialog(
//                 title: new Text('Are you sure?'),
//                 content: new Text('Do you want to exit an App'),
//                 actions: <Widget>[
//                   new FlatButton(
//                     onPressed: () => Navigator.of(context).pop(false),
//                     child: new Text('No'),
//                   ),
//                   new FlatButton(
//                     textColor: Colors.red,
//                     onPressed: () => Navigator.of(context).pop(true),
//                     child: new Text('Yes'),
//                   ),
//                 ],
//               ),
//         ) ??
//         false;
//   }

//   _HomePageState() {
//     SharedPreferences.getInstance().then((onValue) {
//       Map<String, dynamic> userData =
//           json.decode(onValue.getString('userData'));
//       print(userData);
//       var data = {"contactNumber": userData['contactNumber']};
//       appAuth.getUserTickets(json.encode(data)).then((res) {
//         if (res.statusCode == 200) {
//           setState(() {
//             print(res.body);
//             _earnedCoupons = json.decode(res.body)['earnedTickets'].length;
//             _usedCoupons = json.decode(res.body)['ticketMapping'].length;
//           });
//         } else {
//           print('Error Not connect to get user tickets');
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return
//   }
// }
