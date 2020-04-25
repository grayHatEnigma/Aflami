import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import '../blocs/response_bloc.dart';
import '../blocs/favorites_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => ResponseBloc(),
          dispose: (context, responseBloc) => responseBloc.dispose(),
        ),
        Provider(
          create: (context) => FavoritesBloc(),
          dispose: (context, favoritesBloc) => favoritesBloc.dispose(),
        ),
      ],
      child: MaterialApp(
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
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
        },
        initialRoute: HomeScreen.routeName,
      ),
    );
  }
}
