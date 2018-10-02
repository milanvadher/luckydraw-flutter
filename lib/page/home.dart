import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:learn/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

ApiService appAuth = new ApiService();

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _BackdropPageState();
  }
}

class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(url, forceWebView: true);
              });
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
          new Card(
            color: Colors.orangeAccent,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          _actionChoise('Coupons');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.monetization_on),
                              SizedBox(width: 10.0),
                              Text(
                                'Coupons',
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.2,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      RaisedButton(
                        onPressed: () {
                          _actionChoise('Winners');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.flag),
                              SizedBox(width: 10.0),
                              Text(
                                'Winners',
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.2,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      RaisedButton(
                        onPressed: () {
                          _actionChoise('Profile');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.person),
                              SizedBox(width: 10.0),
                              Text(
                                'Profile',
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.2,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      RaisedButton(
                        onPressed: () {
                          _actionChoise('About us');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.details),
                              SizedBox(width: 10.0),
                              Text(
                                'About us',
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.2,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      RaisedButton(
                        onPressed: () {
                          _actionChoise('Share');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.share),
                              SizedBox(width: 10.0),
                              Text(
                                'Share',
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.2,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      RaisedButton(
                        onPressed: () {
                          _actionChoise('Logout');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.exit_to_app),
                              SizedBox(width: 10.0),
                              Text(
                                'Logout',
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.2,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                    ],
                  ),
                )
              ],
            ),
          ),
          new PositionedTransition(
            rect: animation,
            child: new Material(
              borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0)),
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

  void _actionChoise(choise) {
    if (choise == 'Coupons') {
      Navigator.pushNamed(context, '/coupons');
    }
    if (choise == 'Winners') {
      Navigator.pushNamed(context, '/winners');
    }
    if (choise == 'Profile') {
      Navigator.pushNamed(context, '/profile');
    }
    if (choise == 'About us') {
      _aboutDialog(context);
    }
    if (choise == 'Share') {
      _shareApp();
    }
    if (choise == 'Logout') {
      _logOut();
    }
  }

  void _logOut() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((onValue) {
      onValue.remove('userData');
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  void _aboutDialog(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.body2;
    final TextStyle linkStyle =
        themeData.textTheme.body2.copyWith(color: themeData.accentColor);

    return showAboutDialog(
      context: context,
      applicationName: 'Lucky Draw',
      applicationVersion: 'Win coupons for JJ-111',
      applicationIcon: Image.asset(
        'assets/logo.png',
        height: 50.0,
      ),
      applicationLegalese: '© 2018 GNC Bhaio.',
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    style: aboutTextStyle,
                    text:
                        'Dadashri\'s JanmaJayanti Celebrations are happening from 15th Nov to 25th November 2018 @ Adalaj Trimandir. To know more about our event visit '),
                _LinkTextSpan(
                  style: linkStyle,
                  url: 'http://jjd.dadabhagwan.org/',
                  // text: 'Jova Jevi Duniya.'
                ),
                TextSpan(
                  style: aboutTextStyle,
                  text:
                      '\n\nThere will be 3 Lucky Draws everyday during this period.',
                ),
                TextSpan(
                  style: aboutTextStyle,
                  text:
                      '\nWin Lucky Draw Coupons by answering the puzzles. Once you win the coupons, assign them to the draws.',
                ),
                TextSpan(
                  style: aboutTextStyle,
                  text:
                      '\nAll the best to you\'ll. May the best Puzzelier win.',
                ),
                TextSpan(
                  style: aboutTextStyle,
                  text: '\n\nRegards,\nLucky Draw Team',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _shareApp() {
    String messege =
        'Congratulations ! Today is your LUCKY DAY, Go check out this Amazing App and WIN Lucky Draw Coupon and WIN prices in JJ-111 ! https://goo.gl/XTjjnn';
    final RenderBox box = context.findRenderObject();
    Share.share(messege,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
