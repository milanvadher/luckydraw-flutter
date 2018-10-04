import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _TutorialPageState();
  }
}

class _TutorialPageState extends State<TutorialPage> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Jay Sachchidanand",
        description:
            "Welcome to Lucky Draw Game.\n Here you can win Lucky draw Coupons\n and win exiting Prizes.",
        pathImage: "assets/logo.png",
        widthImage: 250.0,
        heightImage: 300.0,
        backgroundColor: 0xff203152,
      ),
    );
    slides.add(
      new Slide(
        title: "Earn Lucky Draw Coupon",
        description: "Guess the Correct word \n and Earn Lucky Draw Coupon.",
        pathImage: "assets/slider.png",
        widthImage: 250.0,
        heightImage: 300.0,
        backgroundColor: 0xfff5a623,
      ),
    );
    slides.add(
      new Slide(
        title: "WIN AMAZING PRIZES",
        description:
            "Use your earned coupons at JJ-111\n and win Amazing Prizes.",
        pathImage: "assets/slider2.png",
        widthImage: 250.0,
        heightImage: 300.0,
        backgroundColor: 0xFF135A60,
      ),
    );
  }

  void onDonePress() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isIntroSeen', true);
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onDonePress,
    );
  }
}
