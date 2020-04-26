import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'detail_screen.dart';
import '../widgets/favorite_button.dart';
import '../../models/movie.dart';
import '../../blocs/favorites_bloc.dart';
import '../../blocs/movie_detail_bloc.dart';
import '../../blocs/trailer_bloc.dart';
import '../../resources/tmdb_api.dart';

class FavoritesScreen extends StatelessWidget {
  static final routeName = 'favorites';
  @override
  Widget build(BuildContext context) {
    final favoritesBloc = Provider.of<FavoritesBloc>(context);
    final movieDetailBloc = Provider.of<MovieDetailBloc>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            'AFLAMY',
            style: Theme.of(context).textTheme.title,
          ),
          actions: [
            FavoriteButton(onTap: null),
          ],
        ),
        body: StreamBuilder<List<int>>(
            stream: favoritesBloc.outFavorites,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                movieDetailBloc.fetchMovies(snapshot.data);
                return StreamBuilder<List<Movie>>(
                    stream: movieDetailBloc.movies,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return FavoriteItem(snapshot.data[index]);
                          },
                          itemCount: snapshot.data.length,
                        );
                      } else
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Loading ...'),
                              SizedBox(height: 10),
                              CircularProgressIndicator(),
                            ],
                          ),
                        );
                    });
              } else
                return Container();
            }),
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  final Movie movie;

  const FavoriteItem(this.movie);

  // a function that handles the navigation code and disposing the bloc
  void _navigateToDetail(BuildContext context) {
    final trailerBloc = TrailerBloc();
    trailerBloc.findTrailers(movie.id);
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => Provider.value(
              value: trailerBloc,
              child: DetailScreen(),
            ),
            settings: RouteSettings(arguments: movie),
          ),
        )
        .then((_) => trailerBloc.dispose);
  }

  @override
  Widget build(BuildContext context) {
    final favoritesBloc = Provider.of<FavoritesBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () => _navigateToDetail(context),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                '${TmdbApi.movieImagePath}${movie.posterPath}',
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
                scale: 2,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 200,
                    child: Text(
                      movie.title,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        color: Theme.of(context).primaryColor,
                        size: 17,
                      ),
                      SizedBox(width: 3),
                      Text(
                        movie.voteAverage.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.remove, color: Theme.of(context).primaryColor),
                onPressed: () => favoritesBloc.inRemoveFavorite(movie.id),
              )
            ]),
      ),
    );
  }
}
