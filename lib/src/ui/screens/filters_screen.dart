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
  //
  int currentGenreId;
  int newGenreId;
  //
  @override
  Widget build(BuildContext context) {
    // BLoCs
    final genresBloc = Provider.of<GenresBloc>(context);
    final responseBloc = Provider.of<ResponseBloc>(context);

    //
    currentGenreId = responseBloc.currentGenreId;
    //
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Filters', style: Theme.of(context).textTheme.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Select Movie Genre',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500),
            ),
            Container(
              height: 250,
              child: StreamBuilder<Genres>(
                  stream: genresBloc.genres,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final List<Genre> genres = snapshot.data.genres;
                      final currentGenre = genres
                          .firstWhere((genre) => genre.id == currentGenreId);
                      return CupertinoPicker(
                        backgroundColor: Theme.of(context).backgroundColor,
                        scrollController: FixedExtentScrollController(
                          initialItem: genres.indexOf(currentGenre),
                        ),
                        useMagnifier: true,
                        magnification: 1.3,
                        diameterRatio: 1,
                        children: genres
                            .map(
                              (movieGenre) => Text(
                                movieGenre.name,
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                            .toList(),
                        onSelectedItemChanged: (index) {
                          newGenreId = genres[index].id;
                        },
                        itemExtent: 50,
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: loading genres list'),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                if (newGenreId != currentGenreId && newGenreId != null) {
                  responseBloc.chooseGenre(newGenreId);
                }
                Navigator.pop(context);
              },
              child: Text('Select',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      letterSpacing: 0.75)),
            )
          ],
        ),
      ),
    );
  }
}
