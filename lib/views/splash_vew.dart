import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:movie_hive/views/home_page.dart';
import 'package:movie_hive/widgets/glass_morphishm.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          "assets/images/splash.jpg",
          fit: BoxFit.cover,
        ),
      ),
      Container(
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
            color: Colors.white,
            // ignore: prefer_const_constructors
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                // ignore: prefer_const_literals_to_create_immutables
                colors: [
                  Colors.black,
                ],
                stops: const [
                  0.0,
                  1.0
                ])),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: GlassMorphism(
              start: 0.2,
              end: 0.3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .95,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(width: 20.0, height: 100.0),
                          DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 60.0,
                              fontFamily: 'Horizon',
                            ),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                RotateAnimatedText('AWESOME'),
                                RotateAnimatedText('OPTIMISTIC'),
                                RotateAnimatedText('DIFFERENT'),
                              ],
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
      )
    ]);
  }

  startTimer() async {
    var duration = Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MovieHomePageView()),
      (Route<dynamic> route) => false,
    );
  }
}
