import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/navigation_screen.dart';
import '../blocs/genres_bloc.dart';
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
        Provider(
          create: (contex) => GenresBloc(),
          dispose: (context, genresBloc) => genresBloc.dispose(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.amber,
          backgroundColor: Colors.black,
          canvasColor: Colors.grey,
          textTheme: TextTheme(
            title: TextStyle(
                color: Colors.black,
                fontFamily: 'Raleway',
                fontSize: 23,
                fontWeight: FontWeight.bold),
            body1: TextStyle(color: Colors.white, fontSize: 21),
          ),
        ),
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          SplashScreen.routeName: (context) => SplashScreen(),
          FavoritesScreen.routeName: (context) => FavoritesScreen(),
          FiltersScreen.routeName: (context) => FiltersScreen(),
          NavigationScreen.routeName: (context) => NavigationScreen(),
        },
        initialRoute: SplashScreen.routeName,
      ),
    );
  }
}
