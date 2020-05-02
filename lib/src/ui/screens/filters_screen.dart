import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import '../../blocs/response_bloc.dart';
import '../../blocs/genres_bloc.dart';
import '../../models/genres.dart';
import '../../models/genre.dart';

// FIXME : handle errors here

class FiltersScreen extends StatefulWidget {
  static final routeName = 'filters';

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  /*
   lastIndex here is a trick  to prevents unnecessary calls to the api,
   when the user simply navigates through the picker wheel.
   it will force the picker to only make the api request 
   - only - when the item index stays the same after 1 second delay period.
  */
  int lastIndex;
  Color selectionColor;

  @override
  Widget build(BuildContext context) {
    final genresBloc = Provider.of<GenresBloc>(context);
    final responseBloc = Provider.of<ResponseBloc>(context);

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
              'Choose Movie Genre',
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
                      return CupertinoPicker(
                        backgroundColor: Theme.of(context).backgroundColor,
                        useMagnifier: true,
                        magnification: 1.3,
                        diameterRatio: 2,
                        children:
                            //FIXME : unexpected behaviour of first item alignment
                            genres
                                .map(
                                  (movieGenre) => Text(
                                    movieGenre.name,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                                .toList(),
                        onSelectedItemChanged: (index) {
                          lastIndex = index;
                          Future.delayed(
                            Duration(seconds: 1),
                            () {
                              if (index == lastIndex) {
                                responseBloc.chooseGenre(genres[index].id);
                              }
                            },
                          );
                        },
                        itemExtent: 50,
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
