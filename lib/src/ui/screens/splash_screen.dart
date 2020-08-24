import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  static final routeName = 'splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  final duration = const Duration(milliseconds: 3500);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: duration);
    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(controller);

    controller.forward();

    controller.addListener(() {
      if (controller.isCompleted) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(),
              Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 40,
                    child: Image.asset(
                      'images/aflami.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Aflami',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white, fontSize: 27),
                  ),
                ],
              ),
              Text(
                'Explore the movie world!',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w300,
                    fontSize: 23),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
