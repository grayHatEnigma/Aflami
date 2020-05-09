import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'poster.dart';
import '../screens/detail_screen.dart';
import '../../blocs/trailer_bloc.dart';
import '../../blocs/favorites_bloc.dart';
import '../../models/movie.dart';

class FavoriteItem extends StatelessWidget {
  final Movie movie;

  FavoriteItem({
    @required this.movie,
  });

// a function that handles the navigation code and disposing the trailer bloc
  void _navigateToDetail(BuildContext context, Widget poster) {
    final trailerBloc = TrailerBloc();
    trailerBloc.findTrailers(movie.id);
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => Provider.value(
              value: trailerBloc,
              child: DetailScreen(),
            ),
            settings: RouteSettings(arguments: [movie, poster]),
          ),
        )
        .then((_) => trailerBloc.dispose);
  }

  @override
  Widget build(BuildContext context) {
    final favoritesBloc = Provider.of<FavoritesBloc>(context);
    // cache the poster
    final poster = Poster(movie);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () => _navigateToDetail(context, poster),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: poster,
                height: 150,
                width: 105,
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
                icon: Icon(Icons.close, color: Theme.of(context).primaryColor),
                onPressed: () {
                  favoritesBloc.inRemoveFavorite(movie);
                },
              ),
            ]),
      ),
    );
  }
}
