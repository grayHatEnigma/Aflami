import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import '../blocs/response_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber,
        backgroundColor: Colors.black,
        textTheme: TextTheme(
          title: TextStyle(
              color: Colors.black, fontFamily: 'Action', fontSize: 25),
          body1: TextStyle(color: Colors.white, fontSize: 21),
        ),
      ),
      home: Provider(
        child: HomeScreen(),
        create: (context) => ResponseBloc(),
        dispose: (context, responseBloc) => responseBloc.dispose(),
      ),
    );
  }
}
