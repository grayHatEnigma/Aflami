import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'favorites_screen.dart';
import 'filters_screen.dart';
import '../widgets/favorite_button.dart';
import '../widgets/movie_card.dart';
import '../../blocs/response_bloc.dart';
import '../../blocs/genres_bloc.dart';
import '../../models/response.dart';
import '../../models/genres.dart';

class HomeScreen extends StatelessWidget {
  static final routeName = 'home';

  @override
  Widget build(BuildContext context) {
    /// BLoCs
    final responseBloc = Provider.of<ResponseBloc>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Image.asset(
                'images/aflami.png',
                height: 30,
                width: 30,
              ),
              SizedBox(width: 7),
              Text(
                'Aflami',
                style: Theme.of(context).textTheme.title,
              ),
            ],
          ),
          actions: [
            Center(
              child: FavoriteButton(onTap: () {
                Navigator.pushNamed(context, FavoritesScreen.routeName);
              }),
            ),
            Center(
              child: IconButton(
                icon: const Icon(Icons.movie, size: 31),
                onPressed: () =>
                    Navigator.of(context).pushNamed(FiltersScreen.routeName),
              ),
            )
          ],
        ),
        bottomNavigationBar: PageBottomBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<int>(
                stream: responseBloc.moviesGenre,
                initialData: 0,
                builder: (context, snapshot) {
                  return GenreSummary(genreId: snapshot.data);
                }),
            Expanded(
              child: StreamBuilder(
                stream: responseBloc.allMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridBuilder(response: snapshot);
                  } else if (snapshot.hasError) {
                    return ErrorWidget(snapshot.error.toString());
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ####################### Custome Widgets ########################

/// Build Genre. Summary Bar
class GenreSummary extends StatelessWidget {
  final int genreId;

  const GenreSummary({this.genreId});

  @override
  Widget build(BuildContext context) {
    // BLoCs
    final responseBloc = Provider.of<ResponseBloc>(context);
    final genresBloc = Provider.of<GenresBloc>(context);

    return Container(
      width: double.infinity,
      height: 30.0,
      decoration: BoxDecoration(
        color: Colors.red[900],
      ),
      child: StreamBuilder<Genres>(
          stream: genresBloc.genres,
          initialData: Genres.initialState(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final genresList = snapshot.data;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Genre.  [ ${genresList.findById(genreId)} ]',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(),
                  StreamBuilder<int>(
                    stream: responseBloc.currentIndex,
                    initialData: 1,
                    builder: (context, snapshot) {
                      return Text(
                        'Page  [ ${snapshot.data.toString()} ]',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'No Internet Connection',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return Container();
          }),
    );
  }
}

/*

*/

/// Build Main Grid
class GridBuilder extends StatelessWidget {
  final AsyncSnapshot<ResponseModel> response;
  const GridBuilder({@required this.response});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        final currentEntry = response.data.results[index];
        return MovieCard(movie: currentEntry);
      },
      itemCount: response.data.results.length,
    );
  }
}

/*

*/

/// Build Bottom Navigation Bar
class PageBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // BLoCs
    final responseBloc = Provider.of<ResponseBloc>(context);
    return BottomNavigationBar(
        currentIndex: 1,
        backgroundColor: Colors.black54,
        unselectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) {
          if (index == 0) {
            responseBloc.dispatch(ResponseEvent.previous);
          } else if (index == 1) {
            responseBloc.dispatch(ResponseEvent.home);
          } else if (index == 2) {
            responseBloc.dispatch(ResponseEvent.next);
          }
        },
        items: [
          BottomNavigationBarItem(
            title: Text('Previous'),
            icon: Icon(
              Icons.navigate_before,
              size: 31,
            ),
          ),
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home,
                color: Theme.of(context).primaryColor, size: 31),
          ),
          BottomNavigationBarItem(
            title: Text('Next'),
            icon: Icon(
              Icons.navigate_next,
              size: 31,
            ),
          ),
        ]);
  }
}

/*

*/

/// Build Error Widget
class ErrorWidget extends StatelessWidget {
  final String errorText;

  ErrorWidget(this.errorText);
  @override
  Widget build(BuildContext context) {
    ///BLoCs
    final responseBloc = Provider.of<ResponseBloc>(context);
    final genresBloc = Provider.of<GenresBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Error!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23, color: Theme.of(context).primaryColor),
        ),
        SizedBox(height: 10),
        Text(
          '$errorText',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20),
        RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text('Try Again',
                style: TextStyle(color: Colors.black, fontSize: 18)),
            onPressed: () {
              responseBloc.dispatch(ResponseEvent.retry);
              genresBloc.dispatch(GenresEvent.retry);
            })
      ],
    );
  }
}
