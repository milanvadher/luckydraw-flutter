import 'package:flutter/material.dart';

class AkStatus extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AkStatusState();
  }
}

class _AkStatusState extends State<AkStatus> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('AY Game'),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Container(
              padding: new EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/logo.png',
                    height: 200.0,
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Card(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: new EdgeInsets.all(10.0),
                                child: Text(
                                  'data 1',
                                ),
                              ),
                            Icon(Icons.done),
                          ],
                        )),
                      ),
                      Expanded(
                        child: Card(
                          child: Center(
                            child: Padding(
                              padding: new EdgeInsets.all(10.0),
                              child: Text('data 2'),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
