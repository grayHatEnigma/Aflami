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
  /*
   lastIndex here is a trick  to prevents unnecessary calls to the api,
   when the user simply navigates through the picker wheel.
   it will force the picker to only make the api request 
   - only - when the item index stays the same after 1 second delay period.
  */
  int lastIndex;

  @override
  Widget build(BuildContext context) {
    // BLoCs
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
                      return CupertinoPicker(
                        backgroundColor: Theme.of(context).backgroundColor,
                        useMagnifier: true,
                        magnification: 1.3,
                        diameterRatio: 2,
                        children: genres
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
            IconButton(
              tooltip: 'Select',
              color: Theme.of(context).primaryColor,
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.subdirectory_arrow_right, size: 40),
            ),
            SizedBox(
              height: 5,
            ),
            Text('Select',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16))
          ],
        ),
      ),
    );
  }
}