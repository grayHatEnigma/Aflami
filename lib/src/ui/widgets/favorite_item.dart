import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../screens/detail_screen.dart';
import '../../blocs/trailer_bloc.dart';
import '../../blocs/favorites_bloc.dart';
import '../../resources/tmdb_api.dart';
import '../../models/movie.dart';

class FavoriteItem extends StatelessWidget {
  final Movie movie;

  FavoriteItem({
    @required this.movie,
  });

// a function that handles the navigation code and disposing the bloc
  void _navigateToDetail(BuildContext context, Image poster) {
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

  Image _cachePoster() {
    return Image.network(
      '${TmdbApi.coverImagePath}${movie.posterPath}',
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
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritesBloc = Provider.of<FavoritesBloc>(context);
    final poster = _cachePoster();

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () => _navigateToDetail(context, poster),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: poster.image,
                height: 150,
                width: 110,
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
              )
            ]),
      ),
    );
  }
}
