import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import '../../blocs/response_bloc.dart';
import '../../blocs/genres_bloc.dart';
import '../../models/genres.dart';
import '../../models/genre.dart';

class FiltersScreen extends StatefulWidget {
  static final routeName = 'filters';

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  Genre movieGenre = Genre(28, 'Action');
  @override
  Widget build(BuildContext context) {
    final genresBloc = Provider.of<GenresBloc>(context);
    final responseBloc = Provider.of<ResponseBloc>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Filters'),
      ),
      body: StreamBuilder<Genres>(
          stream: genresBloc.genres,
          initialData: Genres.initialState(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data.genres.length > 0) {
              print(snapshot.hasData);
              print(snapshot.data.genres);
              final List<Genre> genres = snapshot.data.genres;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Choose Movie Genre',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Center(
                      child: Container(
                    height: 250,
                    child: CupertinoPicker(
                      backgroundColor: Theme.of(context).backgroundColor,
                      useMagnifier: true,
                      magnification: 1.3,
                      children: genres
                          .map(
                            (movieGenre) => Text(
                              movieGenre.name,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                          .toList(),
                      onSelectedItemChanged: (item) =>
                          responseBloc.chooseGenre(genres[item].id),
                      itemExtent: 50,
                    ),
                  )),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

/*

StreamBuilder<Genres>(
        stream: genresBloc.genres,
        initialData: Genres.initialState(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: ListView.builder(
                itemBuilder: (context, index) =>
                    Text(snapshot.data.genres[index].name),
                itemCount: snapshot.data.genres.length,
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
*/
