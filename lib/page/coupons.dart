import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:learn/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiService appAuth = new ApiService();

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2018, 11, 16),
        lastDate: DateTime(2018, 11, 25));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: labelText,
            valueText: DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
      ],
    );
  }
}

class CouponsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _CouponsPageState();
  }
}

class _CouponsPageState extends State<CouponsPage> {
  DateTime _fromDate = DateTime(2018, 11, 16, 18, 00);
  TimeOfDay _fromTime = const TimeOfDay(hour: 7, minute: 28);
  DateTime _toDate = DateTime.now();
  TimeOfDay _toTime = const TimeOfDay(hour: 7, minute: 28);
  final List<String> _allActivities = <String>[
    '06 : 30 PM',
    '08 : 00 PM',
    '90 : 30 PM',
  ];
  String _activity = '06 : 30 PM';

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
                              Expanded(
                                child: Text(
                                  element.toString(),
                                  textScaleFactor: 1.3,
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {},
                                    child: Text('Assign'),
                                  )
                                ],
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
                                  backgroundColor: Color.fromARGB(200, 3, 1, 1),
                                  child: Icon(Icons.monetization_on, color: Colors.yellow,),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    element['ticketNo'].toString(),
                                    textScaleFactor: 1.3,
                                  ),
                                  Text(DateFormat.yMd().add_jm().format(
                                      DateTime.parse(element['assignDate']))),
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

  Widget assignDate() {
    return ListView(
      children: <Widget>[
        _DateTimePicker(
          labelText: 'Select Date',
          selectedDate: _fromDate,
          selectedTime: _fromTime,
          selectDate: (DateTime date) {
            setState(() {
              _fromDate = date;
            });
          },
          selectTime: (TimeOfDay time) {
            setState(() {
              _fromTime = time;
            });
          },
        ),
        const SizedBox(height: 8.0),
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Select time:',
            hintText: 'Choose any time',
            contentPadding: EdgeInsets.zero,
          ),
          isEmpty: _activity == null,
          child: DropdownButton<String>(
            value: _activity,
            onChanged: (String newValue) {
              setState(() {
                _activity = newValue;
              });
            },
            items: _allActivities.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
